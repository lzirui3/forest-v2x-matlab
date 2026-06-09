# Step62 VTC 修订版最终结果包报告

本结果包整合 Step58-Step61，面向 VTC/车辆通信会议论文结果部分。核心原则是：保留负例、限定 claim、不把 inspired baseline 写成完整 SOTA、不把仿真写成实车实验。

## 1. 生成文件

| Artifact | Purpose |
|---|---|
| `step62_vtc_revised_main_performance_table.csv` | PER lookup 口径主性能表 |
| `step62_vtc_revised_stronger_baseline_table.csv` | DCC/AoI inspired strengthened baselines 对比 |
| `step62_vtc_revised_moderate_forest_table.csv` | ModerateForestGeometry 中等退化补充结果 |
| `step62_vtc_revised_applicability_table.csv` | Effective / Graceful / Failure 适用边界 |
| `step62_vtc_revised_negative_boundary_table.csv` | 负例和边界场景保留表 |
| `step62_vtc_revised_cost_efficiency_table.csv` | 代价-收益证据表 |
| `step62_vtc_revised_paper_claim_boundary_table.csv` | 论文 claim 限定表 |
| `step62_vtc_revised_cost_efficiency_pareto.png` | 成本收益散点/Pareto 风格图 |

## 2. 主性能证据规模

- Main performance rows: 96
- Stronger baseline rows: 32
- Moderate forest rows: 64
- Applicability rows: 24
- Negative/boundary rows: 7
- Cost-efficiency rows: 112

## 3. 适用边界分类

| ApplicabilityClass | Count |
|---|---:|
| EffectiveRegime | 7 |
| FailureBoundary | 2 |
| GracefulDegradation | 15 |

## 4. 必须写入论文的 claim 边界

| Claim | Status | Evidence |
|---|---|---|
| Main method is a frozen-parameter finite-action online scheduler. | SupportedByCodeAndStep58To60 | run_step9_proposed_method -> Risk-constrained-v6; no retuning in Step59-62. |
| DCC/AoI baselines are inspired baselines, not full standards or optimal policies. | MustBeStatedAsClaimLimit | Step59/61 labels DCC-CBR-window and AoI-greedy as literature-inspired. |
| ForestGeometry is an extreme stress/boundary scenario. | SupportedByStep58NegativeBoundary | 7 Step61 boundary rows. |
| ModerateForestGeometry is deployable moderate degradation evidence. | SupportedByStep60 | step60_moderate_forest_geometry_50seed_* outputs. |
| Lyapunov is not the main theoretical proof. | MustBeStatedAsClaimLimit | Use risk-constrained utility/finite-action online scheduling as main method; Lyapunov only optional discussion. |
| Constrained Oracle is a bounded-action diagnostic reference, not a global oracle. | MustBeStatedAsClaimLimit | run_step9_baseline_oracle enumerates the same constrained action space. |
| Negative ForestGeometry cases are retained as applicability boundaries. | SupportedByStep61FailureBoundary | 21 small-gain/boundary interpretation rows. |

## 5. 负例处理方式

| Scene | Config | Boundary class | Timely delta (pp) | Emergency delta (pp) | Handling |
|---|---|---|---:|---:|---|
| 10006 | ForestGeometry | FailureBoundary | 0.522 | -0.007 | Retain as limitation/applicability boundary; do not tune away. |
| 10019 | ForestGeometry | FailureBoundary | -0.672 | -0.740 | Retain as limitation/applicability boundary; do not tune away. |
| 10013 | ForestGeometry | FailureBoundary | -0.459 | -0.536 | Retain as limitation/applicability boundary; do not tune away. |
| 10014 | ModerateForestGeometry | PhysicalEmergencyBoundary | 0.745 | -0.667 | Retain as limitation/applicability boundary; do not tune away. |
| 10006 | ModerateForestGeometry | GracefulDegradation | 0.087 | -1.342 | Retain as limitation/applicability boundary; do not tune away. |
| 10017 | ModerateForestGeometry | PhysicalEmergencyBoundary | 1.238 | -0.056 | Retain as limitation/applicability boundary; do not tune away. |
| 10013 | ModerateForestGeometry | GracefulDegradation | -0.133 | -0.356 | Retain as limitation/applicability boundary; do not tune away. |

## 6. VTC 写作口径

1. 主方法写作：`Risk-constrained-v6` 是 frozen-parameter finite-action online scheduler，基于风险约束效用/有限动作在线选择，不声称全局最优。
2. 基线写作：`DCC-like`、`DCC-CBR-window`、`AoI-aware`、`AoI-greedy` 均为 literature-inspired baselines，不是完整 ETSI DCC 协议栈或 AoI 最优策略。
3. 场景写作：`ForestGeometry` 是 extreme stress / boundary case；`ModerateForestGeometry` 是可部署中等退化补充场景。
4. 理论写作：Lyapunov 不作为主理论证明；主线应写成风险约束的有限动作在线调度。
5. Oracle 写作：`Constrained Oracle` 是同动作空间下的诊断参考，不是 global oracle。
6. 实验写作：本文是数据支撑仿真与 PER lookup 验证，不是实车或真实林区消防车实验。
