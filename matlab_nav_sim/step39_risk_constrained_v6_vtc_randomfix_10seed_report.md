# Step 39 Risk-Constrained V6 VTC Validation Report

Step39 validates the Step38-selected v6 method on the full five-scene, two-config matrix. The method uses the Step36 actual-cost weight (`0.060`) plus an explicit emergency action floor.

## Decision Table

| Scene | Config | Timely Gap vs Heuristic (pp) | Emergency Gap vs Heuristic (pp) | Cost Delta vs Heuristic (%) | Delay Delta vs Heuristic (%) | Timely Gap vs Link (pp) | Emergency Gain vs V4 (pp) | Decision |
|---|---|---:|---:|---:|---:|---:|---:|---|
| 10014 | Default | 1.631 | 0.000 | -1.77 | -31.37 | 1.930 | 0.000 | MainCandidate |
| 10014 | ForestGeometry | 1.498 | 0.000 | 9.66 | -9.37 | 4.908 | 0.000 | MainCandidate |
| 10006 | Default | 0.433 | 0.000 | 3.53 | -13.75 | 4.060 | 0.099 | MainCandidate |
| 10006 | ForestGeometry | 0.250 | 0.000 | 9.98 | -1.92 | 1.780 | 0.033 | MainCandidate |
| 10011 | Default | 0.000 | 0.000 | -3.94 | 0.00 | 0.017 | 0.000 | MainCandidate |
| 10011 | ForestGeometry | 3.860 | 0.000 | 9.11 | -11.44 | 13.211 | 1.000 | MainCandidate |
| 10019 | Default | 0.000 | 0.000 | 2.03 | 0.00 | 0.000 | 0.000 | MainCandidate |
| 10019 | ForestGeometry | 0.116 | 0.128 | -0.46 | 0.05 | 0.000 | 0.421 | MainCandidate |
| 10017 | Default | 1.065 | 0.000 | -2.86 | -16.16 | 5.923 | 0.833 | MainCandidate |
| 10017 | ForestGeometry | 0.649 | 0.000 | 12.60 | -1.73 | 0.882 | 0.000 | MainCandidate |

## Method Means

| Scene | Config | Method | Timely Rate | Emergency Timely | Avg Cost | Avg Delay |
|---|---|---|---:|---:|---:|---:|
| 10014 | Default | Link-delay-aware | 0.9699 | 1.0000 | 1.6295 | 0.0232 |
| 10014 | Default | Confidence-heuristic | 0.9729 | 1.0000 | 1.8555 | 0.0227 |
| 10014 | Default | V4Cost0060 | 0.9892 | 1.0000 | 1.8169 | 0.0156 |
| 10014 | Default | Risk-constrained-v6 | 0.9892 | 1.0000 | 1.8226 | 0.0156 |
| 10014 | Default | Constrained Oracle | 0.9933 | 1.0000 | 1.8903 | 0.0154 |
| 10014 | ForestGeometry | Link-delay-aware | 0.7383 | 0.0333 | 1.6983 | 0.1055 |
| 10014 | ForestGeometry | Confidence-heuristic | 0.7724 | 0.0333 | 2.1720 | 0.0928 |
| 10014 | ForestGeometry | V4Cost0060 | 0.7874 | 0.0333 | 2.3774 | 0.0841 |
| 10014 | ForestGeometry | Risk-constrained-v6 | 0.7874 | 0.0333 | 2.3819 | 0.0841 |
| 10014 | ForestGeometry | Constrained Oracle | 0.7975 | 0.0333 | 2.6106 | 0.0829 |
| 10006 | Default | Link-delay-aware | 0.9449 | 0.9980 | 2.1468 | 0.0340 |
| 10006 | Default | Confidence-heuristic | 0.9812 | 0.9990 | 2.4729 | 0.0222 |
| 10006 | Default | V4Cost0060 | 0.9850 | 0.9980 | 2.2575 | 0.0191 |
| 10006 | Default | Risk-constrained-v6 | 0.9855 | 0.9990 | 2.5602 | 0.0191 |
| 10006 | Default | Constrained Oracle | 0.9908 | 0.9980 | 2.3265 | 0.0183 |
| 10006 | ForestGeometry | Link-delay-aware | 0.6918 | 0.8007 | 2.2646 | 0.0928 |
| 10006 | ForestGeometry | Confidence-heuristic | 0.7072 | 0.8007 | 2.6869 | 0.0892 |
| 10006 | ForestGeometry | V4Cost0060 | 0.7095 | 0.8003 | 2.6845 | 0.0875 |
| 10006 | ForestGeometry | Risk-constrained-v6 | 0.7097 | 0.8007 | 2.9551 | 0.0875 |
| 10006 | ForestGeometry | Constrained Oracle | 0.7128 | 0.8003 | 2.8527 | 0.0875 |
| 10011 | Default | Link-delay-aware | 0.9977 | 1.0000 | 1.7188 | 0.0125 |
| 10011 | Default | Confidence-heuristic | 0.9978 | 1.0000 | 1.9424 | 0.0125 |
| 10011 | Default | V4Cost0060 | 0.9978 | 1.0000 | 1.8458 | 0.0125 |
| 10011 | Default | Risk-constrained-v6 | 0.9978 | 1.0000 | 1.8658 | 0.0125 |
| 10011 | Default | Constrained Oracle | 0.9978 | 1.0000 | 1.9007 | 0.0129 |
| 10011 | ForestGeometry | Link-delay-aware | 0.5795 | 0.2750 | 2.7289 | 0.1581 |
| 10011 | ForestGeometry | Confidence-heuristic | 0.6730 | 0.2750 | 3.3981 | 0.1400 |
| 10011 | ForestGeometry | V4Cost0060 | 0.7113 | 0.2650 | 3.7037 | 0.1240 |
| 10011 | ForestGeometry | Risk-constrained-v6 | 0.7116 | 0.2750 | 3.7077 | 0.1240 |
| 10011 | ForestGeometry | Constrained Oracle | 0.6942 | 0.2800 | 4.0091 | 0.1347 |
| 10019 | Default | Link-delay-aware | 1.0000 | 1.0000 | 2.4997 | 0.0121 |
| 10019 | Default | Confidence-heuristic | 1.0000 | 1.0000 | 2.9842 | 0.0121 |
| 10019 | Default | V4Cost0060 | 1.0000 | 1.0000 | 2.5050 | 0.0121 |
| 10019 | Default | Risk-constrained-v6 | 1.0000 | 1.0000 | 3.0448 | 0.0121 |
| 10019 | Default | Constrained Oracle | 1.0000 | 1.0000 | 2.5051 | 0.0121 |
| 10019 | ForestGeometry | Link-delay-aware | 0.6671 | 0.6335 | 2.9584 | 0.0395 |
| 10019 | ForestGeometry | Confidence-heuristic | 0.6659 | 0.6322 | 3.3328 | 0.0397 |
| 10019 | ForestGeometry | V4Cost0060 | 0.6632 | 0.6293 | 2.8922 | 0.0397 |
| 10019 | ForestGeometry | Risk-constrained-v6 | 0.6671 | 0.6335 | 3.3175 | 0.0397 |
| 10019 | ForestGeometry | Constrained Oracle | 0.6634 | 0.6295 | 3.0112 | 0.0399 |
| 10017 | Default | Link-delay-aware | 0.9030 | 0.9861 | 1.9231 | 0.0407 |
| 10017 | Default | Confidence-heuristic | 0.9516 | 0.9944 | 2.3593 | 0.0282 |
| 10017 | Default | V4Cost0060 | 0.9617 | 0.9861 | 2.2559 | 0.0237 |
| 10017 | Default | Risk-constrained-v6 | 0.9622 | 0.9944 | 2.2919 | 0.0236 |
| 10017 | Default | Constrained Oracle | 0.9772 | 0.9861 | 2.4349 | 0.0211 |
| 10017 | ForestGeometry | Link-delay-aware | 0.5206 | 0.0278 | 2.1792 | 0.1282 |
| 10017 | ForestGeometry | Confidence-heuristic | 0.5230 | 0.0278 | 2.6696 | 0.1278 |
| 10017 | ForestGeometry | V4Cost0060 | 0.5295 | 0.0278 | 2.9709 | 0.1256 |
| 10017 | ForestGeometry | Risk-constrained-v6 | 0.5295 | 0.0278 | 3.0060 | 0.1256 |
| 10017 | ForestGeometry | Constrained Oracle | 0.5354 | 0.0278 | 3.7618 | 0.1259 |

## Significance Files

- Heuristic vs v6: `step39_*_heuristic_vs_v6_significance.csv`
- Link-delay-aware vs v6: `step39_*_link_vs_v6_significance.csv`
- V4Cost0060 vs v6: `step39_*_v4_vs_v6_significance.csv`
- Holm correction has been applied by `apply_familywise_holm_to_stats_table`.

## Significance Row Counts

- Heuristic vs v6 rows: 50
- Link-delay-aware vs v6 rows: 50
- V4Cost0060 vs v6 rows: 50
