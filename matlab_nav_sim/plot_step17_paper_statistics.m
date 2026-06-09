function plot_step17_paper_statistics(T_summary, T_stage_summary, prefix)
%PLOT_STEP17_PAPER_STATISTICS Plot paper-level statistics across scenes/configs.

if nargin < 3 || isempty(prefix)
    prefix = 'step17';
end

methods = ["Link-delay-aware", "Confidence-driven", "Constrained Oracle"];
scenes = unique(T_summary.Scene, 'stable');
configs = unique(T_summary.Config, 'stable');

fig = figure('Name', 'Step 17 Paper Statistics', 'Color', 'w', ...
    'Renderer', 'painters', 'InvertHardcopy', 'off', 'Units', 'pixels', ...
    'Position', [180 60 1320 820]);
tlo = tiledlayout(fig, numel(scenes), 2, 'TileSpacing', 'loose', 'Padding', 'loose');

for s = 1:numel(scenes)
    scene_name = scenes(s);
    sub_overall = T_summary(T_summary.Scene == scene_name & ismember(T_summary.Method, methods), :);
    sub_overall = sortrows(sub_overall, {'Config','Method'});

    ax1 = nexttile(tlo);
    plot_grouped_metric(ax1, sub_overall, methods, 'TimelyRateMean', configs, ...
        sprintf('%s Overall Timely Rate', scene_name), 'Timely rate');

    sub_pos = T_stage_summary(T_stage_summary.Scene == scene_name & ...
        T_stage_summary.Stage == "PosDeg_Emerg" & ismember(T_stage_summary.Method, methods), :);
    sub_pos = sortrows(sub_pos, {'Config','Method'});

    ax2 = nexttile(tlo);
    plot_grouped_metric(ax2, sub_pos, methods, 'EmergencyTimelyRateMean', configs, ...
        sprintf('%s PosDeg_Emerg Emergency Timely', scene_name), 'Emergency timely rate');
end

exportgraphics(fig, sprintf('%s_paper_statistics.png', prefix), 'Resolution', 300);
savefig(fig, sprintf('%s_paper_statistics.fig', prefix));
end

function plot_grouped_metric(ax, T, methods, metric_name, configs, ttl, ylab)
vals = zeros(numel(methods), numel(configs));
for c = 1:numel(configs)
    for m = 1:numel(methods)
        idx = T.Config == configs(c) & T.Method == methods(m);
        if any(idx)
            vals(m, c) = T.(metric_name)(find(idx, 1, 'first'));
        end
    end
end

bar(ax, categorical(cellstr(methods)), vals, 'grouped');
title(ax, ttl, 'Color', 'k');
ylabel(ax, ylab);
legend(ax, cellstr(configs), 'Location', 'best');
ylim(ax, [0 1]);
apply_paper_axes_style(ax);
end
