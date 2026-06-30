-- =====================================================================
-- 15_opcion_C_catalogos_maestros.sql
-- Fases 1 + 3 + 4: Categorias ITIL, Estados, Proveedores y Fabricantes
-- =====================================================================
-- Aplica:
--   Fase 1: Categorias ITIL jerarquicas (ODT, Fallas, Inspecciones,
--           Solicitudes) + Estados de activos
--   Fase 3: Tipos de proveedor + tipos de contacto + categorias de
--           grupo (helpdesk vs tecnicos)
--   Fase 4: Fabricantes (TI + industrial) + Estados de inventario
-- =====================================================================

START TRANSACTION;

-- =====================================================================
-- FASE 1 - CATEGORIAS ITIL JERARQUICAS
-- =====================================================================

-- ---- Padres nivel 1 ----
INSERT INTO glpi_itilcategories
  (name, entities_id, is_recursive, itilcategories_id, completename, level,
   is_helpdeskvisible, is_incident, is_request, is_problem, is_change,
   date_creation, date_mod)
VALUES
('Ordenes de Trabajo', 0, 1, 0, 'Ordenes de Trabajo', 1, 1, 0, 1, 0, 1, NOW(), NOW()),
('Fallas',             0, 1, 0, 'Fallas',             1, 1, 1, 0, 1, 0, NOW(), NOW()),
('Inspecciones',       0, 1, 0, 'Inspecciones',       1, 0, 0, 1, 0, 0, NOW(), NOW()),
('Solicitudes',        0, 1, 0, 'Solicitudes',        1, 1, 0, 1, 0, 0, NOW(), NOW());

-- Capturar IDs de los padres
SET @cat_odt   = (SELECT id FROM glpi_itilcategories WHERE name='Ordenes de Trabajo' AND itilcategories_id=0);
SET @cat_falla = (SELECT id FROM glpi_itilcategories WHERE name='Fallas' AND itilcategories_id=0);
SET @cat_insp  = (SELECT id FROM glpi_itilcategories WHERE name='Inspecciones' AND itilcategories_id=0);
SET @cat_sol   = (SELECT id FROM glpi_itilcategories WHERE name='Solicitudes' AND itilcategories_id=0);

-- ---- Hijos: Ordenes de Trabajo ----
INSERT INTO glpi_itilcategories
  (name, entities_id, is_recursive, itilcategories_id, completename, level,
   is_helpdeskvisible, is_incident, is_request, is_problem, is_change,
   date_creation, date_mod)
VALUES
('ODT - Preventiva',          0, 1, @cat_odt, CONCAT('Ordenes de Trabajo > ODT - Preventiva'),          2, 0, 0, 1, 0, 1, NOW(), NOW()),
('ODT - Correctiva',          0, 1, @cat_odt, CONCAT('Ordenes de Trabajo > ODT - Correctiva'),          2, 0, 0, 1, 0, 1, NOW(), NOW()),
('ODT - Instalacion',         0, 1, @cat_odt, CONCAT('Ordenes de Trabajo > ODT - Instalacion'),         2, 0, 0, 1, 0, 1, NOW(), NOW()),
('ODT - Mejora / Adecuacion', 0, 1, @cat_odt, CONCAT('Ordenes de Trabajo > ODT - Mejora / Adecuacion'), 2, 0, 0, 1, 0, 1, NOW(), NOW()),
('ODT - Calibracion',         0, 1, @cat_odt, CONCAT('Ordenes de Trabajo > ODT - Calibracion'),         2, 0, 0, 1, 0, 1, NOW(), NOW());

-- ---- Hijos: Fallas (tipos comunes para frigorifico + TI) ----
INSERT INTO glpi_itilcategories
  (name, entities_id, is_recursive, itilcategories_id, completename, level,
   is_helpdeskvisible, is_incident, is_request, is_problem, is_change,
   date_creation, date_mod)
VALUES
('Falla - Electrica',           0, 1, @cat_falla, 'Fallas > Falla - Electrica',           2, 1, 1, 0, 1, 0, NOW(), NOW()),
('Falla - Mecanica',             0, 1, @cat_falla, 'Fallas > Falla - Mecanica',             2, 1, 1, 0, 1, 0, NOW(), NOW()),
('Falla - Refrigeracion',        0, 1, @cat_falla, 'Fallas > Falla - Refrigeracion',        2, 1, 1, 0, 1, 0, NOW(), NOW()),
('Falla - Hidraulica',           0, 1, @cat_falla, 'Fallas > Falla - Hidraulica',           2, 1, 1, 0, 1, 0, NOW(), NOW()),
('Falla - Neumatica',            0, 1, @cat_falla, 'Fallas > Falla - Neumatica',            2, 1, 1, 0, 1, 0, NOW(), NOW()),
('Falla - Electronica/Control',  0, 1, @cat_falla, 'Fallas > Falla - Electronica/Control',  2, 1, 1, 0, 1, 0, NOW(), NOW()),
('Falla - Estructura/Civil',     0, 1, @cat_falla, 'Fallas > Falla - Estructura/Civil',     2, 1, 1, 0, 1, 0, NOW(), NOW()),
('Falla - TI / Hardware',        0, 1, @cat_falla, 'Fallas > Falla - TI / Hardware',        2, 1, 1, 0, 1, 0, NOW(), NOW()),
('Falla - TI / Software',        0, 1, @cat_falla, 'Fallas > Falla - TI / Software',        2, 1, 1, 0, 1, 0, NOW(), NOW()),
('Falla - TI / Red',             0, 1, @cat_falla, 'Fallas > Falla - TI / Red',             2, 1, 1, 0, 1, 0, NOW(), NOW()),
('Falla - TI / Impresion',       0, 1, @cat_falla, 'Fallas > Falla - TI / Impresion',       2, 1, 1, 0, 1, 0, NOW(), NOW());

-- ---- Hijos: Inspecciones ----
INSERT INTO glpi_itilcategories
  (name, entities_id, is_recursive, itilcategories_id, completename, level,
   is_helpdeskvisible, is_incident, is_request, is_problem, is_change,
   date_creation, date_mod)
VALUES
('Inspeccion - Seguridad industrial', 0, 1, @cat_insp, 'Inspecciones > Inspeccion - Seguridad industrial', 2, 0, 0, 1, 0, 0, NOW(), NOW()),
('Inspeccion - Sanitaria',            0, 1, @cat_insp, 'Inspecciones > Inspeccion - Sanitaria',            2, 0, 0, 1, 0, 0, NOW(), NOW()),
('Inspeccion - Equipos',              0, 1, @cat_insp, 'Inspecciones > Inspeccion - Equipos',              2, 0, 0, 1, 0, 0, NOW(), NOW()),
('Inspeccion - Infraestructura',      0, 1, @cat_insp, 'Inspecciones > Inspeccion - Infraestructura',      2, 0, 0, 1, 0, 0, NOW(), NOW());

-- ---- Hijos: Solicitudes (algunas adicionales a las que ya existian) ----
INSERT INTO glpi_itilcategories
  (name, entities_id, is_recursive, itilcategories_id, completename, level,
   is_helpdeskvisible, is_incident, is_request, is_problem, is_change,
   date_creation, date_mod)
VALUES
('Solicitud de servicio',     0, 1, @cat_sol, 'Solicitudes > Solicitud de servicio',     2, 1, 0, 1, 0, 0, NOW(), NOW()),
('Solicitud de informacion',  0, 1, @cat_sol, 'Solicitudes > Solicitud de informacion',  2, 1, 0, 1, 0, 0, NOW(), NOW()),
('Solicitud de acceso',       0, 1, @cat_sol, 'Solicitudes > Solicitud de acceso',       2, 1, 0, 1, 0, 0, NOW(), NOW()),
('Solicitud de cuenta usuario', 0, 1, @cat_sol, 'Solicitudes > Solicitud de cuenta usuario', 2, 1, 0, 1, 0, 0, NOW(), NOW()),
('Solicitud de capacitacion', 0, 1, @cat_sol, 'Solicitudes > Solicitud de capacitacion', 2, 1, 0, 1, 0, 0, NOW(), NOW());

-- =====================================================================
-- ESTADOS DE ACTIVOS (glpi_states)
-- =====================================================================
INSERT INTO glpi_states
  (name, entities_id, is_recursive, states_id, completename, level, comment, date_creation, date_mod)
VALUES
('Asignado',           0, 1, 0, 'Asignado',           1, 'Equipo entregado y en uso',           NOW(), NOW()),
('En stock',           0, 1, 0, 'En stock',           1, 'Disponible en almacen sin asignar',   NOW(), NOW()),
('En reparacion',      0, 1, 0, 'En reparacion',      1, 'En servicio tecnico / mantenimiento', NOW(), NOW()),
('En prestamo',        0, 1, 0, 'En prestamo',        1, 'Prestado temporalmente a un usuario', NOW(), NOW()),
('Pendiente entrega',  0, 1, 0, 'Pendiente entrega',  1, 'Recibido pero sin entregar',          NOW(), NOW()),
('Dado de baja',       0, 1, 0, 'Dado de baja',       1, 'Equipo retirado / chatarra',          NOW(), NOW()),
('Robado / Perdido',   0, 1, 0, 'Robado / Perdido',   1, 'Reporte de perdida o hurto',          NOW(), NOW()),
('Devuelto a proveedor', 0, 1, 0, 'Devuelto a proveedor', 1, 'Devolucion por garantia',       NOW(), NOW());

-- =====================================================================
-- FASE 3 - TERCEROS: Tipos de proveedor
-- =====================================================================
INSERT INTO glpi_suppliertypes (name, comment, date_creation, date_mod) VALUES
('Insumos TI',              'Computadores, periferi, consumibles TI',  NOW(), NOW()),
('Software / Licencias',    'Proveedores de software y licencias',     NOW(), NOW()),
('Telecomunicaciones',      'Internet, telefonia, datos',              NOW(), NOW()),
('Repuestos electricos',    'Componentes electricos industriales',     NOW(), NOW()),
('Repuestos mecanicos',     'Repuestos mecanicos y de motor',          NOW(), NOW()),
('Refrigeracion industrial','Compresores, evaporadores, gases',        NOW(), NOW()),
('Servicios tecnicos',      'Servicios de instalacion y soporte',      NOW(), NOW()),
('Mantenimiento general',   'Aseo, jardineria, pintura, obra civil',   NOW(), NOW()),
('Papeleria y oficina',     'Insumos administrativos',                 NOW(), NOW()),
('Dotacion y EPP',          'Uniformes, botas, guantes, EPP',          NOW(), NOW()),
('Transporte y logistica',  'Fletes, paqueteria, courier',             NOW(), NOW());

-- =====================================================================
-- FASE 3 - GRUPOS: Crear grupos de trabajo tipicos
-- =====================================================================
-- El grupo "Soporte TI" id=1 ya existe (acabamos de repararlo).
-- Agregar grupos comunes:
INSERT INTO glpi_groups
  (name, entities_id, is_recursive, groups_id, completename, level, comment,
   is_requester, is_watcher, is_assign, is_task, is_notify, is_itemgroup, is_usergroup, is_manager,
   date_creation, date_mod)
VALUES
('Mantenimiento',         0, 1, 0, 'Mantenimiento',         1, 'Equipo de mantenimiento industrial', 0, 1, 1, 1, 1, 0, 1, 0, NOW(), NOW()),
('Refrigeracion',         0, 1, 0, 'Refrigeracion',         1, 'Tecnicos de refrigeracion',          0, 1, 1, 1, 1, 0, 1, 0, NOW(), NOW()),
('Electricos',            0, 1, 0, 'Electricos',            1, 'Tecnicos electricistas',             0, 1, 1, 1, 1, 0, 1, 0, NOW(), NOW()),
('Seguridad industrial',  0, 1, 0, 'Seguridad industrial',  1, 'SST',                                0, 1, 1, 1, 1, 0, 1, 0, NOW(), NOW()),
('Almacen y compras',     0, 1, 0, 'Almacen y compras',     1, 'Personal de almacen y compras',     1, 1, 1, 1, 1, 0, 1, 0, NOW(), NOW()),
('Operaciones',           0, 1, 0, 'Operaciones',           1, 'Solicitantes generales de planta',   1, 0, 0, 0, 1, 0, 1, 0, NOW(), NOW()),
('Administrativo',        0, 1, 0, 'Administrativo',        1, 'Personal administrativo',            1, 0, 0, 0, 1, 0, 1, 0, NOW(), NOW());

-- =====================================================================
-- FASE 4 - FABRICANTES (TI + Industrial)
-- =====================================================================
-- Solo insertar los que no existan
INSERT INTO glpi_manufacturers (name, comment, date_creation, date_mod)
SELECT * FROM (
  SELECT 'Dell' AS n,             'Dell Technologies'           AS c, NOW() AS dc, NOW() AS dm UNION ALL
  SELECT 'HP',                    'Hewlett-Packard',                NOW(), NOW() UNION ALL
  SELECT 'Lenovo',                'Lenovo',                         NOW(), NOW() UNION ALL
  SELECT 'Apple',                 'Apple Inc.',                     NOW(), NOW() UNION ALL
  SELECT 'Acer',                  'Acer',                           NOW(), NOW() UNION ALL
  SELECT 'ASUS',                  'ASUS',                           NOW(), NOW() UNION ALL
  SELECT 'Samsung',                'Samsung Electronics',           NOW(), NOW() UNION ALL
  SELECT 'LG',                    'LG Electronics',                 NOW(), NOW() UNION ALL
  SELECT 'Epson',                 'Seiko Epson',                    NOW(), NOW() UNION ALL
  SELECT 'Canon',                 'Canon',                          NOW(), NOW() UNION ALL
  SELECT 'Brother',                'Brother Industries',            NOW(), NOW() UNION ALL
  SELECT 'Xerox',                 'Xerox',                          NOW(), NOW() UNION ALL
  SELECT 'Ricoh',                 'Ricoh',                          NOW(), NOW() UNION ALL
  SELECT 'Kyocera',               'Kyocera',                        NOW(), NOW() UNION ALL
  SELECT 'Zebra',                 'Zebra Technologies (etiquetas)', NOW(), NOW() UNION ALL
  SELECT 'Cisco',                 'Cisco Systems',                  NOW(), NOW() UNION ALL
  SELECT 'TP-Link',                'TP-Link',                       NOW(), NOW() UNION ALL
  SELECT 'Mikrotik',              'Mikrotik',                       NOW(), NOW() UNION ALL
  SELECT 'Fortinet',              'Fortinet',                       NOW(), NOW() UNION ALL
  SELECT 'Ubiquiti',               'Ubiquiti Networks',             NOW(), NOW() UNION ALL
  SELECT 'APC',                   'Schneider Electric / APC',       NOW(), NOW() UNION ALL
  SELECT 'Tripp Lite',             'Tripp Lite',                    NOW(), NOW() UNION ALL
  SELECT 'Logitech',               'Logitech',                      NOW(), NOW() UNION ALL
  SELECT 'Microsoft',              'Microsoft',                     NOW(), NOW() UNION ALL
  SELECT 'Yealink',                'Yealink (telefonia IP)',        NOW(), NOW() UNION ALL
  SELECT 'Grandstream',            'Grandstream',                   NOW(), NOW() UNION ALL
  -- Industrial / Refrigeracion
  SELECT 'Siemens',                'Siemens',                       NOW(), NOW() UNION ALL
  SELECT 'ABB',                    'ABB',                           NOW(), NOW() UNION ALL
  SELECT 'Schneider Electric',     'Schneider Electric',            NOW(), NOW() UNION ALL
  SELECT 'Danfoss',                'Danfoss',                       NOW(), NOW() UNION ALL
  SELECT 'Bitzer',                 'Bitzer (compresores)',          NOW(), NOW() UNION ALL
  SELECT 'Copeland',               'Copeland (compresores)',        NOW(), NOW() UNION ALL
  SELECT 'Carrier',                'Carrier',                       NOW(), NOW() UNION ALL
  SELECT 'Trane',                  'Trane',                         NOW(), NOW() UNION ALL
  SELECT 'Bohn',                   'Bohn (evaporadores)',           NOW(), NOW() UNION ALL
  SELECT 'Frick',                  'Frick',                         NOW(), NOW() UNION ALL
  SELECT 'York',                   'York',                          NOW(), NOW()
) AS t
WHERE NOT EXISTS (SELECT 1 FROM glpi_manufacturers m WHERE m.name = t.n);

COMMIT;

-- =====================================================================
-- VERIFICACION
-- =====================================================================
SELECT '== CATEGORIAS ITIL ==' AS info;
SELECT id, name, completename, level FROM glpi_itilcategories ORDER BY level, completename;

SELECT '== ESTADOS ==' AS info;
SELECT id, name FROM glpi_states ORDER BY name;

SELECT '== TIPOS DE PROVEEDOR ==' AS info;
SELECT id, name FROM glpi_suppliertypes ORDER BY name;

SELECT '== GRUPOS ==' AS info;
SELECT id, name, completename FROM glpi_groups ORDER BY name;

SELECT '== FABRICANTES (total) ==' AS info;
SELECT COUNT(*) AS total FROM glpi_manufacturers;
SELECT id, name FROM glpi_manufacturers ORDER BY name;
