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

/* pages/admin/rules/index.html.twig */
class __TwigTemplate_56f0955ad78fdb77c20e13e3b16be44e extends Template
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
        // line 60
        yield "
";
        // line 61
        yield Twig\Extension\CoreExtension::include($this->env, $context, "pages/admin/rules/backup_header.html.twig");
        yield "

<div class=\"row\">
    <div class=\"col-12 col-lg-6\">
        <ul class=\"process-chart\">
            <li class=\"align-items-center d-flex justify-content-center my-4 pb-6 fs-1 fw-bold\">
                <i class=\"ti ti-cloud-download me-1\"></i>
                <span>";
        // line 68
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(__("Inventory rules"), "html", null, true);
        yield "</span>
            </li>

            <li class=\"entry-point\">
                <span class=\"icon-stack fa-2x\">
                    <i class=\"ti ti-circle-dashed\"></i>
                    <i class=\"ti ti-robot sm-size\"></i>
                </span>
                <span>";
        // line 76
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(__("Agent sends an inventory file"), "html", null, true);
        yield "</span>
            </li>

            ";
        // line 79
        yield $this->getTemplateForMacro("macro_rule_step", $context, 79, $this->getSourceContext())->macro_rule_step(...["RuleDefineItemtype", __("Transform itemtypes"), __("Override the asset to another custom definition (like Servers)"), $this->extensions['Glpi\Application\View\Extension\PhpExtension']->call("RuleDefineItemtype::canView")]);
        // line 84
        yield "

            ";
        // line 86
        yield $this->getTemplateForMacro("macro_rule_step", $context, 86, $this->getSourceContext())->macro_rule_step(...["RuleImportEntity", __("Rules for assigning an item to an entity"), __("Set an entity with some criteria (by its tag for example)"), $this->extensions['Glpi\Application\View\Extension\PhpExtension']->call("RuleImportEntity::canView")]);
        // line 91
        yield "

            ";
        // line 93
        yield $this->getTemplateForMacro("macro_rule_step", $context, 93, $this->getSourceContext())->macro_rule_step(...["RuleLocation", __("Location rules"), __("Apply a location by checking common criteria"), $this->extensions['Glpi\Application\View\Extension\PhpExtension']->call("RuleLocation::canView")]);
        // line 98
        yield "

            ";
        // line 100
        yield $this->getTemplateForMacro("macro_rule_step", $context, 100, $this->getSourceContext())->macro_rule_step(...["RuleImportAsset", __("Rules for import and link equipments"), __("Match data with an existing asset, create a new asset, or deny the import"), $this->extensions['Glpi\Application\View\Extension\PhpExtension']->call("RuleImportAsset::canView")]);
        // line 105
        yield "

            ";
        // line 107
        yield $this->getTemplateForMacro("macro_rule_step", $context, 107, $this->getSourceContext())->macro_rule_step(...["RuleDictionnaryDropdownCollection", _n("Dictionary", "Dictionaries", Session::getPluralNumber()), __("Normalize sub-data (like softwares, OS and models)"), (($this->extensions['Glpi\Application\View\Extension\PhpExtension']->call("RuleDictionnaryDropdownCollection::canView") || $this->extensions['Glpi\Application\View\Extension\PhpExtension']->call("RuleDictionnarySoftware::canView")) || $this->extensions['Glpi\Application\View\Extension\PhpExtension']->call("RuleDictionnaryPrinter::canView")), $this->extensions['Glpi\Application\View\Extension\RoutingExtension']->path("/front/dictionnary.php")]);
        // line 113
        yield "

            ";
        // line 115
        yield $this->getTemplateForMacro("macro_rule_step", $context, 115, $this->getSourceContext())->macro_rule_step(...["RuleAsset", __("Business rules for assets"), __("Alter asset fields based on their data"), $this->extensions['Glpi\Application\View\Extension\PhpExtension']->call("RuleAsset::canView")]);
        // line 120
        yield "

            <li class=\"end\">
                <i class=\"ti ti-circle-check me-1 fa-2x\"></i>
                <span>";
        // line 124
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(__("The asset is created or updated in GLPI"), "html", null, true);
        yield "</span>
            </li>
        </ul>
    </div>

    <div class=\"col-12 col-lg-6\">
        ";
        // line 130
        yield from $this->load("pages/admin/rules/collections_list.html.twig", 130)->unwrap()->yield(CoreExtension::toArray(["rules_group" =>         // line 131
($context["rules_group"] ?? null)]));
        // line 133
        yield "    </div>
</div>
";
        yield from [];
    }

    // line 33
    public function macro_rule_step($itemtype = null, $title = null, $description = null, $can_view = null, $url = null, ...$varargs): string|Markup
    {
        $macros = $this->macros;
        $context = [
            "itemtype" => $itemtype,
            "title" => $title,
            "description" => $description,
            "can_view" => $can_view,
            "url" => $url,
            "varargs" => $varargs,
        ] + $this->env->getGlobals();

        $blocks = [];

        return ('' === $tmp = \Twig\Extension\CoreExtension::captureOutput((function () use (&$context, $macros, $blocks) {
            // line 34
            yield "    <li class=\"step\">
        ";
            // line 35
            if ((($tmp = ($context["can_view"] ?? null)) && $tmp instanceof Markup ? (string) $tmp : $tmp)) {
                // line 36
                yield "            <a class=\"btn flex-column\" href=\"";
                yield (((array_key_exists("url", $context) &&  !(null === $context["url"]))) ? ($this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($context["url"], "html", null, true)) : ($this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($this->extensions['Glpi\Application\View\Extension\ItemtypeExtension']->getItemtypeSearchPath(($context["itemtype"] ?? null)), "html", null, true)));
                yield "\">
                <div class=\"d-flex align-items-center\">
                    <i class=\"";
                // line 38
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($this->extensions['Glpi\Application\View\Extension\ItemtypeExtension']->getItemtypeIcon(($context["itemtype"] ?? null)), "html", null, true);
                yield "\"></i>
                    <span>";
                // line 39
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["title"] ?? null), "html", null, true);
                yield "</span>
                </div>
                <div class=\"text-muted\">
                    ";
                // line 42
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["description"] ?? null), "html", null, true);
                yield "
                </div>
            </a>
        ";
            } else {
                // line 46
                yield "            <div class=\"btn flex-column opacity-70\" style=\"cursor: not-allowed;\"
                 data-bs-toggle=\"tooltip\" data-bs-placement=\"top\"
                 title=\"";
                // line 48
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(__("You do not have the required permissions"), "html", null, true);
                yield "\">
                <div class=\"d-flex align-items-center\">
                    <i class=\"";
                // line 50
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($this->extensions['Glpi\Application\View\Extension\ItemtypeExtension']->getItemtypeIcon(($context["itemtype"] ?? null)), "html", null, true);
                yield "\"></i>
                    <span>";
                // line 51
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["title"] ?? null), "html", null, true);
                yield "</span>
                </div>
                <div class=\"text-muted\">
                    ";
                // line 54
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["description"] ?? null), "html", null, true);
                yield "
                </div>
            </div>
        ";
            }
            // line 58
            yield "    </li>
";
            yield from [];
        })())) ? '' : new Markup($tmp, $this->env->getCharset());
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName(): string
    {
        return "pages/admin/rules/index.html.twig";
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
        return array (  202 => 58,  195 => 54,  189 => 51,  185 => 50,  180 => 48,  176 => 46,  169 => 42,  163 => 39,  159 => 38,  153 => 36,  151 => 35,  148 => 34,  132 => 33,  125 => 133,  123 => 131,  122 => 130,  113 => 124,  107 => 120,  105 => 115,  101 => 113,  99 => 107,  95 => 105,  93 => 100,  89 => 98,  87 => 93,  83 => 91,  81 => 86,  77 => 84,  75 => 79,  69 => 76,  58 => 68,  48 => 61,  45 => 60,  42 => 32,);
    }

    public function getSourceContext(): Source
    {
        return new Source("", "pages/admin/rules/index.html.twig", "C:\\xampp\\htdocs\\glpi\\templates\\pages\\admin\\rules\\index.html.twig");
    }
}
