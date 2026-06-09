# Step 21 Forest Geometry Matrix Report

This report summarizes the 3x3 forest geometry matrix:
- Profiles: `straight`, `curved`, `blind`
- Vegetation: `sparse`, `medium`, `dense`
- Main comparison: `Confidence-driven` vs `Link-delay-aware`

## Overall Mean Summary

| Config | Profile | Vegetation | Method | Timely Mean | Loss Mean | Avg Delay Mean | Avg Tx Cost Mean | Emergency Timely Mean |
|---|---|---|---|---:|---:|---:|---:|---:|
| FG_blind_medium | blind | medium | Link-delay-aware | 0.8226 | 0.1772 | 0.0919 | 1.8266 | 0.9710 |
| FG_blind_medium | blind | medium | Confidence-driven | 0.8444 | 0.1552 | 0.0871 | 2.1975 | 0.9869 |
| FG_blind_medium | blind | medium | Oracle | 0.8571 | 0.1426 | 0.0829 | 2.2575 | 0.9879 |
| FG_blind_sparse | blind | sparse | Link-delay-aware | 0.9739 | 0.0260 | 0.0219 | 1.6677 | 0.9869 |
| FG_blind_sparse | blind | sparse | Confidence-driven | 0.9774 | 0.0225 | 0.0213 | 1.8544 | 0.9916 |
| FG_blind_sparse | blind | sparse | Oracle | 0.9810 | 0.0186 | 0.0204 | 1.8035 | 0.9907 |
| FG_curved_dense | curved | dense | Link-delay-aware | 0.8205 | 0.1792 | 0.0957 | 1.5957 | 0.9327 |
| FG_curved_dense | curved | dense | Confidence-driven | 0.8516 | 0.1479 | 0.0870 | 1.9521 | 0.9776 |
| FG_curved_dense | curved | dense | Oracle | 0.8714 | 0.1281 | 0.0789 | 2.0568 | 0.9748 |
| FG_curved_medium | curved | medium | Link-delay-aware | 0.8755 | 0.1243 | 0.0702 | 1.5696 | 0.9626 |
| FG_curved_medium | curved | medium | Confidence-driven | 0.8935 | 0.1063 | 0.0653 | 1.8273 | 0.9860 |
| FG_curved_medium | curved | medium | Oracle | 0.9121 | 0.0877 | 0.0581 | 1.9098 | 0.9907 |
| FG_curved_sparse | curved | sparse | Link-delay-aware | 0.9745 | 0.0255 | 0.0235 | 1.5581 | 0.9907 |
| FG_curved_sparse | curved | sparse | Confidence-driven | 0.9785 | 0.0215 | 0.0228 | 1.7144 | 0.9935 |
| FG_curved_sparse | curved | sparse | Oracle | 0.9834 | 0.0166 | 0.0212 | 1.6822 | 0.9991 |
| FG_straight_dense | straight | dense | Link-delay-aware | 0.9040 | 0.0960 | 0.0658 | 1.8829 | 0.9935 |
| FG_straight_dense | straight | dense | Confidence-driven | 0.9171 | 0.0829 | 0.0609 | 2.0791 | 0.9991 |
| FG_straight_dense | straight | dense | Oracle | 0.9363 | 0.0637 | 0.0528 | 2.0936 | 0.9935 |
| FG_straight_medium | straight | medium | Link-delay-aware | 0.9681 | 0.0319 | 0.0312 | 1.7288 | 0.9981 |
| FG_straight_medium | straight | medium | Confidence-driven | 0.9691 | 0.0309 | 0.0310 | 1.8659 | 1.0000 |
| FG_straight_medium | straight | medium | Oracle | 0.9717 | 0.0283 | 0.0298 | 1.7864 | 0.9981 |
| FG_straight_sparse | straight | sparse | Link-delay-aware | 0.9950 | 0.0050 | 0.0148 | 1.5686 | 0.9991 |
| FG_straight_sparse | straight | sparse | Confidence-driven | 0.9957 | 0.0043 | 0.0146 | 1.6958 | 1.0000 |
| FG_straight_sparse | straight | sparse | Oracle | 0.9957 | 0.0043 | 0.0145 | 1.5941 | 0.9991 |

## PosDeg_Emerg Mean Summary

| Config | Profile | Vegetation | Method | Timely Mean | Loss Mean | Avg Delay Mean | Avg Tx Cost Mean | Emergency Timely Mean |
|---|---|---|---|---:|---:|---:|---:|---:|
| FG_blind_medium | blind | medium | Link-delay-aware | 0.9209 | 0.0791 | 0.0247 | 3.0001 | 0.9661 |
| FG_blind_medium | blind | medium | Confidence-driven | 0.9755 | 0.0236 | 0.0280 | 3.9410 | 0.9898 |
| FG_blind_medium | blind | medium | Oracle | 0.9818 | 0.0173 | 0.0284 | 3.7711 | 0.9932 |
| FG_blind_sparse | blind | sparse | Link-delay-aware | 0.9936 | 0.0064 | 0.0141 | 2.4072 | 0.9949 |
| FG_blind_sparse | blind | sparse | Confidence-driven | 0.9964 | 0.0036 | 0.0144 | 2.8694 | 0.9983 |
| FG_blind_sparse | blind | sparse | Oracle | 0.9964 | 0.0027 | 0.0147 | 2.6173 | 0.9983 |
| FG_curved_dense | curved | dense | Link-delay-aware | 0.9436 | 0.0555 | 0.0182 | 2.3150 | 0.9151 |
| FG_curved_dense | curved | dense | Confidence-driven | 0.9855 | 0.0136 | 0.0202 | 2.7760 | 0.9717 |
| FG_curved_dense | curved | dense | Oracle | 0.9855 | 0.0136 | 0.0199 | 2.6871 | 0.9698 |
| FG_curved_medium | curved | medium | Link-delay-aware | 0.9609 | 0.0382 | 0.0159 | 2.3086 | 0.9491 |
| FG_curved_medium | curved | medium | Confidence-driven | 0.9873 | 0.0118 | 0.0171 | 2.6926 | 0.9774 |
| FG_curved_medium | curved | medium | Oracle | 0.9909 | 0.0082 | 0.0174 | 2.6089 | 0.9811 |
| FG_curved_sparse | curved | sparse | Link-delay-aware | 0.9909 | 0.0091 | 0.0132 | 2.2841 | 0.9943 |
| FG_curved_sparse | curved | sparse | Confidence-driven | 0.9964 | 0.0036 | 0.0133 | 2.5929 | 0.9962 |
| FG_curved_sparse | curved | sparse | Oracle | 0.9991 | 0.0009 | 0.0137 | 2.4225 | 0.9981 |
| FG_straight_dense | straight | dense | Link-delay-aware | 0.9909 | 0.0091 | 0.0128 | 2.2150 | 0.9860 |
| FG_straight_dense | straight | dense | Confidence-driven | 0.9991 | 0.0009 | 0.0130 | 2.4695 | 0.9977 |
| FG_straight_dense | straight | dense | Oracle | 0.9945 | 0.0055 | 0.0129 | 2.2414 | 0.9860 |
| FG_straight_medium | straight | medium | Link-delay-aware | 0.9991 | 0.0009 | 0.0123 | 2.2150 | 0.9977 |
| FG_straight_medium | straight | medium | Confidence-driven | 1.0000 | 0.0000 | 0.0123 | 2.4518 | 1.0000 |
| FG_straight_medium | straight | medium | Oracle | 0.9991 | 0.0009 | 0.0123 | 2.2188 | 0.9977 |
| FG_straight_sparse | straight | sparse | Link-delay-aware | 0.9991 | 0.0009 | 0.0121 | 2.2150 | 0.9977 |
| FG_straight_sparse | straight | sparse | Confidence-driven | 1.0000 | 0.0000 | 0.0122 | 2.4492 | 1.0000 |
| FG_straight_sparse | straight | sparse | Oracle | 0.9991 | 0.0009 | 0.0121 | 2.2163 | 0.9977 |

## Confidence-driven vs Link-delay-aware Overall Significance

| Config | Profile | Vegetation | Metric | Baseline Mean | Proposed Mean | Delta Mean | 95% CI | p-value | Significance |
|---|---|---|---|---:|---:|---:|---:|---:|---|
| FG_blind_medium | blind | medium | TimelyRate | 0.8226 | 0.8444 | 0.0218 | [0.0192, 0.0244] | 0 | *** |
| FG_blind_medium | blind | medium | LossRate | 0.1772 | 0.1552 | -0.0220 | [-0.0245, -0.0195] | 0 | *** |
| FG_blind_medium | blind | medium | AvgDelay | 0.0919 | 0.0871 | -0.0048 | [-0.0056, -0.0040] | 4.818e-13 | *** |
| FG_blind_medium | blind | medium | AvgTxCost | 1.8266 | 2.1975 | 0.3710 | [0.3601, 0.3818] | 0 | *** |
| FG_blind_medium | blind | medium | EmgTimely | 0.9710 | 0.9869 | 0.0159 | [0.0125, 0.0193] | 1.46e-08 | *** |
| FG_blind_sparse | blind | sparse | TimelyRate | 0.9739 | 0.9774 | 0.0035 | [0.0025, 0.0045] | 1.315e-05 | *** |
| FG_blind_sparse | blind | sparse | LossRate | 0.0260 | 0.0225 | -0.0035 | [-0.0045, -0.0025] | 1.315e-05 | *** |
| FG_blind_sparse | blind | sparse | AvgDelay | 0.0219 | 0.0213 | -0.0006 | [-0.0008, -0.0003] | 0.002523 | ** |
| FG_blind_sparse | blind | sparse | AvgTxCost | 1.6677 | 1.8544 | 0.1868 | [0.1804, 0.1932] | 0 | *** |
| FG_blind_sparse | blind | sparse | EmgTimely | 0.9869 | 0.9916 | 0.0047 | [0.0028, 0.0066] | 0.0027 | ** |
| FG_curved_dense | curved | dense | TimelyRate | 0.8205 | 0.8516 | 0.0311 | [0.0298, 0.0325] | 0 | *** |
| FG_curved_dense | curved | dense | LossRate | 0.1792 | 0.1479 | -0.0313 | [-0.0327, -0.0299] | 0 | *** |
| FG_curved_dense | curved | dense | AvgDelay | 0.0957 | 0.0870 | -0.0087 | [-0.0093, -0.0081] | 0 | *** |
| FG_curved_dense | curved | dense | AvgTxCost | 1.5957 | 1.9521 | 0.3564 | [0.3362, 0.3766] | 0 | *** |
| FG_curved_dense | curved | dense | EmgTimely | 0.9327 | 0.9776 | 0.0449 | [0.0368, 0.0530] | 1.556e-11 | *** |
| FG_curved_medium | curved | medium | TimelyRate | 0.8755 | 0.8935 | 0.0180 | [0.0154, 0.0205] | 0 | *** |
| FG_curved_medium | curved | medium | LossRate | 0.1243 | 0.1063 | -0.0180 | [-0.0204, -0.0156] | 0 | *** |
| FG_curved_medium | curved | medium | AvgDelay | 0.0702 | 0.0653 | -0.0049 | [-0.0060, -0.0038] | 4.721e-08 | *** |
| FG_curved_medium | curved | medium | AvgTxCost | 1.5696 | 1.8273 | 0.2577 | [0.2422, 0.2733] | 0 | *** |
| FG_curved_medium | curved | medium | EmgTimely | 0.9626 | 0.9860 | 0.0234 | [0.0172, 0.0295] | 4.085e-06 | *** |
| FG_curved_sparse | curved | sparse | TimelyRate | 0.9745 | 0.9785 | 0.0040 | [0.0029, 0.0051] | 9.375e-06 | *** |
| FG_curved_sparse | curved | sparse | LossRate | 0.0255 | 0.0215 | -0.0040 | [-0.0051, -0.0029] | 9.375e-06 | *** |
| FG_curved_sparse | curved | sparse | AvgDelay | 0.0235 | 0.0228 | -0.0007 | [-0.0012, -0.0003] | 0.02904 | * |
| FG_curved_sparse | curved | sparse | AvgTxCost | 1.5581 | 1.7144 | 0.1563 | [0.1482, 0.1643] | 0 | *** |
| FG_curved_sparse | curved | sparse | EmgTimely | 0.9907 | 0.9935 | 0.0028 | [0.0011, 0.0045] | 0.04953 | * |
| FG_straight_dense | straight | dense | TimelyRate | 0.9040 | 0.9171 | 0.0131 | [0.0113, 0.0150] | 0 | *** |
| FG_straight_dense | straight | dense | LossRate | 0.0960 | 0.0829 | -0.0131 | [-0.0150, -0.0113] | 0 | *** |
| FG_straight_dense | straight | dense | AvgDelay | 0.0658 | 0.0609 | -0.0048 | [-0.0056, -0.0041] | 4.441e-16 | *** |
| FG_straight_dense | straight | dense | AvgTxCost | 1.8829 | 2.0791 | 0.1962 | [0.1823, 0.2101] | 0 | *** |
| FG_straight_dense | straight | dense | EmgTimely | 0.9935 | 0.9991 | 0.0056 | [0.0021, 0.0091] | 0.04953 | * |
| FG_straight_medium | straight | medium | TimelyRate | 0.9681 | 0.9691 | 0.0010 | [0.0005, 0.0015] | 0.02445 | * |
| FG_straight_medium | straight | medium | LossRate | 0.0319 | 0.0309 | -0.0010 | [-0.0015, -0.0005] | 0.02445 | * |
| FG_straight_medium | straight | medium | AvgDelay | 0.0312 | 0.0310 | -0.0002 | [-0.0004, 0.0000] | 0.2595 | n.s. |
| FG_straight_medium | straight | medium | AvgTxCost | 1.7288 | 1.8659 | 0.1371 | [0.1287, 0.1454] | 0 | *** |
| FG_straight_medium | straight | medium | EmgTimely | 0.9981 | 1.0000 | 0.0019 | [0.0004, 0.0034] | 0.1336 | n.s. |
| FG_straight_sparse | straight | sparse | TimelyRate | 0.9950 | 0.9957 | 0.0007 | [0.0003, 0.0010] | 0.01431 | * |
| FG_straight_sparse | straight | sparse | LossRate | 0.0050 | 0.0043 | -0.0007 | [-0.0010, -0.0003] | 0.01431 | * |
| FG_straight_sparse | straight | sparse | AvgDelay | 0.0148 | 0.0146 | -0.0002 | [-0.0003, -0.0000] | 0.146 | n.s. |
| FG_straight_sparse | straight | sparse | AvgTxCost | 1.5686 | 1.6958 | 0.1271 | [0.1199, 0.1344] | 0 | *** |
| FG_straight_sparse | straight | sparse | EmgTimely | 0.9991 | 1.0000 | 0.0009 | [-0.0002, 0.0021] | 0.3173 | n.s. |

## Confidence-driven vs Link-delay-aware PosDeg_Emerg Significance

| Config | Profile | Vegetation | Metric | Baseline Mean | Proposed Mean | Delta Mean | 95% CI | p-value | Significance |
|---|---|---|---|---:|---:|---:|---:|---:|---|
| FG_blind_medium | blind | medium | TimelyRate | 0.9209 | 0.9755 | 0.0545 | [0.0463, 0.0628] | 8.882e-16 | *** |
| FG_blind_medium | blind | medium | LossRate | 0.0791 | 0.0236 | -0.0555 | [-0.0633, -0.0476] | 0 | *** |
| FG_blind_medium | blind | medium | AvgDelay | 0.0247 | 0.0280 | 0.0033 | [0.0030, 0.0036] | 0 | *** |
| FG_blind_medium | blind | medium | AvgTxCost | 3.0001 | 3.9410 | 0.9409 | [0.9226, 0.9592] | 0 | *** |
| FG_blind_medium | blind | medium | EmgTimely | 0.9661 | 0.9898 | 0.0237 | [0.0174, 0.0300] | 4.597e-06 | *** |
| FG_blind_sparse | blind | sparse | TimelyRate | 0.9936 | 0.9964 | 0.0027 | [0.0010, 0.0044] | 0.04953 | * |
| FG_blind_sparse | blind | sparse | LossRate | 0.0064 | 0.0036 | -0.0027 | [-0.0044, -0.0010] | 0.04953 | * |
| FG_blind_sparse | blind | sparse | AvgDelay | 0.0141 | 0.0144 | 0.0003 | [0.0002, 0.0004] | 4.085e-06 | *** |
| FG_blind_sparse | blind | sparse | AvgTxCost | 2.4072 | 2.8694 | 0.4623 | [0.4383, 0.4862] | 0 | *** |
| FG_blind_sparse | blind | sparse | EmgTimely | 0.9949 | 0.9983 | 0.0034 | [0.0006, 0.0061] | 0.1336 | n.s. |
| FG_curved_dense | curved | dense | TimelyRate | 0.9436 | 0.9855 | 0.0418 | [0.0365, 0.0471] | 0 | *** |
| FG_curved_dense | curved | dense | LossRate | 0.0555 | 0.0136 | -0.0418 | [-0.0476, -0.0360] | 0 | *** |
| FG_curved_dense | curved | dense | AvgDelay | 0.0182 | 0.0202 | 0.0020 | [0.0016, 0.0024] | 2.722e-10 | *** |
| FG_curved_dense | curved | dense | AvgTxCost | 2.3150 | 2.7760 | 0.4610 | [0.4402, 0.4819] | 0 | *** |
| FG_curved_dense | curved | dense | EmgTimely | 0.9151 | 0.9717 | 0.0566 | [0.0458, 0.0674] | 1.975e-10 | *** |
| FG_curved_medium | curved | medium | TimelyRate | 0.9609 | 0.9873 | 0.0264 | [0.0216, 0.0312] | 2.209e-11 | *** |
| FG_curved_medium | curved | medium | LossRate | 0.0382 | 0.0118 | -0.0264 | [-0.0309, -0.0219] | 1.031e-12 | *** |
| FG_curved_medium | curved | medium | AvgDelay | 0.0159 | 0.0171 | 0.0012 | [0.0009, 0.0014] | 3.701e-08 | *** |
| FG_curved_medium | curved | medium | AvgTxCost | 2.3086 | 2.6926 | 0.3840 | [0.3651, 0.4028] | 0 | *** |
| FG_curved_medium | curved | medium | EmgTimely | 0.9491 | 0.9774 | 0.0283 | [0.0212, 0.0354] | 1.057e-06 | *** |
| FG_curved_sparse | curved | sparse | TimelyRate | 0.9909 | 0.9964 | 0.0055 | [0.0036, 0.0073] | 0.0002386 | *** |
| FG_curved_sparse | curved | sparse | LossRate | 0.0091 | 0.0036 | -0.0055 | [-0.0073, -0.0036] | 0.0002386 | *** |
| FG_curved_sparse | curved | sparse | AvgDelay | 0.0132 | 0.0133 | 0.0001 | [0.0001, 0.0002] | 0.00782 | ** |
| FG_curved_sparse | curved | sparse | AvgTxCost | 2.2841 | 2.5929 | 0.3089 | [0.2950, 0.3227] | 0 | *** |
| FG_curved_sparse | curved | sparse | EmgTimely | 0.9943 | 0.9962 | 0.0019 | [-0.0004, 0.0042] | 0.3173 | n.s. |
| FG_straight_dense | straight | dense | TimelyRate | 0.9909 | 0.9991 | 0.0082 | [0.0047, 0.0117] | 0.00421 | ** |
| FG_straight_dense | straight | dense | LossRate | 0.0091 | 0.0009 | -0.0082 | [-0.0117, -0.0047] | 0.00421 | ** |
| FG_straight_dense | straight | dense | AvgDelay | 0.0128 | 0.0130 | 0.0002 | [0.0001, 0.0003] | 0.02964 | * |
| FG_straight_dense | straight | dense | AvgTxCost | 2.2150 | 2.4695 | 0.2545 | [0.2483, 0.2607] | 0 | *** |
| FG_straight_dense | straight | dense | EmgTimely | 0.9860 | 0.9977 | 0.0116 | [0.0029, 0.0203] | 0.1037 | n.s. |
| FG_straight_medium | straight | medium | TimelyRate | 0.9991 | 1.0000 | 0.0009 | [-0.0002, 0.0020] | 0.3173 | n.s. |
| FG_straight_medium | straight | medium | LossRate | 0.0009 | 0.0000 | -0.0009 | [-0.0020, 0.0002] | 0.3173 | n.s. |
| FG_straight_medium | straight | medium | AvgDelay | 0.0123 | 0.0123 | 0.0000 | [-0.0000, 0.0001] | 0.2681 | n.s. |
| FG_straight_medium | straight | medium | AvgTxCost | 2.2150 | 2.4518 | 0.2368 | [0.2333, 0.2402] | 0 | *** |
| FG_straight_medium | straight | medium | EmgTimely | 0.9977 | 1.0000 | 0.0023 | [-0.0005, 0.0052] | 0.3173 | n.s. |
| FG_straight_sparse | straight | sparse | TimelyRate | 0.9991 | 1.0000 | 0.0009 | [-0.0002, 0.0020] | 0.3173 | n.s. |
| FG_straight_sparse | straight | sparse | LossRate | 0.0009 | 0.0000 | -0.0009 | [-0.0020, 0.0002] | 0.3173 | n.s. |
| FG_straight_sparse | straight | sparse | AvgDelay | 0.0121 | 0.0122 | 0.0000 | [-0.0000, 0.0001] | 0.3173 | n.s. |
| FG_straight_sparse | straight | sparse | AvgTxCost | 2.2150 | 2.4492 | 0.2342 | [0.2325, 0.2359] | 0 | *** |
| FG_straight_sparse | straight | sparse | EmgTimely | 0.9977 | 1.0000 | 0.0023 | [-0.0005, 0.0052] | 0.3173 | n.s. |

## Interpretation

- If gains concentrate in `curved/blind + medium/dense` settings, the method value is specifically tied to high-risk forest geometry rather than generic easy scenarios.
- If gains vanish in `straight + sparse`, this is expected and can be framed as a targeted rather than universal scheduling advantage.
- The matrix should be used to argue forest-scene specificity and geometry-aware robustness.
