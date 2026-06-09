function plot_step13_scenario_expansion(T_summary, profiles)
%PLOT_STEP13_SCENARIO_EXPANSION Plot Step 13 multi-scenario results.

load_levels = profiles.load_levels;
gnss_levels = profiles.gnss_levels;
rsu_levels = profiles.rsu_levels;

fig1 = figure('Name', 'Step 13 Scenario Heatmaps', 'Color', 'w', ...
    'Renderer', 'painters', 'InvertHardcopy', 'off', 'Units', 'pixels', ...
    'Position', [180 60 1320 860]);
tlo1 = tiledlayout(fig1, 2, 3, 'TileSpacing', 'loose', 'Padding', 'loose');
sgtitle(fig1, 'Scenario Expansion: Full vs Link-Aware Gain', ...
    'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'normal', 'Color', 'k');

for i = 1:numel(load_levels)
    gain_overall = build_gain_matrix(T_summary, gnss_levels, rsu_levels, load_levels(i), ...
        'EmergencyTimelyRateMean');
    ax = nexttile(tlo1);
    imagesc(ax, gain_overall);
    colormap(ax, parula);
    colorbar(ax);
    set(ax, 'XTick', 1:numel(rsu_levels), 'XTickLabel', cellstr(rsu_levels), ...
        'YTick', 1:numel(gnss_levels), 'YTickLabel', cellstr(gnss_levels), ...
        'YDir', 'normal');
    xlabel(ax, 'RSU sparsity level');
    ylabel(ax, 'GNSS degradation level');
    title(ax, sprintf('(a%d) Overall emergency gain, Load=%s', i, load_levels(i)), 'Color', 'k');
    add_heatmap_labels(ax, gain_overall);
    apply_paper_axes_style(ax);
end

for i = 1:numel(load_levels)
    gain_effective = build_gain_matrix(T_summary, gnss_levels, rsu_levels, load_levels(i), ...
        'EffectiveWarningRateMean');
    ax = nexttile(tlo1);
    imagesc(ax, gain_effective);
    colormap(ax, turbo);
    colorbar(ax);
    set(ax, 'XTick', 1:numel(rsu_levels), 'XTickLabel', cellstr(rsu_levels), ...
        'YTick', 1:numel(gnss_levels), 'YTickLabel', cellstr(gnss_levels), ...
        'YDir', 'normal');
    xlabel(ax, 'RSU sparsity level');
    ylabel(ax, 'GNSS degradation level');
    title(ax, sprintf('(b%d) Effective-warning gain, Load=%s', i, load_levels(i)), 'Color', 'k');
    add_heatmap_labels(ax, gain_effective);
    apply_paper_axes_style(ax);
end

exportgraphics(fig1, 'step13_scenario_heatmaps.png', 'Resolution', 300);
savefig(fig1, 'step13_scenario_heatmaps.fig');

fig2 = figure('Name', 'Step 13 Scenario Trendlines', 'Color', 'w', ...
    'Renderer', 'painters', 'InvertHardcopy', 'off', 'Units', 'pixels', ...
    'Position', [220 80 1280 780]);
tlo2 = tiledlayout(fig2, 2, 2, 'TileSpacing', 'loose', 'Padding', 'loose');
sgtitle(fig2, 'Scenario Expansion: Method Trendlines Across Conditions', ...
    'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'normal', 'Color', 'k');

ax1 = nexttile(tlo2);
plot_load_trends(ax1, T_summary, profiles, 'EmergencyTimelyRateMean', 'Overall emergency timely rate');
title(ax1, '(a) Overall Emergency Timely Rate vs Load', 'Color', 'k');

ax2 = nexttile(tlo2);
plot_load_trends(ax2, T_summary, profiles, 'EffectiveWarningRateMean', 'Effective warning rate');
title(ax2, '(b) Effective Warning Rate vs Load', 'Color', 'k');

ax3 = nexttile(tlo2);
plot_load_trends(ax3, T_summary, profiles, 'AvgTxCostMean', 'Average transmission cost');
title(ax3, '(c) Average Transmission Cost vs Load', 'Color', 'k');

ax4 = nexttile(tlo2);
plot_load_trends(ax4, T_summary, profiles, 'PosDegEmergencyTimelyRateMean', 'PosDeg emergency timely rate');
title(ax4, '(d) PosDeg Emergency Timely Rate vs Load', 'Color', 'k');

exportgraphics(fig2, 'step13_scenario_trends.png', 'Resolution', 300);
savefig(fig2, 'step13_scenario_trends.fig');
end

function M = build_gain_matrix(T_summary, gnss_levels, rsu_levels, load_level, metric_name)
M = nan(numel(gnss_levels), numel(rsu_levels));
for r = 1:numel(gnss_levels)
    for c = 1:numel(rsu_levels)
        idx_full = T_summary.GNSSLevel == gnss_levels(r) & T_summary.RSULevel == rsu_levels(c) ...
            & T_summary.LoadLevel == load_level & T_summary.Method == "Full";
        idx_link = T_summary.GNSSLevel == gnss_levels(r) & T_summary.RSULevel == rsu_levels(c) ...
            & T_summary.LoadLevel == load_level & T_summary.Method == "Link-aware";
        if any(idx_full) && any(idx_link)
            M(r, c) = T_summary.(metric_name)(idx_full) - T_summary.(metric_name)(idx_link);
        end
    end
end
end

function add_heatmap_labels(ax, M)
for r = 1:size(M, 1)
    for c = 1:size(M, 2)
        text(ax, c, r, sprintf('%.3f', M(r, c)), ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
            'FontName', 'Times New Roman', 'FontSize', 10, 'Color', 'w');
    end
end
end

function plot_load_trends(ax, T_summary, profiles, metric_name, y_label_text)
hold(ax, 'on');
method_set = ["Link-aware", "Full", "No-RSU"];
line_styles = {'--o', '-s', '-.^'};
colors = [0.40 0.40 0.40; 0.00 0.45 0.74; 0.85 0.33 0.10];

for i = 1:numel(method_set)
    y = zeros(numel(profiles.load_levels), 1);
    for j = 1:numel(profiles.load_levels)
        idx = T_summary.Method == method_set(i) & T_summary.LoadLevel == profiles.load_levels(j);
        y(j) = mean(T_summary.(metric_name)(idx), 'omitnan');
    end
    plot(ax, 1:numel(profiles.load_levels), y, line_styles{i}, ...
        'Color', colors(i, :), 'LineWidth', 1.6, 'MarkerSize', 6, ...
        'MarkerFaceColor', colors(i, :));
end

set(ax, 'XTick', 1:numel(profiles.load_levels), 'XTickLabel', cellstr(profiles.load_levels));
xlabel(ax, 'Message load level');
ylabel(ax, y_label_text);
lgd = legend(ax, cellstr(method_set), 'Location', 'best');
set(lgd, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax);
end
