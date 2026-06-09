clc;
clear;
close all;

% Step 2:
% Add the IMU layer and observe open-loop inertial drift.

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

params.dt = 0.02;
params.T_total = 60.0;

truth = make_truth_trajectory(params);
plot_truth(truth);

gnss_params.sigma_normal = 0.5;
gnss_params.sigma_degraded = 3.0;
gnss_params.bias_x = 2.0;
gnss_params.bias_y = -1.5;
gnss = simulate_gnss(truth, gnss_params);
plot_gnss(truth, gnss);

imu_params.sigma_ax = 0.03;                 % m/s^2
imu_params.sigma_ay = 0.04;                 % m/s^2
imu_params.sigma_wz = deg2rad(0.15);        % rad/s
imu_params.bias_ax = 0.015;                 % m/s^2
imu_params.bias_ay = -0.020;                % m/s^2
imu_params.bias_wz = deg2rad(0.08);         % rad/s
imu_params.stationary_speed_threshold = 0.03;
imu = simulate_imu(truth, imu_params);

dr_params.dt = params.dt;
dr = run_imu_dead_reckoning(truth, imu, dr_params);
plot_imu(truth, imu, dr);

disp('Step 2 complete: IMU layer and open-loop dead reckoning generated.');
