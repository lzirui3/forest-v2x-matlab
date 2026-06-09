function [objective_value, aux, meta] = compute_action_risk_constrained_objective( ...
    urgency, q_link, q_pos, action, relay_available, base_rate, params, event_state, context)
%COMPUTE_ACTION_RISK_CONSTRAINED_OBJECTIVE Soft constrained-risk action objective.
%
% The objective is the Lagrangian form of a finite-action scheduling problem:
% maximize value-weighted timely delivery while penalizing communication cost
% and violations of reliability, timely, deadline, and protection constraints.

if nargin < 9 || isempty(context)
    context = struct();
end

aux = evaluate_action_metrics( ...
    urgency, q_link, q_pos, action, relay_available, base_rate, params, event_state, context);

required_timely = compute_required_timely_target(urgency, q_link, q_pos, event_state, params);
required_success = compute_required_success_target_local(urgency, q_link, q_pos, event_state, params);
required_protection = compute_required_protection_level(urgency, q_link, q_pos, event_state, params);

pos_risk = compute_piecewise_position_risk(q_pos, params);
link_risk = max(1.0 - q_link, 0.0);
blind_risk = max(event_state.blind_zone_gate, ...
    max(event_state.blind_zone_gate - params.blind_zone_trigger_threshold, 0.0));
info_value = compute_information_value_local(urgency, pos_risk, link_risk, blind_risk, params);

timely_violation = max(required_timely - aux.timely_prob, 0.0);
success_violation = max(required_success - aux.success_prob, 0.0);
protection_violation = max(required_protection - aux.protection_level, 0.0);
deadline_violation = max(aux.pred_delay / max(aux.deadline, 1.0e-6) - 1.0, 0.0);
position_violation = pos_risk * max(required_protection - aux.protection_level, 0.0);

reward = info_value * aux.timely_prob ...
    + paramsafe(params, 'risk_constrained_success_reward_weight', 0.45) * aux.success_prob ...
    + paramsafe(params, 'risk_constrained_event_reward_weight', 0.12) * aux.event_gain;

lagrangian_penalty = paramsafe(params, 'risk_constrained_timely_lambda', 3.20) * timely_violation ...
    + paramsafe(params, 'risk_constrained_success_lambda', 2.20) * success_violation ...
    + paramsafe(params, 'risk_constrained_deadline_lambda', 1.25) * deadline_violation ...
    + paramsafe(params, 'risk_constrained_protection_lambda', 1.60) * protection_violation ...
    + paramsafe(params, 'risk_constrained_position_lambda', 0.75) * position_violation;

regularization = paramsafe(params, 'risk_constrained_cost_weight', 0.055) * aux.tx_cost ...
    + paramsafe(params, 'risk_constrained_delay_weight', 0.08) * aux.delay_penalty ...
    + paramsafe(params, 'risk_constrained_position_risk_weight', 0.20) * aux.risk_penalty ...
    + paramsafe(params, 'risk_constrained_misdecision_weight', 0.28) * aux.misdecision_risk ...
    + paramsafe(params, 'risk_constrained_relay_penalty_weight', 0.06) * aux.relay_penalty ...
    + aux.support_mismatch_penalty;

objective_value = regularization + lagrangian_penalty - reward;

meta.required_timely = required_timely;
meta.required_success = required_success;
meta.required_protection = required_protection;
meta.info_value = info_value;
meta.pos_risk = pos_risk;
meta.link_risk = link_risk;
meta.blind_risk = blind_risk;
meta.timely_violation = timely_violation;
meta.success_violation = success_violation;
meta.deadline_violation = deadline_violation;
meta.protection_violation = protection_violation;
meta.position_violation = position_violation;
meta.reward = reward;
meta.lagrangian_penalty = lagrangian_penalty;
meta.regularization = regularization;
end

function required_success = compute_required_success_target_local(urgency, q_link, q_pos, event_state, params)
pos_risk = compute_piecewise_position_risk(q_pos, params);
link_risk = max(1.0 - q_link, 0.0);
blind_risk = max(event_state.blind_zone_gate, 0.0);

required_success = paramsafe(params, 'risk_constrained_success_bias', 0.50) ...
    + paramsafe(params, 'risk_constrained_success_urgency_scale', 0.24) * urgency ...
    + paramsafe(params, 'risk_constrained_success_link_scale', 0.12) * link_risk ...
    + paramsafe(params, 'risk_constrained_success_pos_scale', 0.10) * pos_risk ...
    + paramsafe(params, 'risk_constrained_success_blind_scale', 0.12) * blind_risk;

required_success = min(max(required_success, ...
    paramsafe(params, 'risk_constrained_success_min', 0.45)), ...
    paramsafe(params, 'risk_constrained_success_max', 0.94));
end

function info_value = compute_information_value_local(urgency, pos_risk, link_risk, blind_risk, params)
info_value = paramsafe(params, 'risk_constrained_voi_bias', 0.65) ...
    + paramsafe(params, 'risk_constrained_voi_urgency_scale', 0.70) * urgency ...
    + paramsafe(params, 'risk_constrained_voi_pos_scale', 0.24) * pos_risk ...
    + paramsafe(params, 'risk_constrained_voi_link_scale', 0.14) * link_risk ...
    + paramsafe(params, 'risk_constrained_voi_blind_scale', 0.28) * blind_risk;

info_value = min(max(info_value, ...
    paramsafe(params, 'risk_constrained_voi_min', 0.50)), ...
    paramsafe(params, 'risk_constrained_voi_max', 1.90));
end

function v = paramsafe(params, name, default)
if isfield(params, name)
    v = params.(name);
else
    v = default;
end
end
