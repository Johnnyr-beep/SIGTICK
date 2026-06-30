-- ============================================================================
-- Script 23: Ajustes al portal PDV
--   - Usuarios pdv.* -> supervisor.* (el supervisor del PDV es el responsable)
--   - Perfil "Cajero PDV" -> "Supervisor PDV"
--   - Habilitar reporte de OTROS tipos de ticket (hardware, red, telefonia,
--     impresoras, camaras, etc) ademas de SIESA POS
--   - Quitar plantilla forzada por defecto: el supervisor escoge la categoria
--   - Mantener create_ticket_on_login=1: al ingresar va directo al formulario
-- ============================================================================

USE TICKETS_DB;

-- ----------------------------------------------------------------------------
-- 1) Renombrar perfil "Cajero PDV" -> "Supervisor PDV"
--    Quitar tickettemplates_id (=0) para que el form muestre la categoria libre
--    Ampliar helpdesk_item_type para incluir Network y permitir asociar HW
-- ----------------------------------------------------------------------------
UPDATE glpi_profiles
   SET name = 'Supervisor PDV',
       comment = 'Supervisor de PDV: reporta fallas SIESA POS, hardware, red, impresoras, camaras, telefonia, etc.',
       tickettemplates_id = 0,
       helpdesk_hardware  = 1,
       helpdesk_item_type = '["Computer","Monitor","NetworkEquipment","Peripheral","Phone","Printer"]',
       date_mod = NOW()
 WHERE name = 'Cajero PDV';

SET @sup_profile := (SELECT id FROM glpi_profiles WHERE name='Supervisor PDV');

-- ----------------------------------------------------------------------------
-- 2) Renombrar usuarios pdv.<tienda> -> supervisor.<tienda>
--    Ajustar firstname/realname para reflejar el rol
-- ----------------------------------------------------------------------------
UPDATE glpi_users
   SET name      = REPLACE(name, 'pdv.', 'supervisor.'),
       realname  = 'Supervisor',
       firstname = CONCAT('PDV ', firstname),
       date_mod  = NOW()
 WHERE name LIKE 'pdv.%';

-- ----------------------------------------------------------------------------
-- 3) Validacion
-- ----------------------------------------------------------------------------
SELECT '== PERFIL ACTUALIZADO ==' AS info;
SELECT id, name, interface, create_ticket_on_login,
       tickettemplates_id, helpdesk_hardware, helpdesk_item_type
  FROM glpi_profiles WHERE id = @sup_profile;

SELECT '== USUARIOS PDV RENOMBRADOS ==' AS info;
SELECT u.id, u.name, u.firstname, u.realname, e.name AS entidad, p.name AS perfil
  FROM glpi_users u
  JOIN glpi_profiles_users pu ON pu.users_id = u.id
  JOIN glpi_entities e        ON e.id        = pu.entities_id
  JOIN glpi_profiles  p       ON p.id        = pu.profiles_id
 WHERE u.name LIKE 'supervisor.%'
 ORDER BY u.name;

SELECT '== TOTAL SUPERVISORES PDV ==' AS info;
SELECT COUNT(*) AS total FROM glpi_users WHERE name LIKE 'supervisor.%';
