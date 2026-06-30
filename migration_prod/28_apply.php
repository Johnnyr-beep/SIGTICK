<?php
/**
 * 28_apply.php
 * Cambia el perfil de los 20 supervisores PDV/Restaurante:
 *   profiles_id 9 (Supervisor PDV) -> 1 (Usuario)
 * Mantiene entities_id (PDV/Restaurante de cada uno) y is_recursive=0.
 *
 * Backup previo en _bk28_profiles_users.
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

echo "=== Backup glpi_profiles_users -> _bk28_profiles_users ===\n";
$pdo->exec("DROP TABLE IF EXISTS _bk28_profiles_users");
$pdo->exec("CREATE TABLE _bk28_profiles_users AS SELECT * FROM glpi_profiles_users");
$nbk = (int)$pdo->query("SELECT COUNT(*) FROM _bk28_profiles_users")->fetchColumn();
echo "  Filas respaldadas: $nbk\n";

echo "\n=== Estado ANTES ===\n";
$antes = $pdo->query("
    SELECT u.id, u.name, pu.profiles_id, p.name profile_name, e.name entidad
    FROM glpi_users u
    JOIN glpi_profiles_users pu ON pu.users_id=u.id
    JOIN glpi_profiles p ON p.id=pu.profiles_id
    LEFT JOIN glpi_entities e ON e.id=pu.entities_id
    WHERE u.name LIKE 'supervisor.%' AND pu.profiles_id=9
    ORDER BY u.name
")->fetchAll(PDO::FETCH_ASSOC);
echo "  Supervisores con perfil 'Supervisor PDV' (#9): " . count($antes) . "\n";

$pdo->beginTransaction();
try {
    echo "\n=== Aplicando cambio profiles_id: 9 -> 1 ===\n";
    $stmt = $pdo->prepare("
        UPDATE glpi_profiles_users pu
        JOIN glpi_users u ON u.id=pu.users_id
        SET pu.profiles_id=1
        WHERE u.name LIKE 'supervisor.%' AND pu.profiles_id=9
    ");
    $stmt->execute();
    $afect = $stmt->rowCount();
    echo "  Filas actualizadas: $afect\n";

    if ($afect !== count($antes)) {
        throw new Exception("Conteo inesperado: esperados " . count($antes) . ", actualizados $afect");
    }

    $pdo->commit();
} catch (Throwable $e) {
    $pdo->rollBack();
    fwrite(STDERR, "ERROR: " . $e->getMessage() . "\n");
    fwrite(STDERR, "Cambios revertidos. Restaurar con:\n");
    fwrite(STDERR, "  TRUNCATE glpi_profiles_users; INSERT INTO glpi_profiles_users SELECT * FROM _bk28_profiles_users;\n");
    exit(1);
}

echo "\n=== Estado DESPUES ===\n";
$rows = $pdo->query("
    SELECT u.id, u.name, p.name profile_name, e.name entidad, pu.is_recursive
    FROM glpi_users u
    JOIN glpi_profiles_users pu ON pu.users_id=u.id
    JOIN glpi_profiles p ON p.id=pu.profiles_id
    LEFT JOIN glpi_entities e ON e.id=pu.entities_id
    WHERE u.name LIKE 'supervisor.%'
    ORDER BY u.name
")->fetchAll(PDO::FETCH_ASSOC);
foreach ($rows as $r) {
    echo sprintf("  #%-3d %-30s perfil=%-10s entidad=%-30s rec=%d\n",
        $r["id"], $r["name"], $r["profile_name"], $r["entidad"], $r["is_recursive"]);
}

echo "\nHecho.\n";
