-- =====================================================================
-- 16_categorias_aplicaciones_negocio.sql
-- Agrega categorias de soporte a aplicaciones de negocio:
--   SIESA (PDV, Planta, Administrativo) + FRIGOAPP (Planta)
-- Sirven tanto para solicitudes como para incidentes (fallas)
-- =====================================================================

START TRANSACTION;

-- ---- Padre nivel 1: Soporte Aplicaciones ----
INSERT INTO glpi_itilcategories
  (name, entities_id, is_recursive, itilcategories_id, completename, level,
   is_helpdeskvisible, is_incident, is_request, is_problem, is_change,
   date_creation, date_mod)
VALUES
('Soporte Aplicaciones', 0, 1, 0, 'Soporte Aplicaciones', 1, 1, 1, 1, 1, 0, NOW(), NOW());

SET @cat_apps = (SELECT id FROM glpi_itilcategories WHERE name='Soporte Aplicaciones' AND itilcategories_id=0);

-- ---- Hijos nivel 2: por aplicacion ----
INSERT INTO glpi_itilcategories
  (name, entities_id, is_recursive, itilcategories_id, completename, level,
   is_helpdeskvisible, is_incident, is_request, is_problem, is_change,
   date_creation, date_mod)
VALUES
('SIESA',     0, 1, @cat_apps, 'Soporte Aplicaciones > SIESA',     2, 1, 1, 1, 1, 0, NOW(), NOW()),
('FRIGOAPP',  0, 1, @cat_apps, 'Soporte Aplicaciones > FRIGOAPP',  2, 1, 1, 1, 1, 0, NOW(), NOW()),
('Office / Correo', 0, 1, @cat_apps, 'Soporte Aplicaciones > Office / Correo', 2, 1, 1, 1, 1, 0, NOW(), NOW()),
('WhatsApp Business / Mensajeria', 0, 1, @cat_apps, 'Soporte Aplicaciones > WhatsApp Business / Mensajeria', 2, 1, 1, 1, 1, 0, NOW(), NOW()),
('Otros aplicativos', 0, 1, @cat_apps, 'Soporte Aplicaciones > Otros aplicativos', 2, 1, 1, 1, 1, 0, NOW(), NOW());

SET @cat_siesa = (SELECT id FROM glpi_itilcategories WHERE name='SIESA' AND itilcategories_id=@cat_apps);
SET @cat_friapp = (SELECT id FROM glpi_itilcategories WHERE name='FRIGOAPP' AND itilcategories_id=@cat_apps);

-- ---- Hijos nivel 3: SIESA por contexto ----
INSERT INTO glpi_itilcategories
  (name, entities_id, is_recursive, itilcategories_id, completename, level,
   is_helpdeskvisible, is_incident, is_request, is_problem, is_change,
   date_creation, date_mod)
VALUES
('SIESA - Punto de Venta (POS)',   0, 1, @cat_siesa,
 'Soporte Aplicaciones > SIESA > SIESA - Punto de Venta (POS)',     3, 1, 1, 1, 1, 0, NOW(), NOW()),
('SIESA - Facturacion',            0, 1, @cat_siesa,
 'Soporte Aplicaciones > SIESA > SIESA - Facturacion',              3, 1, 1, 1, 1, 0, NOW(), NOW()),
('SIESA - Inventarios',            0, 1, @cat_siesa,
 'Soporte Aplicaciones > SIESA > SIESA - Inventarios',              3, 1, 1, 1, 1, 0, NOW(), NOW()),
('SIESA - Contabilidad y Tesoreria', 0, 1, @cat_siesa,
 'Soporte Aplicaciones > SIESA > SIESA - Contabilidad y Tesoreria', 3, 1, 1, 1, 1, 0, NOW(), NOW()),
('SIESA - Nomina y RRHH',          0, 1, @cat_siesa,
 'Soporte Aplicaciones > SIESA > SIESA - Nomina y RRHH',            3, 1, 1, 1, 1, 0, NOW(), NOW()),
('SIESA - Compras',                0, 1, @cat_siesa,
 'Soporte Aplicaciones > SIESA > SIESA - Compras',                  3, 1, 1, 1, 1, 0, NOW(), NOW()),
('SIESA - Reportes / Informes',    0, 1, @cat_siesa,
 'Soporte Aplicaciones > SIESA > SIESA - Reportes / Informes',      3, 1, 1, 1, 1, 0, NOW(), NOW()),
('SIESA - Acceso / Usuarios',      0, 1, @cat_siesa,
 'Soporte Aplicaciones > SIESA > SIESA - Acceso / Usuarios',        3, 1, 1, 1, 1, 0, NOW(), NOW()),
('SIESA - Impresion (facturas/tirilla)', 0, 1, @cat_siesa,
 'Soporte Aplicaciones > SIESA > SIESA - Impresion (facturas/tirilla)', 3, 1, 1, 1, 1, 0, NOW(), NOW());

-- ---- Hijos nivel 3: FRIGOAPP por modulo (planta) ----
INSERT INTO glpi_itilcategories
  (name, entities_id, is_recursive, itilcategories_id, completename, level,
   is_helpdeskvisible, is_incident, is_request, is_problem, is_change,
   date_creation, date_mod)
VALUES
('FRIGOAPP - Ingreso / Sacrificio',   0, 1, @cat_friapp,
 'Soporte Aplicaciones > FRIGOAPP > FRIGOAPP - Ingreso / Sacrificio',   3, 1, 1, 1, 1, 0, NOW(), NOW()),
('FRIGOAPP - Despostado / Despiece',  0, 1, @cat_friapp,
 'Soporte Aplicaciones > FRIGOAPP > FRIGOAPP - Despostado / Despiece',  3, 1, 1, 1, 1, 0, NOW(), NOW()),
('FRIGOAPP - Pesaje',                 0, 1, @cat_friapp,
 'Soporte Aplicaciones > FRIGOAPP > FRIGOAPP - Pesaje',                 3, 1, 1, 1, 1, 0, NOW(), NOW()),
('FRIGOAPP - Etiquetado / Trazabilidad', 0, 1, @cat_friapp,
 'Soporte Aplicaciones > FRIGOAPP > FRIGOAPP - Etiquetado / Trazabilidad', 3, 1, 1, 1, 1, 0, NOW(), NOW()),
('FRIGOAPP - Despacho',               0, 1, @cat_friapp,
 'Soporte Aplicaciones > FRIGOAPP > FRIGOAPP - Despacho',               3, 1, 1, 1, 1, 0, NOW(), NOW()),
('FRIGOAPP - Reportes',               0, 1, @cat_friapp,
 'Soporte Aplicaciones > FRIGOAPP > FRIGOAPP - Reportes',               3, 1, 1, 1, 1, 0, NOW(), NOW()),
('FRIGOAPP - Acceso / Usuarios',      0, 1, @cat_friapp,
 'Soporte Aplicaciones > FRIGOAPP > FRIGOAPP - Acceso / Usuarios',      3, 1, 1, 1, 1, 0, NOW(), NOW());

COMMIT;

SELECT '== JERARQUIA SOPORTE APLICACIONES ==' AS info;
SELECT id, name, completename, level FROM glpi_itilcategories
WHERE completename LIKE 'Soporte Aplicaciones%'
ORDER BY completename;
