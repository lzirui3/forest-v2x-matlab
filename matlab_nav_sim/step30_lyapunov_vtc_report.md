# Step 30 Lyapunov VTC Validation Report

This side-copy experiment validates the Lyapunov drift-plus-penalty scheduler on the same 5-scene VTC matrix used by Step17. It does not modify the main confidence-driven heuristic scheduler.

## Overall Mean Summary

| Scene | Config | Method | Timely | Loss | Avg Delay | Avg Tx Cost | Emergency Timely |
|---|---|---|---:|---:|---:|---:|---:|
| 10014 | Default | Link-delay-aware | 0.9601 | 0.0399 | 0.0269 | 1.6295 | 1.0000 |
| 10014 | Default | Confidence-heuristic | 0.9634 | 0.0366 | 0.0264 | 1.8750 | 1.0000 |
| 10014 | Default | Confidence-lyapunov | 0.9634 | 0.0366 | 0.0268 | 1.8387 | 1.0000 |
| 10014 | Default | Constrained Oracle | 0.9950 | 0.0050 | 0.0153 | 1.9078 | 1.0000 |
| 10014 | ForestGeometry | Link-delay-aware | 0.7537 | 0.2463 | 0.1014 | 1.6983 | 0.0000 |
| 10014 | ForestGeometry | Confidence-heuristic | 0.7787 | 0.2213 | 0.0911 | 2.2115 | 0.0000 |
| 10014 | ForestGeometry | Confidence-lyapunov | 0.7521 | 0.2479 | 0.1015 | 1.9080 | 0.0000 |
| 10014 | ForestGeometry | Constrained Oracle | 0.8037 | 0.1963 | 0.0812 | 2.6274 | 0.0000 |
| 10006 | Default | Link-delay-aware | 0.9451 | 0.0549 | 0.0329 | 2.1468 | 1.0000 |
| 10006 | Default | Confidence-heuristic | 0.9734 | 0.0266 | 0.0258 | 2.4671 | 1.0000 |
| 10006 | Default | Confidence-lyapunov | 0.9451 | 0.0549 | 0.0329 | 2.1596 | 1.0000 |
| 10006 | Default | Constrained Oracle | 0.9834 | 0.0166 | 0.0215 | 2.3247 | 1.0000 |
| 10006 | ForestGeometry | Link-delay-aware | 0.7072 | 0.2895 | 0.0900 | 2.2646 | 0.8125 |
| 10006 | ForestGeometry | Confidence-heuristic | 0.7138 | 0.2829 | 0.0894 | 2.7091 | 0.8158 |
| 10006 | ForestGeometry | Confidence-lyapunov | 0.7055 | 0.2945 | 0.0902 | 2.2964 | 0.8125 |
| 10006 | ForestGeometry | Constrained Oracle | 0.7255 | 0.2745 | 0.0845 | 2.8752 | 0.8125 |
| 10011 | Default | Link-delay-aware | 0.9967 | 0.0033 | 0.0126 | 1.7188 | 1.0000 |
| 10011 | Default | Confidence-heuristic | 0.9967 | 0.0033 | 0.0126 | 1.9644 | 1.0000 |
| 10011 | Default | Confidence-lyapunov | 0.9967 | 0.0033 | 0.0131 | 1.9240 | 1.0000 |
| 10011 | Default | Constrained Oracle | 0.9967 | 0.0033 | 0.0131 | 1.9240 | 1.0000 |
| 10011 | ForestGeometry | Link-delay-aware | 0.5890 | 0.4010 | 0.1556 | 2.7289 | 0.2000 |
| 10011 | ForestGeometry | Confidence-heuristic | 0.6755 | 0.3161 | 0.1372 | 3.4208 | 0.2000 |
| 10011 | ForestGeometry | Confidence-lyapunov | 0.5990 | 0.3943 | 0.1532 | 2.6584 | 0.2000 |
| 10011 | ForestGeometry | Constrained Oracle | 0.7088 | 0.2812 | 0.1286 | 4.0304 | 0.2000 |
| 10019 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0121 | 2.4997 | 1.0000 |
| 10019 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0121 | 2.9829 | 1.0000 |
| 10019 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0121 | 2.5116 | 1.0000 |
| 10019 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0121 | 2.5116 | 1.0000 |
| 10019 | ForestGeometry | Link-delay-aware | 0.6539 | 0.2879 | 0.0400 | 2.9584 | 0.6190 |
| 10019 | ForestGeometry | Confidence-heuristic | 0.6622 | 0.2712 | 0.0399 | 3.3581 | 0.6282 |
| 10019 | ForestGeometry | Confidence-lyapunov | 0.6589 | 0.2845 | 0.0398 | 2.8843 | 0.6245 |
| 10019 | ForestGeometry | Constrained Oracle | 0.6639 | 0.2629 | 0.0402 | 3.0214 | 0.6300 |
| 10017 | Default | Link-delay-aware | 0.9135 | 0.0865 | 0.0353 | 1.9231 | 1.0000 |
| 10017 | Default | Confidence-heuristic | 0.9601 | 0.0399 | 0.0249 | 2.3724 | 1.0000 |
| 10017 | Default | Confidence-lyapunov | 0.9135 | 0.0865 | 0.0357 | 2.1268 | 1.0000 |
| 10017 | Default | Constrained Oracle | 0.9800 | 0.0200 | 0.0216 | 2.4532 | 1.0000 |
| 10017 | ForestGeometry | Link-delay-aware | 0.5208 | 0.4775 | 0.1282 | 2.1792 | 0.0278 |
| 10017 | ForestGeometry | Confidence-heuristic | 0.5208 | 0.4775 | 0.1282 | 2.6389 | 0.0278 |
| 10017 | ForestGeometry | Confidence-lyapunov | 0.5158 | 0.4842 | 0.1293 | 2.2281 | 0.0278 |
| 10017 | ForestGeometry | Constrained Oracle | 0.5491 | 0.4509 | 0.1241 | 3.7861 | 0.0278 |

## Decision Table: Lyapunov vs Heuristic

| Scene | Config | Timely Gap (pp) | Emergency Gap (pp) | Cost Delta (%) | Delay Delta (%) | Decision |
|---|---|---:|---:|---:|---:|---|
| 10014 | Default | 0.000 | 0.000 | -1.94 | 1.61 | NotCompetitive |
| 10014 | ForestGeometry | -2.662 | 0.000 | -13.73 | 11.44 | CostOnlyVariant |
| 10006 | Default | -2.829 | 0.000 | -12.46 | 27.26 | CostOnlyVariant |
| 10006 | ForestGeometry | -0.832 | -0.329 | -15.23 | 0.91 | CostVariantWithPenalty |
| 10011 | Default | 0.000 | 0.000 | -2.06 | 3.37 | NotCompetitive |
| 10011 | ForestGeometry | -7.654 | 0.000 | -22.29 | 11.65 | CostOnlyVariant |
| 10019 | Default | 0.000 | 0.000 | -15.80 | 0.00 | PromisingCostVariant |
| 10019 | ForestGeometry | -0.333 | -0.366 | -14.11 | -0.22 | PromisingCostVariant |
| 10017 | Default | -4.659 | 0.000 | -10.35 | 43.18 | CostOnlyVariant |
| 10017 | ForestGeometry | -0.499 | 0.000 | -15.57 | 0.84 | PromisingCostVariant |

## Heuristic vs Lyapunov: Overall Significance

| Scene | Config | Metric | Heuristic/Base Mean | Lyapunov/Proposed Mean | Delta Mean | Delta % | Holm(all) | Practical |
|---|---|---|---:|---:|---:|---:|---|---|
| 10014 | Default | TimelyRate | 0.9634 | 0.9634 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | Default | LossRate | 0.0366 | 0.0366 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | Default | AvgDelay | 0.0264 | 0.0268 | 0.0004 | 1.614 | p = 1 | Sub-ms |
| 10014 | Default | AvgTxCost | 1.8750 | 1.8387 | -0.0364 | -1.939 | p = 1 | SeeDelta |
| 10014 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.7787 | 0.7521 | -0.0266 | -2.662 | p = 1 | Meaningful |
| 10014 | ForestGeometry | LossRate | 0.2213 | 0.2479 | 0.0266 | 2.662 | p = 1 | Meaningful |
| 10014 | ForestGeometry | AvgDelay | 0.0911 | 0.1015 | 0.0104 | 11.441 | p = 1 | Meaningful |
| 10014 | ForestGeometry | AvgTxCost | 2.2115 | 1.9080 | -0.3036 | -13.726 | p = 1 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | Default | TimelyRate | 0.9734 | 0.9451 | -0.0283 | -2.829 | p = 1 | Meaningful |
| 10006 | Default | LossRate | 0.0266 | 0.0549 | 0.0283 | 2.829 | p = 1 | Meaningful |
| 10006 | Default | AvgDelay | 0.0258 | 0.0329 | 0.0070 | 27.260 | p = 1 | Meaningful |
| 10006 | Default | AvgTxCost | 2.4671 | 2.1596 | -0.3075 | -12.464 | p = 1 | SeeDelta |
| 10006 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.7138 | 0.7055 | -0.0083 | -0.832 | p = 1 | Below1pp |
| 10006 | ForestGeometry | LossRate | 0.2829 | 0.2945 | 0.0116 | 1.165 | p = 1 | Meaningful |
| 10006 | ForestGeometry | AvgDelay | 0.0894 | 0.0902 | 0.0008 | 0.914 | p = 1 | Sub-ms |
| 10006 | ForestGeometry | AvgTxCost | 2.7091 | 2.2964 | -0.4127 | -15.234 | p = 1 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.8158 | 0.8125 | -0.0033 | -0.329 | p = 1 | Below1pp |
| 10011 | Default | TimelyRate | 0.9967 | 0.9967 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | LossRate | 0.0033 | 0.0033 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | AvgDelay | 0.0126 | 0.0131 | 0.0004 | 3.370 | p = 1 | Sub-ms |
| 10011 | Default | AvgTxCost | 1.9644 | 1.9240 | -0.0404 | -2.058 | p = 1 | SeeDelta |
| 10011 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | ForestGeometry | TimelyRate | 0.6755 | 0.5990 | -0.0765 | -7.654 | p = 1 | Meaningful |
| 10011 | ForestGeometry | LossRate | 0.3161 | 0.3943 | 0.0782 | 7.820 | p = 1 | Meaningful |
| 10011 | ForestGeometry | AvgDelay | 0.1372 | 0.1532 | 0.0160 | 11.646 | p = 1 | Meaningful |
| 10011 | ForestGeometry | AvgTxCost | 3.4208 | 2.6584 | -0.7624 | -22.287 | p = 1 | SeeDelta |
| 10011 | ForestGeometry | EmgTimely | 0.2000 | 0.2000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | AvgDelay | 0.0121 | 0.0121 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10019 | Default | AvgTxCost | 2.9829 | 2.5116 | -0.4712 | -15.797 | p = 1 | SeeDelta |
| 10019 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | ForestGeometry | TimelyRate | 0.6622 | 0.6589 | -0.0033 | -0.333 | p = 1 | Below1pp |
| 10019 | ForestGeometry | LossRate | 0.2712 | 0.2845 | 0.0133 | 1.331 | p = 1 | Meaningful |
| 10019 | ForestGeometry | AvgDelay | 0.0399 | 0.0398 | -0.0001 | -0.221 | p = 1 | Sub-ms |
| 10019 | ForestGeometry | AvgTxCost | 3.3581 | 2.8843 | -0.4738 | -14.109 | p = 1 | SeeDelta |
| 10019 | ForestGeometry | EmgTimely | 0.6282 | 0.6245 | -0.0037 | -0.366 | p = 1 | Below1pp |
| 10017 | Default | TimelyRate | 0.9601 | 0.9135 | -0.0466 | -4.659 | p = 1 | Meaningful |
| 10017 | Default | LossRate | 0.0399 | 0.0865 | 0.0466 | 4.659 | p = 1 | Meaningful |
| 10017 | Default | AvgDelay | 0.0249 | 0.0357 | 0.0108 | 43.177 | p = 1 | Meaningful |
| 10017 | Default | AvgTxCost | 2.3724 | 2.1268 | -0.2456 | -10.352 | p = 1 | SeeDelta |
| 10017 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | ForestGeometry | TimelyRate | 0.5208 | 0.5158 | -0.0050 | -0.499 | p = 1 | Below1pp |
| 10017 | ForestGeometry | LossRate | 0.4775 | 0.4842 | 0.0067 | 0.666 | p = 1 | Below1pp |
| 10017 | ForestGeometry | AvgDelay | 0.1282 | 0.1293 | 0.0011 | 0.839 | p = 1 | Meaningful |
| 10017 | ForestGeometry | AvgTxCost | 2.6389 | 2.2281 | -0.4108 | -15.566 | p = 1 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | 0.0278 | 0.0278 | 0.0000 | 0.000 | p = 1 | Below1pp |

## Heuristic vs Lyapunov: PosDeg_Emerg Significance

| Scene | Config | Metric | Heuristic/Base Mean | Lyapunov/Proposed Mean | Delta Mean | Delta % | Holm(all) | Practical |
|---|---|---|---:|---:|---:|---:|---|---|
| 10014 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | Default | AvgDelay | 0.0121 | 0.0144 | 0.0023 | 19.189 | p = 1 | Meaningful |
| 10014 | Default | AvgTxCost | 3.2000 | 2.9855 | -0.2145 | -6.705 | p = 1 | SeeDelta |
| 10014 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.8364 | 0.8364 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | ForestGeometry | LossRate | 0.1636 | 0.1636 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | ForestGeometry | AvgDelay | 0.0129 | 0.0143 | 0.0014 | 10.543 | p = 1 | Meaningful |
| 10014 | ForestGeometry | AvgTxCost | 3.7528 | 3.1250 | -0.6278 | -16.729 | p = 1 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | Default | AvgDelay | 0.0120 | 0.0120 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10006 | Default | AvgTxCost | 2.6918 | 2.5500 | -0.1418 | -5.268 | p = 1 | SeeDelta |
| 10006 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.9000 | 0.9000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | ForestGeometry | LossRate | 0.0909 | 0.1000 | 0.0091 | 0.909 | p = 1 | Below1pp |
| 10006 | ForestGeometry | AvgDelay | 0.0134 | 0.0125 | -0.0009 | -6.529 | p = 1 | Sub-ms |
| 10006 | ForestGeometry | AvgTxCost | 3.0453 | 2.8107 | -0.2345 | -7.702 | p = 1 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.9000 | 0.9000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | AvgDelay | 0.0120 | 0.0143 | 0.0023 | 19.416 | p = 1 | Meaningful |
| 10011 | Default | AvgTxCost | 3.0800 | 2.9427 | -0.1373 | -4.457 | p = 1 | SeeDelta |
| 10011 | Default | EmgTimely | NaN | NaN | NaN | NaN | p = 1 | NotApplicable |
| 10011 | ForestGeometry | TimelyRate | 0.9818 | 0.8545 | -0.1273 | -12.727 | p = 1 | Meaningful |
| 10011 | ForestGeometry | LossRate | 0.0182 | 0.1455 | 0.1273 | 12.727 | p = 1 | Meaningful |
| 10011 | ForestGeometry | AvgDelay | 0.0219 | 0.0196 | -0.0023 | -10.661 | p = 1 | Meaningful |
| 10011 | ForestGeometry | AvgTxCost | 3.7055 | 3.0445 | -0.6609 | -17.836 | p = 1 | SeeDelta |
| 10011 | ForestGeometry | EmgTimely | NaN | NaN | NaN | NaN | p = 1 | NotApplicable |
| 10019 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | AvgDelay | 0.0120 | 0.0120 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10019 | Default | AvgTxCost | 3.0082 | 2.6155 | -0.3927 | -13.055 | p = 1 | SeeDelta |
| 10019 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | ForestGeometry | TimelyRate | 0.5818 | 0.5818 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | ForestGeometry | LossRate | 0.2000 | 0.2364 | 0.0364 | 3.636 | p = 1 | Meaningful |
| 10019 | ForestGeometry | AvgDelay | 0.0534 | 0.0517 | -0.0017 | -3.134 | p = 1 | Meaningful |
| 10019 | ForestGeometry | AvgTxCost | 4.1545 | 3.8435 | -0.3109 | -7.484 | p = 1 | SeeDelta |
| 10019 | ForestGeometry | EmgTimely | 0.5818 | 0.5818 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | Default | AvgDelay | 0.0120 | 0.0144 | 0.0024 | 20.258 | p = 1 | Meaningful |
| 10017 | Default | AvgTxCost | 3.0809 | 2.9345 | -0.1464 | -4.751 | p = 1 | SeeDelta |
| 10017 | Default | EmgTimely | NaN | NaN | NaN | NaN | p = 1 | NotApplicable |
| 10017 | ForestGeometry | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | ForestGeometry | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | ForestGeometry | AvgDelay | 0.0120 | 0.0132 | 0.0012 | 10.372 | p = 1 | Meaningful |
| 10017 | ForestGeometry | AvgTxCost | 3.0845 | 2.9109 | -0.1736 | -5.629 | p = 1 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | NaN | NaN | NaN | NaN | p = 1 | NotApplicable |

## Link-delay-aware vs Lyapunov: Overall Significance

| Scene | Config | Metric | Heuristic/Base Mean | Lyapunov/Proposed Mean | Delta Mean | Delta % | Holm(all) | Practical |
|---|---|---|---:|---:|---:|---:|---|---|
| 10014 | Default | TimelyRate | 0.9601 | 0.9634 | 0.0033 | 0.333 | p = 1 | Below1pp |
| 10014 | Default | LossRate | 0.0399 | 0.0366 | -0.0033 | -0.333 | p = 1 | Below1pp |
| 10014 | Default | AvgDelay | 0.0269 | 0.0268 | -0.0001 | -0.302 | p = 1 | Sub-ms |
| 10014 | Default | AvgTxCost | 1.6295 | 1.8387 | 0.2092 | 12.841 | p = 1 | SeeDelta |
| 10014 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.7537 | 0.7521 | -0.0017 | -0.166 | p = 1 | Below1pp |
| 10014 | ForestGeometry | LossRate | 0.2463 | 0.2479 | 0.0017 | 0.166 | p = 1 | Below1pp |
| 10014 | ForestGeometry | AvgDelay | 0.1014 | 0.1015 | 0.0001 | 0.085 | p = 1 | Sub-ms |
| 10014 | ForestGeometry | AvgTxCost | 1.6983 | 1.9080 | 0.2097 | 12.344 | p = 1 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | Default | TimelyRate | 0.9451 | 0.9451 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | Default | LossRate | 0.0549 | 0.0549 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | Default | AvgDelay | 0.0329 | 0.0329 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10006 | Default | AvgTxCost | 2.1468 | 2.1596 | 0.0128 | 0.597 | p = 1 | SeeDelta |
| 10006 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.7072 | 0.7055 | -0.0017 | -0.166 | p = 1 | Below1pp |
| 10006 | ForestGeometry | LossRate | 0.2895 | 0.2945 | 0.0050 | 0.499 | p = 1 | Below1pp |
| 10006 | ForestGeometry | AvgDelay | 0.0900 | 0.0902 | 0.0002 | 0.198 | p = 1 | Sub-ms |
| 10006 | ForestGeometry | AvgTxCost | 2.2646 | 2.2964 | 0.0318 | 1.405 | p = 1 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.8125 | 0.8125 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | TimelyRate | 0.9967 | 0.9967 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | LossRate | 0.0033 | 0.0033 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | AvgDelay | 0.0126 | 0.0131 | 0.0004 | 3.370 | p = 1 | Sub-ms |
| 10011 | Default | AvgTxCost | 1.7188 | 1.9240 | 0.2052 | 11.936 | p = 1 | SeeDelta |
| 10011 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | ForestGeometry | TimelyRate | 0.5890 | 0.5990 | 0.0100 | 0.998 | p = 1 | Below1pp |
| 10011 | ForestGeometry | LossRate | 0.4010 | 0.3943 | -0.0067 | -0.666 | p = 1 | Below1pp |
| 10011 | ForestGeometry | AvgDelay | 0.1556 | 0.1532 | -0.0025 | -1.581 | p = 1 | Meaningful |
| 10011 | ForestGeometry | AvgTxCost | 2.7289 | 2.6584 | -0.0705 | -2.584 | p = 1 | SeeDelta |
| 10011 | ForestGeometry | EmgTimely | 0.2000 | 0.2000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | AvgDelay | 0.0121 | 0.0121 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10019 | Default | AvgTxCost | 2.4997 | 2.5116 | 0.0120 | 0.479 | p = 1 | SeeDelta |
| 10019 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | ForestGeometry | TimelyRate | 0.6539 | 0.6589 | 0.0050 | 0.499 | p = 1 | Below1pp |
| 10019 | ForestGeometry | LossRate | 0.2879 | 0.2845 | -0.0033 | -0.333 | p = 1 | Below1pp |
| 10019 | ForestGeometry | AvgDelay | 0.0400 | 0.0398 | -0.0001 | -0.372 | p = 1 | Sub-ms |
| 10019 | ForestGeometry | AvgTxCost | 2.9584 | 2.8843 | -0.0740 | -2.502 | p = 1 | SeeDelta |
| 10019 | ForestGeometry | EmgTimely | 0.6190 | 0.6245 | 0.0055 | 0.549 | p = 1 | Below1pp |
| 10017 | Default | TimelyRate | 0.9135 | 0.9135 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | Default | LossRate | 0.0865 | 0.0865 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | Default | AvgDelay | 0.0353 | 0.0357 | 0.0004 | 1.259 | p = 1 | Sub-ms |
| 10017 | Default | AvgTxCost | 1.9231 | 2.1268 | 0.2037 | 10.590 | p = 1 | SeeDelta |
| 10017 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | ForestGeometry | TimelyRate | 0.5208 | 0.5158 | -0.0050 | -0.499 | p = 1 | Below1pp |
| 10017 | ForestGeometry | LossRate | 0.4775 | 0.4842 | 0.0067 | 0.666 | p = 1 | Below1pp |
| 10017 | ForestGeometry | AvgDelay | 0.1282 | 0.1293 | 0.0011 | 0.839 | p = 1 | Meaningful |
| 10017 | ForestGeometry | AvgTxCost | 2.1792 | 2.2281 | 0.0489 | 2.245 | p = 1 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | 0.0278 | 0.0278 | 0.0000 | 0.000 | p = 1 | Below1pp |

## PosDeg_Emerg Mean Summary

| Scene | Config | Method | Timely | Loss | Avg Delay | Avg Tx Cost | Emergency Timely |
|---|---|---|---:|---:|---:|---:|---:|
| 10014 | Default | Link-delay-aware | 0.9909 | 0.0091 | 0.0120 | 2.0300 | 1.0000 |
| 10014 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0121 | 3.2000 | 1.0000 |
| 10014 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0144 | 2.9855 | 1.0000 |
| 10014 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0144 | 2.9855 | 1.0000 |
| 10014 | ForestGeometry | Link-delay-aware | 0.8364 | 0.1636 | 0.0128 | 2.1455 | 0.0000 |
| 10014 | ForestGeometry | Confidence-heuristic | 0.8364 | 0.1636 | 0.0129 | 3.7528 | 0.0000 |
| 10014 | ForestGeometry | Confidence-lyapunov | 0.8364 | 0.1636 | 0.0143 | 3.1250 | 0.0000 |
| 10014 | ForestGeometry | Constrained Oracle | 0.8364 | 0.1636 | 0.0144 | 3.5174 | 0.0000 |
| 10006 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.5500 | 1.0000 |
| 10006 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 2.6918 | 1.0000 |
| 10006 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0120 | 2.5500 | 1.0000 |
| 10006 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0120 | 2.5500 | 1.0000 |
| 10006 | ForestGeometry | Link-delay-aware | 0.8909 | 0.1000 | 0.0127 | 2.6155 | 0.8909 |
| 10006 | ForestGeometry | Confidence-heuristic | 0.9000 | 0.0909 | 0.0134 | 3.0453 | 0.9000 |
| 10006 | ForestGeometry | Confidence-lyapunov | 0.9000 | 0.1000 | 0.0125 | 2.8107 | 0.9000 |
| 10006 | ForestGeometry | Constrained Oracle | 0.9000 | 0.1000 | 0.0125 | 2.8107 | 0.9000 |
| 10011 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.0000 | NaN |
| 10011 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 3.0800 | NaN |
| 10011 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0143 | 2.9427 | NaN |
| 10011 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0143 | 2.9427 | NaN |
| 10011 | ForestGeometry | Link-delay-aware | 0.7818 | 0.2182 | 0.0185 | 2.0000 | NaN |
| 10011 | ForestGeometry | Confidence-heuristic | 0.9818 | 0.0182 | 0.0219 | 3.7055 | NaN |
| 10011 | ForestGeometry | Confidence-lyapunov | 0.8545 | 0.1455 | 0.0196 | 3.0445 | NaN |
| 10011 | ForestGeometry | Constrained Oracle | 0.9909 | 0.0091 | 0.0212 | 3.7736 | NaN |
| 10019 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.5500 | 1.0000 |
| 10019 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 3.0082 | 1.0000 |
| 10019 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0120 | 2.6155 | 1.0000 |
| 10019 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0120 | 2.6155 | 1.0000 |
| 10019 | ForestGeometry | Link-delay-aware | 0.5545 | 0.2545 | 0.0520 | 3.8283 | 0.5545 |
| 10019 | ForestGeometry | Confidence-heuristic | 0.5818 | 0.2000 | 0.0534 | 4.1545 | 0.5818 |
| 10019 | ForestGeometry | Confidence-lyapunov | 0.5818 | 0.2364 | 0.0517 | 3.8435 | 0.5818 |
| 10019 | ForestGeometry | Constrained Oracle | 0.5909 | 0.1636 | 0.0554 | 4.2415 | 0.5909 |
| 10017 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.0000 | NaN |
| 10017 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 3.0809 | NaN |
| 10017 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0144 | 2.9345 | NaN |
| 10017 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0144 | 2.9345 | NaN |
| 10017 | ForestGeometry | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.0000 | NaN |
| 10017 | ForestGeometry | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 3.0845 | NaN |
| 10017 | ForestGeometry | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0132 | 2.9109 | NaN |
| 10017 | ForestGeometry | Constrained Oracle | 1.0000 | 0.0000 | 0.0132 | 2.9109 | NaN |

## Interpretation

- If rows are classified as `PromisingCostVariant`, Lyapunov is worth optimizing into a stronger side method.
- If most rows are `CostOnlyVariant` or `NotCompetitive`, Lyapunov should remain a theoretical/cost-tradeoff baseline rather than replacing the main heuristic scheduler.
- A valid paper use is to state that Lyapunov formalization provides a tunable drift-plus-penalty counterpart, while the deployment-oriented heuristic occupies the high-reliability end of the Pareto tradeoff.
