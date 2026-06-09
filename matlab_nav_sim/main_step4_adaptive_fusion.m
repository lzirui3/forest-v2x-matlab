clc;
clear;
close all;

% Step 4:
% Add adaptive GNSS weighting and zero-velocity update.

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

gnss_params.sigma_normal = 0.5;
gnss_params.sigma_degraded = 3.0;
gnss_params.bias_x = 2.0;
gnss_params.bias_y = -1.5;
gnss = simulate_gnss(truth, gnss_params);

imu_params.sigma_ax = 0.03;
imu_params.sigma_ay = 0.04;
imu_params.sigma_wz = deg2rad(0.15);
imu_params.bias_ax = 0.015;
imu_params.bias_ay = -0.020;
imu_params.bias_wz = deg2rad(0.08);
imu_params.stationary_speed_threshold = 0.03;
imu = simulate_imu(truth, imu_params);

dr_params.dt = params.dt;
dr = run_imu_dead_reckoning(truth, imu, dr_params);

fusion_base_params.dt = params.dt;
fusion_base_params.alpha_normal = 0.20;
fusion_base_params.alpha_degraded = 0.04;
fusion_base = run_gnss_imu_fusion(truth, gnss, imu, fusion_base_params);

fusion_adapt_params.dt = params.dt;
fusion_adapt_params.alpha_min = 0.00;
fusion_adapt_params.alpha_max = 0.25;
fusion_adapt_params.zupt_velocity_gain = 0.15;
fusion_adapt_params.zupt_velocity_snap_threshold = 0.02;
fusion_adapt_params.quality_params.quality_normal = 0.95;
fusion_adapt_params.quality_params.quality_degraded = 0.18;
fusion_adapt = run_gnss_imu_fusion_adaptive(truth, gnss, imu, fusion_adapt_params);

plot_fusion_adaptive_results(truth, gnss, dr, fusion_base, fusion_adapt, imu);

disp('Step 4 complete: adaptive GNSS/IMU fusion with ZUPT generated.');
