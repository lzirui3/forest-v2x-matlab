function plot_step14_critical_stage_benefit(T)
%PLOT_STEP14_CRITICAL_STAGE_BENEFIT Plot critical-stage benefit-cost tradeoff.

fig = figure('Name', 'Critical Stage Benefit-Cost Tradeoff', 'Color', 'w', ...
    'Renderer', 'painters', 'InvertHardcopy', 'off', 'Units', 'pixels', ...
    'Position', [260 120 1200 540]);
tlo = tiledlayout(fig, 1, 2, 'TileSpacing', 'loose', 'Padding', 'loose');

ax1 = nexttile(tlo);
scatter(ax1, T.CostDelta_ConfVsLinkDelay, T.TimelyGain_ConfVsLinkDelay, 85, ...
    'MarkerFaceColor', [0.00 0.45 0.74], 'MarkerEdgeColor', 'k', 'LineWidth', 0.8);
hold(ax1, 'on');
for i = 1:height(T)
    text(ax1, T.CostDelta_ConfVsLinkDelay(i), T.TimelyGain_ConfVsLinkDelay(i), ...
        ['  ' char(T.Stage(i))], 'FontName', 'Times New Roman', 'FontSize', 10, 'Color', 'k');
end
xlabel(ax1, 'Cost Delta (Conf - Link-delay-aware)');
ylabel(ax1, 'Timely Gain');
title(ax1, '(a) Timely Gain vs Cost Delta', 'Color', 'k');
xline(ax1, 0, '--', 'Color', [0.35 0.35 0.35]);
yline(ax1, 0, '--', 'Color', [0.35 0.35 0.35]);
apply_paper_axes_style(ax1);

ax2 = nexttile(tlo);
scatter(ax2, T.CostDelta_ConfVsLinkDelay, T.LossReduction_ConfVsLinkDelay, 85, ...
    'MarkerFaceColor', [0.85 0.33 0.10], 'MarkerEdgeColor', 'k', 'LineWidth', 0.8);
hold(ax2, 'on');
for i = 1:height(T)
    text(ax2, T.CostDelta_ConfVsLinkDelay(i), T.LossReduction_ConfVsLinkDelay(i), ...
        ['  ' char(T.Stage(i))], 'FontName', 'Times New Roman', 'FontSize', 10, 'Color', 'k');
end
xlabel(ax2, 'Cost Delta (Conf - Link-delay-aware)');
ylabel(ax2, 'Loss Reduction');
title(ax2, '(b) Loss Reduction vs Cost Delta', 'Color', 'k');
xline(ax2, 0, '--', 'Color', [0.35 0.35 0.35]);
yline(ax2, 0, '--', 'Color', [0.35 0.35 0.35]);
apply_paper_axes_style(ax2);

exportgraphics(fig, 'step14_critical_stage_benefit.png', 'Resolution', 300);
savefig(fig, 'step14_critical_stage_benefit.fig');
end
