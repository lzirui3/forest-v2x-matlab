function fusion = run_gnss_imu_fusion_body_velocity(truth, gnss, imu, params)
%RUN_GNSS_IMU_FUSION_BODY_VELOCITY Residual-adaptive fusion with body-velocity states.
%
% States:
% x, y   : position in navigation frame
% yaw    : heading
% vx, vy : body-frame longitudinal and lateral velocity
%
% Optional mechanism:
% If params.enable_nhc is true, apply a simplified nonholonomic constraint
% to suppress lateral drift on a ground vehicle.

if ~isfield(params, 'enable_nhc')
    params.enable_nhc = false;
end

t = truth.t;
dt = params.dt;
N = numel(t);

x_est = zeros(N, 1);
y_est = zeros(N, 1);
yaw_est = zeros(N, 1);
vx_est = zeros(N, 1);
vy_est = zeros(N, 1);
speed_est = zeros(N, 1);

alpha_hist = zeros(N, 1);
quality_hist = zeros(N, 1);
residual_hist = nan(N, 1);
nhc_active = false(N, 1);

residual_ema = params.initial_residual_ema;

x_est(1) = truth.x(1);
y_est(1) = truth.y(1);
yaw_est(1) = truth.yaw(1);
vx_est(1) = truth.v(1);
vy_est(1) = 0.0;
speed_est(1) = truth.v(1);
quality_hist(1) = params.initial_quality;
alpha_hist(1) = params.alpha_valid_min;
residual_hist(1) = residual_ema;

for k = 2:N
    wz = imu.wz(k - 1);
    ax = imu.ax(k - 1);
    ay = imu.ay(k - 1);

    yaw_pred = yaw_est(k - 1) + wz * dt;

    % Planar body-frame velocity propagation.
    vx_pred = vx_est(k - 1) + (ax + wz * vy_est(k - 1)) * dt;
    vy_pred = vy_est(k - 1) + (ay - wz * vx_est(k - 1)) * dt;

    % Zero-velocity update around stop periods.
    if imu.stationary_flag(k)
        vx_pred = params.zupt_velocity_gain * vx_pred;
        vy_pred = params.zupt_velocity_gain * vy_pred;

        if abs(vx_pred) < params.zupt_velocity_snap_threshold
            vx_pred = 0.0;
        end
        if abs(vy_pred) < params.zupt_velocity_snap_threshold
            vy_pred = 0.0;
        end
    end

    % Simplified NHC: suppress lateral velocity and gently align heading.
    if params.enable_nhc && ~imu.stationary_flag(k) && abs(vx_pred) > params.nhc_speed_threshold
        heading_slip = atan2(vy_pred, max(abs(vx_pred), params.nhc_eps_speed));
        yaw_pred = yaw_pred - params.nhc_heading_gain * heading_slip;
        vy_pred = (1 - params.nhc_velocity_gain) * vy_pred;
        nhc_active(k) = true;
    end

    vn_x = cos(yaw_pred) * vx_pred - sin(yaw_pred) * vy_pred;
    vn_y = sin(yaw_pred) * vx_pred + cos(yaw_pred) * vy_pred;

    x_pred = x_est(k - 1) + vn_x * dt;
    y_pred = y_est(k - 1) + vn_y * dt;

    valid_gnss = ~isnan(gnss.x(k)) && ~isnan(gnss.y(k));
    use_gnss_update = false;

    if valid_gnss
        residual_inst = hypot(gnss.x(k) - x_pred, gnss.y(k) - y_pred);
        residual_ema = params.residual_ema_decay * residual_ema + ...
            (1 - params.residual_ema_decay) * residual_inst;
        residual_hist(k) = residual_ema;

        if residual_ema <= params.residual_good_threshold
            quality_target = 1.0;
        elseif residual_ema >= params.residual_bad_threshold
            quality_target = 0.0;
        else
            quality_target = 1.0 - ...
                (residual_ema - params.residual_good_threshold) / ...
                (params.residual_bad_threshold - params.residual_good_threshold);
        end

        quality = params.quality_smoothing * quality_hist(k - 1) + ...
            (1 - params.quality_smoothing) * quality_target;

        if residual_inst <= params.outlier_reject_threshold
            use_gnss_update = true;
        end
    else
        residual_ema = min(params.residual_bad_threshold, ...
            residual_ema + params.residual_growth_no_gnss);
        residual_hist(k) = residual_ema;
        quality = params.quality_decay_no_gnss * quality_hist(k - 1);
    end

    quality = min(max(quality, 0.0), 1.0);
    quality_hist(k) = quality;

    if valid_gnss
        alpha = params.alpha_valid_min + ...
            (params.alpha_max - params.alpha_valid_min) * quality;
    else
        alpha = 0.0;
    end
    alpha_hist(k) = alpha;

    if valid_gnss && use_gnss_update
        corr_x = alpha * (gnss.x(k) - x_pred);
        corr_y = alpha * (gnss.y(k) - y_pred);
        corr_norm = hypot(corr_x, corr_y);

        if corr_norm > params.max_position_correction
            corr_scale = params.max_position_correction / corr_norm;
            corr_x = corr_x * corr_scale;
            corr_y = corr_y * corr_scale;
        end

        x_est(k) = x_pred + corr_x;
        y_est(k) = y_pred + corr_y;
    else
        x_est(k) = x_pred;
        y_est(k) = y_pred;
    end

    yaw_est(k) = yaw_pred;
    vx_est(k) = vx_pred;
    vy_est(k) = vy_pred;
    speed_est(k) = hypot(vx_pred, vy_pred);
end

pos_err = sqrt((x_est - truth.x).^2 + (y_est - truth.y).^2);

fusion.t = t;
fusion.x = x_est;
fusion.y = y_est;
fusion.yaw = yaw_est;
fusion.vx = vx_est;
fusion.vy = vy_est;
fusion.speed = speed_est;
fusion.pos_err = pos_err;
fusion.alpha_hist = alpha_hist;
fusion.quality_hist = quality_hist;
fusion.residual_hist = residual_hist;
fusion.nhc_active = nhc_active;
