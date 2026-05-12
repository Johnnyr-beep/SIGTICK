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

/* forgotpassword.html.twig */
class __TwigTemplate_c6c65ae8baa9c765bb10e62af96e4d2c extends Template
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

        $this->blocks = [
            'content_block' => [$this, 'block_content_block'],
            'footer_block' => [$this, 'block_footer_block'],
        ];
    }

    protected function doGetParent(array $context): bool|string|Template|TemplateWrapper
    {
        // line 38
        return "layout/page_card_notlogged.html.twig";
    }

    protected function doDisplay(array $context, array $blocks = []): iterable
    {
        $macros = $this->macros;
        // line 33
        $context["target"] = $this->extensions['Glpi\Application\View\Extension\RoutingExtension']->path("front/lostpassword.php");
        // line 34
        $context["title"] = ((array_key_exists("title", $context)) ? (Twig\Extension\CoreExtension::default(($context["title"] ?? null), __("Forgotten password?"))) : (__("Forgotten password?")));
        // line 35
        $context["card_md_width"] = true;
        // line 36
        $context["type"] = "forget";
        // line 38
        $this->parent = $this->load("layout/page_card_notlogged.html.twig", 38);
        yield from $this->parent->unwrap()->yield($context, array_merge($this->blocks, $blocks));
    }

    // line 40
    /**
     * @return iterable<null|scalar|\Stringable>
     */
    public function block_content_block(array $context, array $blocks = []): iterable
    {
        $macros = $this->macros;
        // line 41
        yield "    ";
        yield Twig\Extension\CoreExtension::include($this->env, $context, "password_form.html.twig");
        yield "
";
        yield from [];
    }

    // line 44
    /**
     * @return iterable<null|scalar|\Stringable>
     */
    public function block_footer_block(array $context, array $blocks = []): iterable
    {
        $macros = $this->macros;
        // line 45
        yield "    ";
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(__("Forget it,"), "html", null, true);
        yield "
    <a href=\"";
        // line 46
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($this->extensions['Glpi\Application\View\Extension\RoutingExtension']->indexPath(), "html", null, true);
        yield "\">";
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(__("send me back"), "html", null, true);
        yield "</a>
    ";
        // line 47
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(__("to the login screen."), "html", null, true);
        yield "
";
        yield from [];
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName(): string
    {
        return "forgotpassword.html.twig";
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
        return array (  94 => 47,  88 => 46,  83 => 45,  76 => 44,  68 => 41,  61 => 40,  56 => 38,  54 => 36,  52 => 35,  50 => 34,  48 => 33,  41 => 38,);
    }

    public function getSourceContext(): Source
    {
        return new Source("", "forgotpassword.html.twig", "C:\\xampp\\htdocs\\glpi\\templates\\forgotpassword.html.twig");
    }
}
