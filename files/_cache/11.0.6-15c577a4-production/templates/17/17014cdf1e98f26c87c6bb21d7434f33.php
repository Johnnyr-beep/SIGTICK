<?php

use Twig\Environment;
use Twig\Error\LoaderError;
use Twig\Error\RuntimeError;
use Twig\Extension\CoreExtension;
use Twig\Extension\SandboxExtension;
use Twig\Markup;
use Twig\Sandbox\SecurityError;
use Twig\Sandbox\SecurityNotAllowedTagError;
use Twig\Sandbox\SecurityNotAllowedFilterError;
use Twig\Sandbox\SecurityNotAllowedFunctionError;
use Twig\Source;
use Twig\Template;
use Twig\TemplateWrapper;

/* password_form.html.twig */
class __TwigTemplate_2098df5e0b813d805b7a90516b7c602d extends Template
{
    private Source $source;
    /**
     * @var array<string, Template>
     */
    private array $macros = [];

    public function __construct(Environment $env)
    {
        parent::__construct($env);

        $this->source = $this->getSourceContext();

        $this->parent = false;

        $this->blocks = [
        ];
    }

    protected function doDisplay(array $context, array $blocks = []): iterable
    {
        $macros = $this->macros;
        // line 32
        yield "
";
        // line 33
        $macros["fields"] = $this->macros["fields"] = $this->load("components/form/fields_macros.html.twig", 33)->unwrap();
        // line 34
        yield "
";
        // line 35
        if ((array_key_exists("must_change_password", $context) && ($context["must_change_password"] ?? null))) {
            // line 36
            yield "    <div class=\"alert alert-warning\">
        <div class=\"alert-title\">";
            // line 37
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(__("Your password has expired. You must change it to be able to login."), "html", null, true);
            yield "</div>
    </div>
";
        }
        // line 40
        if ((array_key_exists("token_ok", $context) && (($context["token_ok"] ?? null) == false))) {
            // line 41
            yield "    ";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(__("Your password reset request has expired or is invalid. Please renew it."), "html", null, true);
            yield "
";
        } elseif (        // line 42
array_key_exists("messages_only", $context)) {
            // line 43
            yield "    ";
            yield Twig\Extension\CoreExtension::include($this->env, $context, "components/messages_after_redirect_alerts.html.twig");
            yield "
";
        } else {
            // line 45
            yield "    <form action=\"";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["target"] ?? null), "html", null, true);
            yield "\" method=\"post\" autocomplete=\"off\" data-submit-once>
        <input type=\"hidden\" name=\"_glpi_csrf_token\" value=\"";
            // line 46
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(Session::getNewCSRFToken(), "html", null, true);
            yield "\" />
        <h2 class=\"card-title text-center mb-4\">";
            // line 47
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["title"] ?? null), "html", null, true);
            yield "</h2>

        ";
            // line 49
            if ((($context["type"] ?? null) == "update")) {
                // line 50
                yield "            ";
                $macros["fields"] = $this->macros["fields"] = $this->load("components/form/fields_macros.html.twig", 50)->unwrap();
                // line 51
                yield "            ";
                yield $macros["fields"]->getTemplateForMacro("macro_textField", $context, 51, $this->getSourceContext())->macro_textField(...["name", $this->extensions['Glpi\Application\View\Extension\SessionExtension']->session("glpiname"), __("Login"), ["readonly" => true, "full_width" => true, "additional_attributes" => ["autocomplete" => "off"]]]);
                // line 57
                yield "
            ";
                // line 58
                yield $macros["fields"]->getTemplateForMacro("macro_passwordField", $context, 58, $this->getSourceContext())->macro_passwordField(...["current_password", "", __("Current password"), ["full_width" => true, "clearable" => false, "required" => true, "additional_attributes" => ["autocomplete" => "current-password"]]]);
                // line 65
                yield "
        ";
            }
            // line 67
            yield "        ";
            if ((array_key_exists("token", $context) || (($context["type"] ?? null) == "update"))) {
                // line 68
                yield "            <input type=\"hidden\" name=\"password_forget_token\" value=\"";
                yield (((array_key_exists("token", $context) &&  !(null === $context["token"]))) ? ($this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($context["token"], "html", null, true)) : (""));
                yield "\" />
            ";
                // line 69
                yield $macros["fields"]->getTemplateForMacro("macro_passwordField", $context, 69, $this->getSourceContext())->macro_passwordField(...["password", "", __("New password"), ["full_width" => true, "clearable" => false, "required" => true, "additional_attributes" => ["onkeyup" => "passwordCheck();", "autocomplete" => "new-password"]]]);
                // line 77
                yield "
            ";
                // line 78
                yield $macros["fields"]->getTemplateForMacro("macro_passwordField", $context, 78, $this->getSourceContext())->macro_passwordField(...["password2", "", __("New password confirmation"), ["full_width" => true, "clearable" => false, "required" => true, "additional_attributes" => ["onkeyup" => "passwordCheck();", "autocomplete" => "new-password"]]]);
                // line 86
                yield "

            ";
                // line 88
                if ((($tmp = $this->extensions['Glpi\Application\View\Extension\ConfigExtension']->config("use_password_security")) && $tmp instanceof Markup ? (string) $tmp : $tmp)) {
                    // line 89
                    yield "                <div class=\"alert alert-warning\">
                    <h3>";
                    // line 90
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(__("Password security policy"), "html", null, true);
                    yield "</h3>
                    ";
                    // line 91
                    yield Twig\Extension\CoreExtension::include($this->env, $context, "components/user/password_security_checks.html.twig");
                    yield "
                </div>
            ";
                } else {
                    // line 94
                    yield "                <script>
                    function passwordCheck() {
                        return true;
                    }
                </script>
            ";
                }
                // line 100
                yield "
            ";
                // line 101
                $context["save_button"] = (("<i class=\"ti ti-device-floppy\"></i><span>" . __("Save new password")) . "<span>");
                // line 102
                yield "
        ";
            } elseif ((            // line 103
($context["type"] ?? null) == "forget")) {
                // line 104
                yield "            <p class=\"text-muted mb-4\">
                ";
                // line 105
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(__("Please enter your email address. An email will be sent to you and you will be able to choose a new password."), "html", null, true);
                yield "
            </p>
            <div class=\"mb-3\">
                ";
                // line 108
                yield $macros["fields"]->getTemplateForMacro("macro_emailField", $context, 108, $this->getSourceContext())->macro_emailField(...["email", "", _n("Email", "Emails", 1), ["full_width" => true, "required" => true]]);
                // line 111
                yield "
            </div>
            ";
                // line 113
                $context["save_button"] = (("<i class=\"ti ti-mail\"></i><span>" . __("Send")) . "<span>");
                // line 114
                yield "        ";
            }
            // line 115
            yield "
        <div class=\"form-footer d-flex flex-row-reverse\">
            <button class=\"btn btn-primary\" name=\"update\">
                ";
            // line 118
            yield ($context["save_button"] ?? null);
            yield "
            </button>
        </div>

        ";
            // line 122
            if ((array_key_exists("errors", $context) && (Twig\Extension\CoreExtension::length($this->env->getCharset(), ($context["errors"] ?? null)) > 0))) {
                // line 123
                yield "            <div class=\"alert alert-danger mt-2\">
                ";
                // line 124
                $context['_parent'] = $context;
                $context['_seq'] = CoreExtension::ensureTraversable(($context["errors"] ?? null));
                foreach ($context['_seq'] as $context["_key"] => $context["error"]) {
                    // line 125
                    yield "                    <br>";
                    yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($context["error"], "html", null, true);
                    yield "
                ";
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_key'], $context['error'], $context['_parent']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 127
                yield "            </div>
        ";
            }
            // line 129
            yield "    </form>
";
        }
        // line 131
        yield "
";
        yield from [];
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName(): string
    {
        return "password_form.html.twig";
    }

    /**
     * @codeCoverageIgnore
     */
    public function isTraitable(): bool
    {
        return false;
    }

    /**
     * @codeCoverageIgnore
     */
    public function getDebugInfo(): array
    {
        return array (  217 => 131,  213 => 129,  209 => 127,  200 => 125,  196 => 124,  193 => 123,  191 => 122,  184 => 118,  179 => 115,  176 => 114,  174 => 113,  170 => 111,  168 => 108,  162 => 105,  159 => 104,  157 => 103,  154 => 102,  152 => 101,  149 => 100,  141 => 94,  135 => 91,  131 => 90,  128 => 89,  126 => 88,  122 => 86,  120 => 78,  117 => 77,  115 => 69,  110 => 68,  107 => 67,  103 => 65,  101 => 58,  98 => 57,  95 => 51,  92 => 50,  90 => 49,  85 => 47,  81 => 46,  76 => 45,  70 => 43,  68 => 42,  63 => 41,  61 => 40,  55 => 37,  52 => 36,  50 => 35,  47 => 34,  45 => 33,  42 => 32,);
    }

    public function getSourceContext(): Source
    {
        return new Source("", "password_form.html.twig", "C:\\xampp\\htdocs\\glpi\\templates\\password_form.html.twig");
    }
}
