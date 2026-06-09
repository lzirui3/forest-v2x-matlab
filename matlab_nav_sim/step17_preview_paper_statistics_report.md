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
| 10014 | Primary | Default | Link-delay-aware | 0.9687 | 0.0313 | 1.6295 | 1.0000 |
| 10014 | Primary | Default | Confidence-driven | 0.9727 | 0.0273 | 1.6737 | 1.0000 |
| 10014 | Primary | Default | Oracle | 0.9903 | 0.0097 | 1.6941 | 1.0000 |
| 10014 | Primary | ForestGeometry | Link-delay-aware | 0.9659 | 0.0338 | 2.1648 | 0.7833 |
| 10014 | Primary | ForestGeometry | Confidence-driven | 0.9745 | 0.0243 | 2.2960 | 0.8667 |
| 10014 | Primary | ForestGeometry | Oracle | 0.9745 | 0.0245 | 2.2871 | 0.8667 |
| 10006 | Reference | Default | Link-delay-aware | 0.9456 | 0.0544 | 2.1468 | 0.9974 |
| 10006 | Reference | Default | Confidence-driven | 0.9827 | 0.0173 | 2.5034 | 0.9997 |
| 10006 | Reference | Default | Oracle | 0.9877 | 0.0123 | 2.2932 | 0.9974 |
| 10006 | Reference | ForestGeometry | Link-delay-aware | 0.8684 | 0.1270 | 2.4024 | 0.9638 |
| 10006 | Reference | ForestGeometry | Confidence-driven | 0.8795 | 0.1153 | 2.7182 | 0.9688 |
| 10006 | Reference | ForestGeometry | Oracle | 0.9108 | 0.0774 | 2.7341 | 0.9625 |
| 10011 | Boundary | Default | Link-delay-aware | 0.9972 | 0.0028 | 1.7188 | 1.0000 |
| 10011 | Boundary | Default | Confidence-driven | 0.9972 | 0.0028 | 1.7404 | 1.0000 |
| 10011 | Boundary | Default | Oracle | 0.9972 | 0.0028 | 1.7188 | 1.0000 |
| 10011 | Boundary | ForestGeometry | Link-delay-aware | 0.9782 | 0.0218 | 1.7188 | 0.9950 |
| 10011 | Boundary | ForestGeometry | Confidence-driven | 0.9962 | 0.0038 | 1.8403 | 1.0000 |
| 10011 | Boundary | ForestGeometry | Oracle | 0.9977 | 0.0023 | 1.8286 | 0.9950 |
| 10019 | DenseBlind | Default | Link-delay-aware | 1.0000 | 0.0000 | 2.4997 | 1.0000 |
| 10019 | DenseBlind | Default | Confidence-driven | 1.0000 | 0.0000 | 3.1078 | 1.0000 |
| 10019 | DenseBlind | Default | Oracle | 1.0000 | 0.0000 | 2.4997 | 1.0000 |
| 10019 | DenseBlind | ForestGeometry | Link-delay-aware | 0.9995 | 0.0005 | 2.4997 | 0.9995 |
| 10019 | DenseBlind | ForestGeometry | Confidence-driven | 1.0000 | 0.0000 | 3.1262 | 1.0000 |
| 10019 | DenseBlind | ForestGeometry | Oracle | 0.9995 | 0.0005 | 2.4997 | 0.9995 |
| 10017 | LongRange | Default | Link-delay-aware | 0.9045 | 0.0955 | 1.9231 | 0.9917 |
| 10017 | LongRange | Default | Confidence-driven | 0.9556 | 0.0444 | 2.1484 | 1.0000 |
| 10017 | LongRange | Default | Oracle | 0.9729 | 0.0271 | 2.2060 | 0.9917 |
| 10017 | LongRange | ForestGeometry | Link-delay-aware | 0.7988 | 0.1855 | 2.7630 | 0.6056 |
| 10017 | LongRange | ForestGeometry | Confidence-driven | 0.8266 | 0.1577 | 3.0558 | 0.6417 |
| 10017 | LongRange | ForestGeometry | Oracle | 0.8684 | 0.1143 | 3.5054 | 0.6472 |

## Overall Significance: Confidence-driven vs Link-delay-aware

| Scene | Config | Metric | Delta Mean | 95% CI | p-value | Significance |
|---|---|---|---:|---:|---:|---|
| 10014 | Default | TimelyRate | 0.0040 | [0.0033, 0.0047] | 1.674e-12 | *** |
| 10014 | Default | LossRate | -0.0040 | [-0.0047, -0.0033] | 1.674e-12 | *** |
| 10014 | Default | AvgDelay | -0.0005 | [-0.0007, -0.0004] | 2.466e-05 | *** |
| 10014 | Default | AvgTxCost | 0.0442 | [0.0394, 0.0491] | 0 | *** |
| 10014 | Default | EmgTimely | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10014 | ForestGeometry | TimelyRate | 0.0087 | [0.0071, 0.0102] | 3.713e-11 | *** |
| 10014 | ForestGeometry | LossRate | -0.0095 | [-0.0110, -0.0080] | 6.439e-15 | *** |
| 10014 | ForestGeometry | AvgDelay | -0.0009 | [-0.0011, -0.0006] | 3.74e-06 | *** |
| 10014 | ForestGeometry | AvgTxCost | 0.1312 | [0.1248, 0.1377] | 0 | *** |
| 10014 | ForestGeometry | EmgTimely | 0.0833 | [0.0287, 0.1379] | 0.06281 | n.s. |
| 10006 | Default | TimelyRate | 0.0371 | [0.0346, 0.0396] | 0 | *** |
| 10006 | Default | LossRate | -0.0371 | [-0.0396, -0.0346] | 0 | *** |
| 10006 | Default | AvgDelay | -0.0134 | [-0.0142, -0.0126] | 0 | *** |
| 10006 | Default | AvgTxCost | 0.3567 | [0.3500, 0.3634] | 0 | *** |
| 10006 | Default | EmgTimely | 0.0023 | [0.0014, 0.0032] | 0.001039 | ** |
| 10006 | ForestGeometry | TimelyRate | 0.0111 | [0.0099, 0.0124] | 0 | *** |
| 10006 | ForestGeometry | LossRate | -0.0116 | [-0.0130, -0.0103] | 0 | *** |
| 10006 | ForestGeometry | AvgDelay | -0.0016 | [-0.0019, -0.0014] | 6.617e-14 | *** |
| 10006 | ForestGeometry | AvgTxCost | 0.3158 | [0.3037, 0.3278] | 0 | *** |
| 10006 | ForestGeometry | EmgTimely | 0.0049 | [0.0040, 0.0058] | 1.981e-11 | *** |
| 10011 | Default | TimelyRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10011 | Default | LossRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10011 | Default | AvgDelay | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10011 | Default | AvgTxCost | 0.0216 | [0.0196, 0.0236] | 0 | *** |
| 10011 | Default | EmgTimely | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10011 | ForestGeometry | TimelyRate | 0.0180 | [0.0156, 0.0203] | 0 | *** |
| 10011 | ForestGeometry | LossRate | -0.0180 | [-0.0203, -0.0156] | 0 | *** |
| 10011 | ForestGeometry | AvgDelay | -0.0029 | [-0.0033, -0.0025] | 0 | *** |
| 10011 | ForestGeometry | AvgTxCost | 0.1215 | [0.1160, 0.1270] | 0 | *** |
| 10011 | ForestGeometry | EmgTimely | 0.0050 | [-0.0011, 0.0111] | 0.3173 | n.s. |
| 10019 | Default | TimelyRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10019 | Default | LossRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10019 | Default | AvgDelay | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10019 | Default | AvgTxCost | 0.6081 | [0.6026, 0.6136] | 0 | *** |
| 10019 | Default | EmgTimely | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10019 | ForestGeometry | TimelyRate | 0.0005 | [0.0001, 0.0009] | 0.1599 | n.s. |
| 10019 | ForestGeometry | LossRate | -0.0005 | [-0.0009, -0.0001] | 0.1599 | n.s. |
| 10019 | ForestGeometry | AvgDelay | -0.0001 | [-0.0001, -0.0000] | 0.001567 | ** |
| 10019 | ForestGeometry | AvgTxCost | 0.6266 | [0.6191, 0.6340] | 0 | *** |
| 10019 | ForestGeometry | EmgTimely | 0.0005 | [0.0001, 0.0010] | 0.1599 | n.s. |
| 10017 | Default | TimelyRate | 0.0511 | [0.0477, 0.0544] | 0 | *** |
| 10017 | Default | LossRate | -0.0511 | [-0.0544, -0.0477] | 0 | *** |
| 10017 | Default | AvgDelay | -0.0134 | [-0.0145, -0.0123] | 0 | *** |
| 10017 | Default | AvgTxCost | 0.2253 | [0.2228, 0.2278] | 0 | *** |
| 10017 | Default | EmgTimely | 0.0083 | [0.0032, 0.0135] | 0.04953 | * |
| 10017 | ForestGeometry | TimelyRate | 0.0278 | [0.0248, 0.0307] | 0 | *** |
| 10017 | ForestGeometry | LossRate | -0.0278 | [-0.0307, -0.0248] | 0 | *** |
| 10017 | ForestGeometry | AvgDelay | -0.0039 | [-0.0044, -0.0034] | 0 | *** |
| 10017 | ForestGeometry | AvgTxCost | 0.2928 | [0.2810, 0.3046] | 0 | *** |
| 10017 | ForestGeometry | EmgTimely | 0.0361 | [0.0260, 0.0463] | 1.47e-05 | *** |

## PosDeg_Emerg Stage Summary

| Scene | Role | Config | Method | Timely Mean | Loss Mean | Avg Tx Cost Mean | Emergency Timely Mean |
|---|---|---|---|---:|---:|---:|---:|
| 10014 | Primary | Default | Link-delay-aware | 0.9909 | 0.0091 | 2.0300 | 1.0000 |
| 10014 | Primary | Default | Confidence-driven | 0.9982 | 0.0018 | 2.1976 | 1.0000 |
| 10014 | Primary | Default | Oracle | 0.9909 | 0.0091 | 2.0300 | 1.0000 |
| 10014 | Primary | ForestGeometry | Link-delay-aware | 0.9609 | 0.0373 | 2.2282 | 0.7833 |
| 10014 | Primary | ForestGeometry | Confidence-driven | 0.9882 | 0.0055 | 2.7194 | 0.8667 |
| 10014 | Primary | ForestGeometry | Oracle | 0.9882 | 0.0064 | 2.6236 | 0.8667 |
| 10006 | Reference | Default | Link-delay-aware | 1.0000 | 0.0000 | 2.5500 | 1.0000 |
| 10006 | Reference | Default | Confidence-driven | 1.0000 | 0.0000 | 2.8713 | 1.0000 |
| 10006 | Reference | Default | Oracle | 1.0000 | 0.0000 | 2.5500 | 1.0000 |
| 10006 | Reference | ForestGeometry | Link-delay-aware | 0.9964 | 0.0036 | 2.5500 | 0.9964 |
| 10006 | Reference | ForestGeometry | Confidence-driven | 1.0000 | 0.0000 | 2.9945 | 1.0000 |
| 10006 | Reference | ForestGeometry | Oracle | 0.9964 | 0.0036 | 2.5500 | 0.9964 |
| 10011 | Boundary | Default | Link-delay-aware | 1.0000 | 0.0000 | 2.0000 | NaN |
| 10011 | Boundary | Default | Confidence-driven | 1.0000 | 0.0000 | 2.0089 | NaN |
| 10011 | Boundary | Default | Oracle | 1.0000 | 0.0000 | 2.0000 | NaN |
| 10011 | Boundary | ForestGeometry | Link-delay-aware | 1.0000 | 0.0000 | 2.0000 | NaN |
| 10011 | Boundary | ForestGeometry | Confidence-driven | 1.0000 | 0.0000 | 2.0407 | NaN |
| 10011 | Boundary | ForestGeometry | Oracle | 1.0000 | 0.0000 | 2.0000 | NaN |
| 10019 | DenseBlind | Default | Link-delay-aware | 1.0000 | 0.0000 | 2.5500 | 1.0000 |
| 10019 | DenseBlind | Default | Confidence-driven | 1.0000 | 0.0000 | 3.4533 | 1.0000 |
| 10019 | DenseBlind | Default | Oracle | 1.0000 | 0.0000 | 2.5500 | 1.0000 |
| 10019 | DenseBlind | ForestGeometry | Link-delay-aware | 1.0000 | 0.0000 | 2.5500 | 1.0000 |
| 10019 | DenseBlind | ForestGeometry | Confidence-driven | 1.0000 | 0.0000 | 3.4855 | 1.0000 |
| 10019 | DenseBlind | ForestGeometry | Oracle | 1.0000 | 0.0000 | 2.5500 | 1.0000 |
| 10017 | LongRange | Default | Link-delay-aware | 1.0000 | 0.0000 | 2.0000 | NaN |
| 10017 | LongRange | Default | Confidence-driven | 1.0000 | 0.0000 | 2.0089 | NaN |
| 10017 | LongRange | Default | Oracle | 1.0000 | 0.0000 | 2.0000 | NaN |
| 10017 | LongRange | ForestGeometry | Link-delay-aware | 1.0000 | 0.0000 | 2.0000 | NaN |
| 10017 | LongRange | ForestGeometry | Confidence-driven | 1.0000 | 0.0000 | 2.0382 | NaN |
| 10017 | LongRange | ForestGeometry | Oracle | 1.0000 | 0.0000 | 2.0000 | NaN |

## PosDeg_Emerg Significance: Confidence-driven vs Link-delay-aware

| Scene | Config | Metric | Delta Mean | 95% CI | p-value | Significance |
|---|---|---|---:|---:|---:|---|
| 10014 | Default | TimelyRate | 0.0073 | [0.0045, 0.0100] | 0.001341 | ** |
| 10014 | Default | LossRate | -0.0073 | [-0.0100, -0.0045] | 0.001341 | ** |
| 10014 | Default | AvgDelay | 0.0010 | [0.0009, 0.0012] | 0 | *** |
| 10014 | Default | AvgTxCost | 0.1676 | [0.1451, 0.1902] | 0 | *** |
| 10014 | Default | EmgTimely | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10014 | ForestGeometry | TimelyRate | 0.0273 | [0.0226, 0.0319] | 1.126e-12 | *** |
| 10014 | ForestGeometry | LossRate | -0.0318 | [-0.0359, -0.0277] | 0 | *** |
| 10014 | ForestGeometry | AvgDelay | 0.0024 | [0.0022, 0.0026] | 0 | *** |
| 10014 | ForestGeometry | AvgTxCost | 0.4912 | [0.4571, 0.5253] | 0 | *** |
| 10014 | ForestGeometry | EmgTimely | 0.0833 | [0.0287, 0.1379] | 0.06281 | n.s. |
| 10006 | Default | TimelyRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10006 | Default | LossRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10006 | Default | AvgDelay | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10006 | Default | AvgTxCost | 0.3213 | [0.2880, 0.3545] | 0 | *** |
| 10006 | Default | EmgTimely | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10006 | ForestGeometry | TimelyRate | 0.0036 | [0.0018, 0.0054] | 0.01431 | * |
| 10006 | ForestGeometry | LossRate | -0.0036 | [-0.0054, -0.0018] | 0.01431 | * |
| 10006 | ForestGeometry | AvgDelay | 0.0001 | [0.0000, 0.0001] | 0.1009 | n.s. |
| 10006 | ForestGeometry | AvgTxCost | 0.4445 | [0.3890, 0.5001] | 0 | *** |
| 10006 | ForestGeometry | EmgTimely | 0.0036 | [0.0018, 0.0054] | 0.01431 | * |
| 10011 | Default | TimelyRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10011 | Default | LossRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10011 | Default | AvgDelay | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10011 | Default | AvgTxCost | 0.0089 | [-0.0019, 0.0198] | 0.3173 | n.s. |
| 10011 | Default | EmgTimely | NaN | [NaN, NaN] | 1 | n.s. |
| 10011 | ForestGeometry | TimelyRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10011 | ForestGeometry | LossRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10011 | ForestGeometry | AvgDelay | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10011 | ForestGeometry | AvgTxCost | 0.0407 | [0.0176, 0.0638] | 0.03165 | * |
| 10011 | ForestGeometry | EmgTimely | NaN | [NaN, NaN] | 1 | n.s. |
| 10019 | Default | TimelyRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10019 | Default | LossRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10019 | Default | AvgDelay | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10019 | Default | AvgTxCost | 0.9033 | [0.8785, 0.9281] | 0 | *** |
| 10019 | Default | EmgTimely | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10019 | ForestGeometry | TimelyRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10019 | ForestGeometry | LossRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10019 | ForestGeometry | AvgDelay | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10019 | ForestGeometry | AvgTxCost | 0.9355 | [0.9101, 0.9608] | 0 | *** |
| 10019 | ForestGeometry | EmgTimely | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10017 | Default | TimelyRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10017 | Default | LossRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10017 | Default | AvgDelay | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10017 | Default | AvgTxCost | 0.0089 | [-0.0019, 0.0198] | 0.3173 | n.s. |
| 10017 | Default | EmgTimely | NaN | [NaN, NaN] | 1 | n.s. |
| 10017 | ForestGeometry | TimelyRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10017 | ForestGeometry | LossRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10017 | ForestGeometry | AvgDelay | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10017 | ForestGeometry | AvgTxCost | 0.0382 | [0.0145, 0.0619] | 0.04953 | * |
| 10017 | ForestGeometry | EmgTimely | NaN | [NaN, NaN] | 1 | n.s. |

## Recommended Narrative

- The overall gain should be described as a stable but moderate improvement under repeated random realizations.
- The PosDeg\_Emerg results should be emphasized as the main source of method value, especially under forest-geometry calibration.
- The forest-geometry setting should be presented as the more application-relevant evidence for the paper topic.
