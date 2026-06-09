function imu = simulate_imu(truth, params)
%SIMULATE_IMU Simulate a simple planar IMU for the tracked platform.
%
% Outputs:
% ax, ay : measured body-frame accelerations (m/s^2)
% wz     : measured yaw rate (rad/s)

t = truth.t;
N = numel(t);

ax_true = truth.a_long;
ay_true = truth.a_lat;
wz_true = truth.omega;

ax = ax_true + params.bias_ax + params.sigma_ax * randn(N, 1);
ay = ay_true + params.bias_ay + params.sigma_ay * randn(N, 1);
wz = wz_true + params.bias_wz + params.sigma_wz * randn(N, 1);

stationary_flag = (truth.v < params.stationary_speed_threshold);

imu.t = t;
imu.ax_true = ax_true;
imu.ay_true = ay_true;
imu.wz_true = wz_true;
imu.ax = ax;
imu.ay = ay;
imu.wz = wz;
imu.stationary_flag = stationary_flag;
imu.bias_ax = params.bias_ax;
imu.bias_ay = params.bias_ay;
imu.bias_wz = params.bias_wz;
