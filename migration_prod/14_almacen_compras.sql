-- =====================================================================
-- 14_almacen_compras.sql
-- Setup: entidad ALMACEN Y COMPRAS + catalogo consumibles + ubicaciones
-- =====================================================================

START TRANSACTION;

-- =====================================================================
-- 1. ENTIDAD "ALMACEN Y COMPRAS" bajo GRUPO SANTACRUZ
-- =====================================================================
INSERT INTO glpi_entities
  (name, entities_id, completename, level, comment, date_creation, date_mod)
VALUES
  ('ALMACEN Y COMPRAS', 0, 'GRUPO SANTACRUZ > ALMACEN Y COMPRAS', 2,
   'Entidad para gestion de inventario de consumibles, papeleria, repuestos y ordenes de compra',
   NOW(), NOW());

SET @ent_almacen = LAST_INSERT_ID();

-- Limpiar cache de ancestros/hijos
UPDATE glpi_entities SET sons_cache = NULL, ancestors_cache = NULL;

-- =====================================================================
-- 2. TIPOS DE CONSUMIBLE
-- =====================================================================
INSERT INTO glpi_consumableitemtypes (name, comment, date_creation, date_mod) VALUES
-- Consumibles TI
('Tinta',              'Cartucho de tinta para impresora',              NOW(), NOW()),
('Toner',              'Toner para impresora laser',                    NOW(), NOW()),
('Cable de red',       'Cable UTP / patch cord',                        NOW(), NOW()),
('Cable de poder',     'Cable de alimentacion IEC',                     NOW(), NOW()),
('Cable HDMI / VGA',   'Cables de video',                               NOW(), NOW()),
('Adaptador',          'Convertidores / adaptadores',                   NOW(), NOW()),
('Mouse',              'Mouse USB / inalambrico',                       NOW(), NOW()),
('Teclado',            'Teclado USB / inalambrico',                     NOW(), NOW()),
('Memoria USB',        'USB / pendrive',                                NOW(), NOW()),
('Bateria UPS',        'Bateria de reemplazo para UPS',                 NOW(), NOW()),
-- Papeleria y oficina
('Papel',              'Resmas de papel carta / oficio',                NOW(), NOW()),
('Esfero / lapiz',     'Boligrafos, lapices',                           NOW(), NOW()),
('Cinta de empaque',   'Cinta adhesiva',                                NOW(), NOW()),
('Carpeta',            'Carpetas / archivadores',                       NOW(), NOW()),
('Sobre / manila',     'Sobres de correspondencia',                     NOW(), NOW()),
('Marcador',           'Marcadores tablero / permanente',               NOW(), NOW()),
('Grapas / clips',     'Insumos de oficina',                            NOW(), NOW()),
('Rollo termico POS',  'Papel termico para impresora POS',              NOW(), NOW()),
-- Repuestos y herramientas
('Repuesto electrico', 'Bombillos, interruptores, tomas',               NOW(), NOW()),
('Herramienta',        'Destornilladores, alicates, pinzas',            NOW(), NOW()),
('Tornilleria',        'Tornillos, tuercas, anclajes',                  NOW(), NOW()),
('Insumo limpieza',    'Productos de aseo / desinfeccion',              NOW(), NOW());

-- =====================================================================
-- 3. UBICACIONES DENTRO DEL ALMACEN
-- =====================================================================
-- Crear sub-ubicaciones bajo la ubicacion ALMACEN (id=145)
INSERT INTO glpi_locations
  (name, entities_id, is_recursive, locations_id, comment, date_creation, date_mod)
VALUES
('Estanteria A - Consumibles TI',  0, 1, 145, 'Toner, tinta, cables', NOW(), NOW()),
('Estanteria B - Papeleria',       0, 1, 145, 'Papel, esferos, carpetas', NOW(), NOW()),
('Estanteria C - Repuestos',       0, 1, 145, 'Repuestos y herramientas', NOW(), NOW()),
('Estanteria D - Equipos nuevos',  0, 1, 145, 'Equipos sin entregar', NOW(), NOW()),
('Estanteria E - Devoluciones',    0, 1, 145, 'Equipos devueltos / dados de baja', NOW(), NOW());

-- =====================================================================
-- 4. CATEGORIAS DE TICKET PARA ORDENES DE COMPRA / ALMACEN
-- =====================================================================
INSERT INTO glpi_itilcategories
  (name, entities_id, is_recursive, completename, level, comment, date_creation, date_mod)
VALUES
('Solicitud de compra',  0, 1, 'Solicitud de compra',  1,
 'Usuario solicita la compra de un equipo, consumible o servicio',  NOW(), NOW()),
('Solicitud de almacen', 0, 1, 'Solicitud de almacen', 1,
 'Usuario solicita entrega de un consumible existente en stock',    NOW(), NOW()),
('Devolucion a almacen', 0, 1, 'Devolucion a almacen', 1,
 'Devolucion de equipo o consumible al almacen',                    NOW(), NOW());

COMMIT;

-- =====================================================================
-- VERIFICACION
-- =====================================================================
SELECT '== ENTIDAD CREADA ==' AS info;
SELECT id, name, completename, level FROM glpi_entities WHERE name = 'ALMACEN Y COMPRAS';

SELECT '== TIPOS DE CONSUMIBLE ==' AS info;
SELECT id, name FROM glpi_consumableitemtypes ORDER BY name;

SELECT '== UBICACIONES DEL ALMACEN ==' AS info;
SELECT id, name FROM glpi_locations WHERE locations_id = 145 ORDER BY name;

SELECT '== CATEGORIAS NUEVAS ==' AS info;
SELECT id, name FROM glpi_itilcategories WHERE name IN ('Solicitud de compra','Solicitud de almacen','Devolucion a almacen');
