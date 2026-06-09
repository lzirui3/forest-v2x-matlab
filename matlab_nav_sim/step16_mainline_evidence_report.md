# Step 16 Mainline Evidence Report

This report summarizes the multi-seed evidence for the main comparison:
- `Confidence-driven` vs `Link-delay-aware`
- under `Default` and `ForestGeometry` parameter settings.

## Overall Statistical Comparison

| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | 95% CI | p-value | Significance |
|---|---|---:|---:|---:|---:|---:|---|
| Default | TimelyRate | 0.9692 | 0.9736 | 0.0044 | [0.0039, 0.0049] | 0 | *** |
| Default | LossRate | 0.0308 | 0.0264 | -0.0044 | [-0.0049, -0.0039] | 0 | *** |
| Default | AvgDelay | 0.0236 | 0.0230 | -0.0006 | [-0.0007, -0.0005] | 5.472e-12 | *** |
| Default | AvgTxCost | 1.6295 | 1.8508 | 0.2213 | [0.2151, 0.2275] | 0 | *** |
| Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| ForestGeometry | TimelyRate | 0.9668 | 0.9750 | 0.0082 | [0.0073, 0.0091] | 0 | *** |
| ForestGeometry | LossRate | 0.0331 | 0.0243 | -0.0087 | [-0.0096, -0.0078] | 0 | *** |
| ForestGeometry | AvgDelay | 0.0321 | 0.0314 | -0.0007 | [-0.0009, -0.0006] | 2.64e-11 | *** |
| ForestGeometry | AvgTxCost | 2.1648 | 2.4701 | 0.3052 | [0.2959, 0.3146] | 0 | *** |
| ForestGeometry | EmgTimely | 0.8222 | 0.9167 | 0.0944 | [0.0670, 0.1219] | 6.055e-05 | *** |

## PosDeg_Emerg Statistical Comparison

| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | 95% CI | p-value | Significance |
|---|---|---:|---:|---:|---:|---:|---|
| Default | TimelyRate | 0.9894 | 0.9991 | 0.0097 | [0.0082, 0.0112] | 9.903e-14 | *** |
| Default | LossRate | 0.0106 | 0.0009 | -0.0097 | [-0.0112, -0.0082] | 9.903e-14 | *** |
| Default | AvgDelay | 0.0121 | 0.0128 | 0.0006 | [0.0006, 0.0007] | 0 | *** |
| Default | AvgTxCost | 2.0300 | 2.9925 | 0.9625 | [0.9356, 0.9894] | 0 | *** |
| Default | EmgTimely | 1.0000 | 1.0000 | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| ForestGeometry | TimelyRate | 0.9636 | 0.9903 | 0.0267 | [0.0235, 0.0298] | 0 | *** |
| ForestGeometry | LossRate | 0.0355 | 0.0061 | -0.0294 | [-0.0325, -0.0262] | 0 | *** |
| ForestGeometry | AvgDelay | 0.0173 | 0.0195 | 0.0022 | [0.0021, 0.0023] | 0 | *** |
| ForestGeometry | AvgTxCost | 2.2282 | 3.4967 | 1.2685 | [1.2204, 1.3166] | 0 | *** |
| ForestGeometry | EmgTimely | 0.8222 | 0.9167 | 0.0944 | [0.0670, 0.1219] | 6.055e-05 | *** |

## Interpretation

- If the overall `TimelyRate` and `LossRate` deltas are positive/negative with statistically meaningful confidence intervals, the mainline method has stable average benefit.
- If the `PosDeg_Emerg` deltas are stronger than the overall deltas, the method value is concentrated in the intended blind-zone degradation regime.
- The `ForestGeometry` configuration is the more application-relevant evidence for the current paper topic.
