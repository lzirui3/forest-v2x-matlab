# Step 25 Literature Baselines Report

This report compares the proposed confidence-driven scheduler against two literature-inspired baselines:
- `DCC-like`: ETSI DCC style congestion-responsive rate control
- `AoI-aware`: Age-of-Information aware priority scheduling

## Overall Mean Summary

| Config | Method | Timely Mean | Loss Mean | Avg Delay Mean | Avg Tx Cost Mean | Emergency Timely Mean |
|---|---|---:|---:|---:|---:|---:|
| Generic | Link-delay-aware | 0.9687 | 0.0313 | 0.0242 | 1.6295 | 1.0000 |
| Generic | DCC-like | 0.9997 | 0.0003 | 0.0330 | 4.4155 | 1.0000 |
| Generic | AoI-aware | 0.9687 | 0.0313 | 0.0247 | 1.7706 | 0.9333 |
| Generic | Confidence-driven | 0.9709 | 0.0291 | 0.0242 | 1.9048 | 1.0000 |
| Generic | Oracle | 0.9930 | 0.0070 | 0.0157 | 1.8903 | 1.0000 |
| ForestParam | Link-delay-aware | 0.9621 | 0.0376 | 0.0360 | 2.2112 | 0.7833 |
| ForestParam | DCC-like | 0.8651 | 0.1348 | 0.0782 | 3.8762 | 0.8000 |
| ForestParam | AoI-aware | 0.9464 | 0.0531 | 0.0392 | 2.3691 | 0.8667 |
| ForestParam | Confidence-driven | 0.9735 | 0.0255 | 0.0345 | 2.5622 | 0.8833 |
| ForestParam | Oracle | 0.9714 | 0.0275 | 0.0360 | 2.5507 | 0.8667 |
| ForestGeometryDemo | Link-delay-aware | 0.8226 | 0.1772 | 0.0919 | 1.8266 | 0.9710 |
| ForestGeometryDemo | DCC-like | 0.7879 | 0.2120 | 0.0986 | 2.3674 | 0.9794 |
| ForestGeometryDemo | AoI-aware | 0.8105 | 0.1892 | 0.0889 | 1.8955 | 0.9664 |
| ForestGeometryDemo | Confidence-driven | 0.8444 | 0.1552 | 0.0871 | 2.1975 | 0.9869 |
| ForestGeometryDemo | Oracle | 0.8571 | 0.1426 | 0.0829 | 2.2575 | 0.9879 |

## PosDeg_Emerg Mean Summary

| Config | Method | Timely Mean | Loss Mean | Avg Delay Mean | Avg Tx Cost Mean | Emergency Timely Mean |
|---|---|---:|---:|---:|---:|---:|
| Generic | Link-delay-aware | 0.9909 | 0.0091 | 0.0121 | 2.0300 | 1.0000 |
| Generic | DCC-like | 1.0000 | 0.0000 | 0.0318 | 5.0969 | 1.0000 |
| Generic | AoI-aware | 0.9882 | 0.0118 | 0.0127 | 2.1604 | 0.9333 |
| Generic | Confidence-driven | 1.0000 | 0.0000 | 0.0136 | 3.2962 | 1.0000 |
| Generic | Oracle | 0.9991 | 0.0009 | 0.0147 | 2.9018 | 1.0000 |
| ForestParam | Link-delay-aware | 0.9591 | 0.0391 | 0.0174 | 2.2227 | 0.7833 |
| ForestParam | DCC-like | 0.9273 | 0.0718 | 0.0315 | 4.5433 | 0.8000 |
| ForestParam | AoI-aware | 0.9300 | 0.0673 | 0.0168 | 2.3636 | 0.8667 |
| ForestParam | Confidence-driven | 0.9891 | 0.0055 | 0.0198 | 3.5407 | 0.8833 |
| ForestParam | Oracle | 0.9882 | 0.0055 | 0.0211 | 3.3953 | 0.8667 |
| ForestGeometryDemo | Link-delay-aware | 0.9209 | 0.0791 | 0.0247 | 3.0001 | 0.9661 |
| ForestGeometryDemo | DCC-like | 0.8245 | 0.1755 | 0.0260 | 3.2913 | 0.9847 |
| ForestGeometryDemo | AoI-aware | 0.8536 | 0.1445 | 0.0223 | 2.3200 | 0.9678 |
| ForestGeometryDemo | Confidence-driven | 0.9755 | 0.0236 | 0.0280 | 3.9410 | 0.9898 |
| ForestGeometryDemo | Oracle | 0.9818 | 0.0173 | 0.0284 | 3.7711 | 0.9932 |

## Confidence-driven vs DCC-like Overall Significance

| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | Delta % | 95% CI | p-value | Holm(all) | Effect(RBC) | Practical |
|---|---|---:|---:|---:|---:|---:|---|---|---:|---|
| Generic | TimelyRate | 0.9997 | 0.9709 | -0.0288 | -2.8785 | [-0.0313, -0.0263] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| Generic | LossRate | 0.0003 | 0.0291 | 0.0288 | 2.8785 | [0.0263, 0.0313] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| Generic | AvgDelay | 0.0330 | 0.0242 | -0.0088 | -26.6351 | [-0.0099, -0.0077] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| Generic | AvgTxCost | 4.4155 | 1.9048 | -2.5107 | -56.8614 | [-2.5231, -2.4983] | p < 2.3e-308 | p < 1e-15 | -1.0000 | SeeDelta |
| Generic | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| ForestParam | TimelyRate | 0.8651 | 0.9735 | 0.1085 | 10.8486 | [0.1059, 0.1110] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| ForestParam | LossRate | 0.1348 | 0.0255 | -0.1093 | -10.9318 | [-0.1119, -0.1067] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| ForestParam | AvgDelay | 0.0782 | 0.0345 | -0.0437 | -55.8938 | [-0.0444, -0.0429] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| ForestParam | AvgTxCost | 3.8762 | 2.5622 | -1.3140 | -33.8996 | [-1.3250, -1.3031] | p < 2.3e-308 | p < 1e-15 | -1.0000 | SeeDelta |
| ForestParam | EmgTimely | 0.8000 | 0.8833 | 0.0833 | 8.3333 | [0.0495, 0.1172] | p = 0.0027 | p = 0.0081 | 1.0000 | Meaningful |
| ForestGeometryDemo | TimelyRate | 0.7879 | 0.8444 | 0.0566 | 5.6572 | [0.0538, 0.0593] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| ForestGeometryDemo | LossRate | 0.2120 | 0.1552 | -0.0567 | -5.6739 | [-0.0594, -0.0540] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| ForestGeometryDemo | AvgDelay | 0.0986 | 0.0871 | -0.0115 | -11.6494 | [-0.0123, -0.0106] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| ForestGeometryDemo | AvgTxCost | 2.3674 | 2.1975 | -0.1698 | -7.1734 | [-0.1807, -0.1590] | p < 2.3e-308 | p < 1e-15 | -1.0000 | SeeDelta |
| ForestGeometryDemo | EmgTimely | 0.9794 | 0.9869 | 0.0075 | 0.7477 | [0.0042, 0.0108] | p = 0.005906 | p = 0.01181 | 0.8056 | Below1pp |

## Confidence-driven vs AoI-aware Overall Significance

| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | Delta % | 95% CI | p-value | Holm(all) | Effect(RBC) | Practical |
|---|---|---:|---:|---:|---:|---:|---|---|---:|---|
| Generic | TimelyRate | 0.9687 | 0.9709 | 0.0022 | 0.2163 | [0.0012, 0.0031] | p = 0.005944 | p = 0.03128 | 0.8611 | Below1pp |
| Generic | LossRate | 0.0313 | 0.0291 | -0.0022 | -0.2163 | [-0.0031, -0.0012] | p = 0.005944 | p = 0.03128 | -0.8611 | Below1pp |
| Generic | AvgDelay | 0.0247 | 0.0242 | -0.0004 | -1.7530 | [-0.0006, -0.0002] | p = 0.005213 | p = 0.03128 | -0.7455 | Sub-ms |
| Generic | AvgTxCost | 1.7706 | 1.9048 | 0.1341 | 7.5749 | [0.1218, 0.1465] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| Generic | EmgTimely | 0.9333 | 1.0000 | 0.0667 | 6.6667 | [0.0335, 0.0998] | p = 0.01431 | p = 0.04292 | 1.0000 | Meaningful |
| ForestParam | TimelyRate | 0.9464 | 0.9735 | 0.0271 | 2.7121 | [0.0245, 0.0298] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| ForestParam | LossRate | 0.0531 | 0.0255 | -0.0276 | -2.7621 | [-0.0302, -0.0251] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| ForestParam | AvgDelay | 0.0392 | 0.0345 | -0.0047 | -11.9967 | [-0.0056, -0.0038] | p = 8.980e-10 | p = 6.286e-09 | -1.0000 | Meaningful |
| ForestParam | AvgTxCost | 2.3691 | 2.5622 | 0.1931 | 8.1499 | [0.1822, 0.2040] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| ForestParam | EmgTimely | 0.8667 | 0.8833 | 0.0167 | 1.6667 | [-0.0036, 0.0370] | p = 0.3173 | p = 0.3173 | 1.0000 | Meaningful |
| ForestGeometryDemo | TimelyRate | 0.8105 | 0.8444 | 0.0339 | 3.3943 | [0.0312, 0.0367] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| ForestGeometryDemo | LossRate | 0.1892 | 0.1552 | -0.0339 | -3.3943 | [-0.0367, -0.0311] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| ForestGeometryDemo | AvgDelay | 0.0889 | 0.0871 | -0.0018 | -2.0221 | [-0.0028, -0.0008] | p = 0.02855 | p = 0.0571 | -0.6000 | Meaningful |
| ForestGeometryDemo | AvgTxCost | 1.8955 | 2.1975 | 0.3021 | 15.9359 | [0.2912, 0.3129] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| ForestGeometryDemo | EmgTimely | 0.9664 | 0.9869 | 0.0206 | 2.0561 | [0.0183, 0.0228] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |

## Confidence-driven vs DCC-like PosDeg_Emerg Significance

| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | Delta % | 95% CI | p-value | Holm(all) | Effect(RBC) | Practical |
|---|---|---:|---:|---:|---:|---:|---|---|---:|---|
| Generic | TimelyRate | 1.0000 | 1.0000 | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| Generic | LossRate | 0.0000 | 0.0000 | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| Generic | AvgDelay | 0.0318 | 0.0136 | -0.0182 | -57.2676 | [-0.0184, -0.0180] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| Generic | AvgTxCost | 5.0969 | 3.2962 | -1.8007 | -35.3294 | [-1.8498, -1.7516] | p < 2.3e-308 | p < 1e-15 | -1.0000 | SeeDelta |
| Generic | EmgTimely | 1.0000 | 1.0000 | 0.0000 | 0.0000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.0000 | Below1pp |
| ForestParam | TimelyRate | 0.9273 | 0.9891 | 0.0618 | 6.1818 | [0.0572, 0.0664] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| ForestParam | LossRate | 0.0718 | 0.0055 | -0.0664 | -6.6364 | [-0.0716, -0.0611] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| ForestParam | AvgDelay | 0.0315 | 0.0198 | -0.0117 | -37.2675 | [-0.0121, -0.0114] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| ForestParam | AvgTxCost | 4.5433 | 3.5407 | -1.0026 | -22.0678 | [-1.0528, -0.9524] | p < 2.3e-308 | p < 1e-15 | -1.0000 | SeeDelta |
| ForestParam | EmgTimely | 0.8000 | 0.8833 | 0.0833 | 8.3333 | [0.0495, 0.1172] | p = 0.0027 | p = 0.0135 | 1.0000 | Meaningful |
| ForestGeometryDemo | TimelyRate | 0.8245 | 0.9755 | 0.1509 | 15.0909 | [0.1391, 0.1627] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| ForestGeometryDemo | LossRate | 0.1755 | 0.0236 | -0.1518 | -15.1818 | [-0.1630, -0.1406] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| ForestGeometryDemo | AvgDelay | 0.0260 | 0.0280 | 0.0021 | 7.9331 | [0.0017, 0.0024] | p = 1.742e-11 | p = 1.045e-10 | 1.0000 | Meaningful |
| ForestGeometryDemo | AvgTxCost | 3.2913 | 3.9410 | 0.6498 | 19.7420 | [0.6315, 0.6681] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| ForestGeometryDemo | EmgTimely | 0.9847 | 0.9898 | 0.0051 | 0.5085 | [-0.0025, 0.0127] | p = 0.4133 | p = 1 | 0.3571 | Below1pp |

## Confidence-driven vs AoI-aware PosDeg_Emerg Significance

| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | Delta % | 95% CI | p-value | Holm(all) | Effect(RBC) | Practical |
|---|---|---:|---:|---:|---:|---:|---|---|---:|---|
| Generic | TimelyRate | 0.9882 | 1.0000 | 0.0118 | 1.1818 | [0.0089, 0.0147] | p = 5.941e-07 | p = 2.970e-06 | 1.0000 | Meaningful |
| Generic | LossRate | 0.0118 | 0.0000 | -0.0118 | -1.1818 | [-0.0147, -0.0089] | p = 5.941e-07 | p = 2.970e-06 | -1.0000 | Meaningful |
| Generic | AvgDelay | 0.0127 | 0.0136 | 0.0009 | 6.8578 | [0.0007, 0.0011] | p = 1.834e-08 | p = 1.100e-07 | 1.0000 | Sub-ms |
| Generic | AvgTxCost | 2.1604 | 3.2962 | 1.1358 | 52.5762 | [1.0868, 1.1849] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| Generic | EmgTimely | 0.9333 | 1.0000 | 0.0667 | 6.6667 | [0.0335, 0.0998] | p = 0.01431 | p = 0.02861 | 1.0000 | Meaningful |
| ForestParam | TimelyRate | 0.9300 | 0.9891 | 0.0591 | 5.9091 | [0.0557, 0.0625] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| ForestParam | LossRate | 0.0673 | 0.0055 | -0.0618 | -6.1818 | [-0.0664, -0.0572] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| ForestParam | AvgDelay | 0.0168 | 0.0198 | 0.0030 | 17.9431 | [0.0027, 0.0033] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| ForestParam | AvgTxCost | 2.3636 | 3.5407 | 1.1770 | 49.7977 | [1.1268, 1.2273] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| ForestParam | EmgTimely | 0.8667 | 0.8833 | 0.0167 | 1.6667 | [-0.0036, 0.0370] | p = 0.3173 | p = 0.3173 | 1.0000 | Meaningful |
| ForestGeometryDemo | TimelyRate | 0.8536 | 0.9755 | 0.1218 | 12.1818 | [0.1113, 0.1323] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| ForestGeometryDemo | LossRate | 0.1445 | 0.0236 | -0.1209 | -12.0909 | [-0.1317, -0.1101] | p < 2.3e-308 | p < 1e-15 | -1.0000 | Meaningful |
| ForestGeometryDemo | AvgDelay | 0.0223 | 0.0280 | 0.0057 | 25.3991 | [0.0053, 0.0060] | p < 2.3e-308 | p < 1e-15 | 1.0000 | Meaningful |
| ForestGeometryDemo | AvgTxCost | 2.3200 | 3.9410 | 1.6210 | 69.8723 | [1.6027, 1.6393] | p < 2.3e-308 | p < 1e-15 | 1.0000 | SeeDelta |
| ForestGeometryDemo | EmgTimely | 0.9678 | 0.9898 | 0.0220 | 2.2034 | [0.0167, 0.0274] | p = 5.941e-07 | p = 2.970e-06 | 1.0000 | Meaningful |

## Interpretation

- If the confidence-driven scheduler still dominates DCC-like and AoI-aware baselines in the harder forest-relevant scenes, the lack of literature baselines is no longer a critical weakness.
- DCC-like should be interpreted as a communication-standard baseline focused on congestion control rather than blind-zone awareness.
- AoI-aware should be interpreted as a freshness-driven scheduling baseline that ignores cooperative positioning uncertainty.
- Rows marked `Below1pp` or `Sub-ms` should be discussed as statistically detectable but potentially weak in engineering significance.
