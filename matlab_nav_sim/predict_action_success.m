function success_prob = predict_action_success(urgency, q_link, q_pos, action, params)
%PREDICT_ACTION_SUCCESS Predict packet success probability for a candidate action.

priority_bonus = params.abstract_priority_bonus_per_level * (action.priority - 1);
emg_thr = 0.80;
if isfield(params, 'utility_emergency_urgency_threshold')
    emg_thr = params.utility_emergency_urgency_threshold;  % bind to sweepable param (was hardcoded 0.80)
end
if urgency >= emg_thr
    priority_bonus = priority_bonus + params.critical_priority_bonus;
end

mode_bonus = 0.0;
if action.mode == 1
    mode_bonus = params.redundant_success_bonus;
elseif action.mode == 2
    mode_bonus = params.relay_success_bonus;
end

rate_bonus = params.abstract_rate_bonus_scale * ...
    max(action.tx_rate - action.tx_rate / max(action.rate_multiplier, 1.0), 0.0);

confidence_protection = 0.0;
if action.mode >= 1  % redundant or relay
    if (1.0 - q_pos) > 0.45 && action.priority >= 3
        confidence_protection = params.abstract_confidence_protection_high;
    elseif (1.0 - q_pos) > 0.30 && action.priority >= 2
        confidence_protection = params.abstract_confidence_protection_mid;
    end
elseif (1.0 - q_pos) > 0.30 && action.priority >= 2
    confidence_protection = params.abstract_confidence_protection_direct;
end

success_prob = q_link + params.base_success_bias + priority_bonus + mode_bonus + rate_bonus ...
    + confidence_protection - params.position_risk_penalty * (1.0 - q_pos);
success_prob = min(max(success_prob, 0.02), 0.995);
end
