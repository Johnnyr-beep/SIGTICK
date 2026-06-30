-- =====================================================================
-- 13_catalogo_tipos_limpio.sql
-- Catalogo estandarizado de TIPOS para Grupo Santacruz
-- Tablas: glpi_computertypes / monitortypes / printertypes /
--         networkequipmenttypes / peripheraltypes / phonetypes
-- Columnas: id, name, comment, date_mod, date_creation
-- =====================================================================

START TRANSACTION;

-- =====================================================================
-- 1. COMPUTADORES
-- =====================================================================
INSERT INTO glpi_computertypes (name, comment, date_creation, date_mod) VALUES
('Portatil',          'Equipo portatil / laptop',           NOW(), NOW()),
('Todo en Uno',       'All-in-One (AIO)',                   NOW(), NOW()),
('Torre',             'Desktop formato torre',              NOW(), NOW()),
('Micro Torre / SFF', 'Small Form Factor',                  NOW(), NOW()),
('Mini PC',           'Mini PC / NUC / Thin Client',        NOW(), NOW()),
('Servidor',          'Servidor fisico',                    NOW(), NOW()),
('Servidor PBX',      'Servidor de telefonia / conmutador', NOW(), NOW()),
('Estacion POS',      'Equipo punto de venta / retail',     NOW(), NOW());

-- Reasignar el unico equipo existente (Escritorio NUC, id=8) al nuevo "Mini PC"
UPDATE glpi_computers
SET computertypes_id = (SELECT id FROM glpi_computertypes WHERE name = 'Mini PC' LIMIT 1)
WHERE computertypes_id = 8;

-- Borrar todos los tipos antiguos (duplicados / typos / mal clasificados)
DELETE FROM glpi_computertypes
WHERE name NOT IN (
  'Portatil','Todo en Uno','Torre','Micro Torre / SFF','Mini PC',
  'Servidor','Servidor PBX','Estacion POS'
);

-- =====================================================================
-- 2. MONITORES
-- =====================================================================
INSERT INTO glpi_monitortypes (name, comment, date_creation, date_mod) VALUES
('LED',     'Pantalla LED estandar',       NOW(), NOW()),
('LCD',     'Pantalla LCD',                NOW(), NOW()),
('OLED',    'Pantalla OLED',               NOW(), NOW()),
('Touch',   'Monitor tactil',              NOW(), NOW()),
('Curvo',   'Monitor curvo',               NOW(), NOW()),
('POS',     'Monitor para punto de venta', NOW(), NOW());

-- =====================================================================
-- 3. IMPRESORAS
-- =====================================================================
INSERT INTO glpi_printertypes (name, comment, date_creation, date_mod) VALUES
('Laser',             'Impresora laser',                 NOW(), NOW()),
('Tinta',             'Impresora de inyeccion de tinta', NOW(), NOW()),
('Termica',           'Impresora termica',               NOW(), NOW()),
('Multifuncional',    'Impresora multifuncional (MFP)',  NOW(), NOW()),
('Matriz de puntos',  'Impresora de matriz de puntos',   NOW(), NOW()),
('Etiquetadora',      'Impresora de etiquetas / Zebra',  NOW(), NOW()),
('POS',               'Impresora de tirilla / facturas', NOW(), NOW());

-- =====================================================================
-- 4. EQUIPOS DE RED
-- =====================================================================
INSERT INTO glpi_networkequipmenttypes (name, comment, date_creation, date_mod) VALUES
('Switch',        'Switch de red',           NOW(), NOW()),
('Router',        'Router / enrutador',      NOW(), NOW()),
('Access Point',  'Punto de acceso WiFi',    NOW(), NOW()),
('Firewall',      'Firewall / UTM',          NOW(), NOW()),
('Modem',         'Modem ISP',               NOW(), NOW()),
('Hub',           'Concentrador',            NOW(), NOW()),
('Balanceador',   'Balanceador de carga',    NOW(), NOW()),
('Controladora',  'Controladora WiFi / SDN', NOW(), NOW());

-- =====================================================================
-- 5. PERIFERICOS
-- =====================================================================
INSERT INTO glpi_peripheraltypes (name, comment, date_creation, date_mod) VALUES
('Teclado',                 'Teclado USB / inalambrico',              NOW(), NOW()),
('Mouse',                   'Mouse USB / inalambrico',                NOW(), NOW()),
('Escaner',                 'Escaner de documentos',                  NOW(), NOW()),
('Lector codigo de barras', 'Pistola lectora de codigo',              NOW(), NOW()),
('Camara web',              'Webcam',                                 NOW(), NOW()),
('Audifonos',               'Audifonos / diadema',                    NOW(), NOW()),
('Parlante',                'Parlante / altavoz',                     NOW(), NOW()),
('UPS',                     'Sistema de alimentacion ininterrumpida', NOW(), NOW()),
('Disco externo',           'Disco duro externo / SSD externo',       NOW(), NOW()),
('Memoria USB',             'USB / pendrive',                         NOW(), NOW()),
('Docking Station',         'Replicador de puertos',                  NOW(), NOW()),
('Cajon monedero',          'Cajon de dinero POS',                    NOW(), NOW()),
('Pinpad',                  'Datafono / pinpad bancario',             NOW(), NOW());

-- =====================================================================
-- 6. TELEFONOS
-- =====================================================================
INSERT INTO glpi_phonetypes (name, comment, date_creation, date_mod) VALUES
('IP',          'Telefono IP',                  NOW(), NOW()),
('Analogo',     'Telefono analogo',             NOW(), NOW()),
('Inalambrico', 'Telefono inalambrico / DECT',  NOW(), NOW()),
('Movil',       'Telefono celular corporativo', NOW(), NOW()),
('Conmutador',  'PBX / central telefonica',     NOW(), NOW()),
('Softphone',   'Softphone (PC/movil)',         NOW(), NOW());

COMMIT;

-- =====================================================================
-- VERIFICACION
-- =====================================================================
SELECT '== COMPUTADORES ==' AS info;
SELECT id, name FROM glpi_computertypes ORDER BY name;
SELECT '== MONITORES ==' AS info;
SELECT id, name FROM glpi_monitortypes ORDER BY name;
SELECT '== IMPRESORAS ==' AS info;
SELECT id, name FROM glpi_printertypes ORDER BY name;
SELECT '== EQUIPOS DE RED ==' AS info;
SELECT id, name FROM glpi_networkequipmenttypes ORDER BY name;
SELECT '== PERIFERICOS ==' AS info;
SELECT id, name FROM glpi_peripheraltypes ORDER BY name;
SELECT '== TELEFONOS ==' AS info;
SELECT id, name FROM glpi_phonetypes ORDER BY name;
