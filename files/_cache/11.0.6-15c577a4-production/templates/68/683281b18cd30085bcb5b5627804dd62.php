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

/* __string_template__7f6a5ed78c7474501343ab6ed4179942 */
class __TwigTemplate_57cb9db635617daa059892d91179e020 extends Template
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
        yield "            ";
        // line 2
        yield "            <script>
                function impactListUp(target) {
                    target.removeClass(\"ti-caret-down-filled\");
                    target.addClass(\"ti-caret-up-filled\");
                    target.closest(\"tbody\").find('tr:gt(0) td').animate({padding: '0px'}, {duration: 400});
                    target.closest(\"tbody\").find('tr:gt(0) div').slideUp(\"400\");
                }

                function impactListDown(target) {
                    target.addClass(\"ti-caret-down-filled\");
                    target.removeClass(\"ti-caret-up-filled\");
                    target.closest(\"tbody\").find('tr:gt(0) td').animate({padding: '8px 5px'}, {duration: 400});
                    target.closest(\"tbody\").find('tr:gt(0) div').slideDown(\"400\");
                }

                \$(document).on(\"click\", \".impact-toggle-subitems\", (e) => {
                    if (\$(e.target).hasClass(\"ti-caret-up-filled\")) {
                        impactListDown(\$(e.target));
                    } else {
                        impactListUp(\$(e.target));
                    }
                });

                \$(document).on(\"click\", \".impact-toggle-subitems-master\", (e) => {
                    \$(e.target).closest(\"table\").find(\".impact-toggle-subitems\").each((i, elem) => {
                        if (\$(e.target).hasClass(\"ti-caret-up-filled\")) {
                            impactListDown(\$(elem));
                        } else {
                            impactListUp(\$(elem));
                        }
                    });
                    \$(e.target).toggleClass(\"ti-caret-up-filled\");
                    \$(e.target).toggleClass(\"ti-caret-down-filled\");
                });

                \$(document).on(\"impactUpdated\", () => {
                    \$.ajax({
                        type: \"GET\",
                        url: \"";
        // line 40
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($this->extensions['Glpi\Application\View\Extension\RoutingExtension']->path("ajax/impact.php"), "html", null, true);
        yield "\",
                        data: {
                            itemtype: \"";
        // line 42
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape($this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["itemtype"] ?? null), "js"), "html", null, true);
        yield "\",
                            items_id: ";
        // line 43
        yield $this->env->getRuntime('Twig\Runtime\EscaperRuntime')->escape(($context["items_id"] ?? null), "html", null, true);
        yield ",
                            action  : \"load\",
                            view    : \"list\",
                        },
                        success: (data) => {
                            \$(\"#impact_list_view\").replaceWith(data);
                            showGraphView();
                        },
                    });
                });
            </script>";
        yield from [];
    }

    /**
     * @codeCoverageIgnore
     */
    public function getTemplateName(): string
    {
        return "__string_template__7f6a5ed78c7474501343ab6ed4179942";
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
        return array (  93 => 43,  89 => 42,  84 => 40,  44 => 2,  42 => 1,);
    }

    public function getSourceContext(): Source
    {
        return new Source("", "__string_template__7f6a5ed78c7474501343ab6ed4179942", "");
    }
}
