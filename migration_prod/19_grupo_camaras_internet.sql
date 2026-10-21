-- =====================================================================
-- 19_grupo_camaras_internet.sql
-- Agrega categoria "Falla - Camaras / CCTV", crea regla de asignacion
-- para Red+Camaras al nuevo grupo y quita "Red" de la regla generica
-- de "Falla TI -> Soporte TI"
-- =====================================================================

START TRANSACTION;

-- =====================================================================
-- 1. Agregar categoria "Falla - Camaras / CCTV"
-- =====================================================================
SET @cat_falla_pad = (SELECT id FROM glpi_itilcategories WHERE name='Fallas' AND itilcategories_id=0);

INSERT INTO glpi_itilcategories
  (name, entities_id, is_recursive, itilcategories_id, completename, level,
   is_helpdeskvisible, is_incident, is_request, is_problem, is_change,
   date_creation, date_mod)
VALUES
('Falla - Camaras / CCTV', 0, 1, @cat_falla_pad,
 'Fallas > Falla - Camaras / CCTV', 2, 1, 1, 0, 1, 0, NOW(), NOW());

SET @cat_camaras = LAST_INSERT_ID();
SET @cat_red = (SELECT id FROM glpi_itilcategories WHERE name='Falla - TI / Red');
SET @grp_camint = (SELECT id FROM glpi_groups WHERE name='Camaras e Internet');

-- =====================================================================
-- 2. Quitar "Falla - TI / Red" de la regla "Falla TI -> Soporte TI"
-- =====================================================================
SET @regla_falla_ti = (SELECT id FROM glpi_rules WHERE name='Asignar Falla TI -> Soporte TI');
DELETE FROM glpi_rulecriterias
WHERE rules_id = @regla_falla_ti AND pattern = CAST(@cat_red AS CHAR);

-- =====================================================================
-- 3. Crear nueva regla "Asignar Falla Red/Camaras -> Camaras e Internet"
-- =====================================================================
INSERT INTO glpi_rules
  (entities_id, sub_type, ranking, name, description, `match`, is_active,
   comment, is_recursive, `condition`, date_creation, date_mod, uuid)
VALUES
(0, 'RuleTicket', 7, 'Asignar Falla Red/Camaras -> Camaras e Internet',
 'Fallas de red (internet) y camaras CCTV se asignan al grupo Camaras e Internet',
 'OR', 1, '', 1, 1, NOW(), NOW(), UUID());
SET @nueva = LAST_INSERT_ID();

INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
(@nueva, 'itilcategories_id', 0, @cat_red),
(@nueva, 'itilcategories_id', 0, @cat_camaras);

INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
(@nueva, 'assign', '_groups_id_assign', @grp_camint),
(@nueva, 'assign', 'urgency', 4),
(@nueva, 'assign', '_stop_rules_processing', 1);

-- =====================================================================
-- 4. Re-rankear para que la nueva quede en 7 y las siguientes bajen 1
-- =====================================================================
UPDATE glpi_rules SET ranking = 8 WHERE name = 'Asignar Falla TI -> Soporte TI';
UPDATE glpi_rules SET ranking = 9 WHERE name = 'Asignar ODT -> Mantenimiento';
UPDATE glpi_rules SET ranking = 10 WHERE name = 'Asignar Compras/Almacen -> Almacen y compras';

COMMIT;

-- =====================================================================
-- VERIFICACION
-- =====================================================================
SELECT '== NUEVA CATEGORIA ==' AS info;
SELECT id, name, completename FROM glpi_itilcategories WHERE name = 'Falla - Camaras / CCTV';

SELECT '== ORDEN FINAL DE REGLAS ACTIVAS ==' AS info;
SELECT id, ranking, name FROM glpi_rules
WHERE sub_type='RuleTicket' AND is_active = 1 AND name LIKE 'Asignar%'
ORDER BY ranking;

SELECT '== CRITERIOS DE LAS REGLAS DE RED/CAMARAS/FALLA TI ==' AS info;
SELECT r.name, c.criteria, c.`condition`, c.pattern, cat.name AS categoria
FROM glpi_rulecriterias c
JOIN glpi_rules r ON r.id = c.rules_id
LEFT JOIN glpi_itilcategories cat ON cat.id = c.pattern
WHERE r.name IN ('Asignar Falla TI -> Soporte TI', 'Asignar Falla Red/Camaras -> Camaras e Internet')
ORDER BY r.name, c.id;
