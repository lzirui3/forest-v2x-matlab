# Step54 PER lookup 文献基线对比报告

本报告补齐最终物理层口径下的文献基线对比。PDR 口径固定为 `PER lookup`，并合并 Step49/Step50 已冻结结果。

新增运行的文献基线：`DCC-like` 与 `AoI-aware`。主方法 `Risk-constrained-v6` 参数未调整。

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
| 10014 | ForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10014 | ForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10014 | ForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10014 | ForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10014 | ForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10014 | ForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10006 | Default | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10006 | Default | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10006 | Default | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10006 | Default | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10006 | Default | DCC-like | 50 | 50 | 50 | 300 |
| 10006 | Default | AoI-aware | 50 | 50 | 50 | 300 |
| 10006 | ForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10006 | ForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10006 | ForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10006 | ForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10006 | ForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10006 | ForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10011 | Default | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10011 | Default | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10011 | Default | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10011 | Default | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10011 | Default | DCC-like | 50 | 50 | 50 | 300 |
| 10011 | Default | AoI-aware | 50 | 50 | 50 | 300 |
| 10011 | ForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10011 | ForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10011 | ForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10011 | ForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10011 | ForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10011 | ForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10019 | Default | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10019 | Default | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10019 | Default | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10019 | Default | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10019 | Default | DCC-like | 50 | 50 | 50 | 300 |
| 10019 | Default | AoI-aware | 50 | 50 | 50 | 300 |
| 10019 | ForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10019 | ForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10019 | ForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10019 | ForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10019 | ForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10019 | ForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10017 | Default | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10017 | Default | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10017 | Default | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10017 | Default | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10017 | Default | DCC-like | 50 | 50 | 50 | 300 |
| 10017 | Default | AoI-aware | 50 | 50 | 50 | 300 |
| 10017 | ForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10017 | ForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10017 | ForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10017 | ForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10017 | ForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10017 | ForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10013 | Default | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10013 | Default | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10013 | Default | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10013 | Default | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10013 | Default | DCC-like | 50 | 50 | 50 | 300 |
| 10013 | Default | AoI-aware | 50 | 50 | 50 | 300 |
| 10013 | ForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10013 | ForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10013 | ForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10013 | ForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10013 | ForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10013 | ForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10007 | Default | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10007 | Default | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10007 | Default | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10007 | Default | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10007 | Default | DCC-like | 50 | 50 | 50 | 300 |
| 10007 | Default | AoI-aware | 50 | 50 | 50 | 300 |
| 10007 | ForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10007 | ForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10007 | ForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10007 | ForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10007 | ForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10007 | ForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |
| 10015 | Default | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10015 | Default | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10015 | Default | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10015 | Default | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10015 | Default | DCC-like | 50 | 50 | 50 | 300 |
| 10015 | Default | AoI-aware | 50 | 50 | 50 | 300 |
| 10015 | ForestGeometry | Link-delay-aware | 50 | 50 | 50 | 300 |
| 10015 | ForestGeometry | Confidence-heuristic | 50 | 50 | 50 | 300 |
| 10015 | ForestGeometry | Risk-constrained-v6 | 50 | 50 | 50 | 300 |
| 10015 | ForestGeometry | Constrained Oracle | 50 | 50 | 50 | 300 |
| 10015 | ForestGeometry | DCC-like | 50 | 50 | 50 | 300 |
| 10015 | ForestGeometry | AoI-aware | 50 | 50 | 50 | 300 |

## 2. Risk-constrained-v6 相对文献基线的逐场景增益

| Scene | Config | ΔTimely vs DCC (pp) | ΔEmg vs DCC (pp) | ΔCost vs DCC (%) | ΔTimely vs AoI (pp) | ΔEmg vs AoI (pp) | ΔCost vs AoI (%) | Decision |
|---|---|---:|---:|---:|---:|---:|---:|---|
| 10014 | Default | 1.195 | 0.000 | -50.88 | 1.478 | 13.667 | -9.04 | LiteratureStrong |
| 10014 | ForestGeometry | -0.043 | 1.333 | -40.95 | 0.612 | 0.667 | -3.58 | LiteratureBoundary |
| 10006 | Default | 7.155 | -0.046 | -36.23 | 1.797 | 0.533 | 20.14 | LiteratureStrong |
| 10006 | ForestGeometry | 0.419 | 0.151 | -30.30 | 0.116 | 0.125 | 9.29 | LiteratureNonnegative |
| 10011 | Default | -0.486 | 0.000 | -47.90 | 0.190 | 0.300 | 2.87 | LiteratureBoundary |
| 10011 | ForestGeometry | 19.441 | 9.300 | 8.85 | -0.273 | 15.800 | -20.15 | LiteratureStrong |
| 10019 | Default | -0.013 | 0.000 | -33.53 | 0.193 | 0.212 | 80.44 | LiteratureBoundary |
| 10019 | ForestGeometry | 0.572 | 0.645 | -12.06 | -0.832 | -0.916 | 0.23 | LiteratureBoundary |
| 10017 | Default | 8.476 | -1.222 | -39.30 | 3.042 | 3.889 | -13.80 | LiteratureStrong |
| 10017 | ForestGeometry | 1.138 | 0.278 | -25.64 | -0.479 | -0.611 | -26.73 | LiteratureBoundary |
| 10013 | Default | -0.745 | 0.000 | -33.92 | 0.552 | 0.650 | 80.39 | LiteratureBoundary |
| 10013 | ForestGeometry | 0.872 | 0.851 | 2.36 | -0.103 | 0.048 | 1.58 | LiteratureBoundary |
| 10007 | Default | 6.899 | 0.000 | -41.45 | 1.787 | 0.071 | 23.11 | LiteratureStrong |
| 10007 | ForestGeometry | -0.466 | 0.000 | -44.15 | 0.908 | 0.071 | 17.17 | LiteratureBoundary |
| 10015 | Default | 3.298 | 0.000 | -24.64 | 1.478 | 0.154 | 4.02 | LiteratureStrong |
| 10015 | ForestGeometry | -0.809 | 0.000 | -13.73 | 4.865 | 1.385 | 9.05 | LiteratureBoundary |

## 3. DCC-like vs Risk-constrained-v6 显著性摘要

| Scene | Config | Metric | Baseline mean | V6 mean | Delta | Holm p | Effect RBC | Practical note |
|---|---|---|---:|---:|---:|---|---:|---|
| 10014 | Default | TimelyRate | 0.979867 | 0.991814 | 0.011947 | p < 2.3e-308 | 0.998 | Meaningful |
| 10014 | Default | LossRate | 0.020133 | 0.008186 | -0.011947 | p < 2.3e-308 | -0.998 | Meaningful |
| 10014 | Default | AvgTxCost | 4.073039 | 2.000552 | -2.072487 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10014 | Default | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.799834 | 0.799401 | -0.000433 | p = 1 | -0.110 | Below1pp |
| 10014 | ForestGeometry | LossRate | 0.200133 | 0.200499 | 0.000366 | p = 1 | 0.086 | Below1pp |
| 10014 | ForestGeometry | AvgTxCost | 3.868652 | 2.284253 | -1.584399 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | 0.010000 | 0.023333 | 0.013333 | p = 0.117 | 1.000 | Meaningful |
| 10006 | Default | TimelyRate | 0.918436 | 0.989983 | 0.071547 | p < 2.3e-308 | 1.000 | Meaningful |
| 10006 | Default | LossRate | 0.081331 | 0.009318 | -0.072013 | p < 2.3e-308 | -1.000 | Meaningful |
| 10006 | Default | AvgTxCost | 4.467373 | 2.848957 | -1.618416 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10006 | Default | EmgTimely | 0.995526 | 0.995066 | -0.000461 | p = 0.484 | -0.100 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.708885 | 0.713078 | 0.004193 | p = 6.147e-11 | 0.918 | Below1pp |
| 10006 | ForestGeometry | LossRate | 0.290682 | 0.285890 | -0.004792 | p = 1.932e-13 | -0.921 | Below1pp |
| 10006 | ForestGeometry | AvgTxCost | 4.159235 | 2.898837 | -1.260397 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.798355 | 0.799868 | 0.001513 | p = 0.00521 | 0.521 | Below1pp |
| 10011 | Default | TimelyRate | 0.999967 | 0.995108 | -0.004859 | p < 2.3e-308 | -1.000 | Below1pp |
| 10011 | Default | LossRate | 0.000033 | 0.004892 | 0.004859 | p < 2.3e-308 | 1.000 | Below1pp |
| 10011 | Default | AvgTxCost | 3.624027 | 1.888235 | -1.735792 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10011 | Default | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10011 | ForestGeometry | TimelyRate | 0.607454 | 0.801864 | 0.194409 | p < 2.3e-308 | 1.000 | Meaningful |
| 10011 | ForestGeometry | LossRate | 0.390349 | 0.191913 | -0.198436 | p < 2.3e-308 | -1.000 | Meaningful |
| 10011 | ForestGeometry | AvgTxCost | 2.961825 | 3.224041 | 0.262215 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10011 | ForestGeometry | EmgTimely | 0.392000 | 0.485000 | 0.093000 | p = 3.415e-13 | 0.856 | Meaningful |
| 10019 | Default | TimelyRate | 1.000000 | 0.999867 | -0.000133 | p = 0.117 | -1.000 | Below1pp |
| 10019 | Default | LossRate | 0.000000 | 0.000133 | 0.000133 | p = 0.117 | 1.000 | Below1pp |
| 10019 | Default | AvgTxCost | 4.580666 | 3.044759 | -1.535907 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10019 | Default | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10019 | ForestGeometry | TimelyRate | 0.612080 | 0.617804 | 0.005724 | p = 4.811e-06 | 0.647 | Below1pp |
| 10019 | ForestGeometry | LossRate | 0.375607 | 0.314143 | -0.061464 | p < 2.3e-308 | -1.000 | Meaningful |
| 10019 | ForestGeometry | AvgTxCost | 3.778952 | 3.323024 | -0.455928 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10019 | ForestGeometry | EmgTimely | 0.573004 | 0.579451 | 0.006447 | p = 4.183e-06 | 0.660 | Below1pp |
| 10017 | Default | TimelyRate | 0.894243 | 0.979002 | 0.084759 | p < 2.3e-308 | 1.000 | Meaningful |
| 10017 | Default | LossRate | 0.105557 | 0.020865 | -0.084692 | p < 2.3e-308 | -1.000 | Meaningful |
| 10017 | Default | AvgTxCost | 4.727565 | 2.869517 | -1.858048 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10017 | Default | EmgTimely | 0.993333 | 0.981111 | -0.012222 | p = 0.004347 | -0.620 | Meaningful |
| 10017 | ForestGeometry | TimelyRate | 0.521231 | 0.532612 | 0.011381 | p < 2.3e-308 | 1.000 | Meaningful |
| 10017 | ForestGeometry | LossRate | 0.478403 | 0.466689 | -0.011714 | p < 2.3e-308 | -1.000 | Meaningful |
| 10017 | ForestGeometry | AvgTxCost | 4.039268 | 3.003796 | -1.035472 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | 0.021667 | 0.024444 | 0.002778 | p = 0.4772 | 0.140 | Below1pp |
| 10013 | Default | TimelyRate | 0.999900 | 0.992446 | -0.007454 | p < 2.3e-308 | -1.000 | Below1pp |
| 10013 | Default | LossRate | 0.000100 | 0.007554 | 0.007454 | p < 2.3e-308 | 1.000 | Below1pp |
| 10013 | Default | AvgTxCost | 4.604709 | 3.042845 | -1.561864 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10013 | Default | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10013 | ForestGeometry | TimelyRate | 0.544093 | 0.552812 | 0.008719 | p < 2.3e-308 | 0.910 | Below1pp |
| 10013 | ForestGeometry | LossRate | 0.445291 | 0.382196 | -0.063095 | p < 2.3e-308 | -1.000 | Meaningful |
| 10013 | ForestGeometry | AvgTxCost | 3.401248 | 3.481636 | 0.080388 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10013 | ForestGeometry | EmgTimely | 0.599156 | 0.607670 | 0.008514 | p = 3.553e-15 | 0.875 | Below1pp |
| 10007 | Default | TimelyRate | 0.926755 | 0.995740 | 0.068985 | p < 2.3e-308 | 1.000 | Meaningful |
| 10007 | Default | LossRate | 0.073245 | 0.004260 | -0.068985 | p < 2.3e-308 | -1.000 | Meaningful |
| 10007 | Default | AvgTxCost | 4.831830 | 2.829165 | -2.002666 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10007 | Default | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | ForestGeometry | TimelyRate | 0.870050 | 0.865391 | -0.004659 | p < 2.3e-308 | -0.963 | Below1pp |
| 10007 | ForestGeometry | LossRate | 0.129950 | 0.134609 | 0.004659 | p < 2.3e-308 | 0.963 | Below1pp |
| 10007 | ForestGeometry | AvgTxCost | 4.821343 | 2.692733 | -2.128610 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10007 | ForestGeometry | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | Default | TimelyRate | 0.963927 | 0.996905 | 0.032978 | p < 2.3e-308 | 1.000 | Meaningful |
| 10015 | Default | LossRate | 0.036073 | 0.003095 | -0.032978 | p < 2.3e-308 | -1.000 | Meaningful |
| 10015 | Default | AvgTxCost | 1.781597 | 1.342660 | -0.438938 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10015 | Default | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | ForestGeometry | TimelyRate | 0.916306 | 0.908220 | -0.008087 | p < 2.3e-308 | -0.996 | Below1pp |
| 10015 | ForestGeometry | LossRate | 0.083694 | 0.091780 | 0.008087 | p < 2.3e-308 | 0.996 | Below1pp |
| 10015 | ForestGeometry | AvgTxCost | 1.748298 | 1.508214 | -0.240084 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10015 | ForestGeometry | EmgTimely | 1.000000 | 1.000000 | 0.000000 | p = 1 | 0.000 | Below1pp |

## 4. AoI-aware vs Risk-constrained-v6 显著性摘要

| Scene | Config | Metric | Baseline mean | V6 mean | Delta | Holm p | Effect RBC | Practical note |
|---|---|---|---:|---:|---:|---|---:|---|
| 10014 | Default | TimelyRate | 0.977038 | 0.991814 | 0.014775 | p < 2.3e-308 | 1.000 | Meaningful |
| 10014 | Default | LossRate | 0.022962 | 0.008186 | -0.014775 | p < 2.3e-308 | -1.000 | Meaningful |
| 10014 | Default | AvgTxCost | 2.199334 | 2.000552 | -0.198782 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10014 | Default | EmgTimely | 0.863333 | 1.000000 | 0.136667 | p = 2.153e-12 | 1.000 | Meaningful |
| 10014 | ForestGeometry | TimelyRate | 0.793278 | 0.799401 | 0.006123 | p < 2.3e-308 | 1.000 | Below1pp |
| 10014 | ForestGeometry | LossRate | 0.206656 | 0.200499 | -0.006156 | p < 2.3e-308 | -1.000 | Below1pp |
| 10014 | ForestGeometry | AvgTxCost | 2.369118 | 2.284253 | -0.084865 | p < 2.3e-308 | -0.983 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | 0.016667 | 0.023333 | 0.006667 | p = 0.153 | 1.000 | Below1pp |
| 10006 | Default | TimelyRate | 0.972013 | 0.989983 | 0.017970 | p < 2.3e-308 | 1.000 | Meaningful |
| 10006 | Default | LossRate | 0.026922 | 0.009318 | -0.017604 | p < 2.3e-308 | -1.000 | Meaningful |
| 10006 | Default | AvgTxCost | 2.371331 | 2.848957 | 0.477626 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10006 | Default | EmgTimely | 0.989737 | 0.995066 | 0.005329 | p = 3.127e-11 | 0.830 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.711913 | 0.713078 | 0.001165 | p = 0.02851 | 0.448 | Below1pp |
| 10006 | ForestGeometry | LossRate | 0.285092 | 0.285890 | 0.000799 | p = 0.07861 | 0.345 | Below1pp |
| 10006 | ForestGeometry | AvgTxCost | 2.652546 | 2.898837 | 0.246292 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.798618 | 0.799868 | 0.001250 | p = 0.06144 | 0.387 | Below1pp |
| 10011 | Default | TimelyRate | 0.993211 | 0.995108 | 0.001897 | p = 3.617e-08 | 0.940 | Below1pp |
| 10011 | Default | LossRate | 0.006789 | 0.004892 | -0.001897 | p = 3.617e-08 | -0.940 | Below1pp |
| 10011 | Default | AvgTxCost | 1.835541 | 1.888235 | 0.052694 | p < 2.3e-308 | 0.986 | SeeDelta |
| 10011 | Default | EmgTimely | 0.997000 | 1.000000 | 0.003000 | p = 0.07697 | 1.000 | Below1pp |
| 10011 | ForestGeometry | TimelyRate | 0.804592 | 0.801864 | -0.002729 | p = 0.07137 | -0.375 | Below1pp |
| 10011 | ForestGeometry | LossRate | 0.194143 | 0.191913 | -0.002230 | p = 0.07137 | -0.264 | Below1pp |
| 10011 | ForestGeometry | AvgTxCost | 4.037438 | 3.224041 | -0.813397 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10011 | ForestGeometry | EmgTimely | 0.327000 | 0.485000 | 0.158000 | p < 2.3e-308 | 0.977 | Meaningful |
| 10019 | Default | TimelyRate | 0.997937 | 0.999867 | 0.001930 | p < 2.3e-308 | 1.000 | Below1pp |
| 10019 | Default | LossRate | 0.002063 | 0.000133 | -0.001930 | p < 2.3e-308 | -1.000 | Below1pp |
| 10019 | Default | AvgTxCost | 1.687421 | 3.044759 | 1.357338 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10019 | Default | EmgTimely | 0.997875 | 1.000000 | 0.002125 | p < 2.3e-308 | 1.000 | Below1pp |
| 10019 | ForestGeometry | TimelyRate | 0.626123 | 0.617804 | -0.008319 | p = 2.309e-14 | -0.934 | Below1pp |
| 10019 | ForestGeometry | LossRate | 0.308885 | 0.314143 | 0.005258 | p = 1.551e-09 | 0.789 | Below1pp |
| 10019 | ForestGeometry | AvgTxCost | 3.315507 | 3.323024 | 0.007516 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10019 | ForestGeometry | EmgTimely | 0.588608 | 0.579451 | -0.009158 | p = 2.309e-14 | -0.934 | Below1pp |
| 10017 | Default | TimelyRate | 0.948586 | 0.979002 | 0.030416 | p < 2.3e-308 | 1.000 | Meaningful |
| 10017 | Default | LossRate | 0.051281 | 0.020865 | -0.030416 | p < 2.3e-308 | -1.000 | Meaningful |
| 10017 | Default | AvgTxCost | 3.328965 | 2.869517 | -0.459448 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10017 | Default | EmgTimely | 0.942222 | 0.981111 | 0.038889 | p = 3.938e-11 | 0.839 | Meaningful |
| 10017 | ForestGeometry | TimelyRate | 0.537404 | 0.532612 | -0.004792 | p < 2.3e-308 | -0.956 | Below1pp |
| 10017 | ForestGeometry | LossRate | 0.460632 | 0.466689 | 0.006057 | p < 2.3e-308 | 0.990 | Below1pp |
| 10017 | ForestGeometry | AvgTxCost | 4.099434 | 3.003796 | -1.095639 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | 0.030556 | 0.024444 | -0.006111 | p = 0.1591 | -0.336 | Below1pp |
| 10013 | Default | TimelyRate | 0.986922 | 0.992446 | 0.005524 | p < 2.3e-308 | 1.000 | Below1pp |
| 10013 | Default | LossRate | 0.013078 | 0.007554 | -0.005524 | p < 2.3e-308 | -1.000 | Below1pp |
| 10013 | Default | AvgTxCost | 1.686822 | 3.042845 | 1.356023 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10013 | Default | EmgTimely | 0.993505 | 1.000000 | 0.006495 | p < 2.3e-308 | 1.000 | Below1pp |
| 10013 | ForestGeometry | TimelyRate | 0.553844 | 0.552812 | -0.001032 | p = 0.5027 | -0.157 | Below1pp |
| 10013 | ForestGeometry | LossRate | 0.394443 | 0.382196 | -0.012246 | p < 2.3e-308 | -0.995 | Meaningful |
| 10013 | ForestGeometry | AvgTxCost | 3.427421 | 3.481636 | 0.054215 | p = 9.530e-12 | 0.882 | SeeDelta |
| 10013 | ForestGeometry | EmgTimely | 0.607193 | 0.607670 | 0.000477 | p = 0.608 | 0.105 | Below1pp |
| 10007 | Default | TimelyRate | 0.977870 | 0.995740 | 0.017870 | p < 2.3e-308 | 1.000 | Meaningful |
| 10007 | Default | LossRate | 0.022130 | 0.004260 | -0.017870 | p < 2.3e-308 | -1.000 | Meaningful |
| 10007 | Default | AvgTxCost | 2.298070 | 2.829165 | 0.531095 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10007 | Default | EmgTimely | 0.999294 | 1.000000 | 0.000706 | p = 0.001039 | 1.000 | Below1pp |
| 10007 | ForestGeometry | TimelyRate | 0.856306 | 0.865391 | 0.009085 | p < 2.3e-308 | 1.000 | Below1pp |
| 10007 | ForestGeometry | LossRate | 0.143694 | 0.134609 | -0.009085 | p < 2.3e-308 | -1.000 | Below1pp |
| 10007 | ForestGeometry | AvgTxCost | 2.298070 | 2.692733 | 0.394663 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10007 | ForestGeometry | EmgTimely | 0.999294 | 1.000000 | 0.000706 | p = 0.001039 | 1.000 | Below1pp |
| 10015 | Default | TimelyRate | 0.982130 | 0.996905 | 0.014775 | p < 2.3e-308 | 1.000 | Meaningful |
| 10015 | Default | LossRate | 0.017870 | 0.003095 | -0.014775 | p < 2.3e-308 | -1.000 | Meaningful |
| 10015 | Default | AvgTxCost | 1.290749 | 1.342660 | 0.051911 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10015 | Default | EmgTimely | 0.998462 | 1.000000 | 0.001538 | p = 0.3173 | 1.000 | Below1pp |
| 10015 | ForestGeometry | TimelyRate | 0.859567 | 0.908220 | 0.048652 | p < 2.3e-308 | 1.000 | Meaningful |
| 10015 | ForestGeometry | LossRate | 0.140433 | 0.091780 | -0.048652 | p < 2.3e-308 | -1.000 | Meaningful |
| 10015 | ForestGeometry | AvgTxCost | 1.382995 | 1.508214 | 0.125219 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10015 | ForestGeometry | EmgTimely | 0.986154 | 1.000000 | 0.013846 | p = 0.001039 | 1.000 | Meaningful |

## 5. 审稿口径

1. `DCC-like` 应解释为 ETSI DCC 风格的拥塞/链路负载响应基线，不是盲区感知方法。
2. `AoI-aware` 应解释为信息新鲜度驱动调度基线，不显式利用定位可信度和林区盲区风险。
3. 本 Step 的作用是补齐外部文献启发基线，不改变 Step49/Step50 的主方法参数和负例结论。
