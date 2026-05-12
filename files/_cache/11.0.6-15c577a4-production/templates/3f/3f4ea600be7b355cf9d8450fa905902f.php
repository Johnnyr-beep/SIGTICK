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

/* pages/admin/rules/collections_list.html.twig */
class __TwigTemplate_050e70b5d7849d855ee043856b8bc4a6 extends Template
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
<div class=\"container px-4\">
   <div class=\"row g-3 justify-content-evenly\">
      ";
        // line 35
        $context['_parent'] = $context;
        $context['_seq'] = CoreExtension::ensureTraversable(($context["rules_group"] ?? null));
        foreach ($context['_seq'] as $context["_key"] => $context["rules_block"]) {
            // line 36
            yield "         <div class=\"col-12 ";
            yield (((Twig\Extension\CoreExtension::length($this->env->getCharset(), ($context["rules_group"] ?? null)) > 2)) ? ("col-xxl-3") : ("col-xxl-9"));
            yield "\">
            <h2 class=\"justify-content-center my-4 d-flex align-items-center mb-6 pb-3 fs-1\">
                ";
            // line 38
            if ((CoreExtension::getAttribute($this->env, $this->source, $context["rules_block"], "icon", [], "array", true, true, false, 38) &&  !Twig\Extension\CoreExtension::testEmpty((($_v0 = $context["rules_block"]) && is_array($_v0) || $_v0 instanceof ArrayAccess ? ($_v0["icon"] ?? null) : null)))) {
                // line 39
                yield "                    <i class=\"";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape((($_v1 = $context["rules_block"]) && is_array($_v1) || $_v1 instanceof ArrayAccess ? ($_v1["icon"] ?? null) : null), "html", null, true);
                yield " me-1\"></i>
                ";
            }
            // line 41
            yield "                ";
            yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape((($_v2 = $context["rules_block"]) && is_array($_v2) || $_v2 instanceof ArrayAccess ? ($_v2["type"] ?? null) : null), "html", null, true);
            yield "
            </h2>
            <div class=\"card \">
               <div class=\"list-group list-group-flush\">
                  ";
            // line 45
            $context['_parent'] = $context;
            $context['_seq'] = CoreExtension::ensureTraversable((($_v3 = $context["rules_block"]) && is_array($_v3) || $_v3 instanceof ArrayAccess ? ($_v3["entries"] ?? null) : null));
            foreach ($context['_seq'] as $context["_key"] => $context["rule"]) {
                // line 46
                yield "                     <a class=\"list-group-item list-group-item-action\" href=\"";
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape((($_v4 = $context["rule"]) && is_array($_v4) || $_v4 instanceof ArrayAccess ? ($_v4["link"] ?? null) : null), "html", null, true);
                yield "\">
                        <i class=\"";
                // line 47
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape((($_v5 = $context["rule"]) && is_array($_v5) || $_v5 instanceof ArrayAccess ? ($_v5["icon"] ?? null) : null), "html", null, true);
                yield " me-1\"></i>
                        <span>";
                // line 48
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape((($_v6 = $context["rule"]) && is_array($_v6) || $_v6 instanceof ArrayAccess ? ($_v6["label"] ?? null) : null), "html", null, true);
                yield "</span>
                     </a>
                  ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_key'], $context['rule'], $context['_parent']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 51
            yield "               </div>
            </div>
         </div>
      ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_key'], $context['rules_block'], $context['_parent']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 55
        yield "   </div>
</div>
";
        yield from [];
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName(): string
    {
        return "pages/admin/rules/collections_list.html.twig";
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
        return array (  104 => 55,  95 => 51,  86 => 48,  82 => 47,  77 => 46,  73 => 45,  65 => 41,  59 => 39,  57 => 38,  51 => 36,  47 => 35,  42 => 32,);
    }

    public function getSourceContext(): Source
    {
        return new Source("", "pages/admin/rules/collections_list.html.twig", "C:\\xampp\\htdocs\\glpi\\templates\\pages\\admin\\rules\\collections_list.html.twig");
    }
}
