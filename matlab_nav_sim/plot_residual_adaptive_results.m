function plot_residual_adaptive_results(truth, dr, fusion_base, fusion_adapt, fusion_residual, imu)
%PLOT_RESIDUAL_ADAPTIVE_RESULTS Compare baseline, label-adaptive and residual-adaptive fusion.

fig1 = figure('Name', 'Residual Adaptive Fusion Comparison', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [380 100 940 860]);
tlo1 = tiledlayout(fig1, 3, 1, 'TileSpacing', 'loose', 'Padding', 'loose');
sgtitle(fig1, 'Residual-Based Adaptive Fusion Comparison', 'FontName', 'Times New Roman', ...
    'FontSize', 14, 'FontWeight', 'normal', 'Color', 'k');

ax1 = nexttile(tlo1);
plot(ax1, truth.x, truth.y, '-', 'Color', [0.10 0.10 0.10], 'LineWidth', 1.8);
hold(ax1, 'on');
plot(ax1, fusion_base.x, fusion_base.y, '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.4);
plot(ax1, fusion_adapt.x, fusion_adapt.y, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.4);
plot(ax1, fusion_residual.x, fusion_residual.y, '-', 'Color', [0.20 0.60 0.20], 'LineWidth', 1.8);
axis(ax1, 'equal');
xlabel(ax1, 'x (m)');
ylabel(ax1, 'y (m)');
lgd1 = legend(ax1, {'Truth', 'Baseline', 'Label-adaptive', 'Residual-adaptive'}, 'Location', 'best');
set(lgd1, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax1);

ax2 = nexttile(tlo1);
plot(ax2, truth.t, dr.pos_err, '-', 'Color', [0.75 0.75 0.75], 'LineWidth', 1.2);
hold(ax2, 'on');
plot(ax2, truth.t, fusion_base.pos_err, '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.4);
plot(ax2, truth.t, fusion_adapt.pos_err, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.4);
plot(ax2, truth.t, fusion_residual.pos_err, '-', 'Color', [0.20 0.60 0.20], 'LineWidth', 1.8);
xlabel(ax2, 'Time (s)');
ylabel(ax2, 'Position error (m)');
lgd2 = legend(ax2, {'IMU DR', 'Baseline', 'Label-adaptive', 'Residual-adaptive'}, 'Location', 'northwest');
set(lgd2, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax2);
xlim(ax2, [truth.t(1) truth.t(end)]);

ax3 = nexttile(tlo1);
yyaxis(ax3, 'left');
plot(ax3, truth.t, fusion_residual.residual_hist, '-', 'Color', [0.49 0.18 0.56], 'LineWidth', 1.6);
ylabel(ax3, 'GNSS residual (m)');

yyaxis(ax3, 'right');
plot(ax3, truth.t, fusion_residual.quality_hist, '-', 'Color', [0.20 0.60 0.20], 'LineWidth', 1.8);
hold(ax3, 'on');
plot(ax3, truth.t, fusion_residual.alpha_hist, '--', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.4);
stairs(ax3, truth.t, double(imu.stationary_flag), ':', 'Color', [0.75 0.00 0.00], 'LineWidth', 1.2);
ylabel(ax3, 'Quality / weight / ZUPT');
ylim(ax3, [0 1.05]);

xlabel(ax3, 'Time (s)');
lgd3 = legend(ax3, {'Residual', 'Estimated quality', 'Adaptive weight', 'Stationary flag'}, 'Location', 'best');
set(lgd3, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax3);
xlim(ax3, [truth.t(1) truth.t(end)]);
title(ax3, 'Residual-Driven Adaptive Signals', 'Color', 'k');

fig2 = figure('Name', 'Residual Adaptive Fusion RMSE', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [440 140 860 520]);
ax4 = axes(fig2, 'Color', 'w', 'XColor', 'k', 'YColor', 'k');

rmse_dr = sqrt(mean(dr.pos_err.^2));
rmse_base = sqrt(mean(fusion_base.pos_err.^2));
rmse_adapt = sqrt(mean(fusion_adapt.pos_err.^2));
rmse_residual = sqrt(mean(fusion_residual.pos_err.^2));

bar(ax4, [rmse_dr, rmse_base, rmse_adapt, rmse_residual], 0.55, 'FaceColor', [0.30 0.58 0.82]);
xticks(ax4, [1 2 3 4]);
xticklabels(ax4, {'IMU DR', 'Baseline', 'Label-Adaptive', 'Residual-Adaptive'});
ylabel(ax4, 'RMSE (m)');
title(ax4, 'RMSE Comparison of Adaptive Strategies', 'Color', 'k');
apply_paper_axes_style(ax4);
