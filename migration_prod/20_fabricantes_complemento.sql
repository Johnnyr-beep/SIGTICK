-- =====================================================================
-- 20_fabricantes_complemento.sql
-- Corrige "dell" -> "Dell" y agrega fabricantes faltantes:
--   celulares, impresoras, POS/escaneo, redes, UPS, perifericos,
--   refrigeracion industrial y automatizacion
-- =====================================================================

START TRANSACTION;

-- 1. Corregir capitalizacion "dell" -> "Dell"
UPDATE glpi_manufacturers SET name = 'Dell' WHERE name = 'dell';

-- 2. Insertar fabricantes faltantes (solo si no existen)
INSERT INTO glpi_manufacturers (name, comment, date_creation, date_mod)
SELECT * FROM (
  -- ====== CELULARES / MOVILES ======
  SELECT 'Motorola'        AS n, 'Celulares y radios'                AS c, NOW() AS dc, NOW() AS dm UNION ALL
  SELECT 'Xiaomi',           'Celulares Xiaomi / Redmi / POCO',       NOW(), NOW() UNION ALL
  SELECT 'Huawei',            'Celulares y equipos de red Huawei',    NOW(), NOW() UNION ALL
  SELECT 'Honor',             'Celulares Honor',                      NOW(), NOW() UNION ALL
  SELECT 'Nokia',             'Celulares Nokia',                      NOW(), NOW() UNION ALL
  SELECT 'Oppo',              'Celulares Oppo',                       NOW(), NOW() UNION ALL
  SELECT 'Realme',            'Celulares Realme',                     NOW(), NOW() UNION ALL
  SELECT 'OnePlus',           'Celulares OnePlus',                    NOW(), NOW() UNION ALL
  SELECT 'ZTE',               'Celulares y modems ZTE',               NOW(), NOW() UNION ALL
  SELECT 'Alcatel',           'Celulares Alcatel',                    NOW(), NOW() UNION ALL
  -- ====== IMPRESORAS adicionales ======
  SELECT 'Lexmark',           'Impresoras Lexmark',                   NOW(), NOW() UNION ALL
  SELECT 'Pantum',            'Impresoras Pantum',                    NOW(), NOW() UNION ALL
  SELECT 'Konica Minolta',    'Impresoras Konica Minolta',            NOW(), NOW() UNION ALL
  SELECT 'Sharp',             'Impresoras Sharp',                     NOW(), NOW() UNION ALL
  SELECT 'OKI',               'Impresoras OKI Data',                  NOW(), NOW() UNION ALL
  -- ====== IMPRESORAS POS / ETIQUETAS / ESCANEO ======
  SELECT 'Bixolon',           'Impresoras termicas POS Bixolon',      NOW(), NOW() UNION ALL
  SELECT 'Star Micronics',    'Impresoras termicas POS Star',         NOW(), NOW() UNION ALL
  SELECT 'Bematech',          'Impresoras POS Bematech',              NOW(), NOW() UNION ALL
  SELECT 'Honeywell',         'Lectores codigo barras y POS',         NOW(), NOW() UNION ALL
  SELECT 'Datalogic',         'Lectores de codigo de barras',         NOW(), NOW() UNION ALL
  SELECT 'Symbol',             'Lectores Symbol (Zebra/Motorola)',    NOW(), NOW() UNION ALL
  SELECT 'TSC',               'Impresoras de etiquetas TSC',          NOW(), NOW() UNION ALL
  SELECT 'Argox',              'Impresoras de etiquetas Argox',       NOW(), NOW() UNION ALL
  -- ====== REDES / CCTV ======
  SELECT 'D-Link',             'Equipos de red D-Link',               NOW(), NOW() UNION ALL
  SELECT 'Netgear',            'Equipos de red Netgear',              NOW(), NOW() UNION ALL
  SELECT 'Aruba',              'Aruba Networks (HPE)',                NOW(), NOW() UNION ALL
  SELECT 'Juniper',            'Equipos Juniper',                     NOW(), NOW() UNION ALL
  SELECT 'SonicWall',          'Firewalls SonicWall',                 NOW(), NOW() UNION ALL
  SELECT 'Sophos',              'Firewalls Sophos',                   NOW(), NOW() UNION ALL
  SELECT 'Hikvision',           'Camaras CCTV Hikvision',             NOW(), NOW() UNION ALL
  SELECT 'Dahua',              'Camaras CCTV Dahua',                  NOW(), NOW() UNION ALL
  SELECT 'Axis Communications', 'Camaras IP Axis',                    NOW(), NOW() UNION ALL
  SELECT 'EZVIZ',              'Camaras EZVIZ',                       NOW(), NOW() UNION ALL
  -- ====== UPS / ENERGIA ======
  SELECT 'CDP',                'UPS CDP',                             NOW(), NOW() UNION ALL
  SELECT 'Forza',              'UPS Forza',                           NOW(), NOW() UNION ALL
  SELECT 'Eaton',              'UPS Eaton',                           NOW(), NOW() UNION ALL
  SELECT 'Vertiv',              'Liebert / Vertiv',                   NOW(), NOW() UNION ALL
  -- ====== PERIFERICOS / ACCESORIOS ======
  SELECT 'Genius',             'Perifericos Genius',                  NOW(), NOW() UNION ALL
  SELECT 'Klip Xtreme',        'Accesorios Klip Xtreme',              NOW(), NOW() UNION ALL
  SELECT 'HyperX',             'Audifonos / accesorios HyperX',       NOW(), NOW() UNION ALL
  SELECT 'Razer',              'Perifericos Razer',                   NOW(), NOW() UNION ALL
  SELECT 'Corsair',             'Perifericos Corsair',                NOW(), NOW() UNION ALL
  SELECT 'Targus',              'Maletines y accesorios Targus',      NOW(), NOW() UNION ALL
  SELECT 'Kingston',             'Memorias y SSD Kingston',           NOW(), NOW() UNION ALL
  SELECT 'Western Digital',      'Discos WD',                         NOW(), NOW() UNION ALL
  SELECT 'Seagate',             'Discos Seagate',                     NOW(), NOW() UNION ALL
  -- ====== REFRIGERACION INDUSTRIAL adicionales ======
  SELECT 'Tecumseh',             'Compresores Tecumseh',              NOW(), NOW() UNION ALL
  SELECT 'Embraco',              'Compresores Embraco',               NOW(), NOW() UNION ALL
  SELECT 'Heatcraft',             'Equipos Heatcraft',                NOW(), NOW() UNION ALL
  SELECT 'Mainstream',            'Mainstream Engineering',           NOW(), NOW() UNION ALL
  -- ====== AUTOMATIZACION / CONTROL INDUSTRIAL ======
  SELECT 'Allen-Bradley',         'PLC Allen-Bradley (Rockwell)',     NOW(), NOW() UNION ALL
  SELECT 'Omron',                 'Sensores y PLC Omron',             NOW(), NOW() UNION ALL
  SELECT 'Mitsubishi Electric',    'PLC Mitsubishi',                  NOW(), NOW() UNION ALL
  SELECT 'Festo',                 'Componentes neumaticos Festo',     NOW(), NOW() UNION ALL
  SELECT 'SMC',                   'Componentes neumaticos SMC',       NOW(), NOW() UNION ALL
  SELECT 'WEG',                   'Motores y variadores WEG',         NOW(), NOW() UNION ALL
  SELECT 'Phoenix Contact',        'Conectores Phoenix',              NOW(), NOW() UNION ALL
  SELECT 'Legrand',                'Equipos electricos Legrand',      NOW(), NOW() UNION ALL
  -- ====== TELEFONIA IP adicionales ======
  SELECT 'Polycom',               'Telefonia / video Polycom',        NOW(), NOW() UNION ALL
  SELECT 'Snom',                   'Telefonos IP Snom',               NOW(), NOW() UNION ALL
  SELECT 'Fanvil',                 'Telefonos IP Fanvil',             NOW(), NOW() UNION ALL
  -- ====== OTROS ======
  SELECT 'Toshiba',                'Toshiba',                         NOW(), NOW() UNION ALL
  SELECT 'Sony',                   'Sony',                            NOW(), NOW() UNION ALL
  SELECT 'Philips',                 'Philips',                        NOW(), NOW() UNION ALL
  SELECT 'Genericos',                'Marca generica / sin marca',    NOW(), NOW()
) AS t
WHERE NOT EXISTS (SELECT 1 FROM glpi_manufacturers m WHERE m.name = t.n);

COMMIT;

-- =====================================================================
-- VERIFICACION
-- =====================================================================
SELECT '== FABRICANTES TOTAL ==' AS info;
SELECT COUNT(*) AS total FROM glpi_manufacturers;

SELECT '== FABRICANTES POR CATEGORIA (resumen) ==' AS info;
SELECT
  CASE
    WHEN name IN ('Motorola','Xiaomi','Huawei','Honor','Nokia','Oppo','Realme','OnePlus','ZTE','Alcatel','Samsung','Apple','LG') THEN '01. Celulares'
    WHEN name IN ('Dell','HP','Lenovo','Acer','ASUS','Apple','Toshiba','Sony') THEN '02. Computadores'
    WHEN name IN ('Epson','Canon','Brother','Xerox','Ricoh','Kyocera','Lexmark','Pantum','Konica Minolta','Sharp','OKI','HP') THEN '03. Impresoras'
    WHEN name IN ('Bixolon','Star Micronics','Bematech','Zebra','TSC','Argox') THEN '04. POS / Etiquetas'
    WHEN name IN ('Honeywell','Datalogic','Symbol') THEN '05. Lectores codigo'
    WHEN name IN ('Cisco','TP-Link','Mikrotik','Fortinet','Ubiquiti','D-Link','Netgear','Aruba','Juniper','SonicWall','Sophos','Huawei') THEN '06. Redes'
    WHEN name IN ('Hikvision','Dahua','Axis Communications','EZVIZ') THEN '07. CCTV / Camaras'
    WHEN name IN ('APC','Tripp Lite','CDP','Forza','Eaton','Vertiv') THEN '08. UPS / Energia'
    WHEN name IN ('Logitech','Microsoft','Genius','Klip Xtreme','HyperX','Razer','Corsair','Targus','Kingston','Western Digital','Seagate') THEN '09. Perifericos'
    WHEN name IN ('Yealink','Grandstream','Polycom','Snom','Fanvil') THEN '10. Telefonia IP'
    WHEN name IN ('Siemens','ABB','Schneider Electric','Danfoss','Bitzer','Copeland','Carrier','Trane','Bohn','Frick','York','Tecumseh','Embraco','Heatcraft','Mainstream') THEN '11. Refrigeracion'
    WHEN name IN ('Allen-Bradley','Omron','Mitsubishi Electric','Festo','SMC','WEG','Phoenix Contact','Legrand') THEN '12. Industrial'
    ELSE '99. Otros'
  END AS categoria,
  COUNT(*) AS cantidad
FROM glpi_manufacturers
GROUP BY categoria
ORDER BY categoria;
