-- =====================================================================
-- 21_categorias_extra_y_modelos.sql
-- 1) Agrega categorias adicionales de ticket sugeridas
-- 2) Carga catalogo de modelos comunes:
--    computer, monitor, printer, phone, network equipment, peripheral
-- =====================================================================

START TRANSACTION;

-- =====================================================================
-- 1) CATEGORIAS DE TICKET ADICIONALES
-- =====================================================================
SET @cat_falla_pad = (SELECT id FROM glpi_itilcategories WHERE name='Fallas' AND itilcategories_id=0);
SET @cat_sol_pad   = (SELECT id FROM glpi_itilcategories WHERE name='Solicitudes' AND itilcategories_id=0);

-- Sub-categorias adicionales bajo Fallas
INSERT INTO glpi_itilcategories
  (name, entities_id, is_recursive, itilcategories_id, completename, level,
   is_helpdeskvisible, is_incident, is_request, is_problem, is_change,
   date_creation, date_mod)
VALUES
('Falla - Telefonia / Conmutador', 0, 1, @cat_falla_pad,
 'Fallas > Falla - Telefonia / Conmutador', 2, 1, 1, 0, 1, 0, NOW(), NOW()),
('Falla - Vehiculos / Flota',      0, 1, @cat_falla_pad,
 'Fallas > Falla - Vehiculos / Flota',      2, 1, 1, 0, 1, 0, NOW(), NOW()),
('Falla - Bascula / Pesaje',       0, 1, @cat_falla_pad,
 'Fallas > Falla - Bascula / Pesaje',       2, 1, 1, 0, 1, 0, NOW(), NOW()),
('Falla - Aire Acondicionado',     0, 1, @cat_falla_pad,
 'Fallas > Falla - Aire Acondicionado',     2, 1, 1, 0, 1, 0, NOW(), NOW());

-- Sub-categorias adicionales bajo Solicitudes
INSERT INTO glpi_itilcategories
  (name, entities_id, is_recursive, itilcategories_id, completename, level,
   is_helpdeskvisible, is_incident, is_request, is_problem, is_change,
   date_creation, date_mod)
VALUES
('Solicitud de cambio de contrasena', 0, 1, @cat_sol_pad,
 'Solicitudes > Solicitud de cambio de contrasena', 2, 1, 0, 1, 0, 0, NOW(), NOW()),
('Solicitud de permisos / vacaciones', 0, 1, @cat_sol_pad,
 'Solicitudes > Solicitud de permisos / vacaciones', 2, 1, 0, 1, 0, 0, NOW(), NOW()),
('Solicitud de instalacion software', 0, 1, @cat_sol_pad,
 'Solicitudes > Solicitud de instalacion software', 2, 1, 0, 1, 0, 0, NOW(), NOW()),
('Solicitud de mantenimiento PC',     0, 1, @cat_sol_pad,
 'Solicitudes > Solicitud de mantenimiento PC',     2, 1, 0, 1, 0, 0, NOW(), NOW());

-- =====================================================================
-- 2) MODELOS DE COMPUTADOR
-- =====================================================================
INSERT INTO glpi_computermodels (name, comment, date_creation, date_mod) VALUES
-- Dell
('Latitude 3420',      'Dell - Portatil',              NOW(), NOW()),
('Latitude 5420',      'Dell - Portatil',              NOW(), NOW()),
('Latitude 7420',      'Dell - Portatil premium',      NOW(), NOW()),
('Latitude 3520',      'Dell - Portatil',              NOW(), NOW()),
('OptiPlex 3070',      'Dell - Desktop',               NOW(), NOW()),
('OptiPlex 3080',      'Dell - Desktop',               NOW(), NOW()),
('OptiPlex 7080',      'Dell - Desktop',               NOW(), NOW()),
('OptiPlex 7090',      'Dell - Desktop',               NOW(), NOW()),
('Vostro 3681',        'Dell - Desktop',               NOW(), NOW()),
('Vostro 3500',        'Dell - Portatil',              NOW(), NOW()),
('Inspiron 15 3520',    'Dell - Portatil',             NOW(), NOW()),
('PowerEdge T140',     'Dell - Servidor',              NOW(), NOW()),
('PowerEdge R240',      'Dell - Servidor rack',        NOW(), NOW()),
-- HP
('ProDesk 400 G7',     'HP - Desktop',                 NOW(), NOW()),
('ProDesk 400 G9',     'HP - Desktop',                 NOW(), NOW()),
('ProDesk 600 G6',     'HP - Desktop',                 NOW(), NOW()),
('EliteDesk 800 G6',   'HP - Desktop',                 NOW(), NOW()),
('ProBook 440 G9',     'HP - Portatil',                NOW(), NOW()),
('ProBook 450 G9',     'HP - Portatil',                NOW(), NOW()),
('EliteBook 840 G8',   'HP - Portatil',                NOW(), NOW()),
('EliteBook 850 G8',   'HP - Portatil',                NOW(), NOW()),
('Pavilion 15',         'HP - Portatil',               NOW(), NOW()),
('Pavilion x360',       'HP - Portatil convertible',   NOW(), NOW()),
('ProLiant ML30',      'HP - Servidor',                NOW(), NOW()),
('ProLiant DL360',     'HP - Servidor rack',           NOW(), NOW()),
-- Lenovo
('ThinkPad T14',       'Lenovo - Portatil',            NOW(), NOW()),
('ThinkPad E15',       'Lenovo - Portatil',            NOW(), NOW()),
('ThinkPad L14',       'Lenovo - Portatil',            NOW(), NOW()),
('ThinkBook 14',       'Lenovo - Portatil',            NOW(), NOW()),
('ThinkCentre M70q',   'Lenovo - Mini PC',             NOW(), NOW()),
('ThinkCentre M90q',   'Lenovo - Mini PC',             NOW(), NOW()),
('ThinkCentre Neo 50t', 'Lenovo - Desktop',            NOW(), NOW()),
('IdeaPad 3',          'Lenovo - Portatil',            NOW(), NOW()),
('IdeaPad 5',          'Lenovo - Portatil',            NOW(), NOW()),
('V15',                'Lenovo - Portatil',            NOW(), NOW()),
-- Apple
('MacBook Air M1',     'Apple - Portatil',             NOW(), NOW()),
('MacBook Air M2',     'Apple - Portatil',             NOW(), NOW()),
('MacBook Pro 14',     'Apple - Portatil',             NOW(), NOW()),
-- Acer / Asus / otros
('Aspire 3 A315',      'Acer - Portatil',              NOW(), NOW()),
('Aspire 5 A515',      'Acer - Portatil',              NOW(), NOW()),
('Veriton X4660G',     'Acer - Desktop',               NOW(), NOW()),
('VivoBook 15',        'ASUS - Portatil',              NOW(), NOW()),
('ExpertCenter D500',  'ASUS - Desktop',               NOW(), NOW());

-- =====================================================================
-- 3) MODELOS DE MONITOR
-- =====================================================================
INSERT INTO glpi_monitormodels (name, comment, date_creation, date_mod) VALUES
-- Samsung
('S22F350',     'Samsung - 22 LED Full HD',         NOW(), NOW()),
('S24A310',     'Samsung - 24 LED',                 NOW(), NOW()),
('S27A310',     'Samsung - 27 LED',                 NOW(), NOW()),
('LF24T350',    'Samsung - 24 IPS',                 NOW(), NOW()),
-- LG
('22MK430H',    'LG - 22 LED Full HD',              NOW(), NOW()),
('24MK430H',    'LG - 24 LED Full HD',              NOW(), NOW()),
('27MP60G',     'LG - 27 IPS Full HD',              NOW(), NOW()),
('29WK600',     'LG - 29 ultrawide',                NOW(), NOW()),
-- Dell
('E2222H',      'Dell - 22 LED',                    NOW(), NOW()),
('P2422H',      'Dell - 24 IPS',                    NOW(), NOW()),
('P2722H',      'Dell - 27 IPS',                    NOW(), NOW()),
-- HP
('V22',         'HP - 22 LED',                      NOW(), NOW()),
('V24i',        'HP - 24 IPS',                      NOW(), NOW()),
('M24f',        'HP - 24 Full HD',                  NOW(), NOW()),
-- AOC / otros
('22B1H',       'AOC - 22 LED',                     NOW(), NOW()),
('24B1XH',      'AOC - 24 IPS',                     NOW(), NOW()),
('27B1H',       'AOC - 27 LED',                     NOW(), NOW()),
('VS228',       'ASUS - 22 LED',                    NOW(), NOW());

-- =====================================================================
-- 4) MODELOS DE IMPRESORA
-- =====================================================================
INSERT INTO glpi_printermodels (name, comment, date_creation, date_mod) VALUES
-- Epson EcoTank (muy comunes en oficina)
('L121',        'Epson - EcoTank',                  NOW(), NOW()),
('L3110',       'Epson - EcoTank multifuncional',   NOW(), NOW()),
('L3210',       'Epson - EcoTank multifuncional',   NOW(), NOW()),
('L3250',       'Epson - EcoTank multifuncional Wi-Fi', NOW(), NOW()),
('L4150',       'Epson - EcoTank multifuncional dúplex', NOW(), NOW()),
('L4260',       'Epson - EcoTank multifuncional',   NOW(), NOW()),
('L5190',       'Epson - EcoTank multifuncional con ADF', NOW(), NOW()),
('L805',        'Epson - EcoTank fotografica',      NOW(), NOW()),
-- HP
('LaserJet Pro M404n',  'HP - Laser monocromatica',  NOW(), NOW()),
('LaserJet M203dw',     'HP - Laser monocromatica',  NOW(), NOW()),
('LaserJet M227fdw',    'HP - Laser multifuncional', NOW(), NOW()),
('LaserJet M283fdw',    'HP - Laser color multifuncional', NOW(), NOW()),
('DeskJet 2775',        'HP - Tinta multifuncional', NOW(), NOW()),
('OfficeJet Pro 8025',  'HP - Tinta empresarial',    NOW(), NOW()),
('Smart Tank 525',      'HP - Tanque tinta',         NOW(), NOW()),
-- Brother
('HL-1212W',     'Brother - Laser monocromatica',   NOW(), NOW()),
('DCP-T520W',    'Brother - Tanque tinta multifuncional', NOW(), NOW()),
('MFC-J6730DW',  'Brother - Multifuncional A3',     NOW(), NOW()),
-- Canon
('PIXMA G3170',   'Canon - Tanque tinta',           NOW(), NOW()),
('PIXMA G2170',   'Canon - Tanque tinta',           NOW(), NOW()),
-- Ricoh / Kyocera (corporativas)
('SP 230SFNw',   'Ricoh - Laser multifuncional',    NOW(), NOW()),
('MP 2014AD',    'Ricoh - Laser corporativa',       NOW(), NOW()),
('ECOSYS M2040dn','Kyocera - Laser monocromatica',  NOW(), NOW()),
('ECOSYS P3145dn','Kyocera - Laser',                NOW(), NOW()),
-- POS / tirilla
('SRP-275III',   'Bixolon - Termica POS',           NOW(), NOW()),
('SRP-350plusIII','Bixolon - Termica POS',          NOW(), NOW()),
('TM-T20III',    'Epson - Termica POS',             NOW(), NOW()),
('TSP143IIIBI',  'Star Micronics - Termica POS',    NOW(), NOW()),
-- Etiquetadoras Zebra
('ZD220',        'Zebra - Etiquetadora termica',    NOW(), NOW()),
('ZD420',        'Zebra - Etiquetadora termica',    NOW(), NOW()),
('GK420t',       'Zebra - Etiquetadora industrial', NOW(), NOW()),
('ZT230',        'Zebra - Etiquetadora industrial', NOW(), NOW()),
('GC420t',       'Zebra - Etiquetadora desktop',    NOW(), NOW());

-- =====================================================================
-- 5) MODELOS DE TELEFONO
-- =====================================================================
INSERT INTO glpi_phonemodels (name, comment, date_creation, date_mod) VALUES
-- Samsung Galaxy
('Galaxy A14',     'Samsung - gama media',          NOW(), NOW()),
('Galaxy A24',     'Samsung - gama media',          NOW(), NOW()),
('Galaxy A34 5G',   'Samsung - gama media',         NOW(), NOW()),
('Galaxy A54 5G',   'Samsung - gama media',         NOW(), NOW()),
('Galaxy S22',     'Samsung - gama alta',           NOW(), NOW()),
('Galaxy S23',     'Samsung - gama alta',           NOW(), NOW()),
-- Apple
('iPhone 12',      'Apple',                          NOW(), NOW()),
('iPhone 13',      'Apple',                          NOW(), NOW()),
('iPhone 14',      'Apple',                          NOW(), NOW()),
('iPhone 15',      'Apple',                          NOW(), NOW()),
-- Motorola
('Moto E13',       'Motorola - gama de entrada',    NOW(), NOW()),
('Moto G14',       'Motorola - gama media',         NOW(), NOW()),
('Moto G34',       'Motorola - gama media',         NOW(), NOW()),
('Moto G54',       'Motorola - gama media',         NOW(), NOW()),
-- Xiaomi
('Redmi 12',       'Xiaomi - gama media',           NOW(), NOW()),
('Redmi Note 12',  'Xiaomi - gama media',           NOW(), NOW()),
('Redmi Note 13',  'Xiaomi - gama media',           NOW(), NOW()),
('POCO X5',        'Xiaomi - gama media',           NOW(), NOW()),
-- Honor / Huawei
('X7b',            'Honor - gama media',            NOW(), NOW()),
('X8a',            'Honor - gama media',            NOW(), NOW()),
('Y6p',            'Huawei - gama de entrada',      NOW(), NOW()),
-- Telefonia IP
('T31P',           'Yealink - Telefono IP basico',   NOW(), NOW()),
('T33G',           'Yealink - Telefono IP',         NOW(), NOW()),
('T46S',           'Yealink - Telefono IP empresarial', NOW(), NOW()),
('T54W',           'Yealink - Telefono IP premium', NOW(), NOW()),
('GXP1625',        'Grandstream - Telefono IP',     NOW(), NOW()),
('GXP1782',        'Grandstream - Telefono IP',     NOW(), NOW());

-- =====================================================================
-- 6) MODELOS DE EQUIPOS DE RED
-- =====================================================================
INSERT INTO glpi_networkequipmentmodels (name, comment, date_creation, date_mod) VALUES
-- Cisco
('Catalyst 2960X',  'Cisco - Switch 24p gestionable', NOW(), NOW()),
('Catalyst 9200',   'Cisco - Switch gestionable',     NOW(), NOW()),
('SG350-10',        'Cisco - Switch 10p PoE',         NOW(), NOW()),
-- TP-Link
('TL-SG108',         'TP-Link - Switch 8p Gigabit',   NOW(), NOW()),
('TL-SG1024',        'TP-Link - Switch 24p Gigabit',  NOW(), NOW()),
('TL-SG2210P',       'TP-Link - Switch PoE gestionable', NOW(), NOW()),
('Archer C20',       'TP-Link - Router dual band',    NOW(), NOW()),
('Archer C80',       'TP-Link - Router AC1900',       NOW(), NOW()),
('TL-WR841N',         'TP-Link - Router basico',      NOW(), NOW()),
('EAP225',           'TP-Link - Access Point',        NOW(), NOW()),
-- Mikrotik
('RB951G-2HnD',      'Mikrotik - Router/AP',          NOW(), NOW()),
('hAP ac2',          'Mikrotik - Router/AP',          NOW(), NOW()),
('hEX RB750Gr3',     'Mikrotik - Router',             NOW(), NOW()),
('CRS328',           'Mikrotik - Switch 24p',         NOW(), NOW()),
-- Ubiquiti
('UniFi US-8',       'Ubiquiti - Switch 8p',          NOW(), NOW()),
('UniFi USW-24',     'Ubiquiti - Switch 24p',         NOW(), NOW()),
('UAP-AC-Lite',      'Ubiquiti - Access Point',       NOW(), NOW()),
('UAP-AC-Pro',       'Ubiquiti - Access Point Pro',   NOW(), NOW()),
-- Fortinet / firewalls
('FortiGate 40F',    'Fortinet - Firewall SOHO',      NOW(), NOW()),
('FortiGate 60F',    'Fortinet - Firewall empresarial', NOW(), NOW()),
('FortiGate 100F',   'Fortinet - Firewall',           NOW(), NOW()),
-- DVRs / NVR (cámaras)
('DS-7104HQHI-K1',   'Hikvision - DVR 4ch',           NOW(), NOW()),
('DS-7108HQHI-K1',   'Hikvision - DVR 8ch',           NOW(), NOW()),
('DS-7116HQHI-K1',   'Hikvision - DVR 16ch',         NOW(), NOW()),
('DS-7608NI-K2',     'Hikvision - NVR 8ch',           NOW(), NOW()),
('DH-XVR4116HS',     'Dahua - DVR 16ch',              NOW(), NOW()),
-- D-Link / Netgear
('DGS-1008A',         'D-Link - Switch 8p Gigabit',   NOW(), NOW()),
('DIR-615',           'D-Link - Router',              NOW(), NOW()),
('GS108',             'Netgear - Switch 8p',          NOW(), NOW());

-- =====================================================================
-- 7) MODELOS DE PERIFERICOS
-- =====================================================================
INSERT INTO glpi_peripheralmodels (name, comment, date_creation, date_mod) VALUES
-- Logitech
('MK270',            'Logitech - Combo teclado+mouse inalambrico', NOW(), NOW()),
('MK345',            'Logitech - Combo teclado+mouse inalambrico', NOW(), NOW()),
('K120',             'Logitech - Teclado USB',         NOW(), NOW()),
('K380',             'Logitech - Teclado Bluetooth',   NOW(), NOW()),
('M170',             'Logitech - Mouse inalambrico',   NOW(), NOW()),
('M185',             'Logitech - Mouse inalambrico',   NOW(), NOW()),
('B100',             'Logitech - Mouse USB',           NOW(), NOW()),
('C270',             'Logitech - Webcam HD',           NOW(), NOW()),
('C920',             'Logitech - Webcam Full HD',      NOW(), NOW()),
-- Genius / Klip / Microsoft
('KB-110X',          'Genius - Teclado USB',           NOW(), NOW()),
('NetScroll 100',    'Genius - Mouse USB',             NOW(), NOW()),
('Microsoft Wired 600','Microsoft - Combo USB',         NOW(), NOW()),
-- Audifonos
('Cloud Stinger',    'HyperX - Audifonos gaming',      NOW(), NOW()),
('Cloud II',          'HyperX - Audifonos gaming',     NOW(), NOW()),
('H110',             'Logitech - Audifonos USB',       NOW(), NOW()),
('H390',             'Logitech - Audifonos USB',       NOW(), NOW()),
-- UPS (se mete como periferico)
('Back-UPS 750VA',   'APC - UPS 750VA',                NOW(), NOW()),
('Back-UPS 600VA',   'APC - UPS 600VA',                NOW(), NOW()),
('NT-751',           'Forza - UPS 750VA',              NOW(), NOW()),
('B-UPR1008i',       'CDP - UPS 1000VA',                NOW(), NOW()),
('R-UPB 1008i',      'CDP - UPS 1000VA inteligente',   NOW(), NOW()),
-- Lectores codigo de barras (POS)
('Voyager 1200g',    'Honeywell - Lector codigo USB',  NOW(), NOW()),
('Voyager 1450g',    'Honeywell - Lector codigo 2D',   NOW(), NOW()),
('QuickScan QD2430', 'Datalogic - Lector codigo',      NOW(), NOW()),
('DS2208',           'Symbol/Zebra - Lector codigo 2D', NOW(), NOW());

COMMIT;

-- =====================================================================
-- VERIFICACION
-- =====================================================================
SELECT '== CATEGORIAS NUEVAS ==' AS info;
SELECT id, completename FROM glpi_itilcategories
WHERE name IN (
  'Falla - Telefonia / Conmutador','Falla - Vehiculos / Flota',
  'Falla - Bascula / Pesaje','Falla - Aire Acondicionado',
  'Solicitud de cambio de contrasena','Solicitud de permisos / vacaciones',
  'Solicitud de instalacion software','Solicitud de mantenimiento PC');

SELECT '== TOTALES POR TIPO DE MODELO ==' AS info;
SELECT 'Computer' AS tipo, COUNT(*) FROM glpi_computermodels UNION ALL
SELECT 'Monitor',           COUNT(*) FROM glpi_monitormodels UNION ALL
SELECT 'Printer',           COUNT(*) FROM glpi_printermodels UNION ALL
SELECT 'Phone',             COUNT(*) FROM glpi_phonemodels UNION ALL
SELECT 'NetworkEquipment',  COUNT(*) FROM glpi_networkequipmentmodels UNION ALL
SELECT 'Peripheral',        COUNT(*) FROM glpi_peripheralmodels;
