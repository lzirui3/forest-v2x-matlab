# Step 20 Forest Geometry Report

This report compares three configurations:
- `Generic`: default mainline scenario
- `ForestParam`: forest-calibrated parameter setting
- `ForestGeometryDemo`: forest geometry driven external inputs

## Overall Mean Summary

| Config | Method | Timely Mean | Loss Mean | Avg Delay Mean | Avg Tx Cost Mean | Emergency Timely Mean |
|---|---|---:|---:|---:|---:|---:|
| Generic | Link-delay-aware | 0.9686 | 0.0314 | 0.0239 | 1.6295 | 1.0000 |
| Generic | Confidence-driven | 0.9711 | 0.0289 | 0.0239 | 1.9186 | 1.0000 |
| Generic | Oracle | 0.9933 | 0.0067 | 0.0157 | 1.8986 | 1.0000 |
| ForestParam | Link-delay-aware | 0.9600 | 0.0399 | 0.0364 | 2.2112 | 0.8250 |
| ForestParam | Confidence-driven | 0.9720 | 0.0274 | 0.0352 | 2.5737 | 0.9167 |
| ForestParam | Oracle | 0.9705 | 0.0287 | 0.0363 | 2.5588 | 0.9167 |
| ForestGeometryDemo | Link-delay-aware | 0.7910 | 0.2035 | 0.0981 | 1.8650 | 0.9533 |
| ForestGeometryDemo | Confidence-driven | 0.7977 | 0.1968 | 0.0964 | 2.1492 | 0.9528 |
| ForestGeometryDemo | Oracle | 0.8061 | 0.1885 | 0.0944 | 2.2661 | 0.9533 |

## PosDeg_Emerg Mean Summary

| Config | Method | Timely Mean | Loss Mean | Avg Delay Mean | Avg Tx Cost Mean | Emergency Timely Mean |
|---|---|---:|---:|---:|---:|---:|
| Generic | Link-delay-aware | 0.9891 | 0.0109 | 0.0121 | 2.0300 | 1.0000 |
| Generic | Confidence-driven | 1.0000 | 0.0000 | 0.0136 | 3.3158 | 1.0000 |
| Generic | Oracle | 0.9986 | 0.0014 | 0.0147 | 2.9147 | 1.0000 |
| ForestParam | Link-delay-aware | 0.9586 | 0.0405 | 0.0172 | 2.2227 | 0.8250 |
| ForestParam | Confidence-driven | 0.9918 | 0.0045 | 0.0196 | 3.5641 | 0.9167 |
| ForestParam | Oracle | 0.9909 | 0.0050 | 0.0208 | 3.4088 | 0.9167 |
| ForestGeometryDemo | Link-delay-aware | 0.8736 | 0.1018 | 0.0301 | 3.6316 | 0.9415 |
| ForestGeometryDemo | Confidence-driven | 0.8782 | 0.0973 | 0.0304 | 3.9907 | 0.9407 |
| ForestGeometryDemo | Oracle | 0.8909 | 0.0845 | 0.0314 | 3.8920 | 0.9415 |

## Confidence-driven vs Link-delay-aware Overall Significance

| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | 95% CI | p-value | Significance |
|---|---|---:|---:|---:|---:|---:|---|
| Generic | TimelyRate | 0.9686 | 0.9711 | 0.0026 | [0.0021, 0.0030] | 3.919e-12 | *** |
| Generic | LossRate | 0.0314 | 0.0289 | -0.0026 | [-0.0030, -0.0021] | 3.919e-12 | *** |
| Generic | AvgDelay | 0.0239 | 0.0239 | -0.0000 | [-0.0001, 0.0001] | 0.718 | n.s. |
| Generic | AvgTxCost | 1.6295 | 1.9186 | 0.2891 | [0.2782, 0.3000] | 0 | *** |
| Generic | EmgTimely | 1.0000 | 1.0000 | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| ForestParam | TimelyRate | 0.9600 | 0.9720 | 0.0120 | [0.0095, 0.0145] | 2.444e-08 | *** |
| ForestParam | LossRate | 0.0399 | 0.0274 | -0.0125 | [-0.0150, -0.0100] | 4.208e-09 | *** |
| ForestParam | AvgDelay | 0.0364 | 0.0352 | -0.0012 | [-0.0018, -0.0007] | 0.01304 | * |
| ForestParam | AvgTxCost | 2.2112 | 2.5737 | 0.3625 | [0.3513, 0.3737] | 0 | *** |
| ForestParam | EmgTimely | 0.8250 | 0.9167 | 0.0917 | [0.0584, 0.1250] | 0.001195 | ** |
| ForestGeometryDemo | TimelyRate | 0.7910 | 0.7977 | 0.0067 | [0.0056, 0.0077] | 2.838e-13 | *** |
| ForestGeometryDemo | LossRate | 0.2035 | 0.1968 | -0.0067 | [-0.0077, -0.0056] | 2.838e-13 | *** |
| ForestGeometryDemo | AvgDelay | 0.0981 | 0.0964 | -0.0017 | [-0.0020, -0.0014] | 3.845e-11 | *** |
| ForestGeometryDemo | AvgTxCost | 1.8650 | 2.1492 | 0.2841 | [0.2755, 0.2927] | 0 | *** |
| ForestGeometryDemo | EmgTimely | 0.9533 | 0.9528 | -0.0005 | [-0.0010, 0.0001] | 0.3173 | n.s. |

## Confidence-driven vs Link-delay-aware PosDeg_Emerg Significance

| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | 95% CI | p-value | Significance |
|---|---|---:|---:|---:|---:|---:|---|
| Generic | TimelyRate | 0.9891 | 1.0000 | 0.0109 | [0.0089, 0.0129] | 1.212e-10 | *** |
| Generic | LossRate | 0.0109 | 0.0000 | -0.0109 | [-0.0129, -0.0089] | 1.212e-10 | *** |
| Generic | AvgDelay | 0.0121 | 0.0136 | 0.0015 | [0.0014, 0.0016] | 0 | *** |
| Generic | AvgTxCost | 2.0300 | 3.3158 | 1.2858 | [1.2418, 1.3297] | 0 | *** |
| Generic | EmgTimely | 1.0000 | 1.0000 | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| ForestParam | TimelyRate | 0.9586 | 0.9918 | 0.0332 | [0.0280, 0.0384] | 7.638e-14 | *** |
| ForestParam | LossRate | 0.0405 | 0.0045 | -0.0359 | [-0.0411, -0.0307] | 4.441e-16 | *** |
| ForestParam | AvgDelay | 0.0172 | 0.0196 | 0.0024 | [0.0023, 0.0026] | 0 | *** |
| ForestParam | AvgTxCost | 2.2227 | 3.5641 | 1.3414 | [1.2852, 1.3975] | 0 | *** |
| ForestParam | EmgTimely | 0.8250 | 0.9167 | 0.0917 | [0.0584, 0.1250] | 0.001195 | ** |
| ForestGeometryDemo | TimelyRate | 0.8736 | 0.8782 | 0.0045 | [0.0010, 0.0081] | 0.128 | n.s. |
| ForestGeometryDemo | LossRate | 0.1018 | 0.0973 | -0.0045 | [-0.0081, -0.0010] | 0.128 | n.s. |
| ForestGeometryDemo | AvgDelay | 0.0301 | 0.0304 | 0.0003 | [0.0001, 0.0005] | 0.07777 | n.s. |
| ForestGeometryDemo | AvgTxCost | 3.6316 | 3.9907 | 0.3590 | [0.3422, 0.3759] | 0 | *** |
| ForestGeometryDemo | EmgTimely | 0.9415 | 0.9407 | -0.0008 | [-0.0018, 0.0001] | 0.3173 | n.s. |

## Interpretation

- If `ForestGeometryDemo` remains harder than `ForestParam`, the geometry-driven inputs are imposing additional realism rather than merely renaming the calibrated setting.
- If the confidence-driven advantage persists under `ForestGeometryDemo`, the forest-specific contribution is strengthened.
- If cost rises sharply under `ForestGeometryDemo`, the next step is to redesign scheduling conservatism specifically for geometry-driven blind zones.
