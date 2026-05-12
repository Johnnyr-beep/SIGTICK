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

/* components/messages_after_redirect_alerts.html.twig */
class __TwigTemplate_c8b0b57371a903f7bc3d02b03d6d58c4 extends Template
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
        $context["messages"] = $this->extensions['Glpi\Application\View\Extension\SessionExtension']->pullMessages();
        // line 34
        if ((($tmp = Twig\Extension\CoreExtension::length($this->env->getCharset(), ($context["messages"] ?? null))) && $tmp instanceof Markup ? (string) $tmp : $tmp)) {
            // line 35
            yield "
   ";
            // line 36
            $context['_parent'] = $context;
            $context['_seq'] = CoreExtension::ensureTraversable(($context["messages"] ?? null));
            foreach ($context['_seq'] as $context["type"] => $context["message"]) {
                // line 37
                yield "      ";
                $context["message"] = Twig\Extension\CoreExtension::join($context["message"], "<br />");
                // line 38
                yield "      ";
                $context["class"] = "";
                // line 39
                yield "      ";
                $context["title"] = "";
                // line 40
                yield "      ";
                if (($context["type"] == Twig\Extension\CoreExtension::constant("ERROR"))) {
                    // line 41
                    yield "         ";
                    $context["class"] = "alert-danger";
                    // line 42
                    yield "         ";
                    $context["title"] = _n("Error", "Errors", 1);
                    // line 43
                    yield "      ";
                } elseif (($context["type"] == Twig\Extension\CoreExtension::constant("WARNING"))) {
                    // line 44
                    yield "         ";
                    $context["class"] = "alert-warning";
                    // line 45
                    yield "         ";
                    $context["title"] = __("Warning");
                    // line 46
                    yield "      ";
                } else {
                    // line 47
                    yield "         ";
                    $context["class"] = "alert-info";
                    // line 48
                    yield "         ";
                    $context["title"] = _n("Information", "Information", 1);
                    // line 49
                    yield "      ";
                }
                // line 50
                yield "
      <div class=\"alert alert-important ";
                // line 51
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["class"] ?? null), "html", null, true);
                yield "\" role=\"alert\">
         <h3>";
                // line 52
                yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["title"] ?? null), "html", null, true);
                yield "</h3>
         <p>
            ";
                // line 54
                yield $context["message"];
                yield "
         </p>
      </div>
   ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['type'], $context['message'], $context['_parent']);
            $context = array_intersect_key($context, $_parent) + $_parent;
        }
        yield from [];
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName(): string
    {
        return "components/messages_after_redirect_alerts.html.twig";
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
        return array (  107 => 54,  102 => 52,  98 => 51,  95 => 50,  92 => 49,  89 => 48,  86 => 47,  83 => 46,  80 => 45,  77 => 44,  74 => 43,  71 => 42,  68 => 41,  65 => 40,  62 => 39,  59 => 38,  56 => 37,  52 => 36,  49 => 35,  47 => 34,  45 => 33,  42 => 32,);
    }

    public function getSourceContext(): Source
    {
        return new Source("", "components/messages_after_redirect_alerts.html.twig", "C:\\xampp\\htdocs\\glpi\\templates\\components\\messages_after_redirect_alerts.html.twig");
    }
}
