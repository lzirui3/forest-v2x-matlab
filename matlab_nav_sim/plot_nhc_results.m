function plot_nhc_results(truth, dr, fusion_free, fusion_nhc)
%PLOT_NHC_RESULTS Compare residual-adaptive fusion with and without NHC.

fig1 = figure('Name', 'NHC Fusion Comparison', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [380 90 960 860]);
tlo1 = tiledlayout(fig1, 3, 1, 'TileSpacing', 'loose', 'Padding', 'loose');
sgtitle(fig1, 'Residual-Adaptive Fusion With and Without Ground-Motion Constraint', ...
    'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'normal', 'Color', 'k');

ax1 = nexttile(tlo1);
plot(ax1, truth.x, truth.y, '-', 'Color', [0.10 0.10 0.10], 'LineWidth', 1.8);
hold(ax1, 'on');
plot(ax1, fusion_free.x, fusion_free.y, '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.5);
plot(ax1, fusion_nhc.x, fusion_nhc.y, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.8);
axis(ax1, 'equal');
xlabel(ax1, 'x (m)');
ylabel(ax1, 'y (m)');
lgd1 = legend(ax1, {'Truth', 'Residual-adaptive', 'Residual-adaptive + NHC'}, 'Location', 'best');
set(lgd1, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax1);

ax2 = nexttile(tlo1);
plot(ax2, dr.t, dr.pos_err, '-', 'Color', [0.75 0.75 0.75], 'LineWidth', 1.2);
hold(ax2, 'on');
plot(ax2, fusion_free.t, fusion_free.pos_err, '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.5);
plot(ax2, fusion_nhc.t, fusion_nhc.pos_err, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.8);
xlabel(ax2, 'Time (s)');
ylabel(ax2, 'Position error (m)');
lgd2 = legend(ax2, {'IMU DR', 'Residual-adaptive', 'Residual-adaptive + NHC'}, 'Location', 'northwest');
set(lgd2, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax2);
xlim(ax2, [truth.t(1) truth.t(end)]);

ax3 = nexttile(tlo1);
yyaxis(ax3, 'left');
plot(ax3, truth.t, fusion_free.vy, '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.2);
hold(ax3, 'on');
plot(ax3, truth.t, fusion_nhc.vy, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.6);
ylabel(ax3, 'Estimated lateral velocity v_y (m/s)');

yyaxis(ax3, 'right');
plot(ax3, truth.t, fusion_nhc.quality_hist, '--', 'Color', [0.20 0.60 0.20], 'LineWidth', 1.4);
stairs(ax3, truth.t, double(fusion_nhc.nhc_active), ':', 'Color', [0.75 0.00 0.00], 'LineWidth', 1.2);
ylabel(ax3, 'Quality / NHC flag');
ylim(ax3, [0 1.05]);

xlabel(ax3, 'Time (s)');
lgd3 = legend(ax3, {'v_y without NHC', 'v_y with NHC', 'Estimated quality', 'NHC active'}, ...
    'Location', 'best');
set(lgd3, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax3);
xlim(ax3, [truth.t(1) truth.t(end)]);
title(ax3, 'Constraint Effect on Lateral Drift', 'Color', 'k');

fig2 = figure('Name', 'NHC RMSE Comparison', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [460 150 820 520]);
ax4 = axes(fig2, 'Color', 'w', 'XColor', 'k', 'YColor', 'k');

rmse_dr = sqrt(mean(dr.pos_err.^2));
rmse_free = sqrt(mean(fusion_free.pos_err.^2));
rmse_nhc = sqrt(mean(fusion_nhc.pos_err.^2));

bar(ax4, [rmse_dr, rmse_free, rmse_nhc], 0.55, 'FaceColor', [0.30 0.58 0.82]);
xticks(ax4, [1 2 3]);
xticklabels(ax4, {'IMU DR', 'Residual-Adaptive', 'Residual+NHC'});
ylabel(ax4, 'RMSE (m)');
title(ax4, 'RMSE Comparison With Ground-Motion Constraint', 'Color', 'k');
apply_paper_axes_style(ax4);
