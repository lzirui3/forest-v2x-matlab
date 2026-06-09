function fusion = run_gnss_imu_fusion_adaptive(truth, gnss, imu, params)
%RUN_GNSS_IMU_FUSION_ADAPTIVE Enhanced fusion with adaptive GNSS weighting and ZUPT.

t = truth.t;
dt = params.dt;
N = numel(t);

gnss_quality = estimate_gnss_quality(gnss, params.quality_params);

x_est = zeros(N, 1);
y_est = zeros(N, 1);
yaw_est = zeros(N, 1);
v_est = zeros(N, 1);
alpha_hist = zeros(N, 1);

x_est(1) = truth.x(1);
y_est(1) = truth.y(1);
yaw_est(1) = truth.yaw(1);
v_est(1) = truth.v(1);

for k = 2:N
    yaw_pred = yaw_est(k - 1) + imu.wz(k - 1) * dt;
    v_pred = v_est(k - 1) + imu.ax(k - 1) * dt;

    % Zero-velocity update during detected stationary periods.
    if imu.stationary_flag(k)
        v_pred = params.zupt_velocity_gain * v_pred;
        if abs(v_pred) < params.zupt_velocity_snap_threshold
            v_pred = 0.0;
        end
    end

    x_pred = x_est(k - 1) + v_est(k - 1) * cos(yaw_est(k - 1)) * dt;
    y_pred = y_est(k - 1) + v_est(k - 1) * sin(yaw_est(k - 1)) * dt;

    alpha = params.alpha_min + (params.alpha_max - params.alpha_min) * gnss_quality(k);
    alpha_hist(k) = alpha;

    if ~isnan(gnss.x(k)) && ~isnan(gnss.y(k))
        x_est(k) = (1 - alpha) * x_pred + alpha * gnss.x(k);
        y_est(k) = (1 - alpha) * y_pred + alpha * gnss.y(k);
    else
        x_est(k) = x_pred;
        y_est(k) = y_pred;
    end

    yaw_est(k) = yaw_pred;
    v_est(k) = v_pred;
end

pos_err = sqrt((x_est - truth.x).^2 + (y_est - truth.y).^2);

fusion.t = t;
fusion.x = x_est;
fusion.y = y_est;
fusion.yaw = yaw_est;
fusion.v = v_est;
fusion.pos_err = pos_err;
fusion.alpha_hist = alpha_hist;
fusion.gnss_quality = gnss_quality;
