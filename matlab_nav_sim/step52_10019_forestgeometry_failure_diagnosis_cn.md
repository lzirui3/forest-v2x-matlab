# Step52 负例诊断报告：10019 / ForestGeometry

证据来源：`step49_per_lookup_final_validation_50seed_*`。本脚本只读取 Step49 PER lookup 结果，不调整主方法参数。

## 1. 结论

该场景应作为方法适用边界，而不是被隐藏或继续调参修正。Step49 分类为 `PerLookupRisk`。

诊断模式：`DeadlineReliabilityTradeoff`。

V6 improves packet loss versus heuristic but loses timely/emergency delivery, indicating deadline mismatch rather than pure reliability failure.

## 2. Overall delta

| Baseline | Metric | Baseline | V6 | Delta | Delta unit |
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

## 3. Stage-level timely delta vs heuristic

| Stage | Heuristic | V6 | V6 - Heuristic (pp) |
|---|---:|---:|---:|
| Normal | 0.999360 | 0.999360 | 0.000 |
| Coop_1 | 0.909200 | 0.909467 | 0.027 |
| LinkDeg_Emerg | 0.758462 | 0.757231 | -0.123 |
| PosDeg_Emerg | 0.472182 | 0.434545 | -3.764 |
| Recovery | 0.084768 | 0.085695 | 0.093 |
| Full | 0.624526 | 0.617804 | -0.672 |

## 4. Statistical rows

| Comparison | Metric | Delta mean | Delta pct/pp | Holm-family p | Effect RBC | Practical note |
|---|---|---:|---:|---|---:|---|
| HeuristicVsV6 | TimelyRate | -0.006722 | -0.672 | p = 2.887e-13 | -0.880 | Below1pp |
| HeuristicVsV6 | LossRate | -0.006256 | -0.626 | p = 1.163e-07 | -0.748 | Below1pp |
| HeuristicVsV6 | AvgDelay | 0.000505 | 1.249 | p < 1e-15 | 0.997 | Sub-ms |
| HeuristicVsV6 | AvgTxCost | -0.017599 | -0.527 | p = 0.4588 | -0.302 | SeeDelta |
| HeuristicVsV6 | EmgTimely | -0.007399 | -0.740 | p = 2.887e-13 | -0.880 | Below1pp |
| LinkVsV6 | TimelyRate | -0.007155 | -0.715 | p < 1e-15 | -0.957 | Below1pp |
| LinkVsV6 | LossRate | -0.027288 | -2.729 | p < 1e-15 | -1.000 | Meaningful |
| LinkVsV6 | AvgDelay | 0.001034 | 2.593 | p < 1e-15 | 1.000 | Meaningful |
| LinkVsV6 | AvgTxCost | 0.481027 | 16.926 | p < 1e-15 | 1.000 | SeeDelta |
| LinkVsV6 | EmgTimely | -0.007875 | -0.788 | p < 1e-15 | -0.957 | Below1pp |
| V6VsOracle | TimelyRate | -0.005358 | -0.536 | p = 1.047e-09 | -0.828 | Below1pp |
| V6VsOracle | LossRate | -0.002030 | -0.203 | p = 0.506 | -0.328 | Below1pp |
| V6VsOracle | AvgDelay | 0.000340 | 0.831 | p < 1e-15 | 0.972 | Sub-ms |
| V6VsOracle | AvgTxCost | -0.323059 | -9.722 | p < 1e-15 | -1.000 | SeeDelta |
| V6VsOracle | EmgTimely | -0.005897 | -0.590 | p = 1.047e-09 | -0.828 | Below1pp |

## 5. 论文处理建议

1. 不要删除 10019 ForestGeometry；它是审稿人会要求看到的负例边界。
2. 不要把该场景并入平均值后只报告整体均值；需要在适用范围分析中单列。
3. 推荐表述为：短距密集遮挡条件下，风险约束调度可能提高投递可靠性但牺牲 deadline satisfaction，因此方法适用于“遮挡、定位退化、链路退化与应急窗口重叠且仍存在及时性提升空间”的场景。
