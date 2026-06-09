# Step43 Threshold Calibration Report

Purpose: convert key scheduler thresholds from hand-set values into data-backed recommendations.

- Seeds per scene/config: 5
- Sample stride: 1
- This step writes evidence only; it does not modify the main parameter file.

## Recommended Thresholds

| Parameter | Default | Recommended | Score | Evidence |
|---|---:|---:|---:|---|
| `utility_required_timely_qpos_high_threshold` | 0.7500 | 0.8398 | 0.7597 | ROC/Youden threshold for reliable-position label using q_pos >= threshold. |
| `utility_required_timely_qpos_low_threshold` | 0.5000 | 0.6407 | 0.8031 | ROC/Youden threshold for degraded-position label using q_pos <= threshold. |
| `blind_zone_trigger_threshold` | 0.5500 | 0.2000 | 0.4106 | ROC/Youden threshold for high-blockage label using blind_zone >= threshold. |
| `utility_required_protection_activation_pos` | 0.4500 | 0.6253 | NaN | Lower-quartile position-risk level among degraded-position samples. |
| `utility_required_protection_activation_blind` | 0.2200 | 0.1149 | NaN | Lower-quartile excess-blindness level among high-blockage samples. |

## Diagnostics

| Diagnostic | Q25 | Median | Q75 | PositiveRate |
|---|---:|---:|---:|---:|
| QPos | 0.5504 | 0.7294 | 0.8770 | NaN |
| BlindZoneGate | 0.0000 | 0.0000 | 0.2574 | NaN |
| PositionSigma_m | 1.6461 | 1.9898 | 2.6096 | NaN |
| DOP | 1.6560 | 2.2900 | 3.2680 | NaN |
| NSat | 5.4800 | 7.6400 | 9.4720 | NaN |
| PDR | 0.8909 | 0.9990 | 0.9990 | NaN |
| DelayDeadlineRatio | 1.2672 | 1.4209 | 3.2711 | NaN |
| RequiredTimelyDefault | 0.4106 | 0.5082 | 0.5855 | NaN |
| RequiredProtectionDefault | 0.0000 | 0.0000 | 0.0000 | NaN |
| ReliablePosition | NaN | NaN | NaN | 0.1737 |
| DegradedPosition | NaN | NaN | NaN | 0.3045 |
| HighBlockage | NaN | NaN | NaN | 0.9115 |

## Interpretation

A threshold is credible only if Step44 shows that the calibrated value and its perturbations do not overturn the main conclusion.
Step43 provides provenance; Step44 provides robustness validation.
