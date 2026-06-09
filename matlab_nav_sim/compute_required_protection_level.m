function required_protection = compute_required_protection_level(urgency, q_link, q_pos, event_state, params)
%COMPUTE_REQUIRED_PROTECTION_LEVEL Minimum action protection level required by state.
%
%   GROUNDED FORM (default): a GNSS navigation-integrity criterion. The fused
%   1-sigma horizontal positioning error sigma (event_state.coarse_sigma) gives a
%   protection level PL = k*sigma; the required action protection grows with the
%   normalized exceedance of PL over a per-message-class alert limit AL
%   (PL <= AL => 0, the standard "available" region; ESA Navipedia integrity:
%   declare unavailable when PL > AL). This replaces the earlier hand-picked
%   affine RHS (utility_required_protection_*), which is retained ONLY as a
%   fallback when sigma is unavailable (sigma-less callers / ablation).
%
%   Grounded inputs: sigma (fused, already blind-zone-inflated), k (integrity
%   quantile), AL (lane/road alert limits, AV-integrity literature). Engineering:
%   protection_integrity_scale and the [0, max] saturation only.
%   See get_default_step9_params (protection_use_integrity / integrity_k_sigma /
%   integrity_alert_limit_* / protection_integrity_scale).

use_integrity = paramsafe(params, 'protection_use_integrity', true);
sigma = NaN;
if isstruct(event_state) && isfield(event_state, 'coarse_sigma')
    sigma = event_state.coarse_sigma;
end

if use_integrity && isscalar(sigma) && isfinite(sigma)
    k = paramsafe(params, 'integrity_k_sigma', 3.0);
    AL = local_alert_limit(urgency, params);
    PL = k * sigma;                                  % k-sigma protection level
    deficit = max(PL - AL, 0.0) / max(AL, 1.0e-6);   % normalized integrity exceedance
    scale = paramsafe(params, 'protection_integrity_scale', 0.55);
    rp_max = paramsafe(params, 'utility_required_protection_max', 0.82);
    required_protection = min(max(scale * deficit, 0.0), rp_max);
    return;
end

required_protection = local_affine_fallback(urgency, q_link, q_pos, event_state, params);
end

% ------------------------------------------------------------------------
function AL = local_alert_limit(urgency, params)
emg_thr = paramsafe(params, 'utility_emergency_urgency_threshold', 0.80);
if urgency >= emg_thr
    AL = paramsafe(params, 'integrity_alert_limit_lane', 1.5);
elseif urgency >= 0.50
    AL = paramsafe(params, 'integrity_alert_limit_coop', 3.0);
else
    AL = paramsafe(params, 'integrity_alert_limit_road', 5.0);
end
end

% ------------------------------------------------------------------------
function required_protection = local_affine_fallback(urgency, q_link, q_pos, event_state, params)
%LOCAL_AFFINE_FALLBACK Legacy hand-picked affine RHS (pre-integrity); used only
%   when the fused sigma is unavailable. Deprecated in favour of the PL>AL form.
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

% ------------------------------------------------------------------------
function value = paramsafe(source, field_name, default_value)
if isstruct(source) && isfield(source, field_name)
    value = source.(field_name);
else
    value = default_value;
end
end
