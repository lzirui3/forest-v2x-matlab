function required_timely = compute_required_timely_target(urgency, q_link, q_pos, event_state, params)
%COMPUTE_REQUIRED_TIMELY_TARGET State-dependent minimum timely-delivery target.

risk_link = 1.0 - q_link;
blind_zone = event_state.blind_zone_gate;
piecewise_pos_risk = compute_piecewise_position_risk(q_pos, params);

required_timely = paramsafe(params, 'utility_required_timely_bias', 0.18) ...
    + paramsafe(params, 'utility_required_timely_urgency_scale', 0.34) * urgency ...
    + paramsafe(params, 'utility_required_timely_link_risk_scale', 0.20) * risk_link ...
    + paramsafe(params, 'utility_required_timely_pos_risk_scale', 0.16) * piecewise_pos_risk ...
    + paramsafe(params, 'utility_required_timely_blind_scale', 0.14) * blind_zone;

required_timely = min(max(required_timely, ...
    paramsafe(params, 'utility_required_timely_min', 0.25)), ...
    paramsafe(params, 'utility_required_timely_max', 0.92));
end

function value = paramsafe(source, field_name, default_value)
if isstruct(source) && isfield(source, field_name)
    value = source.(field_name);
else
    value = default_value;
end
end
