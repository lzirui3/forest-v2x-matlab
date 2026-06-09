function T = get_parameter_provenance(params)
%GET_PARAMETER_PROVENANCE Single source of truth for parameter provenance.
%
%   T = GET_PARAMETER_PROVENANCE() returns a curated table documenting, for the
%   key parameters of the forest-V2X scheduler, the current value, subsystem,
%   provenance classification, theoretical source, and evidence strength. Use it
%   to generate the paper's parameter table and to keep claims consistent with
%   the verified grounding audit (parameter_theoretical_grounding_audit_cn.md +
%   parameter_provenance_full_audit_cn.md + parameter_provenance_completion_cn.md;
%   the completion doc holds the EXHAUSTIVE ~300-field enumeration, this registry
%   is the curated paper-facing subset).
%
%   Classification:
%     Grounded            - value derivable from a standard/physics constant.
%     StandardsDerivable  - maps onto a published standard/range; the exact number
%                           is an engineering pick within it.
%     DataCalibrated      - computed from external_data statistics.
%     Structural          - an algorithmic element (virtual queue, MPC horizon,
%                           constraint consolidation) justified by a method/theorem,
%                           not a tunable magic number.
%     EngineeringChoice   - design preference; report with a sensitivity sweep,
%                           NOT a fabricated citation.
%   Evidence: Strong / Medium / Weak (per adversarial citation verification).
%
%   METHOD NOTE: the proposed method is now the drift-plus-penalty (DPP) scheduler
%   (run_step9_proposed_method -> run_step9_proposed_method_dpp). The five frozen
%   multipliers are REPLACED by time-varying virtual queues + the single knob V;
%   they are listed here as Deprecated. The lyapunov_* family below belongs to a
%   SEPARATE baseline scheduler (run_step9_confidence_driven_lyapunov) and must NOT
%   be conflated with the DPP-proposed method (lyapunov_V=1.0 != dpp_V=2.0).
%
%   PATH NOTE: PHY Grounded/StandardsDerivable rows are active on the PHYSICAL
%   delivery path (production mainline, use_physical_delivery=true, per_lookup);
%   pdr_midpoint/slope are inactive under per_lookup (raw PER curves replace them).

if nargin < 1 || isempty(params)
    params = get_default_step9_params();
end

rows = {
% Name, Value, Subsystem, Classification, Source, Evidence
% --- PHY (active on the physical delivery path) ---
'tx_power_dBm',                  params.tx_power_dBm,                'PHY',         'Grounded',           '3GPP TS 36.101 C-V2X Power Class 3 (23 dBm)',                        'Strong'
'noise_floor_dBm',               params.noise_floor_dBm,            'PHY',         'Grounded',           '-174 dBm/Hz + 10log10(10MHz) + 10 dB NF = -94 dBm',                 'Strong'
'pathloss_los_offset_dB',        params.pathloss_los_offset_dB,     'PHY',         'Grounded',           'Friis 1 m @5.9 GHz = 47.8 dB (TR 37.885 LOS intercept)',            'Strong'
'pathloss_los_exponent',         params.pathloss_los_exponent,      'PHY',         'Grounded',           'n_LOS = 2.0 free-space / TR 37.885 highway-LOS (10*n)',              'Strong'
'pathloss_nlos_exponent',        params.pathloss_nlos_exponent,     'PHY',         'StandardsDerivable', 'n=2.4 is just BELOW TR 38.901 RMa-NLOS floor 2.7 (not inside band)', 'Medium'
'nlosv_extra_loss_dB',           params.nlosv_extra_loss_dB,        'PHY',         'StandardsDerivable', 'TR 37.885 6.2.1 NLOSv mu=5/9 dB; base 5 hits single-blocker only',  'Medium'
'shadow_sigma_los_dB',           3.0,                                'PHY',         'StandardsDerivable', 'TR 37.885 LOS shadow-fading sigma = 3 dB (literal in link gen)',     'Strong'
'shadow_sigma_nlos_dB',          4.0,                                'PHY',         'StandardsDerivable', 'TR 37.885 NLOS-row SF=4 dB; NLOSv REUSES LOS 3 dB - do not mislabel','Medium'
'fast_fading_sigma_los',         params.fast_fading_sigma_los,      'PHY',         'StandardsDerivable', 'Rician K~3 dB dB-spread (TR 37.885 / Molisch Ch.7)',                 'Medium'
'fast_fading_sigma_nlos',        params.fast_fading_sigma_nlos,     'PHY',         'StandardsDerivable', 'Rayleigh dB-spread ~5.5 dB (TR 37.885)',                             'Medium'
'pdr_midpoint_los',              params.pdr_midpoint_los,           'PHY',         'DataCalibrated',     'MCS req-SINR (WiLab PER fit); INACTIVE under per_lookup',            'Medium'
'pdr_slope_los',                 params.pdr_slope_los,              'PHY',         'EngineeringChoice',  'Empirical sigmoid steepness; INACTIVE under per_lookup',             'Weak'
'interference_scale',            params.interference_scale,         'PHY',         'EngineeringChoice',  'Co-channel interference abstraction (ideally SPS model)',            'Weak'
% --- MAC / delay ---
'base_access_delay',             params.base_access_delay,          'MAC',         'StandardsDerivable', 'SPS 1 ms TTI + grant period (value is engineering)',                 'Medium'
'mode_overhead_relay',           params.mode_overhead_relay,        'MAC',         'StandardsDerivable', 'Relay decode-forward window subframe count (value engineering)',     'Medium'
'congestion_delay_max',          params.congestion_delay_max,       'MAC',         'EngineeringChoice',  'Max congestion delay (bare amplitude)',                              'Weak'
% --- Delivery model (honesty flags) ---
'delivery_success_ceiling',      0.995,                              'Delivery',    'EngineeringChoice',  'Clamp in simulate_step9_delivery; report as derating, NOT hidden',   'None'
'fading_sigma_dB',               params.fading_sigma_dB,            'Delivery',    'StandardsDerivable', 'Shadow-fading std ~5 dB magnitude (TR 37.885 NLOS)',                 'Weak'
% --- Constraint RHS ---
'v2x_reliability_floor_normal',  local_get(params,'v2x_reliability_floor_normal',0.50),   'Constraint','StandardsDerivable','TS 22.186 90% tier minus stated derating (derating=engineering)',  'Medium'
'v2x_reliability_floor_coop',    local_get(params,'v2x_reliability_floor_coop',0.65),     'Constraint','StandardsDerivable','TS 22.186 99.99% tier minus stated derating (derating=engineering)','Medium'
'v2x_reliability_floor_emergency',local_get(params,'v2x_reliability_floor_emergency',0.80),'Constraint','StandardsDerivable','TS 22.186 99.999% tier minus stated derating (derating=engineering)','Medium'
'deadline_coop_physical',        params.deadline_coop_physical,     'Scenario',    'StandardsDerivable', '~1.8x TS 22.186 cooperative 100 ms',                                 'Medium'
'deadline_emergency_physical',   params.deadline_emergency_physical,'Scenario',    'StandardsDerivable', '~1.4x ETSI TR 102 638 pre-crash 50 ms',                              'Medium'
'integrity_k_sigma',             local_get(params,'integrity_k_sigma',2.45),'Constraint','StandardsDerivable','PL=k*sigma; k=sqrt(-2 ln IR)=2.45 (R95, 2D-Rayleigh, IR=0.05)',     'Strong'
'integrity_alert_limit_road',    local_get(params,'integrity_alert_limit_road',8.0),'Constraint','StandardsDerivable','AV-integrity alert limit, warning/coarse-awareness tier (0.5-10 m)','Medium'
'protection_integrity_scale',    local_get(params,'protection_integrity_scale',0.55),'Constraint','EngineeringChoice','Integrity exceedance -> required-protection gain (saturation)',     'Weak'
'utility_required_protection_pos_scale',local_get(params,'utility_required_protection_pos_scale',0.55),'Constraint','EngineeringChoice','FALLBACK-ONLY now (active RHS = PL>AL integrity); affine slope eng.','Weak'
% --- Method: DPP (proposed) ---
'dpp_V',                         local_get(params,'dpp_V',2.0),     'Method',      'Structural',         'Neely 2010 DPP single knob O(1/V)-O(V); live default 2.0',           'Strong'
'dpp_horizon',                   local_get(params,'dpp_horizon',1), 'Method',      'Structural',         'MPC rolling-horizon look-ahead (1 = plain DPP); previews slow state','Medium'
'dpp_queue_max',                 local_get(params,'dpp_queue_max',20.0),'Method',  'Structural',         'Lindley virtual-queue cap = max constraint shadow price (live 20.0)','Medium'
'dpp_constraint_mode',           local_get(params,'dpp_constraint_mode',"consolidated"),'Method','Structural','TS 22.186 reliability consolidation: 5 constraints -> 2',         'Strong'
'risk_constrained_timely_lambda',local_get(params,'risk_constrained_timely_lambda',3.20),'Method','EngineeringChoice','DEPRECATED: replaced by reliability virtual queue (DPP)',   'Strong'
'risk_constrained_protection_lambda',local_get(params,'risk_constrained_protection_lambda',1.60),'Method','EngineeringChoice','DEPRECATED: replaced by protection virtual queue (DPP)','Strong'
'risk_constrained_success_reward_weight',local_get(params,'risk_constrained_success_reward_weight',0.45),'Method','EngineeringChoice','Dimensionless MRS preference weight (Marler&Arora form)','Weak'
'risk_v4_actual_cost_weight',    local_get(params,'risk_v4_actual_cost_weight',0.060),'Method','EngineeringChoice','Dimensionless MRS preference weight (Marler&Arora form)',     'Weak'
'risk_constrained_voi_bias',     local_get(params,'risk_constrained_voi_bias',0.65),'Method','EngineeringChoice','Howard 1966 VPI form; intercept/slopes engineering',           'Weak'
% --- Positioning / confidence fusion ---
'position_weight_gnss',          params.position_weight_gnss,       'Positioning', 'EngineeringChoice',  'CV2X-LOCA fusion mixing weight (framework only)',                   'Weak'
'qpos_fusion_w_sat',             0.25,                               'Positioning', 'EngineeringChoice',  'Confidence-rule blend (compute_positioning_confidence_rule:16)',     'Weak'
'coarse_sigma_fusion_gnss',      0.68,                               'Positioning', 'EngineeringChoice',  'Positioning fusion literal; replace with inverse-variance ~1/sigma^2','Weak'
'blind_zone_trigger_threshold',  params.blind_zone_trigger_threshold,'Positioning','DataCalibrated',     'Forest ROC/Youden (needs step43 artifact to be reproducible)',       'Medium'
'meters_per_degree',             111320,                             'Positioning', 'Grounded',           'Great-circle metres-per-degree constant',                            'Strong'
% --- Baseline schedulers (DISTINCT from the DPP-proposed method) ---
'lyapunov_V',                    local_get(params,'lyapunov_V',1.0),'Baseline',    'Structural',         'BASELINE Lyapunov V (never tuned) - DISTINCT from dpp_V=2.0',        'Strong'
'lyapunov_queue_max',            local_get(params,'lyapunov_queue_max',12.0),'Baseline','Structural',    'BASELINE Lyapunov cap - DISTINCT from dpp_queue_max=20.0',           'Medium'
'dcc_cbr_low_threshold',         local_get(params,'dcc_cbr_low_threshold',0.25),'Baseline','StandardsDerivable','ETSI EN 302 571 / TS 103 574 DCC CBR threshold (form; value eng.)','Weak'
'dcc_cbr_high_threshold',        local_get(params,'dcc_cbr_high_threshold',0.65),'Baseline','StandardsDerivable','ETSI DCC CBR high threshold (form; value engineering)',        'Weak'
'aoi_age_norm_cap',              local_get(params,'aoi_age_norm_cap',8.0),'Baseline','EngineeringChoice','Linear age/cap; should be Sun 2017 nonlinear g(Delta)',              'Weak'
% --- Scenario / action space ---
'urgency_emergency',             params.urgency_emergency,          'Scenario',    'EngineeringChoice',  'Synthetic urgency; standards-clean = message-type tag',             'Weak'
'utility_emergency_urgency_threshold',local_get(params,'utility_emergency_urgency_threshold',0.80),'Scenario','EngineeringChoice','Class boundary; NOTE pred_success/pred_gate HARDCODE 0.80, bypassing it','Weak'
'action_priority_set',           '[1 2 3]',                          'Scenario',    'StandardsDerivable', '3-level priority maps to C-V2X PPPP buckets',                        'Medium'
'action_rate_multiplier_set',    '[1.0 1.35 1.7 2.1 2.5]',           'Scenario',    'EngineeringChoice',  'Finite action-space design configuration',                          'Weak'
};

Parameter      = string(rows(:, 1));
Value          = cellfun(@(v) string(v), rows(:, 2));   % string col: tolerates "consolidated" etc.
Subsystem      = string(rows(:, 3));
Classification = string(rows(:, 4));
Source         = string(rows(:, 5));
Evidence       = string(rows(:, 6));

T = table(Parameter, Value, Subsystem, Classification, Source, Evidence);

if nargout == 0
    disp(T);
    classes = ["Grounded","StandardsDerivable","DataCalibrated","Structural","EngineeringChoice"];
    counts = arrayfun(@(c) sum(Classification == c), classes);
    sourced = sum(counts(1:4));      % all but EngineeringChoice
    fprintf(['Provenance summary (curated subset of %d rows): ' ...
        'Grounded %d, StandardsDerivable %d, DataCalibrated %d, Structural %d, ' ...
        'EngineeringChoice %d.\n'], height(T), counts(1), counts(2), counts(3), counts(4), counts(5));
    fprintf('Theoretically-sourced (non-EngineeringChoice): %d / %d = %.0f%% of this curated set.\n', ...
        sourced, height(T), 100 * sourced / height(T));
    fprintf(['NOTE: this is the curated paper-facing subset; the exhaustive ~300-field ' ...
        'enumeration + honest whole-framework fractions live in ' ...
        'parameter_provenance_completion_cn.md.\n']);
end
end

function v = local_get(params, name, default)
if isstruct(params) && isfield(params, name)
    v = params.(name);
else
    v = default;
end
end
