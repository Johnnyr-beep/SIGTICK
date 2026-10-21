-- =====================================================================
-- 17_plantillas_y_reglas_asignacion.sql
-- Fase 2 (Opcion A) - Plantillas de Ticket + Reglas de Asignacion
-- =====================================================================
-- Crea:
--   A) 7 plantillas de ticket con categoria/tipo/urgencia predefinidos
--   B) 9 reglas de asignacion automatica por categoria
-- =====================================================================

START TRANSACTION;

-- =====================================================================
-- A) PLANTILLAS DE TICKET
-- =====================================================================
-- Campos predefinidos (glpi_tickettemplatepredefinedfields.num):
--   1  = name (titulo)
--   7  = itilcategories_id
--   10 = urgency  (1=muy baja, 2=baja, 3=media, 4=alta, 5=muy alta)
--   11 = impact
--   14 = type (1=Incidente, 2=Solicitud)
-- =====================================================================

INSERT INTO glpi_tickettemplates (name, entities_id, is_recursive, comment) VALUES
('ODT - Orden de Trabajo',          0, 1, 'Orden de Trabajo de mantenimiento'),
('Falla Industrial',                0, 1, 'Reporte de falla en equipo industrial'),
('Soporte SIESA - Punto de Venta',  0, 1, 'Soporte SIESA en PDV (alta urgencia)'),
('Soporte SIESA - Administrativo',  0, 1, 'Soporte SIESA en oficinas administrativas / planta'),
('Soporte FRIGOAPP - Planta',       0, 1, 'Soporte FRIGOAPP - operacion planta'),
('Soporte TI General',              0, 1, 'Soporte de TI (hardware/software/red)'),
('Solicitud General',               0, 1, 'Plantilla generica de solicitud');

-- Capturar IDs
SET @tpl_odt        = (SELECT id FROM glpi_tickettemplates WHERE name='ODT - Orden de Trabajo');
SET @tpl_falla      = (SELECT id FROM glpi_tickettemplates WHERE name='Falla Industrial');
SET @tpl_siesapdv   = (SELECT id FROM glpi_tickettemplates WHERE name='Soporte SIESA - Punto de Venta');
SET @tpl_siesaadmin = (SELECT id FROM glpi_tickettemplates WHERE name='Soporte SIESA - Administrativo');
SET @tpl_frigoapp   = (SELECT id FROM glpi_tickettemplates WHERE name='Soporte FRIGOAPP - Planta');
SET @tpl_titi       = (SELECT id FROM glpi_tickettemplates WHERE name='Soporte TI General');
SET @tpl_sol        = (SELECT id FROM glpi_tickettemplates WHERE name='Solicitud General');

-- Capturar IDs de categorias (de scripts 15 y 16)
SET @cat_odt_pad     = (SELECT id FROM glpi_itilcategories WHERE name='Ordenes de Trabajo' AND itilcategories_id=0);
SET @cat_falla_pad   = (SELECT id FROM glpi_itilcategories WHERE name='Fallas' AND itilcategories_id=0);
SET @cat_sol_pad     = (SELECT id FROM glpi_itilcategories WHERE name='Solicitudes' AND itilcategories_id=0);
SET @cat_apps_pad    = (SELECT id FROM glpi_itilcategories WHERE name='Soporte Aplicaciones' AND itilcategories_id=0);
SET @cat_siesa_pad   = (SELECT id FROM glpi_itilcategories WHERE name='SIESA' AND itilcategories_id=@cat_apps_pad);
SET @cat_frigoapp_pad = (SELECT id FROM glpi_itilcategories WHERE name='FRIGOAPP' AND itilcategories_id=@cat_apps_pad);
SET @cat_siesapdv    = (SELECT id FROM glpi_itilcategories WHERE name='SIESA - Punto de Venta (POS)' AND itilcategories_id=@cat_siesa_pad);

-- Insertar campos predefinidos
INSERT INTO glpi_tickettemplatepredefinedfields (tickettemplates_id, num, value) VALUES
-- ODT: categoria padre ODT, tipo Solicitud, urgencia media
(@tpl_odt, 7, @cat_odt_pad),
(@tpl_odt, 14, 2),
(@tpl_odt, 10, 3),

-- Falla Industrial: categoria padre Fallas, tipo Incidente, urgencia alta
(@tpl_falla, 7, @cat_falla_pad),
(@tpl_falla, 14, 1),
(@tpl_falla, 10, 4),

-- Soporte SIESA PDV: categoria especifica POS, tipo Incidente, urgencia muy alta
(@tpl_siesapdv, 7, @cat_siesapdv),
(@tpl_siesapdv, 14, 1),
(@tpl_siesapdv, 10, 5),

-- Soporte SIESA Administrativo: categoria padre SIESA, tipo Incidente, urgencia media
(@tpl_siesaadmin, 7, @cat_siesa_pad),
(@tpl_siesaadmin, 14, 1),
(@tpl_siesaadmin, 10, 3),

-- Soporte FRIGOAPP: categoria padre FRIGOAPP, tipo Incidente, urgencia alta
(@tpl_frigoapp, 7, @cat_frigoapp_pad),
(@tpl_frigoapp, 14, 1),
(@tpl_frigoapp, 10, 4),

-- Soporte TI General: tipo Incidente, urgencia media
(@tpl_titi, 14, 1),
(@tpl_titi, 10, 3),

-- Solicitud General: categoria padre Solicitudes, tipo Solicitud, urgencia media
(@tpl_sol, 7, @cat_sol_pad),
(@tpl_sol, 14, 2),
(@tpl_sol, 10, 3);

-- =====================================================================
-- B) REGLAS DE ASIGNACION AUTOMATICA
-- =====================================================================
-- Capturar IDs de grupos
SET @g_ti        = (SELECT id FROM glpi_groups WHERE name='Soporte TI');
SET @g_mant      = (SELECT id FROM glpi_groups WHERE name='Mantenimiento');
SET @g_refri     = (SELECT id FROM glpi_groups WHERE name='Refrigeracion');
SET @g_elec      = (SELECT id FROM glpi_groups WHERE name='Electricos');
SET @g_alm       = (SELECT id FROM glpi_groups WHERE name='Almacen y compras');

-- Conditions para reglas:
--   0 = is
--   2 = contains (en texto)
--   7 = under tree (cubre toda la jerarquia descendente)
-- =====================================================================

-- Regla 1: SIESA POS -> Soporte TI + urgencia muy alta
INSERT INTO glpi_rules
  (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, `condition`, date_creation, date_mod, uuid)
VALUES
(0, 'RuleTicket', 10, 'Asignar SIESA POS -> Soporte TI (Muy Alta)',
 'Si la categoria es SIESA - Punto de Venta, asigna a Soporte TI con urgencia maxima',
 'AND', 1, '', 1, 1, NOW(), NOW(), UUID());
SET @r1 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
(@r1, 'itilcategories_id', 0, @cat_siesapdv);
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
(@r1, 'assign', '_groups_id_assign', @g_ti),
(@r1, 'assign', 'urgency', 5);

-- Regla 2: cualquier hijo de SIESA -> Soporte TI
INSERT INTO glpi_rules
  (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, `condition`, date_creation, date_mod, uuid)
VALUES
(0, 'RuleTicket', 20, 'Asignar SIESA -> Soporte TI',
 'Cualquier categoria bajo SIESA se asigna al grupo Soporte TI',
 'AND', 1, '', 1, 1, NOW(), NOW(), UUID());
SET @r2 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
(@r2, 'itilcategories_id', 7, @cat_siesa_pad);
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
(@r2, 'assign', '_groups_id_assign', @g_ti);

-- Regla 3: cualquier hijo de FRIGOAPP -> Soporte TI + urgencia alta
INSERT INTO glpi_rules
  (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, `condition`, date_creation, date_mod, uuid)
VALUES
(0, 'RuleTicket', 30, 'Asignar FRIGOAPP -> Soporte TI (Alta)',
 'Cualquier categoria bajo FRIGOAPP se asigna a Soporte TI con urgencia alta',
 'AND', 1, '', 1, 1, NOW(), NOW(), UUID());
SET @r3 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
(@r3, 'itilcategories_id', 7, @cat_frigoapp_pad);
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
(@r3, 'assign', '_groups_id_assign', @g_ti),
(@r3, 'assign', 'urgency', 4);

-- Regla 4: Falla - Refrigeracion -> grupo Refrigeracion + urgencia muy alta
SET @cat_falla_refri = (SELECT id FROM glpi_itilcategories WHERE name='Falla - Refrigeracion');
INSERT INTO glpi_rules
  (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, `condition`, date_creation, date_mod, uuid)
VALUES
(0, 'RuleTicket', 40, 'Asignar Falla Refrigeracion -> Refrigeracion (Muy Alta)',
 'Fallas de refrigeracion van al equipo de refrigeracion con maxima urgencia',
 'AND', 1, '', 1, 1, NOW(), NOW(), UUID());
SET @r4 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
(@r4, 'itilcategories_id', 0, @cat_falla_refri);
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
(@r4, 'assign', '_groups_id_assign', @g_refri),
(@r4, 'assign', 'urgency', 5);

-- Regla 5: Falla - Electrica -> grupo Electricos
SET @cat_falla_elec = (SELECT id FROM glpi_itilcategories WHERE name='Falla - Electrica');
INSERT INTO glpi_rules
  (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, `condition`, date_creation, date_mod, uuid)
VALUES
(0, 'RuleTicket', 50, 'Asignar Falla Electrica -> Electricos',
 'Fallas electricas van al grupo de electricistas',
 'AND', 1, '', 1, 1, NOW(), NOW(), UUID());
SET @r5 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
(@r5, 'itilcategories_id', 0, @cat_falla_elec);
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
(@r5, 'assign', '_groups_id_assign', @g_elec),
(@r5, 'assign', 'urgency', 4);

-- Regla 6: Falla - Mecanica / Hidraulica / Neumatica / Estructura -> grupo Mantenimiento
-- (una regla por cada por simplicidad)
SET @cat_falla_mec = (SELECT id FROM glpi_itilcategories WHERE name='Falla - Mecanica');
INSERT INTO glpi_rules
  (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, `condition`, date_creation, date_mod, uuid)
VALUES
(0, 'RuleTicket', 60, 'Asignar Falla Mecanica -> Mantenimiento',
 'Fallas mecanicas al equipo de mantenimiento general',
 'AND', 1, '', 1, 1, NOW(), NOW(), UUID());
SET @r6 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
(@r6, 'itilcategories_id', 0, @cat_falla_mec);
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
(@r6, 'assign', '_groups_id_assign', @g_mant),
(@r6, 'assign', 'urgency', 4);

-- Regla 7: cualquier "Falla - TI / *" -> Soporte TI
-- Como son varias, usamos OR de varias condiciones (match=OR)
INSERT INTO glpi_rules
  (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, `condition`, date_creation, date_mod, uuid)
VALUES
(0, 'RuleTicket', 70, 'Asignar Falla TI -> Soporte TI',
 'Cualquier falla relacionada con TI se asigna a Soporte TI',
 'OR', 1, '', 1, 1, NOW(), NOW(), UUID());
SET @r7 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern)
SELECT @r7, 'itilcategories_id', 0, id
FROM glpi_itilcategories
WHERE name IN ('Falla - TI / Hardware','Falla - TI / Software','Falla - TI / Red','Falla - TI / Impresion');
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
(@r7, 'assign', '_groups_id_assign', @g_ti);

-- Regla 8: cualquier hijo de "Ordenes de Trabajo" -> Mantenimiento
INSERT INTO glpi_rules
  (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, `condition`, date_creation, date_mod, uuid)
VALUES
(0, 'RuleTicket', 80, 'Asignar ODT -> Mantenimiento',
 'Cualquier ODT se asigna al equipo de mantenimiento',
 'AND', 1, '', 1, 1, NOW(), NOW(), UUID());
SET @r8 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern) VALUES
(@r8, 'itilcategories_id', 7, @cat_odt_pad);
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
(@r8, 'assign', '_groups_id_assign', @g_mant);

-- Regla 9: Solicitud de compra / almacen / devolucion -> Almacen y compras
INSERT INTO glpi_rules
  (entities_id, sub_type, ranking, name, description, `match`, is_active, comment, is_recursive, `condition`, date_creation, date_mod, uuid)
VALUES
(0, 'RuleTicket', 90, 'Asignar Compras/Almacen -> Almacen y compras',
 'Solicitudes de compra, almacen y devoluciones van al grupo de Almacen',
 'OR', 1, '', 1, 1, NOW(), NOW(), UUID());
SET @r9 = LAST_INSERT_ID();
INSERT INTO glpi_rulecriterias (rules_id, criteria, `condition`, pattern)
SELECT @r9, 'itilcategories_id', 0, id
FROM glpi_itilcategories
WHERE name IN ('Solicitud de compra','Solicitud de almacen','Devolucion a almacen');
INSERT INTO glpi_ruleactions (rules_id, action_type, field, value) VALUES
(@r9, 'assign', '_groups_id_assign', @g_alm);

COMMIT;

-- =====================================================================
-- VERIFICACION
-- =====================================================================
SELECT '== PLANTILLAS ==' AS info;
SELECT id, name FROM glpi_tickettemplates ORDER BY name;

SELECT '== CAMPOS PREDEFINIDOS POR PLANTILLA ==' AS info;
SELECT t.name AS plantilla, p.num, p.value
FROM glpi_tickettemplatepredefinedfields p
JOIN glpi_tickettemplates t ON t.id = p.tickettemplates_id
ORDER BY t.name, p.num;

SELECT '== REGLAS ==' AS info;
SELECT id, ranking, name, is_active FROM glpi_rules WHERE sub_type='RuleTicket' ORDER BY ranking;

SELECT '== CRITERIOS POR REGLA ==' AS info;
SELECT r.name AS regla, c.criteria, c.`condition`, c.pattern
FROM glpi_rulecriterias c
JOIN glpi_rules r ON r.id = c.rules_id
WHERE r.sub_type='RuleTicket'
ORDER BY r.ranking, c.id;

SELECT '== ACCIONES POR REGLA ==' AS info;
SELECT r.name AS regla, a.action_type, a.field, a.value
FROM glpi_ruleactions a
JOIN glpi_rules r ON r.id = a.rules_id
WHERE r.sub_type='RuleTicket'
ORDER BY r.ranking, a.id;

