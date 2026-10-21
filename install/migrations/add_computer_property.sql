-- Agrega el campo Propiedad a las computadoras.
-- Ejecutar una sola vez contra la base de datos GLPI.

ALTER TABLE `glpi_computers`
    ADD COLUMN `propiedad` VARCHAR(20) NULL DEFAULT NULL;
