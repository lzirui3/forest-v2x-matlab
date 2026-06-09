function plot_fusion_results(truth, gnss, dr, fusion)
%PLOT_FUSION_RESULTS Compare GNSS, IMU dead reckoning, and fused trajectory.

fig1 = figure('Name', 'Fusion Trajectory Comparison', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [340 120 860 720]);
tlo1 = tiledlayout(fig1, 2, 1, 'TileSpacing', 'loose', 'Padding', 'loose');
sgtitle(fig1, 'GNSS/IMU Fusion Baseline Comparison', 'FontName', 'Times New Roman', ...
    'FontSize', 14, 'FontWeight', 'normal', 'Color', 'k');

ax1 = nexttile(tlo1);
plot(ax1, truth.x, truth.y, '-', 'Color', [0.10 0.10 0.10], 'LineWidth', 1.8);
hold(ax1, 'on');
plot(ax1, gnss.x, gnss.y, '.', 'Color', [0.75 0.75 0.75], 'MarkerSize', 5);
plot(ax1, dr.x, dr.y, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.2);
plot(ax1, fusion.x, fusion.y, '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.8);
axis(ax1, 'equal');
xlabel(ax1, 'x (m)');
ylabel(ax1, 'y (m)');
lgd1 = legend(ax1, {'Truth', 'GNSS', 'IMU dead reckoning', 'Fused'}, 'Location', 'best');
set(lgd1, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax1);

ax2 = nexttile(tlo1);
err_gnss = sqrt((gnss.x - truth.x).^2 + (gnss.y - truth.y).^2);
plot(ax2, truth.t, err_gnss, '-', 'Color', [0.60 0.60 0.60], 'LineWidth', 1.4);
hold(ax2, 'on');
plot(ax2, dr.t, dr.pos_err, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.4);
plot(ax2, fusion.t, fusion.pos_err, '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.8);
xlabel(ax2, 'Time (s)');
ylabel(ax2, 'Position error (m)');
lgd2 = legend(ax2, {'GNSS', 'IMU dead reckoning', 'Fused'}, 'Location', 'northwest');
set(lgd2, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax2);
xlim(ax2, [truth.t(1) truth.t(end)]);

fig2 = figure('Name', 'Fusion Error Statistics', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [380 140 780 520]);
ax3 = axes(fig2, 'Color', 'w', 'XColor', 'k', 'YColor', 'k');

rmse_gnss = sqrt(mean(err_gnss(~isnan(err_gnss)).^2));
rmse_dr = sqrt(mean(dr.pos_err.^2));
rmse_fusion = sqrt(mean(fusion.pos_err.^2));

bar(ax3, [rmse_gnss, rmse_dr, rmse_fusion], 0.55, 'FaceColor', [0.30 0.55 0.80]);
xticks(ax3, [1 2 3]);
xticklabels(ax3, {'GNSS', 'IMU DR', 'Fusion'});
ylabel(ax3, 'RMSE (m)');
title(ax3, 'Position RMSE Comparison', 'Color', 'k');
apply_paper_axes_style(ax3);
