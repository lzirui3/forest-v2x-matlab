function plot_imu(truth, imu, dr)
%PLOT_IMU Plot IMU channels and open-loop dead-reckoning behavior.

fig1 = figure('Name', 'IMU Measurements', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [260 100 860 760]);
tlo1 = tiledlayout(fig1, 3, 1, 'TileSpacing', 'loose', 'Padding', 'loose');
sgtitle(fig1, 'Simulated IMU Measurements', 'FontName', 'Times New Roman', ...
    'FontSize', 14, 'FontWeight', 'normal', 'Color', 'k');

ax1 = nexttile(tlo1);
plot(ax1, imu.t, imu.ax_true, '-', 'Color', [0.10 0.10 0.10], 'LineWidth', 1.6);
hold(ax1, 'on');
plot(ax1, imu.t, imu.ax, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.0);
ylabel(ax1, 'a_x (m/s^2)');
lgd1 = legend(ax1, {'True', 'Measured'}, 'Location', 'best');
set(lgd1, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax1);
xlim(ax1, [imu.t(1) imu.t(end)]);

ax2 = nexttile(tlo1);
plot(ax2, imu.t, imu.ay_true, '-', 'Color', [0.10 0.10 0.10], 'LineWidth', 1.6);
hold(ax2, 'on');
plot(ax2, imu.t, imu.ay, '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 1.0);
ylabel(ax2, 'a_y (m/s^2)');
lgd2 = legend(ax2, {'True', 'Measured'}, 'Location', 'best');
set(lgd2, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax2);
xlim(ax2, [imu.t(1) imu.t(end)]);

ax3 = nexttile(tlo1);
plot(ax3, imu.t, rad2deg(imu.wz_true), '-', 'Color', [0.10 0.10 0.10], 'LineWidth', 1.6);
hold(ax3, 'on');
plot(ax3, imu.t, rad2deg(imu.wz), '-', 'Color', [0.49 0.18 0.56], 'LineWidth', 1.0);
xlabel(ax3, 'Time (s)');
ylabel(ax3, '\omega_z (deg/s)');
lgd3 = legend(ax3, {'True', 'Measured'}, 'Location', 'best');
set(lgd3, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax3);
xlim(ax3, [imu.t(1) imu.t(end)]);

fig2 = figure('Name', 'IMU Dead Reckoning', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [300 120 860 720]);
tlo2 = tiledlayout(fig2, 2, 1, 'TileSpacing', 'loose', 'Padding', 'loose');
sgtitle(fig2, 'Open-Loop IMU Dead-Reckoning Drift', 'FontName', 'Times New Roman', ...
    'FontSize', 14, 'FontWeight', 'normal', 'Color', 'k');

ax4 = nexttile(tlo2);
plot(ax4, truth.x, truth.y, '-', 'Color', [0.10 0.10 0.10], 'LineWidth', 1.8);
hold(ax4, 'on');
plot(ax4, dr.x, dr.y, '-', 'Color', [0.00 0.45 0.74], 'LineWidth', 1.4);
axis(ax4, 'equal');
xlabel(ax4, 'x (m)');
ylabel(ax4, 'y (m)');
lgd4 = legend(ax4, {'Truth', 'IMU dead reckoning'}, 'Location', 'best');
set(lgd4, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax4);
axis(ax4, 'tight');

ax5 = nexttile(tlo2);
plot(ax5, dr.t, dr.pos_err, '-', 'Color', [0.80 0.20 0.20], 'LineWidth', 1.8);
xlabel(ax5, 'Time (s)');
ylabel(ax5, 'Position error (m)');
apply_paper_axes_style(ax5);
xlim(ax5, [dr.t(1) dr.t(end)]);
