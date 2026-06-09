function plot_gnss(truth, gnss)
%PLOT_GNSS Plot GNSS measurements and the GNSS status timeline.

figure('Name', 'GNSS vs Ground Truth', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [200 120 760 520]);
ax1 = axes('Color', 'w', 'XColor', 'k', 'YColor', 'k');
plot(ax1, truth.x, truth.y, '-', 'Color', [0.10 0.10 0.10], 'LineWidth', 1.8);
hold(ax1, 'on');

idx_normal = (gnss.status == 0);
idx_degraded = (gnss.status == 1);
idx_outage = (gnss.status == 2);

plot(ax1, gnss.x(idx_normal), gnss.y(idx_normal), 'o', ...
    'Color', [0.00 0.45 0.74], 'MarkerSize', 3.5, 'LineWidth', 0.8, ...
    'MarkerFaceColor', [0.00 0.45 0.74]);
plot(ax1, gnss.x(idx_degraded), gnss.y(idx_degraded), 'o', ...
    'Color', [0.85 0.33 0.10], 'MarkerSize', 3.5, 'LineWidth', 0.8, ...
    'MarkerFaceColor', [0.85 0.33 0.10]);
plot(ax1, truth.x(idx_outage), truth.y(idx_outage), 'x', ...
    'Color', [0.75 0.00 0.00], 'MarkerSize', 5, 'LineWidth', 1.0);

axis(ax1, 'equal');
xlabel(ax1, 'x (m)', 'Color', 'k');
ylabel(ax1, 'y (m)', 'Color', 'k');
title(ax1, 'Ground Truth and Simulated GNSS', 'Color', 'k');
lgd1 = legend(ax1, {'Truth', 'GNSS Normal', 'GNSS Degraded', 'GNSS Outage Segment'}, ...
    'TextColor', 'k', 'Location', 'best');
set(lgd1, 'Box', 'off', 'Color', 'none', 'FontName', 'Times New Roman', 'FontSize', 10);
apply_paper_axes_style(ax1);
drawnow;

figure('Name', 'GNSS Status Timeline', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [220 140 760 520]);
ax2 = axes('Color', 'w', 'XColor', 'k', 'YColor', 'k');
stairs(ax2, gnss.t, gnss.status, 'LineWidth', 1.6, 'Color', [0.49 0.18 0.56]);
xlabel(ax2, 'Time (s)', 'Color', 'k');
ylabel(ax2, 'GNSS Status', 'Color', 'k');
title(ax2, 'GNSS State Timeline', 'Color', 'k');
yticks(ax2, [0 1 2]);
yticklabels(ax2, {'Normal', 'Degraded', 'Outage'});
ylim(ax2, [-0.2 2.2]);
xlim(ax2, [gnss.t(1) gnss.t(end)]);
apply_paper_axes_style(ax2);
drawnow;

figure('Name', 'GNSS Position Error', 'Color', 'w', 'Renderer', 'painters', ...
    'InvertHardcopy', 'off', 'Units', 'pixels', 'Position', [240 160 760 520]);
ax3 = axes('Color', 'w', 'XColor', 'k', 'YColor', 'k');
err = sqrt((gnss.x - truth.x).^2 + (gnss.y - truth.y).^2);
plot(ax3, gnss.t, err, '-', 'Color', [0.00 0.32 0.64], 'LineWidth', 1.8);
xlabel(ax3, 'Time (s)', 'Color', 'k');
ylabel(ax3, 'Position Error (m)', 'Color', 'k');
title(ax3, 'Simulated GNSS Position Error', 'Color', 'k');
xlim(ax3, [gnss.t(1) gnss.t(end)]);
valid_err = err(~isnan(err));
if ~isempty(valid_err)
    ylim(ax3, [0, 1.1 * max(valid_err)]);
end
apply_paper_axes_style(ax3);
drawnow;
