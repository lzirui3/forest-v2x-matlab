clc;
clear;
close all;

% Step 10 (academic figure version):
% Run position-confidence ablation and export paper-style comparison figures.

set(groot, 'defaultFigureWindowStyle', 'normal');
opengl software;
set(groot, 'defaultFigureColor', 'w');
set(groot, 'defaultAxesColor', 'w');
set(groot, 'defaultAxesXColor', 'k');
set(groot, 'defaultAxesYColor', 'k');
set(groot, 'defaultAxesZColor', 'k');
set(groot, 'defaultAxesFontName', 'Times New Roman');
set(groot, 'defaultTextFontName', 'Times New Roman');
set(groot, 'defaultAxesFontSize', 11);
set(groot, 'defaultTextFontSize', 11);
set(groot, 'defaultAxesLineWidth', 1.0);
set(groot, 'defaultLineLineWidth', 1.6);
set(groot, 'defaultTextColor', 'k');
set(groot, 'defaultLegendTextColor', 'k');
set(groot, 'defaultColorBarColor', 'k');

params = get_default_step9_params();
cases = get_default_step10_ablation_cases();

scenario_cases = cell(numel(cases), 1);
results = cell(numel(cases) + 1, 1);
method_names = cell(numel(cases) + 1, 1);

base_scenario = generate_step9_scenario(params, cases(1).modules);
link_result = run_step9_baseline_link_only(base_scenario, params);
results{1} = link_result;
method_names{1} = char(link_result.name);

for i = 1:numel(cases)
    scenario_cases{i} = generate_step9_scenario(params, cases(i).modules);
    result_case = run_step9_confidence_driven(scenario_cases{i}, params);
    result_case.name = string(cases(i).name);
    results{i + 1} = result_case;
    method_names{i + 1} = char(cases(i).name);
end

T = evaluate_step9_metrics(base_scenario, results);
stages = define_step9_stage_masks(base_scenario.t);
metrics_list = cell(numel(results), 1);
for i = 1:numel(results)
    metrics_list{i} = compute_step9_stage_metrics(base_scenario, results{i}, stages);
end
T_stage = build_step9_stage_metrics_table(method_names, metrics_list);
T_imp = build_step10_ablation_improvement_table(T, 'Full');
T_stage_imp = build_step9_stage_improvement_table(T_stage, 'Full');

fig_metric = figure('Name', 'Step10 Academic Ablation Metrics', 'Color', 'w', ...
    'Renderer', 'painters', 'InvertHardcopy', 'off', 'Units', 'pixels', ...
    'Position', [260 60 1280 760]);
tlo1 = tiledlayout(fig_metric, 2, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
sgtitle(fig_metric, 'Ablation Study of Position-Confidence Submodules', ...
    'FontName', 'Times New Roman', 'FontSize', 15, 'FontWeight', 'normal', 'Color', 'k');

method_order = categorical(cellstr(T.Method), cellstr(T.Method), cellstr(T.Method));
method_colors = [ ...
    0.40 0.40 0.40; ...
    0.00 0.45 0.74; ...
    0.85 0.33 0.10; ...
    0.47 0.67 0.19; ...
    0.49 0.18 0.56; ...
    0.75 0.00 0.00];

ax1 = nexttile(tlo1);
b1 = bar(ax1, method_order, T.EmergencyTimelyRate, 0.62, 'FaceColor', 'flat', 'EdgeColor', 'none');
b1.CData = method_colors;
ylabel(ax1, 'Emergency timely delivery rate');
title(ax1, '(a) Overall Emergency Timely Rate', 'Color', 'k');
ylim(ax1, [0.45 0.72]);
apply_paper_axes_style(ax1);
label_bar_values(ax1, T.EmergencyTimelyRate, '%.3f', 0.008);

ax2 = nexttile(tlo1);
yyaxis(ax2, 'left');
b2 = bar(ax2, method_order, T.AvgTxCost, 0.58, 'FaceColor', [0.85 0.70 0.25], 'EdgeColor', 'none');
ylabel(ax2, 'Average transmission cost');
yyaxis(ax2, 'right');
plot(ax2, method_order, T.LossRate, '-o', 'Color', [0.15 0.15 0.15], ...
    'MarkerFaceColor', [0.15 0.15 0.15], 'LineWidth', 1.5, 'MarkerSize', 5.5);
ylabel(ax2, 'Loss rate');
title(ax2, '(b) Cost-Reliability Trade-off', 'Color', 'k');
apply_paper_axes_style(ax2);

posdeg = T_stage(T_stage.Stage == "PosDeg_Emerg", :);
ax3 = nexttile(tlo1);
yvals = [posdeg.TimelyRate, posdeg.EmergencyTimelyRate];
b3 = bar(ax3, categorical(cellstr(posdeg.Method), cellstr(posdeg.Method), cellstr(posdeg.Method)), ...
    yvals, 'grouped');
set(b3(1), 'FaceColor', [0.58 0.77 0.93], 'EdgeColor', 'none');
set(b3(2), 'FaceColor', [0.00 0.45 0.74], 'EdgeColor', 'none');
ylabel(ax3, 'Timely delivery rate');
title(ax3, '(c) Critical Blind-Zone Stage (PosDeg\_Emerg)', 'Color', 'k');
lgd3 = legend(ax3, {'All messages', 'Emergency messages'}, 'Location', 'northwest');
set(lgd3, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
ylim(ax3, [0.15 0.55]);
apply_paper_axes_style(ax3);

ax4 = nexttile(tlo1);
hold(ax4, 'on');
plot(ax4, base_scenario.t, scenario_cases{1}.q_pos, '-', 'Color', method_colors(2, :), 'LineWidth', 2.0);
for i = 2:numel(scenario_cases)
    plot(ax4, base_scenario.t, scenario_cases{i}.q_pos, '-', ...
        'Color', method_colors(i + 1, :), 'LineWidth', 1.6);
end
xline(ax4, 68, '--', 'Color', [0.50 0.50 0.50], 'LineWidth', 1.0);
xline(ax4, 90, '--', 'Color', [0.50 0.50 0.50], 'LineWidth', 1.0);
text(ax4, 70, 0.92, 'PosDeg\_Emerg', 'FontName', 'Times New Roman', 'FontSize', 10, 'Color', [0.20 0.20 0.20]);
xlabel(ax4, 'Time (s)');
ylabel(ax4, 'Position confidence q_{pos}');
title(ax4, '(d) Temporal Evolution of Position Confidence', 'Color', 'k');
lgd4 = legend(ax4, {'Full', 'No-GNSS', 'No-RSU', 'No-Env', 'No-Traj'}, 'Location', 'southwest');
set(lgd4, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
ylim(ax4, [0.15 1.02]);
xlim(ax4, [base_scenario.t(1) base_scenario.t(end)]);
apply_paper_axes_style(ax4);

fig_delta = figure('Name', 'Step10 Academic Ablation Delta', 'Color', 'w', ...
    'Renderer', 'painters', 'InvertHardcopy', 'off', 'Units', 'pixels', ...
    'Position', [340 90 1180 580]);
tlo2 = tiledlayout(fig_delta, 1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
sgtitle(fig_delta, 'Relative Degradation/Improvement Against Full Model', ...
    'FontName', 'Times New Roman', 'FontSize', 15, 'FontWeight', 'normal', 'Color', 'k');

delta_methods = categorical(cellstr(T_imp.Method), cellstr(T_imp.Method), cellstr(T_imp.Method));

ax5 = nexttile(tlo2);
yyaxis(ax5, 'left');
b5 = bar(ax5, delta_methods, T_imp.EmergencyTimelyRateGain, 0.58, ...
    'FaceColor', [0.00 0.45 0.74], 'EdgeColor', 'none');
ylabel(ax5, 'Emergency timely rate gain');
yline(ax5, 0, '-', 'Color', [0.25 0.25 0.25], 'LineWidth', 0.9);
yyaxis(ax5, 'right');
plot(ax5, delta_methods, T_imp.AvgTxCostDelta, '-s', 'Color', [0.85 0.33 0.10], ...
    'MarkerFaceColor', [0.85 0.33 0.10], 'LineWidth', 1.5, 'MarkerSize', 5.5);
ylabel(ax5, 'Average Tx cost delta');
title(ax5, '(a) Overall Delta Relative to Full', 'Color', 'k');
apply_paper_axes_style(ax5);

ax6 = nexttile(tlo2);
posdeg_imp = T_stage_imp(T_stage_imp.Stage == "PosDeg_Emerg", :);
yyaxis(ax6, 'left');
b6 = bar(ax6, categorical(cellstr(posdeg_imp.Method), cellstr(posdeg_imp.Method), cellstr(posdeg_imp.Method)), ...
    posdeg_imp.EmergencyTimelyRateGain, 0.58, 'FaceColor', [0.49 0.18 0.56], 'EdgeColor', 'none');
ylabel(ax6, 'Emergency timely rate gain');
yline(ax6, 0, '-', 'Color', [0.25 0.25 0.25], 'LineWidth', 0.9);
yyaxis(ax6, 'right');
plot(ax6, categorical(cellstr(posdeg_imp.Method), cellstr(posdeg_imp.Method), cellstr(posdeg_imp.Method)), ...
    posdeg_imp.AvgTxCostDelta, '-d', 'Color', [0.20 0.20 0.20], ...
    'MarkerFaceColor', [0.20 0.20 0.20], 'LineWidth', 1.5, 'MarkerSize', 5.5);
ylabel(ax6, 'Average Tx cost delta');
title(ax6, '(b) Blind-Zone Stage Delta Relative to Full', 'Color', 'k');
apply_paper_axes_style(ax6);

writetable(T, 'step10_ablation_metrics_table.csv');
writetable(T_stage, 'step10_ablation_stage_metrics_table.csv');
writetable(T_imp, 'step10_ablation_vs_full.csv');
writetable(T_stage_imp, 'step10_ablation_stage_vs_full.csv');
write_step10_ablation_report(T, T_imp, T_stage, T_stage_imp, 'step10_position_ablation_report.md');

exportgraphics(fig_metric, 'step10_ablation_academic_main.png', 'Resolution', 220);
savefig(fig_metric, 'step10_ablation_academic_main.fig');
exportgraphics(fig_delta, 'step10_ablation_academic_delta.png', 'Resolution', 220);
savefig(fig_delta, 'step10_ablation_academic_delta.fig');

disp(T);
disp(T_stage);
disp(T_imp);
disp(T_stage_imp);
disp('Step 10 academic figures complete: ablation study figures exported.');

function label_bar_values(ax, values, fmt, offset)
for i = 1:numel(values)
    text(ax, i, values(i) + offset, sprintf(fmt, values(i)), ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
        'FontName', 'Times New Roman', 'FontSize', 10, 'Color', 'k');
end
end
