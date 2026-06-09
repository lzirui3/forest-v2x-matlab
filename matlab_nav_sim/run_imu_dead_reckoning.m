function dr = run_imu_dead_reckoning(truth, imu, params)
%RUN_IMU_DEAD_RECKONING Integrate IMU measurements to show open-loop drift.

t = truth.t;
dt = params.dt;
N = numel(t);

x_est = zeros(N, 1);
y_est = zeros(N, 1);
yaw_est = zeros(N, 1);
v_est = zeros(N, 1);

x_est(1) = truth.x(1);
y_est(1) = truth.y(1);
yaw_est(1) = truth.yaw(1);
v_est(1) = truth.v(1);

for k = 2:N
    yaw_est(k) = yaw_est(k - 1) + imu.wz(k - 1) * dt;
    v_est(k) = v_est(k - 1) + imu.ax(k - 1) * dt;
    x_est(k) = x_est(k - 1) + v_est(k - 1) * cos(yaw_est(k - 1)) * dt;
    y_est(k) = y_est(k - 1) + v_est(k - 1) * sin(yaw_est(k - 1)) * dt;
end

pos_err = sqrt((x_est - truth.x).^2 + (y_est - truth.y).^2);
yaw_err = atan2(sin(yaw_est - truth.yaw), cos(yaw_est - truth.yaw));
yaw_err_deg = rad2deg(yaw_err);

dr.t = t;
dr.x = x_est;
dr.y = y_est;
dr.yaw = yaw_est;
dr.v = v_est;
dr.pos_err = pos_err;
dr.yaw_err_deg = yaw_err_deg;
