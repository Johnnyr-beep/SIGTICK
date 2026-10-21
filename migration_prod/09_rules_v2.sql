-- =====================================================================
-- 09_rules_v2.sql
-- ---------------------------------------------------------------------
-- Versión 2 de las reglas de asignación automática:
--
-- LUNES A VIERNES (un técnico por franja):
--   06:30 - 08:00  → Julio
--   08:00 - 11:00  → Marco
--   11:00 - 12:30  → Sebastian
--   12:30 - 14:00  → ALMUERZO (sin regla → sin asignar)
--   14:00 - 17:00  → Anthony
--   17:00 - 20:00  → Sebastian
--
-- SÁBADO Y DOMINGO: sin asignación automática.
--   Los tickets llegan SIN técnico → el de turno los toma manualmente.
--
-- FUERA DE TURNO L-V (00:00-06:30 / 20:00-23:59 / hora de almuerzo):
--   Sin asignación automática también.
--
-- Idempotente: borra y recrea las reglas SC-RR-* y SC-WK-*.
-- =====================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================================
-- 1. LIMPIEZA TOTAL (versión anterior)
-- =====================================================================
DELETE rc FROM glpi_rulecriterias rc
  INNER JOIN glpi_rules r ON rc.rules_id = r.id
  WHERE r.uuid LIKE 'SC-RR-%' OR r.uuid LIKE 'SC-WK-%';
DELETE ra FROM glpi_ruleactions ra
  INNER JOIN glpi_rules r ON ra.rules_id = r.id
  WHERE r.uuid LIKE 'SC-RR-%' OR r.uuid LIKE 'SC-WK-%';
DELETE FROM glpi_rules WHERE uuid LIKE 'SC-RR-%' OR uuid LIKE 'SC-WK-%';

-- Desvincular holidays de fin de semana
DELETE ch FROM glpi_calendars_holidays ch
  INNER JOIN glpi_holidays h ON ch.holidays_id = h.id
  WHERE h.name LIKE 'SC-WK-%';
DELETE FROM glpi_holidays WHERE name LIKE 'SC-WK-%';

-- Borrar calendarios viejos
DELETE cs FROM glpi_calendarsegments cs
  INNER JOIN glpi_calendars c ON cs.calendars_id = c.id
  WHERE c.name LIKE 'SC-Turno%' OR c.name LIKE 'SC-FinSemana%';
DELETE FROM glpi_calendars WHERE name LIKE 'SC-Turno%' OR name LIKE 'SC-FinSemana%';

-- =====================================================================
-- 2. IDs DE USUARIOS Y GRUPO
-- =====================================================================
SELECT id INTO @uid_julio     FROM glpi_users  WHERE name='julio.tech'     LIMIT 1;
SELECT id INTO @uid_marco     FROM glpi_users  WHERE name='marco.tech'     LIMIT 1;
SELECT id INTO @uid_sebastian FROM glpi_users  WHERE name='sebastian.tech' LIMIT 1;
SELECT id INTO @uid_anthony   FROM glpi_users  WHERE name='anthony.tech'   LIMIT 1;
SELECT id INTO @gid_soporte   FROM glpi_groups WHERE name='Soporte TI' AND comment LIKE 'SC-RR%' LIMIT 1;

-- =====================================================================
-- 3. CALENDARIOS L-V POR FRANJA
-- =====================================================================
-- cache_duration: [Dom, Lun, Mar, Mié, Jue, Vie, Sáb] en segundos

-- Julio: 06:30-08:00 = 5400 s
INSERT INTO glpi_calendars (name, entities_id, is_recursive, comment, cache_duration, date_creation, date_mod)
VALUES ('SC-Turno Julio (06:30-08:00 L-V)', 0, 1, 'Auto round-robin', '[0,5400,5400,5400,5400,5400,0]', NOW(), NOW());
SET @cal_julio = LAST_INSERT_ID();
INSERT INTO glpi_calendarsegments (calendars_id, entities_id, is_recursive, day, begin, end) VALUES
  (@cal_julio, 0, 1, 1, '06:30:00', '08:00:00'),
  (@cal_julio, 0, 1, 2, '06:30:00', '08:00:00'),
  (@cal_julio, 0, 1, 3, '06:30:00', '08:00:00'),
  (@cal_julio, 0, 1, 4, '06:30:00', '08:00:00'),
  (@cal_julio, 0, 1, 5, '06:30:00', '08:00:00');

-- Marco: 08:00-11:00 = 10800 s
INSERT INTO glpi_calendars (name, entities_id, is_recursive, comment, cache_duration, date_creation, date_mod)
VALUES ('SC-Turno Marco (08:00-11:00 L-V)', 0, 1, 'Auto round-robin', '[0,10800,10800,10800,10800,10800,0]', NOW(), NOW());
SET @cal_marco = LAST_INSERT_ID();
INSERT INTO glpi_calendarsegments (calendars_id, entities_id, is_recursive, day, begin, end) VALUES
  (@cal_marco, 0, 1, 1, '08:00:00', '11:00:00'),
  (@cal_marco, 0, 1, 2, '08:00:00', '11:00:00'),
  (@cal_marco, 0, 1, 3, '08:00:00', '11:00:00'),
  (@cal_marco, 0, 1, 4, '08:00:00', '11:00:00'),
  (@cal_marco, 0, 1, 5, '08:00:00', '11:00:00');

-- Sebastian AM: 11:00-12:30 = 5400 s
INSERT INTO glpi_calendars (name, entities_id, is_recursive, comment, cache_duration, date_creation, date_mod)
VALUES ('SC-Turno Sebastian AM (11:00-12:30 L-V)', 0, 1, 'Auto round-robin', '[0,5400,5400,5400,5400,5400,0]', NOW(), NOW());
SET @cal_seb_am = LAST_INSERT_ID();
INSERT INTO glpi_calendarsegments (calendars_id, entities_id, is_recursive, day, begin, end) VALUES
  (@cal_seb_am, 0, 1, 1, '11:00:00', '12:30:00'),
  (@cal_seb_am, 0, 1, 2, '11:00:00', '12:30:00'),
  (@cal_seb_am, 0, 1, 3, '11:00:00', '12:30:00'),
  (@cal_seb_am, 0, 1, 4, '11:00:00', '12:30:00'),
  (@cal_seb_am, 0, 1, 5, '11:00:00', '12:30:00');

-- Anthony: 14:00-17:00 = 10800 s
INSERT INTO glpi_calendars (name, entities_id, is_recursive, comment, cache_duration, date_creation, date_mod)
VALUES ('SC-Turno Anthony (14:00-17:00 L-V)', 0, 1, 'Auto round-robin', '[0,10800,10800,10800,10800,10800,0]', NOW(), NOW());
SET @cal_anthony = LAST_INSERT_ID();
INSERT INTO glpi_calendarsegments (calendars_id, entities_id, is_recursive, day, begin, end) VALUES
  (@cal_anthony, 0, 1, 1, '14:00:00', '17:00:00'),
  (@cal_anthony, 0, 1, 2, '14:00:00', '17:00:00'),
  (@cal_anthony, 0, 1, 3, '14:00:00', '17:00:00'),
  (@cal_anthony, 0, 1, 4, '14:00:00', '17:00:00'),
  (@cal_anthony, 0, 1, 5, '14:00:00', '17:00:00');

-- Sebastian PM: 17:00-20:00 = 10800 s
INSERT INTO glpi_calendars (name, entities_id, is_recursive, comment, cache_duration, date_creation, date_mod)
VALUES ('SC-Turno Sebastian PM (17:00-20:00 L-V)', 0, 1, 'Auto round-robin', '[0,10800,10800,10800,10800,10800,0]', NOW(), NOW());
SET @cal_seb_pm = LAST_INSERT_ID();
INSERT INTO glpi_calendarsegments (calendars_id, entities_id, is_recursive, day, begin, end) VALUES
  (@cal_seb_pm, 0, 1, 1, '17:00:00', '20:00:00'),
  (@cal_seb_pm, 0, 1, 2, '17:00:00', '20:00:00'),
  (@cal_seb_pm, 0, 1, 3, '17:00:00', '20:00:00'),
  (@cal_seb_pm, 0, 1, 4, '17:00:00', '20:00:00'),
  (@cal_seb_pm, 0, 1, 5, '17:00:00', '20:00:00');

-- =====================================================================
-- 4. REGLAS L-V (sin fallback → si no aplica franja queda sin asignar)
-- =====================================================================

-- Regla 1: Julio 06:30-08:00
INSERT INTO glpi_rules (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, uuid, `condition`, date_creation, date_mod)
VALUES (0, 'RuleTicket', 10, 'Asignacion automatica - Julio (06:30-08:00 L-V)',
        'Franja matutina temprana', 'AND', 1, 'SC-RR: generado por script', 1, 'SC-RR-1', 1, NOW(), NOW());
SET @r1 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
  (@r1, '_date_creation_calendars_id', 0, @cal_julio);
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
  (@r1, 'assign', '_users_id_assign',         @uid_julio),
  (@r1, 'assign', '_groups_id_assign',        @gid_soporte),
  (@r1, 'assign', '_stop_rules_processing',   1);

-- Regla 2: Marco 08:00-11:00
INSERT INTO glpi_rules (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, uuid, `condition`, date_creation, date_mod)
VALUES (0, 'RuleTicket', 20, 'Asignacion automatica - Marco (08:00-11:00 L-V)',
        'Franja matutina media', 'AND', 1, 'SC-RR: generado por script', 1, 'SC-RR-2', 1, NOW(), NOW());
SET @r2 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
  (@r2, '_date_creation_calendars_id', 0, @cal_marco);
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
  (@r2, 'assign', '_users_id_assign',         @uid_marco),
  (@r2, 'assign', '_groups_id_assign',        @gid_soporte),
  (@r2, 'assign', '_stop_rules_processing',   1);

-- Regla 3: Sebastian AM 11:00-12:30
INSERT INTO glpi_rules (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, uuid, `condition`, date_creation, date_mod)
VALUES (0, 'RuleTicket', 30, 'Asignacion automatica - Sebastian (11:00-12:30 L-V)',
        'Franja prealmuerzo', 'AND', 1, 'SC-RR: generado por script', 1, 'SC-RR-3', 1, NOW(), NOW());
SET @r3 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
  (@r3, '_date_creation_calendars_id', 0, @cal_seb_am);
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
  (@r3, 'assign', '_users_id_assign',         @uid_sebastian),
  (@r3, 'assign', '_groups_id_assign',        @gid_soporte),
  (@r3, 'assign', '_stop_rules_processing',   1);

-- Regla 4: Anthony 14:00-17:00
INSERT INTO glpi_rules (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, uuid, `condition`, date_creation, date_mod)
VALUES (0, 'RuleTicket', 40, 'Asignacion automatica - Anthony (14:00-17:00 L-V)',
        'Franja vespertina', 'AND', 1, 'SC-RR: generado por script', 1, 'SC-RR-4', 1, NOW(), NOW());
SET @r4 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
  (@r4, '_date_creation_calendars_id', 0, @cal_anthony);
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
  (@r4, 'assign', '_users_id_assign',         @uid_anthony),
  (@r4, 'assign', '_groups_id_assign',        @gid_soporte),
  (@r4, 'assign', '_stop_rules_processing',   1);

-- Regla 5: Sebastian PM 17:00-20:00
INSERT INTO glpi_rules (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, uuid, `condition`, date_creation, date_mod)
VALUES (0, 'RuleTicket', 50, 'Asignacion automatica - Sebastian (17:00-20:00 L-V)',
        'Franja nocturna', 'AND', 1, 'SC-RR: generado por script', 1, 'SC-RR-5', 1, NOW(), NOW());
SET @r5 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
  (@r5, '_date_creation_calendars_id', 0, @cal_seb_pm);
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
  (@r5, 'assign', '_users_id_assign',         @uid_sebastian),
  (@r5, 'assign', '_groups_id_assign',        @gid_soporte),
  (@r5, 'assign', '_stop_rules_processing',   1);

-- NOTA: NO hay regla fallback.
-- Tickets en sábado, domingo, almuerzo, madrugada o fuera de horario
-- llegarán SIN técnico asignado para que el de turno los tome manualmente.

-- =====================================================================
-- 5. RESULTADO
-- =====================================================================
SET FOREIGN_KEY_CHECKS = 1;

SELECT 'Reglas v2 creadas correctamente.' AS resultado;
SELECT id, name FROM glpi_calendars WHERE name LIKE 'SC-Turno%' ORDER BY id;
SELECT id, name, ranking, is_active FROM glpi_rules WHERE uuid LIKE 'SC-RR-%' ORDER BY ranking;

-- Cobertura del día
SELECT
  '06:30-08:00 → Julio | 08:00-11:00 → Marco | 11:00-12:30 → Sebastian | 12:30-14:00 → ALMUERZO (sin asignar) | 14:00-17:00 → Anthony | 17:00-20:00 → Sebastian | Fines de semana → SIN ASIGNAR'
  AS cobertura;
