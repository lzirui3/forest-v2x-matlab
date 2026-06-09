function truth = make_truth_trajectory(params)
%MAKE_TRUTH_TRAJECTORY Generate a simple 2D ground-truth trajectory.
%
% State definitions:
% x, y    : position in world frame (m)
% yaw     : heading angle (rad)
% v       : forward speed (m/s)
% omega   : yaw rate (rad/s)
% a_long  : longitudinal acceleration in body frame (m/s^2)
% a_lat   : lateral acceleration in body frame (m/s^2)

dt = params.dt;
T_total = params.T_total;
t = (0:dt:T_total).';
N = numel(t);

v = zeros(N, 1);
omega = zeros(N, 1);

for k = 1:N
    tk = t(k);

    % Piecewise motion profile:
    % 0-10 s   : straight with slow acceleration
    % 10-20 s  : constant speed straight
    % 20-30 s  : left turn
    % 30-35 s  : straight
    % 35-40 s  : stop (used later for ZUPT)
    % 40-50 s  : accelerate and straight
    % 50-60 s  : slight right turn
    if tk < 10
        v(k) = 0.1 + 0.09 * tk;
        omega(k) = 0.0;
    elseif tk < 20
        v(k) = 1.0;
        omega(k) = 0.0;
    elseif tk < 30
        v(k) = 0.8;
        omega(k) = deg2rad(6.0);
    elseif tk < 35
        v(k) = 0.8;
        omega(k) = 0.0;
    elseif tk < 40
        v(k) = 0.0;
        omega(k) = 0.0;
    elseif tk < 50
        v(k) = 0.08 * (tk - 40);
        omega(k) = 0.0;
    else
        v(k) = 0.8;
        omega(k) = -deg2rad(3.0);
    end
end

yaw = zeros(N, 1);
x = zeros(N, 1);
y = zeros(N, 1);
a_long = zeros(N, 1);
a_lat = zeros(N, 1);

for k = 2:N
    a_long(k) = (v(k) - v(k - 1)) / dt;
    yaw(k) = yaw(k - 1) + omega(k - 1) * dt;
    x(k) = x(k - 1) + v(k - 1) * cos(yaw(k - 1)) * dt;
    y(k) = y(k - 1) + v(k - 1) * sin(yaw(k - 1)) * dt;
    a_lat(k) = v(k - 1) * omega(k - 1);
end

truth.t = t;
truth.x = x;
truth.y = y;
truth.yaw = yaw;
truth.v = v;
truth.omega = omega;
truth.a_long = a_long;
truth.a_lat = a_lat;
