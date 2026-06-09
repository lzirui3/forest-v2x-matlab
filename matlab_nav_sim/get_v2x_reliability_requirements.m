function req = get_v2x_reliability_requirements(msg_type, params)
%GET_V2X_RELIABILITY_REQUIREMENTS Standards-grounded V2X reliability/latency targets.
%
%   req = GET_V2X_RELIABILITY_REQUIREMENTS(msg_type, params) returns the
%   reliability and latency requirement used as the right-hand-side (RHS) of
%   the reliability constraint in the drift-plus-penalty scheduler
%   (run_step9_proposed_method_dpp).
%
%   THEORETICAL SOURCE (verified, see parameter_theoretical_grounding_audit_cn.md):
%     * 3GPP TS 22.186 defines V2X "reliability" as the percentage of messages
%       successfully received within the required latency AND communication
%       range. Hence a single "timely-delivery" metric (delivered within the
%       deadline) IS the standardized reliability quantity -- there is no need
%       for separate "success" and "timely" constraints (that double-counts).
%     * TS 22.186 reliability tiers used here: 90% / 99.99% / 99.999%.
%     * Latency anchors: TS 22.185 general V2X latency 100 ms; ETSI EN 302 637-2
%       CAM generation 100 ms..1000 ms; ETSI TR 102 638 pre-crash warning 50 ms;
%       TS 22.185 pre-crash 20 ms / TS 22.186 most-stringent 3 ms.
%
%   HONESTY BOUNDARY (must be stated in the paper):
%     The mapping {normal, coop, emergency} -> {tier} is an ENGINEERING
%     INTERPRETATION. The standards do not define these three message classes,
%     nor do they assign these specific tiers to them. We report the class->tier
%     map as a design choice, not as a normative clause.
%
%   SIMULATOR-ACHIEVABILITY DERATING:
%     The abstracted PHY in this package cannot reach 99.99%/99.999% (its timely
%     ceiling is ~0.97). We therefore store the full standard tier
%     (reliability_standard) for documentation, and evaluate the scheduler
%     against an explicit OPERATIONAL FLOOR (reliability_floor). The gap
%     derating = reliability_standard - reliability_floor is reported openly,
%     NOT hidden by clamping.

if nargin < 2 || isempty(params)
    params = struct();
end

key = lower(strtrim(char(string(msg_type))));

switch key
    case {'emergency', 'emg'}
        reliability_standard = 0.99999;   % TS 22.186 highest reliability tier
        deadline_standard    = 0.050;     % ETSI TR 102 638 pre-crash warning
        floor_default        = paramsafe(params, 'v2x_reliability_floor_emergency', 0.80);
    case {'coop', 'cooperative'}
        reliability_standard = 0.99990;   % TS 22.186 cooperative reliability tier
        deadline_standard    = 0.100;     % TS 22.185 / TS 22.186 cooperative latency
        floor_default        = paramsafe(params, 'v2x_reliability_floor_coop', 0.65);
    otherwise % 'normal'
        reliability_standard = 0.90000;   % TS 22.186 baseline reliability tier
        deadline_standard    = 0.100;     % TS 22.185 general V2X latency (CAM staleness 1.0 s alt.)
        floor_default        = paramsafe(params, 'v2x_reliability_floor_normal', 0.50);
end

reliability_floor = min(max(floor_default, 0.0), reliability_standard);

req.msg_type             = string(key);
req.reliability_standard = reliability_standard;
req.reliability_floor    = reliability_floor;
req.deadline_standard    = deadline_standard;
req.derating             = reliability_standard - reliability_floor;
end

function v = paramsafe(params, name, default)
if isstruct(params) && isfield(params, name)
    v = params.(name);
else
    v = default;
end
end
