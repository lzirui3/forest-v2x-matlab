# Step45 Frozen-Parameter Held-Out Validation Report

Purpose: test overfitting risk by freezing the Step40 main method and evaluating unseen V2X-Seq scenes without retuning.

Frozen method: `Risk-constrained-v6` through `run_step9_proposed_method.m`.
No parameter file is modified by this script. V4 uses the same Step40 ablation cost weight `0.060`.

- Seeds per scene/config: 50
- Held-out scenes: `10013`, `10007`, `10015`
- Configs: `Default`, `ForestGeometry`

## Held-Out Scene Rationale

| Scene | Role | Geometry | Density | Vegetation | Rationale |
|---|---|---|---|---|---|
| 10013 | HeldOutHighNLOS | ShortHighNLOS | High | Dense | High-NLOS short-range unseen scene. |
| 10007 | HeldOutLongMixed | LongMixed | Medium | Mixed | Long-range mixed unseen scene. |
| 10015 | HeldOutBoundary | LongLowNLOS | Low | Sparse | Low-NLOS long-range boundary scene. |

## Decision Table

| Scene | Config | Timely Gap vs Heuristic (pp) | Emergency Gap vs Heuristic (pp) | Cost Delta vs Heuristic (%) | Delay Delta vs Heuristic (%) | Timely Gap vs Link (pp) | Emergency Gain vs V4 (pp) | Decision |
|---|---|---:|---:|---:|---:|---:|---:|---|
| 10013 | Default | 0.000 | 0.000 | 2.54 | 0.00 | 0.003 | 0.004 | GeneralizesWeak |
| 10013 | ForestGeometry | 0.166 | 0.154 | 3.77 | 0.18 | 0.566 | 0.319 | GeneralizesWeak |
| 10007 | Default | 0.153 | 0.000 | 3.54 | -6.95 | 4.113 | 0.000 | GeneralizesWeak |
| 10007 | ForestGeometry | 0.047 | 0.000 | 7.28 | -1.65 | 4.965 | 0.000 | GeneralizesWeak |
| 10015 | Default | 0.103 | 0.000 | -2.06 | -5.23 | 1.574 | 0.000 | GeneralizesWeak |
| 10015 | ForestGeometry | 3.255 | 0.308 | 12.39 | -21.92 | 22.632 | 0.923 | GeneralizesStrong |

## Method Means

| Scene | Config | Method | Timely Rate | Emergency Timely | Avg Cost | Avg Delay |
|---|---|---|---:|---:|---:|---:|
| 10013 | Default | Link-delay-aware | 0.9981 | 1.0000 | 2.4988 | 0.0124 |
| 10013 | Default | Confidence-heuristic | 0.9981 | 1.0000 | 2.9676 | 0.0124 |
| 10013 | Default | V4Cost0060 | 0.9981 | 1.0000 | 2.5056 | 0.0124 |
| 10013 | Default | Risk-constrained-v6 | 0.9981 | 1.0000 | 3.0428 | 0.0124 |
| 10013 | Default | Constrained Oracle | 0.9981 | 1.0000 | 2.5058 | 0.0124 |
| 10013 | ForestGeometry | Link-delay-aware | 0.5959 | 0.6557 | 2.9181 | 0.0552 |
| 10013 | ForestGeometry | Confidence-heuristic | 0.5999 | 0.6599 | 3.2578 | 0.0553 |
| 10013 | ForestGeometry | V4Cost0060 | 0.5987 | 0.6583 | 2.9582 | 0.0554 |
| 10013 | ForestGeometry | Risk-constrained-v6 | 0.6016 | 0.6615 | 3.3806 | 0.0554 |
| 10013 | ForestGeometry | Constrained Oracle | 0.6032 | 0.6600 | 3.3846 | 0.0553 |
| 10007 | Default | Link-delay-aware | 0.9495 | 1.0000 | 2.1518 | 0.0305 |
| 10007 | Default | Confidence-heuristic | 0.9891 | 1.0000 | 2.4725 | 0.0181 |
| 10007 | Default | V4Cost0060 | 0.9906 | 1.0000 | 2.3058 | 0.0169 |
| 10007 | Default | Risk-constrained-v6 | 0.9906 | 1.0000 | 2.5600 | 0.0169 |
| 10007 | Default | Constrained Oracle | 0.9963 | 1.0000 | 2.3888 | 0.0164 |
| 10007 | ForestGeometry | Link-delay-aware | 0.8125 | 1.0000 | 2.2007 | 0.0713 |
| 10007 | ForestGeometry | Confidence-heuristic | 0.8617 | 1.0000 | 2.6872 | 0.0621 |
| 10007 | ForestGeometry | V4Cost0060 | 0.8621 | 1.0000 | 2.6401 | 0.0610 |
| 10007 | ForestGeometry | Risk-constrained-v6 | 0.8621 | 1.0000 | 2.8828 | 0.0610 |
| 10007 | ForestGeometry | Constrained Oracle | 0.8697 | 1.0000 | 2.9513 | 0.0607 |
| 10015 | Default | Link-delay-aware | 0.9759 | 1.0000 | 1.0834 | 0.0229 |
| 10015 | Default | Confidence-heuristic | 0.9906 | 1.0000 | 1.2430 | 0.0172 |
| 10015 | Default | V4Cost0060 | 0.9917 | 1.0000 | 1.2045 | 0.0163 |
| 10015 | Default | Risk-constrained-v6 | 0.9917 | 1.0000 | 1.2175 | 0.0163 |
| 10015 | Default | Constrained Oracle | 0.9971 | 1.0000 | 1.2634 | 0.0146 |
| 10015 | ForestGeometry | Link-delay-aware | 0.6822 | 0.9892 | 1.0998 | 0.1673 |
| 10015 | ForestGeometry | Confidence-heuristic | 0.8760 | 0.9954 | 1.7448 | 0.0828 |
| 10015 | ForestGeometry | V4Cost0060 | 0.9084 | 0.9892 | 1.9480 | 0.0646 |
| 10015 | ForestGeometry | Risk-constrained-v6 | 0.9086 | 0.9985 | 1.9609 | 0.0646 |
| 10015 | ForestGeometry | Constrained Oracle | 0.9152 | 0.9892 | 2.1885 | 0.0649 |

## Significance Row Counts

- Heuristic vs v6 rows: 30
- Link-delay-aware vs v6 rows: 30
- V4Cost0060 vs v6 rows: 30

## Interpretation Rule

This held-out validation is not a new tuning loop. Results should be interpreted as frozen-parameter generalization evidence. Rows marked `GeneralizesStrong` support out-of-sample benefit. `GeneralizesWeak` supports non-negative transfer with limited gain. `GracefulBoundary` indicates acceptable non-degradation on a boundary scene. `HeldoutRisk` should be discussed as evidence of limited applicability.
