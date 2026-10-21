<?php
/**
 * 29_apply.php
 * Habilita CSS personalizado en la entidad raíz (id=0) con mejoras
 * responsive para móvil/tablet:
 *   - Touch targets más grandes (>= 44px)
 *   - Inputs/botones cómodos en móvil
 *   - Tablas con scroll horizontal
 *   - Sidebar/topbar más legible en pantallas chicas
 *   - Boton flotante "+ Ticket" en helpdesk en móvil
 *
 * Backup en _bk29_entities (campos relevantes únicamente).
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

$CSS = <<<'CSS'
/* ============================================================
   GRUPO SANTACRUZ - Custom CSS responsivo (movil/tablet)
   Aplica a TODAS las paginas (helpdesk y central).
   ============================================================ */

/* Variables marca Santacruz */
:root {
    --sc-green: #2E7D32;
    --sc-green-dark: #1B5E20;
    --sc-green-soft: #E8F5E9;
    --sc-touch-min: 44px;
}

/* === GENERAL === */
html { -webkit-text-size-adjust: 100%; }
body { -webkit-tap-highlight-color: transparent; }

/* Inputs cómodos en cualquier resolución */
input[type="text"],
input[type="email"],
input[type="password"],
input[type="number"],
input[type="search"],
input[type="tel"],
input[type="url"],
textarea,
select,
.form-control,
.form-select {
    font-size: 16px !important;  /* evita zoom auto del iPhone */
    min-height: 44px;
}

/* Botones touch-friendly */
.btn {
    min-height: 40px;
    padding-left: 14px;
    padding-right: 14px;
}
.btn-sm { min-height: 34px; }

/* === SCROLL HORIZONTAL EN TABLAS GRANDES === */
.table-responsive {
    -webkit-overflow-scrolling: touch;
}
@media (max-width: 992px) {
    table.dataTable, table.tab_cadre_fixe, table.tab_cadre {
        font-size: 13px;
    }
    .glpi_tabs .nav-link { padding: 8px 10px; font-size: 13px; }
}

/* === TOPBAR / NAVBAR EN MOVIL === */
@media (max-width: 768px) {
    .navbar-brand img { max-height: 36px; }
    .navbar-toggler { padding: 8px 12px; }
    /* Ocultar la barra de busqueda fuzzy en pantallas pequeñas */
    #fuzzysearch, .fuzzy-search-input { display: none !important; }
    /* Logo header mas chico */
    header .navbar { padding: 6px 10px; }
}

/* === SIDEBAR (offcanvas en mobile) === */
@media (max-width: 992px) {
    .sidebar, aside.navbar-vertical {
        width: 78vw !important;
        max-width: 320px;
    }
    .sidebar .nav-link, aside .nav-link {
        padding: 12px 14px;
        font-size: 15px;
    }
    .sidebar .nav-link i, aside .nav-link i {
        font-size: 20px;
    }
}

/* === FORMULARIOS DE TICKETS EN MOVIL === */
@media (max-width: 768px) {
    /* Apilar labels y campos */
    .form-group.row, .row.form-group {
        flex-direction: column;
    }
    .form-group.row > label, .row.form-group > label {
        text-align: left !important;
        margin-bottom: 6px;
    }
    /* Botones principales del form full-width */
    .form-actions .btn,
    .form-buttonbar .btn {
        width: 100%;
        margin-bottom: 8px;
    }
    .form-actions, .form-buttonbar {
        flex-direction: column;
        gap: 6px;
    }
    /* Ticket: layout principal en pila */
    .timeline-content, .central { padding: 10px !important; }
    .card-body { padding: 12px !important; }
}

/* === BOTON FLOTANTE PARA CREAR TICKET (mobile helpdesk) === */
@media (max-width: 768px) {
    a.fab-new-ticket,
    .floating-add-ticket {
        position: fixed;
        bottom: 18px;
        right: 18px;
        z-index: 1050;
        background: var(--sc-green);
        color: #ffffff !important;
        width: 56px;
        height: 56px;
        border-radius: 50%;
        display: flex !important;
        align-items: center;
        justify-content: center;
        font-size: 28px;
        box-shadow: 0 4px 14px rgba(0,0,0,0.25);
        text-decoration: none !important;
    }
    a.fab-new-ticket:active { transform: scale(0.94); }
}

/* === TIMELINE / SEGUIMIENTOS DE TICKET === */
@media (max-width: 768px) {
    .timeline-item, .followup-content {
        padding: 10px !important;
        margin-bottom: 8px !important;
    }
    .timeline-item .avatar { width: 32px; height: 32px; }
}

/* === SEARCH RESULTS - TARJETAS EN MOVIL === */
@media (max-width: 576px) {
    /* Cabeceras de tabla mas compactas */
    table thead th { font-size: 11px; padding: 6px 4px !important; }
    table tbody td { padding: 8px 4px !important; }
    /* Status badges con tamaño legible */
    .badge { font-size: 11px; padding: 4px 8px; }
}

/* === DASHBOARDS === */
@media (max-width: 768px) {
    .dashboard .card-body { padding: 10px !important; }
    .dashboard .grid-stack-item { min-height: 120px; }
    .dashboard h3, .dashboard h4 { font-size: 16px !important; }
}

/* === MODALES === */
@media (max-width: 576px) {
    .modal-dialog { margin: 8px; max-width: calc(100vw - 16px); }
    .modal-content { border-radius: 12px; }
    .modal-header, .modal-footer { padding: 12px; }
    .modal-body { padding: 12px; max-height: 70vh; overflow-y: auto; }
}

/* === ACCESIBILIDAD === */
:focus-visible {
    outline: 2px solid var(--sc-green) !important;
    outline-offset: 2px;
}

/* Colores corporativos en botones primarios */
.btn-primary {
    background-color: var(--sc-green);
    border-color: var(--sc-green);
}
.btn-primary:hover,
.btn-primary:focus {
    background-color: var(--sc-green-dark);
    border-color: var(--sc-green-dark);
}
.btn-outline-primary {
    color: var(--sc-green);
    border-color: var(--sc-green);
}
.btn-outline-primary:hover {
    background-color: var(--sc-green);
    border-color: var(--sc-green);
}

/* Link color */
a:not(.btn) { color: var(--sc-green-dark); }
a:not(.btn):hover { color: var(--sc-green); }

/* === SAFE AREA (iPhone notch / Android nav bar) === */
@supports (padding: max(0px)) {
    body {
        padding-left: env(safe-area-inset-left);
        padding-right: env(safe-area-inset-right);
    }
    @media (max-width: 768px) {
        a.fab-new-ticket {
            bottom: max(18px, env(safe-area-inset-bottom));
            right: max(18px, env(safe-area-inset-right));
        }
    }
}
CSS;

echo "=== Backup entidad raíz ===\n";
$pdo->exec("DROP TABLE IF EXISTS _bk29_entities");
$pdo->exec("CREATE TABLE _bk29_entities AS
    SELECT id, name, enable_custom_css, custom_css_code FROM glpi_entities WHERE id=0");
$row = $pdo->query("SELECT * FROM _bk29_entities")->fetch(PDO::FETCH_ASSOC);
echo "  Estado previo: enable_custom_css=" . $row["enable_custom_css"] . " css_len=" . strlen($row["custom_css_code"]) . "\n";

echo "\n=== Aplicando custom CSS responsive en entidad raíz ===\n";
$stmt = $pdo->prepare("UPDATE glpi_entities SET enable_custom_css=1, custom_css_code=:css WHERE id=0");
$stmt->execute([':css' => $CSS]);
echo "  Filas afectadas: " . $stmt->rowCount() . "\n";

echo "\n=== Verificación ===\n";
$row = $pdo->query("SELECT enable_custom_css, LENGTH(custom_css_code) clen FROM glpi_entities WHERE id=0")->fetch(PDO::FETCH_ASSOC);
echo "  enable_custom_css = " . $row["enable_custom_css"] . " (1=activado)\n";
echo "  longitud CSS      = " . $row["clen"] . " bytes\n";

echo "\nHecho. Limpia caché para que se vea de inmediato.\n";
