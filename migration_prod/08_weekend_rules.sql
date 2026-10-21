-- =====================================================================
-- 08_weekend_rules.sql
-- ---------------------------------------------------------------------
-- Reglas de fin de semana con rotación quincenal.
--
-- Próximo sábado (2026-06-13): Marco + Sebastian
-- Siguiente (2026-06-20):       Anthony + Julio
-- ...alterna cada fin de semana durante 6 meses (hasta 2026-12-06).
--
-- Implementación:
--   * 2 calendarios "fin de semana" (Sáb+Dom 24h)
--       - SC-FinSemana-MarcoSeb
--       - SC-FinSemana-AnthJulio
--   * Cada calendario tiene marcados como FERIADO los fines del otro
--     equipo. Así solo un calendario "trabaja" cada finde.
--   * 2 reglas RuleTicket (rank 50 y 60) que matchean por calendario.
--   * El técnico principal se asigna y el compañero se agrega como
--     técnico adicional (append). El grupo Soporte TI también.
--
-- Idempotente: limpia y recrea.
--
-- Cuando se acerquen los 6 meses, regenerar dates con un script
-- nuevo (o ajustar el rango aquí).
-- =====================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================================
-- 1. LIMPIEZA (idempotencia)
-- =====================================================================

-- Borrar reglas previas creadas por este script
DELETE rc FROM glpi_rulecriterias rc
  INNER JOIN glpi_rules r ON rc.rules_id = r.id
  WHERE r.uuid LIKE 'SC-WK-%';
DELETE ra FROM glpi_ruleactions ra
  INNER JOIN glpi_rules r ON ra.rules_id = r.id
  WHERE r.uuid LIKE 'SC-WK-%';
DELETE FROM glpi_rules WHERE uuid LIKE 'SC-WK-%';

-- Borrar enlaces calendario-holiday previos
DELETE ch FROM glpi_calendars_holidays ch
  INNER JOIN glpi_holidays h ON ch.holidays_id = h.id
  WHERE h.name LIKE 'SC-WK-%';
DELETE FROM glpi_holidays WHERE name LIKE 'SC-WK-%';

-- Borrar calendarios fin de semana previos
DELETE cs FROM glpi_calendarsegments cs
  INNER JOIN glpi_calendars c ON cs.calendars_id = c.id
  WHERE c.name LIKE 'SC-FinSemana%';
DELETE FROM glpi_calendars WHERE name LIKE 'SC-FinSemana%';

-- =====================================================================
-- 2. IDs DE USUARIOS Y GRUPO (deben existir tras 07_rules_round_robin.sql)
-- =====================================================================
SELECT id INTO @uid_julio     FROM glpi_users WHERE name='julio.tech'     LIMIT 1;
SELECT id INTO @uid_marco     FROM glpi_users WHERE name='marco.tech'     LIMIT 1;
SELECT id INTO @uid_sebastian FROM glpi_users WHERE name='sebastian.tech' LIMIT 1;
SELECT id INTO @uid_anthony   FROM glpi_users WHERE name='anthony.tech'   LIMIT 1;
SELECT id INTO @gid_soporte   FROM glpi_groups WHERE name='Soporte TI' AND comment LIKE 'SC-RR%' LIMIT 1;

-- =====================================================================
-- 3. CALENDARIOS DE FIN DE SEMANA
-- =====================================================================
-- Día PHP date('w'): 0=Dom, 1=Lun, ..., 6=Sáb
-- cache_duration índice: [Dom, Lun, Mar, Mié, Jue, Vie, Sáb]
-- 86399 seg = 23h59m59s

-- Calendar A: Marco + Sebastian
INSERT INTO glpi_calendars (name, entities_id, is_recursive, comment, cache_duration, date_creation, date_mod)
VALUES ('SC-FinSemana-MarcoSeb', 0, 1, 'Auto round-robin fines de semana',
        '[86399,0,0,0,0,0,86399]', NOW(), NOW());
SET @cal_ms = LAST_INSERT_ID();
INSERT INTO glpi_calendarsegments (calendars_id, entities_id, is_recursive, day, begin, end) VALUES
  (@cal_ms, 0, 1, 6, '00:00:00', '23:59:59'),   -- Sábado
  (@cal_ms, 0, 1, 0, '00:00:00', '23:59:59');   -- Domingo

-- Calendar B: Anthony + Julio
INSERT INTO glpi_calendars (name, entities_id, is_recursive, comment, cache_duration, date_creation, date_mod)
VALUES ('SC-FinSemana-AnthJulio', 0, 1, 'Auto round-robin fines de semana',
        '[86399,0,0,0,0,0,86399]', NOW(), NOW());
SET @cal_aj = LAST_INSERT_ID();
INSERT INTO glpi_calendarsegments (calendars_id, entities_id, is_recursive, day, begin, end) VALUES
  (@cal_aj, 0, 1, 6, '00:00:00', '23:59:59'),
  (@cal_aj, 0, 1, 0, '00:00:00', '23:59:59');

-- =====================================================================
-- 4. HOLIDAYS (excluye los fines del OTRO equipo)
-- =====================================================================
-- Fines de MarcoSeb (próximo sábado 06-13 y cada 14 días) → 13 finsem.
-- Estos se vuelven FERIADO para el calendario AnthJulio.

INSERT INTO glpi_holidays (name, entities_id, is_recursive, comment, begin_date, end_date, is_perpetual, date_creation, date_mod)
VALUES
  ('SC-WK-MS-01', 0, 1, 'Auto: finde Marco+Seb', '2026-06-13', '2026-06-14', 0, NOW(), NOW()),
  ('SC-WK-MS-02', 0, 1, 'Auto: finde Marco+Seb', '2026-06-27', '2026-06-28', 0, NOW(), NOW()),
  ('SC-WK-MS-03', 0, 1, 'Auto: finde Marco+Seb', '2026-07-11', '2026-07-12', 0, NOW(), NOW()),
  ('SC-WK-MS-04', 0, 1, 'Auto: finde Marco+Seb', '2026-07-25', '2026-07-26', 0, NOW(), NOW()),
  ('SC-WK-MS-05', 0, 1, 'Auto: finde Marco+Seb', '2026-08-08', '2026-08-09', 0, NOW(), NOW()),
  ('SC-WK-MS-06', 0, 1, 'Auto: finde Marco+Seb', '2026-08-22', '2026-08-23', 0, NOW(), NOW()),
  ('SC-WK-MS-07', 0, 1, 'Auto: finde Marco+Seb', '2026-09-05', '2026-09-06', 0, NOW(), NOW()),
  ('SC-WK-MS-08', 0, 1, 'Auto: finde Marco+Seb', '2026-09-19', '2026-09-20', 0, NOW(), NOW()),
  ('SC-WK-MS-09', 0, 1, 'Auto: finde Marco+Seb', '2026-10-03', '2026-10-04', 0, NOW(), NOW()),
  ('SC-WK-MS-10', 0, 1, 'Auto: finde Marco+Seb', '2026-10-17', '2026-10-18', 0, NOW(), NOW()),
  ('SC-WK-MS-11', 0, 1, 'Auto: finde Marco+Seb', '2026-10-31', '2026-11-01', 0, NOW(), NOW()),
  ('SC-WK-MS-12', 0, 1, 'Auto: finde Marco+Seb', '2026-11-14', '2026-11-15', 0, NOW(), NOW()),
  ('SC-WK-MS-13', 0, 1, 'Auto: finde Marco+Seb', '2026-11-28', '2026-11-29', 0, NOW(), NOW());

-- Vincular holidays MS al calendario AnthJulio (los excluye)
INSERT INTO glpi_calendars_holidays (calendars_id, holidays_id)
SELECT @cal_aj, id FROM glpi_holidays WHERE name LIKE 'SC-WK-MS-%';

-- Fines de AnthJulio (06-20 y cada 14 días) → 13 finsem.
-- Estos se vuelven FERIADO para el calendario MarcoSeb.

INSERT INTO glpi_holidays (name, entities_id, is_recursive, comment, begin_date, end_date, is_perpetual, date_creation, date_mod)
VALUES
  ('SC-WK-AJ-01', 0, 1, 'Auto: finde Anth+Julio', '2026-06-20', '2026-06-21', 0, NOW(), NOW()),
  ('SC-WK-AJ-02', 0, 1, 'Auto: finde Anth+Julio', '2026-07-04', '2026-07-05', 0, NOW(), NOW()),
  ('SC-WK-AJ-03', 0, 1, 'Auto: finde Anth+Julio', '2026-07-18', '2026-07-19', 0, NOW(), NOW()),
  ('SC-WK-AJ-04', 0, 1, 'Auto: finde Anth+Julio', '2026-08-01', '2026-08-02', 0, NOW(), NOW()),
  ('SC-WK-AJ-05', 0, 1, 'Auto: finde Anth+Julio', '2026-08-15', '2026-08-16', 0, NOW(), NOW()),
  ('SC-WK-AJ-06', 0, 1, 'Auto: finde Anth+Julio', '2026-08-29', '2026-08-30', 0, NOW(), NOW()),
  ('SC-WK-AJ-07', 0, 1, 'Auto: finde Anth+Julio', '2026-09-12', '2026-09-13', 0, NOW(), NOW()),
  ('SC-WK-AJ-08', 0, 1, 'Auto: finde Anth+Julio', '2026-09-26', '2026-09-27', 0, NOW(), NOW()),
  ('SC-WK-AJ-09', 0, 1, 'Auto: finde Anth+Julio', '2026-10-10', '2026-10-11', 0, NOW(), NOW()),
  ('SC-WK-AJ-10', 0, 1, 'Auto: finde Anth+Julio', '2026-10-24', '2026-10-25', 0, NOW(), NOW()),
  ('SC-WK-AJ-11', 0, 1, 'Auto: finde Anth+Julio', '2026-11-07', '2026-11-08', 0, NOW(), NOW()),
  ('SC-WK-AJ-12', 0, 1, 'Auto: finde Anth+Julio', '2026-11-21', '2026-11-22', 0, NOW(), NOW()),
  ('SC-WK-AJ-13', 0, 1, 'Auto: finde Anth+Julio', '2026-12-05', '2026-12-06', 0, NOW(), NOW());

-- Vincular holidays AJ al calendario MarcoSeb (los excluye)
INSERT INTO glpi_calendars_holidays (calendars_id, holidays_id)
SELECT @cal_ms, id FROM glpi_holidays WHERE name LIKE 'SC-WK-AJ-%';

-- =====================================================================
-- 5. REGLAS
-- =====================================================================
-- Regla finde Marco + Sebastian (rank 50)
INSERT INTO glpi_rules (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, uuid, `condition`, date_creation, date_mod)
VALUES (0, 'RuleTicket', 50, 'Asignacion automatica - Fin de semana Marco + Sebastian',
        'Sabado/Domingo en semana rotativa A', 'AND', 1, 'SC-WK: generado por script', 1, 'SC-WK-MS', 1, NOW(), NOW());
SET @rwk_ms = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
  (@rwk_ms, '_date_creation_calendars_id', 0, @cal_ms);
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
  (@rwk_ms, 'assign', '_users_id_assign',         @uid_marco),
  (@rwk_ms, 'append', '_users_id_assign',         @uid_sebastian),
  (@rwk_ms, 'assign', '_groups_id_assign',        @gid_soporte),
  (@rwk_ms, 'assign', '_stop_rules_processing',   1);

-- Regla finde Anthony + Julio (rank 60)
INSERT INTO glpi_rules (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, uuid, `condition`, date_creation, date_mod)
VALUES (0, 'RuleTicket', 60, 'Asignacion automatica - Fin de semana Anthony + Julio',
        'Sabado/Domingo en semana rotativa B', 'AND', 1, 'SC-WK: generado por script', 1, 'SC-WK-AJ', 1, NOW(), NOW());
SET @rwk_aj = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
  (@rwk_aj, '_date_creation_calendars_id', 0, @cal_aj);
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
  (@rwk_aj, 'assign', '_users_id_assign',         @uid_anthony),
  (@rwk_aj, 'append', '_users_id_assign',         @uid_julio),
  (@rwk_aj, 'assign', '_groups_id_assign',        @gid_soporte),
  (@rwk_aj, 'assign', '_stop_rules_processing',   1);

-- =====================================================================
-- 6. RESULTADO
-- =====================================================================
SET FOREIGN_KEY_CHECKS = 1;

SELECT 'Reglas de fin de semana creadas.' AS resultado;
SELECT id, name, cache_duration FROM glpi_calendars WHERE name LIKE 'SC-FinSemana%';
SELECT name, begin_date, end_date FROM glpi_holidays WHERE name LIKE 'SC-WK-%' ORDER BY begin_date LIMIT 5;
SELECT id, name, ranking, is_active FROM glpi_rules WHERE uuid LIKE 'SC-WK-%' ORDER BY ranking;

-- Mostrar quién tiene el próximo turno este sábado:
SELECT
  CONCAT('Proximo sabado (2026-06-13): ',
    CASE
      WHEN EXISTS (SELECT 1 FROM glpi_holidays WHERE name LIKE 'SC-WK-MS-%' AND '2026-06-13' BETWEEN begin_date AND end_date)
        THEN 'Marco Bruges + Sebastian Zarache'
      WHEN EXISTS (SELECT 1 FROM glpi_holidays WHERE name LIKE 'SC-WK-AJ-%' AND '2026-06-13' BETWEEN begin_date AND end_date)
        THEN 'Anthony Redondo + Julio Bovea'
      ELSE 'Sin asignar'
    END
  ) AS turno;
