<?php
/**
 * 34_produccion_check.php  —  DIAGNÓSTICO PARA SALIDA A PRODUCCIÓN
 * Solo lectura. NO modifica nada.
 *
 * Revisa:
 *   1. Cuentas por defecto de GLPI activas (glpi/tech/normal/post-only)
 *   2. Debug/desarrollo activo
 *   3. Modo mantenimiento
 *   4. Instalador presente
 *   5. Configuración de correo
 *   6. Cron / tareas programadas
 *   7. Sesiones activas
 *   8. Datos de prueba
 *   9. Permisos archivo
 *  10. Backups
 */

$pdo = new PDO(
    "mysql:host=20.121.178.90;dbname=TICKETS_DB;charset=utf8mb4",
    "root", "Root",
    [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
     PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4"]
);

$ROOT = 'c:/xampp/htdocs/glpi';
$OK = 0; $WARN = 0; $CRIT = 0;
$msgs = [];

function line($sev, $titulo, $detalle) {
    global $OK, $WARN, $CRIT, $msgs;
    $tag = ['OK'=>'[OK]  ', 'WARN'=>'[WARN]', 'CRIT'=>'[CRIT]'][$sev];
    if ($sev==='OK') $OK++; elseif ($sev==='WARN') $WARN++; else $CRIT++;
    $msgs[] = "$tag $titulo\n         $detalle";
}

echo "========================================\n";
echo " GLPI - CHECKLIST DE PRODUCCION\n";
echo " " . date('Y-m-d H:i:s') . "\n";
echo "========================================\n\n";

// -------------------------------------------------- 1. Cuentas por defecto
$defaults = ['glpi','tech','normal','post-only'];
$st = $pdo->prepare("SELECT id, name, is_active, is_deleted FROM glpi_users WHERE name IN ('".implode("','",$defaults)."')");
$st->execute();
foreach ($st->fetchAll(PDO::FETCH_ASSOC) as $u) {
    if ($u['is_active']==1 && $u['is_deleted']==0) {
        line('CRIT', "Usuario por defecto '{$u['name']}' ACTIVO",
            "Contraseñas conocidas publicamente. Deshabilitar o cambiar clave.");
    } else {
        line('OK', "Usuario '{$u['name']}' deshabilitado o borrado", "is_active={$u['is_active']}, is_deleted={$u['is_deleted']}");
    }
}

// -------------------------------------------------- 2. Debug
$dbg = $pdo->query("SELECT context,name,value FROM glpi_configs
                     WHERE (context='core' AND name IN ('use_log_in_files','_dbslave_status'))
                        OR (name IN ('devmode','maintenance_text','maintenance_mode','use_notifications'))")
           ->fetchAll(PDO::FETCH_ASSOC);
$cfg = [];
foreach ($dbg as $r) $cfg["{$r['context']}.{$r['name']}"] = $r['value'];

$devmode = $pdo->query("SELECT value FROM glpi_configs WHERE name='devmode' LIMIT 1")->fetchColumn();
if ($devmode === '1') line('CRIT', "Modo desarrollador ACTIVO (devmode=1)", "Cambiar a 0 en Configuracion > General > Sistema");
elseif ($devmode !== false) line('OK', "devmode desactivado ($devmode)", "correcto para produccion");

// -------------------------------------------------- 3. Mantenimiento
$mm = $pdo->query("SELECT value FROM glpi_configs WHERE name='maintenance_mode' LIMIT 1")->fetchColumn();
if ($mm === '1') line('WARN', "Modo mantenimiento ACTIVO", "Los usuarios ven pagina de mantenimiento. Desactivar antes de abrir.");
else line('OK', "Modo mantenimiento desactivado", "");

// -------------------------------------------------- 4. Instalador
if (is_file("$ROOT/install/install.php")) {
    line('CRIT', "install/install.php EXISTE", "DEBE eliminarse o renombrarse para produccion.");
} else {
    line('OK', "install/install.php ausente", "correcto");
}

// -------------------------------------------------- 5. Correo (SMTP)
$notif = $pdo->query("SELECT value FROM glpi_configs WHERE name='use_notifications' LIMIT 1")->fetchColumn();
$mode  = $pdo->query("SELECT value FROM glpi_configs WHERE name='notifications_mailing' LIMIT 1")->fetchColumn();
$smtpH = $pdo->query("SELECT value FROM glpi_configs WHERE name='smtp_host' LIMIT 1")->fetchColumn();
$smtpF = $pdo->query("SELECT value FROM glpi_configs WHERE name='from_email' LIMIT 1")->fetchColumn();

if ($notif !== '1') line('WARN', "Notificaciones globales desactivadas", "Los usuarios NO recibiran emails. Config > Notificaciones");
elseif ($mode !== '1') line('WARN', "Notificaciones por email desactivadas", "Config > Notificaciones > Notificaciones por email");
elseif (empty($smtpH)) line('WARN', "SMTP no configurado", "Config > Notificaciones > Config email");
elseif (empty($smtpF)) line('WARN', "Falta email remitente (from_email)", "Config > Notificaciones > Config email");
else line('OK', "SMTP configurado", "host=$smtpH desde=$smtpF");

// -------------------------------------------------- 6. Cron
$last = $pdo->query("SELECT MAX(lastrun) FROM glpi_crontasks")->fetchColumn();
if ($last === null) {
    line('CRIT', "CRON NUNCA se ha ejecutado", "Debe configurarse en Windows Task Scheduler o cron externo.");
} else {
    $edad = time() - strtotime($last);
    if ($edad > 3600) line('WARN', "CRON no corre hace >1 hora", "Ultima: $last (hace ".round($edad/60)." min)");
    else line('OK', "CRON activo", "Ultima corrida: $last");
}

// -------------------------------------------------- 7. Sesiones activas
$sessDir = "$ROOT/files/_sessions";
if (is_dir($sessDir)) {
    $n = count(glob("$sessDir/*"));
    line('OK', "Sesiones activas: $n", "");
}

// -------------------------------------------------- 8. Datos de prueba (CSV de ejemplo)
$csvs = ['switches_template.csv','camaras_template.csv'];
foreach ($csvs as $f) {
    $path = "$ROOT/migration_prod/data/$f";
    if (is_file($path)) {
        $lines = count(file($path)) - 1;
        line('WARN', "Plantilla CSV con datos de ejemplo: $f", "$lines filas. Reemplaza por datos reales o borra antes de importar.");
    }
}

// -------------------------------------------------- 9. Backups tabla _bk*
$bks = $pdo->query("SHOW TABLES LIKE '\\_bk%'")->fetchAll(PDO::FETCH_COLUMN);
if ($bks) {
    line('OK', "Tablas de backup preservadas", implode(', ', $bks));
}

// -------------------------------------------------- 10. Contraseñas admin root/superadmin
$sa = $pdo->query("
    SELECT u.id, u.name, u.password IS NOT NULL AS tiene_pass
      FROM glpi_users u
      JOIN glpi_profiles_users pu ON pu.users_id = u.id
      JOIN glpi_profiles p ON p.id = pu.profiles_id
     WHERE p.name IN ('Super-Admin','Admin')
       AND u.is_active=1 AND u.is_deleted=0
     GROUP BY u.id
")->fetchAll(PDO::FETCH_ASSOC);
$saCount = count($sa);
if ($saCount === 0) line('CRIT', "No hay Super-Admin activo", "Nadie podra administrar.");
else line('OK', "Super-Admin/Admin activos: $saCount", implode(', ', array_map(fn($r)=>$r['name'], $sa)));

// -------------------------------------------------- 11. GLPI_VERSION visible
$ver = $pdo->query("SELECT value FROM glpi_configs WHERE name='version' LIMIT 1")->fetchColumn();
line('OK', "Version GLPI en BD", $ver ?? '(no encontrada)');

// -------------------------------------------------- 12. Cache dir
$cacheDir = "$ROOT/files/_cache";
$folders = is_dir($cacheDir) ? count(glob("$cacheDir/*", GLOB_ONLYDIR)) : 0;
line('OK', "Directorios de cache", "$folders (se regeneran al vuelo)");

// -------------------------------------------------- 13. HTTPS (revisa vhost)
$vhost = 'C:/xampp/apache/conf/extra/httpd-vhosts.conf';
if (is_file($vhost)) {
    $vh = file_get_contents($vhost);
    if (strpos($vh, 'SSLEngine on') !== false || strpos($vh, ':443') !== false) {
        line('OK', "HTTPS configurado en vhost", "");
    } else {
        line('WARN', "HTTPS/SSL no configurado en vhost", "Recomendado para produccion. Considera Let's Encrypt / reverse proxy.");
    }
}

// -------------------------------------------------- 14. Errores recientes
$errFile = "$ROOT/files/_log/php-errors.log";
if (is_file($errFile)) {
    $size = filesize($errFile);
    if ($size > 100*1024) line('WARN', "php-errors.log grande", round($size/1024)." KB. Revisa antes de abrir.");
    else line('OK', "php-errors.log tamaño OK", round($size/1024)." KB");
}

// -------------------------------------------------- 15. Volumen actual
$stats = [];
foreach (['users'=>'glpi_users','entities'=>'glpi_entities',
          'profiles'=>'glpi_profiles','groups'=>'glpi_groups',
          'tickets'=>'glpi_tickets','peripherals'=>'glpi_peripherals',
          'networkequipments'=>'glpi_networkequipments',
          'computers'=>'glpi_computers','locations'=>'glpi_locations'] as $k=>$t) {
    $stats[$k] = $pdo->query("SELECT COUNT(*) FROM $t")->fetchColumn();
}

// ---------------------------------------------- Salida
echo str_repeat('-', 60) . "\n";
foreach ($msgs as $m) echo $m . "\n";
echo "\n" . str_repeat('=', 60) . "\n";
echo " RESUMEN: OK=$OK  WARNINGS=$WARN  CRITICOS=$CRIT\n";
echo str_repeat('=', 60) . "\n";
echo "\nVOLUMEN ACTUAL:\n";
foreach ($stats as $k=>$v) printf("   %-25s %s\n", $k, $v);
