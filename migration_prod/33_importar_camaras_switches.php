<?php
/**
 * 33_importar_camaras_switches.php  —  PARTE B (importador)
 *
 * Lee dos CSV:
 *   - migration_prod/data/switches_template.csv  -> crea NetworkEquipment + puertos
 *   - migration_prod/data/camaras_template.csv   -> crea Peripheral + puerto + conexión al puerto del switch
 *
 * Idempotente: si un equipo ya existe (por name + entity), lo reutiliza.
 *
 * Crea para cada switch N puertos Ethernet ("Port 1", "Port 2"...).
 * Crea para cada cámara 1 puerto Ethernet con su MAC + NetworkName + IPAddress.
 * Crea la fila glpi_networkports_networkports cama_port <-> switch_port.
 *
 * Para probar antes de tocar nada real:
 *   php 33_importar_camaras_switches.php --dry-run
 * Para ejecutar:
 *   php 33_importar_camaras_switches.php
 */

$DRY = in_array('--dry-run', $argv, true);
$BASE = __DIR__ . '/data';

$pdo = new PDO(
    "mysql:host=20.121.178.90;dbname=TICKETS_DB;charset=utf8mb4",
    "root", "Root",
    [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
     PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4"]
);

echo "MODO: " . ($DRY ? "DRY-RUN (no escribe nada)" : "REAL (escribe en BD)") . "\n\n";

// ---------- Helpers ----------
function readCsv(string $file): array {
    if (!is_file($file)) {
        throw new RuntimeException("No existe: $file");
    }
    $rows = [];
    if (($h = fopen($file, 'r')) === false) throw new RuntimeException("No se pudo abrir: $file");
    $headers = fgetcsv($h);
    while (($row = fgetcsv($h)) !== false) {
        if (count(array_filter($row, fn($v) => trim((string)$v) !== '')) === 0) continue;
        $rows[] = array_combine($headers, array_pad($row, count($headers), ''));
    }
    fclose($h);
    return $rows;
}

function findId(PDO $pdo, string $tabla, string $col, string $val, array $extra = []): ?int {
    $where = ["`$col` = :v"];
    $params = [':v' => $val];
    foreach ($extra as $k => $v) {
        $where[] = "`$k` = :$k";
        $params[":$k"] = $v;
    }
    $sql = "SELECT id FROM `$tabla` WHERE " . implode(' AND ', $where) . " LIMIT 1";
    $st = $pdo->prepare($sql);
    $st->execute($params);
    $id = $st->fetchColumn();
    return $id ? (int)$id : null;
}

function ensureSimple(PDO $pdo, string $tabla, string $name): int {
    $id = findId($pdo, $tabla, 'name', $name);
    if ($id) return $id;
    $st = $pdo->prepare("INSERT INTO `$tabla` (name, date_creation, date_mod) VALUES (:n, NOW(), NOW())");
    $st->execute([':n' => $name]);
    return (int)$pdo->lastInsertId();
}

/** Crea/obtiene una ubicación (location) dentro de una entidad */
function ensureLocation(PDO $pdo, string $name, int $entityId): ?int {
    if ($name === '') return null;
    $id = findId($pdo, 'glpi_locations', 'name', $name, ['entities_id' => $entityId]);
    if ($id) return $id;
    $st = $pdo->prepare(
        "INSERT INTO glpi_locations (name, entities_id, is_recursive, date_creation, date_mod, completename, level)
         VALUES (:n, :e, 0, NOW(), NOW(), :n, 1)"
    );
    $st->execute([':n' => $name, ':e' => $entityId]);
    return (int)$pdo->lastInsertId();
}

function ensureManufacturer(PDO $pdo, string $name): ?int {
    if ($name === '') return null;
    return ensureSimple($pdo, 'glpi_manufacturers', $name);
}

function ensureModel(PDO $pdo, string $tabla, string $name): ?int {
    // Los modelos en GLPI son globales (no llevan manufacturers_id).
    // El fabricante se asigna directo en el equipo.
    if ($name === '') return null;
    $id = findId($pdo, $tabla, 'name', $name);
    if ($id) return $id;
    $st = $pdo->prepare(
        "INSERT INTO `$tabla` (name, date_creation, date_mod) VALUES (:n, NOW(), NOW())"
    );
    $st->execute([':n' => $name]);
    return (int)$pdo->lastInsertId();
}

function ipv4ToBinary(string $ip): array {
    if (!filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4)) return [0,0,0,0];
    $long = sprintf('%u', ip2long($ip));
    return [0, 0, 0xffff, (int)$long];
}

// ---------- Resolver entidad ----------
function resolveEntity(PDO $pdo, string $name): int {
    $st = $pdo->prepare("SELECT id FROM glpi_entities WHERE name = :n LIMIT 1");
    $st->execute([':n' => $name]);
    $id = $st->fetchColumn();
    if ($id === false) {
        throw new RuntimeException("Entidad no encontrada: '$name'. Crea la entidad primero o corrige el nombre.");
    }
    return (int)$id;
}

// ============================================================
// 1) IMPORTAR SWITCHES
// ============================================================
echo "==================== SWITCHES ====================\n";
$switches = readCsv("$BASE/switches_template.csv");
$switchIndex = []; // name -> ['id'=>int, 'entity'=>int, 'puertos'=> [num=>networkport_id]]

if (!$DRY) $pdo->beginTransaction();

foreach ($switches as $i => $r) {
    $name   = trim($r['name']);
    if ($name === '') continue;
    $entityName = trim($r['entidad']);
    $entityId   = resolveEntity($pdo, $entityName);
    $manuId     = ensureManufacturer($pdo, trim($r['marca']));
    $modelId    = ensureModel($pdo, 'glpi_networkequipmentmodels', trim($r['modelo']));
    $typeId     = trim($r['tipo']) !== ''
        ? findId($pdo, 'glpi_networkequipmenttypes', 'name', trim($r['tipo']))
        : null;
    $locationId = ensureLocation($pdo, trim($r['ubicacion']), $entityId);
    $numPorts   = max(1, (int)$r['puertos_totales']);

    // ¿existe ya?
    $st = $pdo->prepare("SELECT id FROM glpi_networkequipments WHERE name = :n AND entities_id = :e LIMIT 1");
    $st->execute([':n' => $name, ':e' => $entityId]);
    $netEqId = $st->fetchColumn();

    if (!$netEqId) {
        if ($DRY) {
            echo "  [DRY +SW] $name  (entidad=$entityName, puertos=$numPorts)\n";
            $switchIndex[$name] = ['id' => -($i+1), 'entity' => $entityId, 'puertos' => []];
            continue;
        }
        $st = $pdo->prepare(
            "INSERT INTO glpi_networkequipments
                (name, entities_id, is_recursive, manufacturers_id, networkequipmentmodels_id,
                 networkequipmenttypes_id, locations_id, serial, ram, comment,
                 date_creation, date_mod, is_template, is_deleted)
             VALUES (:n,:e,0,:m,:mo,:ty,:lo,:se,:url,:c,NOW(),NOW(),0,0)"
        );
        $st->execute([
            ':n'  => $name,
            ':e'  => $entityId,
            ':m'  => $manuId,
            ':mo' => $modelId,
            ':ty' => $typeId,
            ':lo' => $locationId,
            ':se' => trim($r['numero_serie']),
            ':url'=> trim($r['gestion_url']),
            ':c'  => trim($r['comentario']),
        ]);
        $netEqId = (int)$pdo->lastInsertId();
        echo "  [+SW] $name  (id=$netEqId, entidad=$entityName)\n";
    } else {
        $netEqId = (int)$netEqId;
        echo "  [=SW] $name  (id=$netEqId) ya existía\n";
    }

    // Asegurar N puertos
    $puertos = [];
    for ($p = 1; $p <= $numPorts; $p++) {
        $portName = "Port $p";
        $st = $pdo->prepare(
            "SELECT id FROM glpi_networkports
              WHERE itemtype='NetworkEquipment' AND items_id=:i AND name=:n LIMIT 1"
        );
        $st->execute([':i' => $netEqId, ':n' => $portName]);
        $portId = $st->fetchColumn();
        if (!$portId) {
            if ($DRY) { $puertos[$p] = -$p; continue; }
            $st2 = $pdo->prepare(
                "INSERT INTO glpi_networkports
                    (itemtype, items_id, entities_id, is_recursive, logical_number, name,
                     instantiation_type, date_creation, date_mod)
                 VALUES ('NetworkEquipment',:i,:e,0,:ln,:n,'NetworkPortEthernet',NOW(),NOW())"
            );
            $st2->execute([':i'=>$netEqId, ':e'=>$entityId, ':ln'=>$p, ':n'=>$portName]);
            $portId = (int)$pdo->lastInsertId();
            // Instancia Ethernet
            $pdo->prepare("INSERT INTO glpi_networkportethernets (networkports_id) VALUES (:p)")
                ->execute([':p' => $portId]);
        } else {
            $portId = (int)$portId;
        }
        $puertos[$p] = $portId;
    }
    $switchIndex[$name] = ['id' => $netEqId, 'entity' => $entityId, 'puertos' => $puertos];
}

// ============================================================
// 2) IMPORTAR CÁMARAS / NVR / DVR
// ============================================================
echo "\n==================== CAMARAS / GRABADORES ====================\n";
$camaras = readCsv("$BASE/camaras_template.csv");
$creadas = 0; $conectadas = 0; $errores = 0;

foreach ($camaras as $r) {
    $name = trim($r['name']);
    if ($name === '') continue;
    try {
        $entityName = trim($r['entidad']);
        $entityId   = resolveEntity($pdo, $entityName);
        $manuId     = ensureManufacturer($pdo, trim($r['marca']));
        $modelId    = ensureModel($pdo, 'glpi_peripheralmodels', trim($r['modelo']));
        $typeId     = findId($pdo, 'glpi_peripheraltypes', 'name', trim($r['tipo']));
        if (!$typeId) {
            throw new RuntimeException("Tipo '{$r['tipo']}' no existe (corre 32_apply.php)");
        }
        $locationId = ensureLocation($pdo, trim($r['ubicacion_fisica']), $entityId);

        // ¿existe el periférico?
        $st = $pdo->prepare("SELECT id FROM glpi_peripherals WHERE name=:n AND entities_id=:e LIMIT 1");
        $st->execute([':n' => $name, ':e' => $entityId]);
        $pid = $st->fetchColumn();

        if (!$pid) {
            if ($DRY) {
                echo "  [DRY +CAM] $name  ({$r['tipo']}, entidad=$entityName)\n";
                $creadas++; continue;
            }
            $st = $pdo->prepare(
                "INSERT INTO glpi_peripherals
                    (name, entities_id, is_recursive, peripheraltypes_id, peripheralmodels_id,
                     manufacturers_id, locations_id, serial, contact, comment,
                     date_creation, date_mod, is_template, is_deleted)
                 VALUES (:n,:e,0,:ty,:mo,:ma,:lo,:se,:url,:c,NOW(),NOW(),0,0)"
            );
            $st->execute([
                ':n'=>$name, ':e'=>$entityId, ':ty'=>$typeId, ':mo'=>$modelId, ':ma'=>$manuId,
                ':lo'=>$locationId, ':se'=>trim($r['numero_serie']),
                ':url'=>trim($r['gestion_url']),
                ':c'=> trim(($r['comentario'] ?? '') . ($r['resolucion'] ? " | Resolucion: " . $r['resolucion'] : "")),
            ]);
            $pid = (int)$pdo->lastInsertId();
            echo "  [+CAM] $name  (id=$pid)\n";
            $creadas++;
        } else {
            $pid = (int)$pid; echo "  [=CAM] $name  (id=$pid) ya existía\n";
        }

        // ---- Puerto de la cámara
        $mac = strtolower(trim($r['mac']));
        $ip  = trim($r['ip']);
        $portName = 'eth0';
        $st = $pdo->prepare("SELECT id FROM glpi_networkports
                              WHERE itemtype='Peripheral' AND items_id=:i AND name=:n LIMIT 1");
        $st->execute([':i'=>$pid, ':n'=>$portName]);
        $camPortId = $st->fetchColumn();
        if (!$camPortId) {
            if (!$DRY) {
                $st2 = $pdo->prepare(
                    "INSERT INTO glpi_networkports
                        (itemtype, items_id, entities_id, is_recursive, logical_number, name,
                         instantiation_type, mac, date_creation, date_mod)
                     VALUES ('Peripheral',:i,:e,0,1,:n,'NetworkPortEthernet',:mac,NOW(),NOW())"
                );
                $st2->execute([':i'=>$pid, ':e'=>$entityId, ':n'=>$portName, ':mac'=>$mac]);
                $camPortId = (int)$pdo->lastInsertId();
                $pdo->prepare("INSERT INTO glpi_networkportethernets (networkports_id) VALUES (:p)")
                    ->execute([':p' => $camPortId]);
            } else { $camPortId = -1; }
        } else { $camPortId = (int)$camPortId; }

        // ---- IP en el puerto (NetworkName + IPAddress)
        if ($ip !== '' && !$DRY) {
            $st = $pdo->prepare("SELECT id FROM glpi_networknames
                                  WHERE itemtype='NetworkPort' AND items_id=:p LIMIT 1");
            $st->execute([':p'=>$camPortId]);
            $nnId = $st->fetchColumn();
            if (!$nnId) {
                $st2 = $pdo->prepare(
                    "INSERT INTO glpi_networknames (entities_id, is_recursive, name, itemtype, items_id, date_creation, date_mod)
                     VALUES (:e,0,:n,'NetworkPort',:p,NOW(),NOW())"
                );
                $st2->execute([':e'=>$entityId, ':n'=>$name, ':p'=>$camPortId]);
                $nnId = (int)$pdo->lastInsertId();
            }
            $stIp = $pdo->prepare("SELECT id FROM glpi_ipaddresses
                                    WHERE itemtype='NetworkName' AND items_id=:n AND name=:ip LIMIT 1");
            $stIp->execute([':n'=>$nnId, ':ip'=>$ip]);
            if (!$stIp->fetchColumn()) {
                [$b0,$b1,$b2,$b3] = ipv4ToBinary($ip);
                $stI2 = $pdo->prepare(
                    "INSERT INTO glpi_ipaddresses
                        (entities_id, itemtype, items_id, version, name,
                         binary_0, binary_1, binary_2, binary_3, date_creation, date_mod, is_recursive)
                     VALUES (:e,'NetworkName',:n,4,:ip,:b0,:b1,:b2,:b3,NOW(),NOW(),0)"
                );
                $stI2->execute([
                    ':e'=>$entityId, ':n'=>$nnId, ':ip'=>$ip,
                    ':b0'=>$b0, ':b1'=>$b1, ':b2'=>$b2, ':b3'=>$b3,
                ]);
            }
        }

        // ---- Conexión al puerto del switch
        $swName = trim($r['switch_name']);
        $swPortNum = (int)$r['switch_port'];
        if ($swName && $swPortNum > 0) {
            if (!isset($switchIndex[$swName])) {
                throw new RuntimeException("Switch '$swName' no está en switches_template.csv");
            }
            if (!isset($switchIndex[$swName]['puertos'][$swPortNum])) {
                throw new RuntimeException("Switch '$swName' no tiene puerto $swPortNum (revisa puertos_totales)");
            }
            $swPortId = $switchIndex[$swName]['puertos'][$swPortNum];
            if (!$DRY) {
                // Verifica conexión existente
                $st = $pdo->prepare(
                    "SELECT id FROM glpi_networkports_networkports
                      WHERE (networkports_id_1=:a AND networkports_id_2=:b)
                         OR (networkports_id_1=:b AND networkports_id_2=:a) LIMIT 1"
                );
                $st->execute([':a'=>$camPortId, ':b'=>$swPortId]);
                if (!$st->fetchColumn()) {
                    $pdo->prepare(
                        "INSERT INTO glpi_networkports_networkports
                            (networkports_id_1, networkports_id_2)
                         VALUES (:a, :b)"
                    )->execute([':a'=>$camPortId, ':b'=>$swPortId]);
                    echo "       conectado a $swName puerto $swPortNum\n";
                    $conectadas++;
                } else {
                    echo "       conexión ya existía con $swName puerto $swPortNum\n";
                }
            } else {
                echo "       [DRY] conectaría a $swName puerto $swPortNum\n";
                $conectadas++;
            }
        }
    } catch (Throwable $e) {
        echo "  [ERR] $name: " . $e->getMessage() . "\n";
        $errores++;
    }
}

if (!$DRY) $pdo->commit();

echo "\n==================== RESUMEN ====================\n";
echo "Switches en archivo : " . count($switches) . "\n";
echo "Cámaras procesadas  : " . count($camaras) . "\n";
echo "Cámaras nuevas      : $creadas\n";
echo "Conexiones nuevas   : $conectadas\n";
echo "Errores             : $errores\n";
echo "\n" . ($DRY ? "(DRY-RUN: nada se guardó. Vuelve a correr sin --dry-run)" : "Listo. Limpia caché si lo deseas.") . "\n";
