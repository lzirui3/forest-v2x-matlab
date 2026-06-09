# Step 36 V4 Actual-Cost Weight Sweep Report

Step36 sweeps the actual-cost weight used by the v4 risk objective. This tests whether the 10017 ForestGeometry cost issue is a tunable cost-performance tradeoff or a consequence of the current reliability/timely constraints.

## Candidate Score

| Candidate | Cost Weight | Mean Timely Gap (pp) | Mean Emg Gap (pp) | Mean Cost Delta (%) | 10017 Default Emg Gap (pp) | 10017 Forest Cost Delta (%) | 10019 Forest Timely Gap (pp) | Status |
|---|---:|---:|---:|---:|---:|---:|---:|---|
| V4Cost0060 | 0.060 | 0.255 | -0.492 | -2.28 | -0.556 | 11.54 | -0.333 | NeedsCalibration |
| V4Cost0035 | 0.035 | 0.843 | -0.444 | 10.95 | -0.556 | 46.12 | -0.200 | NeedsCalibration |
| V4Cost0090 | 0.090 | -0.211 | -0.554 | -9.42 | -0.556 | -6.38 | -0.499 | Reject |
| V4Cost0130 | 0.130 | -0.688 | -0.615 | -14.68 | -0.556 | -18.99 | -0.666 | Reject |
| V4Cost0180 | 0.180 | -0.932 | -0.688 | -15.96 | -0.556 | -20.95 | -0.865 | Reject |
| V4Cost0250 | 0.250 | -1.054 | -0.590 | -17.09 | -0.556 | -21.91 | -0.599 | Reject |

## Per-Case Decision Table

| Scene | Config | Candidate | Timely Gap (pp) | Emg Gap (pp) | Cost Delta (%) | Delay Delta (%) |
|---|---|---|---:|---:|---:|---:|
| 10017 | Default | V4Cost0035 | 1.131 | -0.556 | -0.21 | -13.80 |
| 10017 | Default | V4Cost0060 | 0.399 | -0.556 | -4.41 | -6.85 |
| 10017 | Default | V4Cost0090 | -0.200 | -0.556 | -7.06 | -3.13 |
| 10017 | Default | V4Cost0130 | -0.899 | -0.556 | -9.48 | 2.68 |
| 10017 | Default | V4Cost0180 | -1.298 | -0.556 | -10.63 | 4.68 |
| 10017 | Default | V4Cost0250 | -1.864 | -0.556 | -11.99 | 10.50 |
| 10017 | ForestGeometry | V4Cost0035 | 1.597 | -0.556 | 46.12 | -2.59 |
| 10017 | ForestGeometry | V4Cost0060 | 0.699 | -0.556 | 11.54 | -1.81 |
| 10017 | ForestGeometry | V4Cost0090 | 0.067 | -0.556 | -6.38 | -1.08 |
| 10017 | ForestGeometry | V4Cost0130 | -0.499 | -0.556 | -18.99 | 0.49 |
| 10017 | ForestGeometry | V4Cost0180 | -0.632 | -0.556 | -20.95 | 0.65 |
| 10017 | ForestGeometry | V4Cost0250 | -0.699 | -0.556 | -21.91 | 0.70 |
| 10019 | ForestGeometry | V4Cost0035 | -0.200 | -0.220 | -13.07 | -0.04 |
| 10019 | ForestGeometry | V4Cost0060 | -0.333 | -0.366 | -13.97 | -0.13 |
| 10019 | ForestGeometry | V4Cost0090 | -0.499 | -0.549 | -14.81 | -0.28 |
| 10019 | ForestGeometry | V4Cost0130 | -0.666 | -0.733 | -15.57 | -0.45 |
| 10019 | ForestGeometry | V4Cost0180 | -0.865 | -0.952 | -16.30 | -0.59 |
| 10019 | ForestGeometry | V4Cost0250 | -0.599 | -0.659 | -17.37 | -0.93 |

## Policy Diagnostics

| Scene | Config | Method | Direct Share | Redundant Share | Relay Share | Avg Tx Rate |
|---|---|---|---:|---:|---:|---:|
| 10017 | Default | Confidence-heuristic | 0.923 | 0.077 | 0.000 | 2.311 |
| 10017 | Default | V4Cost0035 | 0.987 | 0.000 | 0.013 | 2.341 |
| 10017 | Default | V4Cost0060 | 0.992 | 0.000 | 0.008 | 2.247 |
| 10017 | Default | V4Cost0090 | 0.976 | 0.021 | 0.003 | 2.163 |
| 10017 | Default | V4Cost0130 | 0.982 | 0.018 | 0.000 | 2.112 |
| 10017 | Default | V4Cost0180 | 0.987 | 0.013 | 0.000 | 2.092 |
| 10017 | Default | V4Cost0250 | 0.990 | 0.010 | 0.000 | 2.063 |
| 10017 | ForestGeometry | Confidence-heuristic | 0.899 | 0.101 | 0.000 | 2.462 |
| 10017 | ForestGeometry | V4Cost0035 | 0.575 | 0.425 | 0.000 | 2.941 |
| 10017 | ForestGeometry | V4Cost0060 | 0.792 | 0.208 | 0.000 | 2.570 |
| 10017 | ForestGeometry | V4Cost0090 | 0.811 | 0.189 | 0.000 | 2.221 |
| 10017 | ForestGeometry | V4Cost0130 | 0.960 | 0.040 | 0.000 | 2.095 |
| 10017 | ForestGeometry | V4Cost0180 | 0.983 | 0.017 | 0.000 | 2.075 |
| 10017 | ForestGeometry | V4Cost0250 | 0.989 | 0.011 | 0.000 | 2.056 |
| 10019 | ForestGeometry | Confidence-heuristic | 0.829 | 0.171 | 0.000 | 3.039 |
| 10019 | ForestGeometry | V4Cost0035 | 0.837 | 0.163 | 0.000 | 2.619 |
| 10019 | ForestGeometry | V4Cost0060 | 0.848 | 0.152 | 0.000 | 2.609 |
| 10019 | ForestGeometry | V4Cost0090 | 0.865 | 0.135 | 0.000 | 2.610 |
| 10019 | ForestGeometry | V4Cost0130 | 0.877 | 0.123 | 0.000 | 2.607 |
| 10019 | ForestGeometry | V4Cost0180 | 0.889 | 0.111 | 0.000 | 2.605 |
| 10019 | ForestGeometry | V4Cost0250 | 0.906 | 0.094 | 0.000 | 2.601 |
