function [utility_value, aux] = compute_action_utility( ...
    urgency, q_link, q_pos, action, relay_available, base_rate, params, event_state, context)
%COMPUTE_ACTION_UTILITY Legacy heuristic scorer retained for comparison/fallback.

aux = evaluate_action_metrics( ...
    urgency, q_link, q_pos, action, relay_available, base_rate, params, event_state, context);

w_lr_urg = paramsafe(params, 'utility_low_risk_weight_urgency', 0.45);
w_lr_link = paramsafe(params, 'utility_low_risk_weight_link', 0.30);
w_lr_pos = paramsafe(params, 'utility_low_risk_weight_pos', 0.25);
low_risk_score = w_lr_urg * urgency + w_lr_link * (1.0 - q_link) + w_lr_pos * (1.0 - q_pos);
emg_thresh = paramsafe(params, 'utility_emergency_urgency_threshold', 0.80);
blind_zone_gain = max(event_state.blind_zone_gate - params.blind_zone_trigger_threshold, 0.0);

utility_value = params.utility_weight_timely * aux.timely_prob ...
    + params.utility_weight_reliability * aux.success_prob ...
    + aux.event_gain ...
    - params.utility_weight_cost * aux.tx_cost ...
    - params.utility_weight_delay * aux.delay_penalty ...
    - params.utility_weight_position_risk * aux.risk_penalty ...
    - params.utility_weight_misdecision * aux.misdecision_risk ...
    - params.utility_relay_penalty * aux.relay_penalty ...
    - aux.support_mismatch_penalty;

if q_link < params.link_bad_threshold && q_pos < params.pos_low_threshold && action.priority < 3
    utility_value = utility_value - params.utility_low_quality_priority_penalty;
end

if low_risk_score < params.utility_low_risk_guard_threshold
    utility_value = utility_value ...
        - params.utility_low_risk_rate_penalty_scale * max(action.rate_multiplier - 1.0, 0.0) ...
        - params.utility_low_risk_priority_penalty_scale * max(action.priority - 1, 0.0);
    if action.mode == 2 && blind_zone_gain <= 1.0e-9
        utility_value = utility_value - params.utility_low_risk_relay_penalty;
    end
end

if urgency >= emg_thresh && action.priority == 3
    utility_value = utility_value + params.utility_emergency_priority_bonus;
end
end

function v = paramsafe(params, name, default)
if isfield(params, name)
    v = params.(name);
else
    v = default;
end
end
