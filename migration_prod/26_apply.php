<?php
/**
 * 26_apply.php
 * Crea 9 subentidades L3 bajo INVERSIONES SERRANO MILLAN (id=46) en TICKETS_DB.
 * Usa PDO con utf8mb4 para preservar acentos correctamente.
 * Hace backup previo a la tabla _bk26_entities.
 */

$pdo = new PDO(
    "mysql:host=20.121.178.90;dbname=TICKETS_DB;charset=utf8mb4",
    "root",
    "Root",
    [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci",
    ]
);

$PADRE_ID    = 46;
$PADRE_NAME  = 'INVERSIONES SERRANO MILLAN';
$PADRE_COMPL = 'GRUPO SANTACRUZ > INVERSIONES SERRANO MILLAN';
$ANCESTORS   = '{"0":0,"46":46}';
$TAG         = 'INVERSIONES';

$subentidades = [
    'Contabilidad',
    'Despacho',
    'Facturación',
    'Montería',
    'Mantenimiento',
    'Producción',
    'Planta Eléctrica Inversiones',
    'Gerencia (Inversiones)',
    'Compras Inversiones',
];

echo "=== Verificando entidad padre #{$PADRE_ID} ===\n";
$padre = $pdo->query("SELECT id, name, completename, level FROM glpi_entities WHERE id={$PADRE_ID}")
    ->fetch(PDO::FETCH_ASSOC);
if (!$padre || $padre['name'] !== $PADRE_NAME) {
    fwrite(STDERR, "ABORTANDO: entidad #{$PADRE_ID} no es '{$PADRE_NAME}'.\n");
    exit(1);
}
echo "  OK: {$padre['completename']} (L{$padre['level']})\n";

echo "\n=== Backup a _bk26_entities ===\n";
$pdo->exec("DROP TABLE IF EXISTS _bk26_entities");
$pdo->exec("CREATE TABLE _bk26_entities AS SELECT * FROM glpi_entities");
$nbk = (int)$pdo->query("SELECT COUNT(*) FROM _bk26_entities")->fetchColumn();
echo "  Filas respaldadas: {$nbk}\n";

echo "\n=== Insertando subentidades ===\n";
$pdo->beginTransaction();
try {
    $stmt = $pdo->prepare("
        INSERT INTO glpi_entities
            (name, entities_id, completename, level, ancestors_cache, tag, date_creation, date_mod)
        VALUES
            (:name, :pid, :compl, 3, :anc, :tag, NOW(), NOW())
    ");
    $creadas = [];
    foreach ($subentidades as $name) {
        // Evitar duplicados si se ejecuta dos veces
        $ya = $pdo->prepare("SELECT id FROM glpi_entities WHERE entities_id=:pid AND name=:name");
        $ya->execute([':pid' => $PADRE_ID, ':name' => $name]);
        if ($ya->fetchColumn()) {
            echo "  [SKIP] '{$name}' ya existe\n";
            continue;
        }
        $stmt->execute([
            ':name'  => $name,
            ':pid'   => $PADRE_ID,
            ':compl' => "{$PADRE_COMPL} > {$name}",
            ':anc'   => $ANCESTORS,
            ':tag'   => $TAG,
        ]);
        $newid = (int)$pdo->lastInsertId();
        $creadas[$newid] = $name;
        echo "  [OK]   #{$newid}  {$name}\n";
    }
    $pdo->commit();
} catch (Throwable $e) {
    $pdo->rollBack();
    fwrite(STDERR, "ERROR: " . $e->getMessage() . "\n");
    exit(1);
}

echo "\n=== Resultado final (rama INVERSIONES) ===\n";
$rows = $pdo->query("SELECT id, completename, level FROM glpi_entities
                     WHERE completename LIKE 'GRUPO SANTACRUZ > INVERSIONES SERRANO MILLAN%'
                     ORDER BY completename")->fetchAll(PDO::FETCH_ASSOC);
foreach ($rows as $r) {
    printf("  #%-3d L%d %s\n", $r['id'], $r['level'], $r['completename']);
}

echo "\nTotal nuevas: " . count($creadas) . "\n";
echo "Hecho.\n";
