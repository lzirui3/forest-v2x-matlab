function q_pos = compute_positioning_confidence_rule(n_sat, dop, sigma_pos, dt_upd, params)
%COMPUTE_POSITIONING_CONFIDENCE_RULE Rule-based positioning confidence score in [0, 1].
%   The four sub-scores normalize the GNSS quality indicators over groundable
%   ranges (n_sat>=4 for a 3D fix; DOP 1..5 "excellent".."poor"; sigma_pos the
%   1-sigma horizontal error 0.3..3.0 m; dt_upd update staleness 0.1..0.8 s). The
%   blend weights are an engineering choice (FORM groundable, split not) and are
%   read from params (qpos_weight_*) so they can be audited and swept; defaults
%   equal the previous hardcoded 0.25/0.25/0.30/0.20.
if nargin < 5 || isempty(params)
    params = struct();
end

s_sat = (n_sat - 3.0) ./ (12.0 - 3.0);
s_sat = min(max(s_sat, 0.0), 1.0);

s_dop = 1.0 - (dop - 1.0) ./ (5.0 - 1.0);
s_dop = min(max(s_dop, 0.0), 1.0);

s_pos = 1.0 - (sigma_pos - 0.3) ./ (3.0 - 0.3);
s_pos = min(max(s_pos, 0.0), 1.0);

s_upd = 1.0 - (dt_upd - 0.1) ./ (0.8 - 0.1);
s_upd = min(max(s_upd, 0.0), 1.0);

w_sat = paramsafe(params, 'qpos_weight_sat', 0.25);
w_dop = paramsafe(params, 'qpos_weight_dop', 0.25);
w_pos = paramsafe(params, 'qpos_weight_sigma', 0.30);
w_upd = paramsafe(params, 'qpos_weight_update', 0.20);

q_pos = w_sat * s_sat + w_dop * s_dop + w_pos * s_pos + w_upd * s_upd;
q_pos = min(max(q_pos, 0.0), 1.0);
end

function value = paramsafe(source, field_name, default_value)
if isstruct(source) && isfield(source, field_name)
    value = source.(field_name);
else
    value = default_value;
end
end

