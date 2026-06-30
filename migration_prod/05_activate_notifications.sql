-- =====================================================================
-- 05_activate_notifications.sql
-- Activa todas las notificaciones del sistema
-- =====================================================================

UPDATE glpi_notifications SET is_active = 1;
