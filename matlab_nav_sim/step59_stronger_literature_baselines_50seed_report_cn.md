# Step59 强化文献启发基线对比报告

本步骤在最终 PER lookup 口径下新增 `DCC-CBR-window` 与 `AoI-greedy` 两个更强的文献启发基线，并合并 Step54 的冻结证据。该步骤不修改 Risk-constrained-v6 参数，不覆盖 Step54-58。

注意：这些方法仍然是 DCC/AoI-inspired baselines，不是完整 ETSI DCC 协议栈，也不是 AoI 最优策略。

每个 scene/config 的随机种子数：50。

## 1. 覆盖率检查

| Scene | Config | Method | Raw seeds | Stage seeds | Raw rows | Stage rows |
|---|---|---|---:|---:|---:|---:|
| 10014 | Default | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10014 | Default | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10014 | Default | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10014 | Default | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10014 | Default | DCC-like | 50 | 50 | 50 | 300 |
| 10014 | Default | AoI-aware | 50 | 50 | 50 | 300 |
| 10014 | Default | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10014 | Default | AoI-greedy | 50 | 50 | 50 | 300 |
| 10014 | ForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10014 | ForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10014 | ForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10014 | ForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10014 | ForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10014 | ForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10014 | ForestGeometry | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10014 | ForestGeometry | AoI-greedy | 50 | 50 | 50 | 300 |
| 10006 | Default | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10006 | Default | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10006 | Default | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10006 | Default | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10006 | Default | DCC-like | 50 | 50 | 50 | 300 |
| 10006 | Default | AoI-aware | 50 | 50 | 50 | 300 |
| 10006 | Default | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10006 | Default | AoI-greedy | 50 | 50 | 50 | 300 |
| 10006 | ForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10006 | ForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10006 | ForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10006 | ForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10006 | ForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10006 | ForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10006 | ForestGeometry | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10006 | ForestGeometry | AoI-greedy | 50 | 50 | 50 | 300 |
| 10011 | Default | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10011 | Default | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10011 | Default | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10011 | Default | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10011 | Default | DCC-like | 50 | 50 | 50 | 300 |
| 10011 | Default | AoI-aware | 50 | 50 | 50 | 300 |
| 10011 | Default | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10011 | Default | AoI-greedy | 50 | 50 | 50 | 300 |
| 10011 | ForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10011 | ForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10011 | ForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10011 | ForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10011 | ForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10011 | ForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10011 | ForestGeometry | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10011 | ForestGeometry | AoI-greedy | 50 | 50 | 50 | 300 |
| 10019 | Default | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10019 | Default | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10019 | Default | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10019 | Default | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10019 | Default | DCC-like | 50 | 50 | 50 | 300 |
| 10019 | Default | AoI-aware | 50 | 50 | 50 | 300 |
| 10019 | Default | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10019 | Default | AoI-greedy | 50 | 50 | 50 | 300 |
| 10019 | ForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10019 | ForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10019 | ForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10019 | ForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10019 | ForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10019 | ForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10019 | ForestGeometry | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10019 | ForestGeometry | AoI-greedy | 50 | 50 | 50 | 300 |
| 10017 | Default | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10017 | Default | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10017 | Default | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10017 | Default | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10017 | Default | DCC-like | 50 | 50 | 50 | 300 |
| 10017 | Default | AoI-aware | 50 | 50 | 50 | 300 |
| 10017 | Default | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10017 | Default | AoI-greedy | 50 | 50 | 50 | 300 |
| 10017 | ForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10017 | ForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10017 | ForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10017 | ForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10017 | ForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10017 | ForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10017 | ForestGeometry | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10017 | ForestGeometry | AoI-greedy | 50 | 50 | 50 | 300 |
| 10013 | Default | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10013 | Default | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10013 | Default | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10013 | Default | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10013 | Default | DCC-like | 50 | 50 | 50 | 300 |
| 10013 | Default | AoI-aware | 50 | 50 | 50 | 300 |
| 10013 | Default | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10013 | Default | AoI-greedy | 50 | 50 | 50 | 300 |
| 10013 | ForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10013 | ForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10013 | ForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10013 | ForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10013 | ForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10013 | ForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10013 | ForestGeometry | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10013 | ForestGeometry | AoI-greedy | 50 | 50 | 50 | 300 |
| 10007 | Default | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10007 | Default | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10007 | Default | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10007 | Default | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10007 | Default | DCC-like | 50 | 50 | 50 | 300 |
| 10007 | Default | AoI-aware | 50 | 50 | 50 | 300 |
| 10007 | Default | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10007 | Default | AoI-greedy | 50 | 50 | 50 | 300 |
| 10007 | ForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10007 | ForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10007 | ForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10007 | ForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10007 | ForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10007 | ForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10007 | ForestGeometry | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10007 | ForestGeometry | AoI-greedy | 50 | 50 | 50 | 300 |
| 10015 | Default | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10015 | Default | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10015 | Default | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10015 | Default | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10015 | Default | DCC-like | 50 | 50 | 50 | 300 |
| 10015 | Default | AoI-aware | 50 | 50 | 50 | 300 |
| 10015 | Default | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10015 | Default | AoI-greedy | 50 | 50 | 50 | 300 |
| 10015 | ForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10015 | ForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10015 | ForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10015 | ForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10015 | ForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10015 | ForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10015 | ForestGeometry | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10015 | ForestGeometry | AoI-greedy | 50 | 50 | 50 | 300 |

## 2. Risk-constrained-v6 相对强化基线的逐场景增益

| Scene | Config | ΔTimely vs DCC-CBR (pp) | ΔEmg vs DCC-CBR (pp) | ΔCost vs DCC-CBR (%) | ΔTimely vs AoI-greedy (pp) | ΔEmg vs AoI-greedy (pp) | ΔCost vs AoI-greedy (%) | Decision |
|---|---|---:|---:|---:|---:|---:|---:|---|
| 10014 | Default | 1.304 | 0.000 | -11.39 | 2.639 | 0.000 | -18.90 | StrongerBaselineGain |
| 10014 | ForestGeometry | -0.050 | 0.667 | 7.41 | 0.003 | 0.000 | -15.83 | StrongerBaselineBoundary |
| 10006 | Default | 6.166 | -0.263 | 3.47 | 2.915 | 0.000 | -14.13 | StrongerBaselineGain |
| 10006 | ForestGeometry | 0.366 | 0.020 | 6.86 | 0.033 | 0.000 | -16.76 | StrongerBaselineNonnegative |
| 10011 | Default | -0.436 | 0.000 | -18.86 | -0.416 | 0.000 | -28.73 | StrongerBaselineBoundary |
| 10011 | ForestGeometry | 18.789 | 2.200 | 53.07 | 4.569 | 0.100 | -4.94 | StrongerBaselineGain |
| 10019 | Default | -0.013 | 0.000 | -4.74 | -0.013 | 0.000 | -16.69 | StrongerBaselineBoundary |
| 10019 | ForestGeometry | -0.842 | -0.912 | 3.97 | -0.549 | -0.590 | -9.06 | StrongerBaselineBoundary |
| 10017 | Default | 8.649 | -1.444 | 15.05 | 2.669 | 0.000 | -10.40 | StrongerBaselineGain |
| 10017 | ForestGeometry | 1.095 | -0.389 | 29.10 | 0.273 | 0.000 | -15.02 | StrongerBaselineBoundary |
| 10013 | Default | -0.732 | 0.000 | -4.64 | -0.745 | 0.000 | -18.15 | StrongerBaselineBoundary |
| 10013 | ForestGeometry | -0.732 | -0.914 | 11.39 | -0.369 | -0.371 | -9.95 | StrongerBaselineBoundary |
| 10007 | Default | 6.875 | 0.000 | 2.36 | 1.993 | 0.000 | -17.32 | StrongerBaselineGain |
| 10007 | ForestGeometry | -0.300 | 0.000 | -2.20 | -0.546 | 0.000 | -22.13 | StrongerBaselineBoundary |
| 10015 | Default | 2.998 | 0.000 | -12.41 | 1.414 | 0.000 | 10.37 | StrongerBaselineGain |
| 10015 | ForestGeometry | -0.812 | 0.000 | 5.08 | 2.077 | 0.000 | 17.04 | StrongerBaselineBoundary |

## 3. DCC-CBR-window vs Risk-constrained-v6 显著性摘要

| Scene | Config | Metric | Baseline mean | V6 mean | Delta | Holm p | Effect RBC | Practical note |
|---|---|---|---:|---:|---:|---|---:|---|
| 10014 | Default | TimelyRate | 0.978769 | 0.991814 | 0.013045 | p < 2.3e-308 | 0.998 | Meaningful |
| 10014 | Default | LossRate | 0.021231 | 0.008186 | -0.013045 | p < 2.3e-308 | -0.998 | Meaningful |
| 10014 | Default | AvgTxCost | 2.257617 | 2.000552 | -0.257065 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10014 | Default | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.799900 | 0.799401 | -0.000499 | p = 0.9316 | -0.136 | Below1pp |
| 10014 | ForestGeometry | LossRate | 0.200033 | 0.200499 | 0.000466 | p = 0.9316 | 0.118 | Below1pp |
| 10014 | ForestGeometry | AvgTxCost | 2.126745 | 2.284253 | 0.157508 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | 0.016667 | 0.023333 | 0.006667 | p = 0.4591 | 1.000 | Below1pp |
| 10006 | Default | TimelyRate | 0.928319 | 0.989983 | 0.061664 | p < 2.3e-308 | 1.000 | Meaningful |
| 10006 | Default | LossRate | 0.070982 | 0.009318 | -0.061664 | p < 2.3e-308 | -1.000 | Meaningful |
| 10006 | Default | AvgTxCost | 2.753478 | 2.848957 | 0.095479 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10006 | Default | EmgTimely | 0.997697 | 0.995066 | -0.002632 | p = 4.165e-06 | -0.722 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.709418 | 0.713078 | 0.003661 | p = 2.603e-08 | 0.844 | Below1pp |
| 10006 | ForestGeometry | LossRate | 0.288852 | 0.285890 | -0.002962 | p = 3.614e-06 | -0.711 | Below1pp |
| 10006 | ForestGeometry | AvgTxCost | 2.712712 | 2.898837 | 0.186125 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.799671 | 0.799868 | 0.000197 | p = 0.6986 | 0.086 | Below1pp |
| 10011 | Default | TimelyRate | 0.999468 | 0.995108 | -0.004359 | p < 2.3e-308 | -1.000 | Below1pp |
| 10011 | Default | LossRate | 0.000532 | 0.004892 | 0.004359 | p < 2.3e-308 | 1.000 | Below1pp |
| 10011 | Default | AvgTxCost | 2.326992 | 1.888235 | -0.438757 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10011 | Default | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10011 | ForestGeometry | TimelyRate | 0.613977 | 0.801864 | 0.187887 | p < 2.3e-308 | 1.000 | Meaningful |
| 10011 | ForestGeometry | LossRate | 0.380100 | 0.191913 | -0.188186 | p < 2.3e-308 | -1.000 | Meaningful |
| 10011 | ForestGeometry | AvgTxCost | 2.106218 | 3.224041 | 1.117823 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10011 | ForestGeometry | EmgTimely | 0.463000 | 0.485000 | 0.022000 | p = 0.03131 | 0.371 | Meaningful |
| 10019 | Default | TimelyRate | 1.000000 | 0.999867 | -0.000133 | p = 0.117 | -1.000 | Below1pp |
| 10019 | Default | LossRate | 0.000000 | 0.000133 | 0.000133 | p = 0.117 | 1.000 | Below1pp |
| 10019 | Default | AvgTxCost | 3.196273 | 3.044759 | -0.151514 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10019 | Default | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10019 | ForestGeometry | TimelyRate | 0.626223 | 0.617804 | -0.008419 | p = 7.834e-13 | -0.887 | Below1pp |
| 10019 | ForestGeometry | LossRate | 0.332213 | 0.314143 | -0.018070 | p < 2.3e-308 | -0.981 | Meaningful |
| 10019 | ForestGeometry | AvgTxCost | 3.196273 | 3.323024 | 0.126751 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10019 | ForestGeometry | EmgTimely | 0.588571 | 0.579451 | -0.009121 | p = 7.834e-13 | -0.884 | Below1pp |
| 10017 | Default | TimelyRate | 0.892512 | 0.979002 | 0.086489 | p < 2.3e-308 | 1.000 | Meaningful |
| 10017 | Default | LossRate | 0.107454 | 0.020865 | -0.086589 | p < 2.3e-308 | -1.000 | Meaningful |
| 10017 | Default | AvgTxCost | 2.494118 | 2.869517 | 0.375399 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10017 | Default | EmgTimely | 0.995556 | 0.981111 | -0.014444 | p = 7.849e-05 | -0.861 | Meaningful |
| 10017 | ForestGeometry | TimelyRate | 0.521664 | 0.532612 | 0.010948 | p < 2.3e-308 | 1.000 | Meaningful |
| 10017 | ForestGeometry | LossRate | 0.477238 | 0.466689 | -0.010549 | p < 2.3e-308 | -1.000 | Meaningful |
| 10017 | ForestGeometry | AvgTxCost | 2.326689 | 3.003796 | 0.677107 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | 0.028333 | 0.024444 | -0.003889 | p = 0.2963 | -0.190 | Below1pp |
| 10013 | Default | TimelyRate | 0.999767 | 0.992446 | -0.007321 | p < 2.3e-308 | -1.000 | Below1pp |
| 10013 | Default | LossRate | 0.000233 | 0.007554 | 0.007321 | p < 2.3e-308 | 1.000 | Below1pp |
| 10013 | Default | AvgTxCost | 3.190849 | 3.042845 | -0.148003 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10013 | Default | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10013 | ForestGeometry | TimelyRate | 0.560133 | 0.552812 | -0.007321 | p = 3.553e-15 | -0.926 | Below1pp |
| 10013 | ForestGeometry | LossRate | 0.403195 | 0.382196 | -0.020998 | p < 2.3e-308 | -0.991 | Meaningful |
| 10013 | ForestGeometry | AvgTxCost | 3.125624 | 3.481636 | 0.356012 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10013 | ForestGeometry | EmgTimely | 0.616807 | 0.607670 | -0.009138 | p < 2.3e-308 | -0.950 | Below1pp |
| 10007 | Default | TimelyRate | 0.926988 | 0.995740 | 0.068752 | p < 2.3e-308 | 1.000 | Meaningful |
| 10007 | Default | LossRate | 0.073012 | 0.004260 | -0.068752 | p < 2.3e-308 | -1.000 | Meaningful |
| 10007 | Default | AvgTxCost | 2.763927 | 2.829165 | 0.065238 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10007 | Default | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | ForestGeometry | TimelyRate | 0.868386 | 0.865391 | -0.002995 | p = 7.928e-09 | -0.830 | Below1pp |
| 10007 | ForestGeometry | LossRate | 0.131614 | 0.134609 | 0.002995 | p = 7.928e-09 | 0.830 | Below1pp |
| 10007 | ForestGeometry | AvgTxCost | 2.753245 | 2.692733 | -0.060512 | p < 2.3e-308 | -0.992 | SeeDelta |
| 10007 | ForestGeometry | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | Default | TimelyRate | 0.966922 | 0.996905 | 0.029983 | p < 2.3e-308 | 1.000 | Meaningful |
| 10015 | Default | LossRate | 0.033078 | 0.003095 | -0.029983 | p < 2.3e-308 | -1.000 | Meaningful |
| 10015 | Default | AvgTxCost | 1.532852 | 1.342660 | -0.190192 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10015 | Default | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | ForestGeometry | TimelyRate | 0.916339 | 0.908220 | -0.008120 | p < 2.3e-308 | -0.996 | Below1pp |
| 10015 | ForestGeometry | LossRate | 0.083661 | 0.091780 | 0.008120 | p < 2.3e-308 | 0.996 | Below1pp |
| 10015 | ForestGeometry | AvgTxCost | 1.435348 | 1.508214 | 0.072866 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10015 | ForestGeometry | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |

## 4. AoI-greedy vs Risk-constrained-v6 显著性摘要

| Scene | Config | Metric | Baseline mean | V6 mean | Delta | Holm p | Effect RBC | Practical note |
|---|---|---|---:|---:|---:|---|---:|---|
| 10014 | Default | TimelyRate | 0.965424 | 0.991814 | 0.026389 | p < 2.3e-308 | 1.000 | Meaningful |
| 10014 | Default | LossRate | 0.034576 | 0.008186 | -0.026389 | p < 2.3e-308 | -1.000 | Meaningful |
| 10014 | Default | AvgTxCost | 2.466918 | 2.000552 | -0.466366 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10014 | Default | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.799368 | 0.799401 | 0.000033 | p = 1 | 0.041 | Below1pp |
| 10014 | ForestGeometry | LossRate | 0.200532 | 0.200499 | -0.000033 | p = 1 | -0.041 | Below1pp |
| 10014 | ForestGeometry | AvgTxCost | 2.713937 | 2.284253 | -0.429684 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | 0.023333 | 0.023333 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10006 | Default | TimelyRate | 0.960832 | 0.989983 | 0.029151 | p < 2.3e-308 | 1.000 | Meaningful |
| 10006 | Default | LossRate | 0.038469 | 0.009318 | -0.029151 | p < 2.3e-308 | -1.000 | Meaningful |
| 10006 | Default | AvgTxCost | 3.317881 | 2.848957 | -0.468924 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10006 | Default | EmgTimely | 0.995066 | 0.995066 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.712745 | 0.713078 | 0.000333 | p = 1 | 0.138 | Below1pp |
| 10006 | ForestGeometry | LossRate | 0.286223 | 0.285890 | -0.000333 | p = 1 | -0.138 | Below1pp |
| 10006 | ForestGeometry | AvgTxCost | 3.482705 | 2.898837 | -0.583868 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.799868 | 0.799868 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10011 | Default | TimelyRate | 0.999268 | 0.995108 | -0.004160 | p < 2.3e-308 | -1.000 | Below1pp |
| 10011 | Default | LossRate | 0.000732 | 0.004892 | 0.004160 | p < 2.3e-308 | 1.000 | Below1pp |
| 10011 | Default | AvgTxCost | 2.649231 | 1.888235 | -0.760997 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10011 | Default | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10011 | ForestGeometry | TimelyRate | 0.756173 | 0.801864 | 0.045691 | p < 2.3e-308 | 1.000 | Meaningful |
| 10011 | ForestGeometry | LossRate | 0.240599 | 0.191913 | -0.048686 | p < 2.3e-308 | -1.000 | Meaningful |
| 10011 | ForestGeometry | AvgTxCost | 3.391763 | 3.224041 | -0.167722 | p < 2.3e-308 | -0.992 | SeeDelta |
| 10011 | ForestGeometry | EmgTimely | 0.484000 | 0.485000 | 0.001000 | p = 0.9145 | 0.020 | Below1pp |
| 10019 | Default | TimelyRate | 1.000000 | 0.999867 | -0.000133 | p = 0.156 | -1.000 | Below1pp |
| 10019 | Default | LossRate | 0.000000 | 0.000133 | 0.000133 | p = 0.156 | 1.000 | Below1pp |
| 10019 | Default | AvgTxCost | 3.654725 | 3.044759 | -0.609967 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10019 | Default | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10019 | ForestGeometry | TimelyRate | 0.623295 | 0.617804 | -0.005491 | p = 3.035e-10 | -0.818 | Below1pp |
| 10019 | ForestGeometry | LossRate | 0.352512 | 0.314143 | -0.038369 | p < 2.3e-308 | -1.000 | Meaningful |
| 10019 | ForestGeometry | AvgTxCost | 3.653910 | 3.323024 | -0.330886 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10019 | ForestGeometry | EmgTimely | 0.585348 | 0.579451 | -0.005897 | p = 5.626e-10 | -0.801 | Below1pp |
| 10017 | Default | TimelyRate | 0.952313 | 0.979002 | 0.026689 | p < 2.3e-308 | 1.000 | Meaningful |
| 10017 | Default | LossRate | 0.047554 | 0.020865 | -0.026689 | p < 2.3e-308 | -1.000 | Meaningful |
| 10017 | Default | AvgTxCost | 3.202733 | 2.869517 | -0.333217 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10017 | Default | EmgTimely | 0.981111 | 0.981111 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10017 | ForestGeometry | TimelyRate | 0.529884 | 0.532612 | 0.002729 | p = 1.918e-05 | 0.645 | Below1pp |
| 10017 | ForestGeometry | LossRate | 0.469418 | 0.466689 | -0.002729 | p = 1.918e-05 | -0.645 | Below1pp |
| 10017 | ForestGeometry | AvgTxCost | 3.534599 | 3.003796 | -0.530803 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | 0.024444 | 0.024444 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10013 | Default | TimelyRate | 0.999900 | 0.992446 | -0.007454 | p < 2.3e-308 | -1.000 | Below1pp |
| 10013 | Default | LossRate | 0.000100 | 0.007554 | 0.007454 | p < 2.3e-308 | 1.000 | Below1pp |
| 10013 | Default | AvgTxCost | 3.717388 | 3.042845 | -0.674542 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10013 | Default | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10013 | ForestGeometry | TimelyRate | 0.556506 | 0.552812 | -0.003694 | p = 9.870e-04 | -0.532 | Below1pp |
| 10013 | ForestGeometry | LossRate | 0.420865 | 0.382196 | -0.038669 | p < 2.3e-308 | -1.000 | Meaningful |
| 10013 | ForestGeometry | AvgTxCost | 3.866473 | 3.481636 | -0.384836 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10013 | ForestGeometry | EmgTimely | 0.611376 | 0.607670 | -0.003706 | p = 0.001037 | -0.528 | Below1pp |
| 10007 | Default | TimelyRate | 0.975807 | 0.995740 | 0.019933 | p < 2.3e-308 | 1.000 | Meaningful |
| 10007 | Default | LossRate | 0.024193 | 0.004260 | -0.019933 | p < 2.3e-308 | -1.000 | Meaningful |
| 10007 | Default | AvgTxCost | 3.421681 | 2.829165 | -0.592516 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10007 | Default | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | ForestGeometry | TimelyRate | 0.870849 | 0.865391 | -0.005458 | p < 2.3e-308 | -0.993 | Below1pp |
| 10007 | ForestGeometry | LossRate | 0.129151 | 0.134609 | 0.005458 | p < 2.3e-308 | 0.993 | Below1pp |
| 10007 | ForestGeometry | AvgTxCost | 3.458097 | 2.692733 | -0.765364 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10007 | ForestGeometry | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | Default | TimelyRate | 0.982762 | 0.996905 | 0.014143 | p < 2.3e-308 | 1.000 | Meaningful |
| 10015 | Default | LossRate | 0.017238 | 0.003095 | -0.014143 | p < 2.3e-308 | -1.000 | Meaningful |
| 10015 | Default | AvgTxCost | 1.216469 | 1.342660 | 0.126191 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10015 | Default | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | ForestGeometry | TimelyRate | 0.887454 | 0.908220 | 0.020765 | p < 2.3e-308 | 1.000 | Meaningful |
| 10015 | ForestGeometry | LossRate | 0.112546 | 0.091780 | -0.020765 | p < 2.3e-308 | -1.000 | Meaningful |
| 10015 | ForestGeometry | AvgTxCost | 1.288602 | 1.508214 | 0.219612 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10015 | ForestGeometry | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |

## 5. 审稿口径

1. `DCC-CBR-window` 使用滑动窗口信道占用代理，比 `DCC-like` 更接近拥塞控制逻辑，但仍不是完整 ETSI DCC 标准栈。
2. `AoI-greedy` 使用预期 AoI 降低、链路成功率与发送成本的贪心目标，不使用定位可信度或林区风险项。
3. 若 Risk-constrained-v6 在某些场景低于强化基线，应作为适用边界或 cost-risk trade-off 讨论，不应隐藏。
