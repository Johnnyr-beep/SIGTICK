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

/* pages/admin/rules/backup_header.html.twig */
class __TwigTemplate_76b60beb15e87cc4ec6fd7e3a224a394 extends Template
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
        // line 39
        yield "
<div class=\"center mb-3\">
   ";
        // line 41
        yield $this->getTemplateForMacro("macro_btn", $context, 41, $this->getSourceContext())->macro_btn(...[($this->extensions['Glpi\Application\View\Extension\ConfigExtension']->config("root_doc") . "/front/rule.backup.php?action=import"), "ti ti-upload", _x("button", "Import")]);
        yield "
   ";
        // line 42
        yield $this->getTemplateForMacro("macro_btn", $context, 42, $this->getSourceContext())->macro_btn(...[($this->extensions['Glpi\Application\View\Extension\ConfigExtension']->config("root_doc") . "/front/rule.backup.php?action=export"), "ti ti-download", _x("button", "Export")]);
        yield "
</div>
";
        yield from [];
    }

    // line 33
    public function macro_btn($url = null, $icon = null, $label = null, ...$varargs): string|Markup
    {
        $macros = $this->macros;
        $context = [
            "url" => $url,
            "icon" => $icon,
            "label" => $label,
            "varargs" => $varargs,
        ] + $this->env->getGlobals();

        $blocks = [];

        return ('' === $tmp = \Twig\Extension\CoreExtension::captureOutput((function () use (&$context, $macros, $blocks) {
            // line 34
            yield "   <a class=\"btn btn-primary me-2\" href=\"";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["url"] ?? null), "html", null, true);
            yield "\">
      <i class=\"";
            // line 35
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["icon"] ?? null), "html", null, true);
            yield "\"></i>
      <span>";
            // line 36
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["label"] ?? null), "html", null, true);
            yield "</span>
   </a>
";
            yield from [];
        })())) ? '' : new Markup($tmp, $this->env->getCharset());
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName(): string
    {
        return "pages/admin/rules/backup_header.html.twig";
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
        return array (  84 => 36,  80 => 35,  75 => 34,  61 => 33,  53 => 42,  49 => 41,  45 => 39,  42 => 32,);
    }

    public function getSourceContext(): Source
    {
        return new Source("", "pages/admin/rules/backup_header.html.twig", "C:\\xampp\\htdocs\\glpi\\templates\\pages\\admin\\rules\\backup_header.html.twig");
    }
}
