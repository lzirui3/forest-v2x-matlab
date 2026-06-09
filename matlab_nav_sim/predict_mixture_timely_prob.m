function timely_prob = predict_mixture_timely_prob(sinr_dB, is_nlos, action, deadline, params)
%PREDICT_MIXTURE_TIMELY_PROB Compute P(timely) using mixture delay model.
%   Accounts for the fact that each attempt count k has a different delay,
%   and computes timely probability as:
%     P(timely) = sum_{k=1}^{n} P(succeed on attempt k) * P(delay_k < deadline)
%
%   This correctly penalizes high n_attempts because later attempts have
%   higher delay that may exceed the deadline.

% Per-attempt PDR
sinr_gain = params.priority_sinr_gain * (action.priority - 1);
if action.is_emergency
    sinr_gain = sinr_gain + params.emergency_sinr_bonus;
end
sinr_pred = sinr_dB + sinr_gain;
pdr_single = sinr_to_pdr_physical(sinr_pred, is_nlos, params);

if action.mode == 0
    pdr_attempt = pdr_single;
elseif action.mode == 1
    pdr_attempt = 1.0 - (1.0 - pdr_single)^2;
elseif action.mode == 2
    % Relay: 两跳独立信道模型（与仿真器一致）
    relay_sinr_offset = paramsafe(params, 'relay_sinr_offset_dB', 2.5);
    sinr_hop1 = sinr_pred + relay_sinr_offset;
    relay_hop2_sinr_offset = paramsafe(params, 'relay_hop2_sinr_offset_dB', 1.5);
    sinr_hop2 = sinr_pred + relay_hop2_sinr_offset;
    relay_nlos_to_los_prob = paramsafe(params, 'relay_nlos_to_los_prob', 0.35);
    if is_nlos
        pdr_hop1 = (1.0 - relay_nlos_to_los_prob) * sinr_to_pdr_physical(sinr_hop1, true, params) ...
            + relay_nlos_to_los_prob * sinr_to_pdr_physical(sinr_hop1, false, params);
        pdr_hop2 = (1.0 - relay_nlos_to_los_prob) * sinr_to_pdr_physical(sinr_hop2, true, params) ...
            + relay_nlos_to_los_prob * sinr_to_pdr_physical(sinr_hop2, false, params);
    else
        pdr_hop1 = sinr_to_pdr_physical(sinr_hop1, false, params);
        pdr_hop2 = sinr_to_pdr_physical(sinr_hop2, false, params);
    end
    pdr_relay_chain = pdr_hop1 * pdr_hop2;
    pdr_attempt = 1.0 - (1.0 - pdr_single) * (1.0 - pdr_relay_chain);
else
    pdr_attempt = pdr_single;
end

% Base delay (without attempt gaps)
pdr_raw = sinr_to_pdr_physical(sinr_dB, is_nlos, params);
congestion = params.congestion_delay_max * (1.0 - pdr_raw);
mode_ovh = 0.0;
if action.mode == 1
    mode_ovh = params.mode_overhead_redundant;
elseif action.mode == 2
    mode_ovh = params.mode_overhead_relay;
end
base_delay = params.base_access_delay + congestion + mode_ovh;

% Number of attempts
n_attempts = max(1, ceil(action.rate_multiplier));

% Mixture over attempt counts
timely_prob = 0.0;
for k = 1:n_attempts
    % Delay for k-th attempt
    delay_k = base_delay + (k - 1) * params.attempt_gap;

    % P(succeed on exactly attempt k)
    p_succeed_k = pdr_attempt * (1.0 - pdr_attempt)^(k - 1);

    % P(delay < deadline | k attempts) using Gaussian CDF
    delay_std = params.delay_jitter_scale * delay_k;
    if delay_std > 0.001
        z_score = (deadline - delay_k) / delay_std;
        % Abramowitz & Stegun erf approximation for normcdf
        p_on_time = 0.5 * (1.0 + local_erf(z_score / sqrt(2.0)));
    else
        if delay_k < deadline
            p_on_time = 1.0;
        else
            p_on_time = 0.0;
        end
    end
    p_on_time = min(max(p_on_time, 0.02), 0.98);

    timely_prob = timely_prob + p_succeed_k * p_on_time;
end
end


function y = local_erf(x)
%LOCAL_ERF Abramowitz & Stegun erf approximation.
sgn = sign(x);
x = abs(x);
t = 1.0 / (1.0 + 0.3275911 * x);
y = 1.0 - (((((1.061405429*t - 1.453152027)*t) + 1.421413741)*t ...
    - 0.284496736)*t + 0.254829592) * t * exp(-x*x);
y = sgn * y;
end

function v = paramsafe(params, name, default)
if isfield(params, name)
    v = params.(name);
else
    v = default;
end
end
