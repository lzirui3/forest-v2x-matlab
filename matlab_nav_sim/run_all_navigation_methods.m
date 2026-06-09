function results = run_all_navigation_methods()
%RUN_ALL_NAVIGATION_METHODS Run all current navigation methods on one scenario.

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

err_gnss = sqrt((gnss.x - truth.x).^2 + (gnss.y - truth.y).^2);

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

fusion_res_params.dt = params.dt;
fusion_res_params.alpha_max = 0.25;
fusion_res_params.alpha_valid_min = 0.015;
fusion_res_params.zupt_velocity_gain = 0.15;
fusion_res_params.zupt_velocity_snap_threshold = 0.02;
fusion_res_params.residual_good_threshold = 1.2;
fusion_res_params.residual_bad_threshold = 4.5;
fusion_res_params.outlier_reject_threshold = 10.0;
fusion_res_params.residual_ema_decay = 0.92;
fusion_res_params.quality_smoothing = 0.92;
fusion_res_params.initial_quality = 0.9;
fusion_res_params.initial_residual_ema = 0.6;
fusion_res_params.residual_growth_no_gnss = 0.05;
fusion_res_params.quality_decay_no_gnss = 0.96;
fusion_res_params.max_position_correction = 0.12;
fusion_residual = run_gnss_imu_fusion_residual_adaptive(truth, gnss, imu, fusion_res_params);

fusion_nhc_params = fusion_res_params;
fusion_nhc_params.nhc_speed_threshold = 0.15;
fusion_nhc_params.nhc_eps_speed = 0.05;
fusion_nhc_params.nhc_velocity_gain = 0.90;
fusion_nhc_params.nhc_heading_gain = 0.10;
fusion_nhc_params.enable_nhc = true;
fusion_nhc = run_gnss_imu_fusion_body_velocity(truth, gnss, imu, fusion_nhc_params);

results.truth = truth;
results.gnss = gnss;
results.imu = imu;
results.methods(1).name = 'GNSS only';
results.methods(1).err = err_gnss;
results.methods(2).name = 'IMU DR';
results.methods(2).err = dr.pos_err;
results.methods(3).name = 'Baseline fusion';
results.methods(3).err = fusion_base.pos_err;
results.methods(4).name = 'Label-adaptive + ZUPT';
results.methods(4).err = fusion_adapt.pos_err;
results.methods(5).name = 'Residual-adaptive';
results.methods(5).err = fusion_residual.pos_err;
results.methods(6).name = 'Residual-adaptive + NHC';
results.methods(6).err = fusion_nhc.pos_err;
