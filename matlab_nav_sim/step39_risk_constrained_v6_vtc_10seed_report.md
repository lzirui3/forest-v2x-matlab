# Step 39 Risk-Constrained V6 VTC Validation Report

Step39 validates the Step38-selected v6 method on the full five-scene, two-config matrix. The method uses the Step36 actual-cost weight (`0.060`) plus an explicit emergency action floor.

## Decision Table

| Scene | Config | Timely Gap vs Heuristic (pp) | Emergency Gap vs Heuristic (pp) | Cost Delta vs Heuristic (%) | Delay Delta vs Heuristic (%) | Timely Gap vs Link (pp) | Emergency Gain vs V4 (pp) | Decision |
|---|---|---:|---:|---:|---:|---:|---:|---|
| 10014 | Default | 1.697 | 0.000 | -1.77 | -31.28 | 1.897 | 0.000 | MainCandidate |
| 10014 | ForestGeometry | 2.097 | 0.000 | 9.66 | -11.86 | 5.225 | 0.000 | MainCandidate |
| 10006 | Default | 0.449 | 0.000 | 3.53 | -14.39 | 3.977 | 0.230 | MainCandidate |
| 10006 | ForestGeometry | 0.499 | -0.066 | 9.98 | -3.43 | 2.130 | 0.000 | MainCandidate |
| 10011 | Default | 0.000 | 0.000 | -3.94 | 0.00 | 0.000 | 0.000 | MainCandidate |
| 10011 | ForestGeometry | 3.677 | 2.000 | 9.11 | -10.73 | 12.562 | 0.000 | MainCandidate |
| 10019 | Default | 0.000 | 0.000 | 2.03 | 0.00 | 0.000 | 0.000 | MainCandidate |
| 10019 | ForestGeometry | 0.017 | 0.018 | -0.46 | 0.20 | 0.183 | 0.311 | MainCandidate |
| 10017 | Default | 1.015 | 0.000 | -2.86 | -15.27 | 5.707 | 0.833 | MainCandidate |
| 10017 | ForestGeometry | 0.749 | 0.000 | 12.60 | -1.95 | 1.048 | 0.278 | MainCandidate |

## Method Means

| Scene | Config | Method | Timely Rate | Emergency Timely | Avg Cost | Avg Delay |
|---|---|---|---:|---:|---:|---:|
| 10014 | Default | Link-delay-aware | 0.9687 | 1.0000 | 1.6295 | 0.0242 |
| 10014 | Default | Confidence-heuristic | 0.9707 | 1.0000 | 1.8555 | 0.0239 |
| 10014 | Default | V4Cost0060 | 0.9877 | 1.0000 | 1.8169 | 0.0164 |
| 10014 | Default | Risk-constrained-v6 | 0.9877 | 1.0000 | 1.8226 | 0.0164 |
| 10014 | Default | Constrained Oracle | 0.9930 | 1.0000 | 1.8903 | 0.0157 |
| 10014 | ForestGeometry | Link-delay-aware | 0.7391 | 0.0167 | 1.6983 | 0.1055 |
| 10014 | ForestGeometry | Confidence-heuristic | 0.7704 | 0.0167 | 2.1720 | 0.0936 |
| 10014 | ForestGeometry | V4Cost0060 | 0.7913 | 0.0167 | 2.3774 | 0.0825 |
| 10014 | ForestGeometry | Risk-constrained-v6 | 0.7913 | 0.0167 | 2.3819 | 0.0825 |
| 10014 | ForestGeometry | Constrained Oracle | 0.8008 | 0.0167 | 2.6106 | 0.0815 |
| 10006 | Default | Link-delay-aware | 0.9456 | 0.9974 | 2.1468 | 0.0337 |
| 10006 | Default | Confidence-heuristic | 0.9809 | 0.9997 | 2.4729 | 0.0225 |
| 10006 | Default | V4Cost0060 | 0.9842 | 0.9974 | 2.2575 | 0.0193 |
| 10006 | Default | Risk-constrained-v6 | 0.9854 | 0.9997 | 2.5602 | 0.0193 |
| 10006 | Default | Constrained Oracle | 0.9887 | 0.9974 | 2.3265 | 0.0189 |
| 10006 | ForestGeometry | Link-delay-aware | 0.6905 | 0.8016 | 2.2646 | 0.0927 |
| 10006 | ForestGeometry | Confidence-heuristic | 0.7068 | 0.8026 | 2.6869 | 0.0894 |
| 10006 | ForestGeometry | V4Cost0060 | 0.7118 | 0.8020 | 2.6845 | 0.0863 |
| 10006 | ForestGeometry | Risk-constrained-v6 | 0.7118 | 0.8020 | 2.9551 | 0.0863 |
| 10006 | ForestGeometry | Constrained Oracle | 0.7158 | 0.8020 | 2.8527 | 0.0862 |
| 10011 | Default | Link-delay-aware | 0.9972 | 1.0000 | 1.7188 | 0.0127 |
| 10011 | Default | Confidence-heuristic | 0.9972 | 1.0000 | 1.9424 | 0.0127 |
| 10011 | Default | V4Cost0060 | 0.9972 | 1.0000 | 1.8458 | 0.0127 |
| 10011 | Default | Risk-constrained-v6 | 0.9972 | 1.0000 | 1.8658 | 0.0127 |
| 10011 | Default | Constrained Oracle | 0.9972 | 1.0000 | 1.9007 | 0.0131 |
| 10011 | ForestGeometry | Link-delay-aware | 0.5905 | 0.2950 | 2.7289 | 0.1557 |
| 10011 | ForestGeometry | Confidence-heuristic | 0.6794 | 0.2750 | 3.3981 | 0.1378 |
| 10011 | ForestGeometry | V4Cost0060 | 0.7161 | 0.2950 | 3.7037 | 0.1230 |
| 10011 | ForestGeometry | Risk-constrained-v6 | 0.7161 | 0.2950 | 3.7077 | 0.1230 |
| 10011 | ForestGeometry | Constrained Oracle | 0.7017 | 0.2900 | 4.0091 | 0.1326 |
| 10019 | Default | Link-delay-aware | 1.0000 | 1.0000 | 2.4997 | 0.0121 |
| 10019 | Default | Confidence-heuristic | 1.0000 | 1.0000 | 2.9842 | 0.0121 |
| 10019 | Default | V4Cost0060 | 1.0000 | 1.0000 | 2.5050 | 0.0121 |
| 10019 | Default | Risk-constrained-v6 | 1.0000 | 1.0000 | 3.0448 | 0.0121 |
| 10019 | Default | Constrained Oracle | 1.0000 | 1.0000 | 2.5051 | 0.0121 |
| 10019 | ForestGeometry | Link-delay-aware | 0.6631 | 0.6291 | 2.9584 | 0.0397 |
| 10019 | ForestGeometry | Confidence-heuristic | 0.6647 | 0.6310 | 3.3328 | 0.0399 |
| 10019 | ForestGeometry | V4Cost0060 | 0.6621 | 0.6280 | 2.8922 | 0.0399 |
| 10019 | ForestGeometry | Risk-constrained-v6 | 0.6649 | 0.6311 | 3.3175 | 0.0399 |
| 10019 | ForestGeometry | Constrained Oracle | 0.6626 | 0.6286 | 3.0112 | 0.0402 |
| 10017 | Default | Link-delay-aware | 0.9045 | 0.9917 | 1.9231 | 0.0394 |
| 10017 | Default | Confidence-heuristic | 0.9514 | 1.0000 | 2.3593 | 0.0282 |
| 10017 | Default | V4Cost0060 | 0.9604 | 0.9917 | 2.2559 | 0.0243 |
| 10017 | Default | Risk-constrained-v6 | 0.9616 | 1.0000 | 2.2919 | 0.0239 |
| 10017 | Default | Constrained Oracle | 0.9779 | 0.9917 | 2.4349 | 0.0212 |
| 10017 | ForestGeometry | Link-delay-aware | 0.5213 | 0.0139 | 2.1792 | 0.1279 |
| 10017 | ForestGeometry | Confidence-heuristic | 0.5243 | 0.0139 | 2.6696 | 0.1275 |
| 10017 | ForestGeometry | V4Cost0060 | 0.5316 | 0.0111 | 2.9709 | 0.1250 |
| 10017 | ForestGeometry | Risk-constrained-v6 | 0.5318 | 0.0139 | 3.0060 | 0.1250 |
| 10017 | ForestGeometry | Constrained Oracle | 0.5396 | 0.0111 | 3.7618 | 0.1250 |

## Significance Files

- Heuristic vs v6: `step39_*_heuristic_vs_v6_significance.csv`
- Link-delay-aware vs v6: `step39_*_link_vs_v6_significance.csv`
- V4Cost0060 vs v6: `step39_*_v4_vs_v6_significance.csv`
- Holm correction has been applied by `apply_familywise_holm_to_stats_table`.

## Significance Row Counts

- Heuristic vs v6 rows: 50
- Link-delay-aware vs v6 rows: 50
- V4Cost0060 vs v6 rows: 50
