clc;
clear;
close all;

% Step 1:
% Build the ground-truth trajectory and the first sensor layer (GNSS).

% Force a more stable figure behavior on some MATLAB dark-theme setups.
set(groot, 'defaultFigureWindowStyle', 'normal');
opengl software;
set(groot, 'defaultFigureColor', 'w');
set(groot, 'defaultAxesColor', 'w');
set(groot, 'defaultAxesXColor', 'k');
set(groot, 'defaultAxesYColor', 'k');
set(groot, 'defaultAxesZColor', 'k');
set(groot, 'defaultAxesFontName', 'Times New Roman');
set(groot, 'defaultTextFontName', 'Times New Roman');
set(groot, 'defaultAxesFontSize', 11);
set(groot, 'defaultTextFontSize', 11);
set(groot, 'defaultAxesLineWidth', 1.0);
set(groot, 'defaultLineLineWidth', 1.6);
set(groot, 'defaultTextColor', 'k');
set(groot, 'defaultLegendTextColor', 'k');
set(groot, 'defaultColorBarColor', 'k');

params.dt = 0.02;       % 50 Hz simulation
params.T_total = 60.0;  % total time in seconds

truth = make_truth_trajectory(params);
plot_truth(truth);

gnss_params.sigma_normal = 0.5;   % m
gnss_params.sigma_degraded = 3.0; % m
gnss_params.bias_x = 2.0;         % m
gnss_params.bias_y = -1.5;        % m
gnss = simulate_gnss(truth, gnss_params);
plot_gnss(truth, gnss);

disp('Step 1 complete: ground-truth trajectory and GNSS layer generated.');
