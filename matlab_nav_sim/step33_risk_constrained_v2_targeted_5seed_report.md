# Step 33 Risk-Constrained V2 Targeted Validation Report

Step33 tests a structural selector change instead of another scalar weight sweep. The v2 selector first seeks actions satisfying timely, success, protection, and deadline constraints, then picks the minimum actual transmission-cost action in that feasible set. Fallback to the Step31 Lagrangian objective is used only when no feasible action exists.

## Method Score

| Method | Mean Timely Gap (pp) | Mean Emg Gap (pp) | Mean Cost Delta (%) | 10017 Default Emg Gap (pp) | 10017 Forest Cost Delta (%) | 10019 Forest Timely Gap (pp) | Status |
|---|---:|---:|---:|---:|---:|---:|---|
| Risk-constrained | 0.821 | -0.468 | 11.11 | -0.556 | 46.47 | -0.266 | NeedsCalibration |
| Risk-constrained-v2 | -0.876 | -0.024 | 9.40 | 0.000 | 43.07 | -0.067 | Reject |

## Per-Case Decision Table

| Scene | Config | Method | Timely Gap (pp) | Emg Gap (pp) | Cost Delta (%) | Delay Delta (%) |
|---|---|---|---:|---:|---:|---:|
| 10017 | Default | Risk-constrained | 1.131 | -0.556 | 0.16 | -11.59 |
| 10017 | Default | Risk-constrained-v2 | -4.193 | 0.000 | -13.88 | 39.84 |
| 10017 | ForestGeometry | Risk-constrained | 1.597 | -0.556 | 46.47 | -2.59 |
| 10017 | ForestGeometry | Risk-constrained-v2 | 1.631 | 0.000 | 43.07 | -2.42 |
| 10019 | Default | Risk-constrained | NaN | NaN | NaN | NaN |
| 10019 | Default | Risk-constrained-v2 | NaN | NaN | NaN | NaN |
| 10019 | ForestGeometry | Risk-constrained | -0.266 | -0.293 | -13.29 | -0.04 |
| 10019 | ForestGeometry | Risk-constrained-v2 | -0.067 | -0.073 | -0.99 | 0.13 |

## Policy Diagnostics

| Scene | Config | Method | Direct Share | Redundant Share | Relay Share | Avg Tx Rate | Safe-Min-Cost Share |
|---|---|---|---:|---:|---:|---:|---:|
| 10017 | Default | Confidence-heuristic | 0.923 | 0.077 | 0.000 | 2.311 | NaN |
| 10017 | Default | Risk-constrained | 0.990 | 0.000 | 0.010 | 2.348 | NaN |
| 10017 | Default | Risk-constrained-v2 | 0.976 | 0.024 | 0.000 | 2.001 | 1.000 |
| 10017 | ForestGeometry | Confidence-heuristic | 0.899 | 0.101 | 0.000 | 2.462 | NaN |
| 10017 | ForestGeometry | Risk-constrained | 0.575 | 0.425 | 0.000 | 2.951 | NaN |
| 10017 | ForestGeometry | Risk-constrained-v2 | 0.558 | 0.442 | 0.000 | 2.840 | 0.516 |
| 10019 | ForestGeometry | Confidence-heuristic | 0.829 | 0.171 | 0.000 | 3.039 | NaN |
| 10019 | ForestGeometry | Risk-constrained | 0.839 | 0.161 | 0.000 | 2.615 | NaN |
| 10019 | ForestGeometry | Risk-constrained-v2 | 0.849 | 0.151 | 0.000 | 3.045 | 0.566 |

## Guard Rules

- `EmgGuard`: `10017 Default` emergency timely gap must be at least -0.25 pp.
- `CostGuard`: `10017 ForestGeometry` cost delta must not exceed 30%.
- `BoundaryGuard`: `10019 ForestGeometry` timely and emergency gaps must both be at least -0.50 pp.
- `TimelyGuard`: no targeted case may lose more than 0.50 pp timely rate.
