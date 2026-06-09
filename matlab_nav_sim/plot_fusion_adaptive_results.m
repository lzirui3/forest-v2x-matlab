function plot_fusion_adaptive_results(truth, gnss, dr, fusion_base, fusion_adapt, imu)
%PLOT_FUSION_ADAPTIVE_RESULTS Compare baseline and adaptive fusion.

fig1 = figure('Name', 'Adaptive Fusion Comparison', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [360 120 920 820]);
tlo1 = tiledlayout(fig1, 3, 1, 'TileSpacing', 'loose', 'Padding', 'loose');
sgtitle(fig1, 'Baseline vs Adaptive GNSS/IMU Fusion', 'FontName', 'Times New Roman', ...
    'FontSize', 14, 'FontWeight', 'normal', 'Color', 'k');

ax1 = nexttile(tlo1);
plot(ax1, truth.x, truth.y, '-', 'Color', [0.10 0.10 0.10], 'LineWidth', 1.8);
hold(ax1, 'on');
plot(ax1, dr.x, dr.y, '-', 'Color', [0.70 0.70 0.70], 'LineWidth', 1.0);
plot(ax1, fusion_base.x, fusion_base.y, '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.6);
plot(ax1, fusion_adapt.x, fusion_adapt.y, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.8);
axis(ax1, 'equal');
xlabel(ax1, 'x (m)');
ylabel(ax1, 'y (m)');
lgd1 = legend(ax1, {'Truth', 'IMU DR', 'Baseline fusion', 'Adaptive + ZUPT'}, 'Location', 'best');
set(lgd1, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax1);

ax2 = nexttile(tlo1);
plot(ax2, truth.t, dr.pos_err, '-', 'Color', [0.70 0.70 0.70], 'LineWidth', 1.2);
hold(ax2, 'on');
plot(ax2, truth.t, fusion_base.pos_err, '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.6);
plot(ax2, truth.t, fusion_adapt.pos_err, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.8);
xlabel(ax2, 'Time (s)');
ylabel(ax2, 'Position error (m)');
lgd2 = legend(ax2, {'IMU DR', 'Baseline fusion', 'Adaptive + ZUPT'}, 'Location', 'northwest');
set(lgd2, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax2);
xlim(ax2, [truth.t(1) truth.t(end)]);

ax3 = nexttile(tlo1);
yyaxis(ax3, 'left');
plot(ax3, truth.t, fusion_adapt.gnss_quality, '-', 'Color', [0.49 0.18 0.56], 'LineWidth', 1.8);
ylabel(ax3, 'GNSS quality');
ylim(ax3, [0 1.05]);

yyaxis(ax3, 'right');
plot(ax3, truth.t, fusion_adapt.alpha_hist, '-', 'Color', [0.20 0.60 0.20], 'LineWidth', 1.6);
hold(ax3, 'on');
stairs(ax3, truth.t, double(imu.stationary_flag), '--', 'Color', [0.75 0.00 0.00], 'LineWidth', 1.2);
ylabel(ax3, 'Fusion weight / ZUPT flag');
ylim(ax3, [0 1.05]);

xlabel(ax3, 'Time (s)');
lgd3 = legend(ax3, {'GNSS quality', 'Adaptive weight', 'Stationary flag'}, 'Location', 'best');
set(lgd3, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax3);
xlim(ax3, [truth.t(1) truth.t(end)]);
title(ax3, 'Adaptive Mechanism Signals', 'Color', 'k');

fig2 = figure('Name', 'Adaptive Fusion RMSE', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [420 160 820 520]);
ax4 = axes(fig2, 'Color', 'w', 'XColor', 'k', 'YColor', 'k');

rmse_dr = sqrt(mean(dr.pos_err.^2));
rmse_base = sqrt(mean(fusion_base.pos_err.^2));
rmse_adapt = sqrt(mean(fusion_adapt.pos_err.^2));

bar(ax4, [rmse_dr, rmse_base, rmse_adapt], 0.55, 'FaceColor', [0.25 0.55 0.82]);
xticks(ax4, [1 2 3]);
xticklabels(ax4, {'IMU DR', 'Baseline', 'Adaptive'});
ylabel(ax4, 'RMSE (m)');
title(ax4, 'RMSE Comparison of Fusion Strategies', 'Color', 'k');
apply_paper_axes_style(ax4);
