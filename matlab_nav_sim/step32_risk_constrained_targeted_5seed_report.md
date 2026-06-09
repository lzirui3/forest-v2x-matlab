# Step 32 Risk-Constrained Targeted Sweep Report

This experiment targets two Step31 issues: emergency timely loss in `10017 Default` and excessive cost in `10017 ForestGeometry`. `10019 ForestGeometry` is included as a boundary guard because Step31 was only comparable there.

## Candidate Score

| Candidate | Mean Timely Gap (pp) | Mean Emg Gap (pp) | Mean Cost Delta (%) | 10017 Default Emg Gap (pp) | 10017 Forest Cost Delta (%) | 10019 Forest Timely Gap (pp) | Status |
|---|---:|---:|---:|---:|---:|---:|---|
| RiskEmgGuard | 0.843 | -0.492 | 11.22 | -0.556 | 46.47 | -0.333 | NeedsCalibration |
| RiskBase | 0.821 | -0.468 | 11.11 | -0.556 | 46.47 | -0.266 | NeedsCalibration |
| RiskBal075 | 0.732 | -0.492 | 9.52 | -0.556 | 45.03 | -0.333 | NeedsCalibration |
| RiskBal095 | 0.643 | -0.480 | 8.74 | -0.556 | 44.43 | -0.300 | NeedsCalibration |
| RiskCost075 | 0.666 | -0.505 | 9.38 | -0.556 | 44.95 | -0.366 | NeedsCalibration |
| RiskCost095 | 0.588 | -0.505 | 8.63 | -0.556 | 44.42 | -0.366 | NeedsCalibration |

## Per-Case Decision Table

| Scene | Config | Candidate | Timely Gap (pp) | Emg Gap (pp) | Cost Delta (%) | Delay Delta (%) |
|---|---|---|---:|---:|---:|---:|
| 10017 | Default | RiskBase | 1.131 | -0.556 | 0.16 | -11.59 |
| 10017 | Default | RiskCost075 | 0.765 | -0.556 | -3.01 | -8.99 |
| 10017 | Default | RiskCost095 | 0.532 | -0.556 | -4.43 | -5.43 |
| 10017 | Default | RiskEmgGuard | 1.265 | -0.556 | 0.53 | -12.60 |
| 10017 | Default | RiskBal075 | 0.932 | -0.556 | -2.69 | -10.29 |
| 10017 | Default | RiskBal095 | 0.632 | -0.556 | -4.18 | -8.25 |
| 10017 | ForestGeometry | RiskBase | 1.597 | -0.556 | 46.47 | -2.59 |
| 10017 | ForestGeometry | RiskCost075 | 1.597 | -0.556 | 44.95 | -2.59 |
| 10017 | ForestGeometry | RiskCost095 | 1.597 | -0.556 | 44.42 | -2.59 |
| 10017 | ForestGeometry | RiskEmgGuard | 1.597 | -0.556 | 46.47 | -2.59 |
| 10017 | ForestGeometry | RiskBal075 | 1.597 | -0.556 | 45.03 | -2.59 |
| 10017 | ForestGeometry | RiskBal095 | 1.597 | -0.556 | 44.43 | -2.59 |
| 10019 | Default | RiskBase | NaN | NaN | NaN | NaN |
| 10019 | Default | RiskCost075 | NaN | NaN | NaN | NaN |
| 10019 | Default | RiskCost095 | NaN | NaN | NaN | NaN |
| 10019 | Default | RiskEmgGuard | NaN | NaN | NaN | NaN |
| 10019 | Default | RiskBal075 | NaN | NaN | NaN | NaN |
| 10019 | Default | RiskBal095 | NaN | NaN | NaN | NaN |
| 10019 | ForestGeometry | RiskBase | -0.266 | -0.293 | -13.29 | -0.04 |
| 10019 | ForestGeometry | RiskCost075 | -0.366 | -0.403 | -13.79 | -0.08 |
| 10019 | ForestGeometry | RiskCost095 | -0.366 | -0.403 | -14.09 | -0.14 |
| 10019 | ForestGeometry | RiskEmgGuard | -0.333 | -0.366 | -13.35 | -0.02 |
| 10019 | ForestGeometry | RiskBal075 | -0.333 | -0.366 | -13.78 | -0.08 |
| 10019 | ForestGeometry | RiskBal095 | -0.300 | -0.330 | -14.03 | -0.14 |

## Guard Rules

- `EmgGuard`: `10017 Default` emergency timely gap must be at least -0.25 pp.
- `CostGuard`: `10017 ForestGeometry` cost delta must not exceed 30%.
- `BoundaryGuard`: `10019 ForestGeometry` timely and emergency gaps must both be at least -0.50 pp.
- `TimelyGuard`: no targeted case may lose more than 0.50 pp timely rate.
