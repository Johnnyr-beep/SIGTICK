-- =====================================================================
-- RECOVERY: Recrear entidad raiz para que GLPI vuelva a funcionar
-- Ejecutar UNA SOLA VEZ
-- =====================================================================

-- Insertar la entidad raiz (id=0). Si ya existe, no hace nada.
INSERT IGNORE INTO `glpi_entities`
  (`id`, `name`, `entities_id`, `completename`, `comment`, `level`, `ancestors_cache`, `sons_cache`)
VALUES
  (0, 'Entidad raiz', 0, 'Entidad raiz', 'Entidad raiz del sistema', 1, NULL, NULL);

-- Verificar
SELECT id, name, completename, level FROM glpi_entities;
