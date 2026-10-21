<?php
/**
 * 32_apply.php  —  PARTE A
 * Catálogo para inventario de cámaras y switches.
 *
 * Crea (si no existen) los tipos:
 *   - Periféricos:  "Cámara IP", "Cámara analógica", "NVR", "DVR"
 *   - Equipos red:  "Switch PoE", "Switch core", "Switch acceso"
 *
 * Idempotente: si el tipo ya existe, no lo duplica.
 * Sin tabla de backup (solo INSERTs aditivos, reversible borrando los nuevos ids).
 */

$pdo = new PDO(
    "mysql:host=20.121.178.90;dbname=TICKETS_DB;charset=utf8mb4",
    "root",
    "Root",
    [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
     PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4"]
);

function ensureType(PDO $pdo, string $tabla, string $nombre, string $comentario = ''): int
{
    $st = $pdo->prepare("SELECT id FROM `$tabla` WHERE name = :n LIMIT 1");
    $st->execute([':n' => $nombre]);
    $id = $st->fetchColumn();
    if ($id) {
        echo "  [=] $tabla / $nombre  (id=$id) ya existe\n";
        return (int)$id;
    }
    $st = $pdo->prepare(
        "INSERT INTO `$tabla` (name, comment, date_creation, date_mod)
         VALUES (:n, :c, NOW(), NOW())"
    );
    $st->execute([':n' => $nombre, ':c' => $comentario]);
    $id = (int)$pdo->lastInsertId();
    echo "  [+] $tabla / $nombre  (id=$id) creado\n";
    return $id;
}

echo "=== Tipos de periférico (cámaras / grabadores) ===\n";
ensureType($pdo, 'glpi_peripheraltypes', 'Cámara IP',
    'Cámara de seguridad con IP propia, se conecta directo al switch (PoE o eléctrica)');
ensureType($pdo, 'glpi_peripheraltypes', 'Cámara analógica',
    'Cámara analógica que se conecta por cable coaxial al DVR');
ensureType($pdo, 'glpi_peripheraltypes', 'NVR',
    'Network Video Recorder: grabador para cámaras IP');
ensureType($pdo, 'glpi_peripheraltypes', 'DVR',
    'Digital Video Recorder: grabador para cámaras analógicas');

echo "\n=== Tipos de equipo de red (switches) ===\n";
ensureType($pdo, 'glpi_networkequipmenttypes', 'Switch PoE',
    'Switch con Power over Ethernet (alimenta cámaras IP, APs, teléfonos IP)');
ensureType($pdo, 'glpi_networkequipmenttypes', 'Switch core',
    'Switch troncal / backbone');
ensureType($pdo, 'glpi_networkequipmenttypes', 'Switch acceso',
    'Switch de acceso a usuarios');

echo "\nListo. Tipos disponibles para registrar cámaras y switches.\n";
