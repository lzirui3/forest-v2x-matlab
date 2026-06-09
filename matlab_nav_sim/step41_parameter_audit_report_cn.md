# Step41 参数可信度审计报告

本报告用于项目内部控制经验参数风险，不是论文正文草稿。

总参数数：295。

## 1. 参数分层统计

| Layer | Count |
|---|---:|
| Core-method | 30 |
| Scenario-definition | 24 |
| Simulation-environment | 40 |
| State-estimation-input | 37 |
| Baseline-only | 13 |
| Deprecated-or-legacy | 151 |

## 2. 需要优先处理的参数

| Priority | Parameter | Layer | Action | EvidenceStatus |
|---|---|---|---|---|
| P0 | `utility_emergency_urgency_threshold` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_protection_activation_blind` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_protection_activation_pos` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_protection_base` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_protection_blind_scale` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_protection_blind_shape` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_protection_link_scale` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_protection_max` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_protection_min` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_protection_pos_scale` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_protection_pos_shape` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_protection_urgency_scale` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_timely_bias` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_timely_blind_scale` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_timely_link_risk_scale` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_timely_max` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_timely_min` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_timely_pos_risk_scale` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_timely_qpos_high_threshold` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_timely_qpos_low_scale` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_timely_qpos_low_threshold` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_timely_qpos_mid_scale` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P0 | `utility_required_timely_urgency_scale` | Core-method | SensitivityAndJustification | Partial: structure exists; thresholds still need bounded sensitivity evidence. |
| P1 | `action_mode_set` | Core-method | AblationOrRangeCheck | Partial: cost efficiency evidence exists; action-space robustness still useful. |
| P1 | `action_priority_set` | Core-method | AblationOrRangeCheck | Partial: cost efficiency evidence exists; action-space robustness still useful. |
| P1 | `action_rate_multiplier_set` | Core-method | AblationOrRangeCheck | Partial: cost efficiency evidence exists; action-space robustness still useful. |
| P1 | `priority_rate_scale` | Core-method | AblationOrRangeCheck | Partial: cost efficiency evidence exists; action-space robustness still useful. |
| P1 | `tx_cost_direct` | Core-method | AblationOrRangeCheck | Partial: cost efficiency evidence exists; action-space robustness still useful. |
| P1 | `tx_cost_redundant` | Core-method | AblationOrRangeCheck | Partial: cost efficiency evidence exists; action-space robustness still useful. |
| P1 | `tx_cost_relay` | Core-method | AblationOrRangeCheck | Partial: cost efficiency evidence exists; action-space robustness still useful. |
| P1 | `deadline_coop` | Scenario-definition | ScenarioSensitivity | Partial: Step28 sensitivity exists; align future runs with proposed method. |
| P1 | `deadline_coop_physical` | Scenario-definition | ScenarioSensitivity | Partial: Step28 sensitivity exists; align future runs with proposed method. |
| P1 | `deadline_emergency` | Scenario-definition | ScenarioSensitivity | Partial: Step28 sensitivity exists; align future runs with proposed method. |
| P1 | `deadline_emergency_physical` | Scenario-definition | ScenarioSensitivity | Partial: Step28 sensitivity exists; align future runs with proposed method. |
| P1 | `deadline_guard_min_urgency` | Scenario-definition | ScenarioSensitivity | Partial: Step28 sensitivity exists; align future runs with proposed method. |
| P1 | `deadline_guard_ratio` | Scenario-definition | ScenarioSensitivity | Partial: Step28 sensitivity exists; align future runs with proposed method. |
| P1 | `deadline_normal` | Scenario-definition | ScenarioSensitivity | Partial: Step28 sensitivity exists; align future runs with proposed method. |
| P1 | `deadline_normal_physical` | Scenario-definition | ScenarioSensitivity | Partial: Step28 sensitivity exists; align future runs with proposed method. |
| P1 | `attempt_gap` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `base_access_delay` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `blind_interference_scale_dB` | Simulation-environment | SourceOrCalibration | Partial: forest calibration changes this parameter; verify source mapping. |
| P1 | `blind_link_loss_scale_dB` | Simulation-environment | SourceOrCalibration | Partial: forest calibration changes this parameter; verify source mapping. |
| P1 | `blind_zone_trigger_threshold` | Simulation-environment | SourceOrCalibration | Partial: forest calibration changes this parameter; verify source mapping. |
| P1 | `congestion_delay_max` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `emergency_sinr_bonus` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `fast_fading_sigma_los` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `fast_fading_sigma_nlos` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `interference_scale` | Simulation-environment | SourceOrCalibration | Partial: forest calibration changes this parameter; verify source mapping. |
| P1 | `link_distance_scale` | Simulation-environment | SourceOrCalibration | Partial: forest calibration changes this parameter; verify source mapping. |
| P1 | `mode_overhead_redundant` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `mode_overhead_relay` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `nlosv_extra_loss_dB` | Simulation-environment | SourceOrCalibration | Partial: forest calibration changes this parameter; verify source mapping. |
| P1 | `noise_floor_dBm` | Simulation-environment | SourceOrCalibration | Needs source or range citation if reported. |
| P1 | `pathloss_los_exponent` | Simulation-environment | SourceOrCalibration | Partial: forest calibration changes this parameter; verify source mapping. |
| P1 | `pathloss_los_offset_dB` | Simulation-environment | SourceOrCalibration | Partial: forest calibration changes this parameter; verify source mapping. |
| P1 | `pathloss_nlos_exponent` | Simulation-environment | SourceOrCalibration | Partial: forest calibration changes this parameter; verify source mapping. |
| P1 | `pathloss_nlos_offset_dB` | Simulation-environment | SourceOrCalibration | Partial: forest calibration changes this parameter; verify source mapping. |
| P1 | `pdr_midpoint_los` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `pdr_midpoint_nlos` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `pdr_slope_los` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `pdr_slope_nlos` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `per_curve_los_tag` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `per_curve_nlos_tag` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `priority_sinr_gain` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `relay_delay_penalty` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `relay_hop2_sinr_offset_dB` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `relay_link_ratio` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `relay_nlos_to_los_prob` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `relay_sinr_offset_dB` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `relay_success_bonus` | Simulation-environment | CrossValidateOrCite | Partial: PER lookup and relay random consistency evidence exists. |
| P1 | `tx_power_dBm` | Simulation-environment | SourceOrCalibration | Partial: forest calibration changes this parameter; verify source mapping. |
| P1 | `use_veg_attenuation` | Simulation-environment | SourceOrCalibration | Needs source or range citation if reported. |
| P1 | `veg_attenuation_base_coeff` | Simulation-environment | SourceOrCalibration | Needs source or range citation if reported. |
| P1 | `veg_attenuation_interference_coeff` | Simulation-environment | SourceOrCalibration | Needs source or range citation if reported. |
| P1 | `veg_attenuation_length_coeff` | Simulation-environment | SourceOrCalibration | Needs source or range citation if reported. |
| P1 | `veg_attenuation_scale` | Simulation-environment | SourceOrCalibration | Needs source or range citation if reported. |
| P1 | `veg_attenuation_score_coeff` | Simulation-environment | SourceOrCalibration | Needs source or range citation if reported. |
| P1 | `veg_attenuation_shadowing_coeff` | Simulation-environment | SourceOrCalibration | Needs source or range citation if reported. |

## 3. 项目内部处理原则

- P0 参数必须有校准、消融或敏感性证据，不能只靠工程直觉。
- P1 参数必须有来源、范围依据或跨场景敏感性验证。
- P2 参数作为状态输入构造参数，需要用消融证明其贡献。
- P3 参数只作为 baseline 或 scenario setting 报告，不作为创新点。
- P4 参数保留用于复现旧实验，但不进入主方法叙事。

## 4. 下一步建议

1. 对 `risk_constrained_*` 与 `risk_v6_*` 做小范围敏感性/校准闭环。
2. 用 Step40 50-seed 验证固定后的 Proposed Method。
3. 对 `deadline_*`、`pathloss_*`、`relay_*`、`veg_*` 做来源或范围表。
4. 旧 `utility_*` 中未被 v6 主方法直接依赖的参数降级为 legacy，不进入主方法贡献。
