# Step44 Threshold Validation Report

Purpose: test whether Step43 calibrated thresholds change or destabilize the proposed-method conclusion.

- Seeds per scene/config: 5
- Threshold table: `D:\matlab bussiness\forest_v2x_matlab_package\matlab_nav_sim\step43_threshold_calibration_5seed_threshold_table.csv`

## Applied Thresholds

| Parameter | Default | Recommended |
|---|---:|---:|
| `utility_required_timely_qpos_high_threshold` | 0.7500 | 0.8398 |
| `utility_required_timely_qpos_low_threshold` | 0.5000 | 0.6407 |
| `blind_zone_trigger_threshold` | 0.5500 | 0.2000 |
| `utility_required_protection_activation_pos` | 0.4500 | 0.6253 |
| `utility_required_protection_activation_blind` | 0.2200 | 0.1149 |

## Scene-Level Decision Table

| Scene | Config | Timely Cal-Default (pp) | Emg Cal-Default (pp) | Cost Cal-Default (%) | Worst Perturb Timely (pp) | Max Perturb Cost (%) | Stability |
|---|---|---:|---:|---:|---:|---:|---|
| 10014 | Default | 0.166 | 0.000 | 6.80 | -0.033 | 2.55 | Stable |
| 10014 | ForestGeometry | 0.166 | 0.000 | 5.56 | -0.100 | 2.15 | Stable |
| 10006 | Default | 0.067 | 0.000 | 1.06 | -0.067 | 0.08 | Stable |
| 10006 | ForestGeometry | 0.033 | 0.066 | 2.30 | -0.033 | 0.96 | Stable |
| 10011 | Default | 0.000 | 0.000 | 5.00 | 0.000 | 2.61 | Stable |
| 10011 | ForestGeometry | 0.133 | 0.000 | 4.06 | -0.100 | 1.25 | Stable |
| 10019 | Default | 0.000 | 0.000 | 0.86 | 0.000 | 0.98 | Stable |
| 10019 | ForestGeometry | -0.233 | -0.256 | 2.91 | 0.000 | 1.24 | Stable |
| 10017 | Default | 0.266 | 0.000 | 5.19 | -0.100 | 2.17 | Stable |
| 10017 | ForestGeometry | 0.200 | 0.000 | 11.10 | 0.000 | 2.10 | Stable |

## Interpretation Rule

`Stable` means the worst +/-10% threshold perturbation loses less than 1 percentage point TimelyRate and changes cost by less than 10%.
If many rows are `Sensitive`, keep default thresholds and report Step43 as exploratory calibration evidence only.
