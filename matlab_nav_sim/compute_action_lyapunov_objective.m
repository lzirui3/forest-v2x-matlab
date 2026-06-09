function [objective_value, aux, meta] = compute_action_lyapunov_objective( ...
    queue_state, urgency, q_link, q_pos, action, relay_available, base_rate, params, event_state, context)
%COMPUTE_ACTION_LYAPUNOV_OBJECTIVE Drift-plus-penalty objective for one action.

if nargin < 10 || isempty(context)
    context = struct();
end

aux = evaluate_action_metrics( ...
    urgency, q_link, q_pos, action, relay_available, base_rate, params, event_state, context);

required_timely = compute_required_timely_target(urgency, q_link, q_pos, event_state, params);
required_protection = compute_required_protection_level(urgency, q_link, q_pos, event_state, params);
arrival = compute_lyapunov_stage_pressure(urgency, q_link, q_pos, event_state, params);
service = params.lyapunov_queue_service_scale * min(aux.timely_prob, 1.0);

drift_term = queue_state * (arrival - service);

penalty = params.lyapunov_cost_weight * aux.tx_cost ...
    + params.lyapunov_delay_weight * aux.delay_penalty ...
    + params.lyapunov_risk_weight * aux.risk_penalty ...
    + params.utility_weight_misdecision * aux.misdecision_risk ...
    + aux.support_mismatch_penalty ...
    + params.utility_relay_penalty * aux.relay_penalty;

reward = params.lyapunov_event_weight * aux.event_gain ...
    + params.utility_weight_reliability * aux.success_prob;

protection_violation = max(required_protection - aux.protection_level, 0.0);
timely_violation = max(required_timely - aux.timely_prob, 0.0);

objective_value = drift_term ...
    + params.lyapunov_V * (penalty + protection_violation + timely_violation - reward);

meta.required_timely = required_timely;
meta.required_protection = required_protection;
meta.arrival = arrival;
meta.service = service;
meta.drift_term = drift_term;
meta.penalty = penalty;
meta.reward = reward;
meta.timely_violation = timely_violation;
meta.protection_violation = protection_violation;
meta.queue_next = min(max(queue_state + arrival - service, 0.0), params.lyapunov_queue_max);
end
