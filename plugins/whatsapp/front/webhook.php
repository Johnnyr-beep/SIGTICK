<?php

/**
 * Public webhook endpoint for Meta WhatsApp Cloud API.
 *
 * Meta sends:
 *  - GET  with hub.mode=subscribe&hub.verify_token=...&hub.challenge=...
 *         -> we must echo hub.challenge as plain text.
 *  - POST with JSON payload of messages/status, signed in X-Hub-Signature-256.
 *
 * Phase 1: validate signature, log payload to file. No ticket logic yet.
 */

// Boot GLPI without forcing user session (this endpoint is anonymous; auth is
// enforced by the Meta verify token + HMAC signature instead).
define('GLPI_USE_CSRF_CHECK', false);
include_once(__DIR__ . '/../../../inc/includes.php');

header('Content-Type: text/plain; charset=utf-8');

$config = new PluginWhatsappConfig();
if (!$config->getFromDB(1) || !$config->fields['is_active']) {
    http_response_code(503);
    echo 'WhatsApp plugin not active.';
    exit;
}

$verify_token = $config->fields['verify_token'];
$app_secret   = $config->fields['app_secret'];
$log_dir      = GLPI_PLUGIN_DOC_DIR . '/whatsapp';
if (!is_dir($log_dir)) {
    @mkdir($log_dir, 0775, true);
}
$log_file = $log_dir . '/inbound-' . date('Y-m-d') . '.log';

// -- Meta webhook verification (GET) -----------------------------------------
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $mode      = $_GET['hub_mode']         ?? $_GET['hub.mode']         ?? '';
    $token     = $_GET['hub_verify_token'] ?? $_GET['hub.verify_token'] ?? '';
    $challenge = $_GET['hub_challenge']    ?? $_GET['hub.challenge']    ?? '';

    if ($mode === 'subscribe' && hash_equals($verify_token, $token) && $verify_token !== '') {
        @file_put_contents($log_file, '[' . date('c') . "] WEBHOOK VERIFIED\n", FILE_APPEND);
        http_response_code(200);
        echo $challenge;
        exit;
    }

    @file_put_contents(
        $log_file,
        '[' . date('c') . "] WEBHOOK VERIFY FAILED mode=$mode token=$token\n",
        FILE_APPEND,
    );
    http_response_code(403);
    echo 'Forbidden';
    exit;
}

// -- Incoming events (POST) --------------------------------------------------
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo 'Method Not Allowed';
    exit;
}

$raw = file_get_contents('php://input');

// Validate X-Hub-Signature-256 if app_secret is configured.
if ($app_secret !== '') {
    $sig_header = $_SERVER['HTTP_X_HUB_SIGNATURE_256'] ?? '';
    $expected   = 'sha256=' . hash_hmac('sha256', $raw, $app_secret);
    if (!hash_equals($expected, $sig_header)) {
        @file_put_contents(
            $log_file,
            '[' . date('c') . "] BAD SIGNATURE got=$sig_header expected=$expected\n",
            FILE_APPEND,
        );
        http_response_code(403);
        echo 'Bad signature';
        exit;
    }
}

if ($config->fields['log_payloads']) {
    @file_put_contents(
        $log_file,
        '[' . date('c') . "] INBOUND\n" . $raw . "\n----\n",
        FILE_APPEND,
    );
}

// Always ACK with 200 so Meta does not retry. Real handling comes in Phase 2.
http_response_code(200);
echo 'OK';
