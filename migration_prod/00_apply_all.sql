-- =====================================================================
-- 00_apply_all.sql
-- Script maestro: aplica TODOS los cambios en orden.
-- Uso:
--   mysql -u <USER> -p <DB_NAME> < 00_apply_all.sql
-- =====================================================================
-- Antes de ejecutar:
--   1. Hacer backup completo de la BD de producción.
--   2. Verificar que la versión de GLPI sea 11.0.x.
-- =====================================================================

SOURCE 01_notification_templates.sql;
SOURCE 02_smtp_config.sql;
SOURCE 03_mailcollector.sql;
SOURCE 05_activate_notifications.sql;
SOURCE 06_activate_crons.sql;

-- Limpia cache de configuración (opcional pero recomendado)
DELETE FROM glpi_configs WHERE context = 'core' AND name = 'cache_lifetime';

SELECT 'Migracion aplicada correctamente.' AS resultado;
