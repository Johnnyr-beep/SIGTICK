# =====================================================================
# export_full.ps1
# ---------------------------------------------------------------------
# Genera un único archivo SQL (migration_prod\full_export.sql) con
# TODOS los cambios actuales de la BD local lista para aplicar en prod.
#
# Incluye:
#   - Plantillas de notificación (glpi_notificationtemplatetranslations)
#   - Configuración SMTP / URL / firmas (glpi_configs filtrado)
#   - Mail collector IMAP (glpi_mailcollectors, SIN contraseña)
#   - Notificaciones activas (glpi_notifications)
#   - Cron tasks de correo (glpi_crontasks)
#   - Plugins (glpi_plugins)
#
# Uso:
#   cd c:\xampp\htdocs\glpi\migration_prod
#   powershell -ExecutionPolicy Bypass -File .\export_full.ps1
#
# Después en producción:
#   mysql -u <USER> -p <DB_NAME> < full_export.sql
# =====================================================================

$ErrorActionPreference = "Stop"

# --- Config local ---
$DbHost = "localhost"
$DbUser = "root"
$DbPass = "Root"
$DbName = "glpi"

$Mysql     = "C:\xampp\mysql\bin\mysql.exe"
$Mysqldump = "C:\xampp\mysql\bin\mysqldump.exe"

$OutDir  = $PSScriptRoot
$OutFile = Join-Path $OutDir "full_export.sql"
$TmpDir  = Join-Path $OutDir "_tmp"

if (Test-Path $TmpDir) { Remove-Item $TmpDir -Recurse -Force }
New-Item -ItemType Directory -Path $TmpDir | Out-Null

Write-Host "Exportando BD local '$DbName'..." -ForegroundColor Cyan

# Argumentos comunes para mysqldump (sin DROP, con REPLACE para idempotencia)
$dumpArgs = @(
    "-h", $DbHost,
    "-u", $DbUser,
    "--password=$DbPass",
    "--no-create-info",          # solo datos
    "--skip-add-drop-table",
    "--skip-add-locks",
    "--skip-comments",
    "--skip-extended-insert",
    "--skip-set-charset",
    "--complete-insert",
    "--replace",                 # REPLACE INTO (idempotente)
    "--default-character-set=utf8mb4"
)

function Dump-Table {
    param(
        [string]$Table,
        [string]$Where = "",
        [string]$OutName
    )
    $args = $dumpArgs + @($DbName, $Table)
    if ($Where -ne "") {
        $args += @("--where=$Where")
    }
    $outPath = Join-Path $TmpDir $OutName
    & $Mysqldump @args 2>$null | Out-File -FilePath $outPath -Encoding UTF8
    if (-not (Test-Path $outPath) -or (Get-Item $outPath).Length -eq 0) {
        Write-Warning "Tabla $Table devolvió contenido vacío"
    } else {
        Write-Host "  OK $Table -> $OutName" -ForegroundColor Green
    }
}

# 1. Plantillas de notificación (las 32 con HTML rebrandeado)
Dump-Table -Table "glpi_notificationtemplatetranslations" -OutName "01_templates.sql"

# 2. Configs: solo claves de correo / URL / firma (no exportamos toda glpi_configs por seguridad)
$configKeys = @(
    "smtp_mode","smtp_host","smtp_port","smtp_username",
    "smtp_check_certificate","smtp_sender",
    "admin_email","admin_email_name","from_email","from_email_name",
    "replyto_email","replyto_email_name","admin_reply","admin_reply_name",
    "use_notifications","notifications_mailing","notifications_ajax",
    "attach_ticket_documents_to_mail","mailing_signature","url_base","url_base_api"
) | ForEach-Object { "'$_'" }
$keysIn = $configKeys -join ","
$where  = "context='core' AND name IN ($keysIn)"
Dump-Table -Table "glpi_configs" -Where $where -OutName "02_configs.sql"

# 3. Mail collector (sin password)
Dump-Table -Table "glpi_mailcollectors" -OutName "03_mailcollectors.sql"

# 4. Notificaciones activas
Dump-Table -Table "glpi_notifications" -OutName "04_notifications.sql"

# 5. Crontasks (solo las de correo)
$where = "name IN ('queuednotification','queuednotificationclean','mailgate','mailgateerror')"
Dump-Table -Table "glpi_crontasks" -Where $where -OutName "05_crontasks.sql"

# 6. Plugins
Dump-Table -Table "glpi_plugins" -OutName "06_plugins.sql"

# --- Construir archivo único ---
Write-Host ""
Write-Host "Consolidando en $OutFile..." -ForegroundColor Cyan

$header = @"
-- =====================================================================
-- full_export.sql
-- Generado: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
-- Origen:   BD local '$DbName'
--
-- Aplica TODOS los cambios de la BD local en producción.
-- ANTES DE EJECUTAR:
--   1. Hacer backup completo de la BD de producción.
--   2. Verificar que la versión de GLPI coincida (11.0.x).
--
-- Después de ejecutar:
--   - Ingresar manualmente en la UI de GLPI las contraseñas de:
--       * SMTP (Configuración > Notificaciones > Correo electrónico)
--       * Mail Collector (Configuración > Recolectores)
--   - Limpiar caché:  rm -rf files/_cache/*
-- =====================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO';

-- Sanea contraseña del mail collector (en prod se reingresa por UI)
UPDATE glpi_mailcollectors SET passwd='' WHERE id > 0;

"@

$footer = @"

-- Reactivar
SET FOREIGN_KEY_CHECKS=1;

-- Sanea contraseña SMTP (se reingresa en UI por seguridad)
UPDATE glpi_configs SET value='' WHERE context='core' AND name='smtp_passwd';

-- Limpia caché de configuración
DELETE FROM glpi_configs WHERE context='core' AND name='cache_lifetime';

SELECT 'Exportación aplicada correctamente.' AS resultado;
"@

$header | Out-File -FilePath $OutFile -Encoding UTF8

$order = @(
    "01_templates.sql",
    "02_configs.sql",
    "03_mailcollectors.sql",
    "04_notifications.sql",
    "05_crontasks.sql",
    "06_plugins.sql"
)

foreach ($f in $order) {
    $p = Join-Path $TmpDir $f
    if (Test-Path $p) {
        "`n-- ============================================" | Out-File -FilePath $OutFile -Encoding UTF8 -Append
        "-- $f"                                              | Out-File -FilePath $OutFile -Encoding UTF8 -Append
        "-- ============================================`n" | Out-File -FilePath $OutFile -Encoding UTF8 -Append
        Get-Content $p | Out-File -FilePath $OutFile -Encoding UTF8 -Append
    }
}

$footer | Out-File -FilePath $OutFile -Encoding UTF8 -Append

Remove-Item $TmpDir -Recurse -Force

$size = [math]::Round((Get-Item $OutFile).Length / 1KB, 1)
Write-Host ""
Write-Host "Listo." -ForegroundColor Green
Write-Host "Archivo: $OutFile  ($size KB)"
Write-Host ""
Write-Host "Para aplicar en producción:" -ForegroundColor Yellow
Write-Host "  mysql -u <USER> -p <DB_NAME> < full_export.sql"
