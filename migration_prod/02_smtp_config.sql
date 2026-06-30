-- =====================================================================
-- 02_smtp_config.sql
-- Configuración SMTP (Gmail) + IMAP + notificaciones
-- =====================================================================
-- IMPORTANTE: la contraseña SMTP NO se incluye en este script por seguridad.
-- Después de ejecutar este SQL, hay que entrar a:
--   Configuración → Notificaciones → Configuración de notificaciones por correo
-- y escribir la contraseña de aplicación de Gmail (16 caracteres) en
-- el campo "Contraseña SMTP".
-- =====================================================================

-- SMTP saliente (Gmail con TLS en puerto 587)
REPLACE INTO glpi_configs (context, name, value) VALUES ('core', 'smtp_host',              'smtp.gmail.com');
REPLACE INTO glpi_configs (context, name, value) VALUES ('core', 'smtp_port',              '587');
REPLACE INTO glpi_configs (context, name, value) VALUES ('core', 'smtp_mode',              '1');
REPLACE INTO glpi_configs (context, name, value) VALUES ('core', 'smtp_username',          'tisantacruz48@gmail.com');
REPLACE INTO glpi_configs (context, name, value) VALUES ('core', 'smtp_check_certificate', '1');

-- Direcciones de correo
REPLACE INTO glpi_configs (context, name, value) VALUES ('core', 'admin_email',         'tisantacruz48@gmail.com');
REPLACE INTO glpi_configs (context, name, value) VALUES ('core', 'admin_email_name',    'Soporte Santacruz');
REPLACE INTO glpi_configs (context, name, value) VALUES ('core', 'from_email',          'tisantacruz48@gmail.com');
REPLACE INTO glpi_configs (context, name, value) VALUES ('core', 'from_email_name',     'Soporte Santacruz');
REPLACE INTO glpi_configs (context, name, value) VALUES ('core', 'replyto_email',       'tisantacruz48@gmail.com');
REPLACE INTO glpi_configs (context, name, value) VALUES ('core', 'replyto_email_name',  'Soporte Santacruz');
REPLACE INTO glpi_configs (context, name, value) VALUES ('core', 'admin_reply',         'tisantacruz48@gmail.com');
REPLACE INTO glpi_configs (context, name, value) VALUES ('core', 'admin_reply_name',    'Soporte Santacruz');

-- Habilitar el envío de notificaciones
REPLACE INTO glpi_configs (context, name, value) VALUES ('core', 'use_notifications',              '1');
REPLACE INTO glpi_configs (context, name, value) VALUES ('core', 'notifications_mailing',          '1');
REPLACE INTO glpi_configs (context, name, value) VALUES ('core', 'attach_ticket_documents_to_mail','1');

-- Firma y URL pública
REPLACE INTO glpi_configs (context, name, value) VALUES ('core', 'mailing_signature', 'Atentamente,\n\nMesa de Ayuda TI\nGrupo Empresarial Santacruz');
REPLACE INTO glpi_configs (context, name, value) VALUES ('core', 'url_base',          'https://helpdesk.grupo-santacruz.com');
