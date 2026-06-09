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
| 10017 | LongRange | LongMixed | Medium | Mixed |
## Overall Mean Summary

| Scene | Role | Config | Method | Timely Mean | Loss Mean | Avg Tx Cost Mean | Emergency Timely Mean |
|---|---|---|---|---:|---:|---:|---:|
| 10014 | Primary | Default | Link-delay-aware | 0.9685 | 0.0315 | 1.6295 | 1.0000 |
| 10014 | Primary | Default | Confidence-driven | 0.9714 | 0.0286 | 1.9153 | 1.0000 |
| 10014 | Primary | Default | Oracle | 0.9937 | 0.0063 | 1.8990 | 1.0000 |
| 10014 | Primary | ForestGeometry | Link-delay-aware | 0.9595 | 0.0404 | 2.2112 | 0.8333 |
| 10014 | Primary | ForestGeometry | Confidence-driven | 0.9721 | 0.0273 | 2.5792 | 0.9233 |
| 10014 | Primary | ForestGeometry | Oracle | 0.9714 | 0.0281 | 2.5656 | 0.9300 |
| 10006 | Reference | Default | Link-delay-aware | 0.9445 | 0.0555 | 2.1468 | 0.9974 |
| 10006 | Reference | Default | Confidence-driven | 0.9810 | 0.0190 | 2.4974 | 0.9994 |
| 10006 | Reference | Default | Oracle | 0.9887 | 0.0113 | 2.3268 | 0.9974 |
| 10006 | Reference | ForestGeometry | Link-delay-aware | 0.8769 | 0.1175 | 2.4733 | 0.9629 |
| 10006 | Reference | ForestGeometry | Confidence-driven | 0.8885 | 0.1055 | 2.7964 | 0.9678 |
| 10006 | Reference | ForestGeometry | Oracle | 0.9109 | 0.0781 | 2.7735 | 0.9642 |
| 10017 | LongRange | Default | Link-delay-aware | 0.9071 | 0.0929 | 1.9231 | 0.9861 |
| 10017 | LongRange | Default | Confidence-driven | 0.9558 | 0.0442 | 2.3721 | 0.9989 |
| 10017 | LongRange | Default | Oracle | 0.9782 | 0.0218 | 2.4434 | 0.9861 |
| 10017 | LongRange | ForestGeometry | Link-delay-aware | 0.8067 | 0.1758 | 2.9413 | 0.6222 |
| 10017 | LongRange | ForestGeometry | Confidence-driven | 0.8425 | 0.1399 | 3.6198 | 0.6433 |
| 10017 | LongRange | ForestGeometry | Oracle | 0.8762 | 0.1062 | 4.0232 | 0.6411 |

## Overall Significance: Confidence-driven vs Link-delay-aware

| Scene | Config | Metric | Delta Mean | Delta % | 95% CI | p-value | Holm(all) | Effect(RBC) | Practical |
|---|---|---|---:|---:|---:|---|---|---:|---|
| 10014 | Default | TimelyRate | 0.0029 | 0.2928 | [0.0026, 0.0033] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Below1pp |
| 10014 | Default | LossRate | -0.0029 | -0.2928 | [-0.0033, -0.0026] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Below1pp |
| 10014 | Default | AvgDelay | -0.0001 | -0.4416 | [-0.0002, -0.0000] | p = 0.03872 | p = 0.07744 | -0.2455 | Sub-ms |
| 10014 | Default | AvgTxCost | 0.2858 | 17.5402 | [0.2791, 0.2925] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10014 | Default | EmgTimely | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.0127 | 1.2679 | [0.0114, 0.0140] | p < 2.3e-308 | p < 1e-15 | 0.9829 | Meaningful |
| 10014 | ForestGeometry | LossRate | -0.0131 | -1.3078 | [-0.0144, -0.0118] | p < 2.3e-308 | p < 1e-15 | -0.9965 | Meaningful |
| 10014 | ForestGeometry | AvgDelay | -0.0016 | -4.4117 | [-0.0020, -0.0012] | p = 6.132e-07 | p = 3.066e-06 | -0.6847 | Meaningful |
| 10014 | ForestGeometry | AvgTxCost | 0.3680 | 16.6414 | [0.3599, 0.3760] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | 0.0900 | 9.0000 | [0.0681, 0.1119] | p = 2.678e-06 | p = 1.071e-05 | 0.8291 | Meaningful |
| 10006 | Default | TimelyRate | 0.0365 | 3.6473 | [0.0355, 0.0374] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| 10006 | Default | LossRate | -0.0365 | -3.6473 | [-0.0374, -0.0355] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10006 | Default | AvgDelay | -0.0114 | -33.6983 | [-0.0118, -0.0110] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10006 | Default | AvgTxCost | 0.3506 | 16.3323 | [0.3465, 0.3547] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10006 | Default | EmgTimely | 0.0020 | 0.1974 | [0.0016, 0.0023] | p = 1.348e-09 | p = 8.088e-09 | 1.0000 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.0116 | 1.1614 | [0.0108, 0.0124] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| 10006 | ForestGeometry | LossRate | -0.0120 | -1.1980 | [-0.0128, -0.0112] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10006 | ForestGeometry | AvgDelay | -0.0011 | -1.8267 | [-0.0013, -0.0009] | p = 1.163e-12 | p = 9.305e-12 | -0.8620 | Meaningful |
| 10006 | ForestGeometry | AvgTxCost | 0.3230 | 13.0610 | [0.3175, 0.3286] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.0049 | 0.4934 | [0.0044, 0.0055] | p < 2.3e-308 | p < 1e-15 | 0.9788 | Below1pp |
| 10017 | Default | TimelyRate | 0.0488 | 4.8785 | [0.0479, 0.0497] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| 10017 | Default | LossRate | -0.0488 | -4.8785 | [-0.0497, -0.0479] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10017 | Default | AvgDelay | -0.0118 | -30.3331 | [-0.0122, -0.0115] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10017 | Default | AvgTxCost | 0.4490 | 23.3479 | [0.4432, 0.4548] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10017 | Default | EmgTimely | 0.0128 | 1.2778 | [0.0092, 0.0163] | p = 3.658e-05 | p = 1.097e-04 | 1.0000 | Meaningful |
| 10017 | ForestGeometry | TimelyRate | 0.0358 | 3.5840 | [0.0344, 0.0373] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| 10017 | ForestGeometry | LossRate | -0.0359 | -3.5940 | [-0.0374, -0.0345] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10017 | ForestGeometry | AvgDelay | -0.0029 | -3.6501 | [-0.0032, -0.0027] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10017 | ForestGeometry | AvgTxCost | 0.6785 | 23.0688 | [0.6694, 0.6876] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | 0.0211 | 2.1111 | [0.0175, 0.0247] | p = 1.556e-11 | p = 1.089e-10 | 1.0000 | Meaningful |

## PosDeg_Emerg Stage Summary

| Scene | Role | Config | Method | Timely Mean | Loss Mean | Avg Tx Cost Mean | Emergency Timely Mean |
|---|---|---|---|---:|---:|---:|---:|
| 10014 | Primary | Default | Link-delay-aware | 0.9887 | 0.0113 | 2.0300 | 1.0000 |
| 10014 | Primary | Default | Confidence-driven | 0.9991 | 0.0009 | 3.3240 | 1.0000 |
| 10014 | Primary | Default | Oracle | 0.9982 | 0.0018 | 2.9312 | 1.0000 |
| 10014 | Primary | ForestGeometry | Link-delay-aware | 0.9604 | 0.0389 | 2.2227 | 0.8333 |
| 10014 | Primary | ForestGeometry | Confidence-driven | 0.9924 | 0.0047 | 3.6211 | 0.9233 |
| 10014 | Primary | ForestGeometry | Oracle | 0.9925 | 0.0044 | 3.4622 | 0.9300 |
| 10006 | Reference | Default | Link-delay-aware | 1.0000 | 0.0000 | 2.5500 | 1.0000 |
| 10006 | Reference | Default | Confidence-driven | 1.0000 | 0.0000 | 2.7005 | 1.0000 |
| 10006 | Reference | Default | Oracle | 1.0000 | 0.0000 | 2.5526 | 1.0000 |
| 10006 | Reference | ForestGeometry | Link-delay-aware | 0.9964 | 0.0036 | 2.5500 | 0.9964 |
| 10006 | Reference | ForestGeometry | Confidence-driven | 0.9993 | 0.0007 | 2.7893 | 0.9993 |
| 10006 | Reference | ForestGeometry | Oracle | 0.9969 | 0.0031 | 2.6091 | 0.9969 |
| 10017 | LongRange | Default | Link-delay-aware | 0.9995 | 0.0005 | 2.0000 | NaN |
| 10017 | LongRange | Default | Confidence-driven | 1.0000 | 0.0000 | 3.0169 | NaN |
| 10017 | LongRange | Default | Oracle | 1.0000 | 0.0000 | 2.8753 | NaN |
| 10017 | LongRange | ForestGeometry | Link-delay-aware | 0.9995 | 0.0005 | 2.0000 | NaN |
| 10017 | LongRange | ForestGeometry | Confidence-driven | 1.0000 | 0.0000 | 3.0910 | NaN |
| 10017 | LongRange | ForestGeometry | Oracle | 1.0000 | 0.0000 | 2.9298 | NaN |

## PosDeg_Emerg Significance: Confidence-driven vs Link-delay-aware

| Scene | Config | Metric | Delta Mean | Delta % | 95% CI | p-value | Holm(all) | Effect(RBC) | Practical |
|---|---|---|---:|---:|---:|---|---|---:|---|
| 10014 | Default | TimelyRate | 0.0104 | 1.0364 | [0.0091, 0.0117] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| 10014 | Default | LossRate | -0.0104 | -1.0364 | [-0.0117, -0.0091] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10014 | Default | AvgDelay | 0.0014 | 11.9682 | [0.0014, 0.0015] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| 10014 | Default | AvgTxCost | 1.2940 | 63.7442 | [1.2651, 1.3229] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10014 | Default | EmgTimely | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| 10014 | ForestGeometry | TimelyRate | 0.0320 | 3.2000 | [0.0289, 0.0351] | p < 2.3e-308 | p < 1e-15 | 0.9951 | Meaningful |
| 10014 | ForestGeometry | LossRate | -0.0342 | -3.4182 | [-0.0372, -0.0311] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| 10014 | ForestGeometry | AvgDelay | 0.0026 | 14.8950 | [0.0024, 0.0027] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| 10014 | ForestGeometry | AvgTxCost | 1.3984 | 62.9136 | [1.3585, 1.4383] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10014 | ForestGeometry | EmgTimely | 0.0900 | 9.0000 | [0.0681, 0.1119] | p = 2.678e-06 | p = 4.285e-05 | 0.8291 | Meaningful |
| 10006 | Default | TimelyRate | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| 10006 | Default | LossRate | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| 10006 | Default | AvgDelay | 0.0006 | 4.9873 | [0.0005, 0.0007] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Sub-ms |
| 10006 | Default | AvgTxCost | 0.1505 | 5.9010 | [0.1421, 0.1589] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10006 | Default | EmgTimely | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| 10006 | ForestGeometry | TimelyRate | 0.0029 | 0.2909 | [0.0022, 0.0037] | p = 1.018e-05 | p = 1.528e-04 | 1.0000 | Below1pp |
| 10006 | ForestGeometry | LossRate | -0.0029 | -0.2909 | [-0.0037, -0.0022] | p = 1.018e-05 | p = 1.528e-04 | -1.0000 | Below1pp |
| 10006 | ForestGeometry | AvgDelay | 0.0006 | 5.1283 | [0.0006, 0.0007] | p < 2.3e-308 | p < 1e-15 | 0.9876 | Sub-ms |
| 10006 | ForestGeometry | AvgTxCost | 0.2393 | 9.3831 | [0.2238, 0.2548] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10006 | ForestGeometry | EmgTimely | 0.0029 | 0.2909 | [0.0022, 0.0037] | p = 1.018e-05 | p = 1.528e-04 | 1.0000 | Below1pp |
| 10017 | Default | TimelyRate | 0.0005 | 0.0545 | [0.0002, 0.0009] | p = 0.07697 | p = 0.9237 | 1.0000 | Below1pp |
| 10017 | Default | LossRate | -0.0005 | -0.0545 | [-0.0009, -0.0002] | p = 0.07697 | p = 0.9237 | -1.0000 | Below1pp |
| 10017 | Default | AvgDelay | 0.0000 | 0.0655 | [0.0000, 0.0000] | p = 0.07831 | p = 0.9237 | 1.0000 | Sub-ms |
| 10017 | Default | AvgTxCost | 1.0169 | 50.8473 | [0.9896, 1.0443] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10017 | Default | EmgTimely | NaN | NaN | [NaN, NaN] | p = 1 | p = 1 | 0.0000 | Meaningful |
| 10017 | ForestGeometry | TimelyRate | 0.0005 | 0.0545 | [0.0002, 0.0009] | p = 0.07697 | p = 0.9237 | 1.0000 | Below1pp |
| 10017 | ForestGeometry | LossRate | -0.0005 | -0.0545 | [-0.0009, -0.0002] | p = 0.07697 | p = 0.9237 | -1.0000 | Below1pp |
| 10017 | ForestGeometry | AvgDelay | 0.0000 | 0.0655 | [0.0000, 0.0000] | p = 0.07831 | p = 0.9237 | 1.0000 | Sub-ms |
| 10017 | ForestGeometry | AvgTxCost | 1.0910 | 54.5500 | [1.0502, 1.1318] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| 10017 | ForestGeometry | EmgTimely | NaN | NaN | [NaN, NaN] | p = 1 | p = 1 | 0.0000 | Meaningful |

## Recommended Narrative

- The overall gain should be described as a stable but moderate improvement under repeated random realizations.
- The PosDeg\_Emerg results should be emphasized as the main source of method value, especially under forest-geometry calibration.
- The forest-geometry setting should be presented as the more application-relevant evidence for the paper topic.
- Results marked `Below1pp` or `Sub-ms` should be interpreted cautiously even when uncorrected p-values are small.
