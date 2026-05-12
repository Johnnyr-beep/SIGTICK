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

/* __string_template__dfa1bc49a119a21aef53edcee4c03636 */
class __TwigTemplate_e956328f078d87607a5716bb5d1b1d4c extends Template
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
        // line 1
        yield "            <script defer>
                ";
        // line 3
        yield "                    GLPIImpact.prepareNetwork(\$(\"#network_container\"), {
                        'default' : '";
        // line 4
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["default"] ?? null), "js", null, true);
        yield "',
                        'forward' : '";
        // line 5
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["forward"] ?? null), "js", null, true);
        yield "',
                        'backward' : '";
        // line 6
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["backward"] ?? null), "js", null, true);
        yield "',
                        'both' : '";
        // line 7
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["both"] ?? null), "js", null, true);
        yield "',
                    }, '";
        // line 8
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["start_node"] ?? null), "js", null, true);
        yield "');
                ";
        // line 10
        yield "            </script>";
        yield from [];
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName(): string
    {
        return "__string_template__dfa1bc49a119a21aef53edcee4c03636";
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
        return array (  68 => 10,  64 => 8,  60 => 7,  56 => 6,  52 => 5,  48 => 4,  45 => 3,  42 => 1,);
    }

    public function getSourceContext(): Source
    {
        return new Source("", "__string_template__dfa1bc49a119a21aef53edcee4c03636", "");
    }
}
