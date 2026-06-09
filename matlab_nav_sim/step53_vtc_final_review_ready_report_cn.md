# Step53 VTC 投稿前最终证据闭环报告

本报告用于 VTC 级别投稿前的最终内部审查。证据口径统一为 `PER lookup`，不再使用早期 sigmoid 结果作为最终物理层结论。

## 1. 输入证据

| Evidence | Prefix / file | Role |
|---|---|---|
| Step49 | `step49_per_lookup_final_validation_50seed_*` | 主场景 5 scenes x 2 configs x 50 seeds，PER lookup |
| Step50 | `step50_per_lookup_heldout_validation_50seed_*` | Held-out 3 scenes x 2 configs x 50 seeds，PER lookup |
| Step51 | `step51_per_lookup_applicability_evidence_*` | 最终适用范围分析 |
| Step52 | `step52_10019_forestgeometry_*` | 10019 ForestGeometry 负例诊断 |

## 2. 主场景 Step49 结果

| Scene | Config | Timely gain vs heuristic (pp) | Emergency gain (pp) | Timely gain vs link (pp) | Cost delta (%) | Decision |
|---|---|---:|---:|---:|---:|---|
| 10014 | Default | 0.343 | 0.000 | 5.724 | -4.40 | PerLookupWeak |
| 10014 | ForestGeometry | 1.032 | 0.333 | 1.181 | 9.40 | PerLookupStrong |
| 10006 | Default | 0.176 | 0.000 | 5.900 | 4.53 | PerLookupWeak |
| 10006 | ForestGeometry | 0.522 | -0.007 | 0.619 | 10.86 | PerLookupWeak |
| 10011 | Default | 0.123 | 0.000 | 0.233 | -3.63 | PerLookupWeak |
| 10011 | ForestGeometry | 4.100 | 0.100 | 12.889 | 7.31 | PerLookupStrong |
| 10019 | Default | 0.000 | 0.000 | 0.000 | 2.16 | PerLookupWeak |
| 10019 | ForestGeometry | -0.672 | -0.740 | -0.715 | -0.53 | PerLookupRisk |
| 10017 | Default | 0.173 | 0.000 | 11.085 | -3.77 | PerLookupWeak |
| 10017 | ForestGeometry | 0.619 | 0.000 | 0.905 | 12.12 | PerLookupWeak |

## 3. Held-out Step50 结果

| Scene | Config | Timely gain vs heuristic (pp) | Emergency gain (pp) | Timely gain vs link (pp) | Cost delta (%) | Decision |
|---|---|---:|---:|---:|---:|---|
| 10013 | Default | 0.000 | 0.000 | 0.023 | 2.54 | PerLookupHeldoutWeak |
| 10013 | ForestGeometry | -0.459 | -0.536 | -0.589 | 6.25 | PerLookupHeldoutBoundary |
| 10007 | Default | 0.063 | 0.000 | 3.957 | 2.90 | PerLookupHeldoutWeak |
| 10007 | ForestGeometry | 0.120 | 0.000 | 1.381 | 9.02 | PerLookupHeldoutWeak |
| 10015 | Default | 0.017 | 0.000 | 2.103 | -1.08 | PerLookupHeldoutWeak |
| 10015 | ForestGeometry | 2.789 | 0.000 | 6.602 | 12.98 | PerLookupHeldoutStrong |

## 4. 最终适用范围分类

| Applicability class | Count |
|---|---:|
| BaselineImprovement | 6 |
| WeakButSafe | 5 |
| PrimaryApplicable | 3 |
| BoundaryLimited | 2 |

### 逐场景结论

| Dataset | Scene | Config | Timely gain vs heuristic (pp) | Emergency gain (pp) | Timely gain vs link (pp) | Applicability | Note |
|---|---|---|---:|---:|---:|---|---|
| Main | 10006 | Default | 0.176 | 0.000 | 5.900 | BaselineImprovement | Gain is stronger versus link-only scheduling than versus the confidence heuristic. |
| Main | 10006 | ForestGeometry | 0.522 | -0.007 | 0.619 | WeakButSafe | Transfer is weak but nonnegative or near-nonnegative; report as safe boundary. |
| HeldOut | 10007 | Default | 0.063 | 0.000 | 3.957 | BaselineImprovement | Gain is stronger versus link-only scheduling than versus the confidence heuristic. |
| HeldOut | 10007 | ForestGeometry | 0.120 | 0.000 | 1.381 | BaselineImprovement | Gain is stronger versus link-only scheduling than versus the confidence heuristic. |
| Main | 10011 | Default | 0.123 | 0.000 | 0.233 | WeakButSafe | Transfer is weak but nonnegative or near-nonnegative; report as safe boundary. |
| Main | 10011 | ForestGeometry | 4.100 | 0.100 | 12.889 | PrimaryApplicable | PER lookup confirms clear benefit in forest/risk-degraded operating region. |
| HeldOut | 10013 | Default | 0.000 | 0.000 | 0.023 | WeakButSafe | Transfer is weak but nonnegative or near-nonnegative; report as safe boundary. |
| HeldOut | 10013 | ForestGeometry | -0.459 | -0.536 | -0.589 | BoundaryLimited | Small negative or boundary result; avoid all-scenario dominance claims. |
| Main | 10014 | Default | 0.343 | 0.000 | 5.724 | BaselineImprovement | Gain is stronger versus link-only scheduling than versus the confidence heuristic. |
| Main | 10014 | ForestGeometry | 1.032 | 0.333 | 1.181 | PrimaryApplicable | PER lookup confirms clear benefit in forest/risk-degraded operating region. |
| HeldOut | 10015 | Default | 0.017 | 0.000 | 2.103 | BaselineImprovement | Gain is stronger versus link-only scheduling than versus the confidence heuristic. |
| HeldOut | 10015 | ForestGeometry | 2.789 | 0.000 | 6.602 | PrimaryApplicable | PER lookup confirms clear benefit in forest/risk-degraded operating region. |
| Main | 10017 | Default | 0.173 | 0.000 | 11.085 | BaselineImprovement | Gain is stronger versus link-only scheduling than versus the confidence heuristic. |
| Main | 10017 | ForestGeometry | 0.619 | 0.000 | 0.905 | WeakButSafe | Transfer is weak but nonnegative or near-nonnegative; report as safe boundary. |
| Main | 10019 | Default | 0.000 | 0.000 | 0.000 | WeakButSafe | Transfer is weak but nonnegative or near-nonnegative; report as safe boundary. |
| Main | 10019 | ForestGeometry | -0.672 | -0.740 | -0.715 | BoundaryLimited | Small negative or boundary result; avoid all-scenario dominance claims. |

## 5. 10019 ForestGeometry 负例处理

Step52 将 `10019 / ForestGeometry` 归类为 `PerLookupRisk`，失败模式为 `DeadlineReliabilityTradeoff`。

核心证据：V6 improves packet loss versus heuristic but loses timely/emergency delivery, indicating deadline mismatch rather than pure reliability failure.

| Baseline | Metric | Baseline | V6 | Delta | Unit |
|---|---|---:|---:|---:|---|
| Confidence-heuristic | TimelyRate | 0.624526 | 0.617804 | -0.672 | pp |
| Confidence-heuristic | EmergencyTimelyRate | 0.586850 | 0.579451 | -0.740 | pp |
| Confidence-heuristic | LossRate | 0.320399 | 0.314143 | -0.626 | pp |
| Confidence-heuristic | AvgDelay | 0.040395 | 0.040899 | 1.249 | pct |
| Confidence-heuristic | AvgTxCost | 3.340623 | 3.323024 | -0.527 | pct |
| Link-delay-aware | TimelyRate | 0.624958 | 0.617804 | -0.715 | pp |
| Link-delay-aware | EmergencyTimelyRate | 0.587326 | 0.579451 | -0.788 | pp |
| Link-delay-aware | LossRate | 0.341431 | 0.314143 | -2.729 | pp |
| Link-delay-aware | AvgDelay | 0.039866 | 0.040899 | 2.593 | pct |
| Link-delay-aware | AvgTxCost | 2.841997 | 3.323024 | 16.926 | pct |
| Constrained Oracle | TimelyRate | 0.612446 | 0.617804 | 0.536 | pp |
| Constrained Oracle | EmergencyTimelyRate | 0.573553 | 0.579451 | 0.590 | pp |
| Constrained Oracle | LossRate | 0.312113 | 0.314143 | 0.203 | pp |
| Constrained Oracle | AvgDelay | 0.041240 | 0.040899 | -0.825 | pct |
| Constrained Oracle | AvgTxCost | 2.999965 | 3.323024 | 10.769 | pct |

## 6. 最终论文主张边界

可以主张：

1. 本文方法是面向林区应急 V2X 的在线有限动作风险约束调度方法，而不是全局最优或全场景支配方法。
2. 在 PER lookup 物理层下，方法在多个林区风险退化场景中获得明确收益，并在 held-out 场景中提供外部泛化证据。
3. 对于低风险、已饱和或短距密集遮挡导致 deadline-reliability tradeoff 失配的场景，方法应作为适用边界处理。

不能主张：

1. 不能声称方法在所有场景均显著优于全部基线。
2. 不能把 10019 ForestGeometry 隐藏在平均值中，或通过继续调参消除该负例。
3. 不能把 sigmoid 近似结果作为最终物理层证据的主口径。

## 7. VTC 投稿前状态判断

当前证据链已达到 VTC 会议仿真论文的基本闭环：主场景、多 seed、held-out、PER lookup、适用范围分析与负例诊断均有独立文件支撑。
剩余风险主要在论文写法：必须诚实限定适用范围，并将 10019 ForestGeometry 作为 boundary case，而不是包装成全局优势。
