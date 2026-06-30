<?php
/**
 * 30_apply.php
 * Corrige el dropdown del menú de usuario (cabecera con foto/avatar)
 * para que NO se corte en pantallas móviles.
 *
 * El dropdown usa Bootstrap 5 + Tabler con clase .dropdown-menu-end,
 * lo que hace que se posicione alineado a la derecha del trigger.
 * En pantallas <= 576px se sale por el borde izquierdo o derecho.
 *
 * Solución: forzar en móvil que el panel del menú se posicione fijo
 * en la parte superior derecha con un ancho calculado para no salirse,
 * y con scroll interno si el contenido es alto.
 *
 * Aplica en glpi_entities.id=0 concatenando al custom_css_code actual.
 * Backup en _bk30_entities.
 */

$pdo = new PDO(
    "mysql:host=20.121.178.90;dbname=TICKETS_DB;charset=utf8mb4",
    "root",
    "Root",
    [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci",
    ]
);

$EXTRA_CSS = <<<'CSS'

/* ============================================================
   GRUPO SANTACRUZ - Fix menu usuario (Cerrar sesion) en movil
   ============================================================ */

/* --- En cualquier resolucion: que NUNCA se salga del viewport --- */
.user-menu .dropdown-menu,
.navbar-nav .user-menu-dropdown-toggle + .dropdown-menu {
    max-width: calc(100vw - 16px);
    max-height: calc(100vh - 70px);
    overflow-y: auto;
    overflow-x: hidden;
}

/* Items del menu: padding tactil */
.user-menu .dropdown-menu .dropdown-item {
    padding: 0.6rem 1rem;
    min-height: var(--sc-touch-min, 44px);
    display: flex;
    align-items: center;
    gap: 0.5rem;
    white-space: normal;
    word-wrap: break-word;
}

.user-menu .dropdown-menu .dropdown-item i {
    flex: 0 0 auto;
    font-size: 1.1rem;
}

/* Header (nombre del usuario) que no se desborde */
.user-menu .dropdown-menu .dropdown-header {
    white-space: normal;
    word-wrap: break-word;
    font-weight: 600;
    padding: 0.75rem 1rem;
}

/* El selector de perfil/entidad dentro del dropdown */
.user-menu .dropdown-menu .profile-selector,
.user-menu .dropdown-menu form,
.user-menu .dropdown-menu .select2-container {
    max-width: 100% !important;
    width: 100% !important;
}

/* --- Tablet y movil: panel ocupa esquina superior derecha --- */
@media (max-width: 768px) {
    .user-menu .dropdown-menu.show,
    .navbar-nav .user-menu-dropdown-toggle.show + .dropdown-menu {
        position: fixed !important;
        top: 56px !important;
        right: 8px !important;
        left: auto !important;
        bottom: auto !important;
        transform: none !important;
        width: 280px;
        max-width: calc(100vw - 16px);
        max-height: calc(100vh - 70px);
        margin: 0 !important;
        z-index: 1080;
        box-shadow: 0 10px 30px rgba(0,0,0,0.25);
        border-radius: 10px;
    }
}

/* --- Movil pequeño: panel casi full-width centrado --- */
@media (max-width: 480px) {
    .user-menu .dropdown-menu.show,
    .navbar-nav .user-menu-dropdown-toggle.show + .dropdown-menu {
        right: 8px !important;
        left: 8px !important;
        width: auto !important;
        max-width: none !important;
    }

    /* El select2 (selector de perfil) ocupa todo el ancho */
    .user-menu .dropdown-menu .select2-container--default .select2-selection--single {
        height: var(--sc-touch-min, 44px);
        line-height: var(--sc-touch-min, 44px);
    }
    .user-menu .dropdown-menu .select2-container--default .select2-selection__rendered {
        line-height: var(--sc-touch-min, 44px);
    }
}

/* Dropdowns globales (otros menús de la topbar): mismo guard */
@media (max-width: 576px) {
    .navbar .dropdown-menu.dropdown-menu-end {
        right: 8px !important;
        left: auto !important;
        max-width: calc(100vw - 16px);
    }
}
CSS;

echo "=== Backup CSS actual (entidad raíz) ===\n";
$pdo->exec("DROP TABLE IF EXISTS _bk30_entities");
$pdo->exec("CREATE TABLE _bk30_entities AS
            SELECT id, enable_custom_css, custom_css_code
              FROM glpi_entities WHERE id = 0");

$row = $pdo->query("SELECT enable_custom_css, CHAR_LENGTH(custom_css_code) AS len
                    FROM glpi_entities WHERE id = 0")->fetch(PDO::FETCH_ASSOC);
echo "  Estado previo: enable_custom_css={$row['enable_custom_css']} css_len={$row['len']}\n\n";

echo "=== Anexando reglas para fix de menú usuario en móvil ===\n";
$stmt = $pdo->prepare("UPDATE glpi_entities
                          SET custom_css_code = CONCAT(COALESCE(custom_css_code,''), :extra),
                              enable_custom_css = 1
                        WHERE id = 0");
$stmt->execute([':extra' => $EXTRA_CSS]);
echo "  Filas afectadas: " . $stmt->rowCount() . "\n\n";

echo "=== Verificación ===\n";
$row = $pdo->query("SELECT enable_custom_css, CHAR_LENGTH(custom_css_code) AS len
                    FROM glpi_entities WHERE id = 0")->fetch(PDO::FETCH_ASSOC);
echo "  enable_custom_css = {$row['enable_custom_css']}\n";
echo "  longitud CSS      = {$row['len']} bytes\n";

echo "\nHecho. Limpia caché para que se vea de inmediato.\n";
