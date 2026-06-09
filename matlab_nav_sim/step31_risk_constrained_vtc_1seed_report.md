# Step 31 Risk-Constrained VTC Validation Report

This side-copy experiment validates a risk-constrained Lagrangian scheduler on the same VTC scene matrix used by Step17/Step30. It does not modify the main confidence-driven heuristic scheduler.

## Method Framing

The scheduler maximizes value-weighted timely delivery and penalizes communication cost plus soft violations of timely, reliability, deadline, and protection constraints. This makes the decision rule closer to a constrained optimization formulation than the legacy heuristic scorer.

## Overall Mean Summary

| Scene | Config | Method | Timely | Loss | Avg Delay | Avg Tx Cost | Emergency Timely |
|---|---|---|---:|---:|---:|---:|---:|
| 10014 | Default | Link-delay-aware | 0.9601 | 0.0399 | 0.0269 | 1.6295 | 1.0000 |
| 10014 | Default | Confidence-heuristic | 0.9634 | 0.0366 | 0.0264 | 1.8750 | 1.0000 |
| 10014 | Default | Risk-constrained | 0.9933 | 0.0067 | 0.0149 | 1.9211 | 1.0000 |
| 10014 | Default | Confidence-lyapunov | 0.9634 | 0.0366 | 0.0268 | 1.8387 | 1.0000 |
| 10014 | Default | Constrained Oracle | 0.9950 | 0.0050 | 0.0153 | 1.9078 | 1.0000 |
| 10014 | ForestGeometry | Link-delay-aware | 0.7537 | 0.2463 | 0.1014 | 1.6983 | 0.0000 |
| 10014 | ForestGeometry | Confidence-heuristic | 0.7787 | 0.2213 | 0.0911 | 2.2115 | 0.0000 |
| 10014 | ForestGeometry | Risk-constrained | 0.8053 | 0.1947 | 0.0795 | 2.6732 | 0.0000 |
| 10014 | ForestGeometry | Confidence-lyapunov | 0.7521 | 0.2479 | 0.1015 | 1.9080 | 0.0000 |
| 10014 | ForestGeometry | Constrained Oracle | 0.8037 | 0.1963 | 0.0812 | 2.6274 | 0.0000 |
| 10006 | Default | Link-delay-aware | 0.9451 | 0.0549 | 0.0329 | 2.1468 | 1.0000 |
| 10006 | Default | Confidence-heuristic | 0.9734 | 0.0266 | 0.0258 | 2.4671 | 1.0000 |
| 10006 | Default | Risk-constrained | 0.9850 | 0.0150 | 0.0197 | 2.3301 | 1.0000 |
| 10006 | Default | Confidence-lyapunov | 0.9451 | 0.0549 | 0.0329 | 2.1596 | 1.0000 |
| 10006 | Default | Constrained Oracle | 0.9834 | 0.0166 | 0.0215 | 2.3247 | 1.0000 |
| 10006 | ForestGeometry | Link-delay-aware | 0.7072 | 0.2895 | 0.0900 | 2.2646 | 0.8125 |
| 10006 | ForestGeometry | Confidence-heuristic | 0.7138 | 0.2829 | 0.0894 | 2.7091 | 0.8158 |
| 10006 | ForestGeometry | Risk-constrained | 0.7288 | 0.2712 | 0.0832 | 2.9702 | 0.8125 |
| 10006 | ForestGeometry | Confidence-lyapunov | 0.7055 | 0.2945 | 0.0902 | 2.2964 | 0.8125 |
| 10006 | ForestGeometry | Constrained Oracle | 0.7255 | 0.2745 | 0.0845 | 2.8752 | 0.8125 |
| 10011 | Default | Link-delay-aware | 0.9967 | 0.0033 | 0.0126 | 1.7188 | 1.0000 |
| 10011 | Default | Confidence-heuristic | 0.9967 | 0.0033 | 0.0126 | 1.9644 | 1.0000 |
| 10011 | Default | Risk-constrained | 0.9967 | 0.0033 | 0.0126 | 1.9323 | 1.0000 |
| 10011 | Default | Confidence-lyapunov | 0.9967 | 0.0033 | 0.0131 | 1.9240 | 1.0000 |
| 10011 | Default | Constrained Oracle | 0.9967 | 0.0033 | 0.0131 | 1.9240 | 1.0000 |
| 10011 | ForestGeometry | Link-delay-aware | 0.5890 | 0.4010 | 0.1556 | 2.7289 | 0.2000 |
| 10011 | ForestGeometry | Confidence-heuristic | 0.6755 | 0.3161 | 0.1372 | 3.4208 | 0.2000 |
| 10011 | ForestGeometry | Risk-constrained | 0.7371 | 0.2529 | 0.1160 | 4.0867 | 0.2000 |
| 10011 | ForestGeometry | Confidence-lyapunov | 0.5990 | 0.3943 | 0.1532 | 2.6584 | 0.2000 |
| 10011 | ForestGeometry | Constrained Oracle | 0.7088 | 0.2812 | 0.1286 | 4.0304 | 0.2000 |
| 10019 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0121 | 2.4997 | 1.0000 |
| 10019 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0121 | 2.9829 | 1.0000 |
| 10019 | Default | Risk-constrained | 1.0000 | 0.0000 | 0.0121 | 2.5785 | 1.0000 |
| 10019 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0121 | 2.5116 | 1.0000 |
| 10019 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0121 | 2.5116 | 1.0000 |
| 10019 | ForestGeometry | Link-delay-aware | 0.6539 | 0.2879 | 0.0400 | 2.9584 | 0.6190 |
| 10019 | ForestGeometry | Confidence-heuristic | 0.6622 | 0.2712 | 0.0399 | 3.3581 | 0.6282 |
| 10019 | ForestGeometry | Risk-constrained | 0.6622 | 0.2745 | 0.0401 | 2.9382 | 0.6282 |
| 10019 | ForestGeometry | Confidence-lyapunov | 0.6589 | 0.2845 | 0.0398 | 2.8843 | 0.6245 |
| 10019 | ForestGeometry | Constrained Oracle | 0.6639 | 0.2629 | 0.0402 | 3.0214 | 0.6300 |
| 10017 | Default | Link-delay-aware | 0.9135 | 0.0865 | 0.0353 | 1.9231 | 1.0000 |
| 10017 | Default | Confidence-heuristic | 0.9601 | 0.0399 | 0.0249 | 2.3724 | 1.0000 |
| 10017 | Default | Risk-constrained | 0.9684 | 0.0316 | 0.0232 | 2.3874 | 1.0000 |
| 10017 | Default | Confidence-lyapunov | 0.9135 | 0.0865 | 0.0357 | 2.1268 | 1.0000 |
| 10017 | Default | Constrained Oracle | 0.9784 | 0.0216 | 0.0218 | 2.4532 | 1.0000 |
| 10017 | ForestGeometry | Link-delay-aware | 0.5208 | 0.4775 | 0.1282 | 2.1792 | 0.0278 |
| 10017 | ForestGeometry | Confidence-heuristic | 0.5208 | 0.4775 | 0.1282 | 2.6389 | 0.0278 |
| 10017 | ForestGeometry | Risk-constrained | 0.5524 | 0.4476 | 0.1223 | 3.9197 | 0.0278 |
| 10017 | ForestGeometry | Confidence-lyapunov | 0.5158 | 0.4842 | 0.1293 | 2.2281 | 0.0278 |
| 10017 | ForestGeometry | Constrained Oracle | 0.5491 | 0.4509 | 0.1241 | 3.7861 | 0.0278 |

## Decision Table: Risk-Constrained vs Heuristic

| Scene | Config | Timely Gap (pp) | Emergency Gap (pp) | Cost Delta (%) | Delay Delta (%) | Decision |
|---|---|---:|---:|---:|---:|---|
| 10014 | Default | 2.995 | 0.000 | 2.46 | -43.36 | CandidateMainMethod |
| 10014 | ForestGeometry | 2.662 | 0.000 | 20.88 | -12.76 | CandidateMainMethod |
| 10006 | Default | 1.165 | 0.000 | -5.55 | -23.74 | CandidateMainMethod |
| 10006 | ForestGeometry | 1.498 | -0.329 | 9.64 | -6.92 | CandidateMainMethod |
| 10011 | Default | 0.000 | 0.000 | -1.63 | 0.00 | CandidateMainMethod |
| 10011 | ForestGeometry | 6.156 | 0.000 | 19.47 | -15.49 | CandidateMainMethod |
| 10019 | Default | 0.000 | 0.000 | -13.55 | 0.00 | CandidateMainMethod |
| 10019 | ForestGeometry | 0.000 | 0.000 | -12.51 | 0.41 | CandidateMainMethod |
| 10017 | Default | 0.832 | 0.000 | 0.63 | -6.95 | CandidateMainMethod |
| 10017 | ForestGeometry | 3.161 | 0.000 | 48.54 | -4.58 | CandidateMainMethod |

## Heuristic vs Risk-Constrained: Overall Significance

| Scene | Config | Metric | Heuristic Mean | Risk Mean | Delta Mean | Delta % | Holm(all) | Practical |
|---|---|---|---:|---:|---:|---:|---|---|
| 10014 | Default | TimelyRate | 0.9634 | 0.9933 | 0.0300 | 2.995 | p = 1 | Meaningful |
| 10014 | Default | LossRate | 0.0366 | 0.0067 | -0.0300 | -2.995 | p = 1 | Meaningful |
| 10014 | Default | AvgDelay | 0.0264 | 0.0149 | -0.0114 | -43.360 | p = 1 | Meaningful |
| 10014 | Default | AvgTxCost | 1.8750 | 1.9211 | 0.0461 | 2.458 | p = 1 | SeeDelta |
| 10014 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.7787 | 0.8053 | 0.0266 | 2.662 | p = 1 | Meaningful |
| 10014 | ForestGeometry | LossRate | 0.2213 | 0.1947 | -0.0266 | -2.662 | p = 1 | Meaningful |
| 10014 | ForestGeometry | AvgDelay | 0.0911 | 0.0795 | -0.0116 | -12.763 | p = 1 | Meaningful |
| 10014 | ForestGeometry | AvgTxCost | 2.2115 | 2.6732 | 0.4617 | 20.877 | p = 1 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | Default | TimelyRate | 0.9734 | 0.9850 | 0.0116 | 1.165 | p = 1 | Meaningful |
| 10006 | Default | LossRate | 0.0266 | 0.0150 | -0.0116 | -1.165 | p = 1 | Meaningful |
| 10006 | Default | AvgDelay | 0.0258 | 0.0197 | -0.0061 | -23.743 | p = 1 | Meaningful |
| 10006 | Default | AvgTxCost | 2.4671 | 2.3301 | -0.1369 | -5.551 | p = 1 | SeeDelta |
| 10006 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.7138 | 0.7288 | 0.0150 | 1.498 | p = 1 | Meaningful |
| 10006 | ForestGeometry | LossRate | 0.2829 | 0.2712 | -0.0116 | -1.165 | p = 1 | Meaningful |
| 10006 | ForestGeometry | AvgDelay | 0.0894 | 0.0832 | -0.0062 | -6.917 | p = 1 | Meaningful |
| 10006 | ForestGeometry | AvgTxCost | 2.7091 | 2.9702 | 0.2611 | 9.640 | p = 1 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.8158 | 0.8125 | -0.0033 | -0.329 | p = 1 | Below1pp |
| 10011 | Default | TimelyRate | 0.9967 | 0.9967 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | LossRate | 0.0033 | 0.0033 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | AvgDelay | 0.0126 | 0.0126 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10011 | Default | AvgTxCost | 1.9644 | 1.9323 | -0.0321 | -1.635 | p = 1 | SeeDelta |
| 10011 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | ForestGeometry | TimelyRate | 0.6755 | 0.7371 | 0.0616 | 6.156 | p = 1 | Meaningful |
| 10011 | ForestGeometry | LossRate | 0.3161 | 0.2529 | -0.0632 | -6.323 | p = 1 | Meaningful |
| 10011 | ForestGeometry | AvgDelay | 0.1372 | 0.1160 | -0.0212 | -15.487 | p = 1 | Meaningful |
| 10011 | ForestGeometry | AvgTxCost | 3.4208 | 4.0867 | 0.6660 | 19.468 | p = 1 | SeeDelta |
| 10011 | ForestGeometry | EmgTimely | 0.2000 | 0.2000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | AvgDelay | 0.0121 | 0.0121 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10019 | Default | AvgTxCost | 2.9829 | 2.5785 | -0.4043 | -13.555 | p = 1 | SeeDelta |
| 10019 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | ForestGeometry | TimelyRate | 0.6622 | 0.6622 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | ForestGeometry | LossRate | 0.2712 | 0.2745 | 0.0033 | 0.333 | p = 1 | Below1pp |
| 10019 | ForestGeometry | AvgDelay | 0.0399 | 0.0401 | 0.0002 | 0.414 | p = 1 | Sub-ms |
| 10019 | ForestGeometry | AvgTxCost | 3.3581 | 2.9382 | -0.4200 | -12.505 | p = 1 | SeeDelta |
| 10019 | ForestGeometry | EmgTimely | 0.6282 | 0.6282 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | Default | TimelyRate | 0.9601 | 0.9684 | 0.0083 | 0.832 | p = 1 | Below1pp |
| 10017 | Default | LossRate | 0.0399 | 0.0316 | -0.0083 | -0.832 | p = 1 | Below1pp |
| 10017 | Default | AvgDelay | 0.0249 | 0.0232 | -0.0017 | -6.951 | p = 1 | Meaningful |
| 10017 | Default | AvgTxCost | 2.3724 | 2.3874 | 0.0150 | 0.631 | p = 1 | SeeDelta |
| 10017 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | ForestGeometry | TimelyRate | 0.5208 | 0.5524 | 0.0316 | 3.161 | p = 1 | Meaningful |
| 10017 | ForestGeometry | LossRate | 0.4775 | 0.4476 | -0.0300 | -2.995 | p = 1 | Meaningful |
| 10017 | ForestGeometry | AvgDelay | 0.1282 | 0.1223 | -0.0059 | -4.578 | p = 1 | Meaningful |
| 10017 | ForestGeometry | AvgTxCost | 2.6389 | 3.9197 | 1.2808 | 48.536 | p = 1 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | 0.0278 | 0.0278 | 0.0000 | 0.000 | p = 1 | Below1pp |

## Link-delay-aware vs Risk-Constrained: Overall Significance

| Scene | Config | Metric | Link-delay-aware Mean | Risk Mean | Delta Mean | Delta % | Holm(all) | Practical |
|---|---|---|---:|---:|---:|---:|---|---|
| 10014 | Default | TimelyRate | 0.9601 | 0.9933 | 0.0333 | 3.328 | p = 1 | Meaningful |
| 10014 | Default | LossRate | 0.0399 | 0.0067 | -0.0333 | -3.328 | p = 1 | Meaningful |
| 10014 | Default | AvgDelay | 0.0269 | 0.0149 | -0.0119 | -44.428 | p = 1 | Meaningful |
| 10014 | Default | AvgTxCost | 1.6295 | 1.9211 | 0.2917 | 17.901 | p = 1 | SeeDelta |
| 10014 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.7537 | 0.8053 | 0.0516 | 5.158 | p = 1 | Meaningful |
| 10014 | ForestGeometry | LossRate | 0.2463 | 0.1947 | -0.0516 | -5.158 | p = 1 | Meaningful |
| 10014 | ForestGeometry | AvgDelay | 0.1014 | 0.0795 | -0.0220 | -21.653 | p = 1 | Meaningful |
| 10014 | ForestGeometry | AvgTxCost | 1.6983 | 2.6732 | 0.9749 | 57.404 | p = 1 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | Default | TimelyRate | 0.9451 | 0.9850 | 0.0399 | 3.993 | p = 1 | Meaningful |
| 10006 | Default | LossRate | 0.0549 | 0.0150 | -0.0399 | -3.993 | p = 1 | Meaningful |
| 10006 | Default | AvgDelay | 0.0329 | 0.0197 | -0.0132 | -40.078 | p = 1 | Meaningful |
| 10006 | Default | AvgTxCost | 2.1468 | 2.3301 | 0.1834 | 8.541 | p = 1 | SeeDelta |
| 10006 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.7072 | 0.7288 | 0.0216 | 2.163 | p = 1 | Meaningful |
| 10006 | ForestGeometry | LossRate | 0.2895 | 0.2712 | -0.0183 | -1.830 | p = 1 | Meaningful |
| 10006 | ForestGeometry | AvgDelay | 0.0900 | 0.0832 | -0.0068 | -7.578 | p = 1 | Meaningful |
| 10006 | ForestGeometry | AvgTxCost | 2.2646 | 2.9702 | 0.7057 | 31.162 | p = 1 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.8125 | 0.8125 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | TimelyRate | 0.9967 | 0.9967 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | LossRate | 0.0033 | 0.0033 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | AvgDelay | 0.0126 | 0.0126 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10011 | Default | AvgTxCost | 1.7188 | 1.9323 | 0.2135 | 12.420 | p = 1 | SeeDelta |
| 10011 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | ForestGeometry | TimelyRate | 0.5890 | 0.7371 | 0.1481 | 14.809 | p = 1 | Meaningful |
| 10011 | ForestGeometry | LossRate | 0.4010 | 0.2529 | -0.1481 | -14.809 | p = 1 | Meaningful |
| 10011 | ForestGeometry | AvgDelay | 0.1556 | 0.1160 | -0.0397 | -25.500 | p = 1 | Meaningful |
| 10011 | ForestGeometry | AvgTxCost | 2.7289 | 4.0867 | 1.3578 | 49.758 | p = 1 | SeeDelta |
| 10011 | ForestGeometry | EmgTimely | 0.2000 | 0.2000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | AvgDelay | 0.0121 | 0.0121 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10019 | Default | AvgTxCost | 2.4997 | 2.5785 | 0.0789 | 3.155 | p = 1 | SeeDelta |
| 10019 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | ForestGeometry | TimelyRate | 0.6539 | 0.6622 | 0.0083 | 0.832 | p = 1 | Below1pp |
| 10019 | ForestGeometry | LossRate | 0.2879 | 0.2745 | -0.0133 | -1.331 | p = 1 | Meaningful |
| 10019 | ForestGeometry | AvgDelay | 0.0400 | 0.0401 | 0.0001 | 0.261 | p = 1 | Sub-ms |
| 10019 | ForestGeometry | AvgTxCost | 2.9584 | 2.9382 | -0.0202 | -0.682 | p = 1 | SeeDelta |
| 10019 | ForestGeometry | EmgTimely | 0.6190 | 0.6282 | 0.0092 | 0.916 | p = 1 | Below1pp |
| 10017 | Default | TimelyRate | 0.9135 | 0.9684 | 0.0549 | 5.491 | p = 1 | Meaningful |
| 10017 | Default | LossRate | 0.0865 | 0.0316 | -0.0549 | -5.491 | p = 1 | Meaningful |
| 10017 | Default | AvgDelay | 0.0353 | 0.0232 | -0.0121 | -34.193 | p = 1 | Meaningful |
| 10017 | Default | AvgTxCost | 1.9231 | 2.3874 | 0.4642 | 24.139 | p = 1 | SeeDelta |
| 10017 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | ForestGeometry | TimelyRate | 0.5208 | 0.5524 | 0.0316 | 3.161 | p = 1 | Meaningful |
| 10017 | ForestGeometry | LossRate | 0.4775 | 0.4476 | -0.0300 | -2.995 | p = 1 | Meaningful |
| 10017 | ForestGeometry | AvgDelay | 0.1282 | 0.1223 | -0.0059 | -4.578 | p = 1 | Meaningful |
| 10017 | ForestGeometry | AvgTxCost | 2.1792 | 3.9197 | 1.7405 | 79.869 | p = 1 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | 0.0278 | 0.0278 | 0.0000 | 0.000 | p = 1 | Below1pp |

## Lyapunov vs Risk-Constrained: Overall Significance

| Scene | Config | Metric | Lyapunov Mean | Risk Mean | Delta Mean | Delta % | Holm(all) | Practical |
|---|---|---|---:|---:|---:|---:|---|---|
| 10014 | Default | TimelyRate | 0.9634 | 0.9933 | 0.0300 | 2.995 | p = 1 | Meaningful |
| 10014 | Default | LossRate | 0.0366 | 0.0067 | -0.0300 | -2.995 | p = 1 | Meaningful |
| 10014 | Default | AvgDelay | 0.0268 | 0.0149 | -0.0119 | -44.260 | p = 1 | Meaningful |
| 10014 | Default | AvgTxCost | 1.8387 | 1.9211 | 0.0824 | 4.484 | p = 1 | SeeDelta |
| 10014 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.7521 | 0.8053 | 0.0532 | 5.324 | p = 1 | Meaningful |
| 10014 | ForestGeometry | LossRate | 0.2479 | 0.1947 | -0.0532 | -5.324 | p = 1 | Meaningful |
| 10014 | ForestGeometry | AvgDelay | 0.1015 | 0.0795 | -0.0221 | -21.720 | p = 1 | Meaningful |
| 10014 | ForestGeometry | AvgTxCost | 1.9080 | 2.6732 | 0.7653 | 40.108 | p = 1 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | Default | TimelyRate | 0.9451 | 0.9850 | 0.0399 | 3.993 | p = 1 | Meaningful |
| 10006 | Default | LossRate | 0.0549 | 0.0150 | -0.0399 | -3.993 | p = 1 | Meaningful |
| 10006 | Default | AvgDelay | 0.0329 | 0.0197 | -0.0132 | -40.078 | p = 1 | Meaningful |
| 10006 | Default | AvgTxCost | 2.1596 | 2.3301 | 0.1705 | 7.897 | p = 1 | SeeDelta |
| 10006 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.7055 | 0.7288 | 0.0233 | 2.329 | p = 1 | Meaningful |
| 10006 | ForestGeometry | LossRate | 0.2945 | 0.2712 | -0.0233 | -2.329 | p = 1 | Meaningful |
| 10006 | ForestGeometry | AvgDelay | 0.0902 | 0.0832 | -0.0070 | -7.760 | p = 1 | Meaningful |
| 10006 | ForestGeometry | AvgTxCost | 2.2964 | 2.9702 | 0.6739 | 29.345 | p = 1 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.8125 | 0.8125 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | TimelyRate | 0.9967 | 0.9967 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | LossRate | 0.0033 | 0.0033 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | AvgDelay | 0.0131 | 0.0126 | -0.0004 | -3.260 | p = 1 | Sub-ms |
| 10011 | Default | AvgTxCost | 1.9240 | 1.9323 | 0.0083 | 0.432 | p = 1 | SeeDelta |
| 10011 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | ForestGeometry | TimelyRate | 0.5990 | 0.7371 | 0.1381 | 13.810 | p = 1 | Meaningful |
| 10011 | ForestGeometry | LossRate | 0.3943 | 0.2529 | -0.1414 | -14.143 | p = 1 | Meaningful |
| 10011 | ForestGeometry | AvgDelay | 0.1532 | 0.1160 | -0.0372 | -24.303 | p = 1 | Meaningful |
| 10011 | ForestGeometry | AvgTxCost | 2.6584 | 4.0867 | 1.4284 | 53.730 | p = 1 | SeeDelta |
| 10011 | ForestGeometry | EmgTimely | 0.2000 | 0.2000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | AvgDelay | 0.0121 | 0.0121 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10019 | Default | AvgTxCost | 2.5116 | 2.5785 | 0.0669 | 2.663 | p = 1 | SeeDelta |
| 10019 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | ForestGeometry | TimelyRate | 0.6589 | 0.6622 | 0.0033 | 0.333 | p = 1 | Below1pp |
| 10019 | ForestGeometry | LossRate | 0.2845 | 0.2745 | -0.0100 | -0.998 | p = 1 | Below1pp |
| 10019 | ForestGeometry | AvgDelay | 0.0398 | 0.0401 | 0.0003 | 0.636 | p = 1 | Sub-ms |
| 10019 | ForestGeometry | AvgTxCost | 2.8843 | 2.9382 | 0.0539 | 1.867 | p = 1 | SeeDelta |
| 10019 | ForestGeometry | EmgTimely | 0.6245 | 0.6282 | 0.0037 | 0.366 | p = 1 | Below1pp |
| 10017 | Default | TimelyRate | 0.9135 | 0.9684 | 0.0549 | 5.491 | p = 1 | Meaningful |
| 10017 | Default | LossRate | 0.0865 | 0.0316 | -0.0549 | -5.491 | p = 1 | Meaningful |
| 10017 | Default | AvgDelay | 0.0357 | 0.0232 | -0.0125 | -35.011 | p = 1 | Meaningful |
| 10017 | Default | AvgTxCost | 2.1268 | 2.3874 | 0.2606 | 12.252 | p = 1 | SeeDelta |
| 10017 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | ForestGeometry | TimelyRate | 0.5158 | 0.5524 | 0.0366 | 3.661 | p = 1 | Meaningful |
| 10017 | ForestGeometry | LossRate | 0.4842 | 0.4476 | -0.0366 | -3.661 | p = 1 | Meaningful |
| 10017 | ForestGeometry | AvgDelay | 0.1293 | 0.1223 | -0.0069 | -5.372 | p = 1 | Meaningful |
| 10017 | ForestGeometry | AvgTxCost | 2.2281 | 3.9197 | 1.6916 | 75.920 | p = 1 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | 0.0278 | 0.0278 | 0.0000 | 0.000 | p = 1 | Below1pp |

## PosDeg_Emerg Mean Summary

| Scene | Config | Method | Timely | Loss | Avg Delay | Avg Tx Cost | Emergency Timely |
|---|---|---|---:|---:|---:|---:|---:|
| 10014 | Default | Link-delay-aware | 0.9909 | 0.0091 | 0.0120 | 2.0300 | 1.0000 |
| 10014 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0121 | 3.2000 | 1.0000 |
| 10014 | Default | Risk-constrained | 1.0000 | 0.0000 | 0.0121 | 3.0827 | 1.0000 |
| 10014 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0144 | 2.9855 | 1.0000 |
| 10014 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0144 | 2.9855 | 1.0000 |
| 10014 | ForestGeometry | Link-delay-aware | 0.8364 | 0.1636 | 0.0128 | 2.1455 | 0.0000 |
| 10014 | ForestGeometry | Confidence-heuristic | 0.8364 | 0.1636 | 0.0129 | 3.7528 | 0.0000 |
| 10014 | ForestGeometry | Risk-constrained | 0.8364 | 0.1636 | 0.0129 | 3.5326 | 0.0000 |
| 10014 | ForestGeometry | Confidence-lyapunov | 0.8364 | 0.1636 | 0.0143 | 3.1250 | 0.0000 |
| 10014 | ForestGeometry | Constrained Oracle | 0.8364 | 0.1636 | 0.0144 | 3.5174 | 0.0000 |
| 10006 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.5500 | 1.0000 |
| 10006 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 2.6918 | 1.0000 |
| 10006 | Default | Risk-constrained | 1.0000 | 0.0000 | 0.0120 | 2.7627 | 1.0000 |
| 10006 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0120 | 2.5500 | 1.0000 |
| 10006 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0120 | 2.5500 | 1.0000 |
| 10006 | ForestGeometry | Link-delay-aware | 0.8909 | 0.1000 | 0.0127 | 2.6155 | 0.8909 |
| 10006 | ForestGeometry | Confidence-heuristic | 0.9000 | 0.0909 | 0.0134 | 3.0453 | 0.9000 |
| 10006 | ForestGeometry | Risk-constrained | 0.9000 | 0.1000 | 0.0125 | 2.9097 | 0.9000 |
| 10006 | ForestGeometry | Confidence-lyapunov | 0.9000 | 0.1000 | 0.0125 | 2.8107 | 0.9000 |
| 10006 | ForestGeometry | Constrained Oracle | 0.9000 | 0.1000 | 0.0125 | 2.8107 | 0.9000 |
| 10011 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.0000 | NaN |
| 10011 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 3.0800 | NaN |
| 10011 | Default | Risk-constrained | 1.0000 | 0.0000 | 0.0120 | 2.9882 | NaN |
| 10011 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0143 | 2.9427 | NaN |
| 10011 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0143 | 2.9427 | NaN |
| 10011 | ForestGeometry | Link-delay-aware | 0.7818 | 0.2182 | 0.0185 | 2.0000 | NaN |
| 10011 | ForestGeometry | Confidence-heuristic | 0.9818 | 0.0182 | 0.0219 | 3.7055 | NaN |
| 10011 | ForestGeometry | Risk-constrained | 0.9909 | 0.0091 | 0.0211 | 3.8991 | NaN |
| 10011 | ForestGeometry | Confidence-lyapunov | 0.8545 | 0.1455 | 0.0196 | 3.0445 | NaN |
| 10011 | ForestGeometry | Constrained Oracle | 0.9909 | 0.0091 | 0.0212 | 3.7736 | NaN |
| 10019 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.5500 | 1.0000 |
| 10019 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 3.0082 | 1.0000 |
| 10019 | Default | Risk-constrained | 1.0000 | 0.0000 | 0.0120 | 2.9045 | 1.0000 |
| 10019 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0120 | 2.6155 | 1.0000 |
| 10019 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0120 | 2.6155 | 1.0000 |
| 10019 | ForestGeometry | Link-delay-aware | 0.5545 | 0.2545 | 0.0520 | 3.8283 | 0.5545 |
| 10019 | ForestGeometry | Confidence-heuristic | 0.5818 | 0.2000 | 0.0534 | 4.1545 | 0.5818 |
| 10019 | ForestGeometry | Risk-constrained | 0.5818 | 0.2091 | 0.0537 | 4.0860 | 0.5818 |
| 10019 | ForestGeometry | Confidence-lyapunov | 0.5818 | 0.2364 | 0.0517 | 3.8435 | 0.5818 |
| 10019 | ForestGeometry | Constrained Oracle | 0.5909 | 0.1636 | 0.0554 | 4.2415 | 0.5909 |
| 10017 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.0000 | NaN |
| 10017 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 3.0809 | NaN |
| 10017 | Default | Risk-constrained | 1.0000 | 0.0000 | 0.0120 | 2.9818 | NaN |
| 10017 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0144 | 2.9345 | NaN |
| 10017 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0144 | 2.9345 | NaN |
| 10017 | ForestGeometry | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.0000 | NaN |
| 10017 | ForestGeometry | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 3.0845 | NaN |
| 10017 | ForestGeometry | Risk-constrained | 1.0000 | 0.0000 | 0.0120 | 2.9818 | NaN |
| 10017 | ForestGeometry | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0132 | 2.9109 | NaN |
| 10017 | ForestGeometry | Constrained Oracle | 1.0000 | 0.0000 | 0.0132 | 2.9109 | NaN |

## Interpretation Rules

- `CandidateMainMethod`: Risk-constrained is no worse in timely delivery and does not harm emergency delivery.
- `ComparableTheoryVariant`: Risk-constrained stays within 0.5 pp of heuristic and has acceptable emergency behavior.
- `NeedsTuning`: Risk-constrained has theoretical value but loses enough timely/emergency performance that weights need calibration.
- `NotCompetitive`: Risk-constrained should stay as a baseline rather than a main method candidate.
