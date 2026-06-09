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
| 10014 | Primary | Default | Link-delay-aware | 0.9659 | 0.0341 | 1.6295 | 1.0000 |
| 10014 | Primary | Default | Confidence-driven | 0.9692 | 0.0308 | 1.8979 | 1.0000 |
| 10014 | Primary | Default | Oracle | 0.9950 | 0.0050 | 1.8936 | 1.0000 |
| 10014 | Primary | ForestGeometry | Link-delay-aware | 0.9634 | 0.0358 | 2.2112 | 0.6667 |
| 10014 | Primary | ForestGeometry | Confidence-driven | 0.9792 | 0.0191 | 2.5744 | 0.8333 |
| 10014 | Primary | ForestGeometry | Oracle | 0.9742 | 0.0241 | 2.5526 | 0.8333 |
| 10006 | Reference | Default | Link-delay-aware | 0.9468 | 0.0532 | 2.1468 | 0.9984 |
| 10006 | Reference | Default | Confidence-driven | 0.9792 | 0.0208 | 2.4786 | 1.0000 |
| 10006 | Reference | Default | Oracle | 0.9867 | 0.0133 | 2.3259 | 0.9984 |
| 10006 | Reference | ForestGeometry | Link-delay-aware | 0.8852 | 0.1131 | 2.4733 | 0.9753 |
| 10006 | Reference | ForestGeometry | Confidence-driven | 0.8968 | 0.1015 | 2.7635 | 0.9786 |
| 10006 | Reference | ForestGeometry | Oracle | 0.9193 | 0.0732 | 2.7715 | 0.9720 |
| 10017 | LongRange | Default | Link-delay-aware | 0.9110 | 0.0890 | 1.9231 | 1.0000 |
| 10017 | LongRange | Default | Confidence-driven | 0.9551 | 0.0449 | 2.3620 | 1.0000 |
| 10017 | LongRange | Default | Oracle | 0.9775 | 0.0225 | 2.4371 | 1.0000 |
| 10017 | LongRange | ForestGeometry | Link-delay-aware | 0.8228 | 0.1631 | 2.9413 | 0.6250 |
| 10017 | LongRange | ForestGeometry | Confidence-driven | 0.8627 | 0.1231 | 3.6049 | 0.6806 |
| 10017 | LongRange | ForestGeometry | Oracle | 0.8885 | 0.0973 | 4.0169 | 0.6806 |

## Overall Significance: Confidence-driven vs Link-delay-aware

| Scene | Config | Metric | Delta Mean | 95% CI | p-value | Significance |
|---|---|---|---:|---:|---:|---|
| 10014 | Default | TimelyRate | 0.0033 | [0.0033, 0.0033] | 0 | *** |
| 10014 | Default | LossRate | -0.0033 | [-0.0033, -0.0033] | 0 | *** |
| 10014 | Default | AvgDelay | -0.0001 | [-0.0001, -0.0000] | 0.002878 | ** |
| 10014 | Default | AvgTxCost | 0.2685 | [0.2446, 0.2923] | 0 | *** |
| 10014 | Default | EmgTimely | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10014 | ForestGeometry | TimelyRate | 0.0158 | [0.0067, 0.0249] | 0.0001447 | *** |
| 10014 | ForestGeometry | LossRate | -0.0166 | [-0.0275, -0.0057] | 0.0008582 | *** |
| 10014 | ForestGeometry | AvgDelay | -0.0014 | [-0.0040, 0.0011] | 0.2152 | n.s. |
| 10014 | ForestGeometry | AvgTxCost | 0.3631 | [0.3039, 0.4224] | 0 | *** |
| 10014 | ForestGeometry | EmgTimely | 0.1667 | [-0.1969, 0.5303] | 0.3173 | n.s. |
| 10006 | Default | TimelyRate | 0.0324 | [0.0234, 0.0415] | 6.217e-15 | *** |
| 10006 | Default | LossRate | -0.0324 | [-0.0415, -0.0234] | 6.217e-15 | *** |
| 10006 | Default | AvgDelay | -0.0095 | [-0.0159, -0.0032] | 0.001035 | ** |
| 10006 | Default | AvgTxCost | 0.3319 | [0.2918, 0.3720] | 0 | *** |
| 10006 | Default | EmgTimely | 0.0016 | [-0.0019, 0.0052] | 0.3173 | n.s. |
| 10006 | ForestGeometry | TimelyRate | 0.0116 | [0.0080, 0.0153] | 2.576e-12 | *** |
| 10006 | ForestGeometry | LossRate | -0.0116 | [-0.0153, -0.0080] | 2.576e-12 | *** |
| 10006 | ForestGeometry | AvgDelay | -0.0011 | [-0.0017, -0.0004] | 0.0007402 | *** |
| 10006 | ForestGeometry | AvgTxCost | 0.2901 | [0.1904, 0.3899] | 2.224e-10 | *** |
| 10006 | ForestGeometry | EmgTimely | 0.0033 | [-0.0039, 0.0105] | 0.3173 | n.s. |
| 10017 | Default | TimelyRate | 0.0441 | [0.0386, 0.0495] | 0 | *** |
| 10017 | Default | LossRate | -0.0441 | [-0.0495, -0.0386] | 0 | *** |
| 10017 | Default | AvgDelay | -0.0108 | [-0.0118, -0.0098] | 0 | *** |
| 10017 | Default | AvgTxCost | 0.4389 | [0.4163, 0.4615] | 0 | *** |
| 10017 | Default | EmgTimely | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10017 | ForestGeometry | TimelyRate | 0.0399 | [0.0254, 0.0545] | 1.98e-09 | *** |
| 10017 | ForestGeometry | LossRate | -0.0399 | [-0.0545, -0.0254] | 1.98e-09 | *** |
| 10017 | ForestGeometry | AvgDelay | -0.0034 | [-0.0056, -0.0012] | 0.0007476 | *** |
| 10017 | ForestGeometry | AvgTxCost | 0.6636 | [0.6378, 0.6894] | 0 | *** |
| 10017 | ForestGeometry | EmgTimely | 0.0556 | [0.0556, 0.0556] | 0 | *** |

## PosDeg_Emerg Stage Summary

| Scene | Role | Config | Method | Timely Mean | Loss Mean | Avg Tx Cost Mean | Emergency Timely Mean |
|---|---|---|---|---:|---:|---:|---:|
| 10014 | Primary | Default | Link-delay-aware | 0.9864 | 0.0136 | 2.0300 | 1.0000 |
| 10014 | Primary | Default | Confidence-driven | 1.0000 | 0.0000 | 3.2948 | 1.0000 |
| 10014 | Primary | Default | Oracle | 1.0000 | 0.0000 | 2.9082 | 1.0000 |
| 10014 | Primary | ForestGeometry | Link-delay-aware | 0.9455 | 0.0500 | 2.2227 | 0.6667 |
| 10014 | Primary | ForestGeometry | Confidence-driven | 0.9864 | 0.0045 | 3.5759 | 0.8333 |
| 10014 | Primary | ForestGeometry | Oracle | 0.9864 | 0.0045 | 3.3790 | 0.8333 |
| 10006 | Reference | Default | Link-delay-aware | 1.0000 | 0.0000 | 2.5500 | 1.0000 |
| 10006 | Reference | Default | Confidence-driven | 1.0000 | 0.0000 | 2.7041 | 1.0000 |
| 10006 | Reference | Default | Oracle | 1.0000 | 0.0000 | 2.5500 | 1.0000 |
| 10006 | Reference | ForestGeometry | Link-delay-aware | 1.0000 | 0.0000 | 2.5500 | 1.0000 |
| 10006 | Reference | ForestGeometry | Confidence-driven | 1.0000 | 0.0000 | 2.7995 | 1.0000 |
| 10006 | Reference | ForestGeometry | Oracle | 1.0000 | 0.0000 | 2.5936 | 1.0000 |
| 10017 | LongRange | Default | Link-delay-aware | 1.0000 | 0.0000 | 2.0000 | NaN |
| 10017 | LongRange | Default | Confidence-driven | 1.0000 | 0.0000 | 2.9809 | NaN |
| 10017 | LongRange | Default | Oracle | 1.0000 | 0.0000 | 2.8577 | NaN |
| 10017 | LongRange | ForestGeometry | Link-delay-aware | 1.0000 | 0.0000 | 2.0000 | NaN |
| 10017 | LongRange | ForestGeometry | Confidence-driven | 1.0000 | 0.0000 | 3.0473 | NaN |
| 10017 | LongRange | ForestGeometry | Oracle | 1.0000 | 0.0000 | 2.8532 | NaN |

## PosDeg_Emerg Significance: Confidence-driven vs Link-delay-aware

| Scene | Config | Metric | Delta Mean | 95% CI | p-value | Significance |
|---|---|---|---:|---:|---:|---|
| 10014 | Default | TimelyRate | 0.0136 | [0.0037, 0.0236] | 0.0027 | ** |
| 10014 | Default | LossRate | -0.0136 | [-0.0236, -0.0037] | 0.0027 | ** |
| 10014 | Default | AvgDelay | 0.0016 | [0.0009, 0.0023] | 1.177e-06 | *** |
| 10014 | Default | AvgTxCost | 1.2648 | [1.1181, 1.4114] | 0 | *** |
| 10014 | Default | EmgTimely | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10014 | ForestGeometry | TimelyRate | 0.0409 | [0.0310, 0.0508] | 0 | *** |
| 10014 | ForestGeometry | LossRate | -0.0455 | [-0.0455, -0.0455] | 0 | *** |
| 10014 | ForestGeometry | AvgDelay | 0.0032 | [0.0023, 0.0042] | 2.336e-13 | *** |
| 10014 | ForestGeometry | AvgTxCost | 1.3532 | [1.0821, 1.6243] | 0 | *** |
| 10014 | ForestGeometry | EmgTimely | 0.1667 | [-0.1969, 0.5303] | 0.3173 | n.s. |
| 10006 | Default | TimelyRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10006 | Default | LossRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10006 | Default | AvgDelay | 0.0005 | [-0.0006, 0.0017] | 0.3173 | n.s. |
| 10006 | Default | AvgTxCost | 0.1541 | [0.0083, 0.2999] | 0.0211 | * |
| 10006 | Default | EmgTimely | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10006 | ForestGeometry | TimelyRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10006 | ForestGeometry | LossRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10006 | ForestGeometry | AvgDelay | 0.0004 | [-0.0008, 0.0016] | 0.4549 | n.s. |
| 10006 | ForestGeometry | AvgTxCost | 0.2495 | [-0.0450, 0.5441] | 0.06453 | n.s. |
| 10006 | ForestGeometry | EmgTimely | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10017 | Default | TimelyRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10017 | Default | LossRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10017 | Default | AvgDelay | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10017 | Default | AvgTxCost | 0.9809 | [0.7627, 1.1991] | 0 | *** |
| 10017 | Default | EmgTimely | NaN | [NaN, NaN] | 1 | n.s. |
| 10017 | ForestGeometry | TimelyRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10017 | ForestGeometry | LossRate | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10017 | ForestGeometry | AvgDelay | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| 10017 | ForestGeometry | AvgTxCost | 1.0473 | [0.9382, 1.1564] | 0 | *** |
| 10017 | ForestGeometry | EmgTimely | NaN | [NaN, NaN] | 1 | n.s. |

## Recommended Narrative

- The overall gain should be described as a stable but moderate improvement under repeated random realizations.
- The PosDeg\_Emerg results should be emphasized as the main source of method value, especially under forest-geometry calibration.
- The forest-geometry setting should be presented as the more application-relevant evidence for the paper topic.
