-- =====================================================================
-- 18_fix_orden_reglas.sql
-- Reordena las reglas nuevas a rankings 1-9 (antes de los turnos) y
-- agrega "_stop_rules_processing" donde corresponde para que las
-- reglas de turno (10-99) no sobreescriban las asignaciones de
-- categorias no-TI (Refrigeracion, Electricos, Mantenimiento, Almacen).
-- =====================================================================
--
-- LOGICA DE EJECUCION (orden ASC por ranking):
--   1-3: Asignar SIESA/FRIGOAPP -> Soporte TI (NO STOP: deja que
--        las reglas de turno asignen el usuario tecnico de turno)
--   4-9: Asignar Fallas/ODT/Compras a grupos especificos (STOP:
--        no necesitan asignar usuario de turno)
--   10-99: Reglas de turno existentes (asignan usuario+grupo Soporte TI)
-- =====================================================================

START TRANSACTION;

-- Re-rankear reglas nuevas a 1-9
UPDATE glpi_rules SET ranking = 1 WHERE name = 'Asignar SIESA POS -> Soporte TI (Muy Alta)';
UPDATE glpi_rules SET ranking = 2 WHERE name = 'Asignar SIESA -> Soporte TI';
UPDATE glpi_rules SET ranking = 3 WHERE name = 'Asignar FRIGOAPP -> Soporte TI (Alta)';
UPDATE glpi_rules SET ranking = 4 WHERE name = 'Asignar Falla Refrigeracion -> Refrigeracion (Muy Alta)';
UPDATE glpi_rules SET ranking = 5 WHERE name = 'Asignar Falla Electrica -> Electricos';
UPDATE glpi_rules SET ranking = 6 WHERE name = 'Asignar Falla Mecanica -> Mantenimiento';
UPDATE glpi_rules SET ranking = 7 WHERE name = 'Asignar Falla TI -> Soporte TI';
UPDATE glpi_rules SET ranking = 8 WHERE name = 'Asignar ODT -> Mantenimiento';
UPDATE glpi_rules SET ranking = 9 WHERE name = 'Asignar Compras/Almacen -> Almacen y compras';

-- Agregar _stop_rules_processing a reglas que asignan a grupos NO-TI
-- (asi las reglas de turno 10-99 no las sobreescriben)
SET @r4 = (SELECT id FROM glpi_rules WHERE name = 'Asignar Falla Refrigeracion -> Refrigeracion (Muy Alta)');
SET @r5 = (SELECT id FROM glpi_rules WHERE name = 'Asignar Falla Electrica -> Electricos');
SET @r6 = (SELECT id FROM glpi_rules WHERE name = 'Asignar Falla Mecanica -> Mantenimiento');
SET @r8 = (SELECT id FROM glpi_rules WHERE name = 'Asignar ODT -> Mantenimiento');
SET @r9 = (SELECT id FROM glpi_rules WHERE name = 'Asignar Compras/Almacen -> Almacen y compras');

INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
(@r4, 'assign', '_stop_rules_processing', 1),
(@r5, 'assign', '_stop_rules_processing', 1),
(@r6, 'assign', '_stop_rules_processing', 1),
(@r8, 'assign', '_stop_rules_processing', 1),
(@r9, 'assign', '_stop_rules_processing', 1);

COMMIT;

-- =====================================================================
-- VERIFICACION ORDEN FINAL
-- =====================================================================
SELECT id, ranking, name, is_active
FROM glpi_rules
WHERE sub_type='RuleTicket' AND is_active = 1
ORDER BY ranking, id;
