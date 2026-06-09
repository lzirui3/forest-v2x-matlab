function pred_delay = predict_action_delay_physical(sinr_dB, is_nlos, action, params)
%PREDICT_ACTION_DELAY_PHYSICAL Predict delay using physical model.
%   Computes expected delay including congestion, mode overhead, and
%   expected attempt gaps (accounting for early stopping).

% Congestion based on raw channel quality
pdr_raw = sinr_to_pdr_physical(sinr_dB, is_nlos, params);
congestion = params.congestion_delay_max * (1.0 - pdr_raw);

% Mode overhead
mode_overhead = 0.0;
if action.mode == 1
    mode_overhead = params.mode_overhead_redundant;
elseif action.mode == 2
    mode_overhead = params.mode_overhead_relay;
end

% Expected extra attempts (with early stopping)
n_attempts = max(1, ceil(action.rate_multiplier));

% Compute per-attempt success probability for early stopping model
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
    % Relay: 两跳独立信道模型（期望 PDR，与仿真器一致）
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

% Expected extra attempts beyond the first
expected_extra = 0.0;
if n_attempts > 1 && pdr_attempt < 0.999
    fail_prob = 1.0 - pdr_attempt;
    for a = 1:(n_attempts - 1)
        expected_extra = expected_extra + fail_prob^a;
    end
end

attempt_delay = params.attempt_gap * expected_extra;

pred_delay = params.base_access_delay + congestion + mode_overhead + attempt_delay;
end

function v = paramsafe(params, name, default)
if isfield(params, name)
    v = params.(name);
else
    v = default;
end
end
