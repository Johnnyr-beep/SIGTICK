-- =====================================================================
-- 26_subentidades_inversiones.sql
-- Crea 9 subentidades L3 bajo INVERSIONES SERRANO MILLAN (id=46)
-- =====================================================================
-- IMPORTANTE: Aplicar con PHP/PDO (charset=utf8mb4) por los acentos.
-- Si se aplica con `mysql < file.sql` la consola cp850 corrompe la UTF-8.
-- Backup automático a tabla _bk26_entities (ver migration_prod/26_apply.php).
-- ---------------------------------------------------------------------

START TRANSACTION;

INSERT INTO glpi_entities
    (name, entities_id, completename, level, ancestors_cache, tag, date_creation, date_mod)
VALUES
    ('Contabilidad',                  46, 'GRUPO SANTACRUZ > INVERSIONES SERRANO MILLAN > Contabilidad',                  3, '{"0":0,"46":46}', 'INVERSIONES', NOW(), NOW()),
    ('Despacho',                      46, 'GRUPO SANTACRUZ > INVERSIONES SERRANO MILLAN > Despacho',                      3, '{"0":0,"46":46}', 'INVERSIONES', NOW(), NOW()),
    ('Facturación',                   46, 'GRUPO SANTACRUZ > INVERSIONES SERRANO MILLAN > Facturación',                   3, '{"0":0,"46":46}', 'INVERSIONES', NOW(), NOW()),
    ('Montería',                      46, 'GRUPO SANTACRUZ > INVERSIONES SERRANO MILLAN > Montería',                      3, '{"0":0,"46":46}', 'INVERSIONES', NOW(), NOW()),
    ('Mantenimiento',                 46, 'GRUPO SANTACRUZ > INVERSIONES SERRANO MILLAN > Mantenimiento',                 3, '{"0":0,"46":46}', 'INVERSIONES', NOW(), NOW()),
    ('Producción',                    46, 'GRUPO SANTACRUZ > INVERSIONES SERRANO MILLAN > Producción',                    3, '{"0":0,"46":46}', 'INVERSIONES', NOW(), NOW()),
    ('Planta Eléctrica Inversiones',  46, 'GRUPO SANTACRUZ > INVERSIONES SERRANO MILLAN > Planta Eléctrica Inversiones',  3, '{"0":0,"46":46}', 'INVERSIONES', NOW(), NOW()),
    ('Gerencia (Inversiones)',        46, 'GRUPO SANTACRUZ > INVERSIONES SERRANO MILLAN > Gerencia (Inversiones)',        3, '{"0":0,"46":46}', 'INVERSIONES', NOW(), NOW()),
    ('Compras Inversiones',           46, 'GRUPO SANTACRUZ > INVERSIONES SERRANO MILLAN > Compras Inversiones',           3, '{"0":0,"46":46}', 'INVERSIONES', NOW(), NOW());

COMMIT;
