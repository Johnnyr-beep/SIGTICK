-- =====================================================================
-- 03_mailcollector.sql
-- Crea/actualiza el recolector de correo IMAP (Gmail)
-- =====================================================================
-- IMPORTANTE: la contraseña NO se incluye porque GLPI la cifra con una
-- clave local (config/glpicrypt.key) que es distinta en cada servidor.
-- Después de aplicar este SQL hay que entrar a:
--   Configuración → Recolectores de correo → Buzon Soporte Gmail
-- y escribir la contraseña de aplicación de Gmail (16 caracteres).
-- =====================================================================

REPLACE INTO glpi_mailcollectors (
    id,
    name,
    host,
    login,
    filesize_max,
    is_active,
    comment,
    use_mail_date,
    requester_field,
    add_to_to_observer,
    add_cc_to_observer,
    collect_only_unread,
    create_user_from_email,
    date_creation,
    date_mod
) VALUES (
    1,
    'Buzon Soporte Gmail',
    '{imap.gmail.com:993/imap/ssl/validate-cert/notls/secure}INBOX',
    'tisantacruz48@gmail.com',
    2097152,
    1,
    'Recolector principal Gmail',
    0,
    0,
    1,
    0,
    1,
    1,
    NOW(),
    NOW()
);
