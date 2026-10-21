-- =====================================================================
-- 07_rules_round_robin.sql
-- ---------------------------------------------------------------------
-- Asignación automática de tickets por turno horario (round-robin).
--
-- Crea:
--   * 3 usuarios técnicos (Marco, Sebastian, Anthony) si no existen
--   * 1 grupo "Soporte TI" con los 4 técnicos (incluye Julio id=8)
--   * 4 calendarios — uno por franja horaria
--   * 5 reglas de negocio (RuleTicket OnAdd):
--       - 4 reglas: una por franja → técnico + grupo + stop
--       - 1 regla fallback (resto del tiempo) → Julio + grupo
--
-- Franjas (L-V):
--   06:30-11:00 → Julio Bovea (id=8)
--   11:00-13:30 → Marco Bruges
--   13:30-17:00 → Anthony Redondo
--   17:00-20:00 → Sebastian Zarache
--   Resto / fin de semana → Julio (fallback)
--
-- Es idempotente: limpia antes de insertar.
-- =====================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================================
-- 1. LIMPIEZA (idempotencia)
-- =====================================================================

-- Borrar reglas previas creadas por este script (y sus criterios/acciones)
DELETE rc FROM glpi_rulecriterias rc
  INNER JOIN glpi_rules r ON rc.rules_id = r.id
  WHERE r.uuid LIKE 'SC-RR-%';
DELETE ra FROM glpi_ruleactions ra
  INNER JOIN glpi_rules r ON ra.rules_id = r.id
  WHERE r.uuid LIKE 'SC-RR-%';
DELETE FROM glpi_rules WHERE uuid LIKE 'SC-RR-%';

-- Borrar calendarios previos del script
DELETE cs FROM glpi_calendarsegments cs
  INNER JOIN glpi_calendars c ON cs.calendars_id = c.id
  WHERE c.name LIKE 'SC-Turno%';
DELETE FROM glpi_calendars WHERE name LIKE 'SC-Turno%';

-- Borrar membresía y grupo previo del script
DELETE gu FROM glpi_groups_users gu
  INNER JOIN glpi_groups g ON gu.groups_id = g.id
  WHERE g.name = 'Soporte TI' AND g.comment LIKE 'SC-RR%';
DELETE FROM glpi_groups WHERE name = 'Soporte TI' AND comment LIKE 'SC-RR%';

-- =====================================================================
-- 2. USUARIOS TÉCNICOS (crear solo si no existen)
-- =====================================================================
-- Marco Bruges
INSERT INTO glpi_users (name, realname, firstname, language, is_active,
                        authtype, auths_id, profiles_id, entities_id, date_creation, date_mod)
SELECT 'marco.tech', 'Bruges', 'Marco', 'es_CO', 1, 1, 0, 0, 0, NOW(), NOW()
  WHERE NOT EXISTS (SELECT 1 FROM glpi_users WHERE name='marco.tech');

-- Sebastian Zarache
INSERT INTO glpi_users (name, realname, firstname, language, is_active,
                        authtype, auths_id, profiles_id, entities_id, date_creation, date_mod)
SELECT 'sebastian.tech', 'Zarache', 'Sebastian', 'es_CO', 1, 1, 0, 0, 0, NOW(), NOW()
  WHERE NOT EXISTS (SELECT 1 FROM glpi_users WHERE name='sebastian.tech');

-- Anthony Redondo
INSERT INTO glpi_users (name, realname, firstname, language, is_active,
                        authtype, auths_id, profiles_id, entities_id, date_creation, date_mod)
SELECT 'anthony.tech', 'Redondo', 'Anthony', 'es_CO', 1, 1, 0, 0, 0, NOW(), NOW()
  WHERE NOT EXISTS (SELECT 1 FROM glpi_users WHERE name='anthony.tech');

-- Capturar IDs en variables
SELECT id INTO @uid_julio     FROM glpi_users WHERE name='julio.tech'     LIMIT 1;
SELECT id INTO @uid_marco     FROM glpi_users WHERE name='marco.tech'     LIMIT 1;
SELECT id INTO @uid_sebastian FROM glpi_users WHERE name='sebastian.tech' LIMIT 1;
SELECT id INTO @uid_anthony   FROM glpi_users WHERE name='anthony.tech'   LIMIT 1;

-- Asignar perfil "Technician" (id=6) en entidad raíz, recursivo
INSERT IGNORE INTO glpi_profiles_users (users_id, profiles_id, entities_id, is_recursive, is_dynamic) VALUES
  (@uid_marco,     6, 0, 1, 0),
  (@uid_sebastian, 6, 0, 1, 0),
  (@uid_anthony,   6, 0, 1, 0);

-- =====================================================================
-- 3. GRUPO "SOPORTE TI"
-- =====================================================================
INSERT INTO glpi_groups
  (entities_id, is_recursive, name, comment,
   is_requester, is_watcher, is_assign, is_task, is_notify, is_itemgroup, is_usergroup, is_manager,
   date_creation, date_mod)
VALUES
  (0, 1, 'Soporte TI', 'SC-RR: Equipo de soporte TI (asignacion automatica)',
   1, 1, 1, 1, 1, 1, 1, 0, NOW(), NOW());
SET @gid_soporte = LAST_INSERT_ID();

INSERT INTO glpi_groups_users (users_id, groups_id) VALUES
  (@uid_julio,     @gid_soporte),
  (@uid_marco,     @gid_soporte),
  (@uid_sebastian, @gid_soporte),
  (@uid_anthony,   @gid_soporte);

-- =====================================================================
-- 4. CALENDARIOS (uno por franja, L=1 a V=5)
-- =====================================================================
-- Julio: 06:30-11:00
INSERT INTO glpi_calendars (name, entities_id, is_recursive, comment, date_creation, date_mod)
VALUES ('SC-Turno Julio (06:30-11:00 L-V)', 0, 1, 'Auto round-robin', NOW(), NOW());
SET @cal_julio = LAST_INSERT_ID();
INSERT INTO glpi_calendarsegments (calendars_id, entities_id, is_recursive, day, begin, end) VALUES
  (@cal_julio, 0, 1, 1, '06:30:00', '11:00:00'),
  (@cal_julio, 0, 1, 2, '06:30:00', '11:00:00'),
  (@cal_julio, 0, 1, 3, '06:30:00', '11:00:00'),
  (@cal_julio, 0, 1, 4, '06:30:00', '11:00:00'),
  (@cal_julio, 0, 1, 5, '06:30:00', '11:00:00');

-- Marco: 11:00-13:30
INSERT INTO glpi_calendars (name, entities_id, is_recursive, comment, date_creation, date_mod)
VALUES ('SC-Turno Marco (11:00-13:30 L-V)', 0, 1, 'Auto round-robin', NOW(), NOW());
SET @cal_marco = LAST_INSERT_ID();
INSERT INTO glpi_calendarsegments (calendars_id, entities_id, is_recursive, day, begin, end) VALUES
  (@cal_marco, 0, 1, 1, '11:00:00', '13:30:00'),
  (@cal_marco, 0, 1, 2, '11:00:00', '13:30:00'),
  (@cal_marco, 0, 1, 3, '11:00:00', '13:30:00'),
  (@cal_marco, 0, 1, 4, '11:00:00', '13:30:00'),
  (@cal_marco, 0, 1, 5, '11:00:00', '13:30:00');

-- Anthony: 13:30-17:00
INSERT INTO glpi_calendars (name, entities_id, is_recursive, comment, date_creation, date_mod)
VALUES ('SC-Turno Anthony (13:30-17:00 L-V)', 0, 1, 'Auto round-robin', NOW(), NOW());
SET @cal_anthony = LAST_INSERT_ID();
INSERT INTO glpi_calendarsegments (calendars_id, entities_id, is_recursive, day, begin, end) VALUES
  (@cal_anthony, 0, 1, 1, '13:30:00', '17:00:00'),
  (@cal_anthony, 0, 1, 2, '13:30:00', '17:00:00'),
  (@cal_anthony, 0, 1, 3, '13:30:00', '17:00:00'),
  (@cal_anthony, 0, 1, 4, '13:30:00', '17:00:00'),
  (@cal_anthony, 0, 1, 5, '13:30:00', '17:00:00');

-- Sebastian: 17:00-20:00
INSERT INTO glpi_calendars (name, entities_id, is_recursive, comment, date_creation, date_mod)
VALUES ('SC-Turno Sebastian (17:00-20:00 L-V)', 0, 1, 'Auto round-robin', NOW(), NOW());
SET @cal_sebastian = LAST_INSERT_ID();
INSERT INTO glpi_calendarsegments (calendars_id, entities_id, is_recursive, day, begin, end) VALUES
  (@cal_sebastian, 0, 1, 1, '17:00:00', '20:00:00'),
  (@cal_sebastian, 0, 1, 2, '17:00:00', '20:00:00'),
  (@cal_sebastian, 0, 1, 3, '17:00:00', '20:00:00'),
  (@cal_sebastian, 0, 1, 4, '17:00:00', '20:00:00'),
  (@cal_sebastian, 0, 1, 5, '17:00:00', '20:00:00');

-- =====================================================================
-- 5. REGLAS DE NEGOCIO (RuleTicket, condition=1 = al crear)
-- =====================================================================
-- Helper: action 'assign' a usuario/grupo. PATTERN_IS = 0.

-- Regla 1: Turno Julio
INSERT INTO glpi_rules (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, uuid, `condition`, date_creation, date_mod)
VALUES (0, 'RuleTicket', 10, 'Asignacion automatica - Turno Julio (06:30-11:00)',
        'Round-robin por franja horaria', 'AND', 1, 'SC-RR: generado por script', 1, 'SC-RR-1', 1, NOW(), NOW());
SET @r1 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
  (@r1, '_date_creation_calendars_id', 0, @cal_julio);
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
  (@r1, 'assign', '_users_id_assign',  @uid_julio),
  (@r1, 'assign', '_groups_id_assign', @gid_soporte),
  (@r1, 'assign', '_stop_rules_processing', 1);

-- Regla 2: Turno Marco
INSERT INTO glpi_rules (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, uuid, `condition`, date_creation, date_mod)
VALUES (0, 'RuleTicket', 20, 'Asignacion automatica - Turno Marco (11:00-13:30)',
        'Round-robin por franja horaria', 'AND', 1, 'SC-RR: generado por script', 1, 'SC-RR-2', 1, NOW(), NOW());
SET @r2 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
  (@r2, '_date_creation_calendars_id', 0, @cal_marco);
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
  (@r2, 'assign', '_users_id_assign',  @uid_marco),
  (@r2, 'assign', '_groups_id_assign', @gid_soporte),
  (@r2, 'assign', '_stop_rules_processing', 1);

-- Regla 3: Turno Anthony
INSERT INTO glpi_rules (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, uuid, `condition`, date_creation, date_mod)
VALUES (0, 'RuleTicket', 30, 'Asignacion automatica - Turno Anthony (13:30-17:00)',
        'Round-robin por franja horaria', 'AND', 1, 'SC-RR: generado por script', 1, 'SC-RR-3', 1, NOW(), NOW());
SET @r3 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
  (@r3, '_date_creation_calendars_id', 0, @cal_anthony);
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
  (@r3, 'assign', '_users_id_assign',  @uid_anthony),
  (@r3, 'assign', '_groups_id_assign', @gid_soporte),
  (@r3, 'assign', '_stop_rules_processing', 1);

-- Regla 4: Turno Sebastian
INSERT INTO glpi_rules (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, uuid, `condition`, date_creation, date_mod)
VALUES (0, 'RuleTicket', 40, 'Asignacion automatica - Turno Sebastian (17:00-20:00)',
        'Round-robin por franja horaria', 'AND', 1, 'SC-RR: generado por script', 1, 'SC-RR-4', 1, NOW(), NOW());
SET @r4 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
  (@r4, '_date_creation_calendars_id', 0, @cal_sebastian);
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
  (@r4, 'assign', '_users_id_assign',  @uid_sebastian),
  (@r4, 'assign', '_groups_id_assign', @gid_soporte),
  (@r4, 'assign', '_stop_rules_processing', 1);

-- Regla 5: Fallback (status=1 "Nuevo" siempre se cumple al crear)
INSERT INTO glpi_rules (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, uuid, `condition`, date_creation, date_mod)
VALUES (0, 'RuleTicket', 99, 'Asignacion automatica - Fallback (fuera de turno)',
        'Si ninguna franja aplica, asigna a Julio (turno mas cercano)', 'AND', 1, 'SC-RR: generado por script', 1, 'SC-RR-5', 1, NOW(), NOW());
SET @r5 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
  (@r5, 'status', 0, '1');   -- status=Nuevo (siempre verdadero al crear)
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
  (@r5, 'assign', '_users_id_assign',  @uid_julio),
  (@r5, 'assign', '_groups_id_assign', @gid_soporte);

-- =====================================================================
-- 6. RESULTADO
-- =====================================================================
SET FOREIGN_KEY_CHECKS = 1;

SELECT 'Reglas creadas correctamente.' AS resultado;
SELECT id, name, realname, firstname FROM glpi_users WHERE name IN ('julio.tech','marco.tech','sebastian.tech','anthony.tech');
SELECT g.id, g.name, COUNT(gu.users_id) AS miembros
  FROM glpi_groups g LEFT JOIN glpi_groups_users gu ON gu.groups_id=g.id
  WHERE g.name='Soporte TI' AND g.comment LIKE 'SC-RR%' GROUP BY g.id;
SELECT id, name FROM glpi_calendars WHERE name LIKE 'SC-Turno%' ORDER BY id;
SELECT id, name, ranking, is_active FROM glpi_rules WHERE uuid LIKE 'SC-RR-%' ORDER BY ranking;
