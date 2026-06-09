function gnss = simulate_gnss(truth, params)
%SIMULATE_GNSS Simulate 2D GNSS position measurements with three states:
% 0: normal
% 1: degraded
% 2: outage

t = truth.t;
N = numel(t);

status = zeros(N, 1);

for k = 1:N
    tk = t(k);

    if tk < 20
        status(k) = 0; % normal
    elseif tk < 35
        status(k) = 1; % degraded
    elseif tk < 45
        status(k) = 2; % outage
    else
        status(k) = 0; % recovered normal
    end
end

x_meas = nan(N, 1);
y_meas = nan(N, 1);

for k = 1:N
    switch status(k)
        case 0
            x_meas(k) = truth.x(k) + params.sigma_normal * randn;
            y_meas(k) = truth.y(k) + params.sigma_normal * randn;

        case 1
            x_meas(k) = truth.x(k) + params.bias_x + params.sigma_degraded * randn;
            y_meas(k) = truth.y(k) + params.bias_y + params.sigma_degraded * randn;

        case 2
            % GNSS outage: no measurement
            x_meas(k) = nan;
            y_meas(k) = nan;
    end
end

gnss.t = t;
gnss.status = status;
gnss.x = x_meas;
gnss.y = y_meas;

