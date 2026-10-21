-- =====================================================================
-- 10_pdf_plugin_install.sql
-- ---------------------------------------------------------------------
-- Reinstala las tablas y permisos del plugin PDF en la BD de producción.
-- El plugin tenia state=1 pero sus tablas no existian, por eso las
-- customizaciones (logo, acta de entrega, colores Santacruz) no se veian.
--
-- Idempotente: usa CREATE TABLE IF NOT EXISTS y INSERT IGNORE.
-- =====================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================================
-- 1. Tabla de configuración del plugin
-- =====================================================================
CREATE TABLE IF NOT EXISTS `glpi_plugin_pdf_configs` (
    `id` int unsigned NOT NULL,
    `currency` varchar(15) DEFAULT NULL,
    `add_text` varchar(255) DEFAULT NULL,
    `use_branding_logo` tinyint(1) DEFAULT 0,
    `date_mod` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

INSERT IGNORE INTO `glpi_plugin_pdf_configs` (`id`, `currency`, `add_text`, `use_branding_logo`, `date_mod`)
VALUES (1, 'COP', NULL, 0, NOW());

-- =====================================================================
-- 2. Tabla de preferencias del plugin
-- =====================================================================
CREATE TABLE IF NOT EXISTS `glpi_plugin_pdf_preferences` (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    `users_id` int unsigned NOT NULL COMMENT 'RELATION to glpi_users (id)',
    `itemtype` varchar(100) NOT NULL COMMENT 'see define.php *_TYPE constant',
    `tabref` varchar(255) NOT NULL COMMENT 'ref of tab to display',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- =====================================================================
-- 3. Permisos: dar acceso "use" (rights=1) al plugin PDF en perfiles relevantes
-- =====================================================================
-- profiles 3=Admin, 4=Super-Admin, 6=Technician, 7=Supervisor → permiso=1
UPDATE glpi_profilerights
   SET rights = 1
 WHERE name = 'plugin_pdf'
   AND profiles_id IN (3, 4, 6, 7);

-- Para los demás (Self-Service id=1, Observer id=5, Hotliner id=2, Read-Only id=8) dejamos 0.
-- Si quieres dar acceso a todos, descomenta:
-- UPDATE glpi_profilerights SET rights = 1 WHERE name = 'plugin_pdf';

-- =====================================================================
-- 4. Resultado
-- =====================================================================
SET FOREIGN_KEY_CHECKS = 1;

SELECT 'Plugin PDF reparado correctamente.' AS resultado;
SELECT TABLE_NAME, TABLE_ROWS
  FROM information_schema.TABLES
 WHERE TABLE_SCHEMA = DATABASE()
   AND TABLE_NAME LIKE 'glpi_plugin_pdf%';
SELECT id, currency, add_text, use_branding_logo FROM glpi_plugin_pdf_configs;
SELECT pr.profiles_id, p.name AS profile_name, pr.rights
  FROM glpi_profilerights pr
  JOIN glpi_profiles p ON p.id = pr.profiles_id
 WHERE pr.name = 'plugin_pdf'
 ORDER BY pr.profiles_id;
