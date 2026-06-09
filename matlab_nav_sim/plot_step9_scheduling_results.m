function plot_step9_scheduling_results(scenario, fixed_result, link_result, conf_result, T)
%PLOT_STEP9_SCHEDULING_RESULTS Plot Step 9 scheduling inputs and outputs.

fig1 = figure('Name', 'Step 9 Scheduling Inputs and Decisions', 'Color', 'w', ...
    'Renderer', 'painters', 'InvertHardcopy', 'off', 'Units', 'pixels', ...
    'Position', [360 60 1080 960]);
tlo = tiledlayout(fig1, 4, 1, 'TileSpacing', 'loose', 'Padding', 'loose');
sgtitle(fig1, 'Confidence-Driven Adaptive Scheduling Analysis', ...
    'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'normal', 'Color', 'k');

ax1 = nexttile(tlo);
plot(ax1, scenario.t, scenario.q_link, '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.8);
hold(ax1, 'on');
plot(ax1, scenario.t, scenario.q_pos, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.8);
stairs(ax1, scenario.t, scenario.relay_available, '--', 'Color', [0.20 0.60 0.20], 'LineWidth', 1.3);
xlabel(ax1, 'Time (s)');
ylabel(ax1, 'Quality / flag');
ylim(ax1, [0 1.05]);
lgd1 = legend(ax1, {'Link quality', 'Positioning confidence', 'Relay available'}, 'Location', 'best');
set(lgd1, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax1);
xlim(ax1, [scenario.t(1) scenario.t(end)]);

ax2 = nexttile(tlo);
plot(ax2, scenario.t, fixed_result.policy.score, '-', 'Color', [0.45 0.45 0.45], 'LineWidth', 1.3);
hold(ax2, 'on');
plot(ax2, scenario.t, link_result.policy.score, '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.5);
plot(ax2, scenario.t, conf_result.policy.score, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.8);
yline(ax2, 0.45, '--', 'Color', [0.50 0.50 0.50], 'LineWidth', 1.0);
yline(ax2, 0.72, ':', 'Color', [0.35 0.35 0.35], 'LineWidth', 1.0);
xlabel(ax2, 'Time (s)');
ylabel(ax2, 'Scheduling score');
lgd2 = legend(ax2, {'Fixed baseline', 'Link-aware baseline', 'Confidence-driven', 'T1', 'T2'}, 'Location', 'best');
set(lgd2, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax2);
xlim(ax2, [scenario.t(1) scenario.t(end)]);

ax3 = nexttile(tlo);
stairs(ax3, scenario.t, conf_result.policy.priority, '-', 'Color', [0.49 0.18 0.56], 'LineWidth', 1.7);
hold(ax3, 'on');
plot(ax3, scenario.t, conf_result.policy.tx_rate, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.8);
stairs(ax3, scenario.t, conf_result.policy.mode, '--', 'Color', [0.75 0.00 0.00], 'LineWidth', 1.4);
xlabel(ax3, 'Time (s)');
ylabel(ax3, 'Decision value');
lgd3 = legend(ax3, {'Priority', 'Tx rate (Hz)', 'Mode'}, 'Location', 'best');
set(lgd3, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax3);
xlim(ax3, [scenario.t(1) scenario.t(end)]);
title(ax3, 'Confidence-Driven Scheduling Actions', 'Color', 'k');

ax4 = nexttile(tlo);
plot(ax4, scenario.t, fixed_result.delivery.delay, '-', 'Color', [0.45 0.45 0.45], 'LineWidth', 1.3);
hold(ax4, 'on');
plot(ax4, scenario.t, link_result.delivery.delay, '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.5);
plot(ax4, scenario.t, conf_result.delivery.delay, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.8);
xlabel(ax4, 'Time (s)');
ylabel(ax4, 'Effective delay (s)');
lgd4 = legend(ax4, {'Fixed baseline', 'Link-aware baseline', 'Confidence-driven'}, 'Location', 'best');
set(lgd4, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax4);
xlim(ax4, [scenario.t(1) scenario.t(end)]);

fig2 = figure('Name', 'Step 9 Metrics Comparison', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [440 120 1320 560]);
tlo2 = tiledlayout(fig2, 1, 3, 'TileSpacing', 'loose', 'Padding', 'loose');

ax5 = nexttile(tlo2);
bar(ax5, categorical(cellstr(T.Method)), T.AvgDelay_s, 0.55, 'FaceColor', [0.30 0.58 0.82]);
ylabel(ax5, 'Average delay (s)');
title(ax5, 'Average Delay', 'Color', 'k');
apply_paper_axes_style(ax5);
xtickangle(ax5, 20);

ax6 = nexttile(tlo2);
bar(ax6, categorical(cellstr(T.Method)), [T.TimelyRate T.EmergencyTimelyRate], 'grouped');
ylabel(ax6, 'Rate');
title(ax6, 'Timely Delivery Rate', 'Color', 'k');
lgd6 = legend(ax6, {'All messages', 'Emergency messages'}, 'Location', 'best');
set(lgd6, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax6);
xtickangle(ax6, 20);

ax7 = nexttile(tlo2);
bar(ax7, categorical(cellstr(T.Method)), [T.LossRate T.AvgTxCost], 'grouped');
ylabel(ax7, 'Loss / cost');
title(ax7, 'Loss Rate and Overhead', 'Color', 'k');
lgd7 = legend(ax7, {'Loss rate', 'Average Tx cost'}, 'Location', 'best');
set(lgd7, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax7);
xtickangle(ax7, 20);

if isfield(scenario, 'gnss_score') && isfield(scenario, 'rsu_support_score')
    fig3 = figure('Name', 'Step 9 Position Confidence Decomposition', 'Color', 'w', ...
        'Renderer', 'painters', 'InvertHardcopy', 'off', 'Units', 'pixels', ...
        'Position', [540 80 1020 820]);
    tlo3 = tiledlayout(fig3, 3, 1, 'TileSpacing', 'loose', 'Padding', 'loose');
    sgtitle(fig3, 'CV2X-LOCA-Like Position Confidence Decomposition', ...
        'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'normal', 'Color', 'k');

    ax8 = nexttile(tlo3);
    plot(ax8, scenario.t, scenario.q_pos_rule, '-', 'Color', [0.65 0.65 0.65], 'LineWidth', 1.3);
    hold(ax8, 'on');
    plot(ax8, scenario.t, scenario.gnss_score, '-', 'Color', [0.20 0.55 0.20], 'LineWidth', 1.6);
    plot(ax8, scenario.t, scenario.q_pos, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.8);
    xlabel(ax8, 'Time (s)');
    ylabel(ax8, 'Confidence');
    lgd8 = legend(ax8, {'Rule-only q_{pos}', 'GNSS base score', 'Final q_{pos}'}, 'Location', 'best');
    set(lgd8, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
    apply_paper_axes_style(ax8);
    xlim(ax8, [scenario.t(1) scenario.t(end)]);

    ax9 = nexttile(tlo3);
    plot(ax9, scenario.t, scenario.rsu_support_score, '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.6);
    hold(ax9, 'on');
    plot(ax9, scenario.t, scenario.env_score, '-', 'Color', [0.49 0.18 0.56], 'LineWidth', 1.6);
    plot(ax9, scenario.t, scenario.traj_score, '-', 'Color', [0.00 0.62 0.68], 'LineWidth', 1.6);
    xlabel(ax9, 'Time (s)');
    ylabel(ax9, 'Sub-score');
    lgd9 = legend(ax9, {'RSU support score', 'Environment score', 'Trajectory score'}, 'Location', 'best');
    set(lgd9, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
    apply_paper_axes_style(ax9);
    xlim(ax9, [scenario.t(1) scenario.t(end)]);

    ax10 = nexttile(tlo3);
    yyaxis(ax10, 'left');
    stairs(ax10, scenario.t, scenario.nearest_rsu_count, '-', 'Color', [0.75 0.00 0.00], 'LineWidth', 1.5);
    ylabel(ax10, 'Visible RSU count');
    yyaxis(ax10, 'right');
    plot(ax10, scenario.t, scenario.env_attenuation, '-', 'Color', [0.10 0.10 0.10], 'LineWidth', 1.6);
    ylabel(ax10, 'Attenuation factor');
    xlabel(ax10, 'Time (s)');
    title(ax10, 'Sparse V2I Support and Environment Correction', 'Color', 'k');
    apply_paper_axes_style(ax10);
    xlim(ax10, [scenario.t(1) scenario.t(end)]);
end
end
