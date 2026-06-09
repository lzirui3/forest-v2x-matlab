function plot_cost_efficiency_pareto(T_summary, prefix)
%PLOT_COST_EFFICIENCY_PARETO Plot cost-performance Pareto evidence.

if nargin < 2 || isempty(prefix)
    prefix = 'cost_efficiency';
end

methods = unique(as_string_column(T_summary.Method), 'stable');
configs = unique(as_string_column(T_summary.Config), 'stable');
colors = lines(max(numel(methods), 3));
markers = {'o','s','^','d','v','>','<','p','h'};

fig = figure('Name', 'Cost-Efficiency Pareto', 'Color', 'w', ...
    'Renderer', 'painters', 'InvertHardcopy', 'off', 'Units', 'pixels', ...
    'Position', [160 80 1280 620]);
tlo = tiledlayout(fig, 1, 2, 'TileSpacing', 'loose', 'Padding', 'loose');

ax1 = nexttile(tlo);
plot_pareto_panel(ax1, T_summary, methods, configs, colors, markers, ...
    'TimelyRateMean', 'Overall timely rate');

ax2 = nexttile(tlo);
plot_pareto_panel(ax2, T_summary, methods, configs, colors, markers, ...
    'EmergencyTimelyRateMean', 'Emergency timely rate');

exportgraphics(fig, sprintf('%s_cost_efficiency_pareto.png', prefix), 'Resolution', 300);
savefig(fig, sprintf('%s_cost_efficiency_pareto.fig', prefix));
end

function plot_pareto_panel(ax, T, methods, configs, colors, markers, metric_name, y_label)
hold(ax, 'on');
set(ax, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', ...
    'GridColor', [0.72 0.72 0.72], 'MinorGridColor', [0.84 0.84 0.84]);
for m = 1:numel(methods)
    method = methods(m);
    idx = as_string_column(T.Method) == method;
    if ~any(idx)
        continue;
    end

    marker = markers{mod(m - 1, numel(markers)) + 1};
    scatter(ax, T.AvgTxCostMean(idx), T.(metric_name)(idx), 58, ...
        'Marker', marker, 'MarkerFaceColor', colors(m, :), ...
        'MarkerEdgeColor', [0.15 0.15 0.15], 'DisplayName', char(method));
end

front_idx = find_pareto_points(T.AvgTxCostMean, T.(metric_name));
if nnz(front_idx) >= 2
    [~, order] = sort(T.AvgTxCostMean(front_idx), 'ascend');
    front_rows = find(front_idx);
    front_rows = front_rows(order);
    plot(ax, T.AvgTxCostMean(front_rows), T.(metric_name)(front_rows), '-', ...
        'Color', [0.05 0.05 0.05], 'LineWidth', 1.4, ...
        'DisplayName', 'Non-dominated front');
elseif nnz(front_idx) == 1
    front_rows = find(front_idx);
    scatter(ax, T.AvgTxCostMean(front_rows), T.(metric_name)(front_rows), 95, ...
        'Marker', 'x', 'MarkerEdgeColor', [0.05 0.05 0.05], ...
        'LineWidth', 1.4, 'DisplayName', 'Non-dominated point');
end

apply_axis_padding(ax, T.AvgTxCostMean, T.(metric_name));
label_rows = find(front_idx);
x_range = diff(xlim(ax));
y_range = diff(ylim(ax));
for k = 1:numel(label_rows)
    i = label_rows(k);
    label = build_point_label(T, i, configs);
    text(ax, T.AvgTxCostMean(i) + 0.012 * x_range, ...
        T.(metric_name)(i) + 0.012 * y_range, label, ...
        'FontSize', 7, 'Color', [0.20 0.20 0.20], 'Interpreter', 'none');
end

xlabel(ax, 'Average Tx cost');
ylabel(ax, y_label);
title(ax, sprintf('Cost-performance Pareto: %s', y_label), 'Color', 'k');
lgd = legend(ax, 'Location', 'best');
set(lgd, 'Color', 'w', 'TextColor', 'k', 'EdgeColor', [0.25 0.25 0.25]);
grid(ax, 'on');
box(ax, 'off');
apply_paper_axes_style(ax);
set(ax, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', ...
    'GridColor', [0.72 0.72 0.72], 'MinorGridColor', [0.84 0.84 0.84]);
hold(ax, 'off');
end

function label = build_point_label(T, idx, configs)
if ismember('Scene', T.Properties.VariableNames)
    scenes = as_string_column(T.Scene);
    scene = scenes(idx);
else
    scene = "";
end

config = as_string_column(T.Config);
config = config(idx);
if numel(configs) > 1
    if strlength(scene) > 0
        label = sprintf('%s/%s', scene, short_config(config));
    else
        label = char(short_config(config));
    end
else
    label = char(scene);
end
end

function out = short_config(config)
if config == "ForestGeometry"
    out = "FG";
elseif config == "Moderate-Forest"
    out = "MF";
elseif config == "Forest-150ms"
    out = "F150";
elseif config == "Strict-75ms"
    out = "S75";
else
    out = config;
end
end

function values = as_string_column(column)
if iscell(column)
    values = string(column);
else
    values = string(column);
end
end

function apply_axis_padding(ax, x, y)
valid = ~(isnan(x) | isnan(y));
if ~any(valid)
    return;
end

x_min = min(x(valid));
x_max = max(x(valid));
y_min = min(y(valid));
y_max = max(y(valid));
x_pad = max(0.05, 0.06 * max(x_max - x_min, eps));
y_pad = max(0.02, 0.08 * max(y_max - y_min, eps));
xlim(ax, [x_min - x_pad, x_max + x_pad]);
ylim(ax, [max(0, y_min - y_pad), min(1.05, y_max + y_pad)]);
end

function front_idx = find_pareto_points(cost, performance)
% Lower cost and higher performance are preferred.
front_idx = false(numel(cost), 1);
valid = ~(isnan(cost) | isnan(performance));
valid_rows = find(valid);
if isempty(valid_rows)
    return;
end

sort_matrix = [cost(valid), -performance(valid)];
[~, order] = sortrows(sort_matrix, [1 2]);
ordered_rows = valid_rows(order);

best_performance = -Inf;
for i = 1:numel(ordered_rows)
    row = ordered_rows(i);
    if performance(row) > best_performance + 1.0e-12
        front_idx(row) = true;
        best_performance = performance(row);
    end
end
end
