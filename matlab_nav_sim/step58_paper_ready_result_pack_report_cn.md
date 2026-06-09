# Step58 VTC 可投稿结果包总报告

本报告汇总 Step54 至 Step57 的最终证据链。报告只整理既有 PER lookup 结果，不重新仿真，不调 Risk-constrained-v6 参数，也不覆盖 Step40/45/46/49/50/51/52/53 的历史结果。

## 1. 最终证据口径

| 项目 | 结论 |
|---|---|
| 最终物理层 | PER-table lookup，不使用 sigmoid 作为最终主证据 |
| 实验覆盖 | 8 scenes x 2 configs x 50 seeds x 6 methods |
| 主方法 | Risk-constrained-v6，参数冻结，不为负例继续调参 |
| 文献风格基线 | ETSI DCC-like、AoI-aware |
| 诊断上界 | Constrained Oracle，仅作为受约束诊断上界，不是全局最优 oracle |
| 真实性边界 | forestry-data-informed PER-lookup simulation，不是实车通信实测 |

## 2. 输出文件

| 文件 | 用途 |
|---|---|
| `step58_paper_ready_main_performance_table.csv` | 主性能表 |
| `step58_paper_ready_sota_baseline_table.csv` | DCC-like / AoI-aware 文献风格基线对比 |
| `step58_paper_ready_statistical_table.csv` | Holm 校正、effect size 与实践显著性 |
| `step58_paper_ready_cost_efficiency_table.csv` | 成本收益分析 |
| `step58_paper_ready_applicability_table.csv` | 适用范围表 |
| `step58_paper_ready_negative_boundary_table.csv` | 负例与边界场景表 |
| `step58_paper_ready_parameter_credibility_table.csv` | 参数可信度表 |
| `step58_paper_ready_overall_pareto.png` | Pareto trade-off 图 |
| `step58_paper_ready_delta_tradeoff.png` | 成本-收益差分图 |

## 3. 覆盖率审查

| Audit item | Observed | Expected | Pass |
|---|---:|---:|---|
| Step54 coverage rows | 96 | 96 | true |
| Step54 bad coverage rows | 0 | 0 | true |
| Step55 core rows | 96 | 96 | true |
| Step55 significance rows | 400 | 400 | true |
| Step55 interpretation rows | 80 | 80 | true |
| Step56 cost-efficiency rows | 64 | 64 | true |
| Step56 Pareto rows | 96 | 96 | true |
| Step57 final physical mode | 1 | 1 | true |
| Step57 V6 parameter rows | 1 | 1 | true |

### Step54 覆盖矩阵摘要

| Method | Cases | Min raw seeds | Min stage seeds |
|---|---:|---:|---:|
| Link-delay-aware | 16 | 50 | 50 |
| Confidence-heuristic | 16 | 50 | 50 |
| Risk-constrained-v6 | 16 | 50 | 50 |
| Constrained Oracle | 16 | 50 | 50 |
| DCC-like | 16 | 50 | 50 |
| AoI-aware | 16 | 50 | 50 |

## 4. 主性能与文献基线结论

Risk-constrained-v6 在若干林区风险场景中相对 DCC-like、AoI-aware、Link-delay-aware 或 Confidence-heuristic 存在有意义收益，但结果不是全场景支配。论文中应表述为“风险约束场景下的选择性优势”，而不是“所有场景全面最优”。

| Scene | Config | ΔTimely vs DCC (pp) | ΔTimely vs AoI (pp) | ΔTimely vs heuristic (pp) | ΔTimely vs link (pp) | Decision |
|---|---|---:|---:|---:|---:|---|
| 10014 | Default | 1.195 | 1.478 | 0.343 | 5.724 | LiteratureStrong |
| 10014 | ForestGeometry | -0.043 | 0.612 | 1.032 | 1.181 | LiteratureBoundary |
| 10006 | Default | 7.155 | 1.797 | 0.176 | 5.900 | LiteratureStrong |
| 10006 | ForestGeometry | 0.419 | 0.116 | 0.522 | 0.619 | LiteratureNonnegative |
| 10011 | Default | -0.486 | 0.190 | 0.123 | 0.233 | LiteratureBoundary |
| 10011 | ForestGeometry | 19.441 | -0.273 | 4.100 | 12.889 | LiteratureStrong |
| 10019 | Default | -0.013 | 0.193 | 0.000 | 0.000 | LiteratureBoundary |
| 10019 | ForestGeometry | 0.572 | -0.832 | -0.672 | -0.715 | LiteratureBoundary |
| 10017 | Default | 8.476 | 3.042 | 0.173 | 11.085 | LiteratureStrong |
| 10017 | ForestGeometry | 1.138 | -0.479 | 0.619 | 0.905 | LiteratureBoundary |
| 10013 | Default | -0.745 | 0.552 | 0.000 | 0.023 | LiteratureBoundary |
| 10013 | ForestGeometry | 0.872 | -0.103 | -0.459 | -0.589 | LiteratureBoundary |
| 10007 | Default | 6.899 | 1.787 | 0.063 | 3.957 | LiteratureStrong |
| 10007 | ForestGeometry | -0.466 | 0.908 | 0.120 | 1.381 | LiteratureBoundary |
| 10015 | Default | 3.298 | 1.478 | 0.017 | 2.103 | LiteratureStrong |
| 10015 | ForestGeometry | -0.809 | 4.865 | 2.789 | 6.602 | LiteratureBoundary |

## 5. 统计显著性与实践显著性

| Practical class | Count |
|---|---:|
| MeaningfulGain | 16 |
| WeakNonnegative | 33 |
| Boundary | 18 |
| CostlyGain | 11 |
| Risk | 2 |

统计表已使用 Holm-Bonferroni 口径。对小于 1% 的收益，论文中必须补充工程意义说明，不能只依赖 p-value。

## 6. 成本收益与 Pareto 结论

| Cost-efficiency class | Count |
|---|---:|
| DominantOrCostSaving | 22 |
| CostlyButMeaningful | 17 |
| WeakGainWithCost | 18 |
| CostInefficientBoundary | 6 |
| MixedBoundary | 1 |

Risk-constrained-v6 位于 Timely Pareto front 的场景配置数为 8 / 16。该结果可以作为成本-收益合理性的证据，但不能解释为全局最优。

## 7. 适用范围与边界负例

| Applicability class | Count |
|---|---:|
| BaselineImprovement | 6 |
| WeakButSafe | 5 |
| PrimaryApplicable | 3 |
| BoundaryLimited | 2 |

### 必须显式讨论的边界/负例

| Scene | Config | Baseline | ΔTimely (pp) | ΔEmergency (pp) | ΔCost (%) | Evidence |
|---|---|---|---:|---:|---:|---|
| 10006 | ForestGeometry | Confidence-heuristic | 0.522 | -0.007 | 10.86 | Step55 class: WeakNonnegative |
| 10019 | ForestGeometry | Confidence-heuristic | -0.672 | -0.740 | -0.53 | DeadlineReliabilityTradeoff: V6 improves packet loss versus heuristic but loses timely/emergency delivery, indicating deadline mismatch rather than pure reliability failure. |
| 10013 | ForestGeometry | Confidence-heuristic | -0.459 | -0.536 | 6.25 | Step55 class: Boundary |

Step52 对 10019 ForestGeometry 的诊断表明，该场景主要体现 deadline-reliability trade-off，不应通过继续调参消除。10013 ForestGeometry 同样应作为边界表现纳入适用性讨论。

## 8. 参数可信度边界

Step57 将参数划分为数据支撑、PER 表支撑、文献/模型启发、工程冻结权重和诊断上界几类。论文中必须避免把工程冻结参数写成实测标定结果。

| Resource | Exists | Size bytes |
|---|---:|---:|
| USFS forest road shapefile | 1 | 556398584 |
| ForestPaths vegetation raster | 1 | 2469816 |
| Below-canopy point cloud | 1 | 92683103 |
| WiLabV2Xsim PER LOS table | 1 | 455 |
| WiLabV2Xsim PER NLOS table | 1 | 468 |

### 关键参数口径

| Parameter | Default | ForestGeometry | Source note |
|---|---|---|---|
| final_physical_pdr_mode | per_lookup_forced_step49_step50_step54 | per_lookup_forced_step49_step50_step54 | Final Step49, Step50, and Step54 scripts explicitly force params.physical_pdr_mode to per_lookup |
| objective_timely_lambda | 3.20 | 3.20 | Objective default: risk_constrained_timely_lambda = 3.20 in compute_action_risk_constrained_objective_v4 |
| objective_success_lambda | 2.20 | 2.20 | Objective default: risk_constrained_success_lambda = 2.20 in compute_action_risk_constrained_objective_v4 |
| risk_v4_actual_cost_weight | 0.060 | 0.060 | V6 default actual-cost weight: 0.060 if not provided |
| risk_v6_emergency_floor | priority>=3, rate>=2.1x | priority>=3, rate>=2.1x | V6 emergency floor: priority >= 3 and rate multiplier >= 2.1 when urgency is emergency-level |

## 9. Constrained Oracle 使用边界

Constrained Oracle 只能作为有限动作集合、给定仿真模型和既定约束下的诊断上界。不能写成全局最优 oracle，也不能用它证明主方法达到理论最优。

## 10. 论文写作建议

可以主张：

1. 在 PER-table lookup 物理层和 8 个数据支撑场景下，Risk-constrained-v6 提供了风险约束应急消息调度的系统性证据链。
2. 与 DCC-like 和 AoI-aware 文献风格基线相比，方法在多个林区风险场景中具有可统计验证的收益。
3. 成本收益分析表明，部分收益来自额外通信成本，部分场景具有 cost-saving 或 Pareto-front 证据。
4. 10019 ForestGeometry 与 10013 ForestGeometry 是适用性边界，不是需要隐藏的异常点。

不能主张：

1. 方法全场景支配所有基线。
2. 当前结果来自真实林区实车通信测量。
3. Risk-constrained-v6 权重是全局最优估计。
4. Constrained Oracle 是无约束全局最优。

## 11. Step58 结论

当前结果包已经补齐 VTC 审稿最容易追问的四类证据：文献风格基线、统计严谨性、成本收益解释和参数可信度边界。项目可以进入论文写作与图表整理阶段，但写作时必须保持边界表述，尤其是对负例、工程冻结权重和非实测性质的限定。
