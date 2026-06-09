function plot_step12_multiseed_results(T_raw, T_stage_raw, T_summary, T_stage_summary)
%PLOT_STEP12_MULTISEED_RESULTS Plot Step 12 multiseed statistical results.

methods = categorical(cellstr(T_summary.Method), cellstr(T_summary.Method), cellstr(T_summary.Method));
method_labels = cellstr(T_summary.Method);
posdeg = T_stage_summary(T_stage_summary.Stage == "PosDeg_Emerg", :);

fig1 = figure('Name', 'Step 12 Multiseed Errorbars', 'Color', 'w', ...
    'Renderer', 'painters', 'InvertHardcopy', 'off', 'Units', 'pixels', ...
    'Position', [220 60 1220 760]);
tlo1 = tiledlayout(fig1, 2, 2, 'TileSpacing', 'loose', 'Padding', 'loose');
sgtitle(fig1, 'Step 12 Multi-Seed Statistical Summary', ...
    'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'normal', 'Color', 'k');

ax1 = nexttile(tlo1);
errorbar(ax1, methods, T_summary.EmergencyTimelyRateMean, T_summary.EmergencyTimelyRateCI95, ...
    '-o', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.6, 'MarkerFaceColor', [0.00 0.45 0.74]);
ylabel(ax1, 'Overall emergency timely rate');
title(ax1, '(a) Overall Emergency Timely Rate', 'Color', 'k');
ylim(ax1, [0 1.0]);
apply_paper_axes_style(ax1);
xtickangle(ax1, 20);

ax2 = nexttile(tlo1);
posdeg_methods = categorical(cellstr(posdeg.Method), method_labels, method_labels);
errorbar(ax2, posdeg_methods, posdeg.EmergencyTimelyRateMean, posdeg.EmergencyTimelyRateCI95, ...
    '-s', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.6, 'MarkerFaceColor', [0.85 0.33 0.10]);
ylabel(ax2, 'PosDeg emergency timely rate');
title(ax2, '(b) PosDeg\_Emerg Emergency Timely Rate', 'Color', 'k');
ylim(ax2, [0 1.0]);
apply_paper_axes_style(ax2);
xtickangle(ax2, 20);

ax3 = nexttile(tlo1);
errorbar(ax3, methods, T_summary.AvgTxCostMean, T_summary.AvgTxCostCI95, ...
    '-d', 'Color', [0.49 0.18 0.56], 'LineWidth', 1.6, 'MarkerFaceColor', [0.49 0.18 0.56]);
ylabel(ax3, 'Average transmission cost');
title(ax3, '(c) Average Transmission Cost', 'Color', 'k');
apply_paper_axes_style(ax3);
xtickangle(ax3, 20);

ax4 = nexttile(tlo1);
errorbar(ax4, methods, T_summary.TimelyRateMean, T_summary.TimelyRateCI95, ...
    '-^', 'Color', [0.20 0.60 0.20], 'LineWidth', 1.6, 'MarkerFaceColor', [0.20 0.60 0.20]);
ylabel(ax4, 'Overall timely rate');
title(ax4, '(d) Overall Timely Rate', 'Color', 'k');
ylim(ax4, [0 1.0]);
apply_paper_axes_style(ax4);
xtickangle(ax4, 20);

exportgraphics(fig1, 'step12_errorbar_overall.png', 'Resolution', 300);
savefig(fig1, 'step12_errorbar_overall.fig');

fig2 = figure('Name', 'Step 12 Multiseed Boxplots', 'Color', 'w', ...
    'Renderer', 'painters', 'InvertHardcopy', 'off', 'Units', 'pixels', ...
    'Position', [280 90 1220 760]);
tlo2 = tiledlayout(fig2, 2, 1, 'TileSpacing', 'loose', 'Padding', 'loose');
sgtitle(fig2, 'Step 12 Multi-Seed Distribution of Emergency Timely Rates', ...
    'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'normal', 'Color', 'k');

ax5 = nexttile(tlo2);
axes(ax5);
draw_custom_distribution(ax5, T_raw.EmergencyTimelyRate, T_raw.Method, method_labels);
ylabel(ax5, 'Overall emergency timely rate');
title(ax5, '(a) Overall Emergency Timely Rate Distribution', 'Color', 'k');
apply_paper_axes_style(ax5);
xtickangle(ax5, 20);

ax6 = nexttile(tlo2);
posdeg_raw = T_stage_raw;
posdeg_raw = posdeg_raw(posdeg_raw.Stage == "PosDeg_Emerg", :);
axes(ax6);
draw_custom_distribution(ax6, posdeg_raw.EmergencyTimelyRate, posdeg_raw.Method, method_labels);
ylabel(ax6, 'PosDeg emergency timely rate');
title(ax6, '(b) PosDeg\_Emerg Emergency Timely Distribution', 'Color', 'k');
apply_paper_axes_style(ax6);
xtickangle(ax6, 20);

exportgraphics(fig2, 'step12_boxplot_emergency_timely.png', 'Resolution', 300);
savefig(fig2, 'step12_boxplot_emergency_timely.fig');
end

function draw_custom_distribution(ax, values, method_col, method_labels)
hold(ax, 'on');

num_methods = numel(method_labels);
box_width = 0.46;
jitter_width = 0.14;
box_color = [0.78 0.86 0.95];
median_color = [0.00 0.45 0.74];
whisker_color = [0.25 0.25 0.25];
point_color = [0.40 0.40 0.40];

for i = 1:num_methods
    idx = method_col == string(method_labels{i});
    x = values(idx);
    x = x(~isnan(x));
    if isempty(x)
        continue;
    end

    q1 = percentile_local(x, 25);
    med = percentile_local(x, 50);
    q3 = percentile_local(x, 75);
    iqr_val = q3 - q1;
    lower_bound = q1 - 1.5 * iqr_val;
    upper_bound = q3 + 1.5 * iqr_val;
    whisker_low = min(x(x >= lower_bound));
    whisker_high = max(x(x <= upper_bound));

    patch(ax, ...
        [i - box_width / 2, i + box_width / 2, i + box_width / 2, i - box_width / 2], ...
        [q1, q1, q3, q3], box_color, ...
        'EdgeColor', whisker_color, 'LineWidth', 1.0, 'FaceAlpha', 0.85);
    plot(ax, [i - box_width / 2, i + box_width / 2], [med, med], '-', ...
        'Color', median_color, 'LineWidth', 1.8);
    plot(ax, [i, i], [whisker_low, q1], '-', 'Color', whisker_color, 'LineWidth', 1.0);
    plot(ax, [i, i], [q3, whisker_high], '-', 'Color', whisker_color, 'LineWidth', 1.0);
    plot(ax, [i - 0.12, i + 0.12], [whisker_low, whisker_low], '-', 'Color', whisker_color, 'LineWidth', 1.0);
    plot(ax, [i - 0.12, i + 0.12], [whisker_high, whisker_high], '-', 'Color', whisker_color, 'LineWidth', 1.0);

    jitter = linspace(-jitter_width, jitter_width, numel(x))';
    if numel(x) > 1
        jitter = jitter(randperm(numel(x)));
    end
    scatter(ax, i + jitter, x, 18, 'MarkerFaceColor', point_color, ...
        'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.55, 'MarkerEdgeAlpha', 0.55);
end

xlim(ax, [0.5, num_methods + 0.5]);
ylim(ax, [0 1.0]);
set(ax, 'XTick', 1:num_methods, 'XTickLabel', method_labels);
end

function q = percentile_local(x, p)
x = sort(x(:));
n = numel(x);
if n == 1
    q = x;
    return;
end

pos = 1 + (n - 1) * p / 100;
lo = floor(pos);
hi = ceil(pos);
if lo == hi
    q = x(lo);
else
    q = x(lo) + (pos - lo) * (x(hi) - x(lo));
end
end
