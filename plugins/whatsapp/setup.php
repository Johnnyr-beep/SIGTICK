<?php

/**
 * WhatsApp integration plugin for GLPI.
 * Phase 1: scaffold + Meta Cloud API webhook receiver.
 */

define('PLUGIN_WHATSAPP_VERSION', '0.1.0');
define('PLUGIN_WHATSAPP_MIN_GLPI', '10.0.0');
define('PLUGIN_WHATSAPP_MAX_GLPI', '11.99.99');

function plugin_init_whatsapp()
{
    /** @var array $PLUGIN_HOOKS */
    global $PLUGIN_HOOKS;

    $PLUGIN_HOOKS['csrf_compliant']['whatsapp'] = true;

    Plugin::registerClass('PluginWhatsappConfig');

    if (!Plugin::isPluginActive('whatsapp')) {
        return;
    }

    // Admin config entry (Setup > General > plugin)
    $PLUGIN_HOOKS['config_page']['whatsapp'] = 'front/config.form.php';
    $PLUGIN_HOOKS['menu_toadd']['whatsapp']  = ['config' => 'PluginWhatsappConfig'];
}

function plugin_version_whatsapp()
{
    return [
        'name'         => 'WhatsApp',
        'version'      => PLUGIN_WHATSAPP_VERSION,
        'author'       => 'Grupo Santacruz',
        'license'      => 'GPLv3',
        'homepage'     => '',
        'requirements' => [
            'glpi' => [
                'min' => PLUGIN_WHATSAPP_MIN_GLPI,
                'max' => PLUGIN_WHATSAPP_MAX_GLPI,
            ],
        ],
    ];
}

function plugin_whatsapp_check_prerequisites()
{
    return true;
}

function plugin_whatsapp_check_config($verbose = false)
{
    return true;
}
