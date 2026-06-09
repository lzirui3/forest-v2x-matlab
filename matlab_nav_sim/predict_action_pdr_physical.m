function pred_pdr = predict_action_pdr_physical(sinr_dB, is_nlos, action, params)
%PREDICT_ACTION_PDR_PHYSICAL Predict delivery probability using physical model.
%   Uses SINR->PDR mapping with priority gain and mode diversity.
%   No fast fading (uses expected PDR for optimization).

% Priority SINR gain
sinr_gain = params.priority_sinr_gain * (action.priority - 1);
if action.is_emergency
    sinr_gain = sinr_gain + params.emergency_sinr_bonus;
end
sinr_pred = sinr_dB + sinr_gain;

% Single-transmission PDR (expected, no fading)
pdr_single = sinr_to_pdr_physical(sinr_pred, is_nlos, params);

% Mode diversity
if action.mode == 0
    pdr_attempt = pdr_single;
elseif action.mode == 1
    % Redundant: selection combining of 2 independent copies
    pdr_attempt = 1.0 - (1.0 - pdr_single)^2;
elseif action.mode == 2
    % Relay: 两跳独立信道模型（与 simulate_step9_delivery_physical 一致）
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

% Multi-attempt (time diversity)
n_attempts = max(1, ceil(action.rate_multiplier));
pred_pdr = 1.0 - (1.0 - pdr_attempt)^n_attempts;

pred_pdr = min(max(pred_pdr, 0.02), 0.995);
end

function v = paramsafe(params, name, default)
if isfield(params, name)
    v = params.(name);
else
    v = default;
end
end
