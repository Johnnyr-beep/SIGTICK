<?php
/**
 * 35_produccion_apply.php  —  FIXES SEGUROS PARA SALIDA A PRODUCCION
 *
 * Ejecuta acciones reversibles:
 *  1. Deshabilita usuarios por defecto de GLPI (glpi, tech, normal, post-only)
 *  2. Renombra install/install.php  ->  install.php.disabled_YYYYMMDD
 *  3. Trunca php-errors.log tras copiarlo con timestamp
 *  4. Limpia los CSV de ejemplo (deja solo el header)
 *  5. Confirma que devmode=0 y maintenance_mode=0
 *  6. Limpia cache
 */

$pdo = new PDO(
    "mysql:host=20.121.178.90;dbname=TICKETS_DB;charset=utf8mb4",
    "root","Root",
    [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
     PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4"]
);

$ROOT  = 'c:/xampp/htdocs/glpi';
$stamp = date('Ymd_His');

echo "=========================================\n";
echo " APLICANDO FIXES DE PRODUCCION\n";
echo "=========================================\n\n";

// -------------------- 1. Deshabilitar cuentas por defecto
echo "[1] Deshabilitar usuarios por defecto (glpi/tech/normal/post-only)\n";
$st = $pdo->prepare(
    "UPDATE glpi_users SET is_active=0
      WHERE name IN ('glpi','tech','normal','post-only')
        AND is_active=1"
);
$st->execute();
echo "    filas afectadas: {$st->rowCount()}\n";
echo "    (revertir: UPDATE glpi_users SET is_active=1 WHERE name IN (...);)\n\n";

// -------------------- 2. install/install.php
echo "[2] Desactivar instalador\n";
$src = "$ROOT/install/install.php";
if (is_file($src)) {
    $dst = "$ROOT/install/install.php.disabled_$stamp";
    if (rename($src, $dst)) {
        echo "    renombrado a: install.php.disabled_$stamp\n";
    } else {
        echo "    ERROR: no se pudo renombrar (revisa permisos)\n";
    }
} else {
    echo "    ya estaba ausente. OK.\n";
}
echo "\n";

// -------------------- 3. php-errors.log
echo "[3] Rotar php-errors.log\n";
$log = "$ROOT/files/_log/php-errors.log";
if (is_file($log)) {
    $sz = filesize($log);
    $bak = "$ROOT/files/_log/php-errors.log.$stamp.bak";
    if ($sz > 0) {
        copy($log, $bak);
        file_put_contents($log, "");
        echo "    respaldado ($sz bytes) -> " . basename($bak) . "\n";
        echo "    truncado el original.\n";
    } else {
        echo "    ya estaba vacio.\n";
    }
} else {
    echo "    no existe (nada que rotar).\n";
}
echo "\n";

// -------------------- 4. Vaciar CSV de ejemplo
echo "[4] Limpiar CSV de ejemplo (dejar solo encabezado)\n";
$csvs = [
    'switches_template.csv' => "name,entidad,marca,modelo,tipo,numero_serie,ip,mac,gestion_url,puertos_totales,ubicacion,comentario\n",
    'camaras_template.csv'  => "name,entidad,tipo,marca,modelo,numero_serie,ip,mac,switch_name,switch_port,ubicacion_fisica,resolucion,gestion_url,comentario\n",
];
foreach ($csvs as $f => $header) {
    $path = "$ROOT/migration_prod/data/$f";
    if (is_file($path)) {
        $bak = "$ROOT/migration_prod/data/$f.$stamp.bak";
        copy($path, $bak);
        file_put_contents($path, $header);
        echo "    $f: encabezado listo (ejemplo respaldado en .bak)\n";
    }
}
echo "\n";

// -------------------- 5. devmode + maintenance
echo "[5] Confirmar flags de produccion\n";
$pdo->exec("UPDATE glpi_configs SET value='0' WHERE name='devmode' AND value<>'0'");
$pdo->exec("UPDATE glpi_configs SET value='0' WHERE name='maintenance_mode' AND value<>'0'");
$dev = $pdo->query("SELECT value FROM glpi_configs WHERE name='devmode' LIMIT 1")->fetchColumn();
$mm  = $pdo->query("SELECT value FROM glpi_configs WHERE name='maintenance_mode' LIMIT 1")->fetchColumn();
echo "    devmode=$dev  maintenance_mode=$mm\n\n";

// -------------------- 6. Limpieza cache
echo "[6] Limpiar cache\n";
$cacheDir = "$ROOT/files/_cache";
$n = 0;
if (is_dir($cacheDir)) {
    foreach (glob("$cacheDir/*", GLOB_ONLYDIR) as $d) {
        $rmdirRec = function($p) use (&$rmdirRec) {
            foreach (scandir($p) as $e) {
                if ($e==='.'||$e==='..') continue;
                $full = "$p/$e";
                is_dir($full) ? $rmdirRec($full) : @unlink($full);
            }
            @rmdir($p);
        };
        $rmdirRec($d);
        $n++;
    }
}
echo "    directorios cache limpiados: $n\n\n";

echo "=========================================\n";
echo " FIXES APLICADOS. Corre 34_produccion_check.php para reverificar.\n";
echo "=========================================\n";
