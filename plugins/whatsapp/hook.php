<?php

function plugin_whatsapp_install()
{
    /** @var \DBmysql $DB */
    global $DB;

    $table = 'glpi_plugin_whatsapp_configs';

    if (!$DB->tableExists($table)) {
        $query = "CREATE TABLE `$table` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `verify_token` VARCHAR(255) NOT NULL DEFAULT '',
            `app_secret` VARCHAR(255) NOT NULL DEFAULT '',
            `access_token` TEXT NOT NULL,
            `phone_number_id` VARCHAR(64) NOT NULL DEFAULT '',
            `waba_id` VARCHAR(64) NOT NULL DEFAULT '',
            `business_phone` VARCHAR(32) NOT NULL DEFAULT '',
            `default_entities_id` INT NOT NULL DEFAULT 0,
            `default_requesttypes_id` INT NOT NULL DEFAULT 0,
            `log_payloads` TINYINT NOT NULL DEFAULT 1,
            `is_active` TINYINT NOT NULL DEFAULT 0,
            `date_creation` TIMESTAMP NULL DEFAULT NULL,
            `date_mod` TIMESTAMP NULL DEFAULT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci";
        $DB->doQueryOrDie($query, 'Cannot create glpi_plugin_whatsapp_configs');

        $DB->insert($table, [
            'id'           => 1,
            'verify_token' => bin2hex(random_bytes(16)),
            'access_token' => '',
            'is_active'    => 0,
        ]);
    }

    // Storage folder for inbound webhook logs.
    $log_dir = GLPI_PLUGIN_DOC_DIR . '/whatsapp';
    if (!is_dir($log_dir)) {
        mkdir($log_dir, 0775, true);
    }

    return true;
}

function plugin_whatsapp_uninstall()
{
    /** @var \DBmysql $DB */
    global $DB;

    $table = 'glpi_plugin_whatsapp_configs';
    if ($DB->tableExists($table)) {
        $DB->doQuery("DROP TABLE `$table`");
    }
    return true;
}
