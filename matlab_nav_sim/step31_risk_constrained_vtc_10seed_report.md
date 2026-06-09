# Step 31 Risk-Constrained VTC Validation Report

This side-copy experiment validates a risk-constrained Lagrangian scheduler on the same VTC scene matrix used by Step17/Step30. It does not modify the main confidence-driven heuristic scheduler.

## Method Framing

The scheduler maximizes value-weighted timely delivery and penalizes communication cost plus soft violations of timely, reliability, deadline, and protection constraints. This makes the decision rule closer to a constrained optimization formulation than the legacy heuristic scorer.

## Overall Mean Summary

| Scene | Config | Method | Timely | Loss | Avg Delay | Avg Tx Cost | Emergency Timely |
|---|---|---|---:|---:|---:|---:|---:|
| 10014 | Default | Link-delay-aware | 0.9687 | 0.0313 | 0.0242 | 1.6295 | 1.0000 |
| 10014 | Default | Confidence-heuristic | 0.9707 | 0.0293 | 0.0239 | 1.8555 | 1.0000 |
| 10014 | Default | Risk-constrained | 0.9923 | 0.0077 | 0.0153 | 1.9082 | 1.0000 |
| 10014 | Default | Confidence-lyapunov | 0.9707 | 0.0293 | 0.0244 | 1.8197 | 1.0000 |
| 10014 | Default | Constrained Oracle | 0.9930 | 0.0070 | 0.0157 | 1.8903 | 1.0000 |
| 10014 | ForestGeometry | Link-delay-aware | 0.7391 | 0.2609 | 0.1055 | 1.6983 | 0.0167 |
| 10014 | ForestGeometry | Confidence-heuristic | 0.7704 | 0.2295 | 0.0936 | 2.1720 | 0.0167 |
| 10014 | ForestGeometry | Risk-constrained | 0.7977 | 0.2023 | 0.0814 | 2.6536 | 0.0167 |
| 10014 | ForestGeometry | Confidence-lyapunov | 0.7438 | 0.2561 | 0.1043 | 1.8836 | 0.0167 |
| 10014 | ForestGeometry | Constrained Oracle | 0.8008 | 0.1990 | 0.0815 | 2.6106 | 0.0167 |
| 10006 | Default | Link-delay-aware | 0.9456 | 0.0544 | 0.0337 | 2.1468 | 0.9974 |
| 10006 | Default | Confidence-heuristic | 0.9809 | 0.0191 | 0.0225 | 2.4729 | 0.9997 |
| 10006 | Default | Risk-constrained | 0.9859 | 0.0141 | 0.0190 | 2.3159 | 0.9974 |
| 10006 | Default | Confidence-lyapunov | 0.9458 | 0.0542 | 0.0337 | 2.1613 | 0.9974 |
| 10006 | Default | Constrained Oracle | 0.9884 | 0.0116 | 0.0191 | 2.3265 | 0.9974 |
| 10006 | ForestGeometry | Link-delay-aware | 0.6905 | 0.3083 | 0.0927 | 2.2646 | 0.8016 |
| 10006 | ForestGeometry | Confidence-heuristic | 0.7068 | 0.2912 | 0.0894 | 2.6869 | 0.8026 |
| 10006 | ForestGeometry | Risk-constrained | 0.7171 | 0.2825 | 0.0855 | 2.9423 | 0.8020 |
| 10006 | ForestGeometry | Confidence-lyapunov | 0.6937 | 0.3058 | 0.0918 | 2.2695 | 0.8020 |
| 10006 | ForestGeometry | Constrained Oracle | 0.7158 | 0.2837 | 0.0862 | 2.8527 | 0.8020 |
| 10011 | Default | Link-delay-aware | 0.9972 | 0.0028 | 0.0127 | 1.7188 | 1.0000 |
| 10011 | Default | Confidence-heuristic | 0.9972 | 0.0028 | 0.0127 | 1.9424 | 1.0000 |
| 10011 | Default | Risk-constrained | 0.9972 | 0.0028 | 0.0127 | 1.9083 | 1.0000 |
| 10011 | Default | Confidence-lyapunov | 0.9972 | 0.0028 | 0.0131 | 1.9007 | 1.0000 |
| 10011 | Default | Constrained Oracle | 0.9972 | 0.0028 | 0.0131 | 1.9007 | 1.0000 |
| 10011 | ForestGeometry | Link-delay-aware | 0.5905 | 0.4042 | 0.1557 | 2.7289 | 0.2950 |
| 10011 | ForestGeometry | Confidence-heuristic | 0.6794 | 0.3170 | 0.1378 | 3.3981 | 0.2750 |
| 10011 | ForestGeometry | Risk-constrained | 0.7248 | 0.2700 | 0.1219 | 4.0459 | 0.2950 |
| 10011 | ForestGeometry | Confidence-lyapunov | 0.6027 | 0.3952 | 0.1542 | 2.6355 | 0.2450 |
| 10011 | ForestGeometry | Constrained Oracle | 0.7017 | 0.2899 | 0.1326 | 4.0091 | 0.2900 |
| 10019 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0121 | 2.4997 | 1.0000 |
| 10019 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0121 | 2.9842 | 1.0000 |
| 10019 | Default | Risk-constrained | 1.0000 | 0.0000 | 0.0121 | 2.5830 | 1.0000 |
| 10019 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0121 | 2.5051 | 1.0000 |
| 10019 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0121 | 2.5051 | 1.0000 |
| 10019 | ForestGeometry | Link-delay-aware | 0.6631 | 0.2784 | 0.0397 | 2.9584 | 0.6291 |
| 10019 | ForestGeometry | Confidence-heuristic | 0.6647 | 0.2694 | 0.0399 | 3.3328 | 0.6310 |
| 10019 | ForestGeometry | Risk-constrained | 0.6624 | 0.2740 | 0.0399 | 2.9200 | 0.6284 |
| 10019 | ForestGeometry | Confidence-lyapunov | 0.6591 | 0.2872 | 0.0397 | 2.8543 | 0.6247 |
| 10019 | ForestGeometry | Constrained Oracle | 0.6626 | 0.2617 | 0.0402 | 3.0112 | 0.6286 |
| 10017 | Default | Link-delay-aware | 0.9045 | 0.0955 | 0.0394 | 1.9231 | 0.9917 |
| 10017 | Default | Confidence-heuristic | 0.9514 | 0.0486 | 0.0282 | 2.3593 | 1.0000 |
| 10017 | Default | Risk-constrained | 0.9674 | 0.0326 | 0.0230 | 2.3705 | 0.9917 |
| 10017 | Default | Confidence-lyapunov | 0.9045 | 0.0955 | 0.0399 | 2.1085 | 0.9917 |
| 10017 | Default | Constrained Oracle | 0.9774 | 0.0226 | 0.0213 | 2.4349 | 0.9917 |
| 10017 | ForestGeometry | Link-delay-aware | 0.5213 | 0.4779 | 0.1279 | 2.1792 | 0.0139 |
| 10017 | ForestGeometry | Confidence-heuristic | 0.5243 | 0.4749 | 0.1275 | 2.6696 | 0.0139 |
| 10017 | ForestGeometry | Risk-constrained | 0.5408 | 0.4589 | 0.1240 | 3.8878 | 0.0111 |
| 10017 | ForestGeometry | Confidence-lyapunov | 0.5183 | 0.4814 | 0.1286 | 2.2079 | 0.0111 |
| 10017 | ForestGeometry | Constrained Oracle | 0.5396 | 0.4601 | 0.1250 | 3.7618 | 0.0111 |

## Decision Table: Risk-Constrained vs Heuristic

| Scene | Config | Timely Gap (pp) | Emergency Gap (pp) | Cost Delta (%) | Delay Delta (%) | Decision |
|---|---|---:|---:|---:|---:|---|
| 10014 | Default | 2.163 | 0.000 | 2.84 | -35.85 | CandidateMainMethod |
| 10014 | ForestGeometry | 2.729 | 0.000 | 22.17 | -12.98 | CandidateMainMethod |
| 10006 | Default | 0.499 | -0.230 | -6.35 | -15.69 | CandidateMainMethod |
| 10006 | ForestGeometry | 1.032 | -0.066 | 9.51 | -4.33 | CandidateMainMethod |
| 10011 | Default | 0.000 | 0.000 | -1.76 | 0.00 | CandidateMainMethod |
| 10011 | ForestGeometry | 4.542 | 2.000 | 19.06 | -11.49 | CandidateMainMethod |
| 10019 | Default | 0.000 | 0.000 | -13.44 | 0.00 | CandidateMainMethod |
| 10019 | ForestGeometry | -0.233 | -0.256 | -12.39 | 0.18 | ComparableTheoryVariant |
| 10017 | Default | 1.597 | -0.833 | 0.48 | -18.42 | NeedsTuning |
| 10017 | ForestGeometry | 1.647 | -0.278 | 45.63 | -2.73 | CandidateMainMethod |

## Heuristic vs Risk-Constrained: Overall Significance

| Scene | Config | Metric | Heuristic Mean | Risk Mean | Delta Mean | Delta % | Holm(all) | Practical |
|---|---|---|---:|---:|---:|---:|---|---|
| 10014 | Default | TimelyRate | 0.9707 | 0.9923 | 0.0216 | 2.163 | p < 1e-15 | Meaningful |
| 10014 | Default | LossRate | 0.0293 | 0.0077 | -0.0216 | -2.163 | p < 1e-15 | Meaningful |
| 10014 | Default | AvgDelay | 0.0239 | 0.0153 | -0.0086 | -35.849 | p < 1e-15 | Meaningful |
| 10014 | Default | AvgTxCost | 1.8555 | 1.9082 | 0.0527 | 2.842 | p < 1e-15 | SeeDelta |
| 10014 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.7704 | 0.7977 | 0.0273 | 2.729 | p < 1e-15 | Meaningful |
| 10014 | ForestGeometry | LossRate | 0.2295 | 0.2023 | -0.0271 | -2.712 | p < 1e-15 | Meaningful |
| 10014 | ForestGeometry | AvgDelay | 0.0936 | 0.0814 | -0.0121 | -12.978 | p < 1e-15 | Meaningful |
| 10014 | ForestGeometry | AvgTxCost | 2.1720 | 2.6536 | 0.4816 | 22.174 | p < 1e-15 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | 0.0167 | 0.0167 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | Default | TimelyRate | 0.9809 | 0.9859 | 0.0050 | 0.499 | p = 0.0507 | Below1pp |
| 10006 | Default | LossRate | 0.0191 | 0.0141 | -0.0050 | -0.499 | p = 0.0507 | Below1pp |
| 10006 | Default | AvgDelay | 0.0225 | 0.0190 | -0.0035 | -15.694 | p = 5.712e-06 | Meaningful |
| 10006 | Default | AvgTxCost | 2.4729 | 2.3159 | -0.1569 | -6.346 | p < 1e-15 | SeeDelta |
| 10006 | Default | EmgTimely | 0.9997 | 0.9974 | -0.0023 | -0.230 | p = 0.02287 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.7068 | 0.7171 | 0.0103 | 1.032 | p = 2.022e-09 | Meaningful |
| 10006 | ForestGeometry | LossRate | 0.2912 | 0.2825 | -0.0087 | -0.865 | p = 1.077e-09 | Below1pp |
| 10006 | ForestGeometry | AvgDelay | 0.0894 | 0.0855 | -0.0039 | -4.333 | p = 2.118e-09 | Meaningful |
| 10006 | ForestGeometry | AvgTxCost | 2.6869 | 2.9423 | 0.2554 | 9.506 | p < 1e-15 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.8026 | 0.8020 | -0.0007 | -0.066 | p = 1 | Below1pp |
| 10011 | Default | TimelyRate | 0.9972 | 0.9972 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | LossRate | 0.0028 | 0.0028 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | AvgDelay | 0.0127 | 0.0127 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10011 | Default | AvgTxCost | 1.9424 | 1.9083 | -0.0341 | -1.757 | p = 8.793e-14 | SeeDelta |
| 10011 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | ForestGeometry | TimelyRate | 0.6794 | 0.7248 | 0.0454 | 4.542 | p < 1e-15 | Meaningful |
| 10011 | ForestGeometry | LossRate | 0.3170 | 0.2700 | -0.0469 | -4.692 | p < 1e-15 | Meaningful |
| 10011 | ForestGeometry | AvgDelay | 0.1378 | 0.1219 | -0.0158 | -11.492 | p < 1e-15 | Meaningful |
| 10011 | ForestGeometry | AvgTxCost | 3.3981 | 4.0459 | 0.6477 | 19.062 | p < 1e-15 | SeeDelta |
| 10011 | ForestGeometry | EmgTimely | 0.2750 | 0.2950 | 0.0200 | 2.000 | p = 1 | Meaningful |
| 10019 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | AvgDelay | 0.0121 | 0.0121 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10019 | Default | AvgTxCost | 2.9842 | 2.5830 | -0.4011 | -13.442 | p < 1e-15 | SeeDelta |
| 10019 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | ForestGeometry | TimelyRate | 0.6647 | 0.6624 | -0.0023 | -0.233 | p = 1 | Below1pp |
| 10019 | ForestGeometry | LossRate | 0.2694 | 0.2740 | 0.0047 | 0.466 | p = 1 | Below1pp |
| 10019 | ForestGeometry | AvgDelay | 0.0399 | 0.0399 | 0.0001 | 0.181 | p = 1 | Sub-ms |
| 10019 | ForestGeometry | AvgTxCost | 3.3328 | 2.9200 | -0.4128 | -12.386 | p < 1e-15 | SeeDelta |
| 10019 | ForestGeometry | EmgTimely | 0.6310 | 0.6284 | -0.0026 | -0.256 | p = 1 | Below1pp |
| 10017 | Default | TimelyRate | 0.9514 | 0.9674 | 0.0160 | 1.597 | p = 2.959e-10 | Meaningful |
| 10017 | Default | LossRate | 0.0486 | 0.0326 | -0.0160 | -1.597 | p = 2.959e-10 | Meaningful |
| 10017 | Default | AvgDelay | 0.0282 | 0.0230 | -0.0052 | -18.424 | p = 4.982e-08 | Meaningful |
| 10017 | Default | AvgTxCost | 2.3593 | 2.3705 | 0.0112 | 0.476 | p = 0.4631 | SeeDelta |
| 10017 | Default | EmgTimely | 1.0000 | 0.9917 | -0.0083 | -0.833 | p = 0.8916 | Below1pp |
| 10017 | ForestGeometry | TimelyRate | 0.5243 | 0.5408 | 0.0165 | 1.647 | p = 1.039e-09 | Meaningful |
| 10017 | ForestGeometry | LossRate | 0.4749 | 0.4589 | -0.0160 | -1.597 | p = 2.118e-09 | Meaningful |
| 10017 | ForestGeometry | AvgDelay | 0.1275 | 0.1240 | -0.0035 | -2.727 | p = 1.867e-09 | Meaningful |
| 10017 | ForestGeometry | AvgTxCost | 2.6696 | 3.8878 | 1.2182 | 45.631 | p < 1e-15 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | 0.0139 | 0.0111 | -0.0028 | -0.278 | p = 1 | Below1pp |

## Link-delay-aware vs Risk-Constrained: Overall Significance

| Scene | Config | Metric | Link-delay-aware Mean | Risk Mean | Delta Mean | Delta % | Holm(all) | Practical |
|---|---|---|---:|---:|---:|---:|---|---|
| 10014 | Default | TimelyRate | 0.9687 | 0.9923 | 0.0236 | 2.363 | p < 1e-15 | Meaningful |
| 10014 | Default | LossRate | 0.0313 | 0.0077 | -0.0236 | -2.363 | p < 1e-15 | Meaningful |
| 10014 | Default | AvgDelay | 0.0242 | 0.0153 | -0.0089 | -36.670 | p < 1e-15 | Meaningful |
| 10014 | Default | AvgTxCost | 1.6295 | 1.9082 | 0.2788 | 17.108 | p < 1e-15 | SeeDelta |
| 10014 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.7391 | 0.7977 | 0.0586 | 5.857 | p < 1e-15 | Meaningful |
| 10014 | ForestGeometry | LossRate | 0.2609 | 0.2023 | -0.0586 | -5.857 | p < 1e-15 | Meaningful |
| 10014 | ForestGeometry | AvgDelay | 0.1055 | 0.0814 | -0.0241 | -22.815 | p < 1e-15 | Meaningful |
| 10014 | ForestGeometry | AvgTxCost | 1.6983 | 2.6536 | 0.9553 | 56.249 | p < 1e-15 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | 0.0167 | 0.0167 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | Default | TimelyRate | 0.9456 | 0.9859 | 0.0403 | 4.027 | p < 1e-15 | Meaningful |
| 10006 | Default | LossRate | 0.0544 | 0.0141 | -0.0403 | -4.027 | p < 1e-15 | Meaningful |
| 10006 | Default | AvgDelay | 0.0337 | 0.0190 | -0.0148 | -43.764 | p < 1e-15 | Meaningful |
| 10006 | Default | AvgTxCost | 2.1468 | 2.3159 | 0.1692 | 7.880 | p < 1e-15 | SeeDelta |
| 10006 | Default | EmgTimely | 0.9974 | 0.9974 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.6905 | 0.7171 | 0.0266 | 2.662 | p < 1e-15 | Meaningful |
| 10006 | ForestGeometry | LossRate | 0.3083 | 0.2825 | -0.0258 | -2.579 | p < 1e-15 | Meaningful |
| 10006 | ForestGeometry | AvgDelay | 0.0927 | 0.0855 | -0.0072 | -7.789 | p < 1e-15 | Meaningful |
| 10006 | ForestGeometry | AvgTxCost | 2.2646 | 2.9423 | 0.6778 | 29.929 | p < 1e-15 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.8016 | 0.8020 | 0.0003 | 0.033 | p = 1 | Below1pp |
| 10011 | Default | TimelyRate | 0.9972 | 0.9972 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | LossRate | 0.0028 | 0.0028 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | AvgDelay | 0.0127 | 0.0127 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10011 | Default | AvgTxCost | 1.7188 | 1.9083 | 0.1895 | 11.025 | p < 1e-15 | SeeDelta |
| 10011 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | ForestGeometry | TimelyRate | 0.5905 | 0.7248 | 0.1343 | 13.428 | p < 1e-15 | Meaningful |
| 10011 | ForestGeometry | LossRate | 0.4042 | 0.2700 | -0.1341 | -13.411 | p < 1e-15 | Meaningful |
| 10011 | ForestGeometry | AvgDelay | 0.1557 | 0.1219 | -0.0338 | -21.679 | p < 1e-15 | Meaningful |
| 10011 | ForestGeometry | AvgTxCost | 2.7289 | 4.0459 | 1.3170 | 48.261 | p < 1e-15 | SeeDelta |
| 10011 | ForestGeometry | EmgTimely | 0.2950 | 0.2950 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | AvgDelay | 0.0121 | 0.0121 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10019 | Default | AvgTxCost | 2.4997 | 2.5830 | 0.0834 | 3.335 | p < 1e-15 | SeeDelta |
| 10019 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | ForestGeometry | TimelyRate | 0.6631 | 0.6624 | -0.0007 | -0.067 | p = 1 | Below1pp |
| 10019 | ForestGeometry | LossRate | 0.2784 | 0.2740 | -0.0043 | -0.433 | p = 0.1306 | Below1pp |
| 10019 | ForestGeometry | AvgDelay | 0.0397 | 0.0399 | 0.0002 | 0.581 | p = 1.359e-06 | Sub-ms |
| 10019 | ForestGeometry | AvgTxCost | 2.9584 | 2.9200 | -0.0383 | -1.295 | p = 4.135e-11 | SeeDelta |
| 10019 | ForestGeometry | EmgTimely | 0.6291 | 0.6284 | -0.0007 | -0.073 | p = 1 | Below1pp |
| 10017 | Default | TimelyRate | 0.9045 | 0.9674 | 0.0629 | 6.290 | p < 1e-15 | Meaningful |
| 10017 | Default | LossRate | 0.0955 | 0.0326 | -0.0629 | -6.290 | p < 1e-15 | Meaningful |
| 10017 | Default | AvgDelay | 0.0394 | 0.0230 | -0.0164 | -41.529 | p < 1e-15 | Meaningful |
| 10017 | Default | AvgTxCost | 1.9231 | 2.3705 | 0.4474 | 23.263 | p < 1e-15 | SeeDelta |
| 10017 | Default | EmgTimely | 0.9917 | 0.9917 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | ForestGeometry | TimelyRate | 0.5213 | 0.5408 | 0.0195 | 1.947 | p < 1e-15 | Meaningful |
| 10017 | ForestGeometry | LossRate | 0.4779 | 0.4589 | -0.0190 | -1.897 | p < 1e-15 | Meaningful |
| 10017 | ForestGeometry | AvgDelay | 0.1279 | 0.1240 | -0.0038 | -2.983 | p = 3.870e-13 | Meaningful |
| 10017 | ForestGeometry | AvgTxCost | 2.1792 | 3.8878 | 1.7086 | 78.403 | p < 1e-15 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | 0.0139 | 0.0111 | -0.0028 | -0.278 | p = 1 | Below1pp |

## Lyapunov vs Risk-Constrained: Overall Significance

| Scene | Config | Metric | Lyapunov Mean | Risk Mean | Delta Mean | Delta % | Holm(all) | Practical |
|---|---|---|---:|---:|---:|---:|---|---|
| 10014 | Default | TimelyRate | 0.9707 | 0.9923 | 0.0216 | 2.163 | p < 1e-15 | Meaningful |
| 10014 | Default | LossRate | 0.0293 | 0.0077 | -0.0216 | -2.163 | p < 1e-15 | Meaningful |
| 10014 | Default | AvgDelay | 0.0244 | 0.0153 | -0.0090 | -37.084 | p < 1e-15 | Meaningful |
| 10014 | Default | AvgTxCost | 1.8197 | 1.9082 | 0.0885 | 4.865 | p < 1e-15 | SeeDelta |
| 10014 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.7438 | 0.7977 | 0.0539 | 5.391 | p < 1e-15 | Meaningful |
| 10014 | ForestGeometry | LossRate | 0.2561 | 0.2023 | -0.0537 | -5.374 | p < 1e-15 | Meaningful |
| 10014 | ForestGeometry | AvgDelay | 0.1043 | 0.0814 | -0.0229 | -21.962 | p < 1e-15 | Meaningful |
| 10014 | ForestGeometry | AvgTxCost | 1.8836 | 2.6536 | 0.7701 | 40.884 | p < 1e-15 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | 0.0167 | 0.0167 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | Default | TimelyRate | 0.9458 | 0.9859 | 0.0401 | 4.010 | p < 1e-15 | Meaningful |
| 10006 | Default | LossRate | 0.0542 | 0.0141 | -0.0401 | -4.010 | p < 1e-15 | Meaningful |
| 10006 | Default | AvgDelay | 0.0337 | 0.0190 | -0.0147 | -43.742 | p < 1e-15 | Meaningful |
| 10006 | Default | AvgTxCost | 2.1613 | 2.3159 | 0.1546 | 7.153 | p < 1e-15 | SeeDelta |
| 10006 | Default | EmgTimely | 0.9974 | 0.9974 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.6937 | 0.7171 | 0.0235 | 2.346 | p < 1e-15 | Meaningful |
| 10006 | ForestGeometry | LossRate | 0.3058 | 0.2825 | -0.0233 | -2.329 | p < 1e-15 | Meaningful |
| 10006 | ForestGeometry | AvgDelay | 0.0918 | 0.0855 | -0.0063 | -6.834 | p < 1e-15 | Meaningful |
| 10006 | ForestGeometry | AvgTxCost | 2.2695 | 2.9423 | 0.6728 | 29.647 | p < 1e-15 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.8020 | 0.8020 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | TimelyRate | 0.9972 | 0.9972 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | LossRate | 0.0028 | 0.0028 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | Default | AvgDelay | 0.0131 | 0.0127 | -0.0004 | -3.355 | p = 3.111e-06 | Sub-ms |
| 10011 | Default | AvgTxCost | 1.9007 | 1.9083 | 0.0076 | 0.399 | p = 1.457e-05 | SeeDelta |
| 10011 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10011 | ForestGeometry | TimelyRate | 0.6027 | 0.7248 | 0.1221 | 12.213 | p < 1e-15 | Meaningful |
| 10011 | ForestGeometry | LossRate | 0.3952 | 0.2700 | -0.1251 | -12.512 | p < 1e-15 | Meaningful |
| 10011 | ForestGeometry | AvgDelay | 0.1542 | 0.1219 | -0.0323 | -20.931 | p < 1e-15 | Meaningful |
| 10011 | ForestGeometry | AvgTxCost | 2.6355 | 4.0459 | 1.4103 | 53.512 | p < 1e-15 | SeeDelta |
| 10011 | ForestGeometry | EmgTimely | 0.2450 | 0.2950 | 0.0500 | 5.000 | p = 0.0432 | Meaningful |
| 10019 | Default | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | Default | AvgDelay | 0.0121 | 0.0121 | 0.0000 | 0.000 | p = 1 | Sub-ms |
| 10019 | Default | AvgTxCost | 2.5051 | 2.5830 | 0.0780 | 3.113 | p < 1e-15 | SeeDelta |
| 10019 | Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10019 | ForestGeometry | TimelyRate | 0.6591 | 0.6624 | 0.0033 | 0.333 | p = 1 | Below1pp |
| 10019 | ForestGeometry | LossRate | 0.2872 | 0.2740 | -0.0131 | -1.314 | p = 0.001031 | Meaningful |
| 10019 | ForestGeometry | AvgDelay | 0.0397 | 0.0399 | 0.0003 | 0.648 | p = 1.140e-06 | Sub-ms |
| 10019 | ForestGeometry | AvgTxCost | 2.8543 | 2.9200 | 0.0657 | 2.302 | p = 0.004853 | SeeDelta |
| 10019 | ForestGeometry | EmgTimely | 0.6247 | 0.6284 | 0.0037 | 0.366 | p = 1 | Below1pp |
| 10017 | Default | TimelyRate | 0.9045 | 0.9674 | 0.0629 | 6.290 | p < 1e-15 | Meaningful |
| 10017 | Default | LossRate | 0.0955 | 0.0326 | -0.0629 | -6.290 | p < 1e-15 | Meaningful |
| 10017 | Default | AvgDelay | 0.0399 | 0.0230 | -0.0168 | -42.187 | p < 1e-15 | Meaningful |
| 10017 | Default | AvgTxCost | 2.1085 | 2.3705 | 0.2620 | 12.428 | p < 1e-15 | SeeDelta |
| 10017 | Default | EmgTimely | 0.9917 | 0.9917 | 0.0000 | 0.000 | p = 1 | Below1pp |
| 10017 | ForestGeometry | TimelyRate | 0.5183 | 0.5408 | 0.0225 | 2.246 | p < 1e-15 | Meaningful |
| 10017 | ForestGeometry | LossRate | 0.4814 | 0.4589 | -0.0225 | -2.246 | p < 1e-15 | Meaningful |
| 10017 | ForestGeometry | AvgDelay | 0.1286 | 0.1240 | -0.0045 | -3.535 | p < 1e-15 | Meaningful |
| 10017 | ForestGeometry | AvgTxCost | 2.2079 | 3.8878 | 1.6798 | 76.083 | p < 1e-15 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | 0.0111 | 0.0111 | 0.0000 | 0.000 | p = 1 | Below1pp |

## PosDeg_Emerg Mean Summary

| Scene | Config | Method | Timely | Loss | Avg Delay | Avg Tx Cost | Emergency Timely |
|---|---|---|---:|---:|---:|---:|---:|
| 10014 | Default | Link-delay-aware | 0.9909 | 0.0091 | 0.0121 | 2.0300 | 1.0000 |
| 10014 | Default | Confidence-heuristic | 0.9991 | 0.0009 | 0.0122 | 3.0877 | 1.0000 |
| 10014 | Default | Risk-constrained | 0.9991 | 0.0009 | 0.0122 | 3.0111 | 1.0000 |
| 10014 | Default | Confidence-lyapunov | 0.9991 | 0.0009 | 0.0147 | 2.9005 | 1.0000 |
| 10014 | Default | Constrained Oracle | 0.9991 | 0.0009 | 0.0147 | 2.9018 | 1.0000 |
| 10014 | ForestGeometry | Link-delay-aware | 0.8100 | 0.1900 | 0.0124 | 2.1455 | 0.0167 |
| 10014 | ForestGeometry | Confidence-heuristic | 0.8282 | 0.1709 | 0.0130 | 3.5825 | 0.0167 |
| 10014 | ForestGeometry | Risk-constrained | 0.8291 | 0.1709 | 0.0129 | 3.4419 | 0.0167 |
| 10014 | ForestGeometry | Confidence-lyapunov | 0.8255 | 0.1736 | 0.0144 | 3.0545 | 0.0167 |
| 10014 | ForestGeometry | Constrained Oracle | 0.8291 | 0.1700 | 0.0146 | 3.4463 | 0.0167 |
| 10006 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.5500 | 1.0000 |
| 10006 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 2.6629 | 1.0000 |
| 10006 | Default | Risk-constrained | 1.0000 | 0.0000 | 0.0120 | 2.6940 | 1.0000 |
| 10006 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0120 | 2.5544 | 1.0000 |
| 10006 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0120 | 2.5544 | 1.0000 |
| 10006 | ForestGeometry | Link-delay-aware | 0.8936 | 0.1045 | 0.0123 | 2.6155 | 0.8936 |
| 10006 | ForestGeometry | Confidence-heuristic | 0.8955 | 0.1018 | 0.0126 | 2.9296 | 0.8955 |
| 10006 | ForestGeometry | Risk-constrained | 0.8955 | 0.1036 | 0.0124 | 2.7867 | 0.8955 |
| 10006 | ForestGeometry | Confidence-lyapunov | 0.8955 | 0.1027 | 0.0125 | 2.7361 | 0.8955 |
| 10006 | ForestGeometry | Constrained Oracle | 0.8955 | 0.1027 | 0.0125 | 2.7361 | 0.8955 |
| 10011 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.0000 | NaN |
| 10011 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 2.9753 | NaN |
| 10011 | Default | Risk-constrained | 1.0000 | 0.0000 | 0.0120 | 2.8855 | NaN |
| 10011 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0144 | 2.8451 | NaN |
| 10011 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0144 | 2.8451 | NaN |
| 10011 | ForestGeometry | Link-delay-aware | 0.7527 | 0.2473 | 0.0183 | 2.0000 | NaN |
| 10011 | ForestGeometry | Confidence-heuristic | 0.9800 | 0.0200 | 0.0221 | 3.5640 | NaN |
| 10011 | ForestGeometry | Risk-constrained | 0.9891 | 0.0109 | 0.0215 | 3.8114 | NaN |
| 10011 | ForestGeometry | Confidence-lyapunov | 0.8964 | 0.1036 | 0.0209 | 3.0296 | NaN |
| 10011 | ForestGeometry | Constrained Oracle | 0.9864 | 0.0136 | 0.0218 | 3.6587 | NaN |
| 10019 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.5500 | 1.0000 |
| 10019 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 3.0027 | 1.0000 |
| 10019 | Default | Risk-constrained | 1.0000 | 0.0000 | 0.0120 | 2.9482 | 1.0000 |
| 10019 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0120 | 2.5795 | 1.0000 |
| 10019 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0120 | 2.5795 | 1.0000 |
| 10019 | ForestGeometry | Link-delay-aware | 0.5955 | 0.2000 | 0.0530 | 3.8283 | 0.5955 |
| 10019 | ForestGeometry | Confidence-heuristic | 0.6082 | 0.1591 | 0.0546 | 4.1784 | 0.6082 |
| 10019 | ForestGeometry | Risk-constrained | 0.6064 | 0.1618 | 0.0549 | 4.1306 | 0.6064 |
| 10019 | ForestGeometry | Confidence-lyapunov | 0.5955 | 0.1982 | 0.0529 | 3.8803 | 0.5955 |
| 10019 | ForestGeometry | Constrained Oracle | 0.6064 | 0.1264 | 0.0565 | 4.3306 | 0.6064 |
| 10017 | Default | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.0000 | NaN |
| 10017 | Default | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 2.9747 | NaN |
| 10017 | Default | Risk-constrained | 1.0000 | 0.0000 | 0.0120 | 2.8835 | NaN |
| 10017 | Default | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0144 | 2.8436 | NaN |
| 10017 | Default | Constrained Oracle | 1.0000 | 0.0000 | 0.0144 | 2.8436 | NaN |
| 10017 | ForestGeometry | Link-delay-aware | 1.0000 | 0.0000 | 0.0120 | 2.0000 | NaN |
| 10017 | ForestGeometry | Confidence-heuristic | 1.0000 | 0.0000 | 0.0120 | 2.9942 | NaN |
| 10017 | ForestGeometry | Risk-constrained | 1.0000 | 0.0000 | 0.0120 | 2.9183 | NaN |
| 10017 | ForestGeometry | Confidence-lyapunov | 1.0000 | 0.0000 | 0.0136 | 2.8625 | NaN |
| 10017 | ForestGeometry | Constrained Oracle | 1.0000 | 0.0000 | 0.0136 | 2.8625 | NaN |

## Interpretation Rules

- `CandidateMainMethod`: Risk-constrained is no worse in timely delivery and does not harm emergency delivery.
- `ComparableTheoryVariant`: Risk-constrained stays within 0.5 pp of heuristic and has acceptable emergency behavior.
- `NeedsTuning`: Risk-constrained has theoretical value but loses enough timely/emergency performance that weights need calibration.
- `NotCompetitive`: Risk-constrained should stay as a baseline rather than a main method candidate.
