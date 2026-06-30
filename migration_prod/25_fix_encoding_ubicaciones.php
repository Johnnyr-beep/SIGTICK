<?php
/**
 * Fix encoding mojibake on glpi_locations.
 *
 * Causa: las cadenas UTF-8 del script 24 fueron reinterpretadas como cp850
 * cuando mysql.exe leyo el archivo. Cada caracter acentuado quedo guardado
 * como 5-6 bytes en lugar de 2.
 *
 * Patrones corregidos:
 *   ├¡  -> í  (UTF-8: E2 94 9C C2 A1     -> C3 AD)
 *   ├│  -> ó  (UTF-8: E2 94 9C E2 94 82  -> C3 B3)
 *   ├®  -> é  (UTF-8: E2 94 9C C2 AE     -> C3 A9)
 *   ├▒  -> ñ  (UTF-8: E2 94 9C E2 96 92  -> C3 B1)
 */

$dsn = 'mysql:host=20.121.178.90;dbname=TICKETS_DB;charset=utf8mb4';
$pdo = new PDO($dsn, 'root', 'Root', [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8mb4',
]);

// Mapa: bytes corruptos UTF-8 -> caracter correcto UTF-8
$fixes = [
    "\xE2\x94\x9C\xC2\xA1"        => "\xC3\xAD", // í
    "\xE2\x94\x9C\xE2\x94\x82"    => "\xC3\xB3", // ó
    "\xE2\x94\x9C\xC2\xAE"        => "\xC3\xA9", // é
    "\xE2\x94\x9C\xE2\x96\x92"    => "\xC3\xB1", // ñ
];

$search  = array_keys($fixes);
$replace = array_values($fixes);

$tables = [
    'glpi_locations' => ['name', 'completename', 'comment'],
    'glpi_entities'  => ['name', 'completename', 'comment'],
];

foreach ($tables as $table => $cols) {
    $colList = implode(',', $cols);
    $rows = $pdo->query("SELECT id, $colList FROM $table")->fetchAll(PDO::FETCH_ASSOC);
    $fixed = 0;
    foreach ($rows as $r) {
        $dirty = false;
        $newVals = [];
        foreach ($cols as $c) {
            $orig = $r[$c] ?? '';
            $new  = str_replace($search, $replace, $orig);
            $newVals[$c] = $new;
            if ($new !== $orig) {
                $dirty = true;
            }
        }
        if (!$dirty) continue;

        $setClause = implode(',', array_map(fn($c) => "$c=?", $cols));
        $stmt = $pdo->prepare("UPDATE $table SET $setClause WHERE id=?");
        $params = array_values($newVals);
        $params[] = $r['id'];
        $stmt->execute($params);
        $fixed++;
        echo "  fixed $table#{$r['id']}: {$newVals[$cols[0]]}\n";
    }
    echo "Tabla $table: $fixed filas corregidas\n";
}

echo "\n== Verificacion ==\n";
$bad = $pdo->query("SELECT COUNT(*) FROM glpi_locations WHERE name LIKE BINARY CONCAT('%', CHAR(0xE2,0x94,0x9C), '%')")->fetchColumn();
echo "Ubicaciones aun corruptas: $bad\n";
