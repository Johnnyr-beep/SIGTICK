<?php
/**
 * 27_apply.php
 * Aplica 3 cambios simultaneos:
 * 1. Sube helpdesk_hardware del perfil "Usuario" (#1, Self-Service) de 1 a 3
 * 2. Sube helpdesk_hardware del perfil "Supervisor PDV" (#9) de 1 a 3
 * 3. Crea una plantilla de impresora "Impresora compartida (Global)" con is_global=1
 *
 * Hace backup previo a _bk27_profiles.
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

echo "=== Backup glpi_profiles -> _bk27_profiles ===\n";
$pdo->exec("DROP TABLE IF EXISTS _bk27_profiles");
$pdo->exec("CREATE TABLE _bk27_profiles AS SELECT * FROM glpi_profiles");
$nbk = (int)$pdo->query("SELECT COUNT(*) FROM _bk27_profiles")->fetchColumn();
echo "  Filas respaldadas: $nbk\n";

$pdo->beginTransaction();
try {
    echo "\n=== 1) Subiendo helpdesk_hardware perfil #1 (Usuario) ===\n";
    $stmt = $pdo->prepare("UPDATE glpi_profiles SET helpdesk_hardware=3 WHERE id=1");
    $stmt->execute();
    echo "  Filas afectadas: " . $stmt->rowCount() . "\n";

    echo "\n=== 2) Subiendo helpdesk_hardware perfil #9 (Supervisor PDV) ===\n";
    $stmt = $pdo->prepare("UPDATE glpi_profiles SET helpdesk_hardware=3 WHERE id=9");
    $stmt->execute();
    echo "  Filas afectadas: " . $stmt->rowCount() . "\n";

    echo "\n=== 3) Creando plantilla 'Impresora compartida (Global)' ===\n";
    // Verificar si ya existe
    $tpl_id = $pdo->query("SELECT id FROM glpi_printers WHERE is_template=1 AND template_name='Impresora compartida (Global)'")->fetchColumn();
    if ($tpl_id) {
        echo "  Ya existe plantilla #{$tpl_id}, omito creación.\n";
    } else {
        $stmt = $pdo->prepare("
            INSERT INTO glpi_printers
                (entities_id, is_recursive, name, is_template, template_name, is_global, comment, date_creation, date_mod)
            VALUES
                (0, 1, '********', 1, :tn, 1, :c, NOW(), NOW())
        ");
        $stmt->execute([
            ':tn' => 'Impresora compartida (Global)',
            ':c'  => 'Plantilla con is_global=1 para impresoras compartidas (PDV, oficinas).',
        ]);
        $tpl_id = (int)$pdo->lastInsertId();
        echo "  Plantilla creada con id #{$tpl_id}\n";
    }

    $pdo->commit();
} catch (Throwable $e) {
    $pdo->rollBack();
    fwrite(STDERR, "ERROR: " . $e->getMessage() . "\n");
    exit(1);
}

echo "\n=== Verificación final ===\n";
$rows = $pdo->query("SELECT id, name, helpdesk_hardware FROM glpi_profiles WHERE id IN (1,9)")->fetchAll(PDO::FETCH_ASSOC);
foreach ($rows as $r) {
    $ok = $r["helpdesk_hardware"] == 3 ? "OK" : "FALLO";
    echo sprintf("  [%s] #%d %-20s helpdesk_hardware=%d\n", $ok, $r["id"], $r["name"], $r["helpdesk_hardware"]);
}

$tpl = $pdo->query("SELECT id, template_name, is_global FROM glpi_printers WHERE is_template=1")->fetchAll(PDO::FETCH_ASSOC);
foreach ($tpl as $t) {
    echo sprintf("  [OK] Plantilla #%d %s is_global=%d\n", $t["id"], $t["template_name"], $t["is_global"]);
}

echo "\nHecho.\n";
