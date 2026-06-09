function plot_step11_sensitivity_results(T)
%PLOT_STEP11_SENSITIVITY_RESULTS Plot Step 11 parameter sensitivity figures.

params = unique(T.Parameter, 'stable');
num_params = numel(params);
colors = lines(3);
num_tiles = num_params + 1;
num_cols = 2;
num_rows = ceil(num_tiles / num_cols);

fig1 = figure('Name', 'Step 11 Sensitivity Main', 'Color', 'w', ...
    'Renderer', 'painters', 'InvertHardcopy', 'off', 'Units', 'pixels', ...
    'Position', [220 60 1280 860]);
tlo1 = tiledlayout(fig1, num_rows, num_cols, 'TileSpacing', 'loose', 'Padding', 'loose');
sgtitle(fig1, 'Step 11 Sensitivity: Scheduling Performance Response', ...
    'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'normal', 'Color', 'k');

for i = 1:num_params
    subT = T(T.Parameter == params(i), :);
    ax = nexttile(tlo1);
    plot(ax, subT.Value, subT.TimelyRate, '-o', 'Color', colors(1, :), 'LineWidth', 1.5, 'MarkerSize', 5);
    hold(ax, 'on');
    plot(ax, subT.Value, subT.EmergencyTimelyRate, '-s', 'Color', colors(2, :), 'LineWidth', 1.5, 'MarkerSize', 5);
    plot(ax, subT.Value, subT.PosDegEmergencyTimelyRate, '-d', 'Color', colors(3, :), 'LineWidth', 1.6, 'MarkerSize', 5);
    xline(ax, subT.DefaultValue(1), ':', 'Color', [0.25 0.25 0.25], 'LineWidth', 1.0);
    xlabel(ax, strrep(char(params(i)), '_', '\_'));
    ylabel(ax, 'Rate');
    ylim(ax, [0 1.05]);
    title(ax, format_param_title(params(i)), 'Color', 'k');
    apply_paper_axes_style(ax);

    if i == 1
        lgd = legend(ax, {'Overall timely', 'Emergency timely', 'PosDeg emergency timely', 'Default'}, ...
            'Location', 'best');
        set(lgd, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
    end
end

ax_summary = nexttile(tlo1);
span_summary = zeros(num_params, 2);
for i = 1:num_params
    subT = T(T.Parameter == params(i), :);
    span_summary(i, 1) = max(subT.EmergencyTimelyRate) - min(subT.EmergencyTimelyRate);
    span_summary(i, 2) = max(subT.PosDegEmergencyTimelyRate) - min(subT.PosDegEmergencyTimelyRate);
end
bar(ax_summary, categorical(cellstr(params)), span_summary, 'grouped');
ylabel(ax_summary, 'Rate span');
title(ax_summary, 'Sensitivity Span Summary', 'Color', 'k');
lgd = legend(ax_summary, {'Overall emergency timely span', 'PosDeg emergency timely span'}, ...
    'Location', 'best');
set(lgd, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax_summary);
xtickangle(ax_summary, 20);

exportgraphics(fig1, 'step11_sensitivity_main.png', 'Resolution', 300);
savefig(fig1, 'step11_sensitivity_main.fig');

fig2 = figure('Name', 'Step 11 Sensitivity Tradeoff', 'Color', 'w', ...
    'Renderer', 'painters', 'InvertHardcopy', 'off', 'Units', 'pixels', ...
    'Position', [260 80 1280 860]);
tlo2 = tiledlayout(fig2, num_rows, num_cols, 'TileSpacing', 'loose', 'Padding', 'loose');
sgtitle(fig2, 'Step 11 Sensitivity: Critical-Stage Gain vs Transmission Cost', ...
    'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'normal', 'Color', 'k');

for i = 1:num_params
    subT = T(T.Parameter == params(i), :);
    ax = nexttile(tlo2);
    yyaxis(ax, 'left');
    plot(ax, subT.Value, subT.PosDegEmergencyTimelyRate, '-d', ...
        'Color', [0.85 0.33 0.10], 'LineWidth', 1.6, 'MarkerSize', 5);
    ylabel(ax, 'PosDeg emergency timely');
    ylim(ax, [0 1.05]);

    yyaxis(ax, 'right');
    plot(ax, subT.Value, subT.AvgTxCost, '-o', ...
        'Color', [0.00 0.45 0.74], 'LineWidth', 1.5, 'MarkerSize', 5);
    ylabel(ax, 'Average Tx cost');

    xline(ax, subT.DefaultValue(1), ':', 'Color', [0.25 0.25 0.25], 'LineWidth', 1.0);
    xlabel(ax, strrep(char(params(i)), '_', '\_'));
    title(ax, format_param_title(params(i)), 'Color', 'k');
    apply_paper_axes_style(ax);

    if i == 1
        lgd = legend(ax, {'PosDeg emergency timely', 'Average Tx cost', 'Default'}, 'Location', 'best');
        set(lgd, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
    end
end

ax_summary2 = nexttile(tlo2);
summary_cost = zeros(num_params, 2);
for i = 1:num_params
    subT = T(T.Parameter == params(i), :);
    summary_cost(i, 1) = max(subT.AvgTxCost) - min(subT.AvgTxCost);
    summary_cost(i, 2) = max(subT.PosDegAvgTxCost) - min(subT.PosDegAvgTxCost);
end
bar(ax_summary2, categorical(cellstr(params)), summary_cost, 'grouped');
ylabel(ax_summary2, 'Cost span');
title(ax_summary2, 'Transmission Cost Span Summary', 'Color', 'k');
lgd = legend(ax_summary2, {'Overall cost span', 'PosDeg cost span'}, 'Location', 'best');
set(lgd, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax_summary2);
xtickangle(ax_summary2, 20);

exportgraphics(fig2, 'step11_sensitivity_tradeoff.png', 'Resolution', 300);
savefig(fig2, 'step11_sensitivity_tradeoff.fig');
end

function title_text = format_param_title(param_name)
switch char(param_name)
    case 'blind_zone_trigger_threshold'
        title_text = 'Blind-Zone Trigger Threshold';
    case 'rsu_event_trigger_threshold'
        title_text = 'RSU Event Trigger Threshold';
    case 'env_event_trigger_threshold'
        title_text = 'Environment Event Trigger Threshold';
    case 'event_rate_scale_gain'
        title_text = 'Event Rate Scale Gain';
    case 'event_synergy_gain'
        title_text = 'Event Synergy Gain';
    case 'utility_weight_timely'
        title_text = 'Utility Weight: Timely';
    case 'utility_weight_reliability'
        title_text = 'Utility Weight: Reliability';
    case 'utility_weight_position_risk'
        title_text = 'Utility Weight: Position Risk';
    case 'utility_weight_event'
        title_text = 'Utility Weight: Event Gain';
    case 'utility_constraint_penalty'
        title_text = 'Constraint Penalty';
    case 'utility_margin_sigmoid_scale'
        title_text = 'Delivery Margin Sigmoid Scale';
    case 'utility_sigmoid_scale'
        title_text = 'Deadline Sigmoid Scale';
    otherwise
        title_text = strrep(char(param_name), '_', ' ');
end
end
