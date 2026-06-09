clc;
clear;
close all;

% Step 6:
% Add a simplified nonholonomic ground-motion constraint (NHC style).

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

fusion_params.dt = params.dt;
fusion_params.alpha_max = 0.25;
fusion_params.alpha_valid_min = 0.015;
fusion_params.zupt_velocity_gain = 0.15;
fusion_params.zupt_velocity_snap_threshold = 0.02;
fusion_params.residual_good_threshold = 1.2;
fusion_params.residual_bad_threshold = 4.5;
fusion_params.outlier_reject_threshold = 10.0;
fusion_params.residual_ema_decay = 0.92;
fusion_params.quality_smoothing = 0.92;
fusion_params.initial_quality = 0.9;
fusion_params.initial_residual_ema = 0.6;
fusion_params.residual_growth_no_gnss = 0.05;
fusion_params.quality_decay_no_gnss = 0.96;
fusion_params.max_position_correction = 0.12;
fusion_params.nhc_speed_threshold = 0.15;
fusion_params.nhc_eps_speed = 0.05;
fusion_params.nhc_velocity_gain = 0.90;
fusion_params.nhc_heading_gain = 0.10;

fusion_params.enable_nhc = false;
fusion_free = run_gnss_imu_fusion_body_velocity(truth, gnss, imu, fusion_params);

fusion_params.enable_nhc = true;
fusion_nhc = run_gnss_imu_fusion_body_velocity(truth, gnss, imu, fusion_params);

plot_nhc_results(truth, dr, fusion_free, fusion_nhc);

disp('Step 6 complete: simplified ground-motion constraint fusion generated.');
