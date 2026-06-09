function [score, aux, meta] = compute_action_chance_risk_aoi_objective( ...
    urgency, q_link, q_pos, action, relay_available, base_rate, params, event_state, context)
%COMPUTE_ACTION_CHANCE_RISK_AOI_OBJECTIVE Chance-risk-AoI finite-action score.
%
% This Step63 side-copy separates chance-constraint feasibility from the
% remaining cost/information-value score. It is intentionally compact so it
% can be audited against Risk-constrained-v6 without changing the mainline.

if nargin < 9 || isempty(context)
    context = struct();
end

aux = evaluate_action_metrics( ...
    urgency, q_link, q_pos, action, relay_available, base_rate, params, event_state, context);
aux.tx_cost = compute_actual_tx_cost_local(action, params);

targets = compute_chance_targets_local(urgency, q_link, q_pos, event_state, params);
voi = compute_voi_local(urgency, q_link, q_pos, event_state, context, params);
aoi_value = compute_aoi_value_local(context, params);

timely_violation = max(targets.timely - aux.timely_prob, 0.0);
success_violation = max(targets.success - aux.success_prob, 0.0);
delay_violation = max(aux.pred_delay / max(aux.deadline, 1.0e-6) - 1.0, 0.0);
protection_violation = max(targets.protection - aux.protection_level, 0.0);

total_violation = timely_violation ...
    + success_violation ...
    + paramsafe(params, 'chance_risk_aoi_delay_violation_weight', 0.60) * delay_violation ...
    + paramsafe(params, 'chance_risk_aoi_protection_violation_weight', 0.45) * protection_violation;

score = voi * aux.timely_prob ...
    + paramsafe(params, 'chance_risk_aoi_aoi_weight', 0.30) * aoi_value * aux.success_prob ...
    - paramsafe(params, 'chance_risk_aoi_cost_weight', 0.045) * aux.tx_cost ...
    - paramsafe(params, 'chance_risk_aoi_delay_weight', 0.050) * aux.delay_penalty ...
    - paramsafe(params, 'chance_risk_aoi_violation_weight', 3.20) * total_violation;

meta.required_timely = targets.timely;
meta.required_success = targets.success;
meta.required_protection = targets.protection;
meta.voi = voi;
meta.aoi_value = aoi_value;
meta.timely_violation = timely_violation;
meta.success_violation = success_violation;
meta.delay_violation = delay_violation;
meta.protection_violation = protection_violation;
meta.total_violation = total_violation;
meta.is_feasible = total_violation <= paramsafe(params, 'chance_risk_aoi_feasibility_tol', 1.0e-9);
end

function targets = compute_chance_targets_local(urgency, q_link, q_pos, event_state, params)
pos_risk = compute_piecewise_position_risk(q_pos, params);
link_risk = max(1.0 - q_link, 0.0);
blind_risk = max(event_state.blind_zone_gate, 0.0);

epsilon_t = paramsafe(params, 'chance_risk_aoi_epsilon_timely_base', 0.30) ...
    - paramsafe(params, 'chance_risk_aoi_epsilon_timely_urgency_scale', 0.16) * urgency ...
    - paramsafe(params, 'chance_risk_aoi_epsilon_timely_risk_scale', 0.08) * max(pos_risk, blind_risk);
epsilon_t = min(max(epsilon_t, ...
    paramsafe(params, 'chance_risk_aoi_epsilon_timely_min', 0.08)), ...
    paramsafe(params, 'chance_risk_aoi_epsilon_timely_max', 0.35));

epsilon_s = paramsafe(params, 'chance_risk_aoi_epsilon_success_base', 0.24) ...
    - paramsafe(params, 'chance_risk_aoi_epsilon_success_urgency_scale', 0.10) * urgency ...
    - paramsafe(params, 'chance_risk_aoi_epsilon_success_link_scale', 0.08) * link_risk;
epsilon_s = min(max(epsilon_s, ...
    paramsafe(params, 'chance_risk_aoi_epsilon_success_min', 0.06)), ...
    paramsafe(params, 'chance_risk_aoi_epsilon_success_max', 0.30));

targets.timely = min(max(1.0 - epsilon_t, ...
    paramsafe(params, 'chance_risk_aoi_timely_min', 0.58)), ...
    paramsafe(params, 'chance_risk_aoi_timely_max', 0.94));
targets.success = min(max(1.0 - epsilon_s, ...
    paramsafe(params, 'chance_risk_aoi_success_min', 0.62)), ...
    paramsafe(params, 'chance_risk_aoi_success_max', 0.96));
targets.protection = compute_required_protection_level(urgency, q_link, q_pos, event_state, params);
end

function value = compute_voi_local(urgency, q_link, q_pos, event_state, context, params)
pos_risk = compute_piecewise_position_risk(q_pos, params);
link_risk = max(1.0 - q_link, 0.0);
blind_risk = max(event_state.blind_zone_gate, 0.0);

deadline_pressure = 0.0;
if isfield(context, 'deadline')
    deadline_pressure = 1.0 / max(context.deadline, 1.0e-3);
    deadline_pressure = min(deadline_pressure / 15.0, 1.0);
end

value = paramsafe(params, 'chance_risk_aoi_voi_bias', 0.70) ...
    + paramsafe(params, 'chance_risk_aoi_voi_urgency_scale', 0.75) * urgency ...
    + paramsafe(params, 'chance_risk_aoi_voi_pos_scale', 0.22) * pos_risk ...
    + paramsafe(params, 'chance_risk_aoi_voi_link_scale', 0.16) * link_risk ...
    + paramsafe(params, 'chance_risk_aoi_voi_blind_scale', 0.24) * blind_risk ...
    + paramsafe(params, 'chance_risk_aoi_voi_deadline_scale', 0.10) * deadline_pressure;
value = min(max(value, 0.50), 2.20);
end

function value = compute_aoi_value_local(context, params)
if isfield(context, 'aoi_age')
    age = context.aoi_age;
else
    age = 0.0;
end
cap = paramsafe(params, 'chance_risk_aoi_age_norm_cap', ...
    paramsafe(params, 'aoi_age_norm_cap', 8.0));
value = min(max(age / max(cap, 1.0e-6), 0.0), 1.0);
end

function actual_tx_cost = compute_actual_tx_cost_local(action, params)
if action.mode == 1
    mode_cost = params.tx_cost_redundant;
elseif action.mode == 2
    mode_cost = params.tx_cost_relay;
else
    mode_cost = params.tx_cost_direct;
end
actual_tx_cost = mode_cost * action.tx_rate;
end

function value = paramsafe(params, name, default)
if isfield(params, name)
    value = params.(name);
else
    value = default;
end
end
