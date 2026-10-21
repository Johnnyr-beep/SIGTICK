<?php

define('PLUGIN_AUTOINVENTORY_VERSION', '1.0.0');

function plugin_init_autoinventory()
{
    global $PLUGIN_HOOKS;

    $PLUGIN_HOOKS['csrf_compliant']['autoinventory'] = true;

    $itemtypes = [
        'Computer',
        'Monitor',
        'Printer',
        'NetworkEquipment',
        'Phone',
        'Peripheral',
    ];

    foreach ($itemtypes as $itemtype) {
        $PLUGIN_HOOKS['pre_item_add']['autoinventory'][$itemtype] = 'plugin_autoinventory_pre_add';
    }
}

function plugin_version_autoinventory()
{
    return [
        'name'           => 'Auto Inventario Santacruz',
        'version'        => PLUGIN_AUTOINVENTORY_VERSION,
        'author'         => 'Grupo Santacruz',
        'license'        => 'AGPLv3',
        'homepage'       => '',
        'requirements'   => [
            'glpi' => [
                'min' => '11.0',
            ],
        ],
    ];
}

function plugin_autoinventory_check_prerequisites()
{
    return true;
}

function plugin_autoinventory_check_config($verbose = false)
{
    return true;
}

/**
 * Hook pre_item_add: assigns otherserial automatically if empty.
 */
function plugin_autoinventory_pre_add(CommonDBTM $item)
{
    // Only act if otherserial is empty
    if (!empty($item->input['otherserial'])) {
        return $item;
    }

    $itemtype    = $item->getType();
    $entities_id = $item->input['entities_id'] ?? 0;

    // Entity prefix
    $entity_name = Dropdown::getDropdownName('glpi_entities', $entities_id);
    $entity_lower = mb_strtolower($entity_name);
    if (str_contains($entity_lower, 'inversion')) {
        $entity_prefix = 'CFSC';
    } elseif (str_contains($entity_lower, 'carne')) {
        $entity_prefix = 'CSC';
    } elseif (str_contains($entity_lower, 'agropecuaria')) {
        $entity_prefix = 'ASC';
    } else {
        $entity_prefix = 'GSC';
    }

    // Type prefix
    $type_map = [
        'Computer'         => 'PC',
        'Monitor'          => 'MON',
        'Printer'          => 'IMP',
        'NetworkEquipment' => 'NET',
        'Phone'            => 'TEL',
        'Peripheral'       => 'PER',
    ];
    $type_prefix = $type_map[$itemtype] ?? 'EQ';

    // For computers, refine prefix by computer type (Portátil, Escritorio, NUC, Microtorre)
    if ($itemtype === 'Computer' && !empty($item->input['computertypes_id'])) {
        $ctype_name = mb_strtolower(Dropdown::getDropdownName(
            'glpi_computertypes',
            $item->input['computertypes_id']
        ));
        if (str_contains($ctype_name, 'portátil') || str_contains($ctype_name, 'portatil') || str_contains($ctype_name, 'laptop')) {
            $type_prefix = 'PORT';
        } elseif (str_contains($ctype_name, 'nuc')) {
            $type_prefix = 'NUC';
        } elseif (str_contains($ctype_name, 'microtorre') || str_contains($ctype_name, 'micro torre')) {
            $type_prefix = 'MT';
        } elseif (str_contains($ctype_name, 'escritorio') || str_contains($ctype_name, 'desktop')) {
            $type_prefix = 'ESC';
        }
    }

    $base = $entity_prefix . '-' . $type_prefix . '-';

    // Find next correlative across ALL entities of same matching prefix
    /** @var DBmysql $DB */
    global $DB;

    $table = getTableForItemType($itemtype);

    $iterator = $DB->request([
        'SELECT' => ['otherserial'],
        'FROM'   => $table,
        'WHERE'  => [
            'otherserial' => ['LIKE', $DB->escape($base) . '%'],
        ],
    ]);

    $max = 0;
    foreach ($iterator as $row) {
        if (preg_match('/' . preg_quote($base, '/') . '(\d+)$/', $row['otherserial'], $m)) {
            $n = (int) $m[1];
            if ($n > $max) {
                $max = $n;
            }
        }
    }

    $next = $max + 1;
    $item->input['otherserial'] = $base . str_pad((string) $next, 3, '0', STR_PAD_LEFT);

    return $item;
}
