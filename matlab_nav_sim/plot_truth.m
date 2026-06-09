function plot_truth(truth)
%PLOT_TRUTH Plot the generated ground-truth trajectory and motion states.

figure('Name', 'Ground Truth Trajectory', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [120 120 760 520]);
ax1 = axes('Color', 'w', 'XColor', 'k', 'YColor', 'k');
plot(ax1, truth.x, truth.y, '-', 'Color', [0.00 0.32 0.64], 'LineWidth', 1.8);
axis(ax1, 'equal');
xlabel(ax1, 'x (m)', 'Color', 'k');
ylabel(ax1, 'y (m)', 'Color', 'k');
title(ax1, 'Ground-Truth 2D Trajectory', 'Color', 'k');
apply_paper_axes_style(ax1);
drawnow;

figure('Name', 'Ground Truth Speed', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [140 140 760 520]);
ax2 = axes('Color', 'w', 'XColor', 'k', 'YColor', 'k');
plot(ax2, truth.t, truth.v, '-', 'Color', [0.80 0.20 0.20], 'LineWidth', 1.8);
xlabel(ax2, 'Time (s)', 'Color', 'k');
ylabel(ax2, 'Speed v (m/s)', 'Color', 'k');
title(ax2, 'Ground-Truth Speed', 'Color', 'k');
ylim(ax2, [-0.05 1.05]);
xlim(ax2, [truth.t(1) truth.t(end)]);
apply_paper_axes_style(ax2);
drawnow;

figure('Name', 'Ground Truth Heading', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [160 160 760 520]);
ax3 = axes('Color', 'w', 'XColor', 'k', 'YColor', 'k');
plot(ax3, truth.t, rad2deg(truth.yaw), '-', 'Color', [0.10 0.10 0.10], 'LineWidth', 1.8);
xlabel(ax3, 'Time (s)', 'Color', 'k');
ylabel(ax3, 'Yaw (deg)', 'Color', 'k');
title(ax3, 'Ground-Truth Heading', 'Color', 'k');
ylim(ax3, [-5 65]);
xlim(ax3, [truth.t(1) truth.t(end)]);
apply_paper_axes_style(ax3);
drawnow;

figure('Name', 'Ground Truth Yaw Rate', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [180 180 760 520]);
ax4 = axes('Color', 'w', 'XColor', 'k', 'YColor', 'k');
plot(ax4, truth.t, rad2deg(truth.omega), '-', 'Color', [0.45 0.18 0.55], 'LineWidth', 1.8);
xlabel(ax4, 'Time (s)', 'Color', 'k');
ylabel(ax4, 'Yaw Rate (deg/s)', 'Color', 'k');
title(ax4, 'Ground-Truth Yaw Rate', 'Color', 'k');
xlim(ax4, [truth.t(1) truth.t(end)]);
apply_paper_axes_style(ax4);
drawnow;
