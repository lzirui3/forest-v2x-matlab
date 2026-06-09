function plot_step15_default_vs_forest_multiseed(T_summary, T_stage_summary)
%PLOT_STEP15_DEFAULT_VS_FOREST_MULTISEED Plot default vs forest multiseed comparison.

methods = unique(T_summary.Method, 'stable');
method_labels = cellstr(methods);
cfg_default = T_summary(T_summary.Config == "Default", :);
cfg_forest = T_summary(T_summary.Config == "ForestGeometry", :);

fig = figure('Name', 'Default vs Forest Geometry Multiseed', 'Color', 'w', ...
    'Renderer', 'painters', 'InvertHardcopy', 'off', 'Units', 'pixels', ...
    'Position', [220 80 1260 760]);
tlo = tiledlayout(fig, 2, 2, 'TileSpacing', 'loose', 'Padding', 'loose');

ax1 = nexttile(tlo);
bar(ax1, categorical(method_labels), [cfg_default.TimelyRateMean cfg_forest.TimelyRateMean], 'grouped');
ylabel(ax1, 'Overall timely rate');
title(ax1, '(a) Overall Timely Rate', 'Color', 'k');
legend(ax1, {'Default', 'ForestGeometry'}, 'Location', 'best');
ylim(ax1, [0 1]);
apply_paper_axes_style(ax1);

ax2 = nexttile(tlo);
bar(ax2, categorical(method_labels), [cfg_default.LossRateMean cfg_forest.LossRateMean], 'grouped');
ylabel(ax2, 'Loss rate');
title(ax2, '(b) Overall Loss Rate', 'Color', 'k');
legend(ax2, {'Default', 'ForestGeometry'}, 'Location', 'best');
apply_paper_axes_style(ax2);

ax3 = nexttile(tlo);
bar(ax3, categorical(method_labels), [cfg_default.AvgTxCostMean cfg_forest.AvgTxCostMean], 'grouped');
ylabel(ax3, 'Average Tx cost');
title(ax3, '(c) Average Transmission Cost', 'Color', 'k');
legend(ax3, {'Default', 'ForestGeometry'}, 'Location', 'best');
apply_paper_axes_style(ax3);

posdeg_default = T_stage_summary(T_stage_summary.Config == "Default" & T_stage_summary.Stage == "PosDeg_Emerg", :);
posdeg_forest = T_stage_summary(T_stage_summary.Config == "ForestGeometry" & T_stage_summary.Stage == "PosDeg_Emerg", :);

ax4 = nexttile(tlo);
bar(ax4, categorical(method_labels), [posdeg_default.EmergencyTimelyRateMean posdeg_forest.EmergencyTimelyRateMean], 'grouped');
ylabel(ax4, 'PosDeg emergency timely rate');
title(ax4, '(d) PosDeg\\_Emerg Emergency Timely Rate', 'Color', 'k');
legend(ax4, {'Default', 'ForestGeometry'}, 'Location', 'best');
ylim(ax4, [0 1]);
apply_paper_axes_style(ax4);

exportgraphics(fig, 'step15_default_vs_forest_multiseed.png', 'Resolution', 300);
savefig(fig, 'step15_default_vs_forest_multiseed.fig');
end
