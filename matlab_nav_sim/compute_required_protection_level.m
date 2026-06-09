function required_protection = compute_required_protection_level(urgency, q_link, q_pos, event_state, params)
%COMPUTE_REQUIRED_PROTECTION_LEVEL Minimum action protection level required by state.

piecewise_pos_risk = compute_piecewise_position_risk(q_pos, params);
blind_zone_gain = max(event_state.blind_zone_gate - params.blind_zone_trigger_threshold, 0.0);
risk_link = 1.0 - q_link;

pos_activation = paramsafe(params, 'utility_required_protection_activation_pos', 0.45);
blind_activation = paramsafe(params, 'utility_required_protection_activation_blind', 0.22);
pos_shape = paramsafe(params, 'utility_required_protection_pos_shape', 1.35);
blind_shape = paramsafe(params, 'utility_required_protection_blind_shape', 1.20);

pos_excess = max(piecewise_pos_risk - pos_activation, 0.0);
blind_excess = max(blind_zone_gain - blind_activation, 0.0);

if pos_excess <= 1.0e-9 && blind_excess <= 1.0e-9
    required_protection = 0.0;
    return;
end

pos_term = (pos_excess / max(1.0 - pos_activation, 1.0e-6)) ^ pos_shape;
blind_term = (blind_excess / max(1.0 - blind_activation, 1.0e-6)) ^ blind_shape;

required_protection = params.utility_required_protection_base ...
    + params.utility_required_protection_pos_scale * pos_term ...
    + params.utility_required_protection_blind_scale * blind_term ...
    + params.utility_required_protection_urgency_scale * max(urgency - 0.5, 0.0) ...
    + params.utility_required_protection_link_scale * max(risk_link - 0.2, 0.0);

required_protection = min(max(required_protection, ...
    params.utility_required_protection_min), ...
    params.utility_required_protection_max);
end

function value = paramsafe(source, field_name, default_value)
if isstruct(source) && isfield(source, field_name)
    value = source.(field_name);
else
    value = default_value;
end
end
