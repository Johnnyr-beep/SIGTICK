-- Agrega columnas personalizadas a la tabla glpi_computers
-- Ejecutar contra la base de datos TICKETS_DB

ALTER TABLE `glpi_computers`
    ADD COLUMN `procesador` VARCHAR(255) NULL DEFAULT NULL AFTER `comment`,
    ADD COLUMN `ram` VARCHAR(100) NULL DEFAULT NULL AFTER `procesador`,
    ADD COLUMN `licencia_windows` VARCHAR(255) NULL DEFAULT NULL AFTER `ram`,
    ADD COLUMN `disco_duro` VARCHAR(100) NULL DEFAULT NULL AFTER `licencia_windows`;
