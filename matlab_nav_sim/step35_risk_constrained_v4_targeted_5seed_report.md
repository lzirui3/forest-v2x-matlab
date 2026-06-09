# Step 35 Risk-Constrained V4 Targeted Validation Report

Step35 tests an actual-cost aligned risk objective. The communication cost used inside the objective is changed from relative rate multiplier cost to the same `mode_cost * tx_rate` metric used by physical delivery evaluation.

## Method Score

| Method | Mean Timely Gap (pp) | Mean Emg Gap (pp) | Mean Cost Delta (%) | 10017 Default Emg Gap (pp) | 10017 Forest Cost Delta (%) | 10019 Forest Timely Gap (pp) | Status |
|---|---:|---:|---:|---:|---:|---:|---|
| Risk-constrained-v3 | 0.843 | -0.468 | 11.09 | -0.556 | 46.47 | -0.266 | NeedsCalibration |
| Risk-constrained-v4 | 0.799 | -0.444 | 10.95 | -0.556 | 46.12 | -0.200 | NeedsCalibration |
| Risk-constrained | 0.821 | -0.468 | 11.11 | -0.556 | 46.47 | -0.266 | NeedsCalibration |
| Risk-constrained-v2 | -0.876 | -0.024 | 9.40 | 0.000 | 43.07 | -0.067 | Reject |

## Per-Case Decision Table

| Scene | Config | Method | Timely Gap (pp) | Emg Gap (pp) | Cost Delta (%) | Delay Delta (%) |
|---|---|---|---:|---:|---:|---:|
| 10017 | Default | Risk-constrained | 1.131 | -0.556 | 0.16 | -11.59 |
| 10017 | Default | Risk-constrained-v2 | -4.193 | 0.000 | -13.88 | 39.84 |
| 10017 | Default | Risk-constrained-v3 | 1.198 | -0.556 | 0.09 | -13.15 |
| 10017 | Default | Risk-constrained-v4 | 0.998 | -0.556 | -0.21 | -12.36 |
| 10017 | ForestGeometry | Risk-constrained | 1.597 | -0.556 | 46.47 | -2.59 |
| 10017 | ForestGeometry | Risk-constrained-v2 | 1.631 | 0.000 | 43.07 | -2.42 |
| 10017 | ForestGeometry | Risk-constrained-v3 | 1.597 | -0.556 | 46.47 | -2.59 |
| 10017 | ForestGeometry | Risk-constrained-v4 | 1.597 | -0.556 | 46.12 | -2.59 |
| 10019 | Default | Risk-constrained | NaN | NaN | NaN | NaN |
| 10019 | Default | Risk-constrained-v2 | NaN | NaN | NaN | NaN |
| 10019 | Default | Risk-constrained-v3 | NaN | NaN | NaN | NaN |
| 10019 | Default | Risk-constrained-v4 | NaN | NaN | NaN | NaN |
| 10019 | ForestGeometry | Risk-constrained | -0.266 | -0.293 | -13.29 | -0.04 |
| 10019 | ForestGeometry | Risk-constrained-v2 | -0.067 | -0.073 | -0.99 | 0.13 |
| 10019 | ForestGeometry | Risk-constrained-v3 | -0.266 | -0.293 | -13.29 | -0.04 |
| 10019 | ForestGeometry | Risk-constrained-v4 | -0.200 | -0.220 | -13.07 | -0.04 |

## Policy Diagnostics

| Scene | Config | Method | Direct Share | Redundant Share | Relay Share | Avg Tx Rate |
|---|---|---|---:|---:|---:|---:|
| 10017 | Default | Confidence-heuristic | 0.923 | 0.077 | 0.000 | 2.311 |
| 10017 | Default | Risk-constrained | 0.990 | 0.000 | 0.010 | 2.348 |
| 10017 | Default | Risk-constrained-v2 | 0.976 | 0.024 | 0.000 | 2.001 |
| 10017 | Default | Risk-constrained-v3 | 1.000 | 0.000 | 0.000 | 2.360 |
| 10017 | Default | Risk-constrained-v4 | 0.987 | 0.000 | 0.013 | 2.341 |
| 10017 | ForestGeometry | Confidence-heuristic | 0.899 | 0.101 | 0.000 | 2.462 |
| 10017 | ForestGeometry | Risk-constrained | 0.575 | 0.425 | 0.000 | 2.951 |
| 10017 | ForestGeometry | Risk-constrained-v2 | 0.558 | 0.442 | 0.000 | 2.840 |
| 10017 | ForestGeometry | Risk-constrained-v3 | 0.575 | 0.425 | 0.000 | 2.951 |
| 10017 | ForestGeometry | Risk-constrained-v4 | 0.575 | 0.425 | 0.000 | 2.941 |
| 10019 | ForestGeometry | Confidence-heuristic | 0.829 | 0.171 | 0.000 | 3.039 |
| 10019 | ForestGeometry | Risk-constrained | 0.839 | 0.161 | 0.000 | 2.615 |
| 10019 | ForestGeometry | Risk-constrained-v2 | 0.849 | 0.151 | 0.000 | 3.045 |
| 10019 | ForestGeometry | Risk-constrained-v3 | 0.839 | 0.161 | 0.000 | 2.615 |
| 10019 | ForestGeometry | Risk-constrained-v4 | 0.837 | 0.163 | 0.000 | 2.619 |

## Guard Rules

- `EmgGuard`: `10017 Default` emergency timely gap must be at least -0.25 pp.
- `CostGuard`: `10017 ForestGeometry` cost delta must not exceed 30%.
- `BoundaryGuard`: `10019 ForestGeometry` timely and emergency gaps must both be at least -0.50 pp.
- `TimelyGuard`: no targeted case may lose more than 0.50 pp timely rate.
