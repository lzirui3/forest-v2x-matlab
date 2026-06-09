# Step 29 VTC Applicability Boundary Report

This report converts the Step17 5-scene formal statistics into an applicability-boundary argument. It is intended to address P1/P4/P6 without retuning the mainline parameters.

## Classification Rule

- `PrimaryEvidence`: full timely-rate gain is at least 3 pp and the row is suitable for main performance claims.
- `SupportingEvidence`: full timely-rate gain is at least 1 pp but below 3 pp.
- `BoundaryOnly`: the row should be used for ceiling, uniformly-hard, or costly-low-gain boundary discussion.
- `StressBoundary`: emergency delivery is physically near-impossible because constrained-oracle emergency timely rate is below 10%.

## Applicability Summary

| Scene | Role | Config | Class | Paper Use | Base Timely | Conf Timely | Oracle Timely | Timely Delta (pp) | Base Emg | Conf Emg | Oracle Emg | Emg Delta (pp) | Cost Delta (%) | Activation Proxy | Peak Stage |
|---|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 10014 | Primary | Default | CostlyLowGain | BoundaryOnly | 0.9685 | 0.9712 | 0.9937 | 0.276 | 1.0000 | 1.0000 | 1.0000 | 0.000 | 14.46 | 0.095 | PosDeg_Emerg |
| 10014 | Primary | ForestGeometry | NearImpossible | StressBoundary | 0.7422 | 0.7747 | 0.8006 | 3.251 | 0.0267 | 0.0200 | 0.0200 | -0.667 | 29.00 | 0.205 | Recovery |
| 10006 | Reference | Default | ActiveGain | PrimaryEvidence | 0.9445 | 0.9810 | 0.9887 | 3.647 | 0.9974 | 0.9994 | 0.9974 | 0.197 | 15.27 | 0.000 | Normal |
| 10006 | Reference | ForestGeometry | ModerateGain | SupportingEvidence | 0.6916 | 0.7070 | 0.7151 | 1.537 | 0.8007 | 0.8011 | 0.8005 | 0.039 | 19.04 | 0.008 | Coop_1 |
| 10011 | Boundary | Default | CeilingBoundary | BoundaryOnly | 0.9973 | 0.9974 | 0.9974 | 0.010 | 1.0000 | 1.0000 | 1.0000 | 0.000 | 13.63 | 0.005 | PosDeg_Emerg |
| 10011 | Boundary | ForestGeometry | ActiveGain | PrimaryEvidence | 0.5903 | 0.6785 | 0.7004 | 8.822 | 0.3000 | 0.2870 | 0.3050 | -1.300 | 24.90 | 1.000 | LinkDeg_Emerg |
| 10019 | DenseBlind | Default | CeilingBoundary | BoundaryOnly | 0.9998 | 0.9998 | 0.9998 | 0.000 | 1.0000 | 1.0000 | 1.0000 | 0.000 | 19.24 | 0.000 | Normal |
| 10019 | DenseBlind | ForestGeometry | UniformHardBoundary | BoundaryOnly | 0.6671 | 0.6692 | 0.6670 | 0.210 | 0.6337 | 0.6360 | 0.6336 | 0.231 | 12.64 | 0.091 | PosDeg_Emerg |
| 10017 | LongRange | Default | ActiveGain | PrimaryEvidence | 0.9071 | 0.9558 | 0.9782 | 4.879 | 0.9861 | 0.9989 | 0.9861 | 1.278 | 23.13 | 0.005 | Normal |
| 10017 | LongRange | ForestGeometry | NearImpossible | StressBoundary | 0.5211 | 0.5242 | 0.5378 | 0.313 | 0.0200 | 0.0200 | 0.0156 | 0.000 | 22.94 | 0.009 | LinkDeg_Emerg |

## Main-Claim Rows

- `10006 / Default`: timely gain 3.647 pp, cost increase 15.27%, peak stage `Normal`.
- `10011 / ForestGeometry`: timely gain 8.822 pp, cost increase 24.90%, peak stage `LinkDeg_Emerg`.
- `10017 / Default`: timely gain 4.879 pp, cost increase 23.13%, peak stage `Normal`.

## Supporting Rows

- `10006 / ForestGeometry`: timely gain 1.537 pp; use as moderate supporting evidence.

## Boundary and Stress Rows

- `10014 / Default` [BoundaryOnly]: The trigger condition exists but the global timely gain is below 1 pp while cost increases; use only for cost-boundary discussion.
- `10014 / ForestGeometry` [StressBoundary]: Emergency delivery is bounded by the physical/channel configuration; use this row as feasibility-boundary evidence, not as a scheduler superiority claim. The negative emergency delta is not a valid method-failure claim because the constrained-oracle upper bound is also near zero.
- `10011 / Default` [BoundaryOnly]: The link-delay-aware baseline is already near saturation; the method has little room to improve and should be discussed as graceful degradation.
- `10019 / Default` [BoundaryOnly]: The link-delay-aware baseline is already near saturation; the method has little room to improve and should be discussed as graceful degradation.
- `10019 / ForestGeometry` [BoundaryOnly]: The scene is uniformly hard and the constrained oracle offers limited headroom; localized confidence triggering cannot create large global gains.
- `10017 / ForestGeometry` [StressBoundary]: Emergency delivery is bounded by the physical/channel configuration; use this row as feasibility-boundary evidence, not as a scheduler superiority claim.

## P1 / P4 / P6 Closure

- P1 is not closed as a performance improvement problem. It is reframed as a feasibility-boundary result when constrained-oracle emergency timely rate is near zero.
- P4 is closed only if the paper separates primary evidence from boundary rows. Rows with below-1-pp gain must not be counted as broad superiority evidence.
- P6 should be reported through significance and feasibility context. A negative emergency delta in a near-impossible row is not strong evidence of method failure, but it remains a limitation.

## Recommended Paper Wording

The proposed scheduler should be claimed to improve timely delivery in scenes where blind-zone risk and positioning degradation create a non-trivial but still feasible reliability gap. When the baseline is already saturated, the method exhibits graceful-boundary behavior; when the constrained oracle is also poor, the scenario should be interpreted as physically near-impossible rather than algorithmically solvable.
