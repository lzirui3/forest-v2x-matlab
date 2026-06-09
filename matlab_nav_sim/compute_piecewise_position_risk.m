function pos_risk = compute_piecewise_position_risk(q_pos, params)
%COMPUTE_PIECEWISE_POSITION_RISK Piecewise amplified positioning risk.

high_thr = paramsafe(params, 'utility_required_timely_qpos_high_threshold', 0.75);
low_thr = paramsafe(params, 'utility_required_timely_qpos_low_threshold', 0.50);
mid_scale = paramsafe(params, 'utility_required_timely_qpos_mid_scale', 0.50);
low_scale = paramsafe(params, 'utility_required_timely_qpos_low_scale', 1.00);

if q_pos > high_thr
    pos_risk = 0.0;
elseif q_pos > low_thr
    pos_risk = mid_scale * (high_thr - q_pos) / max(high_thr - low_thr, 1.0e-6);
else
    pos_risk = mid_scale ...
        + low_scale * (low_thr - q_pos) / max(low_thr, 1.0e-6);
end

pos_risk = max(pos_risk, 0.0);
end

function value = paramsafe(source, field_name, default_value)
if isstruct(source) && isfield(source, field_name)
    value = source.(field_name);
else
    value = default_value;
end
end
