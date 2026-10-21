<?php
/**
 * Diagnóstico previo para módulo de cámaras + switches.
 * Solo lectura. NO modifica nada.
 */
$pdo = new PDO(
    "mysql:host=20.121.178.90;dbname=TICKETS_DB;charset=utf8mb4",
    "root",
    "Root",
    [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
     PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4"]
);

$queries = [
    "Tipos de periférico existentes (cámaras irían acá)" =>
        "SELECT id, name FROM glpi_peripheraltypes ORDER BY name",
    "Tipos de equipo de red existentes (switches)" =>
        "SELECT id, name FROM glpi_networkequipmenttypes ORDER BY name",
    "Fabricantes existentes" =>
        "SELECT id, name FROM glpi_manufacturers ORDER BY name",
    "Modelos de periférico existentes" =>
        "SELECT id, name FROM glpi_peripheralmodels ORDER BY name LIMIT 30",
    "Modelos de equipo de red existentes" =>
        "SELECT id, name FROM glpi_networkequipmentmodels ORDER BY name LIMIT 30",
    "Periféricos registrados (cuántos)" =>
        "SELECT COUNT(*) AS n FROM glpi_peripherals WHERE is_deleted=0 AND is_template=0",
    "Switches registrados (cuántos)" =>
        "SELECT COUNT(*) AS n FROM glpi_networkequipments WHERE is_deleted=0 AND is_template=0",
    "Conexiones puerto a puerto existentes" =>
        "SELECT COUNT(*) AS n FROM glpi_networkports_networkports",
    "Entidades disponibles (resumen)" =>
        "SELECT id, name, level FROM glpi_entities ORDER BY level, name",
];

foreach ($queries as $titulo => $sql) {
    echo "\n=== $titulo ===\n";
    $st = $pdo->query($sql);
    $rows = $st->fetchAll(PDO::FETCH_ASSOC);
    if (!$rows) {
        echo "  (vacío)\n";
        continue;
    }
    foreach ($rows as $r) {
        echo "  " . implode(" | ", array_map(fn($k,$v) => "$k=$v", array_keys($r), array_values($r))) . "\n";
    }
}
