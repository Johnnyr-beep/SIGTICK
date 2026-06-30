<?php

class PluginWhatsappConfig extends CommonDBTM
{
    public static $rightname = 'config';

    public static function getTypeName($nb = 0)
    {
        return 'WhatsApp';
    }

    public static function getIcon()
    {
        return 'ti ti-brand-whatsapp';
    }

    public static function canCreate(): bool
    {
        return false;
    }

    public static function canPurge(): bool
    {
        return false;
    }

    public static function getMenuContent()
    {
        if (!Session::haveRight('config', UPDATE)) {
            return false;
        }
        return [
            'title'   => self::getTypeName(),
            'page'    => '/plugins/whatsapp/front/config.form.php',
            'icon'    => self::getIcon(),
        ];
    }

    public static function getInstance(): self
    {
        $cfg = new self();
        if (!$cfg->getFromDB(1)) {
            $cfg->fields = [
                'id' => 1,
                'verify_token' => '',
                'app_secret' => '',
                'access_token' => '',
                'phone_number_id' => '',
                'waba_id' => '',
                'business_phone' => '',
                'default_entities_id' => 0,
                'default_requesttypes_id' => 0,
                'log_payloads' => 1,
                'is_active' => 0,
            ];
        }
        return $cfg;
    }

    public function showForm($ID = 1, array $options = [])
    {
        if (!Session::haveRight('config', UPDATE)) {
            return false;
        }

        $this->getFromDB(1);
        $webhook_url = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' ? 'https' : 'http')
            . '://' . ($_SERVER['HTTP_HOST'] ?? 'localhost')
            . '/plugins/whatsapp/front/webhook.php';

        echo '<form method="post" action="' . htmlspecialchars($_SERVER['REQUEST_URI']) . '">';
        echo '<table class="tab_cadre_fixe">';
        echo '<tr><th colspan="2">Configuración del plugin WhatsApp (Meta Cloud API)</th></tr>';

        echo '<tr class="tab_bg_1"><td>URL del webhook (configúrala en Meta)</td>';
        echo '<td><input type="text" readonly size="80" value="' . htmlspecialchars($webhook_url) . '"></td></tr>';

        echo '<tr class="tab_bg_1"><td>Verify Token (mismo valor que pongas en Meta)</td>';
        echo '<td><input type="text" name="verify_token" size="60" value="'
            . htmlspecialchars($this->fields['verify_token'] ?? '') . '"></td></tr>';

        echo '<tr class="tab_bg_1"><td>App Secret (Meta App → Configuración → Básica)</td>';
        echo '<td><input type="password" name="app_secret" size="60" value="'
            . htmlspecialchars($this->fields['app_secret'] ?? '') . '"></td></tr>';

        echo '<tr class="tab_bg_1"><td>Access Token permanente (System User)</td>';
        echo '<td><textarea name="access_token" rows="3" cols="80">'
            . htmlspecialchars($this->fields['access_token'] ?? '') . '</textarea></td></tr>';

        echo '<tr class="tab_bg_1"><td>Phone Number ID</td>';
        echo '<td><input type="text" name="phone_number_id" size="40" value="'
            . htmlspecialchars($this->fields['phone_number_id'] ?? '') . '"></td></tr>';

        echo '<tr class="tab_bg_1"><td>WhatsApp Business Account ID (WABA)</td>';
        echo '<td><input type="text" name="waba_id" size="40" value="'
            . htmlspecialchars($this->fields['waba_id'] ?? '') . '"></td></tr>';

        echo '<tr class="tab_bg_1"><td>Número WhatsApp del negocio (display)</td>';
        echo '<td><input type="text" name="business_phone" size="20" value="'
            . htmlspecialchars($this->fields['business_phone'] ?? '') . '"></td></tr>';

        echo '<tr class="tab_bg_1"><td>Entidad por defecto para tickets entrantes</td>';
        echo '<td>';
        Entity::dropdown([
            'name'  => 'default_entities_id',
            'value' => $this->fields['default_entities_id'] ?? 0,
        ]);
        echo '</td></tr>';

        echo '<tr class="tab_bg_1"><td>Origen de la solicitud por defecto</td>';
        echo '<td>';
        Dropdown::show('RequestType', [
            'name'  => 'default_requesttypes_id',
            'value' => $this->fields['default_requesttypes_id'] ?? 0,
        ]);
        echo '</td></tr>';

        echo '<tr class="tab_bg_1"><td>Registrar payloads entrantes en log</td>';
        echo '<td><input type="checkbox" name="log_payloads" value="1" '
            . (($this->fields['log_payloads'] ?? 0) ? 'checked' : '') . '></td></tr>';

        echo '<tr class="tab_bg_1"><td>Plugin activo</td>';
        echo '<td><input type="checkbox" name="is_active" value="1" '
            . (($this->fields['is_active'] ?? 0) ? 'checked' : '') . '></td></tr>';

        echo '<tr class="tab_bg_2"><td colspan="2" style="text-align:center">';
        echo Html::hidden('id', ['value' => 1]);
        echo Html::hidden('_glpi_csrf_token', ['value' => Session::getNewCSRFToken()]);
        echo '<button type="submit" name="update" class="btn btn-primary">Guardar</button>';
        echo '</td></tr>';

        echo '</table></form>';

        return true;
    }
}
