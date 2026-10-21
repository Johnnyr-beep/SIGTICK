<?php

include('../../../inc/includes.php');

Session::checkRight('config', UPDATE);

$config = new PluginWhatsappConfig();
$config->getFromDB(1);

if (isset($_POST['update'])) {
    Session::checkCSRF($_POST);
    $input = [
        'id'                       => 1,
        'verify_token'             => $_POST['verify_token'] ?? '',
        'app_secret'               => $_POST['app_secret'] ?? '',
        'access_token'             => $_POST['access_token'] ?? '',
        'phone_number_id'          => $_POST['phone_number_id'] ?? '',
        'waba_id'                  => $_POST['waba_id'] ?? '',
        'business_phone'           => $_POST['business_phone'] ?? '',
        'default_entities_id'      => (int) ($_POST['default_entities_id'] ?? 0),
        'default_requesttypes_id'  => (int) ($_POST['default_requesttypes_id'] ?? 0),
        'log_payloads'             => isset($_POST['log_payloads']) ? 1 : 0,
        'is_active'                => isset($_POST['is_active']) ? 1 : 0,
    ];
    $config->update($input);
    Session::addMessageAfterRedirect('Configuración de WhatsApp guardada.');
    Html::back();
}

Html::header('WhatsApp', '', 'config', 'PluginWhatsappConfig');
$config->showForm();
Html::footer();
