function params = get_default_step9_params()
%GET_DEFAULT_STEP9_PARAMS Default parameters for Step 9 confidence-driven scheduling.

params.dt = 1.0;
params.T_total = 120.0;

params.urgency_normal = 0.30;
params.urgency_coop = 0.60;
params.urgency_emergency = 0.95;

params.base_rate_normal = 1.0;
params.base_rate_coop = 2.0;
params.base_rate_emergency = 1.5;

params.alpha = 0.45;
params.beta = 0.30;
params.gamma = 0.25;

params.T1 = 0.45;
params.T2 = 0.72;
params.pos_T1 = 0.42;
params.pos_T2 = 0.68;

params.link_good_threshold = 0.65;
params.link_bad_threshold = 0.35;
params.pos_low_threshold = 0.40;

params.priority_rate_scale = [1.0, 1.5, 2.0];
params.noncritical_suppression_scale = 0.70;

params.tx_cost_direct = 1.0;
params.tx_cost_redundant = 1.6;
params.tx_cost_relay = 1.8;

params.deadline_normal = 0.50;
params.deadline_coop = 0.24;
params.deadline_emergency = 0.088;

params.base_delay = 0.05;
params.link_delay_scale = 0.45;
params.redundant_delay_penalty = 0.08;
params.relay_delay_penalty = 0.12;

params.base_success_bias = -0.02;
params.critical_priority_bonus = 0.03;
params.redundant_success_bonus = 0.10;
params.relay_success_bonus = 0.15;
params.position_risk_penalty = 0.14;
params.abstract_priority_bonus_per_level = 0.05;
params.abstract_rate_bonus_scale = 0.03;
params.abstract_redundant_gate_bonus = 0.05;
params.abstract_confidence_protection_high = 0.14;
params.abstract_confidence_protection_mid = 0.08;
params.abstract_confidence_protection_direct = 0.04;
params.emergency_gate_reduction = 0.03;

params.link_gate_weight = 0.48;
params.pos_gate_weight = 0.16;
params.urgency_gate_weight = 0.08;
params.mode_gate_bonus = 0.10;
params.priority_gate_bonus = 0.02;

params.position_rsu_x = [22.0, 64.0, 96.0, 142.0];
params.position_rsu_y = [8.0, -9.0, 10.0, -8.0];
params.position_rsu_coverage = [58.0, 52.0, 46.0, 62.0];
params.position_support_threshold = 0.18;
params.position_env_peak_time = 78.0;
params.position_weight_gnss = 0.45;
params.position_weight_rsu = 0.22;
params.position_weight_env = 0.15;
params.position_weight_traj = 0.18;
params.position_filter_process_noise = 0.06;
params.position_filter_velocity_noise = 0.03;
params.position_blind_zone_sigma_penalty = 1.20;
params.position_blind_zone_score_penalty = 0.22;
params.position_rsu_relief_cap = 0.82;
params.position_alpha_base = 0.42;
params.position_alpha_delta_scale = 0.28;
params.position_alpha_traj_scale = 0.18;
params.position_alpha_blind_scale = 0.22;
params.position_alpha_min = 0.35;
params.position_alpha_max = 0.95;

% GNSS 独立噪声参数（与 sidelink 无线电链路解耦）
params.position_gnss_independent_noise_std = 0.08;   % 电离层闪烁对 GNSS 置信度的扰动标准差
params.position_gnss_independent_temporal_len = 12;  % 电离层闪烁时间相关长度（样本数）
params.position_gnss_multipath_noise_std = 0.12;     % GNSS 多径对定位误差的独立扰动（米缩放）
params.position_gnss_multipath_temporal_len = 8;     % GNSS 多径时间相关长度（样本数）

params.blind_zone_trigger_threshold = 0.55;
params.rsu_event_trigger_threshold = 0.45;
params.env_event_trigger_threshold = 0.22;
params.event_rate_scale_gain = 0.22;
params.event_priority_bias = 0.06;
params.event_synergy_gain = 0.45;

params.action_priority_set = [1, 2, 3];
params.action_mode_set = [0, 1, 2];
params.action_rate_multiplier_set = [1.0, 1.35, 1.7, 2.1, 2.5];
params.baseline_rate_multiplier_by_priority = [1.0, 1.7, 2.5];

params.utility_weight_timely = 1.00;
params.utility_weight_reliability = 0.55;
params.utility_weight_cost = 0.07;
params.utility_weight_delay = 0.10;
params.utility_weight_position_risk = 0.28;
params.utility_weight_misdecision = 0.22;
params.utility_weight_event = 0.22;
params.utility_priority_bias = [0.00, 0.08, 0.18];
params.utility_mode_bias = [0.00, 0.05, 0.09];
params.utility_noncritical_suppression = 0.08;
params.utility_risk_tradeoff_scale = 0.35;
params.utility_sigmoid_scale = 0.035;
params.utility_min_priority_when_emergency = 2;
params.utility_min_priority_when_high_risk = 2;
params.utility_force_mode_when_relay = true;
params.utility_constraint_penalty = 1.60;
params.utility_margin_sigmoid_scale = 0.060;
params.utility_required_timely_bias = 0.18;
params.utility_required_timely_urgency_scale = 0.34;
params.utility_required_timely_link_risk_scale = 0.20;
params.utility_required_timely_pos_risk_scale = 0.16;
params.utility_required_timely_blind_scale = 0.14;
params.utility_required_timely_min = 0.25;
params.utility_required_timely_max = 0.92;
params.utility_required_timely_qpos_high_threshold = 0.75;
params.utility_required_timely_qpos_low_threshold = 0.50;
params.utility_required_timely_qpos_mid_scale = 0.50;
params.utility_required_timely_qpos_low_scale = 1.00;
params.utility_required_protection_activation_pos = 0.45;
params.utility_required_protection_activation_blind = 0.22;
params.utility_required_protection_base = 0.00;
params.utility_required_protection_pos_scale = 0.55;
params.utility_required_protection_blind_scale = 0.35;
params.utility_required_protection_urgency_scale = 0.12;
params.utility_required_protection_link_scale = 0.10;
params.utility_required_protection_min = 0.08;
params.utility_required_protection_max = 0.82;
params.utility_required_protection_pos_shape = 1.35;
params.utility_required_protection_blind_shape = 1.20;
params.utility_surplus_penalty_activation = 0.20;
params.utility_surplus_penalty_timely_scale = 0.45;
params.utility_surplus_penalty_protection_scale = 0.30;
params.utility_surplus_penalty_timely_margin = 0.15;
params.utility_surplus_penalty_protection_margin = 0.05;
params.utility_surplus_penalty_cost_scale = 0.80;
params.utility_surplus_penalty_priority_scale = 0.70;
params.utility_surplus_penalty_mode_scale = 0.50;
params.utility_module_support_weight_rsu = 0.55;
params.utility_module_support_weight_env = 0.30;
params.utility_module_support_weight_traj = 0.15;
params.utility_event_base_gain = 0.55;
params.utility_position_risk_base = 0.50;
params.utility_position_risk_urgency_scale = 0.35;
params.utility_misdecision_qpos_threshold = 0.60;
params.utility_misdecision_blind_threshold = 0.20;
params.utility_misdecision_blind_scale = 1.20;
params.utility_misdecision_urgency_scale = 0.70;
params.utility_misdecision_target_protection = 0.55;
params.utility_relay_penalty = 0.25;
params.utility_support_mismatch_penalty_relay = 0.18;
params.utility_support_mismatch_penalty_redundant = 0.05;
params.utility_low_quality_priority_penalty = 0.30;
params.utility_emergency_priority_bonus = 0.05;
params.utility_low_risk_guard_threshold = 0.32;
params.utility_low_risk_rate_penalty_scale = 0.22;
params.utility_low_risk_priority_penalty_scale = 0.12;
params.utility_low_risk_relay_penalty = 0.55;
params.utility_low_risk_blind_threshold = 0.18;
params.utility_blind_protection_threshold = 0.58;
params.utility_blind_pos_threshold = 0.48;
params.utility_blind_min_priority = 2;
params.utility_blind_force_mode = 1;
params.utility_blind_relay_threshold = 0.78;
params.confidence_regime_blind_threshold = 0.18;
params.confidence_regime_qpos_threshold = 0.72;
params.confidence_regime_hold_blind_threshold = 0.42;
params.confidence_regime_hold_qpos_threshold = 0.52;
params.utility_event_activation_threshold = 0.12;
params.utility_position_activation_threshold = 0.18;
params.utility_protection_priority_weight = 0.30;
params.utility_protection_rate_weight = 0.35;
params.utility_protection_mode_weight = 0.35;
params.utility_mode_level_relay = 1.0;
params.utility_mode_level_redundant = 0.62;
params.utility_mode_level_direct = 0.20;

% 效用函数中的关键阈值参数（从硬编码提取，支持敏感性分析）
% emergency 判定阈值：urgency >= 此值视为紧急消息
params.utility_emergency_urgency_threshold = 0.80;
% low_risk_score 三分量权重：urgency / (1-q_link) / (1-q_pos)
% 用于判断当前时刻总体风险水平，低于阈值时抑制过度传输
params.utility_low_risk_weight_urgency = 0.45;
params.utility_low_risk_weight_link = 0.30;
params.utility_low_risk_weight_pos = 0.25;
% redundant 模式冗余抑制条件阈值
params.utility_redundant_blind_threshold = 0.10;   % blind_zone_gain 低于此值
params.utility_redundant_qpos_threshold = 0.65;     % q_pos 高于此值时抑制冗余传输

% P5 guard: suppress costly protection when it cannot fit the timely budget
% or when the predicted link is already reliable enough.
params.deadline_guard_ratio = 0.82;
params.deadline_guard_min_urgency = 0.80;
params.regime_pdr_bypass_threshold = 0.95;
params.regime_pdr_bypass_min_blind_score = 0.0;

% Phase 3: Channel fading and delay jitter (stochastic delivery model)
params.fading_sigma_dB = 5.0;       % shadow fading std dev in dB
params.delay_jitter_scale = 0.15;   % delay jitter as fraction of nominal delay
params.enable_stochastic = true;    % set false to revert to deterministic model

% Phase 4: Physical delivery model parameters
params.use_physical_delivery = false;  % false = backward compatible
params.physical_pdr_mode = "sigmoid";

% Priority / emergency SINR gain (resource allocation advantage)
params.priority_sinr_gain = 0.5;
params.emergency_sinr_bonus = 1.0;

% Fast fading (per-packet, Rayleigh/Rician)
% 物理依据：快衰落是每包独立的小尺度衰落，与大尺度阴影衰落（已含在 sinr_dB 中）正交
% LOS: Rician fading, K-factor ≈ 3 dB (典型 V2X highway/rural)
%   理论 dB spread: σ ≈ 5.57/sqrt(1+K_linear) ≈ 5.57/sqrt(3) ≈ 2.2 dB
%   取 2.0 dB 偏保守（考虑 C-V2X 子帧内频率分集增益）
% NLOS: Rayleigh fading (K=0)
%   理论 dB spread: σ ≈ 5.57 dB (20*log10(Rayleigh) 的标准差)
%   取 5.0 dB（考虑 OFDM 子载波分集后的等效值）
% 参考: 3GPP TR 37.885 Table 6.2.3-1, Molisch "Wireless Communications" Ch.7
params.fast_fading_sigma_los = 2.0;
params.fast_fading_sigma_nlos = 5.0;
params.enable_fast_fading = true;

% Relay link quality
params.relay_link_ratio = 0.80;         % relay hop PDR relative to direct (抽象模型后备)

% 物理中继模型参数（两跳独立信道）
params.relay_sinr_offset_dB = 2.5;     % Source->Relay 第一跳 SINR 增益（中继距离更近）
params.relay_hop2_sinr_offset_dB = 1.5; % Relay->Dest 第二跳 SINR 增益
params.relay_nlos_to_los_prob = 0.35;   % 直通 NLOS 时中继恢复 LOS 的概率（空间分集优势）

% Physical delay model (C-V2X sidelink timing)
params.base_access_delay = 0.012;
params.mode_overhead_redundant = 0.012;
params.mode_overhead_relay = 0.030;
params.congestion_delay_max = 0.045;
params.attempt_gap = 0.014;

% SINR->PDR sigmoid approximation (fitted to WiLabV2Xsim PER curves)
params.pdr_midpoint_los = 4.0;
params.pdr_midpoint_nlos = 6.0;
params.pdr_slope_los = 0.9;
params.pdr_slope_nlos = 0.7;

% Physical deadlines.
% Re-anchored to standardized V2X latency requirements, expressed as explicit
% engineering-margin multiples of the standard value (NOT clause values):
%   normal     : 0.50 s  ~= 5x  the TS 22.185 general 100 ms latency
%                          (or the ETSI EN 302 637-2 CAM staleness bound ~0.5-1.0 s)
%   coop       : 0.18 s  ~= 1.8x the TS 22.186 cooperative 100 ms latency
%   emergency  : 0.070 s ~= 1.4x the ETSI TR 102 638 pre-crash 50 ms warning
% Margins (>1x) reflect end-to-end stack + forest-channel slack beyond the raw
% air-interface requirement. See get_v2x_reliability_requirements.m for the
% paired reliability tiers, and parameter_theoretical_grounding_audit_cn.m.
params.deadline_normal_physical = 0.50;
params.deadline_coop_physical = 0.18;
params.deadline_emergency_physical = 0.070;

% Rural/forest-oriented physical link defaults.
% Provenance (verified, see parameter_theoretical_grounding_audit_cn.md sec. 3.5):
%   tx_power_dBm = 23  : C-V2X UE Power Class 3 max output (3GPP TS 36.101).
%   noise_floor_dBm = -94 : thermal floor -174 dBm/Hz + 10*log10(10e6 Hz)
%                           + 10 dB receiver noise figure = -94 dBm (10 MHz BW).
%   pathloss_los_offset_dB = 47 : free-space loss at 1 m, 5.9 GHz,
%                           20*log10(4*pi*fc/c) = 47.8 dB (Friis); equivalently
%                           the 3GPP TR 37.885 LOS intercept 32.4 + 20*log10(fc[GHz]).
%   pathloss_los_exponent = 20  : path-loss exponent n_LOS = 2.0 (free-space /
%                           TR 37.885 highway-LOS), stored as 10*n in dB/decade.
%   pathloss_nlos_exponent = 24 : n_NLOS = 2.4, within the TR 38.901 RMa-NLOS
%                           range n in [2.7, 3.9] floor side; rural NLOS.
%   nlosv_extra_loss_dB = 5 : TR 37.885 sec. 6.2.1 vehicle-blockage (NLOSv) extra
%                           loss, mu = 5 dB single blocker / 9 dB high blockage,
%                           sigma = 4-4.5 dB. (Forest calibration scales 3.5..7.)
% NOTE on shadow fading attribution (do not mis-state in the paper): TR 37.885
% LOS shadow-fading sigma = 3 dB, and NLOSv REUSES the LOS shadowing (3 dB); the
% 4 dB figure belongs to the NLOS row's shadow fading, while 4/4.5 dB is the
% NLOSv blockage log-normal sigma -- NOT an "NLOSv shadow fading = 4 dB".
% NOTE on vegetation models: at 5.9 GHz use ITU-R P.833 / Weissberger
% (L = 1.33*f^0.284*d^0.588, 230 MHz-95 GHz). COST 235 (9.6-57.6 GHz) and
% FITU-R (10-40 GHz) do NOT cover 5.9 GHz and must not be cited as the basis.
params.tx_power_dBm = 23.0;
params.noise_floor_dBm = -94.0;
params.pathloss_los_offset_dB = 47.0;
params.pathloss_los_exponent = 20.0;
params.pathloss_nlos_offset_dB = 50.0;
params.pathloss_nlos_exponent = 24.0;
params.nlosv_extra_loss_dB = 5.0;
params.interference_scale = 1.8;
params.link_distance_scale = 1.0;
params.blind_link_loss_scale_dB = 5.5;
params.blind_interference_scale_dB = 2.5;
params.per_curve_los_tag = "highway_los";
params.per_curve_nlos_tag = "urban_nlos";
params.use_veg_attenuation = false;
params.veg_attenuation_scale = 1.0;
params.veg_attenuation_base_coeff = 0.8;
params.veg_attenuation_score_coeff = 1.6;
params.veg_attenuation_length_coeff = 1.0;
params.veg_attenuation_shadowing_coeff = 0.65;
params.veg_attenuation_interference_coeff = 0.18;

params.scenario_input.mode = "fallback";
params.scenario_input.trajectory_file = "";
params.scenario_input.rsu_layout_file = "";
params.scenario_input.blockage_profile_file = "";
params.scenario_input.gnss_config_file = "";
params.scenario_input.message_profile_file = "";
params.scenario_input.strict_external = false;
params.scenario_input.interp_method = "linear";
params.scenario_input.template_name = "forest_demo";

% Lyapunov drift-plus-penalty scheduling parameters
params.lyapunov_V = 1.0;
params.lyapunov_queue_init = 0.0;
params.lyapunov_queue_arrival_scale = 1.0;
params.lyapunov_queue_service_scale = 1.0;
params.lyapunov_queue_max = 12.0;
params.lyapunov_cost_weight = 1.0;
params.lyapunov_delay_weight = 1.0;
params.lyapunov_risk_weight = 1.0;
params.lyapunov_event_weight = 1.0;
params.lyapunov_violation_weight = 1.0;

% Literature-inspired baseline parameters
params.dcc_cbr_low_threshold = 0.25;
params.dcc_cbr_high_threshold = 0.65;
params.dcc_rate_multiplier_low = 1.0;
params.dcc_rate_multiplier_mid = 1.35;
params.dcc_rate_multiplier_high = 1.7;
params.dcc_emergency_priority = 3;
params.dcc_coop_priority = 2;
params.dcc_direct_mode_threshold = 0.30;
params.aoi_age_norm_cap = 8.0;
params.aoi_high_threshold = 0.55;
params.aoi_critical_threshold = 0.80;
params.aoi_default_mode = 0;
params.aoi_redundant_threshold = 0.55;
end
