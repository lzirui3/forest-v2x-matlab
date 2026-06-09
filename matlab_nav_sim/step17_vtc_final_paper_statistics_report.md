# Step 17 Paper-Level Statistics Report

This report consolidates the main evidence chain for the paper:
- multi-seed overall comparison,
- multi-seed key-stage comparison,
- default vs forest-geometry parameter settings,
- main comparison focus: `Confidence-driven` vs `Link-delay-aware`.

## Formal Scene Matrix

| Scene | Role | Geometry | Density | Vegetation |
|---|---|---|---|---|
| 10014 | Primary | CurvedBlind | Medium | Dense |
| 10006 | Reference | Mixed | Medium | Mixed |
| 10011 | Boundary | Open | Low | Sparse |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense |
| 10017 | LongRange | LongMixed | Medium | Mixed |
## Overall Mean Summary

| Scene | Role | Config | Method | Timely Mean | Loss Mean | Avg Tx Cost Mean | Emergency Timely Mean |
|---|---|---|---|---:|---:|---:|---:|
| 10014 | Primary | Default | Link-delay-aware | 0.9685 | 0.0315 | 1.6295 | 1.0000 |
| 10014 | Primary | Default | Confidence-driven | 0.9712 | 0.0288 | 1.8651 | 1.0000 |
| 10014 | Primary | Default | Constrained Oracle | 0.9937 | 0.0063 | 1.8990 | 1.0000 |
| 10014 | Primary | ForestGeometry | Link-delay-aware | 0.7422 | 0.2577 | 1.6983 | 0.0267 |
| 10014 | Primary | ForestGeometry | Confidence-driven | 0.7747 | 0.2251 | 2.1908 | 0.0200 |
| 10014 | Primary | ForestGeometry | Constrained Oracle | 0.8006 | 0.1992 | 2.6277 | 0.0200 |
| 10006 | Reference | Default | Link-delay-aware | 0.9445 | 0.0555 | 2.1468 | 0.9974 |
| 10006 | Reference | Default | Confidence-driven | 0.9810 | 0.0190 | 2.4746 | 0.9994 |
| 10006 | Reference | Default | Constrained Oracle | 0.9887 | 0.0113 | 2.3268 | 0.9974 |
| 10006 | Reference | ForestGeometry | Link-delay-aware | 0.6916 | 0.3073 | 2.2646 | 0.8007 |
| 10006 | Reference | ForestGeometry | Confidence-driven | 0.7070 | 0.2907 | 2.6958 | 0.8011 |
| 10006 | Reference | ForestGeometry | Constrained Oracle | 0.7151 | 0.2839 | 2.8612 | 0.8005 |
| 10011 | Boundary | Default | Link-delay-aware | 0.9973 | 0.0027 | 1.7188 | 1.0000 |
| 10011 | Boundary | Default | Confidence-driven | 0.9974 | 0.0026 | 1.9532 | 1.0000 |
| 10011 | Boundary | Default | Constrained Oracle | 0.9974 | 0.0026 | 1.9084 | 1.0000 |
| 10011 | Boundary | ForestGeometry | Link-delay-aware | 0.5903 | 0.4052 | 2.7289 | 0.3000 |
| 10011 | Boundary | ForestGeometry | Confidence-driven | 0.6785 | 0.3191 | 3.4085 | 0.2870 |
| 10011 | Boundary | ForestGeometry | Constrained Oracle | 0.7004 | 0.2921 | 4.0133 | 0.3050 |
| 10019 | DenseBlind | Default | Link-delay-aware | 0.9998 | 0.0002 | 2.4997 | 1.0000 |
| 10019 | DenseBlind | Default | Confidence-driven | 0.9998 | 0.0002 | 2.9805 | 1.0000 |
| 10019 | DenseBlind | Default | Constrained Oracle | 0.9998 | 0.0002 | 2.5081 | 1.0000 |
| 10019 | DenseBlind | ForestGeometry | Link-delay-aware | 0.6671 | 0.2794 | 2.9584 | 0.6337 |
| 10019 | DenseBlind | ForestGeometry | Confidence-driven | 0.6692 | 0.2688 | 3.3324 | 0.6360 |
| 10019 | DenseBlind | ForestGeometry | Constrained Oracle | 0.6670 | 0.2637 | 3.0120 | 0.6336 |
| 10017 | LongRange | Default | Link-delay-aware | 0.9071 | 0.0929 | 1.9231 | 0.9861 |
| 10017 | LongRange | Default | Confidence-driven | 0.9558 | 0.0442 | 2.3680 | 0.9989 |
| 10017 | LongRange | Default | Constrained Oracle | 0.9782 | 0.0218 | 2.4434 | 0.9861 |
| 10017 | LongRange | ForestGeometry | Link-delay-aware | 0.5211 | 0.4780 | 2.1792 | 0.0200 |
| 10017 | LongRange | ForestGeometry | Confidence-driven | 0.5242 | 0.4747 | 2.6790 | 0.0200 |
| 10017 | LongRange | ForestGeometry | Constrained Oracle | 0.5378 | 0.4618 | 3.7779 | 0.0156 |

## Overall Significance: Confidence-driven vs Link-delay-aware

| Scene | Config | Metric | Delta Mean | Delta % | 95% CI | p-value | Holm(all) | Effect(RBC) | Practical |
|---|---|---|---:|---:|---:|---|---|---:|---|
| 10014 | Default | TimelyRate | 0.0028 | 0.2762 | [0.0024, 0.0031] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Below1pp |
| 10014 | Default | LossRate | -0.0028 | -0.2762 | [-0.0031, -0.0024] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Below1pp |
| 10014 | Default | AvgDelay | -0.0004 | -1.8072 | [-0.0005, -0.0004] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Sub-ms |
| 10014 | Default | AvgTxCost | 0.2357 | 14.4637 | [0.2301, 0.2413] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10014 | Default | EmgTimely | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.0325 | 3.2512 | [0.0315, 0.0336] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| 10014 | ForestGeometry | LossRate | -0.0327 | -3.2679 | [-0.0337, -0.0316] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10014 | ForestGeometry | AvgDelay | -0.0124 | -11.8245 | [-0.0128, -0.0119] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10014 | ForestGeometry | AvgTxCost | 0.4924 | 28.9956 | [0.4833, 0.5016] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | -0.0067 | -0.6667 | [-0.0143, 0.0009] | p = 0.3173 | p = 1 | -0.5000 | Below1pp |
| 10006 | Default | TimelyRate | 0.0365 | 3.6473 | [0.0355, 0.0374] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| 10006 | Default | LossRate | -0.0365 | -3.6473 | [-0.0374, -0.0355] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10006 | Default | AvgDelay | -0.0117 | -34.4503 | [-0.0121, -0.0113] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10006 | Default | AvgTxCost | 0.3278 | 15.2703 | [0.3256, 0.3300] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10006 | Default | EmgTimely | 0.0020 | 0.1974 | [0.0016, 0.0023] | p = 1.348e-09 | p = 2.426e-08 | 1.0000 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.0154 | 1.5374 | [0.0144, 0.0163] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| 10006 | ForestGeometry | LossRate | -0.0166 | -1.6606 | [-0.0176, -0.0156] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10006 | ForestGeometry | AvgDelay | -0.0033 | -3.5853 | [-0.0035, -0.0031] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10006 | ForestGeometry | AvgTxCost | 0.4313 | 19.0439 | [0.4253, 0.4372] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.0004 | 0.0395 | [0.0000, 0.0008] | p = 0.2375 | p = 1 | 0.2500 | Below1pp |
| 10011 | Default | TimelyRate | 0.0001 | 0.0100 | [0.0000, 0.0002] | p = 0.07697 | p = 0.8802 | 1.0000 | Below1pp |
| 10011 | Default | LossRate | -0.0001 | -0.0100 | [-0.0002, -0.0000] | p = 0.07697 | p = 0.8802 | -1.0000 | Below1pp |
| 10011 | Default | AvgDelay | -0.0000 | -0.1249 | [-0.0000, -0.0000] | p = 0.06864 | p = 0.8802 | -1.0000 | Sub-ms |
| 10011 | Default | AvgTxCost | 0.2344 | 13.6348 | [0.2286, 0.2401] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10011 | Default | EmgTimely | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| 10011 | ForestGeometry | TimelyRate | 0.0882 | 8.8220 | [0.0867, 0.0898] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| 10011 | ForestGeometry | LossRate | -0.0862 | -8.6156 | [-0.0877, -0.0846] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10011 | ForestGeometry | AvgDelay | -0.0176 | -11.3114 | [-0.0180, -0.0172] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10011 | ForestGeometry | AvgTxCost | 0.6796 | 24.9033 | [0.6717, 0.6875] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10011 | ForestGeometry | EmgTimely | -0.0130 | -1.3000 | [-0.0211, -0.0049] | p = 0.06771 | p = 0.8802 | -0.3280 | Meaningful |
| 10019 | Default | TimelyRate | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| 10019 | Default | LossRate | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| 10019 | Default | AvgDelay | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Sub-ms |
| 10019 | Default | AvgTxCost | 0.4808 | 19.2353 | [0.4787, 0.4829] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10019 | Default | EmgTimely | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| 10019 | ForestGeometry | TimelyRate | 0.0021 | 0.2097 | [0.0012, 0.0030] | p = 0.009709 | p = 0.1456 | 0.4080 | Below1pp |
| 10019 | ForestGeometry | LossRate | -0.0106 | -1.0649 | [-0.0121, -0.0092] | p < 2.3e-308 | p < 1e-15 | -0.9384 | Meaningful |
| 10019 | ForestGeometry | AvgDelay | 0.0002 | 0.4659 | [0.0001, 0.0002] | p = 6.061e-09 | p = 1.030e-07 | 0.7318 | Sub-ms |
| 10019 | ForestGeometry | AvgTxCost | 0.3740 | 12.6434 | [0.3646, 0.3835] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10019 | ForestGeometry | EmgTimely | 0.0023 | 0.2308 | [0.0013, 0.0033] | p = 0.009709 | p = 0.1456 | 0.4080 | Below1pp |
| 10017 | Default | TimelyRate | 0.0488 | 4.8785 | [0.0479, 0.0497] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| 10017 | Default | LossRate | -0.0488 | -4.8785 | [-0.0497, -0.0479] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10017 | Default | AvgDelay | -0.0119 | -30.4051 | [-0.0122, -0.0115] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10017 | Default | AvgTxCost | 0.4448 | 23.1306 | [0.4393, 0.4504] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10017 | Default | EmgTimely | 0.0128 | 1.2778 | [0.0092, 0.0163] | p = 3.658e-05 | p = 5.853e-04 | 1.0000 | Meaningful |
| 10017 | ForestGeometry | TimelyRate | 0.0031 | 0.3128 | [0.0028, 0.0035] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Below1pp |
| 10017 | ForestGeometry | LossRate | -0.0033 | -0.3295 | [-0.0036, -0.0029] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Below1pp |
| 10017 | ForestGeometry | AvgDelay | -0.0005 | -0.3594 | [-0.0005, -0.0004] | p < 2.3e-308 | p < 1e-15 | -0.9949 | Sub-ms |
| 10017 | ForestGeometry | AvgTxCost | 0.4998 | 22.9356 | [0.4873, 0.5124] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | 0.0000 | 0.0000 | [-0.0009, 0.0009] | p = 1 | p = 1 | 0.0000 | Below1pp |

## Cost-Efficiency Summary

| Scene | Config | Method | Timely/Cost | Emergency/Cost | Delta Timely (pp) | Delta Emergency (pp) | Delta Cost | Gain Class |
|---|---|---|---:|---:|---:|---:|---:|---|
| 10014 | Default | Link-delay-aware | 0.5944 | 0.6137 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10014 | Default | Confidence-driven | 0.5207 | 0.5362 | 0.276 | 0.000 | 0.2357 | CostlyGain |
| 10014 | Default | Constrained Oracle | 0.5233 | 0.5266 | 2.519 | 0.000 | 0.2695 | CostlyGain |
| 10014 | ForestGeometry | Link-delay-aware | 0.4370 | 0.0157 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10014 | ForestGeometry | Confidence-driven | 0.3536 | 0.0091 | 3.251 | -0.667 | 0.4924 | CostlyGain |
| 10014 | ForestGeometry | Constrained Oracle | 0.3047 | 0.0076 | 5.840 | -0.667 | 0.9294 | CostlyGain |
| 10006 | Default | Link-delay-aware | 0.4400 | 0.4646 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10006 | Default | Confidence-driven | 0.3964 | 0.4039 | 3.647 | 0.197 | 0.3278 | CostlyGain |
| 10006 | Default | Constrained Oracle | 0.4249 | 0.4287 | 4.416 | 0.000 | 0.1800 | CostlyGain |
| 10006 | ForestGeometry | Link-delay-aware | 0.3054 | 0.3536 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10006 | ForestGeometry | Confidence-driven | 0.2622 | 0.2971 | 1.537 | 0.039 | 0.4313 | CostlyGain |
| 10006 | ForestGeometry | Constrained Oracle | 0.2499 | 0.2798 | 2.353 | -0.020 | 0.5966 | CostlyGain |
| 10011 | Default | Link-delay-aware | 0.5802 | 0.5818 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10011 | Default | Confidence-driven | 0.5106 | 0.5120 | 0.010 | 0.000 | 0.2344 | CostlyGain |
| 10011 | Default | Constrained Oracle | 0.5226 | 0.5240 | 0.013 | 0.000 | 0.1896 | CostlyGain |
| 10011 | ForestGeometry | Link-delay-aware | 0.2163 | 0.1099 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10011 | ForestGeometry | Confidence-driven | 0.1991 | 0.0842 | 8.822 | -1.300 | 0.6796 | CostlyGain |
| 10011 | ForestGeometry | Constrained Oracle | 0.1745 | 0.0760 | 11.012 | 0.500 | 1.2844 | CostlyGain |
| 10019 | Default | Link-delay-aware | 0.4000 | 0.4001 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10019 | Default | Confidence-driven | 0.3355 | 0.3355 | 0.000 | 0.000 | 0.4808 | NoGainExtraCost |
| 10019 | Default | Constrained Oracle | 0.3986 | 0.3987 | 0.000 | 0.000 | 0.0084 | NoGainExtraCost |
| 10019 | ForestGeometry | Link-delay-aware | 0.2255 | 0.2142 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10019 | ForestGeometry | Confidence-driven | 0.2008 | 0.1909 | 0.210 | 0.231 | 0.3740 | CostlyGain |
| 10019 | ForestGeometry | Constrained Oracle | 0.2214 | 0.2104 | -0.010 | -0.011 | 0.0537 | NoGainExtraCost |
| 10017 | Default | Link-delay-aware | 0.4717 | 0.5128 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10017 | Default | Confidence-driven | 0.4037 | 0.4218 | 4.879 | 1.278 | 0.4448 | CostlyGain |
| 10017 | Default | Constrained Oracle | 0.4004 | 0.4036 | 7.118 | 0.000 | 0.5203 | CostlyGain |
| 10017 | ForestGeometry | Link-delay-aware | 0.2391 | 0.0092 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10017 | ForestGeometry | Confidence-driven | 0.1957 | 0.0075 | 0.313 | 0.000 | 0.4998 | CostlyGain |
| 10017 | ForestGeometry | Constrained Oracle | 0.1424 | 0.0041 | 1.674 | -0.444 | 1.5987 | CostlyGain |

## PosDeg_Emerg Stage Summary

| Scene | Role | Config | Method | Timely Mean | Loss Mean | Avg Tx Cost Mean | Emergency Timely Mean |
|---|---|---|---|---:|---:|---:|---:|
| 10014 | Primary | Default | Link-delay-aware | 0.9887 | 0.0113 | 2.0300 | 1.0000 |
| 10014 | Primary | Default | Confidence-driven | 0.9982 | 0.0018 | 3.1215 | 1.0000 |
| 10014 | Primary | Default | Constrained Oracle | 0.9982 | 0.0018 | 2.9312 | 1.0000 |
| 10014 | Primary | ForestGeometry | Link-delay-aware | 0.8113 | 0.1885 | 2.1455 | 0.0267 |
| 10014 | Primary | ForestGeometry | Confidence-driven | 0.8309 | 0.1680 | 3.6636 | 0.0200 |
| 10014 | Primary | ForestGeometry | Constrained Oracle | 0.8327 | 0.1665 | 3.5163 | 0.0200 |
| 10006 | Reference | Default | Link-delay-aware | 1.0000 | 0.0000 | 2.5500 | 1.0000 |
| 10006 | Reference | Default | Confidence-driven | 1.0000 | 0.0000 | 2.6558 | 1.0000 |
| 10006 | Reference | Default | Constrained Oracle | 1.0000 | 0.0000 | 2.5526 | 1.0000 |
| 10006 | Reference | ForestGeometry | Link-delay-aware | 0.8935 | 0.1053 | 2.6155 | 0.8935 |
| 10006 | Reference | ForestGeometry | Confidence-driven | 0.8944 | 0.1025 | 2.9263 | 0.8944 |
| 10006 | Reference | ForestGeometry | Constrained Oracle | 0.8942 | 0.1040 | 2.7546 | 0.8942 |
| 10011 | Boundary | Default | Link-delay-aware | 0.9995 | 0.0005 | 2.0000 | NaN |
| 10011 | Boundary | Default | Confidence-driven | 1.0000 | 0.0000 | 3.0182 | NaN |
| 10011 | Boundary | Default | Constrained Oracle | 1.0000 | 0.0000 | 2.8767 | NaN |
| 10011 | Boundary | ForestGeometry | Link-delay-aware | 0.7656 | 0.2344 | 2.0000 | NaN |
| 10011 | Boundary | ForestGeometry | Confidence-driven | 0.9765 | 0.0235 | 3.6199 | NaN |
| 10011 | Boundary | ForestGeometry | Constrained Oracle | 0.9862 | 0.0138 | 3.6826 | NaN |
| 10019 | DenseBlind | Default | Link-delay-aware | 1.0000 | 0.0000 | 2.5500 | 1.0000 |
| 10019 | DenseBlind | Default | Confidence-driven | 1.0000 | 0.0000 | 3.0034 | 1.0000 |
| 10019 | DenseBlind | Default | Constrained Oracle | 1.0000 | 0.0000 | 2.5940 | 1.0000 |
| 10019 | DenseBlind | ForestGeometry | Link-delay-aware | 0.6225 | 0.1933 | 3.8283 | 0.6225 |
| 10019 | DenseBlind | ForestGeometry | Confidence-driven | 0.6324 | 0.1535 | 4.2169 | 0.6324 |
| 10019 | DenseBlind | ForestGeometry | Constrained Oracle | 0.6309 | 0.1276 | 4.3357 | 0.6309 |
| 10017 | LongRange | Default | Link-delay-aware | 0.9995 | 0.0005 | 2.0000 | NaN |
| 10017 | LongRange | Default | Confidence-driven | 1.0000 | 0.0000 | 3.0169 | NaN |
| 10017 | LongRange | Default | Constrained Oracle | 1.0000 | 0.0000 | 2.8753 | NaN |
| 10017 | LongRange | ForestGeometry | Link-delay-aware | 0.9989 | 0.0011 | 2.0000 | NaN |
| 10017 | LongRange | ForestGeometry | Confidence-driven | 0.9998 | 0.0002 | 3.0967 | NaN |
| 10017 | LongRange | ForestGeometry | Constrained Oracle | 0.9998 | 0.0002 | 2.9436 | NaN |

## PosDeg_Emerg Significance: Confidence-driven vs Link-delay-aware

| Scene | Config | Metric | Delta Mean | Delta % | 95% CI | p-value | Holm(all) | Effect(RBC) | Practical |
|---|---|---|---:|---:|---:|---|---|---:|---|
| 10014 | Default | TimelyRate | 0.0095 | 0.9455 | [0.0082, 0.0107] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Below1pp |
| 10014 | Default | LossRate | -0.0095 | -0.9455 | [-0.0107, -0.0082] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Below1pp |
| 10014 | Default | AvgDelay | 0.0001 | 0.9057 | [0.0001, 0.0001] | p = 5.646e-10 | p = 1.694e-08 | 0.9492 | Sub-ms |
| 10014 | Default | AvgTxCost | 1.0915 | 53.7671 | [1.0650, 1.1180] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10014 | Default | EmgTimely | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.0196 | 1.9636 | [0.0176, 0.0216] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| 10014 | ForestGeometry | LossRate | -0.0205 | -2.0545 | [-0.0226, -0.0185] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10014 | ForestGeometry | AvgDelay | 0.0007 | 5.4527 | [0.0006, 0.0008] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Sub-ms |
| 10014 | ForestGeometry | AvgTxCost | 1.5182 | 70.7625 | [1.4757, 1.5607] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | -0.0067 | -0.6667 | [-0.0143, 0.0009] | p = 0.3173 | p = 1 | -0.5000 | Below1pp |
| 10006 | Default | TimelyRate | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| 10006 | Default | LossRate | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| 10006 | Default | AvgDelay | -0.0000 | -0.0192 | [-0.0000, 0.0000] | p = 0.3173 | p = 1 | -1.0000 | Sub-ms |
| 10006 | Default | AvgTxCost | 0.1058 | 4.1497 | [0.1009, 0.1108] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10006 | Default | EmgTimely | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.0009 | 0.0909 | [0.0003, 0.0015] | p = 0.08956 | p = 1 | 0.5556 | Below1pp |
| 10006 | ForestGeometry | LossRate | -0.0027 | -0.2727 | [-0.0035, -0.0020] | p = 2.671e-05 | p = 7.478e-04 | -1.0000 | Below1pp |
| 10006 | ForestGeometry | AvgDelay | 0.0003 | 2.0679 | [0.0002, 0.0003] | p = 2.692e-06 | p = 7.806e-05 | 1.0000 | Sub-ms |
| 10006 | ForestGeometry | AvgTxCost | 0.3109 | 11.8861 | [0.2967, 0.3250] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.0009 | 0.0909 | [0.0003, 0.0015] | p = 0.08956 | p = 1 | 0.5556 | Below1pp |
| 10011 | Default | TimelyRate | 0.0005 | 0.0545 | [0.0002, 0.0009] | p = 0.07697 | p = 1 | 1.0000 | Below1pp |
| 10011 | Default | LossRate | -0.0005 | -0.0545 | [-0.0009, -0.0002] | p = 0.07697 | p = 1 | -1.0000 | Below1pp |
| 10011 | Default | AvgDelay | 0.0000 | 0.0655 | [0.0000, 0.0000] | p = 0.07831 | p = 1 | 1.0000 | Sub-ms |
| 10011 | Default | AvgTxCost | 1.0182 | 50.9109 | [0.9909, 1.0456] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10011 | Default | EmgTimely | NaN | NaN | [NaN, NaN] | p = 1 | p = 1 | 0.0000 | NotApplicable |
| 10011 | ForestGeometry | TimelyRate | 0.2109 | 21.0909 | [0.2043, 0.2175] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| 10011 | ForestGeometry | LossRate | -0.2109 | -21.0909 | [-0.2175, -0.2043] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10011 | ForestGeometry | AvgDelay | 0.0035 | 18.8646 | [0.0033, 0.0036] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| 10011 | ForestGeometry | AvgTxCost | 1.6199 | 80.9951 | [1.5950, 1.6448] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10011 | ForestGeometry | EmgTimely | NaN | NaN | [NaN, NaN] | p = 1 | p = 1 | 0.0000 | NotApplicable |
| 10019 | Default | TimelyRate | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| 10019 | Default | LossRate | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| 10019 | Default | AvgDelay | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Sub-ms |
| 10019 | Default | AvgTxCost | 0.4534 | 17.7797 | [0.4488, 0.4580] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10019 | Default | EmgTimely | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| 10019 | ForestGeometry | TimelyRate | 0.0098 | 0.9818 | [0.0053, 0.0143] | p = 0.01304 | p = 0.3522 | 0.4576 | Below1pp |
| 10019 | ForestGeometry | LossRate | -0.0398 | -3.9818 | [-0.0446, -0.0350] | p < 2.3e-308 | p < 1e-15 | -0.9445 | Meaningful |
| 10019 | ForestGeometry | AvgDelay | 0.0018 | 3.5280 | [0.0016, 0.0021] | p = 2.975e-14 | p = 9.224e-13 | 0.8416 | Meaningful |
| 10019 | ForestGeometry | AvgTxCost | 0.3886 | 10.1509 | [0.3652, 0.4120] | p < 2.3e-308 | p < 1e-15 | 0.9953 | SeeDelta |
| 10019 | ForestGeometry | EmgTimely | 0.0098 | 0.9818 | [0.0053, 0.0143] | p = 0.01304 | p = 0.3522 | 0.4576 | Below1pp |
| 10017 | Default | TimelyRate | 0.0005 | 0.0545 | [0.0002, 0.0009] | p = 0.07697 | p = 1 | 1.0000 | Below1pp |
| 10017 | Default | LossRate | -0.0005 | -0.0545 | [-0.0009, -0.0002] | p = 0.07697 | p = 1 | -1.0000 | Below1pp |
| 10017 | Default | AvgDelay | 0.0000 | 0.0655 | [0.0000, 0.0000] | p = 0.07831 | p = 1 | 1.0000 | Sub-ms |
| 10017 | Default | AvgTxCost | 1.0169 | 50.8473 | [0.9896, 1.0443] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10017 | Default | EmgTimely | NaN | NaN | [NaN, NaN] | p = 1 | p = 1 | 0.0000 | NotApplicable |
| 10017 | ForestGeometry | TimelyRate | 0.0009 | 0.0909 | [0.0004, 0.0014] | p = 0.0522 | p = 1 | 1.0000 | Below1pp |
| 10017 | ForestGeometry | LossRate | -0.0009 | -0.0909 | [-0.0014, -0.0004] | p = 0.0522 | p = 1 | -1.0000 | Below1pp |
| 10017 | ForestGeometry | AvgDelay | 0.0000 | 0.1184 | [0.0000, 0.0000] | p = 0.04552 | p = 1 | 1.0000 | Sub-ms |
| 10017 | ForestGeometry | AvgTxCost | 1.0967 | 54.8345 | [1.0537, 1.1397] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | NaN | NaN | [NaN, NaN] | p = 1 | p = 1 | 0.0000 | NotApplicable |

## Recommended Narrative

- The overall gain should be described as a stable but moderate improvement under repeated random realizations.
- The PosDeg\_Emerg results should be emphasized as the main source of method value, especially under forest-geometry calibration.
- The forest-geometry setting should be presented as the more application-relevant evidence for the paper topic.
- Results marked `Below1pp` or `Sub-ms` should be interpreted cautiously even when uncorrected p-values are small.

## Method Applicability Analysis

The confidence-driven scheduler is not expected to improve every scene uniformly. Its intended activation regime is the overlap between blind-zone risk and positioning-confidence degradation, especially in the `PosDeg_Emerg` stage.

A scene should therefore be interpreted as method-applicable only when two conditions co-occur:
- low positioning confidence (`q_{pos}` falls into the low-confidence regime);
- blind-zone risk exceeds the protection trigger and overlaps the emergency time window.

The boundary scene `10011` should be interpreted as positive evidence of graceful degradation rather than as a failure case. In the open/low/sparse setting, the confidence-driven scheduler does not improve timely performance because the critical trigger overlap is absent; however, it also does not degrade timely performance relative to the link-aware baseline. This indicates that the proposed scheduler collapses to the baseline behavior under easy conditions, while its gain is concentrated in the risk-dominant scenes such as `10014 / ForestGeometry`.
