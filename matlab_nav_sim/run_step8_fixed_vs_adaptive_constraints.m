function results = run_step8_fixed_vs_adaptive_constraints()
%RUN_STEP8_FIXED_VS_ADAPTIVE_CONSTRAINTS Run fixed vs adaptive constraint scheduling comparison.

sim_params.dt = 0.02;
sim_params.T_total = 60.0;

truth = make_truth_trajectory(sim_params);

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

fixed_params = get_default_fusion_nhc_params(sim_params.dt);
fixed_params.enable_nhc = true;
fixed_nhc = run_gnss_imu_fusion_body_velocity(truth, gnss, imu, fixed_params);

adaptive_params = get_default_adaptive_constraint_params(sim_params.dt);
adaptive_nhc = run_gnss_imu_fusion_body_velocity_adaptive_constraints(truth, gnss, imu, adaptive_params);

results.truth = truth;
results.fixed_nhc = fixed_nhc;
results.adaptive_nhc = adaptive_nhc;
