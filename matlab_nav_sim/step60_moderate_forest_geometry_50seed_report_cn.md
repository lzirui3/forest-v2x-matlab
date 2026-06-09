# Step60 ModerateForestGeometry 验证报告

本步骤新增 `ModerateForestGeometry`，作为可部署的中等林区退化补充场景。原 `ForestGeometry` 保留为 extreme stress / boundary case，不覆盖、不删除、不通过调参消除旧负例。

每个 scene 的随机种子数：50。最终物理层口径仍为 PER lookup。

## 1. 覆盖率检查

| Scene | Config | Method | Raw seeds | Stage seeds | Raw rows | Stage rows |
|---|---|---|---:|---:|---:|---:|
| 10014 | ModerateForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10014 | ModerateForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10014 | ModerateForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10014 | ModerateForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10014 | ModerateForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10014 | ModerateForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10014 | ModerateForestGeometry | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10014 | ModerateForestGeometry | AoI-greedy | 50 | 50 | 50 | 300 |
| 10006 | ModerateForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10006 | ModerateForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10006 | ModerateForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10006 | ModerateForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10006 | ModerateForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10006 | ModerateForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10006 | ModerateForestGeometry | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10006 | ModerateForestGeometry | AoI-greedy | 50 | 50 | 50 | 300 |
| 10011 | ModerateForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10011 | ModerateForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10011 | ModerateForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10011 | ModerateForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10011 | ModerateForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10011 | ModerateForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10011 | ModerateForestGeometry | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10011 | ModerateForestGeometry | AoI-greedy | 50 | 50 | 50 | 300 |
| 10019 | ModerateForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10019 | ModerateForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10019 | ModerateForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10019 | ModerateForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10019 | ModerateForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10019 | ModerateForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10019 | ModerateForestGeometry | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10019 | ModerateForestGeometry | AoI-greedy | 50 | 50 | 50 | 300 |
| 10017 | ModerateForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10017 | ModerateForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10017 | ModerateForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10017 | ModerateForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10017 | ModerateForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10017 | ModerateForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10017 | ModerateForestGeometry | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10017 | ModerateForestGeometry | AoI-greedy | 50 | 50 | 50 | 300 |
| 10013 | ModerateForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10013 | ModerateForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10013 | ModerateForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10013 | ModerateForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10013 | ModerateForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10013 | ModerateForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10013 | ModerateForestGeometry | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10013 | ModerateForestGeometry | AoI-greedy | 50 | 50 | 50 | 300 |
| 10007 | ModerateForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10007 | ModerateForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10007 | ModerateForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10007 | ModerateForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10007 | ModerateForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10007 | ModerateForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10007 | ModerateForestGeometry | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10007 | ModerateForestGeometry | AoI-greedy | 50 | 50 | 50 | 300 |
| 10015 | ModerateForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10015 | ModerateForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10015 | ModerateForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10015 | ModerateForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10015 | ModerateForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10015 | ModerateForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10015 | ModerateForestGeometry | DCC-CBR-window | 50 | 50 | 50 | 300 |
| 10015 | ModerateForestGeometry | AoI-greedy | 50 | 50 | 50 | 300 |

## 2. ModerateForestGeometry 逐场景结论

| Scene | V6 Timely (%) | V6 Emergency (%) | Constrained Oracle Emergency (%) | Delta Timely vs Heuristic (pp) | Delta Emergency vs Heuristic (pp) | Delta Timely vs DCC-CBR (pp) | Delta Timely vs AoI-greedy (pp) | Decision |
|---|---:|---:|---:|---:|---:|---:|---:|---|
| 10014 | 81.45 | 10.33 | 7.33 | 0.745 | -0.667 | 1.148 | 0.532 | ModerateHardEmergencyBoundary |
| 10006 | 74.59 | 83.04 | 82.70 | 0.087 | -1.342 | 1.285 | 0.406 | ModerateBoundary |
| 10011 | 95.85 | 95.80 | 95.80 | 0.379 | 0.000 | 0.705 | 0.203 | ModerateNonnegative |
| 10019 | 97.21 | 96.95 | 97.21 | 0.120 | 0.132 | -0.419 | 0.140 | ModerateNonnegative |
| 10017 | 55.13 | 4.56 | 3.94 | 1.238 | -0.056 | 2.483 | 0.626 | ModerateHardEmergencyBoundary |
| 10013 | 83.78 | 87.16 | 86.20 | -0.133 | -0.356 | 3.521 | 1.441 | ModerateBoundary |
| 10007 | 87.40 | 100.00 | 100.00 | 0.356 | 0.000 | 0.389 | 0.110 | ModerateNonnegative |
| 10015 | 93.17 | 100.00 | 100.00 | 0.319 | 0.000 | 0.250 | 0.193 | ModerateNonnegative |

## 3. 显著性摘要

以下统计保留 Holm 多重比较校正和 effect size。DCC-CBR-window 与 AoI-greedy 均为文献风格 inspired baseline，不声称完整复现标准协议栈或 AoI 最优策略。

### DCC-CBR-window vs Risk-constrained-v6

| Scene | Metric | Baseline mean | V6 mean | Delta | Holm p | Effect RBC | Practical note |
|---|---|---:|---:|---:|---|---:|---|
| 10014 | TimelyRate | 0.803062 | 0.814542 | 0.011481 | p < 2.3e-308 | 1.000 | Meaningful |
| 10014 | LossRate | 0.196073 | 0.184759 | -0.011314 | p < 2.3e-308 | -1.000 | Meaningful |
| 10014 | AvgTxCost | 2.146062 | 2.241328 | 0.095266 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10014 | EmgTimely | 0.106667 | 0.103333 | -0.003333 | p = 0.843 | -0.040 | Below1pp |
| 10006 | TimelyRate | 0.733045 | 0.745890 | 0.012845 | p < 2.3e-308 | 0.998 | Meaningful |
| 10006 | LossRate | 0.247720 | 0.213544 | -0.034176 | p < 2.3e-308 | -1.000 | Meaningful |
| 10006 | AvgTxCost | 2.712712 | 3.075586 | 0.362874 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10006 | EmgTimely | 0.842039 | 0.830395 | -0.011645 | p < 2.3e-308 | -0.992 | Meaningful |
| 10011 | TimelyRate | 0.951481 | 0.958536 | 0.007055 | p < 2.3e-308 | 1.000 | Below1pp |
| 10011 | LossRate | 0.048253 | 0.041364 | -0.006889 | p < 2.3e-308 | -1.000 | Below1pp |
| 10011 | AvgTxCost | 2.280973 | 2.052123 | -0.228851 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10011 | EmgTimely | 0.959000 | 0.958000 | -0.001000 | p = 0.7651 | -0.091 | Below1pp |
| 10019 | TimelyRate | 0.976339 | 0.972146 | -0.004193 | p = 3.504e-13 | -0.889 | Below1pp |
| 10019 | LossRate | 0.010349 | 0.009817 | -0.000532 | p = 0.3497 | -0.171 | Below1pp |
| 10019 | AvgTxCost | 3.196273 | 3.170812 | -0.025461 | p < 2.3e-308 | -0.995 | SeeDelta |
| 10019 | EmgTimely | 0.973956 | 0.969487 | -0.004469 | p = 1.595e-12 | -0.879 | Below1pp |
| 10017 | TimelyRate | 0.526456 | 0.551281 | 0.024825 | p < 2.3e-308 | 1.000 | Meaningful |
| 10017 | LossRate | 0.470616 | 0.447022 | -0.023594 | p < 2.3e-308 | -1.000 | Meaningful |
| 10017 | AvgTxCost | 2.326689 | 2.944656 | 0.617967 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10017 | EmgTimely | 0.048333 | 0.045556 | -0.002778 | p = 0.5439 | -0.111 | Below1pp |
| 10013 | TimelyRate | 0.802596 | 0.837804 | 0.035208 | p < 2.3e-308 | 1.000 | Meaningful |
| 10013 | LossRate | 0.141963 | 0.082296 | -0.059667 | p < 2.3e-308 | -1.000 | Meaningful |
| 10013 | AvgTxCost | 3.125624 | 3.779174 | 0.653550 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10013 | EmgTimely | 0.873688 | 0.871633 | -0.002055 | p = 4.702e-04 | -0.561 | Below1pp |
| 10007 | TimelyRate | 0.870116 | 0.874010 | 0.003894 | p < 2.3e-308 | 1.000 | Below1pp |
| 10007 | LossRate | 0.129884 | 0.125990 | -0.003894 | p < 2.3e-308 | -1.000 | Below1pp |
| 10007 | AvgTxCost | 2.760433 | 2.629191 | -0.131242 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10007 | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | TimelyRate | 0.929251 | 0.931747 | 0.002496 | p = 1.239e-13 | 0.930 | Below1pp |
| 10015 | LossRate | 0.070749 | 0.068253 | -0.002496 | p = 1.239e-13 | -0.930 | Below1pp |
| 10015 | AvgTxCost | 1.482473 | 1.350598 | -0.131875 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10015 | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |

### AoI-greedy vs Risk-constrained-v6

| Scene | Metric | Baseline mean | V6 mean | Delta | Holm p | Effect RBC | Practical note |
|---|---|---:|---:|---:|---|---:|---|
| 10014 | TimelyRate | 0.809218 | 0.814542 | 0.005324 | p < 2.3e-308 | 0.992 | Below1pp |
| 10014 | LossRate | 0.190083 | 0.184759 | -0.005324 | p < 2.3e-308 | -0.992 | Below1pp |
| 10014 | AvgTxCost | 2.705970 | 2.241328 | -0.464642 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10014 | EmgTimely | 0.103333 | 0.103333 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10006 | TimelyRate | 0.741830 | 0.745890 | 0.004060 | p = 7.596e-07 | 0.684 | Below1pp |
| 10006 | LossRate | 0.245691 | 0.213544 | -0.032146 | p < 2.3e-308 | -1.000 | Meaningful |
| 10006 | AvgTxCost | 3.484732 | 3.075586 | -0.409146 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10006 | EmgTimely | 0.843487 | 0.830395 | -0.013092 | p < 2.3e-308 | -0.960 | Meaningful |
| 10011 | TimelyRate | 0.956506 | 0.958536 | 0.002030 | p = 1.266e-04 | 0.630 | Below1pp |
| 10011 | LossRate | 0.043394 | 0.041364 | -0.002030 | p = 1.266e-04 | -0.630 | Below1pp |
| 10011 | AvgTxCost | 2.821990 | 2.052123 | -0.769867 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10011 | EmgTimely | 0.958000 | 0.958000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10019 | TimelyRate | 0.970749 | 0.972146 | 0.001398 | p = 0.02696 | 0.394 | Below1pp |
| 10019 | LossRate | 0.019567 | 0.009817 | -0.009750 | p < 2.3e-308 | -1.000 | Below1pp |
| 10019 | AvgTxCost | 3.653910 | 3.170812 | -0.483099 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10019 | EmgTimely | 0.967802 | 0.969487 | 0.001685 | p = 0.02696 | 0.429 | Below1pp |
| 10017 | TimelyRate | 0.545025 | 0.551281 | 0.006256 | p = 5.862e-14 | 0.894 | Below1pp |
| 10017 | LossRate | 0.453278 | 0.447022 | -0.006256 | p = 5.862e-14 | -0.894 | Below1pp |
| 10017 | AvgTxCost | 3.543474 | 2.944656 | -0.598819 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10017 | EmgTimely | 0.045556 | 0.045556 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10013 | TimelyRate | 0.823394 | 0.837804 | 0.014409 | p < 2.3e-308 | 0.983 | Meaningful |
| 10013 | LossRate | 0.143295 | 0.082296 | -0.060998 | p < 2.3e-308 | -1.000 | Meaningful |
| 10013 | AvgTxCost | 3.866473 | 3.779174 | -0.087298 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10013 | EmgTimely | 0.875523 | 0.871633 | -0.003890 | p = 0.004337 | -0.473 | Below1pp |
| 10007 | TimelyRate | 0.872912 | 0.874010 | 0.001098 | p = 7.268e-04 | 0.592 | Below1pp |
| 10007 | LossRate | 0.127088 | 0.125990 | -0.001098 | p = 7.268e-04 | -0.592 | Below1pp |
| 10007 | AvgTxCost | 3.460692 | 2.629191 | -0.831501 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10007 | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | TimelyRate | 0.929817 | 0.931747 | 0.001930 | p < 2.3e-308 | 0.967 | Below1pp |
| 10015 | LossRate | 0.070183 | 0.068253 | -0.001930 | p < 2.3e-308 | -0.967 | Below1pp |
| 10015 | AvgTxCost | 1.287604 | 1.350598 | 0.062994 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10015 | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |

### Confidence-heuristic vs Risk-constrained-v6

| Scene | Metric | Baseline mean | V6 mean | Delta | Holm p | Effect RBC | Practical note |
|---|---|---:|---:|---:|---|---:|---|
| 10014 | TimelyRate | 0.807088 | 0.814542 | 0.007454 | p < 2.3e-308 | 1.000 | Below1pp |
| 10014 | LossRate | 0.191614 | 0.184759 | -0.006855 | p < 2.3e-308 | -1.000 | Below1pp |
| 10014 | AvgTxCost | 2.060830 | 2.241328 | 0.180498 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10014 | EmgTimely | 0.110000 | 0.103333 | -0.006667 | p = 0.6573 | -0.100 | Below1pp |
| 10006 | TimelyRate | 0.745025 | 0.745890 | 0.000865 | p = 0.2991 | 0.175 | Below1pp |
| 10006 | LossRate | 0.233810 | 0.213544 | -0.020266 | p < 2.3e-308 | -1.000 | Meaningful |
| 10006 | AvgTxCost | 2.618595 | 3.075586 | 0.456991 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10006 | EmgTimely | 0.843816 | 0.830395 | -0.013421 | p < 2.3e-308 | -0.922 | Meaningful |
| 10011 | TimelyRate | 0.954742 | 0.958536 | 0.003794 | p < 2.3e-308 | 1.000 | Below1pp |
| 10011 | LossRate | 0.045158 | 0.041364 | -0.003794 | p < 2.3e-308 | -1.000 | Below1pp |
| 10011 | AvgTxCost | 2.056621 | 2.052123 | -0.004498 | p = 0.4594 | -0.126 | SeeDelta |
| 10011 | EmgTimely | 0.958000 | 0.958000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10019 | TimelyRate | 0.970948 | 0.972146 | 0.001198 | p = 0.09138 | 0.376 | Below1pp |
| 10019 | LossRate | 0.019235 | 0.009817 | -0.009418 | p < 2.3e-308 | -1.000 | Below1pp |
| 10019 | AvgTxCost | 3.004019 | 3.170812 | 0.166793 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10019 | EmgTimely | 0.968168 | 0.969487 | 0.001319 | p = 0.09138 | 0.376 | Below1pp |
| 10017 | TimelyRate | 0.538902 | 0.551281 | 0.012379 | p < 2.3e-308 | 1.000 | Meaningful |
| 10017 | LossRate | 0.459068 | 0.447022 | -0.012047 | p < 2.3e-308 | -1.000 | Meaningful |
| 10017 | AvgTxCost | 2.599991 | 2.944656 | 0.344664 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10017 | EmgTimely | 0.046111 | 0.045556 | -0.000556 | p = 0.7079 | -0.143 | Below1pp |
| 10013 | TimelyRate | 0.839135 | 0.837804 | -0.001331 | p = 0.251 | -0.216 | Below1pp |
| 10013 | LossRate | 0.126955 | 0.082296 | -0.044659 | p < 2.3e-308 | -1.000 | Meaningful |
| 10013 | AvgTxCost | 3.320354 | 3.779174 | 0.458820 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10013 | EmgTimely | 0.875193 | 0.871633 | -0.003560 | p = 0.008389 | -0.460 | Below1pp |
| 10007 | TimelyRate | 0.870449 | 0.874010 | 0.003561 | p < 2.3e-308 | 1.000 | Below1pp |
| 10007 | LossRate | 0.129551 | 0.125990 | -0.003561 | p < 2.3e-308 | -1.000 | Below1pp |
| 10007 | AvgTxCost | 2.378350 | 2.629191 | 0.250841 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10007 | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | TimelyRate | 0.928552 | 0.931747 | 0.003195 | p < 2.3e-308 | 1.000 | Below1pp |
| 10015 | LossRate | 0.071448 | 0.068253 | -0.003195 | p < 2.3e-308 | -1.000 | Below1pp |
| 10015 | AvgTxCost | 1.220730 | 1.350598 | 0.129868 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10015 | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |

## 4. 审稿口径

1. `ModerateForestGeometry` 是补充可部署退化场景，不替代原 `ForestGeometry`。
2. 原 `ForestGeometry` 应写为 extreme stress test，用于暴露 deadline-reliability boundary。
3. 若某些 Moderate 场景仍然 emergency headroom 很低，应作为场景物理边界讨论，不能包装为主方法失效或成功。
4. 本步骤仅补充场景真实性与适用性证据，不改变 `Risk-constrained-v6` 冻结参数。
