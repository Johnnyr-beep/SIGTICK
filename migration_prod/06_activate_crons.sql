-- =====================================================================
-- 06_activate_crons.sql
-- Activa las tareas cron necesarias para correo y mantenimiento
-- =====================================================================

UPDATE glpi_crontasks SET state = 1, frequency = 60     WHERE name = 'queuednotification';
UPDATE glpi_crontasks SET state = 1, frequency = 86400  WHERE name = 'queuednotificationclean';
UPDATE glpi_crontasks SET state = 1, frequency = 600    WHERE name = 'mailgate';
UPDATE glpi_crontasks SET state = 1, frequency = 86400  WHERE name = 'mailgateerror';
