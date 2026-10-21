-- ============================================================================
-- Script 22: Portal autoservicio para Cajeros PDV
-- ----------------------------------------------------------------------------
-- Objetivo: que un cajero entre a https://<glpi>/ desde el navegador del PDV,
--           se autentique con un usuario compartido por tienda, y al ingresar
--           vea inmediatamente el formulario simplificado para reportar fallas
--           de SIESA POS, balanzas, internet, impresora ticket, etc.
--
-- Componentes:
--   1. Perfil "Cajero PDV" con interface=helpdesk (portal self-service)
--   2. Derechos minimos: crear ticket, ver sus tickets, FAQ, cambiar password
--   3. Plantilla por defecto = "Soporte SIESA - Punto de Venta" (id=11)
--   4. create_ticket_on_login=1: al loguear se abre directo el formulario
--   5. Un usuario por PDV (16 tiendas) con password compartido "Santacruz2026"
--      asignado al perfil "Cajero PDV" en la entidad de cada tienda
-- ============================================================================

USE TICKETS_DB;

-- ----------------------------------------------------------------------------
-- 1) Limpieza idempotente (por si se reejecuta)
-- ----------------------------------------------------------------------------
DELETE pu FROM glpi_profiles_users pu
  JOIN glpi_users u ON pu.users_id = u.id
 WHERE u.name LIKE 'pdv.%';
DELETE u FROM glpi_users u WHERE u.name LIKE 'pdv.%';

DELETE pr FROM glpi_profilerights pr
  JOIN glpi_profiles p ON pr.profiles_id = p.id
 WHERE p.name = 'Cajero PDV';
DELETE FROM glpi_profiles WHERE name = 'Cajero PDV';

-- ----------------------------------------------------------------------------
-- 2) Crear perfil "Cajero PDV" (interfaz helpdesk = portal autoservicio)
-- ----------------------------------------------------------------------------
INSERT INTO glpi_profiles
  (name, interface, is_default, helpdesk_hardware, helpdesk_item_type,
   ticket_status, problem_status, change_status,
   create_ticket_on_login, tickettemplates_id, changetemplates_id, problemtemplates_id,
   comment, date_mod, date_creation, last_rights_update)
VALUES
  ('Cajero PDV', 'helpdesk', 0, 0,
   '["Computer","Monitor","Peripheral","Phone","Printer"]',
   '{"1":{"1":0,"2":1,"3":1,"4":1,"5":1,"6":1},"2":{"1":0,"2":0,"3":1,"4":1,"5":1,"6":1},"3":{"1":0,"2":0,"3":0,"4":1,"5":1,"6":1},"4":{"1":0,"2":0,"3":0,"4":0,"5":1,"6":1},"5":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":1},"6":{"1":0,"2":0,"3":0,"4":0,"5":0,"6":0}}',
   NULL, NULL,
   1, 11, 0, 0,
   'Perfil para cajeros de PDV. Solo crea tickets de SIESA POS.',
   NOW(), NOW(), NOW());

SET @cajero_profile := LAST_INSERT_ID();

-- ----------------------------------------------------------------------------
-- 3) Derechos del perfil Cajero PDV
--    ticket=5 (CREATE=1 + READMY=4)
--    followup=5 (ADDMY=1 + SEEPUBLIC=4)
--    knowbase=2048 (READFAQ)
--    password_update=1 (cambiar su propia contrasena)
--    Resto de derechos en 0 (lectura ITIL category necesaria para mostrar arbol
--    en el formulario simplificado)
-- ----------------------------------------------------------------------------
INSERT INTO glpi_profilerights (profiles_id, name, rights)
SELECT @cajero_profile, name,
       CASE name
         WHEN 'ticket'            THEN 5
         WHEN 'followup'          THEN 5
         WHEN 'knowbase'          THEN 2048
         WHEN 'password_update'   THEN 1
         WHEN 'itilcategory'      THEN 1
         WHEN 'document'          THEN 2
         WHEN 'reminder_public'   THEN 1
         WHEN 'rssfeed_public'    THEN 1
         WHEN 'personalization'   THEN 1
         WHEN 'task'              THEN 1
         ELSE 0
       END
  FROM glpi_profilerights
 WHERE profiles_id = 1
 GROUP BY name;

-- ----------------------------------------------------------------------------
-- 4) Crear usuarios PDV (uno por tienda)
--    Password compartido inicial: "Santacruz2026"
--    Hash bcrypt PHP password_hash() PASSWORD_BCRYPT
-- ----------------------------------------------------------------------------
SET @pwd_hash := '$2y$10$MmjFzopahFrBx9ptTNt7l.FCwhN9Mtr4iWuINfapmZB6Y4NjavXfm';

INSERT INTO glpi_users
  (name, password, password_last_update, realname, firstname,
   language, list_limit, is_active, is_deleted, authtype, auths_id,
   date_creation, date_mod)
VALUES
  ('pdv.alameda',      @pwd_hash, NOW(), 'PDV', 'Alameda',       'es_ES', NULL, 1, 0, 1, 0, NOW(), NOW()),
  ('pdv.bucaramanga',  @pwd_hash, NOW(), 'PDV', 'Bucaramanga',   'es_ES', NULL, 1, 0, 1, 0, NOW(), NOW()),
  ('pdv.cartagena',    @pwd_hash, NOW(), 'PDV', 'Cartagena',     'es_ES', NULL, 1, 0, 1, 0, NOW(), NOW()),
  ('pdv.centro',       @pwd_hash, NOW(), 'PDV', 'Centro',        'es_ES', NULL, 1, 0, 1, 0, NOW(), NOW()),
  ('pdv.concord',      @pwd_hash, NOW(), 'PDV', 'Concord',       'es_ES', NULL, 1, 0, 1, 0, NOW(), NOW()),
  ('pdv.fruver70',     @pwd_hash, NOW(), 'PDV', 'Fruver La 70',  'es_ES', NULL, 1, 0, 1, 0, NOW(), NOW()),
  ('pdv.la43',         @pwd_hash, NOW(), 'PDV', 'La 43',         'es_ES', NULL, 1, 0, 1, 0, NOW(), NOW()),
  ('pdv.la70',         @pwd_hash, NOW(), 'PDV', 'La 70',         'es_ES', NULL, 1, 0, 1, 0, NOW(), NOW()),
  ('pdv.la93',         @pwd_hash, NOW(), 'PDV', 'La 93',         'es_ES', NULL, 1, 0, 1, 0, NOW(), NOW()),
  ('pdv.malambo',      @pwd_hash, NOW(), 'PDV', 'Malambo',       'es_ES', NULL, 1, 0, 1, 0, NOW(), NOW()),
  ('pdv.olaya',        @pwd_hash, NOW(), 'PDV', 'Olaya',         'es_ES', NULL, 1, 0, 1, 0, NOW(), NOW()),
  ('pdv.pereira',      @pwd_hash, NOW(), 'PDV', 'Pereira',       'es_ES', NULL, 1, 0, 1, 0, NOW(), NOW()),
  ('pdv.piedecuesta',  @pwd_hash, NOW(), 'PDV', 'Piedecuesta',   'es_ES', NULL, 1, 0, 1, 0, NOW(), NOW()),
  ('pdv.sanfelipe',    @pwd_hash, NOW(), 'PDV', 'San Felipe',    'es_ES', NULL, 1, 0, 1, 0, NOW(), NOW()),
  ('pdv.simonbolivar', @pwd_hash, NOW(), 'PDV', 'Simon Bolivar', 'es_ES', NULL, 1, 0, 1, 0, NOW(), NOW()),
  ('pdv.soledad',      @pwd_hash, NOW(), 'PDV', 'Soledad',       'es_ES', NULL, 1, 0, 1, 0, NOW(), NOW());

-- ----------------------------------------------------------------------------
-- 5) Asignar cada usuario PDV a su entidad con el perfil "Cajero PDV"
--    Mapeo nombre_usuario -> entities_id
-- ----------------------------------------------------------------------------
INSERT INTO glpi_profiles_users (users_id, profiles_id, entities_id, is_recursive, is_dynamic)
SELECT u.id, @cajero_profile, e.id, 0, 0
  FROM glpi_users u
  JOIN glpi_entities e ON e.name = (
    CASE u.name
      WHEN 'pdv.alameda'      THEN 'PDV-ALAMEDA'
      WHEN 'pdv.bucaramanga'  THEN 'PDV-BUCARAMANGA'
      WHEN 'pdv.cartagena'    THEN 'PDV-CARTAGENA'
      WHEN 'pdv.centro'       THEN 'PDV-CENTRO'
      WHEN 'pdv.concord'      THEN 'PDV-CONCORD'
      WHEN 'pdv.fruver70'     THEN 'PDV-FRUVER LA 70'
      WHEN 'pdv.la43'         THEN 'PDV-LA 43'
      WHEN 'pdv.la70'         THEN 'PDV-LA 70'
      WHEN 'pdv.la93'         THEN 'PDV-LA 93'
      WHEN 'pdv.malambo'      THEN 'PDV-MALAMBO'
      WHEN 'pdv.olaya'        THEN 'PDV-OLAYA'
      WHEN 'pdv.pereira'      THEN 'PDV-PEREIRA'
      WHEN 'pdv.piedecuesta'  THEN 'PDV-PIEDECUESTA'
      WHEN 'pdv.sanfelipe'    THEN 'PDV-SAN FELIPE'
      WHEN 'pdv.simonbolivar' THEN 'PDV-SIMON BOLIVAR'
      WHEN 'pdv.soledad'      THEN 'PDV-SOLEDAD'
    END
  )
 WHERE u.name LIKE 'pdv.%';

-- Fijar entidad por defecto del usuario (profiles_users_id de su unico mapping)
UPDATE glpi_users u
  JOIN glpi_profiles_users pu ON pu.users_id = u.id
   SET u.entities_id = pu.entities_id,
       u.profiles_id = pu.profiles_id
 WHERE u.name LIKE 'pdv.%';

-- ----------------------------------------------------------------------------
-- 6) Validacion
-- ----------------------------------------------------------------------------
SELECT '== PERFIL CAJERO PDV ==' AS info;
SELECT id, name, interface, create_ticket_on_login, tickettemplates_id, helpdesk_hardware
  FROM glpi_profiles WHERE name='Cajero PDV';

SELECT '== DERECHOS CLAVE DEL PERFIL ==' AS info;
SELECT name, rights
  FROM glpi_profilerights
 WHERE profiles_id = @cajero_profile
   AND rights > 0
 ORDER BY name;

SELECT '== USUARIOS PDV Y SU ENTIDAD ==' AS info;
SELECT u.id, u.name, u.firstname, e.name AS entidad, p.name AS perfil
  FROM glpi_users u
  JOIN glpi_profiles_users pu ON pu.users_id = u.id
  JOIN glpi_entities e ON e.id = pu.entities_id
  JOIN glpi_profiles p ON p.id = pu.profiles_id
 WHERE u.name LIKE 'pdv.%'
 ORDER BY u.name;

SELECT '== TOTAL USUARIOS PDV CREADOS ==' AS info;
SELECT COUNT(*) AS total_cajeros FROM glpi_users WHERE name LIKE 'pdv.%';
