function plot_step8_constraint_scheduling(truth, fixed_nhc, adaptive_nhc)
%PLOT_STEP8_CONSTRAINT_SCHEDULING Compare fixed and adaptive constraint scheduling.

fig1 = figure('Name', 'Adaptive Constraint Scheduling Comparison', 'Color', 'w', ...
    'Renderer', 'painters', 'InvertHardcopy', 'off', 'Units', 'pixels', ...
    'Position', [360 80 980 900]);
tlo1 = tiledlayout(fig1, 4, 1, 'TileSpacing', 'loose', 'Padding', 'loose');
sgtitle(fig1, 'Fixed vs Adaptive Constraint Strength Scheduling', ...
    'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'normal', 'Color', 'k');

ax1 = nexttile(tlo1);
plot(ax1, truth.x, truth.y, '-', 'Color', [0.10 0.10 0.10], 'LineWidth', 1.8);
hold(ax1, 'on');
plot(ax1, fixed_nhc.x, fixed_nhc.y, '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.5);
plot(ax1, adaptive_nhc.x, adaptive_nhc.y, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.8);
axis(ax1, 'equal');
xlabel(ax1, 'x (m)');
ylabel(ax1, 'y (m)');
lgd1 = legend(ax1, {'Truth', 'Fixed constraints', 'Adaptive constraints'}, 'Location', 'best');
set(lgd1, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax1);

ax2 = nexttile(tlo1);
plot(ax2, truth.t, fixed_nhc.pos_err, '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.5);
hold(ax2, 'on');
plot(ax2, truth.t, adaptive_nhc.pos_err, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.8);
xlabel(ax2, 'Time (s)');
ylabel(ax2, 'Position error (m)');
lgd2 = legend(ax2, {'Fixed constraints', 'Adaptive constraints'}, 'Location', 'northwest');
set(lgd2, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax2);
xlim(ax2, [truth.t(1) truth.t(end)]);

ax3 = nexttile(tlo1);
yyaxis(ax3, 'left');
plot(ax3, truth.t, adaptive_nhc.zupt_gain_hist, '-', 'Color', [0.20 0.60 0.20], 'LineWidth', 1.8);
hold(ax3, 'on');
plot(ax3, truth.t, adaptive_nhc.nhc_gain_hist, '-', 'Color', [0.49 0.18 0.56], 'LineWidth', 1.6);
ylabel(ax3, 'Adaptive gain');
ylim(ax3, [0 1.0]);

yyaxis(ax3, 'right');
stairs(ax3, truth.t, double(adaptive_nhc.nhc_active), '--', 'Color', [0.75 0.00 0.00], 'LineWidth', 1.2);
ylabel(ax3, 'NHC active flag');
ylim(ax3, [0 1.05]);

xlabel(ax3, 'Time (s)');
lgd3 = legend(ax3, {'Adaptive ZUPT gain', 'Adaptive NHC gain', 'NHC active'}, 'Location', 'best');
set(lgd3, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax3);
xlim(ax3, [truth.t(1) truth.t(end)]);
title(ax3, 'Constraint Scheduling Signals', 'Color', 'k');

ax4 = nexttile(tlo1);
yyaxis(ax4, 'left');
plot(ax4, truth.t, adaptive_nhc.residual_hist, '-', 'Color', [0.30 0.30 0.30], 'LineWidth', 1.5);
ylabel(ax4, 'Residual (m)');

yyaxis(ax4, 'right');
plot(ax4, truth.t, adaptive_nhc.quality_hist, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.8);
hold(ax4, 'on');
plot(ax4, truth.t, adaptive_nhc.alpha_hist, '--', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.4);
ylabel(ax4, 'Quality / weight');
ylim(ax4, [0 1.05]);

xlabel(ax4, 'Time (s)');
lgd4 = legend(ax4, {'Residual', 'Estimated quality', 'Fusion weight'}, 'Location', 'best');
set(lgd4, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax4);
xlim(ax4, [truth.t(1) truth.t(end)]);
title(ax4, 'Residual-Driven Scheduling Context', 'Color', 'k');

fig2 = figure('Name', 'Adaptive Constraint RMSE', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [440 130 820 520]);
ax5 = axes(fig2, 'Color', 'w', 'XColor', 'k', 'YColor', 'k');

rmse_fixed = sqrt(mean(fixed_nhc.pos_err.^2));
rmse_adapt = sqrt(mean(adaptive_nhc.pos_err.^2));

bar(ax5, [rmse_fixed, rmse_adapt], 0.55, 'FaceColor', [0.30 0.58 0.82]);
xticks(ax5, [1 2]);
xticklabels(ax5, {'Fixed constraints', 'Adaptive constraints'});
ylabel(ax5, 'RMSE (m)');
title(ax5, 'RMSE Comparison of Constraint Scheduling Strategies', 'Color', 'k');
apply_paper_axes_style(ax5);
