# Step57 参数可信度闭环报告

本报告用于说明最终 VTC 版本中的参数来源、证据强度和论文表述边界。该 Step 不重新调参、不重新运行仿真。

## 1. 外部资源检查

| Resource | Role | Exists | Size bytes |
|---|---|---|---:|
| USFS forest road shapefile | Road geometry / curvature / segment-length statistics | true | 556398584 |
| ForestPaths vegetation raster | Vegetation cover and attenuation severity proxy | true | 2469816 |
| Below-canopy point cloud | Canopy-density proxy for GNSS degradation | true | 92683103 |
| WiLabV2Xsim PER LOS table | PER lookup physical-layer calibration | true | 455 |
| WiLabV2Xsim PER NLOS table | PER lookup physical-layer calibration | true | 468 |

## 2. 参数类别、证据强度与论文边界

| Category | Source type | Evidence strength | Allowed claim | Forbidden claim |
|---|---|---|---|---|
| Scenario trajectory and topology | V2X-Seq scene metadata + generated scenario | Medium | Data-informed simulation scenarios | Do not claim real field driving experiment |
| PER lookup physical layer | External PER tables | Medium-High | PER-table-calibrated physical-layer lookup | Do not claim forest-measured V2X PER validation |
| Default physical deadlines | Engineering safety-deadline setting | Medium | Deadline-constrained safety-message evaluation | Do not claim regulatory deadline certification |
| Forest pathloss and attenuation | Forestry data statistics + literature-guided monotonic mapping | Medium | Forestry-data-informed attenuation model | Do not claim direct electromagnetic fitting |
| GNSS / positioning degradation | Vegetation raster + point-cloud proxy mapping | Medium | Canopy-informed positioning degradation model | Do not claim measured GNSS receiver calibration |
| Risk-constrained objective weights | Frozen engineering Lagrangian weights | Medium-Low | Risk-constrained online finite-action scheduler with frozen parameters | Do not claim globally optimal weights |
| DCC-like literature baseline | Literature-inspired standard-style baseline | Medium | ETSI-DCC-style comparison baseline | Do not claim full ETSI stack implementation |
| AoI-aware literature baseline | Literature-inspired freshness baseline | Medium | AoI-aware comparison baseline | Do not claim full AoI theory optimum |
| Constrained Oracle | Bounded-action diagnostic reference | DiagnosticOnly | Constrained oracle, not global optimum | Do not call it an unconstrained global oracle |

## 3. 关键参数值

| Parameter | Default | ForestGeometry | Source note |
|---|---:|---:|---|
| deadline_normal | 0.5 | 0.5 | Physical safety-message deadline setting used consistently across final PER lookup evidence |
| deadline_coop | 0.18 | 0.2 | Physical safety-message deadline setting used consistently across final PER lookup evidence |
| deadline_emergency | 0.07 | 0.077 | Physical safety-message deadline setting used consistently across final PER lookup evidence |
| final_physical_pdr_mode | per_lookup_forced_step49_step50_step54 | per_lookup_forced_step49_step50_step54 | Final Step49, Step50, and Step54 scripts explicitly force params.physical_pdr_mode to per_lookup |
| pathloss_los_exponent | 20 | 28.5 | Forest calibration: road curvature 0.1947, veg density 1.000 |
| pathloss_nlos_exponent | 24 | 37.5 | Forest calibration: road curvature 0.1947, veg density 1.000 |
| nlosv_extra_loss_dB | 5 | 7 | Forest calibration: road curvature 0.1947, veg density 1.000 |
| position_gnss_independent_noise_std | 0.08 | 0.13394 | Canopy proxy: point-cloud density 0.775, veg attenuation 1.000 |
| position_gnss_multipath_noise_std | 0.12 | 0.2099 | Canopy proxy: point-cloud density 0.775, veg attenuation 1.000 |
| utility_blind_protection_threshold | 0.58 | 0.49 | Default project parameter |
| utility_blind_pos_threshold | 0.48 | 0.53596 | Default project parameter |
| objective_timely_lambda | 3.20 | 3.20 | Objective default: risk_constrained_timely_lambda = 3.20 in compute_action_risk_constrained_objective_v4 |
| objective_success_lambda | 2.20 | 2.20 | Objective default: risk_constrained_success_lambda = 2.20 in compute_action_risk_constrained_objective_v4 |
| risk_v4_actual_cost_weight | 0.060 | 0.060 | V6 default actual-cost weight: 0.060 if not provided |
| risk_v6_emergency_floor | priority>=3, rate>=2.1x | priority>=3, rate>=2.1x | V6 emergency floor: priority >= 3 and rate multiplier >= 2.1 when urgency is emergency-level |
| dcc_cbr_low_threshold | 0.25 | 0.25 | DCC-style congestion threshold used as literature-inspired baseline parameter |
| dcc_cbr_high_threshold | 0.65 | 0.65 | DCC-style congestion threshold used as literature-inspired baseline parameter |
| aoi_age_norm_cap | 8 | 8 | AoI-aware freshness baseline parameter |
| aoi_critical_threshold | 0.8 | 0.8 | AoI-aware freshness baseline parameter |

## 4. 论文可用表述与禁用表述

| Claim | Allowed wording | Forbidden wording |
|---|---|---|
| The final physical-layer evidence uses PER lookup. | PER-table-calibrated physical-layer lookup | real forest V2X measurement validation |
| Forest geometry parameters are data-informed. | forestry-data-informed simulation | fully realistic forest propagation model |
| Risk-constrained-v6 is frozen for Step49-58. | frozen-parameter validation | globally optimal or adaptively tuned after seeing test scenes |
| DCC-like and AoI-aware are literature-inspired baselines. | ETSI-DCC-style and AoI-aware baseline comparisons | complete standards-compliant DCC stack or optimal AoI policy |
| Negative cases 10019/10013 are applicability boundaries. | boundary cases caused by deadline-reliability/cost trade-off | hide in averages or tune away the negative cases |

## 5. 审稿口径

1. 当前项目的真实性应表述为 `forestry-data-informed PER-lookup simulation`，不是实车或真实林区通信实测。
2. 风险约束权重是冻结工程权重，不能声称通过理论推导得到唯一最优值。
3. 参数可信度的核心证据来自 Step54/55/56 的冻结参数、多场景、held-out 和成本收益闭环。
4. 若投 VTC，建议在方法和实验设置中单独列出本报告的 allowed/forbidden wording，避免过度主张。
