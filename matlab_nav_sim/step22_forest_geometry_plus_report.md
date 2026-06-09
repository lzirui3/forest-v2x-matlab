# Step 22 Forest Geometry Plus Report

This report compares `ForestGeometry` and `ForestGeometryPlus` on representative forest scenarios.
- Profiles: `Blind`, `Curved`, `Straight`
- Variants: `Base` vs `Plus`
- Main comparison: `Confidence-driven` vs `Link-delay-aware`

## Overall Mean Summary

| Config | Profile | Vegetation | Variant | Method | Timely Mean | Loss Mean | Avg Delay Mean | Avg Tx Cost Mean | Emergency Timely Mean |
|---|---|---|---|---|---:|---:|---:|---:|---:|
| FG_Blind_Medium_Base | Blind | Medium | Base | Link-delay-aware | 0.8226 | 0.1772 | 0.0919 | 1.8266 | 0.9710 |
| FG_Blind_Medium_Base | Blind | Medium | Base | Confidence-driven | 0.8444 | 0.1552 | 0.0871 | 2.1975 | 0.9869 |
| FG_Blind_Medium_Base | Blind | Medium | Base | Oracle | 0.8571 | 0.1426 | 0.0829 | 2.2575 | 0.9879 |
| FG_Blind_Medium_Plus | Blind | Medium | Plus | Link-delay-aware | 0.8156 | 0.1822 | 0.0941 | 1.9252 | 0.9692 |
| FG_Blind_Medium_Plus | Blind | Medium | Plus | Confidence-driven | 0.8253 | 0.1720 | 0.0916 | 2.1947 | 0.9729 |
| FG_Blind_Medium_Plus | Blind | Medium | Plus | Oracle | 0.8354 | 0.1617 | 0.0886 | 2.2654 | 0.9757 |
| FG_Curved_Dense_Base | Curved | Dense | Base | Link-delay-aware | 0.8038 | 0.1948 | 0.1011 | 1.6109 | 0.8841 |
| FG_Curved_Dense_Base | Curved | Dense | Base | Confidence-driven | 0.8261 | 0.1699 | 0.0963 | 1.9981 | 0.9364 |
| FG_Curved_Dense_Base | Curved | Dense | Base | Oracle | 0.8418 | 0.1526 | 0.0913 | 2.1842 | 0.9514 |
| FG_Curved_Dense_Plus | Curved | Dense | Plus | Link-delay-aware | 0.9411 | 0.0379 | 0.0210 | 2.0957 | 0.8121 |
| FG_Curved_Dense_Plus | Curved | Dense | Plus | Confidence-driven | 0.9542 | 0.0176 | 0.0207 | 2.3581 | 0.8465 |
| FG_Curved_Dense_Plus | Curved | Dense | Plus | Oracle | 0.9536 | 0.0158 | 0.0208 | 2.3257 | 0.8432 |
| FG_Straight_Sparse_Base | Straight | Sparse | Base | Link-delay-aware | 0.9908 | 0.0092 | 0.0166 | 1.5529 | 0.9991 |
| FG_Straight_Sparse_Base | Straight | Sparse | Base | Confidence-driven | 0.9918 | 0.0082 | 0.0162 | 1.6828 | 0.9991 |
| FG_Straight_Sparse_Base | Straight | Sparse | Base | Oracle | 0.9935 | 0.0065 | 0.0155 | 1.5916 | 0.9991 |
| FG_Straight_Sparse_Plus | Straight | Sparse | Plus | Link-delay-aware | 0.9411 | 0.0379 | 0.0210 | 2.0957 | 0.8121 |
| FG_Straight_Sparse_Plus | Straight | Sparse | Plus | Confidence-driven | 0.9542 | 0.0176 | 0.0207 | 2.3581 | 0.8465 |
| FG_Straight_Sparse_Plus | Straight | Sparse | Plus | Oracle | 0.9536 | 0.0158 | 0.0208 | 2.3257 | 0.8432 |

## PosDeg_Emerg Mean Summary

| Config | Profile | Vegetation | Variant | Method | Timely Mean | Loss Mean | Avg Delay Mean | Avg Tx Cost Mean | Emergency Timely Mean |
|---|---|---|---|---|---:|---:|---:|---:|---:|
| FG_Blind_Medium_Base | Blind | Medium | Base | Link-delay-aware | 0.9209 | 0.0791 | 0.0247 | 3.0001 | 0.9661 |
| FG_Blind_Medium_Base | Blind | Medium | Base | Confidence-driven | 0.9755 | 0.0236 | 0.0280 | 3.9410 | 0.9898 |
| FG_Blind_Medium_Base | Blind | Medium | Base | Oracle | 0.9818 | 0.0173 | 0.0284 | 3.7711 | 0.9932 |
| FG_Blind_Medium_Plus | Blind | Medium | Plus | Link-delay-aware | 0.9400 | 0.0500 | 0.0304 | 3.6783 | 0.9678 |
| FG_Blind_Medium_Plus | Blind | Medium | Plus | Confidence-driven | 0.9500 | 0.0382 | 0.0306 | 4.0381 | 0.9712 |
| FG_Blind_Medium_Plus | Blind | Medium | Plus | Oracle | 0.9527 | 0.0355 | 0.0309 | 3.8455 | 0.9763 |
| FG_Curved_Dense_Base | Curved | Dense | Base | Link-delay-aware | 0.9182 | 0.0791 | 0.0232 | 2.5014 | 0.8472 |
| FG_Curved_Dense_Base | Curved | Dense | Base | Confidence-driven | 0.9555 | 0.0327 | 0.0254 | 2.9275 | 0.9189 |
| FG_Curved_Dense_Base | Curved | Dense | Base | Oracle | 0.9664 | 0.0118 | 0.0276 | 3.2366 | 0.9396 |
| FG_Curved_Dense_Plus | Curved | Dense | Plus | Link-delay-aware | 0.7182 | 0.1700 | 0.0468 | 3.2693 | 0.7142 |
| FG_Curved_Dense_Plus | Curved | Dense | Plus | Confidence-driven | 0.7673 | 0.0827 | 0.0505 | 4.2176 | 0.7600 |
| FG_Curved_Dense_Plus | Curved | Dense | Plus | Oracle | 0.7618 | 0.0745 | 0.0511 | 4.2619 | 0.7545 |
| FG_Straight_Sparse_Base | Straight | Sparse | Base | Link-delay-aware | 0.9991 | 0.0009 | 0.0123 | 2.2150 | 0.9977 |
| FG_Straight_Sparse_Base | Straight | Sparse | Base | Confidence-driven | 0.9991 | 0.0009 | 0.0123 | 2.4493 | 0.9977 |
| FG_Straight_Sparse_Base | Straight | Sparse | Base | Oracle | 0.9991 | 0.0009 | 0.0123 | 2.2224 | 0.9977 |
| FG_Straight_Sparse_Plus | Straight | Sparse | Plus | Link-delay-aware | 0.7182 | 0.1700 | 0.0468 | 3.2693 | 0.7142 |
| FG_Straight_Sparse_Plus | Straight | Sparse | Plus | Confidence-driven | 0.7673 | 0.0827 | 0.0505 | 4.2176 | 0.7600 |
| FG_Straight_Sparse_Plus | Straight | Sparse | Plus | Oracle | 0.7618 | 0.0745 | 0.0511 | 4.2619 | 0.7545 |

## Confidence-driven vs Link-delay-aware Overall Significance

| Config | Profile | Vegetation | Variant | Metric | Baseline Mean | Proposed Mean | Delta Mean | 95% CI | p-value | Significance |
|---|---|---|---|---|---:|---:|---:|---:|---:|---|
| FG_Blind_Medium_Base | Blind | Medium | Base | TimelyRate | 0.8226 | 0.8444 | 0.0218 | [0.0192, 0.0244] | 0 | *** |
| FG_Blind_Medium_Base | Blind | Medium | Base | LossRate | 0.1772 | 0.1552 | -0.0220 | [-0.0245, -0.0195] | 0 | *** |
| FG_Blind_Medium_Base | Blind | Medium | Base | AvgDelay | 0.0919 | 0.0871 | -0.0048 | [-0.0056, -0.0040] | 4.818e-13 | *** |
| FG_Blind_Medium_Base | Blind | Medium | Base | AvgTxCost | 1.8266 | 2.1975 | 0.3710 | [0.3601, 0.3818] | 0 | *** |
| FG_Blind_Medium_Base | Blind | Medium | Base | EmgTimely | 0.9710 | 0.9869 | 0.0159 | [0.0125, 0.0193] | 1.46e-08 | *** |
| FG_Blind_Medium_Plus | Blind | Medium | Plus | TimelyRate | 0.8156 | 0.8253 | 0.0097 | [0.0083, 0.0110] | 0 | *** |
| FG_Blind_Medium_Plus | Blind | Medium | Plus | LossRate | 0.1822 | 0.1720 | -0.0101 | [-0.0117, -0.0086] | 1.776e-15 | *** |
| FG_Blind_Medium_Plus | Blind | Medium | Plus | AvgDelay | 0.0941 | 0.0916 | -0.0024 | [-0.0029, -0.0019] | 5.654e-10 | *** |
| FG_Blind_Medium_Plus | Blind | Medium | Plus | AvgTxCost | 1.9252 | 2.1947 | 0.2696 | [0.2603, 0.2788] | 0 | *** |
| FG_Blind_Medium_Plus | Blind | Medium | Plus | EmgTimely | 0.9692 | 0.9729 | 0.0037 | [0.0019, 0.0056] | 0.01431 | * |
| FG_Curved_Dense_Base | Curved | Dense | Base | TimelyRate | 0.8038 | 0.8261 | 0.0223 | [0.0196, 0.0250] | 0 | *** |
| FG_Curved_Dense_Base | Curved | Dense | Base | LossRate | 0.1948 | 0.1699 | -0.0250 | [-0.0280, -0.0219] | 0 | *** |
| FG_Curved_Dense_Base | Curved | Dense | Base | AvgDelay | 0.1011 | 0.0963 | -0.0048 | [-0.0056, -0.0041] | 3.553e-15 | *** |
| FG_Curved_Dense_Base | Curved | Dense | Base | AvgTxCost | 1.6109 | 1.9981 | 0.3872 | [0.3642, 0.4103] | 0 | *** |
| FG_Curved_Dense_Base | Curved | Dense | Base | EmgTimely | 0.8841 | 0.9364 | 0.0523 | [0.0400, 0.0647] | 2.604e-07 | *** |
| FG_Curved_Dense_Plus | Curved | Dense | Plus | TimelyRate | 0.9411 | 0.9542 | 0.0131 | [0.0100, 0.0163] | 4.079e-07 | *** |
| FG_Curved_Dense_Plus | Curved | Dense | Plus | LossRate | 0.0379 | 0.0176 | -0.0203 | [-0.0239, -0.0167] | 3.766e-12 | *** |
| FG_Curved_Dense_Plus | Curved | Dense | Plus | AvgDelay | 0.0210 | 0.0207 | -0.0003 | [-0.0006, -0.0000] | 0.2067 | n.s. |
| FG_Curved_Dense_Plus | Curved | Dense | Plus | AvgTxCost | 2.0957 | 2.3581 | 0.2624 | [0.2486, 0.2762] | 0 | *** |
| FG_Curved_Dense_Plus | Curved | Dense | Plus | EmgTimely | 0.8121 | 0.8465 | 0.0344 | [0.0264, 0.0425] | 1.625e-07 | *** |
| FG_Straight_Sparse_Base | Straight | Sparse | Base | TimelyRate | 0.9908 | 0.9918 | 0.0010 | [0.0005, 0.0015] | 0.02445 | * |
| FG_Straight_Sparse_Base | Straight | Sparse | Base | LossRate | 0.0092 | 0.0082 | -0.0010 | [-0.0015, -0.0005] | 0.02445 | * |
| FG_Straight_Sparse_Base | Straight | Sparse | Base | AvgDelay | 0.0166 | 0.0162 | -0.0004 | [-0.0006, -0.0002] | 0.0389 | * |
| FG_Straight_Sparse_Base | Straight | Sparse | Base | AvgTxCost | 1.5529 | 1.6828 | 0.1298 | [0.1223, 0.1373] | 0 | *** |
| FG_Straight_Sparse_Base | Straight | Sparse | Base | EmgTimely | 0.9991 | 0.9991 | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| FG_Straight_Sparse_Plus | Straight | Sparse | Plus | TimelyRate | 0.9411 | 0.9542 | 0.0131 | [0.0100, 0.0163] | 4.079e-07 | *** |
| FG_Straight_Sparse_Plus | Straight | Sparse | Plus | LossRate | 0.0379 | 0.0176 | -0.0203 | [-0.0239, -0.0167] | 3.766e-12 | *** |
| FG_Straight_Sparse_Plus | Straight | Sparse | Plus | AvgDelay | 0.0210 | 0.0207 | -0.0003 | [-0.0006, -0.0000] | 0.2067 | n.s. |
| FG_Straight_Sparse_Plus | Straight | Sparse | Plus | AvgTxCost | 2.0957 | 2.3581 | 0.2624 | [0.2486, 0.2762] | 0 | *** |
| FG_Straight_Sparse_Plus | Straight | Sparse | Plus | EmgTimely | 0.8121 | 0.8465 | 0.0344 | [0.0264, 0.0425] | 1.625e-07 | *** |

## Confidence-driven vs Link-delay-aware PosDeg_Emerg Significance

| Config | Profile | Vegetation | Variant | Metric | Baseline Mean | Proposed Mean | Delta Mean | 95% CI | p-value | Significance |
|---|---|---|---|---|---:|---:|---:|---:|---:|---|
| FG_Blind_Medium_Base | Blind | Medium | Base | TimelyRate | 0.9209 | 0.9755 | 0.0545 | [0.0463, 0.0628] | 8.882e-16 | *** |
| FG_Blind_Medium_Base | Blind | Medium | Base | LossRate | 0.0791 | 0.0236 | -0.0555 | [-0.0633, -0.0476] | 0 | *** |
| FG_Blind_Medium_Base | Blind | Medium | Base | AvgDelay | 0.0247 | 0.0280 | 0.0033 | [0.0030, 0.0036] | 0 | *** |
| FG_Blind_Medium_Base | Blind | Medium | Base | AvgTxCost | 3.0001 | 3.9410 | 0.9409 | [0.9226, 0.9592] | 0 | *** |
| FG_Blind_Medium_Base | Blind | Medium | Base | EmgTimely | 0.9661 | 0.9898 | 0.0237 | [0.0174, 0.0300] | 4.597e-06 | *** |
| FG_Blind_Medium_Plus | Blind | Medium | Plus | TimelyRate | 0.9400 | 0.9500 | 0.0100 | [0.0074, 0.0126] | 2.428e-06 | *** |
| FG_Blind_Medium_Plus | Blind | Medium | Plus | LossRate | 0.0500 | 0.0382 | -0.0118 | [-0.0147, -0.0089] | 5.941e-07 | *** |
| FG_Blind_Medium_Plus | Blind | Medium | Plus | AvgDelay | 0.0304 | 0.0306 | 0.0003 | [0.0001, 0.0004] | 0.01064 | * |
| FG_Blind_Medium_Plus | Blind | Medium | Plus | AvgTxCost | 3.6783 | 4.0381 | 0.3599 | [0.3449, 0.3748] | 0 | *** |
| FG_Blind_Medium_Plus | Blind | Medium | Plus | EmgTimely | 0.9678 | 0.9712 | 0.0034 | [0.0006, 0.0061] | 0.1336 | n.s. |
| FG_Curved_Dense_Base | Curved | Dense | Base | TimelyRate | 0.9182 | 0.9555 | 0.0373 | [0.0291, 0.0454] | 2.67e-08 | *** |
| FG_Curved_Dense_Base | Curved | Dense | Base | LossRate | 0.0791 | 0.0327 | -0.0464 | [-0.0569, -0.0359] | 7.499e-08 | *** |
| FG_Curved_Dense_Base | Curved | Dense | Base | AvgDelay | 0.0232 | 0.0254 | 0.0023 | [0.0017, 0.0029] | 5.99e-06 | *** |
| FG_Curved_Dense_Base | Curved | Dense | Base | AvgTxCost | 2.5014 | 2.9275 | 0.4261 | [0.3939, 0.4583] | 0 | *** |
| FG_Curved_Dense_Base | Curved | Dense | Base | EmgTimely | 0.8472 | 0.9189 | 0.0717 | [0.0561, 0.0873] | 2.286e-08 | *** |
| FG_Curved_Dense_Plus | Curved | Dense | Plus | TimelyRate | 0.7182 | 0.7673 | 0.0491 | [0.0361, 0.0621] | 4.372e-06 | *** |
| FG_Curved_Dense_Plus | Curved | Dense | Plus | LossRate | 0.1700 | 0.0827 | -0.0873 | [-0.1005, -0.0740] | 8.882e-16 | *** |
| FG_Curved_Dense_Plus | Curved | Dense | Plus | AvgDelay | 0.0468 | 0.0505 | 0.0036 | [0.0033, 0.0040] | 0 | *** |
| FG_Curved_Dense_Plus | Curved | Dense | Plus | AvgTxCost | 3.2693 | 4.2176 | 0.9483 | [0.9027, 0.9939] | 0 | *** |
| FG_Curved_Dense_Plus | Curved | Dense | Plus | EmgTimely | 0.7142 | 0.7600 | 0.0457 | [0.0330, 0.0585] | 1.307e-05 | *** |
| FG_Straight_Sparse_Base | Straight | Sparse | Base | TimelyRate | 0.9991 | 0.9991 | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| FG_Straight_Sparse_Base | Straight | Sparse | Base | LossRate | 0.0009 | 0.0009 | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| FG_Straight_Sparse_Base | Straight | Sparse | Base | AvgDelay | 0.0123 | 0.0123 | -0.0000 | [-0.0000, 0.0000] | 0.3173 | n.s. |
| FG_Straight_Sparse_Base | Straight | Sparse | Base | AvgTxCost | 2.2150 | 2.4493 | 0.2343 | [0.2325, 0.2360] | 0 | *** |
| FG_Straight_Sparse_Base | Straight | Sparse | Base | EmgTimely | 0.9977 | 0.9977 | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| FG_Straight_Sparse_Plus | Straight | Sparse | Plus | TimelyRate | 0.7182 | 0.7673 | 0.0491 | [0.0361, 0.0621] | 4.372e-06 | *** |
| FG_Straight_Sparse_Plus | Straight | Sparse | Plus | LossRate | 0.1700 | 0.0827 | -0.0873 | [-0.1005, -0.0740] | 8.882e-16 | *** |
| FG_Straight_Sparse_Plus | Straight | Sparse | Plus | AvgDelay | 0.0468 | 0.0505 | 0.0036 | [0.0033, 0.0040] | 0 | *** |
| FG_Straight_Sparse_Plus | Straight | Sparse | Plus | AvgTxCost | 3.2693 | 4.2176 | 0.9483 | [0.9027, 0.9939] | 0 | *** |
| FG_Straight_Sparse_Plus | Straight | Sparse | Plus | EmgTimely | 0.7142 | 0.7600 | 0.0457 | [0.0330, 0.0585] | 1.307e-05 | *** |

## Interpretation

- If the `Plus` variant consistently reduces TimelyRate and increases LossRate, vegetation attenuation is making the scene more realistic/harder.
- If method ordering remains stable under `Plus`, the realism augmentation strengthens credibility without overturning the scheduling conclusion.
- If gains collapse only in selected representative scenarios, the `Plus` branch should be reported as a realism stress test rather than a replacement of the mainline result.
