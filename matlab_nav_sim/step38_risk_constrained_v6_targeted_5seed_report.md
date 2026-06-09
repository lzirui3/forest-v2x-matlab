# Step 38 Risk-Constrained V6 Targeted Validation Report

Step38 tests explicit emergency action floors on top of the Step36-selected actual-cost weight (`0.060`).

## Method Score

| Method | Mean Timely Gap (pp) | Mean Emg Gap (pp) | Mean Cost Delta (%) | 10017 Default Emg Gap (pp) | 10017 Forest Cost Delta (%) | 10019 Forest Timely Gap (pp) | Status |
|---|---:|---:|---:|---:|---:|---:|---|
| V4Cost0060 | 0.266 | -0.492 | -2.28 | -0.556 | 11.54 | -0.333 | NeedsCalibration |
| Risk-constrained-v6 | 0.399 | -0.024 | 2.89 | 0.000 | 12.90 | -0.067 | Step38Candidate |

## Per-Case Decision Table

| Scene | Config | Method | Timely Gap (pp) | Emg Gap (pp) | Cost Delta (%) | Delay Delta (%) |
|---|---|---|---:|---:|---:|---:|
| 10017 | Default | V4Cost0060 | 0.433 | -0.556 | -4.41 | -7.41 |
| 10017 | Default | Risk-constrained-v6 | 0.532 | 0.000 | -2.89 | -8.61 |
| 10017 | ForestGeometry | V4Cost0060 | 0.699 | -0.556 | 11.54 | -1.81 |
| 10017 | ForestGeometry | Risk-constrained-v6 | 0.732 | 0.000 | 12.90 | -1.80 |
| 10019 | ForestGeometry | V4Cost0060 | -0.333 | -0.366 | -13.97 | -0.13 |
| 10019 | ForestGeometry | Risk-constrained-v6 | -0.067 | -0.073 | -1.35 | 0.03 |

## Policy Diagnostics

| Scene | Config | Method | Direct Share | Redundant Share | Relay Share | Avg Tx Rate | Emergency Floor Share |
|---|---|---|---:|---:|---:|---:|---:|
| 10017 | Default | Confidence-heuristic | 0.923 | 0.077 | 0.000 | 2.311 | NaN |
| 10017 | Default | V4Cost0060 | 0.992 | 0.000 | 0.008 | 2.247 | NaN |
| 10017 | Default | Risk-constrained-v6 | 0.992 | 0.000 | 0.008 | 2.283 | 0.060 |
| 10017 | ForestGeometry | Confidence-heuristic | 0.899 | 0.101 | 0.000 | 2.462 | NaN |
| 10017 | ForestGeometry | V4Cost0060 | 0.792 | 0.208 | 0.000 | 2.570 | NaN |
| 10017 | ForestGeometry | Risk-constrained-v6 | 0.792 | 0.208 | 0.000 | 2.606 | 0.060 |
| 10019 | ForestGeometry | Confidence-heuristic | 0.829 | 0.171 | 0.000 | 3.039 | NaN |
| 10019 | ForestGeometry | V4Cost0060 | 0.848 | 0.152 | 0.000 | 2.609 | NaN |
| 10019 | ForestGeometry | Risk-constrained-v6 | 0.856 | 0.144 | 0.000 | 3.045 | 0.908 |
