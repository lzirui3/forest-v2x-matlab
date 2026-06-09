function filter_state = step9_filter_position_confidence(meas_x, meas_y, meas_sigma, dt, params)
%STEP9_FILTER_POSITION_CONFIDENCE
% Apply a simple constant-velocity filter and derive trajectory consistency.

N = numel(meas_x);
filtered_x = zeros(N, 1);
filtered_y = zeros(N, 1);
innovation_norm = zeros(N, 1);
consistency_score = zeros(N, 1);

A = [1.0, 0.0, dt, 0.0; ...
     0.0, 1.0, 0.0, dt; ...
     0.0, 0.0, 1.0, 0.0; ...
     0.0, 0.0, 0.0, 1.0];
H = [1.0, 0.0, 0.0, 0.0; ...
     0.0, 1.0, 0.0, 0.0];

state = [meas_x(1); meas_y(1); 0.0; 0.0];
if N >= 2
    state(3) = (meas_x(2) - meas_x(1)) / max(dt, eps);
    state(4) = (meas_y(2) - meas_y(1)) / max(dt, eps);
end

P = diag([4.0, 4.0, 1.0, 1.0]);
Q_base = diag([params.position_filter_process_noise, params.position_filter_process_noise, ...
    params.position_filter_velocity_noise, params.position_filter_velocity_noise]);
I4 = eye(4);

for k = 1:N
    if k == 1
        pred = state;
        P_pred = P;
    else
        pred = A * state;
        Q = (1.0 + 0.12 * meas_sigma(k)) * Q_base;
        P_pred = A * P * A' + Q;
    end

    z = [meas_x(k); meas_y(k)];
    R = (0.35 + meas_sigma(k))^2 * eye(2);
    S = H * P_pred * H' + R;
    K = P_pred * H' / S;
    innovation = z - H * pred;

    state = pred + K * innovation;
    P = (I4 - K * H) * P_pred;

    filtered_x(k) = state(1);
    filtered_y(k) = state(2);
    innovation_norm(k) = norm(innovation);

    expected_innovation = sqrt(max(trace(S), 1.0e-6));
    consistency_score(k) = 1.0 - innovation_norm(k) / (2.2 * expected_innovation + 0.25);
end

consistency_score = min(max(consistency_score, 0.0), 1.0);

filter_state.filtered_x = filtered_x;
filter_state.filtered_y = filtered_y;
filter_state.innovation_norm = innovation_norm;
filter_state.consistency_score = consistency_score;
end
