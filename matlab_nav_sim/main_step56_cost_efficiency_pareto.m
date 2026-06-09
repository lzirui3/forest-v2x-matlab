clc;
clear;
close all;

% Step56: cost-efficiency and Pareto trade-off evidence.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

prefix = "step56_cost_efficiency_pareto";
summary_path = "step54_literature_baselines_per_lookup_50seed_summary.csv";
interpretation_path = "step55_final_statistical_evidence_interpretation_table.csv";
if ~isfile(summary_path) || ~isfile(interpretation_path)
    error('Missing Step54/Step55 input for Step56.');
end

T_summary = normalize_table_local(readtable(summary_path, 'TextType', 'string'));
T_interpretation = normalize_table_local(readtable(interpretation_path, 'TextType', 'string'));

T_eff = build_step56_cost_efficiency_table_local(T_summary);
T_pareto = build_step56_pareto_table_local(T_summary);

writetable(T_eff, prefix + "_efficiency_table.csv");
writetable(T_pareto, prefix + "_pareto_membership.csv");

plot_step56_pareto_figures_local(T_summary, prefix);
plot_step56_delta_tradeoff_local(T_eff, prefix);
write_step56_cost_efficiency_report_cn(T_eff, T_pareto, T_interpretation, ...
    prefix + "_overall_pareto.png", prefix + "_delta_tradeoff.png", ...
    prefix + "_report_cn.md");

disp(T_eff(T_eff.BaselineMethod == "Confidence-heuristic", :));
fprintf('Step56 complete: cost-efficiency and Pareto evidence generated.\n');

function T_eff = build_step56_cost_efficiency_table_local(T_summary)
keys = unique(T_summary(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'}), ...
    'rows', 'stable');
baselines = ["DCC-like", "AoI-aware", "Link-delay-aware", "Confidence-heuristic"];
rows = [];
for i = 1:height(keys)
    subT = T_summary(T_summary.Scene == keys.Scene(i) & T_summary.Config == keys.Config(i), :);
    v6 = get_method_row_local(subT, "Risk-constrained-v6");
    if isempty(v6)
        continue;
    end
    for baseline = baselines
        b = get_method_row_local(subT, baseline);
        if isempty(b)
            continue;
        end
        row = keys(i, :);
        row.BaselineMethod = baseline;
        row.ProposedMethod = "Risk-constrained-v6";
        row.DeltaTimely_pp = 100.0 * (v6.TimelyRateMean - b.TimelyRateMean);
        row.DeltaEmergency_pp = 100.0 * (v6.EmergencyTimelyRateMean - b.EmergencyTimelyRateMean);
        row.DeltaLoss_pp = 100.0 * (v6.LossRateMean - b.LossRateMean);
        row.DeltaDelay_pct = pct_delta_local(v6.AvgDelayMean, b.AvgDelayMean);
        row.DeltaCost_pct = pct_delta_local(v6.AvgTxCostMean, b.AvgTxCostMean);
        row.DeltaCost_abs = v6.AvgTxCostMean - b.AvgTxCostMean;
        row.TimelyGainPerCostPct = safe_ratio_local(row.DeltaTimely_pp, max(row.DeltaCost_pct, 0.0));
        row.EmergencyGainPerCostPct = safe_ratio_local(row.DeltaEmergency_pp, max(row.DeltaCost_pct, 0.0));
        row.CostEfficiencyClass = classify_efficiency_local(row.DeltaTimely_pp, ...
            row.DeltaEmergency_pp, row.DeltaCost_pct);
        rows = append_table_local(rows, row);
    end
end
T_eff = rows;
end

function T_pareto = build_step56_pareto_table_local(T_summary)
rows = [];
keys = unique(T_summary(:, {'Scene','Config'}), 'rows', 'stable');
for i = 1:height(keys)
    subT = T_summary(T_summary.Scene == keys.Scene(i) & T_summary.Config == keys.Config(i), :);
    timely_front = find_pareto_points_local(subT.AvgTxCostMean, subT.TimelyRateMean);
    emg_front = find_pareto_points_local(subT.AvgTxCostMean, subT.EmergencyTimelyRateMean);
    for j = 1:height(subT)
        row = subT(j, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config','Method'});
        row.AvgTxCostMean = subT.AvgTxCostMean(j);
        row.TimelyRateMean = subT.TimelyRateMean(j);
        row.EmergencyTimelyRateMean = subT.EmergencyTimelyRateMean(j);
        row.OnTimelyParetoFront = timely_front(j);
        row.OnEmergencyParetoFront = emg_front(j);
        rows = append_table_local(rows, row);
    end
end
T_pareto = rows;
end

function plot_step56_pareto_figures_local(T_summary, prefix)
fig = figure('Color', 'w', 'Name', 'Step56 Pareto', 'Renderer', 'painters', ...
    'Units', 'pixels', 'Position', [120 80 1280 620]);
tlo = tiledlayout(fig, 1, 2, 'TileSpacing', 'loose', 'Padding', 'loose');

ax1 = nexttile(tlo);
plot_pareto_panel_local(ax1, T_summary, 'TimelyRateMean', 'Timely rate');
ax2 = nexttile(tlo);
plot_pareto_panel_local(ax2, T_summary, 'EmergencyTimelyRateMean', 'Emergency timely rate');

exportgraphics(fig, prefix + "_overall_pareto.png", 'Resolution', 300);
savefig(fig, prefix + "_overall_pareto.fig");
close(fig);
end

function plot_step56_delta_tradeoff_local(T_eff, prefix)
fig = figure('Color', 'w', 'Name', 'Step56 Delta Tradeoff', 'Renderer', 'painters', ...
    'Units', 'pixels', 'Position', [140 90 980 660]);
ax = axes(fig);
hold(ax, 'on');
baselines = unique(T_eff.BaselineMethod, 'stable');
colors = lines(numel(baselines));
markers = {'o','s','^','d','v','p'};
for i = 1:numel(baselines)
    b = baselines(i);
    idx = T_eff.BaselineMethod == b;
    scatter(ax, T_eff.DeltaCost_pct(idx), T_eff.DeltaTimely_pp(idx), 62, ...
        'Marker', markers{mod(i - 1, numel(markers)) + 1}, ...
        'MarkerFaceColor', colors(i, :), 'MarkerEdgeColor', [0.12 0.12 0.12], ...
        'DisplayName', char(b));
end
plot(ax, xlim(ax), [0 0], ':', 'Color', [0.25 0.25 0.25], 'HandleVisibility', 'off');
plot(ax, [0 0], ylim(ax), ':', 'Color', [0.25 0.25 0.25], 'HandleVisibility', 'off');
xlabel(ax, '\Delta Tx cost (%)');
ylabel(ax, '\Delta timely rate (percentage points)');
title(ax, 'Risk-constrained-v6 cost-efficiency against baselines');
legend(ax, 'Location', 'best');
apply_paper_axes_style(ax);
hold(ax, 'off');
exportgraphics(fig, prefix + "_delta_tradeoff.png", 'Resolution', 300);
savefig(fig, prefix + "_delta_tradeoff.fig");
close(fig);
end

function plot_pareto_panel_local(ax, T, metric_name, y_label)
hold(ax, 'on');
methods = unique(T.Method, 'stable');
colors = lines(numel(methods));
markers = {'o','s','^','d','v','p','h'};
for i = 1:numel(methods)
    method = methods(i);
    idx = T.Method == method;
    scatter(ax, T.AvgTxCostMean(idx), T.(metric_name)(idx), 54, ...
        'Marker', markers{mod(i - 1, numel(markers)) + 1}, ...
        'MarkerFaceColor', colors(i, :), 'MarkerEdgeColor', [0.12 0.12 0.12], ...
        'DisplayName', char(method));
end
front = find_pareto_points_local(T.AvgTxCostMean, T.(metric_name));
if nnz(front) >= 2
    rows = find(front);
    [~, order] = sort(T.AvgTxCostMean(rows), 'ascend');
    rows = rows(order);
    plot(ax, T.AvgTxCostMean(rows), T.(metric_name)(rows), '-', ...
        'Color', [0.05 0.05 0.05], 'LineWidth', 1.3, 'DisplayName', 'Pareto front');
end
xlabel(ax, 'Average Tx cost');
ylabel(ax, y_label);
title(ax, sprintf('Pareto trade-off: %s', y_label));
legend(ax, 'Location', 'best');
apply_paper_axes_style(ax);
hold(ax, 'off');
end

function front = find_pareto_points_local(cost, performance)
front = false(numel(cost), 1);
valid = ~(isnan(cost) | isnan(performance));
rows = find(valid);
if isempty(rows)
    return;
end
[~, order] = sortrows([cost(valid), -performance(valid)], [1 2]);
ordered = rows(order);
best_perf = -Inf;
for i = 1:numel(ordered)
    row = ordered(i);
    if performance(row) > best_perf + 1.0e-12
        front(row) = true;
        best_perf = performance(row);
    end
end
end

function row = get_method_row_local(T, method_name)
row = T(T.Method == method_name, :);
if height(row) > 1
    row = row(1, :);
end
end

function label = classify_efficiency_local(delta_timely_pp, delta_emg_pp, delta_cost_pct)
if delta_cost_pct <= 0 && (delta_timely_pp >= 0 || delta_emg_pp >= 0)
    label = "DominantOrCostSaving";
elseif delta_cost_pct > 0 && (delta_timely_pp >= 1.0 || delta_emg_pp >= 1.0)
    label = "CostlyButMeaningful";
elseif delta_cost_pct > 0 && delta_timely_pp >= 0
    label = "WeakGainWithCost";
elseif delta_timely_pp < 0 && delta_emg_pp < 0
    label = "CostInefficientBoundary";
else
    label = "MixedBoundary";
end
end

function value = pct_delta_local(new_value, ref_value)
value = 100.0 * (new_value - ref_value) / max(abs(ref_value), 1.0e-12);
end

function value = safe_ratio_local(num, den)
if den <= 1.0e-12
    value = NaN;
else
    value = num / den;
end
end

function T = normalize_table_local(T)
names = {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','Method','BaselineMethod','ProposedMethod','CostEfficiencyClass'};
for i = 1:numel(names)
    if ismember(names{i}, T.Properties.VariableNames)
        T.(names{i}) = string(T.(names{i}));
    end
end
end

function T = append_table_local(T, rows)
if isempty(T)
    T = rows;
else
    T = [T; rows]; %#ok<AGROW>
end
end
