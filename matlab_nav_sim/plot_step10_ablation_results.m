function plot_step10_ablation_results(base_scenario, scenario_cases, T, T_stage)
%PLOT_STEP10_ABLATION_RESULTS Plot overall and stage-focused ablation comparisons.

fig1 = figure('Name', 'Step 10 Ablation Metrics', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [420 100 1100 760]);
tlo = tiledlayout(fig1, 2, 2, 'TileSpacing', 'loose', 'Padding', 'loose');
sgtitle(fig1, 'Position-Confidence Module Ablation', ...
    'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'normal', 'Color', 'k');

ax1 = nexttile(tlo);
bar(ax1, categorical(cellstr(T.Method)), T.EmergencyTimelyRate, 0.58, 'FaceColor', [0.20 0.55 0.80]);
ylabel(ax1, 'Emergency timely rate');
title(ax1, 'Overall Emergency Timely Rate', 'Color', 'k');
apply_paper_axes_style(ax1);

ax2 = nexttile(tlo);
bar(ax2, categorical(cellstr(T.Method)), T.AvgTxCost, 0.58, 'FaceColor', [0.82 0.48 0.14]);
ylabel(ax2, 'Average Tx cost');
title(ax2, 'Overall Transmission Cost', 'Color', 'k');
apply_paper_axes_style(ax2);

posdeg = T_stage(T_stage.Stage == "PosDeg_Emerg", :);
ax3 = nexttile(tlo);
bar(ax3, categorical(cellstr(posdeg.Method)), [posdeg.TimelyRate posdeg.EmergencyTimelyRate], 'grouped');
ylabel(ax3, 'Rate');
title(ax3, 'PosDeg_Emerg Timely Delivery', 'Color', 'k');
lgd3 = legend(ax3, {'All messages', 'Emergency messages'}, 'Location', 'best');
set(lgd3, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax3);

ax4 = nexttile(tlo);
plot(ax4, base_scenario.t, scenario_cases{1}.q_pos, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.9);
hold(ax4, 'on');
colors = [0.85 0.33 0.10; 0.20 0.60 0.20; 0.49 0.18 0.56; 0.75 0.00 0.00];
for i = 2:numel(scenario_cases)
    plot(ax4, base_scenario.t, scenario_cases{i}.q_pos, '-', ...
        'Color', colors(i - 1, :), 'LineWidth', 1.5);
end
xlabel(ax4, 'Time (s)');
ylabel(ax4, 'q_{pos}');
title(ax4, 'Position Confidence under Ablation', 'Color', 'k');
lgd4 = legend(ax4, {'Full', 'No-GNSS', 'No-RSU', 'No-Env', 'No-Traj'}, 'Location', 'best');
set(lgd4, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax4);
xlim(ax4, [base_scenario.t(1) base_scenario.t(end)]);
end
