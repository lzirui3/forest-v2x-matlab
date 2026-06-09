# Step 30 Lyapunov VTC Validation Report

This side-copy experiment validates the Lyapunov drift-plus-penalty scheduler on the same 5-scene VTC matrix used by Step17. It does not modify the main confidence-driven heuristic scheduler.

## Overall Mean Summary

| Scene | Config | Method | Timely | Loss | Avg Delay | Avg Tx Cost | Emergency Timely |
|---|---|---|---:|---:|---:|---:|---:|
| 10014 | Default | Link-delay-aware | 0.9687 | 0.0313 | 0.0242 | 1.6295 | 1.0000 |
| 10014 | Default | Confidence-heuristic | 0.9707 | 0.0293 | 0.0239 | 1.8555 | 1.0000 |
| 10014 | Default | Confidence-lyapunov | 0.9707 | 0.0293 | 0.0244 | 1.8197 | 1.0000 |
| 10014 | Default | Constrained Oracle | 0.9930 | 0.0070 | 0.0157 | 1.8903 | 1.0000 |
| 10014 | ForestGeometry | Link-delay-aware | 0.7391 | 0.2609 | 0.1055 | 1.6983 | 0.0167 |
| 10014 | ForestGeometry | Confidence-heuristic | 0.7704 | 0.2295 | 0.0936 | 2.1720 | 0.0167 |
| 10014 | ForestGeometry | Confidence-lyapunov | 0.7438 | 0.2561 | 0.1043 | 1.8836 | 0.0167 |
| 10014 | ForestGeometry | Constrained Oracle | 0.8008 | 0.1990 | 0.0815 | 2.6106 | 0.0167 |
| 10006 | Default | Link-delay-aware | 0.9456 | 0.0544 | 0.0337 | 2.1468 | 0.9974 |
| 10006 | Default | Confidence-heuristic | 0.9809 | 0.0191 | 0.0225 | 2.4729 | 0.9997 |
| 10006 | Default | Confidence-lyapunov | 0.9458 | 0.0542 | 0.0337 | 2.1613 | 0.9974 |
| 10006 | Default | Constrained Oracle | 0.9889 | 0.0111 | 0.0189 | 2.3265 | 0.9974 |
| 10006 | ForestGeometry | Link-delay-aware | 0.6905 | 0.3083 | 0.0927 | 2.2646 | 0.8016 |
| 10006 | ForestGeometry | Confidence-heuristic | 0.7068 | 0.2912 | 0.0894 | 2.6869 | 0.8026 |
| 10006 | ForestGeometry | Confidence-lyapunov | 0.6937 | 0.3058 | 0.0918 | 2.2695 | 0.8020 |
| 10006 | ForestGeometry | Constrained Oracle | 0.7158 | 0.2837 | 0.0862 | 2.8527 | 0.8020 |
| 10011 | Default | Link-delay-aware | 0.9972 | 0.0028 | 0.0127 | 1.7188 | 1.0000 |
| 10011 | Default | Confidence-heuristic | 0.9972 | 0.0028 | 0.0127 | 1.9424 | 1.0000 |
| 10011 | Default | Confidence-lyapunov | 0.9972 | 0.0028 | 0.0131 | 1.9007 | 1.0000 |
| 10011 | Default | Constrained Oracle | 0.9972 | 0.0028 | 0.0131 | 1.9007 | 1.0000 |
| 10011 | ForestGeometry | Link-delay-aware | 0.5905 | 0.4042 | 0.1557 | 2.7289 | 0.2950 |
| 10011 | ForestGeometry | Confidence-heuristic | 0.6794 | 0.3170 | 0.1378 | 3.3981 | 0.2750 |
| 10011 | ForestGeometry | Confidence-lyapunov | 0.6027 | 0.3952 | 0.1542 | 2.6355 | 0.2450 |
| 10011 | ForestGeometry | Constrained Oracle | 0.7017 | 0.2899 | 0.1326 | 4.0091 | 0.2900 |
| 10019 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0121 | 2.4997 | 1.0000 |
| 10019 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0121 | 2.9842 | 1.0000 |
| 10019 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0121 | 2.5051 | 1.0000 |
| 10019 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0121 | 2.5051 | 1.0000 |
| 10019 | ForestGeometry | Link-delay-aware | 0.6631 | 0.2784 | 0.0397 | 2.9584 | 0.6291 |
| 10019 | ForestGeometry | Confidence-heuristic | 0.6647 | 0.2694 | 0.0399 | 3.3328 | 0.6310 |
| 10019 | ForestGeometry | Confidence-lyapunov | 0.6591 | 0.2872 | 0.0397 | 2.8543 | 0.6247 |
| 10019 | ForestGeometry | Constrained Oracle | 0.6626 | 0.2617 | 0.0402 | 3.0112 | 0.6286 |
| 10017 | Default | Link-delay-aware | 0.9045 | 0.0955 | 0.0394 | 1.9231 | 0.9917 |
| 10017 | Default | Confidence-heuristic | 0.9514 | 0.0486 | 0.0282 | 2.3593 | 1.0000 |
| 10017 | Default | Confidence-lyapunov | 0.9045 | 0.0955 | 0.0399 | 2.1085 | 0.9917 |
| 10017 | Default | Constrained Oracle | 0.9775 | 0.0225 | 0.0212 | 2.4349 | 0.9917 |
| 10017 | ForestGeometry | Link-delay-aware | 0.5213 | 0.4779 | 0.1279 | 2.1792 | 0.0139 |
| 10017 | ForestGeometry | Confidence-heuristic | 0.5243 | 0.4749 | 0.1275 | 2.6696 | 0.0139 |
| 10017 | ForestGeometry | Confidence-lyapunov | 0.5183 | 0.4814 | 0.1286 | 2.2079 | 0.0111 |
| 10017 | ForestGeometry | Constrained Oracle | 0.5396 | 0.4601 | 0.1250 | 3.7618 | 0.0111 |

## Decision Table: Lyapunov vs Heuristic

| Scene | Config | Timely Gap (pp) | Emergency Gap (pp) | Cost Delta (%) | Delay Delta (%) | Decision |
|---|---|---:|---:|---:|---:|---|
| 10014 | Default | 0.000 | 0.000 | -1.93 | 1.96 | NotCompetitive |
| 10014 | ForestGeometry | -2.662 | 0.000 | -13.28 | 11.51 | CostOnlyVariant |
| 10006 | Default | -3.511 | -0.230 | -12.60 | 49.85 | CostOnlyVariant |
| 10006 | ForestGeometry | -1.314 | -0.066 | -15.53 | 2.69 | CostOnlyVariant |
| 10011 | Default | 0.000 | 0.000 | -2.15 | 3.47 | NotCompetitive |
| 10011 | ForestGeometry | -7.671 | -3.000 | -22.44 | 11.94 | CostOnlyVariant |
| 10019 | Default | 0.000 | 0.000 | -16.05 | 0.00 | PromisingCostVariant |
| 10019 | ForestGeometry | -0.566 | -0.623 | -14.36 | -0.46 | CostVariantWithPenalty |
| 10017 | Default | -4.692 | -0.833 | -10.63 | 41.10 | CostOnlyVariant |
| 10017 | ForestGeometry | -0.599 | -0.278 | -17.29 | 0.84 | CostVariantWithPenalty |

## Heuristic vs Lyapunov: Overall Significance

| Scene | Config | Metric | Heuristic/Base Mean | Lyapunov/Proposed Mean | Delta Mean | Delta % | Holm(all) | Practical |
|---|---|---|---:|---:|---:|---:|---|---|
| 10014 | Default | TimelyRate | 0.9707 | 0.9707 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | Default | LossRate | 0.0293 | 0.0293 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | Default | AvgDelay | 0.0239 | 0.0244 | 0.0005 | 1.964 | p = 1.468e-07 | Sub-ms |
| 10014 | Default | AvgTxCost | 1.8555 | 1.8197 | -0.0358 | -1.929 | p < 1e-15 | SeeDelta |
| 10014 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.7704 | 0.7438 | -0.0266 | -2.662 | p < 1e-15 | Meaningful |
| 10014 | ForestGeometry | LossRate | 0.2295 | 0.2561 | 0.0266 | 2.662 | p < 1e-15 | Meaningful |
| 10014 | ForestGeometry | AvgDelay | 0.0936 | 0.1043 | 0.0108 | 11.512 | p < 1e-15 | Meaningful |
| 10014 | ForestGeometry | AvgTxCost | 2.1720 | 1.8836 | -0.2885 | -13.281 | p < 1e-15 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | 0.0167 | 0.0167 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | Default | TimelyRate | 0.9809 | 0.9458 | -0.0351 | -3.511 | p < 1e-15 | Meaningful |
| 10006 | Default | LossRate | 0.0191 | 0.0542 | 0.0351 | 3.511 | p < 1e-15 | Meaningful |
| 10006 | Default | AvgDelay | 0.0225 | 0.0337 | 0.0112 | 49.855 | p < 1e-15 | Meaningful |
| 10006 | Default | AvgTxCost | 2.4729 | 2.1613 | -0.3115 | -12.598 | p < 1e-15 | SeeDelta |
| 10006 | Default | EmgTimely | 0.9997 | 0.9974 | -0.0023 | -0.230 | p = 0.01559 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.7068 | 0.6937 | -0.0131 | -1.314 | p < 1e-15 | Meaningful |
| 10006 | ForestGeometry | LossRate | 0.2912 | 0.3058 | 0.0146 | 1.464 | p < 1e-15 | Meaningful |
| 10006 | ForestGeometry | AvgDelay | 0.0894 | 0.0918 | 0.0024 | 2.685 | p = 7.772e-14 | Meaningful |
| 10006 | ForestGeometry | AvgTxCost | 2.6869 | 2.2695 | -0.4174 | -15.535 | p < 1e-15 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.8026 | 0.8020 | -0.0007 | -0.066 | p = 1 | Below1pp |
| 10011 | Default | TimelyRate | 0.9972 | 0.9972 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | LossRate | 0.0028 | 0.0028 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | AvgDelay | 0.0127 | 0.0131 | 0.0004 | 3.472 | p = 2.799e-06 | Sub-ms |
| 10011 | Default | AvgTxCost | 1.9424 | 1.9007 | -0.0417 | -2.148 | p < 1e-15 | SeeDelta |
| 10011 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | ForestGeometry | TimelyRate | 0.6794 | 0.6027 | -0.0767 | -7.671 | p < 1e-15 | Meaningful |
| 10011 | ForestGeometry | LossRate | 0.3170 | 0.3952 | 0.0782 | 7.820 | p < 1e-15 | Meaningful |
| 10011 | ForestGeometry | AvgDelay | 0.1378 | 0.1542 | 0.0164 | 11.938 | p < 1e-15 | Meaningful |
| 10011 | ForestGeometry | AvgTxCost | 3.3981 | 2.6355 | -0.7626 | -22.441 | p < 1e-15 | SeeDelta |
| 10011 | ForestGeometry | EmgTimely | 0.2750 | 0.2450 | -0.0300 | -3.000 | p = 0.003818 | Meaningful |
| 10019 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | AvgDelay | 0.0121 | 0.0121 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10019 | Default | AvgTxCost | 2.9842 | 2.5051 | -0.4791 | -16.055 | p < 1e-15 | SeeDelta |
| 10019 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | ForestGeometry | TimelyRate | 0.6647 | 0.6591 | -0.0057 | -0.566 | p = 3.291e-08 | Below1pp |
| 10019 | ForestGeometry | LossRate | 0.2694 | 0.2872 | 0.0178 | 1.780 | p < 1e-15 | Meaningful |
| 10019 | ForestGeometry | AvgDelay | 0.0399 | 0.0397 | -0.0002 | -0.464 | p = 4.308e-05 | Sub-ms |
| 10019 | ForestGeometry | AvgTxCost | 3.3328 | 2.8543 | -0.4785 | -14.357 | p < 1e-15 | SeeDelta |
| 10019 | ForestGeometry | EmgTimely | 0.6310 | 0.6247 | -0.0062 | -0.623 | p = 3.291e-08 | Below1pp |
| 10017 | Default | TimelyRate | 0.9514 | 0.9045 | -0.0469 | -4.692 | p < 1e-15 | Meaningful |
| 10017 | Default | LossRate | 0.0486 | 0.0955 | 0.0469 | 4.692 | p < 1e-15 | Meaningful |
| 10017 | Default | AvgDelay | 0.0282 | 0.0399 | 0.0116 | 41.102 | p < 1e-15 | Meaningful |
| 10017 | Default | AvgTxCost | 2.3593 | 2.1085 | -0.2508 | -10.631 | p < 1e-15 | SeeDelta |
| 10017 | Default | EmgTimely | 1.0000 | 0.9917 | -0.0083 | -0.833 | p = 0.6935 | Below1pp |
| 10017 | ForestGeometry | TimelyRate | 0.5243 | 0.5183 | -0.0060 | -0.599 | p = 6.783e-07 | Below1pp |
| 10017 | ForestGeometry | LossRate | 0.4749 | 0.4814 | 0.0065 | 0.649 | p = 1.468e-07 | Below1pp |
| 10017 | ForestGeometry | AvgDelay | 0.1275 | 0.1286 | 0.0011 | 0.838 | p = 9.492e-10 | Meaningful |
| 10017 | ForestGeometry | AvgTxCost | 2.6696 | 2.2079 | -0.4617 | -17.294 | p < 1e-15 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | 0.0139 | 0.0111 | -0.0028 | -0.278 | p = 1 | Below1pp |

## Heuristic vs Lyapunov: PosDeg_Emerg Significance

| Scene | Config | Metric | Heuristic/Base Mean | Lyapunov/Proposed Mean | Delta Mean | Delta % | Holm(all) | Practical |
|---|---|---|---:|---:|---:|---:|---|---|
| 10014 | Default | TimelyRate | 0.9991 | 0.9991 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | Default | LossRate | 0.0009 | 0.0009 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | Default | AvgDelay | 0.0122 | 0.0147 | 0.0024 | 19.922 | p = 1.583e-07 | Meaningful |
| 10014 | Default | AvgTxCost | 3.0877 | 2.9005 | -0.1872 | -6.062 | p < 1e-15 | SeeDelta |
| 10014 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.8282 | 0.8255 | -0.0027 | -0.273 | p = 1 | Below1pp |
| 10014 | ForestGeometry | LossRate | 0.1709 | 0.1736 | 0.0027 | 0.273 | p = 1 | Below1pp |
| 10014 | ForestGeometry | AvgDelay | 0.0130 | 0.0144 | 0.0013 | 10.281 | p = 4.260e-05 | Meaningful |
| 10014 | ForestGeometry | AvgTxCost | 3.5825 | 3.0545 | -0.5280 | -14.738 | p < 1e-15 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | 0.0167 | 0.0167 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | Default | AvgDelay | 0.0120 | 0.0120 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10006 | Default | AvgTxCost | 2.6629 | 2.5544 | -0.1085 | -4.076 | p < 1e-15 | SeeDelta |
| 10006 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.8955 | 0.8955 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | ForestGeometry | LossRate | 0.1018 | 0.1027 | 0.0009 | 0.091 | p = 1 | Below1pp |
| 10006 | ForestGeometry | AvgDelay | 0.0126 | 0.0125 | -0.0001 | -0.695 | p = 1 | Sub-ms |
| 10006 | ForestGeometry | AvgTxCost | 2.9296 | 2.7361 | -0.1935 | -6.606 | p < 1e-15 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.8955 | 0.8955 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | AvgDelay | 0.0120 | 0.0144 | 0.0023 | 19.378 | p = 1.249e-06 | Meaningful |
| 10011 | Default | AvgTxCost | 2.9753 | 2.8451 | -0.1302 | -4.375 | p = 4.619e-13 | SeeDelta |
| 10011 | Default | EmgTimely | NaN | NaN | NaN | NaN | p = 1 | NotApplicable |
| 10011 | ForestGeometry | TimelyRate | 0.9800 | 0.8964 | -0.0836 | -8.364 | p = 2.529e-10 | Meaningful |
| 10011 | ForestGeometry | LossRate | 0.0200 | 0.1036 | 0.0836 | 8.364 | p = 2.529e-10 | Meaningful |
| 10011 | ForestGeometry | AvgDelay | 0.0221 | 0.0209 | -0.0012 | -5.478 | p = 3.741e-05 | Meaningful |
| 10011 | ForestGeometry | AvgTxCost | 3.5640 | 3.0296 | -0.5344 | -14.993 | p < 1e-15 | SeeDelta |
| 10011 | ForestGeometry | EmgTimely | NaN | NaN | NaN | NaN | p = 1 | NotApplicable |
| 10019 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | AvgDelay | 0.0120 | 0.0120 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10019 | Default | AvgTxCost | 3.0027 | 2.5795 | -0.4233 | -14.096 | p < 1e-15 | SeeDelta |
| 10019 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | ForestGeometry | TimelyRate | 0.6082 | 0.5955 | -0.0127 | -1.273 | p = 0.004866 | Meaningful |
| 10019 | ForestGeometry | LossRate | 0.1591 | 0.1982 | 0.0391 | 3.909 | p < 1e-15 | Meaningful |
| 10019 | ForestGeometry | AvgDelay | 0.0546 | 0.0529 | -0.0017 | -3.050 | p < 1e-15 | Meaningful |
| 10019 | ForestGeometry | AvgTxCost | 4.1784 | 3.8803 | -0.2981 | -7.134 | p < 1e-15 | SeeDelta |
| 10019 | ForestGeometry | EmgTimely | 0.6082 | 0.5955 | -0.0127 | -1.273 | p = 0.004866 | Meaningful |
| 10017 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | Default | AvgDelay | 0.0120 | 0.0144 | 0.0023 | 19.462 | p = 1.132e-06 | Meaningful |
| 10017 | Default | AvgTxCost | 2.9747 | 2.8436 | -0.1311 | -4.407 | p = 1.022e-11 | SeeDelta |
| 10017 | Default | EmgTimely | NaN | NaN | NaN | NaN | p = 1 | NotApplicable |
| 10017 | ForestGeometry | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | ForestGeometry | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | ForestGeometry | AvgDelay | 0.0120 | 0.0136 | 0.0015 | 12.858 | p = 2.855e-10 | Meaningful |
| 10017 | ForestGeometry | AvgTxCost | 2.9942 | 2.8625 | -0.1317 | -4.399 | p < 1e-15 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | NaN | NaN | NaN | NaN | p = 1 | NotApplicable |

## Link-delay-aware vs Lyapunov: Overall Significance

| Scene | Config | Metric | Heuristic/Base Mean | Lyapunov/Proposed Mean | Delta Mean | Delta % | Holm(all) | Practical |
|---|---|---|---:|---:|---:|---:|---|---|
| 10014 | Default | TimelyRate | 0.9687 | 0.9707 | 0.0020 | 0.200 | p = 0.06875 | Below1pp |
| 10014 | Default | LossRate | 0.0313 | 0.0293 | -0.0020 | -0.200 | p = 0.06875 | Below1pp |
| 10014 | Default | AvgDelay | 0.0242 | 0.0244 | 0.0002 | 0.659 | p = 1 | Sub-ms |
| 10014 | Default | AvgTxCost | 1.6295 | 1.8197 | 0.1902 | 11.675 | p < 1e-15 | SeeDelta |
| 10014 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.7391 | 0.7438 | 0.0047 | 0.466 | p = 0.01056 | Below1pp |
| 10014 | ForestGeometry | LossRate | 0.2609 | 0.2561 | -0.0048 | -0.483 | p = 0.005899 | Below1pp |
| 10014 | ForestGeometry | AvgDelay | 0.1055 | 0.1043 | -0.0012 | -1.093 | p = 0.1225 | Meaningful |
| 10014 | ForestGeometry | AvgTxCost | 1.6983 | 1.8836 | 0.1852 | 10.906 | p < 1e-15 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | 0.0167 | 0.0167 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | Default | TimelyRate | 0.9456 | 0.9458 | 0.0002 | 0.017 | p = 1 | Below1pp |
| 10006 | Default | LossRate | 0.0544 | 0.0542 | -0.0002 | -0.017 | p = 1 | Below1pp |
| 10006 | Default | AvgDelay | 0.0337 | 0.0337 | -0.0000 | -0.040 | p = 1 | Sub-ms |
| 10006 | Default | AvgTxCost | 2.1468 | 2.1613 | 0.0146 | 0.679 | p = 5.415e-08 | SeeDelta |
| 10006 | Default | EmgTimely | 0.9974 | 0.9974 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.6905 | 0.6937 | 0.0032 | 0.316 | p = 0.05863 | Below1pp |
| 10006 | ForestGeometry | LossRate | 0.3083 | 0.3058 | -0.0025 | -0.250 | p = 1 | Below1pp |
| 10006 | ForestGeometry | AvgDelay | 0.0927 | 0.0918 | -0.0010 | -1.025 | p = 0.0237 | Sub-ms |
| 10006 | ForestGeometry | AvgTxCost | 2.2646 | 2.2695 | 0.0049 | 0.218 | p = 1 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.8016 | 0.8020 | 0.0003 | 0.033 | p = 1 | Below1pp |
| 10011 | Default | TimelyRate | 0.9972 | 0.9972 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | LossRate | 0.0028 | 0.0028 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | AvgDelay | 0.0127 | 0.0131 | 0.0004 | 3.472 | p = 6.532e-06 | Sub-ms |
| 10011 | Default | AvgTxCost | 1.7188 | 1.9007 | 0.1819 | 10.583 | p < 1e-15 | SeeDelta |
| 10011 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | ForestGeometry | TimelyRate | 0.5905 | 0.6027 | 0.0121 | 1.215 | p = 0.0945 | Meaningful |
| 10011 | ForestGeometry | LossRate | 0.4042 | 0.3952 | -0.0090 | -0.899 | p = 0.7087 | Below1pp |
| 10011 | ForestGeometry | AvgDelay | 0.1557 | 0.1542 | -0.0015 | -0.945 | p = 1 | Meaningful |
| 10011 | ForestGeometry | AvgTxCost | 2.7289 | 2.6355 | -0.0933 | -3.420 | p = 4.412e-12 | SeeDelta |
| 10011 | ForestGeometry | EmgTimely | 0.2950 | 0.2450 | -0.0500 | -5.000 | p = 0.0864 | Meaningful |
| 10019 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | AvgDelay | 0.0121 | 0.0121 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10019 | Default | AvgTxCost | 2.4997 | 2.5051 | 0.0054 | 0.216 | p = 0.09065 | SeeDelta |
| 10019 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | ForestGeometry | TimelyRate | 0.6631 | 0.6591 | -0.0040 | -0.399 | p = 1 | Below1pp |
| 10019 | ForestGeometry | LossRate | 0.2784 | 0.2872 | 0.0088 | 0.882 | p = 0.5435 | Below1pp |
| 10019 | ForestGeometry | AvgDelay | 0.0397 | 0.0397 | -0.0000 | -0.066 | p = 1 | Sub-ms |
| 10019 | ForestGeometry | AvgTxCost | 2.9584 | 2.8543 | -0.1040 | -3.516 | p = 9.451e-08 | SeeDelta |
| 10019 | ForestGeometry | EmgTimely | 0.6291 | 0.6247 | -0.0044 | -0.440 | p = 1 | Below1pp |
| 10017 | Default | TimelyRate | 0.9045 | 0.9045 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | Default | LossRate | 0.0955 | 0.0955 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | Default | AvgDelay | 0.0394 | 0.0399 | 0.0004 | 1.139 | p = 1.237e-05 | Sub-ms |
| 10017 | Default | AvgTxCost | 1.9231 | 2.1085 | 0.1853 | 9.637 | p < 1e-15 | SeeDelta |
| 10017 | Default | EmgTimely | 0.9917 | 0.9917 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | ForestGeometry | TimelyRate | 0.5213 | 0.5183 | -0.0030 | -0.300 | p = 0.001831 | Below1pp |
| 10017 | ForestGeometry | LossRate | 0.4779 | 0.4814 | 0.0035 | 0.349 | p = 0.001256 | Below1pp |
| 10017 | ForestGeometry | AvgDelay | 0.1279 | 0.1286 | 0.0007 | 0.572 | p = 2.682e-07 | Sub-ms |
| 10017 | ForestGeometry | AvgTxCost | 2.1792 | 2.2079 | 0.0287 | 1.317 | p = 0.1052 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | 0.0139 | 0.0111 | -0.0028 | -0.278 | p = 1 | Below1pp |

## PosDeg_Emerg Mean Summary

| Scene | Config | Method | Timely | Loss | Avg Delay | Avg Tx Cost | Emergency Timely |
|---|---|---|---:|---:|---:|---:|---:|
| 10014 | Default | Link-delay-aware | 0.9909 | 0.0091 | 0.0121 | 2.0300 | 1.0000 |
| 10014 | Default | Confidence-heuristic | 0.9991 | 0.0009 | 0.0122 | 3.0877 | 1.0000 |
| 10014 | Default | Confidence-lyapunov | 0.9991 | 0.0009 | 0.0147 | 2.9005 | 1.0000 |
| 10014 | Default | Constrained Oracle | 0.9991 | 0.0009 | 0.0147 | 2.9018 | 1.0000 |
| 10014 | ForestGeometry | Link-delay-aware | 0.8100 | 0.1900 | 0.0124 | 2.1455 | 0.0167 |
| 10014 | ForestGeometry | Confidence-heuristic | 0.8282 | 0.1709 | 0.0130 | 3.5825 | 0.0167 |
| 10014 | ForestGeometry | Confidence-lyapunov | 0.8255 | 0.1736 | 0.0144 | 3.0545 | 0.0167 |
| 10014 | ForestGeometry | Constrained Oracle | 0.8291 | 0.1700 | 0.0146 | 3.4463 | 0.0167 |
| 10006 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.5500 | 1.0000 |
| 10006 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 2.6629 | 1.0000 |
| 10006 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0120 | 2.5544 | 1.0000 |
| 10006 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0120 | 2.5544 | 1.0000 |
| 10006 | ForestGeometry | Link-delay-aware | 0.8936 | 0.1045 | 0.0123 | 2.6155 | 0.8936 |
| 10006 | ForestGeometry | Confidence-heuristic | 0.8955 | 0.1018 | 0.0126 | 2.9296 | 0.8955 |
| 10006 | ForestGeometry | Confidence-lyapunov | 0.8955 | 0.1027 | 0.0125 | 2.7361 | 0.8955 |
| 10006 | ForestGeometry | Constrained Oracle | 0.8955 | 0.1027 | 0.0125 | 2.7361 | 0.8955 |
| 10011 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.0000 | NaN |
| 10011 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 2.9753 | NaN |
| 10011 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0144 | 2.8451 | NaN |
| 10011 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0144 | 2.8451 | NaN |
| 10011 | ForestGeometry | Link-delay-aware | 0.7527 | 0.2473 | 0.0183 | 2.0000 | NaN |
| 10011 | ForestGeometry | Confidence-heuristic | 0.9800 | 0.0200 | 0.0221 | 3.5640 | NaN |
| 10011 | ForestGeometry | Confidence-lyapunov | 0.8964 | 0.1036 | 0.0209 | 3.0296 | NaN |
| 10011 | ForestGeometry | Constrained Oracle | 0.9864 | 0.0136 | 0.0218 | 3.6587 | NaN |
| 10019 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.5500 | 1.0000 |
| 10019 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 3.0027 | 1.0000 |
| 10019 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0120 | 2.5795 | 1.0000 |
| 10019 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0120 | 2.5795 | 1.0000 |
| 10019 | ForestGeometry | Link-delay-aware | 0.5955 | 0.2000 | 0.0530 | 3.8283 | 0.5955 |
| 10019 | ForestGeometry | Confidence-heuristic | 0.6082 | 0.1591 | 0.0546 | 4.1784 | 0.6082 |
| 10019 | ForestGeometry | Confidence-lyapunov | 0.5955 | 0.1982 | 0.0529 | 3.8803 | 0.5955 |
| 10019 | ForestGeometry | Constrained Oracle | 0.6064 | 0.1264 | 0.0565 | 4.3306 | 0.6064 |
| 10017 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.0000 | NaN |
| 10017 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 2.9747 | NaN |
| 10017 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0144 | 2.8436 | NaN |
| 10017 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0144 | 2.8436 | NaN |
| 10017 | ForestGeometry | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.0000 | NaN |
| 10017 | ForestGeometry | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 2.9942 | NaN |
| 10017 | ForestGeometry | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0136 | 2.8625 | NaN |
| 10017 | ForestGeometry | Constrained Oracle | 1.0000 | 0.0000 | 0.0136 | 2.8625 | NaN |

## Interpretation

- If rows are classified as `PromisingCostVariant`, Lyapunov is worth optimizing into a stronger side method.
- If most rows are `CostOnlyVariant` or `NotCompetitive`, Lyapunov should remain a theoretical/cost-tradeoff baseline rather than replacing the main heuristic scheduler.
- A valid paper use is to state that Lyapunov formalization provides a tunable drift-plus-penalty counterpart, while the deployment-oriented heuristic occupies the high-reliability end of the Pareto tradeoff.
