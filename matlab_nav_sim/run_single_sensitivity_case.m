function result = run_single_sensitivity_case(param_name, param_value)
%RUN_SINGLE_SENSITIVITY_CASE Run one sensitivity case for residual-adaptive + NHC method.

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

fusion_params = get_default_fusion_nhc_params(sim_params.dt);
fusion_params.(param_name) = param_value;

fusion = run_gnss_imu_fusion_body_velocity(truth, gnss, imu, fusion_params);

stages = define_stage_masks(truth.t);
metrics = compute_stage_metrics(fusion.pos_err, stages);

result.param_name = string(param_name);
result.param_value = param_value;
result.metrics = metrics;
result.full_rmse = get_stage_metric(metrics, 'Full', 'rmse');
result.degraded_rmse = get_stage_metric(metrics, 'Degraded', 'rmse');
result.outage_rmse = get_stage_metric(metrics, 'Outage', 'rmse');
result.recovery_rmse = get_stage_metric(metrics, 'Recovery', 'rmse');

function value = get_stage_metric(metrics, stage_name, field_name)
value = NaN;
for ii = 1:numel(metrics)
    if strcmp(metrics(ii).stage, stage_name)
        value = metrics(ii).(field_name);
        return;
    end
end
end
end
