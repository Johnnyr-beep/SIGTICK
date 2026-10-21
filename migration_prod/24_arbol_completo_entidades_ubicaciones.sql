-- ============================================================================
-- Script 24: Árbol completo de Entidades + Ubicaciones + Supervisores
-- ----------------------------------------------------------------------------
-- Cambios:
--   1. ALMACEN Y COMPRAS -> renombrada a ALMACEN CENTRAL
--   2. 7 entidades nuevas:
--      * TRANSANTACRUZ (raíz)
--      * PLANTA BENEFICIO BOVINO, PLANTA BENEFICIO PORCINO (bajo AGROPECUARIA)
--      * PDV-ALAMEDA 2, RESTAURANTE LA 43, LA 93, MALAMBO (bajo CARNES SANTACRUZ)
--   3. Árbol limpio de ubicaciones (140) con normalización Title Case:
--      * 14 áreas transversales bajo GRUPO SANTACRUZ (raíz)
--      * Plantas Bovino/Porcino con sus áreas
--      * 17 PDVs con cuartos fríos (incl. nuevo PDV-ALAMEDA 2)
--      * 3 Restaurantes con áreas estándar
--      * Compras por empresa
--      * ALMACEN CENTRAL con estanterías
--   4. 4 supervisores nuevos: supervisor.alameda2, restaurante43,
--      restaurante93, restaurantemalambo (perfil Supervisor PDV)
-- ============================================================================

USE TICKETS_DB;

-- ----------------------------------------------------------------------------
-- 0) Backup
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS _bk24_entities;
DROP TABLE IF EXISTS _bk24_locations;
DROP TABLE IF EXISTS _bk24_users;
DROP TABLE IF EXISTS _bk24_profilesusers;
CREATE TABLE _bk24_entities      AS SELECT * FROM glpi_entities;
CREATE TABLE _bk24_locations     AS SELECT * FROM glpi_locations;
CREATE TABLE _bk24_users         AS SELECT * FROM glpi_users WHERE name LIKE 'supervisor.%' OR name LIKE 'pdv.%';
CREATE TABLE _bk24_profilesusers AS SELECT pu.* FROM glpi_profiles_users pu
  JOIN glpi_users u ON u.id=pu.users_id WHERE u.name LIKE 'supervisor.%';

START TRANSACTION;

-- ============================================================================
-- 1) ENTIDADES
-- ============================================================================

-- 1.a Renombrar ALMACEN Y COMPRAS -> ALMACEN CENTRAL
UPDATE glpi_entities
   SET name = 'ALMACEN CENTRAL',
       completename = 'GRUPO SANTACRUZ > ALMACEN CENTRAL',
       date_mod = NOW()
 WHERE id = 70;

-- 1.b Nueva entidad TRANSANTACRUZ
INSERT INTO glpi_entities
  (name, completename, level, entities_id, ancestors_cache, date_mod, date_creation)
VALUES
  ('TRANSANTACRUZ', 'GRUPO SANTACRUZ > TRANSANTACRUZ', 2, 0, '[0]', NOW(), NOW());
SET @ent_transantacruz := LAST_INSERT_ID();

-- 1.c Plantas bajo AGROPECUARIA (id=44)
INSERT INTO glpi_entities
  (name, completename, level, entities_id, ancestors_cache, date_mod, date_creation)
VALUES
  ('PLANTA BENEFICIO BOVINO',  'GRUPO SANTACRUZ > AGROPECUARIA > PLANTA BENEFICIO BOVINO',  3, 44, '{"0":0,"44":44}', NOW(), NOW());
SET @ent_planta_bov := LAST_INSERT_ID();

INSERT INTO glpi_entities
  (name, completename, level, entities_id, ancestors_cache, date_mod, date_creation)
VALUES
  ('PLANTA BENEFICIO PORCINO', 'GRUPO SANTACRUZ > AGROPECUARIA > PLANTA BENEFICIO PORCINO', 3, 44, '{"0":0,"44":44}', NOW(), NOW());
SET @ent_planta_por := LAST_INSERT_ID();

-- 1.d Nuevas unidades bajo CARNES SANTACRUZ (id=45)
INSERT INTO glpi_entities
  (name, completename, level, entities_id, ancestors_cache, date_mod, date_creation)
VALUES
  ('PDV-ALAMEDA 2',       'GRUPO SANTACRUZ > CARNES SANTACRUZ > PDV-ALAMEDA 2',       3, 45, '{"0":0,"45":45}', NOW(), NOW());
SET @ent_alameda2 := LAST_INSERT_ID();

INSERT INTO glpi_entities
  (name, completename, level, entities_id, ancestors_cache, date_mod, date_creation)
VALUES
  ('RESTAURANTE LA 43',   'GRUPO SANTACRUZ > CARNES SANTACRUZ > RESTAURANTE LA 43',   3, 45, '{"0":0,"45":45}', NOW(), NOW());
SET @ent_rest43 := LAST_INSERT_ID();

INSERT INTO glpi_entities
  (name, completename, level, entities_id, ancestors_cache, date_mod, date_creation)
VALUES
  ('RESTAURANTE LA 93',   'GRUPO SANTACRUZ > CARNES SANTACRUZ > RESTAURANTE LA 93',   3, 45, '{"0":0,"45":45}', NOW(), NOW());
SET @ent_rest93 := LAST_INSERT_ID();

INSERT INTO glpi_entities
  (name, completename, level, entities_id, ancestors_cache, date_mod, date_creation)
VALUES
  ('RESTAURANTE MALAMBO', 'GRUPO SANTACRUZ > CARNES SANTACRUZ > RESTAURANTE MALAMBO', 3, 45, '{"0":0,"45":45}', NOW(), NOW());
SET @ent_restmal := LAST_INSERT_ID();

-- ============================================================================
-- 2) UBICACIONES - wipe limpio (no hay equipos cargados aún)
-- ============================================================================
DELETE FROM glpi_locations;
ALTER TABLE glpi_locations AUTO_INCREMENT = 1;

-- ----------------------------------------------------------------------------
-- 2.a Áreas transversales (raíz: locations_id=0, entities_id=0, recursivas)
-- ----------------------------------------------------------------------------
INSERT INTO glpi_locations
  (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES
  ('Agroporcícola',                                       'Agroporcícola',                                       1, 0, 0, 1, NOW(), NOW()),
  ('Departamento de Seguridad',                           'Departamento de Seguridad',                           1, 0, 0, 1, NOW(), NOW()),
  ('Departamento de Sistemas',                            'Departamento de Sistemas',                            1, 0, 0, 1, NOW(), NOW()),
  ('Departamento Ambiental',                              'Departamento Ambiental',                              1, 0, 0, 1, NOW(), NOW()),
  ('Portería',                                            'Portería',                                            1, 0, 0, 1, NOW(), NOW()),
  ('Oficina SST',                                         'Oficina SST',                                         1, 0, 0, 1, NOW(), NOW()),
  ('Oficina Gerencia',                                    'Oficina Gerencia',                                    1, 0, 0, 1, NOW(), NOW()),
  ('Bodegas Nuevas (Antigua Zona de Caldera - Movilidad)','Bodegas Nuevas (Antigua Zona de Caldera - Movilidad)',1, 0, 0, 1, NOW(), NOW()),
  ('SITRAD Refrigeración',                                'SITRAD Refrigeración',                                1, 0, 0, 1, NOW(), NOW()),
  ('TAT Container',                                       'TAT Container',                                       1, 0, 0, 1, NOW(), NOW()),
  ('Salón VIP',                                           'Salón VIP',                                           1, 0, 0, 1, NOW(), NOW()),
  ('Bomba de Combustible',                                'Bomba de Combustible',                                1, 0, 0, 1, NOW(), NOW()),
  ('Oficina Megatienda',                                  'Oficina Megatienda',                                  1, 0, 0, 1, NOW(), NOW()),
  ('Logística',                                           'Logística',                                           1, 0, 0, 1, NOW(), NOW());

-- ----------------------------------------------------------------------------
-- 2.b AGROPECUARIA + subárbol
-- ----------------------------------------------------------------------------
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('AGROPECUARIA', 'AGROPECUARIA', 1, 0, 44, 1, NOW(), NOW());
SET @loc_agro := LAST_INSERT_ID();

-- Planta de Beneficio Bovino
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('Planta de Beneficio Bovino', 'AGROPECUARIA > Planta de Beneficio Bovino', 2, @loc_agro, @ent_planta_bov, 1, NOW(), NOW());
SET @loc_planta_bov := LAST_INSERT_ID();

INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Corrales Bovino',             CONCAT('AGROPECUARIA > Planta de Beneficio Bovino > Corrales Bovino'),             3, @loc_planta_bov, @ent_planta_bov, 0, NOW(), NOW()),
  ('Salón Bovino',                CONCAT('AGROPECUARIA > Planta de Beneficio Bovino > Salón Bovino'),                3, @loc_planta_bov, @ent_planta_bov, 0, NOW(), NOW()),
  ('Oficina Beneficio Bovino',    CONCAT('AGROPECUARIA > Planta de Beneficio Bovino > Oficina Beneficio Bovino'),    3, @loc_planta_bov, @ent_planta_bov, 0, NOW(), NOW()),
  ('Logística Bovino',            CONCAT('AGROPECUARIA > Planta de Beneficio Bovino > Logística Bovino'),            3, @loc_planta_bov, @ent_planta_bov, 0, NOW(), NOW()),
  ('Vísceras Bovino',             CONCAT('AGROPECUARIA > Planta de Beneficio Bovino > Vísceras Bovino'),             3, @loc_planta_bov, @ent_planta_bov, 0, NOW(), NOW()),
  ('Sala de Despresado Bovino',   CONCAT('AGROPECUARIA > Planta de Beneficio Bovino > Sala de Despresado Bovino'),   3, @loc_planta_bov, @ent_planta_bov, 0, NOW(), NOW()),
  ('Cuarto Frío Bovino',          CONCAT('AGROPECUARIA > Planta de Beneficio Bovino > Cuarto Frío Bovino'),          3, @loc_planta_bov, @ent_planta_bov, 0, NOW(), NOW());

-- Planta de Beneficio Porcino
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('Planta de Beneficio Porcino', 'AGROPECUARIA > Planta de Beneficio Porcino', 2, @loc_agro, @ent_planta_por, 1, NOW(), NOW());
SET @loc_planta_por := LAST_INSERT_ID();

INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Corrales Porcino',            'AGROPECUARIA > Planta de Beneficio Porcino > Corrales Porcino',           3, @loc_planta_por, @ent_planta_por, 0, NOW(), NOW()),
  ('Salón Porcino A',             'AGROPECUARIA > Planta de Beneficio Porcino > Salón Porcino A',            3, @loc_planta_por, @ent_planta_por, 0, NOW(), NOW()),
  ('Salón Porcino B',             'AGROPECUARIA > Planta de Beneficio Porcino > Salón Porcino B',            3, @loc_planta_por, @ent_planta_por, 0, NOW(), NOW()),
  ('Oficina Porcino',             'AGROPECUARIA > Planta de Beneficio Porcino > Oficina Porcino',            3, @loc_planta_por, @ent_planta_por, 0, NOW(), NOW()),
  ('Vísceras Porcino',            'AGROPECUARIA > Planta de Beneficio Porcino > Vísceras Porcino',           3, @loc_planta_por, @ent_planta_por, 0, NOW(), NOW()),
  ('Sala de Despresado Porcino',  'AGROPECUARIA > Planta de Beneficio Porcino > Sala de Despresado Porcino', 3, @loc_planta_por, @ent_planta_por, 0, NOW(), NOW()),
  ('Cuarto Frío Porcino',         'AGROPECUARIA > Planta de Beneficio Porcino > Cuarto Frío Porcino',        3, @loc_planta_por, @ent_planta_por, 0, NOW(), NOW());

-- Oficinas ASC
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('Oficinas ASC', 'AGROPECUARIA > Oficinas ASC', 2, @loc_agro, 63, 1, NOW(), NOW());
SET @loc_asc := LAST_INSERT_ID();

INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Almacén ASC',                       'AGROPECUARIA > Oficinas ASC > Almacén ASC',                       3, @loc_asc, 63, 0, NOW(), NOW()),
  ('Calidad',                           'AGROPECUARIA > Oficinas ASC > Calidad',                           3, @loc_asc, 63, 0, NOW(), NOW()),
  ('Container',                         'AGROPECUARIA > Oficinas ASC > Container',                         3, @loc_asc, 63, 0, NOW(), NOW()),
  ('Gestión Humana',                    'AGROPECUARIA > Oficinas ASC > Gestión Humana',                    3, @loc_asc, 63, 0, NOW(), NOW()),
  ('Mantenimiento',                     'AGROPECUARIA > Oficinas ASC > Mantenimiento',                     3, @loc_asc, 63, 0, NOW(), NOW()),
  ('Pagaduría',                         'AGROPECUARIA > Oficinas ASC > Pagaduría',                         3, @loc_asc, 63, 0, NOW(), NOW()),
  ('Tesorería',                         'AGROPECUARIA > Oficinas ASC > Tesorería',                         3, @loc_asc, 63, 0, NOW(), NOW()),
  ('Oficina Nueva de Agropecuaria',     'AGROPECUARIA > Oficinas ASC > Oficina Nueva de Agropecuaria',     3, @loc_asc, 63, 0, NOW(), NOW());

-- Compras Agropecuaria
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('Compras Agropecuaria', 'AGROPECUARIA > Compras Agropecuaria', 2, @loc_agro, 44, 0, NOW(), NOW());

-- ----------------------------------------------------------------------------
-- 2.c CARNES SANTACRUZ + subárbol
-- ----------------------------------------------------------------------------
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('CARNES SANTACRUZ', 'CARNES SANTACRUZ', 1, 0, 45, 1, NOW(), NOW());
SET @loc_carnes := LAST_INSERT_ID();

INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Oficinas Carnes Santacruz', 'CARNES SANTACRUZ > Oficinas Carnes Santacruz', 2, @loc_carnes, 45, 0, NOW(), NOW()),
  ('Call Center Ventas',        'CARNES SANTACRUZ > Call Center Ventas',        2, @loc_carnes, 45, 0, NOW(), NOW()),
  ('Compras Carnes Santacruz',  'CARNES SANTACRUZ > Compras Carnes Santacruz',  2, @loc_carnes, 45, 0, NOW(), NOW());

-- Macro para PDVs estándar (Cong + Refr)
-- PDV-ALAMEDA (entidad 59)
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('PDV-ALAMEDA', 'CARNES SANTACRUZ > PDV-ALAMEDA', 2, @loc_carnes, 59, 1, NOW(), NOW());
SET @loc_pdv := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Cuarto Congelación', 'CARNES SANTACRUZ > PDV-ALAMEDA > Cuarto Congelación', 3, @loc_pdv, 59, 0, NOW(), NOW()),
  ('Cuarto Refrigerado', 'CARNES SANTACRUZ > PDV-ALAMEDA > Cuarto Refrigerado', 3, @loc_pdv, 59, 0, NOW(), NOW());

-- PDV-ALAMEDA 2 (entidad nueva)
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('PDV-ALAMEDA 2', 'CARNES SANTACRUZ > PDV-ALAMEDA 2', 2, @loc_carnes, @ent_alameda2, 1, NOW(), NOW());
SET @loc_pdv := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Cuarto Congelación', 'CARNES SANTACRUZ > PDV-ALAMEDA 2 > Cuarto Congelación', 3, @loc_pdv, @ent_alameda2, 0, NOW(), NOW()),
  ('Cuarto Refrigerado', 'CARNES SANTACRUZ > PDV-ALAMEDA 2 > Cuarto Refrigerado', 3, @loc_pdv, @ent_alameda2, 0, NOW(), NOW());

-- PDV-BUCARAMANGA (entidad 47)
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('PDV-BUCARAMANGA', 'CARNES SANTACRUZ > PDV-BUCARAMANGA', 2, @loc_carnes, 47, 1, NOW(), NOW());
SET @loc_pdv := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Cuarto Congelación', 'CARNES SANTACRUZ > PDV-BUCARAMANGA > Cuarto Congelación', 3, @loc_pdv, 47, 0, NOW(), NOW()),
  ('Cuarto Refrigerado', 'CARNES SANTACRUZ > PDV-BUCARAMANGA > Cuarto Refrigerado', 3, @loc_pdv, 47, 0, NOW(), NOW());

-- PDV-CARTAGENA (entidad 60) - 3 cuartos
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('PDV-CARTAGENA', 'CARNES SANTACRUZ > PDV-CARTAGENA', 2, @loc_carnes, 60, 1, NOW(), NOW());
SET @loc_pdv := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Cuarto Congelación',      'CARNES SANTACRUZ > PDV-CARTAGENA > Cuarto Congelación',      3, @loc_pdv, 60, 0, NOW(), NOW()),
  ('Cuarto Refrigerado',      'CARNES SANTACRUZ > PDV-CARTAGENA > Cuarto Refrigerado',      3, @loc_pdv, 60, 0, NOW(), NOW()),
  ('Difusor Sala de Proceso', 'CARNES SANTACRUZ > PDV-CARTAGENA > Difusor Sala de Proceso', 3, @loc_pdv, 60, 0, NOW(), NOW());

-- PDV-CENTRO (entidad 53) - 4 cuartos (2 cong)
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('PDV-CENTRO', 'CARNES SANTACRUZ > PDV-CENTRO', 2, @loc_carnes, 53, 1, NOW(), NOW());
SET @loc_pdv := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Cuarto Congelación 1',    'CARNES SANTACRUZ > PDV-CENTRO > Cuarto Congelación 1',    3, @loc_pdv, 53, 0, NOW(), NOW()),
  ('Cuarto Congelación 2',    'CARNES SANTACRUZ > PDV-CENTRO > Cuarto Congelación 2',    3, @loc_pdv, 53, 0, NOW(), NOW()),
  ('Cuarto Refrigerado',      'CARNES SANTACRUZ > PDV-CENTRO > Cuarto Refrigerado',      3, @loc_pdv, 53, 0, NOW(), NOW()),
  ('Difusor Sala de Proceso', 'CARNES SANTACRUZ > PDV-CENTRO > Difusor Sala de Proceso', 3, @loc_pdv, 53, 0, NOW(), NOW());

-- PDV-CONCORD (entidad 50)
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('PDV-CONCORD', 'CARNES SANTACRUZ > PDV-CONCORD', 2, @loc_carnes, 50, 1, NOW(), NOW());
SET @loc_pdv := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Cuarto Congelación 1',     'CARNES SANTACRUZ > PDV-CONCORD > Cuarto Congelación 1',     3, @loc_pdv, 50, 0, NOW(), NOW()),
  ('Cuarto Congelación 2',     'CARNES SANTACRUZ > PDV-CONCORD > Cuarto Congelación 2',     3, @loc_pdv, 50, 0, NOW(), NOW()),
  ('Cuarto Refrigerado',       'CARNES SANTACRUZ > PDV-CONCORD > Cuarto Refrigerado',       3, @loc_pdv, 50, 0, NOW(), NOW()),
  ('Sala de Proceso Concord',  'CARNES SANTACRUZ > PDV-CONCORD > Sala de Proceso Concord',  3, @loc_pdv, 50, 0, NOW(), NOW());

-- PDV-FRUVER LA 70 (entidad 62)
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('PDV-FRUVER LA 70', 'CARNES SANTACRUZ > PDV-FRUVER LA 70', 2, @loc_carnes, 62, 1, NOW(), NOW());
SET @loc_pdv := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Cuarto Congelación', 'CARNES SANTACRUZ > PDV-FRUVER LA 70 > Cuarto Congelación', 3, @loc_pdv, 62, 0, NOW(), NOW()),
  ('Cuarto Refrigerado', 'CARNES SANTACRUZ > PDV-FRUVER LA 70 > Cuarto Refrigerado', 3, @loc_pdv, 62, 0, NOW(), NOW());

-- PDV-LA 43 (entidad 57)
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('PDV-LA 43', 'CARNES SANTACRUZ > PDV-LA 43', 2, @loc_carnes, 57, 1, NOW(), NOW());
SET @loc_pdv := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Cuarto Congelación 1',    'CARNES SANTACRUZ > PDV-LA 43 > Cuarto Congelación 1',    3, @loc_pdv, 57, 0, NOW(), NOW()),
  ('Cuarto Congelación 2',    'CARNES SANTACRUZ > PDV-LA 43 > Cuarto Congelación 2',    3, @loc_pdv, 57, 0, NOW(), NOW()),
  ('Cuarto Refrigerado',      'CARNES SANTACRUZ > PDV-LA 43 > Cuarto Refrigerado',      3, @loc_pdv, 57, 0, NOW(), NOW()),
  ('Difusor Sala de Proceso', 'CARNES SANTACRUZ > PDV-LA 43 > Difusor Sala de Proceso', 3, @loc_pdv, 57, 0, NOW(), NOW());

-- PDV-LA 70 (entidad 56)
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('PDV-LA 70', 'CARNES SANTACRUZ > PDV-LA 70', 2, @loc_carnes, 56, 1, NOW(), NOW());
SET @loc_pdv := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Cuarto Congelación', 'CARNES SANTACRUZ > PDV-LA 70 > Cuarto Congelación', 3, @loc_pdv, 56, 0, NOW(), NOW()),
  ('Cuarto Refrigerado', 'CARNES SANTACRUZ > PDV-LA 70 > Cuarto Refrigerado', 3, @loc_pdv, 56, 0, NOW(), NOW());

-- PDV-LA 93 (entidad 58)
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('PDV-LA 93', 'CARNES SANTACRUZ > PDV-LA 93', 2, @loc_carnes, 58, 1, NOW(), NOW());
SET @loc_pdv := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Cuarto Congelación',      'CARNES SANTACRUZ > PDV-LA 93 > Cuarto Congelación',      3, @loc_pdv, 58, 0, NOW(), NOW()),
  ('Cuarto Refrigerado',      'CARNES SANTACRUZ > PDV-LA 93 > Cuarto Refrigerado',      3, @loc_pdv, 58, 0, NOW(), NOW()),
  ('Difusor Sala de Proceso', 'CARNES SANTACRUZ > PDV-LA 93 > Difusor Sala de Proceso', 3, @loc_pdv, 58, 0, NOW(), NOW());

-- PDV-MALAMBO (entidad 49)
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('PDV-MALAMBO', 'CARNES SANTACRUZ > PDV-MALAMBO', 2, @loc_carnes, 49, 1, NOW(), NOW());
SET @loc_pdv := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Sala de Proceso',    'CARNES SANTACRUZ > PDV-MALAMBO > Sala de Proceso',    3, @loc_pdv, 49, 0, NOW(), NOW()),
  ('Cuarto Congelación', 'CARNES SANTACRUZ > PDV-MALAMBO > Cuarto Congelación', 3, @loc_pdv, 49, 0, NOW(), NOW()),
  ('Cuarto Refrigerado', 'CARNES SANTACRUZ > PDV-MALAMBO > Cuarto Refrigerado', 3, @loc_pdv, 49, 0, NOW(), NOW());

-- PDV-OLAYA (entidad 55)
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('PDV-OLAYA', 'CARNES SANTACRUZ > PDV-OLAYA', 2, @loc_carnes, 55, 1, NOW(), NOW());
SET @loc_pdv := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Cuarto Congelación',      'CARNES SANTACRUZ > PDV-OLAYA > Cuarto Congelación',      3, @loc_pdv, 55, 0, NOW(), NOW()),
  ('Cuarto Refrigerado',      'CARNES SANTACRUZ > PDV-OLAYA > Cuarto Refrigerado',      3, @loc_pdv, 55, 0, NOW(), NOW()),
  ('Difusor Sala de Proceso', 'CARNES SANTACRUZ > PDV-OLAYA > Difusor Sala de Proceso', 3, @loc_pdv, 55, 0, NOW(), NOW());

-- PDV-PEREIRA (entidad 48)
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('PDV-PEREIRA', 'CARNES SANTACRUZ > PDV-PEREIRA', 2, @loc_carnes, 48, 1, NOW(), NOW());
SET @loc_pdv := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Cuarto Congelación', 'CARNES SANTACRUZ > PDV-PEREIRA > Cuarto Congelación', 3, @loc_pdv, 48, 0, NOW(), NOW()),
  ('Cuarto Refrigerado', 'CARNES SANTACRUZ > PDV-PEREIRA > Cuarto Refrigerado', 3, @loc_pdv, 48, 0, NOW(), NOW());

-- PDV-PIEDECUESTA (entidad 61)
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('PDV-PIEDECUESTA', 'CARNES SANTACRUZ > PDV-PIEDECUESTA', 2, @loc_carnes, 61, 1, NOW(), NOW());
SET @loc_pdv := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Cuarto Congelación', 'CARNES SANTACRUZ > PDV-PIEDECUESTA > Cuarto Congelación', 3, @loc_pdv, 61, 0, NOW(), NOW()),
  ('Cuarto Refrigerado', 'CARNES SANTACRUZ > PDV-PIEDECUESTA > Cuarto Refrigerado', 3, @loc_pdv, 61, 0, NOW(), NOW());

-- PDV-SAN FELIPE (entidad 54)
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('PDV-SAN FELIPE', 'CARNES SANTACRUZ > PDV-SAN FELIPE', 2, @loc_carnes, 54, 1, NOW(), NOW());
SET @loc_pdv := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Cuarto Congelación',      'CARNES SANTACRUZ > PDV-SAN FELIPE > Cuarto Congelación',      3, @loc_pdv, 54, 0, NOW(), NOW()),
  ('Cuarto Refrigerado',      'CARNES SANTACRUZ > PDV-SAN FELIPE > Cuarto Refrigerado',      3, @loc_pdv, 54, 0, NOW(), NOW()),
  ('Difusor Sala de Proceso', 'CARNES SANTACRUZ > PDV-SAN FELIPE > Difusor Sala de Proceso', 3, @loc_pdv, 54, 0, NOW(), NOW());

-- PDV-SIMON BOLIVAR (entidad 52)
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('PDV-SIMON BOLIVAR', 'CARNES SANTACRUZ > PDV-SIMON BOLIVAR', 2, @loc_carnes, 52, 1, NOW(), NOW());
SET @loc_pdv := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Sala de Proceso Pequeña', 'CARNES SANTACRUZ > PDV-SIMON BOLIVAR > Sala de Proceso Pequeña', 3, @loc_pdv, 52, 0, NOW(), NOW()),
  ('Sala de Proceso',         'CARNES SANTACRUZ > PDV-SIMON BOLIVAR > Sala de Proceso',         3, @loc_pdv, 52, 0, NOW(), NOW()),
  ('Cuarto Congelación',      'CARNES SANTACRUZ > PDV-SIMON BOLIVAR > Cuarto Congelación',      3, @loc_pdv, 52, 0, NOW(), NOW()),
  ('Cuarto Refrigerado',      'CARNES SANTACRUZ > PDV-SIMON BOLIVAR > Cuarto Refrigerado',      3, @loc_pdv, 52, 0, NOW(), NOW());

-- PDV-SOLEDAD (entidad 51)
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('PDV-SOLEDAD', 'CARNES SANTACRUZ > PDV-SOLEDAD', 2, @loc_carnes, 51, 1, NOW(), NOW());
SET @loc_pdv := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Cuarto Congelación 1', 'CARNES SANTACRUZ > PDV-SOLEDAD > Cuarto Congelación 1', 3, @loc_pdv, 51, 0, NOW(), NOW()),
  ('Cuarto Congelación 2', 'CARNES SANTACRUZ > PDV-SOLEDAD > Cuarto Congelación 2', 3, @loc_pdv, 51, 0, NOW(), NOW()),
  ('Cuarto Refrigerado',   'CARNES SANTACRUZ > PDV-SOLEDAD > Cuarto Refrigerado',   3, @loc_pdv, 51, 0, NOW(), NOW());

-- RESTAURANTE LA 43
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('RESTAURANTE LA 43', 'CARNES SANTACRUZ > RESTAURANTE LA 43', 2, @loc_carnes, @ent_rest43, 1, NOW(), NOW());
SET @loc_rest := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Cocina',             'CARNES SANTACRUZ > RESTAURANTE LA 43 > Cocina',             3, @loc_rest, @ent_rest43, 0, NOW(), NOW()),
  ('Salón / Comedor',    'CARNES SANTACRUZ > RESTAURANTE LA 43 > Salón / Comedor',    3, @loc_rest, @ent_rest43, 0, NOW(), NOW()),
  ('Cuarto Congelación', 'CARNES SANTACRUZ > RESTAURANTE LA 43 > Cuarto Congelación', 3, @loc_rest, @ent_rest43, 0, NOW(), NOW()),
  ('Cuarto Refrigerado', 'CARNES SANTACRUZ > RESTAURANTE LA 43 > Cuarto Refrigerado', 3, @loc_rest, @ent_rest43, 0, NOW(), NOW()),
  ('Bodega',             'CARNES SANTACRUZ > RESTAURANTE LA 43 > Bodega',             3, @loc_rest, @ent_rest43, 0, NOW(), NOW());

-- RESTAURANTE LA 93
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('RESTAURANTE LA 93', 'CARNES SANTACRUZ > RESTAURANTE LA 93', 2, @loc_carnes, @ent_rest93, 1, NOW(), NOW());
SET @loc_rest := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Cocina',             'CARNES SANTACRUZ > RESTAURANTE LA 93 > Cocina',             3, @loc_rest, @ent_rest93, 0, NOW(), NOW()),
  ('Salón / Comedor',    'CARNES SANTACRUZ > RESTAURANTE LA 93 > Salón / Comedor',    3, @loc_rest, @ent_rest93, 0, NOW(), NOW()),
  ('Cuarto Congelación', 'CARNES SANTACRUZ > RESTAURANTE LA 93 > Cuarto Congelación', 3, @loc_rest, @ent_rest93, 0, NOW(), NOW()),
  ('Cuarto Refrigerado', 'CARNES SANTACRUZ > RESTAURANTE LA 93 > Cuarto Refrigerado', 3, @loc_rest, @ent_rest93, 0, NOW(), NOW()),
  ('Bodega',             'CARNES SANTACRUZ > RESTAURANTE LA 93 > Bodega',             3, @loc_rest, @ent_rest93, 0, NOW(), NOW());

-- RESTAURANTE MALAMBO
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('RESTAURANTE MALAMBO', 'CARNES SANTACRUZ > RESTAURANTE MALAMBO', 2, @loc_carnes, @ent_restmal, 1, NOW(), NOW());
SET @loc_rest := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Cocina',             'CARNES SANTACRUZ > RESTAURANTE MALAMBO > Cocina',             3, @loc_rest, @ent_restmal, 0, NOW(), NOW()),
  ('Salón / Comedor',    'CARNES SANTACRUZ > RESTAURANTE MALAMBO > Salón / Comedor',    3, @loc_rest, @ent_restmal, 0, NOW(), NOW()),
  ('Cuarto Congelación', 'CARNES SANTACRUZ > RESTAURANTE MALAMBO > Cuarto Congelación', 3, @loc_rest, @ent_restmal, 0, NOW(), NOW()),
  ('Cuarto Refrigerado', 'CARNES SANTACRUZ > RESTAURANTE MALAMBO > Cuarto Refrigerado', 3, @loc_rest, @ent_restmal, 0, NOW(), NOW()),
  ('Bodega',             'CARNES SANTACRUZ > RESTAURANTE MALAMBO > Bodega',             3, @loc_rest, @ent_restmal, 0, NOW(), NOW());

-- ----------------------------------------------------------------------------
-- 2.d INVERSIONES SERRANO MILLAN + subárbol
-- ----------------------------------------------------------------------------
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('INVERSIONES SERRANO MILLAN', 'INVERSIONES SERRANO MILLAN', 1, 0, 46, 1, NOW(), NOW());
SET @loc_inv := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Contabilidad',                  'INVERSIONES SERRANO MILLAN > Contabilidad',                  2, @loc_inv, 46, 0, NOW(), NOW()),
  ('Despacho',                      'INVERSIONES SERRANO MILLAN > Despacho',                      2, @loc_inv, 46, 0, NOW(), NOW()),
  ('Facturación',                   'INVERSIONES SERRANO MILLAN > Facturación',                   2, @loc_inv, 46, 0, NOW(), NOW()),
  ('Montería',                      'INVERSIONES SERRANO MILLAN > Montería',                      2, @loc_inv, 46, 0, NOW(), NOW()),
  ('Mantenimiento',                 'INVERSIONES SERRANO MILLAN > Mantenimiento',                 2, @loc_inv, 46, 0, NOW(), NOW()),
  ('Producción',                    'INVERSIONES SERRANO MILLAN > Producción',                    2, @loc_inv, 46, 0, NOW(), NOW()),
  ('Planta Eléctrica Inversiones',  'INVERSIONES SERRANO MILLAN > Planta Eléctrica Inversiones',  2, @loc_inv, 46, 0, NOW(), NOW()),
  ('Gerencia (Inversiones)',        'INVERSIONES SERRANO MILLAN > Gerencia (Inversiones)',        2, @loc_inv, 46, 0, NOW(), NOW()),
  ('Compras Inversiones',           'INVERSIONES SERRANO MILLAN > Compras Inversiones',           2, @loc_inv, 46, 0, NOW(), NOW());

-- ----------------------------------------------------------------------------
-- 2.e TRANSANTACRUZ + subárbol
-- ----------------------------------------------------------------------------
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('TRANSANTACRUZ', 'TRANSANTACRUZ', 1, 0, @ent_transantacruz, 1, NOW(), NOW());
SET @loc_trans := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Oficinas Transantacruz', 'TRANSANTACRUZ > Oficinas Transantacruz', 2, @loc_trans, @ent_transantacruz, 0, NOW(), NOW());

-- ----------------------------------------------------------------------------
-- 2.f ALMACEN CENTRAL + subárbol
-- ----------------------------------------------------------------------------
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation)
VALUES ('ALMACEN CENTRAL', 'ALMACEN CENTRAL', 1, 0, 70, 1, NOW(), NOW());
SET @loc_alm := LAST_INSERT_ID();
INSERT INTO glpi_locations (name, completename, level, locations_id, entities_id, is_recursive, date_mod, date_creation) VALUES
  ('Estantería 1', 'ALMACEN CENTRAL > Estantería 1', 2, @loc_alm, 70, 0, NOW(), NOW()),
  ('Estantería 2', 'ALMACEN CENTRAL > Estantería 2', 2, @loc_alm, 70, 0, NOW(), NOW()),
  ('Estantería 3', 'ALMACEN CENTRAL > Estantería 3', 2, @loc_alm, 70, 0, NOW(), NOW()),
  ('Estantería 4', 'ALMACEN CENTRAL > Estantería 4', 2, @loc_alm, 70, 0, NOW(), NOW()),
  ('Estantería 5', 'ALMACEN CENTRAL > Estantería 5', 2, @loc_alm, 70, 0, NOW(), NOW());

-- ============================================================================
-- 3) SUPERVISORES NUEVOS (4 usuarios) -- perfil Supervisor PDV existente
-- ============================================================================
SET @sup_profile := (SELECT id FROM glpi_profiles WHERE name='Supervisor PDV');
SET @pwd_hash    := '$2y$10$MmjFzopahFrBx9ptTNt7l.FCwhN9Mtr4iWuINfapmZB6Y4NjavXfm'; -- Santacruz2026

INSERT INTO glpi_users
  (name, password, password_last_update, realname, firstname,
   language, is_active, is_deleted, authtype, auths_id, date_creation, date_mod)
VALUES
  ('supervisor.alameda2',         @pwd_hash, NOW(), 'Supervisor', 'PDV Alameda 2',       'es_ES', 1, 0, 1, 0, NOW(), NOW()),
  ('supervisor.restaurante43',    @pwd_hash, NOW(), 'Supervisor', 'Restaurante La 43',   'es_ES', 1, 0, 1, 0, NOW(), NOW()),
  ('supervisor.restaurante93',    @pwd_hash, NOW(), 'Supervisor', 'Restaurante La 93',   'es_ES', 1, 0, 1, 0, NOW(), NOW()),
  ('supervisor.restaurantemalambo', @pwd_hash, NOW(), 'Supervisor', 'Restaurante Malambo', 'es_ES', 1, 0, 1, 0, NOW(), NOW());

-- Mapear cada supervisor a su entidad nueva
INSERT INTO glpi_profiles_users (users_id, profiles_id, entities_id, is_recursive, is_dynamic)
SELECT id, @sup_profile, @ent_alameda2, 0, 0 FROM glpi_users WHERE name='supervisor.alameda2'
UNION ALL
SELECT id, @sup_profile, @ent_rest43,   0, 0 FROM glpi_users WHERE name='supervisor.restaurante43'
UNION ALL
SELECT id, @sup_profile, @ent_rest93,   0, 0 FROM glpi_users WHERE name='supervisor.restaurante93'
UNION ALL
SELECT id, @sup_profile, @ent_restmal,  0, 0 FROM glpi_users WHERE name='supervisor.restaurantemalambo';

-- Fijar entidad y perfil por defecto en cada usuario
UPDATE glpi_users u
  JOIN glpi_profiles_users pu ON pu.users_id = u.id
   SET u.entities_id = pu.entities_id,
       u.profiles_id = pu.profiles_id
 WHERE u.name IN ('supervisor.alameda2','supervisor.restaurante43','supervisor.restaurante93','supervisor.restaurantemalambo');

COMMIT;

-- ============================================================================
-- 4) VALIDACIÓN
-- ============================================================================
SELECT '== ENTIDADES (32 totales esperadas) ==' AS info;
SELECT id, name, completename, level
  FROM glpi_entities
 ORDER BY completename;

SELECT '== UBICACIONES POR EMPRESA (totales) ==' AS info;
SELECT
  CASE
    WHEN entities_id = 0  THEN 'GRUPO SANTACRUZ (transversales)'
    WHEN entities_id = 44 THEN 'AGROPECUARIA'
    WHEN entities_id = 45 THEN 'CARNES SANTACRUZ'
    WHEN entities_id = 46 THEN 'INVERSIONES SERRANO MILLAN'
    WHEN entities_id = 70 THEN 'ALMACEN CENTRAL'
    WHEN entities_id = @ent_transantacruz THEN 'TRANSANTACRUZ'
    WHEN entities_id = @ent_planta_bov    THEN 'PLANTA BENEFICIO BOVINO'
    WHEN entities_id = @ent_planta_por    THEN 'PLANTA BENEFICIO PORCINO'
    WHEN entities_id = @ent_alameda2      THEN 'PDV-ALAMEDA 2'
    WHEN entities_id = @ent_rest43        THEN 'RESTAURANTE LA 43'
    WHEN entities_id = @ent_rest93        THEN 'RESTAURANTE LA 93'
    WHEN entities_id = @ent_restmal       THEN 'RESTAURANTE MALAMBO'
    ELSE CONCAT('Entidad ', entities_id)
  END AS empresa,
  COUNT(*) AS ubicaciones
FROM glpi_locations
GROUP BY empresa
ORDER BY ubicaciones DESC;

SELECT '== TOTAL UBICACIONES ==' AS info;
SELECT COUNT(*) AS total_ubicaciones FROM glpi_locations;

SELECT '== SUPERVISORES (20 totales esperados) ==' AS info;
SELECT u.id, u.name, u.firstname, e.name AS entidad
  FROM glpi_users u
  JOIN glpi_profiles_users pu ON pu.users_id = u.id
  JOIN glpi_entities e        ON e.id        = pu.entities_id
 WHERE u.name LIKE 'supervisor.%'
 ORDER BY u.name;
