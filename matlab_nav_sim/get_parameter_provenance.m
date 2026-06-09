function T = get_parameter_provenance(params)
%GET_PARAMETER_PROVENANCE Single source of truth for parameter provenance.
%
%   T = GET_PARAMETER_PROVENANCE() returns a table documenting, for each
%   active-path parameter of the forest-V2X scheduler, its current value, the
%   subsystem it belongs to, a provenance classification, the theoretical
%   source, and the evidence strength. Use it to generate the paper's parameter
%   table and to keep claims consistent with the verified grounding audit
%   (parameter_theoretical_grounding_audit_cn.md).
%
%   Classification:
%     Grounded            - value derivable from a standard/physics constant.
%     DataCalibrated      - computed from external_data statistics.
%     StandardsDerivable  - currently set, maps cleanly to a known standard.
%     EngineeringChoice   - design preference; report with a sensitivity sweep,
%                           NOT a fabricated citation.
%   Evidence: Strong / Medium / Weak (per adversarial citation verification).
%
%   NOTE: under the drift-plus-penalty proposed method
%   (run_step9_proposed_method_dpp), the five frozen multipliers are REPLACED by
%   virtual queues and a single knob V; they are listed here as Deprecated.

if nargin < 1 || isempty(params)
    params = get_default_step9_params();
end

rows = {
% Name, Value, Subsystem, Classification, Source, Evidence
'tx_power_dBm',                  params.tx_power_dBm,                'PHY',         'Grounded',           '3GPP TS 36.101 C-V2X Power Class 3 (23 dBm)',                 'Strong'
'noise_floor_dBm',               params.noise_floor_dBm,            'PHY',         'Grounded',           '-174 dBm/Hz + 10log10(10MHz) + 10 dB NF',                     'Strong'
'pathloss_los_offset_dB',        params.pathloss_los_offset_dB,     'PHY',         'Grounded',           'Friis 1 m @5.9 GHz = 47.8 dB (TR 37.885 LOS intercept)',      'Strong'
'pathloss_los_exponent',         params.pathloss_los_exponent,      'PHY',         'Grounded',           'n_LOS = 2.0 free-space / TR 37.885 highway-LOS (10*n)',       'Strong'
'pathloss_nlos_exponent',        params.pathloss_nlos_exponent,     'PHY',         'StandardsDerivable', 'n_NLOS in TR 38.901 RMa-NLOS range (10*n)',                   'Medium'
'nlosv_extra_loss_dB',           params.nlosv_extra_loss_dB,        'PHY',         'StandardsDerivable', 'TR 37.885 sec.6.2.1 NLOSv mu=5/9 dB, sigma=4/4.5 dB',         'Strong'
'fast_fading_sigma_los',         params.fast_fading_sigma_los,      'PHY',         'StandardsDerivable', 'Rician K~3 dB dB-spread (TR 37.885 / Molisch Ch.7)',          'Medium'
'fast_fading_sigma_nlos',        params.fast_fading_sigma_nlos,     'PHY',         'StandardsDerivable', 'Rayleigh dB-spread ~5.5 dB (TR 37.885)',                      'Medium'
'pdr_midpoint_los',              params.pdr_midpoint_los,           'PHY',         'DataCalibrated',     'MCS required-SINR (WiLabV2Xsim PER fit)',                     'Medium'
'pdr_midpoint_nlos',             params.pdr_midpoint_nlos,          'PHY',         'DataCalibrated',     'MCS required-SINR (WiLabV2Xsim PER fit)',                     'Medium'
'pdr_slope_los',                 params.pdr_slope_los,              'PHY',         'EngineeringChoice',  'Empirical sigmoid steepness (PER roll-off)',                  'Weak'
'pdr_slope_nlos',                params.pdr_slope_nlos,             'PHY',         'EngineeringChoice',  'Empirical sigmoid steepness (PER roll-off)',                  'Weak'
'interference_scale',            params.interference_scale,         'PHY',         'EngineeringChoice',  'Co-channel interference abstraction (ideally SPS model)',     'Weak'
'base_access_delay',             params.base_access_delay,          'MAC',         'StandardsDerivable', 'SPS 1 ms TTI + grant period (value is engineering)',          'Medium'
'mode_overhead_redundant',       params.mode_overhead_redundant,    'MAC',         'StandardsDerivable', 'HARQ blind-retx subframe count (value engineering)',          'Medium'
'mode_overhead_relay',           params.mode_overhead_relay,        'MAC',         'StandardsDerivable', 'Relay decode-forward window (value engineering)',             'Medium'
'congestion_delay_max',          params.congestion_delay_max,       'MAC',         'EngineeringChoice',  'Max congestion delay (bare amplitude)',                       'Weak'
'deadline_normal_physical',      params.deadline_normal_physical,   'Scenario',    'StandardsDerivable', '~5x TS 22.185 100 ms / CAM staleness',                        'Medium'
'deadline_coop_physical',        params.deadline_coop_physical,     'Scenario',    'StandardsDerivable', '~1.8x TS 22.186 cooperative 100 ms',                          'Strong'
'deadline_emergency_physical',   params.deadline_emergency_physical,'Scenario',    'StandardsDerivable', '~1.4x ETSI TR 102 638 pre-crash 50 ms',                       'Strong'
'v2x_reliability_floor_normal',  local_get(params,'v2x_reliability_floor_normal',0.50),  'Constraint', 'StandardsDerivable', 'TS 22.186 90% tier minus stated derating',     'Strong'
'v2x_reliability_floor_coop',    local_get(params,'v2x_reliability_floor_coop',0.65),    'Constraint', 'StandardsDerivable', 'TS 22.186 99.99% tier minus stated derating',  'Strong'
'v2x_reliability_floor_emergency',local_get(params,'v2x_reliability_floor_emergency',0.80),'Constraint','StandardsDerivable','TS 22.186 99.999% tier minus stated derating','Strong'
'dpp_V',                         local_get(params,'dpp_V',1.0),     'Method',      'EngineeringChoice',  'Single drift-plus-penalty knob (O(1/V)-O(V) tradeoff)',       'Strong'
'risk_constrained_timely_lambda',local_get(params,'risk_constrained_timely_lambda',3.20),'Method','EngineeringChoice','DEPRECATED: replaced by reliability virtual queue',   'Strong'
'risk_constrained_protection_lambda',local_get(params,'risk_constrained_protection_lambda',1.60),'Method','EngineeringChoice','DEPRECATED: replaced by protection virtual queue','Strong'
'risk_constrained_success_reward_weight',local_get(params,'risk_constrained_success_reward_weight',0.45),'Method','EngineeringChoice','Dimensionless MRS preference weight','Weak'
'risk_v4_actual_cost_weight',    local_get(params,'risk_v4_actual_cost_weight',0.060),'Method','EngineeringChoice','Dimensionless MRS preference weight',             'Weak'
'utility_required_protection_pos_scale',local_get(params,'utility_required_protection_pos_scale',0.55),'Constraint','StandardsDerivable','Protection RHS, GNSS-integrity (PL>AL) shaped','Medium'
'position_weight_gnss',          params.position_weight_gnss,       'Positioning', 'EngineeringChoice',  'CV2X-LOCA fusion mixing weight (framework only)',             'Weak'
'urgency_emergency',             params.urgency_emergency,          'Scenario',    'EngineeringChoice',  'Synthetic urgency; standards-clean = message-type tag',       'Weak'
};

Parameter = string(rows(:, 1));
Value = cell2mat(rows(:, 2));
Subsystem = string(rows(:, 3));
Classification = string(rows(:, 4));
Source = string(rows(:, 5));
Evidence = string(rows(:, 6));

T = table(Parameter, Value, Subsystem, Classification, Source, Evidence);

if nargout == 0
    disp(T);
    n_ground = sum(Classification == "Grounded");
    n_std = sum(Classification == "StandardsDerivable");
    n_cal = sum(Classification == "DataCalibrated");
    n_eng = sum(Classification == "EngineeringChoice");
    fprintf(['Provenance summary: %d Grounded, %d StandardsDerivable, %d DataCalibrated, ' ...
        '%d EngineeringChoice (of %d shown).\n'], n_ground, n_std, n_cal, n_eng, height(T));
end
end

function v = local_get(params, name, default)
if isstruct(params) && isfield(params, name)
    v = params.(name);
else
    v = default;
end
end
