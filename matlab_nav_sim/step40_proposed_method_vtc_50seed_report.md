# Step 40 Proposed Method VTC Validation Report

Step40 validates the proposed actual-cost-aware risk-constrained emergency-safe scheduler on the full five-scene, two-config matrix. The method uses the Step36 actual-cost weight (`0.060`) plus an explicit emergency action floor.

## Decision Table

| Scene | Config | Timely Gap vs Heuristic (pp) | Emergency Gap vs Heuristic (pp) | Cost Delta vs Heuristic (%) | Delay Delta vs Heuristic (%) | Timely Gap vs Link (pp) | Emergency Gain vs V4 (pp) | Decision |
|---|---|---:|---:|---:|---:|---:|---:|---|
| 10014 | Default | 1.601 | 0.000 | -1.86 | -31.26 | 1.890 | 0.000 | MainCandidate |
| 10014 | ForestGeometry | 1.674 | 0.333 | 9.31 | -10.00 | 5.111 | 0.000 | MainCandidate |
| 10006 | Default | 0.489 | 0.000 | 3.55 | -15.23 | 4.090 | 0.164 | MainCandidate |
| 10006 | ForestGeometry | 0.349 | -0.007 | 9.70 | -2.22 | 1.887 | 0.046 | MainCandidate |
| 10011 | Default | 0.000 | 0.000 | -3.98 | 0.00 | 0.013 | 0.000 | MainCandidate |
| 10011 | ForestGeometry | 3.724 | 0.000 | 9.09 | -11.02 | 12.652 | 1.100 | MainCandidate |
| 10019 | Default | 0.000 | 0.000 | 2.16 | 0.00 | 0.000 | 0.000 | MainCandidate |
| 10019 | ForestGeometry | 0.053 | 0.059 | -0.44 | 0.06 | 0.133 | 0.407 | MainCandidate |
| 10017 | Default | 0.992 | 0.000 | -2.82 | -16.68 | 5.887 | 1.111 | MainCandidate |
| 10017 | ForestGeometry | 0.619 | 0.000 | 12.12 | -1.73 | 0.908 | 0.167 | MainCandidate |

## Method Means

| Scene | Config | Method | Timely Rate | Emergency Timely | Avg Cost | Avg Delay |
|---|---|---|---:|---:|---:|---:|
| 10014 | Default | Link-delay-aware | 0.9692 | 1.0000 | 1.6295 | 0.0234 |
| 10014 | Default | Confidence-heuristic | 0.9721 | 1.0000 | 1.8651 | 0.0230 |
| 10014 | Default | V4Cost0060 | 0.9881 | 1.0000 | 1.8247 | 0.0158 |
| 10014 | Default | Risk-constrained-v6 | 0.9881 | 1.0000 | 1.8305 | 0.0158 |
| 10014 | Default | Constrained Oracle | 0.9937 | 1.0000 | 1.8990 | 0.0154 |
| 10014 | ForestGeometry | Link-delay-aware | 0.7403 | 0.0233 | 1.6983 | 0.1053 |
| 10014 | ForestGeometry | Confidence-heuristic | 0.7747 | 0.0200 | 2.1908 | 0.0921 |
| 10014 | ForestGeometry | V4Cost0060 | 0.7914 | 0.0233 | 2.3917 | 0.0829 |
| 10014 | ForestGeometry | Risk-constrained-v6 | 0.7914 | 0.0233 | 2.3947 | 0.0829 |
| 10014 | ForestGeometry | Constrained Oracle | 0.7994 | 0.0200 | 2.6277 | 0.0820 |
| 10006 | Default | Link-delay-aware | 0.9454 | 0.9978 | 2.1468 | 0.0336 |
| 10006 | Default | Confidence-heuristic | 0.9814 | 0.9995 | 2.4746 | 0.0221 |
| 10006 | Default | V4Cost0060 | 0.9854 | 0.9978 | 2.2594 | 0.0188 |
| 10006 | Default | Risk-constrained-v6 | 0.9863 | 0.9995 | 2.5624 | 0.0188 |
| 10006 | Default | Constrained Oracle | 0.9905 | 0.9978 | 2.3268 | 0.0180 |
| 10006 | ForestGeometry | Link-delay-aware | 0.6911 | 0.7998 | 2.2646 | 0.0927 |
| 10006 | ForestGeometry | Confidence-heuristic | 0.7065 | 0.7999 | 2.6958 | 0.0892 |
| 10006 | ForestGeometry | V4Cost0060 | 0.7097 | 0.7994 | 2.6868 | 0.0872 |
| 10006 | ForestGeometry | Risk-constrained-v6 | 0.7100 | 0.7999 | 2.9573 | 0.0872 |
| 10006 | ForestGeometry | Constrained Oracle | 0.7140 | 0.7995 | 2.8612 | 0.0869 |
| 10011 | Default | Link-delay-aware | 0.9972 | 1.0000 | 1.7188 | 0.0126 |
| 10011 | Default | Confidence-heuristic | 0.9973 | 1.0000 | 1.9532 | 0.0126 |
| 10011 | Default | V4Cost0060 | 0.9973 | 1.0000 | 1.8555 | 0.0126 |
| 10011 | Default | Risk-constrained-v6 | 0.9973 | 1.0000 | 1.8755 | 0.0126 |
| 10011 | Default | Constrained Oracle | 0.9973 | 1.0000 | 1.9084 | 0.0131 |
| 10011 | ForestGeometry | Link-delay-aware | 0.5876 | 0.2490 | 2.7289 | 0.1558 |
| 10011 | ForestGeometry | Confidence-heuristic | 0.6768 | 0.2490 | 3.4085 | 0.1384 |
| 10011 | ForestGeometry | V4Cost0060 | 0.7137 | 0.2380 | 3.7144 | 0.1232 |
| 10011 | ForestGeometry | Risk-constrained-v6 | 0.7141 | 0.2490 | 3.7184 | 0.1231 |
| 10011 | ForestGeometry | Constrained Oracle | 0.6979 | 0.2630 | 4.0133 | 0.1334 |
| 10019 | Default | Link-delay-aware | 0.9999 | 1.0000 | 2.4997 | 0.0121 |
| 10019 | Default | Confidence-heuristic | 0.9999 | 1.0000 | 2.9805 | 0.0121 |
| 10019 | Default | V4Cost0060 | 0.9999 | 1.0000 | 2.5080 | 0.0121 |
| 10019 | Default | Risk-constrained-v6 | 0.9999 | 1.0000 | 3.0448 | 0.0121 |
| 10019 | Default | Constrained Oracle | 0.9999 | 1.0000 | 2.5081 | 0.0121 |
| 10019 | ForestGeometry | Link-delay-aware | 0.6675 | 0.6341 | 2.9584 | 0.0396 |
| 10019 | ForestGeometry | Confidence-heuristic | 0.6683 | 0.6350 | 3.3324 | 0.0397 |
| 10019 | ForestGeometry | V4Cost0060 | 0.6651 | 0.6315 | 2.8921 | 0.0397 |
| 10019 | ForestGeometry | Risk-constrained-v6 | 0.6688 | 0.6356 | 3.3177 | 0.0398 |
| 10019 | ForestGeometry | Constrained Oracle | 0.6672 | 0.6338 | 3.0120 | 0.0400 |
| 10017 | Default | Link-delay-aware | 0.9079 | 0.9872 | 1.9231 | 0.0390 |
| 10017 | Default | Confidence-heuristic | 0.9568 | 0.9983 | 2.3680 | 0.0271 |
| 10017 | Default | V4Cost0060 | 0.9661 | 0.9872 | 2.2652 | 0.0226 |
| 10017 | Default | Risk-constrained-v6 | 0.9668 | 0.9983 | 2.3011 | 0.0226 |
| 10017 | Default | Constrained Oracle | 0.9789 | 0.9872 | 2.4434 | 0.0208 |
| 10017 | ForestGeometry | Link-delay-aware | 0.5211 | 0.0244 | 2.1792 | 0.1279 |
| 10017 | ForestGeometry | Confidence-heuristic | 0.5240 | 0.0244 | 2.6790 | 0.1275 |
| 10017 | ForestGeometry | V4Cost0060 | 0.5300 | 0.0228 | 2.9688 | 0.1253 |
| 10017 | ForestGeometry | Risk-constrained-v6 | 0.5301 | 0.0244 | 3.0038 | 0.1253 |
| 10017 | ForestGeometry | Constrained Oracle | 0.5367 | 0.0228 | 3.7779 | 0.1254 |

## Significance Files

- Heuristic vs proposed: `step40_*_heuristic_vs_v6_significance.csv`
- Link-delay-aware vs proposed: `step40_*_link_vs_v6_significance.csv`
- V4Cost0060 vs proposed: `step40_*_v4_vs_v6_significance.csv`
- Holm correction has been applied by `apply_familywise_holm_to_stats_table`.

## Significance Row Counts

- Heuristic vs v6 rows: 50
- Link-delay-aware vs v6 rows: 50
- V4Cost0060 vs v6 rows: 50
