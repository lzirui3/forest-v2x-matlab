# Step 37 Risk-Constrained V5 Targeted Validation Report

Step37 tests the Step36-selected actual-cost weight (`0.060`) plus an emergency safeguard. The target is to keep the 10017 ForestGeometry cost below 30% while reducing emergency loss in 10017 Default.

## Method Score

| Method | Mean Timely Gap (pp) | Mean Emg Gap (pp) | Mean Cost Delta (%) | 10017 Default Emg Gap (pp) | 10017 Forest Cost Delta (%) | 10019 Forest Timely Gap (pp) | Status |
|---|---:|---:|---:|---:|---:|---:|---|
| Risk-constrained-v5 | 0.288 | -0.492 | -2.28 | -0.556 | 11.54 | -0.333 | NeedsCalibration |
| V4Cost0060 | 0.266 | -0.492 | -2.28 | -0.556 | 11.54 | -0.333 | NeedsCalibration |

## Per-Case Decision Table

| Scene | Config | Method | Timely Gap (pp) | Emg Gap (pp) | Cost Delta (%) | Delay Delta (%) |
|---|---|---|---:|---:|---:|---:|
| 10017 | Default | V4Cost0060 | 0.433 | -0.556 | -4.41 | -7.41 |
| 10017 | Default | Risk-constrained-v5 | 0.499 | -0.556 | -4.41 | -8.53 |
| 10017 | ForestGeometry | V4Cost0060 | 0.699 | -0.556 | 11.54 | -1.81 |
| 10017 | ForestGeometry | Risk-constrained-v5 | 0.699 | -0.556 | 11.54 | -1.81 |
| 10019 | ForestGeometry | V4Cost0060 | -0.333 | -0.366 | -13.97 | -0.13 |
| 10019 | ForestGeometry | Risk-constrained-v5 | -0.333 | -0.366 | -13.97 | -0.13 |

## Policy Diagnostics

| Scene | Config | Method | Direct Share | Redundant Share | Relay Share | Avg Tx Rate | Emergency Guard Share |
|---|---|---|---:|---:|---:|---:|---:|
| 10017 | Default | Confidence-heuristic | 0.923 | 0.077 | 0.000 | 2.311 | NaN |
| 10017 | Default | V4Cost0060 | 0.992 | 0.000 | 0.008 | 2.247 | NaN |
| 10017 | Default | Risk-constrained-v5 | 0.992 | 0.000 | 0.008 | 2.247 | 0.000 |
| 10017 | ForestGeometry | Confidence-heuristic | 0.899 | 0.101 | 0.000 | 2.462 | NaN |
| 10017 | ForestGeometry | V4Cost0060 | 0.792 | 0.208 | 0.000 | 2.570 | NaN |
| 10017 | ForestGeometry | Risk-constrained-v5 | 0.792 | 0.208 | 0.000 | 2.570 | 0.000 |
| 10019 | ForestGeometry | Confidence-heuristic | 0.829 | 0.171 | 0.000 | 3.039 | NaN |
| 10019 | ForestGeometry | V4Cost0060 | 0.848 | 0.152 | 0.000 | 2.609 | NaN |
| 10019 | ForestGeometry | Risk-constrained-v5 | 0.848 | 0.152 | 0.000 | 2.609 | 0.000 |
