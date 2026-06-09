# Step45 Parameter Credibility Closure Report

Purpose: close the project-level credibility gap for hand-set thresholds and method parameters before paper writing.

## 1. Evidence Status

| Evidence block | Status | Artifact |
|---|---|---|
| Formal main-result run | Closed | `step40_proposed_method_vtc_50seed_*` |
| Parameter layer audit | Closed | `step41_parameter_audit_table.csv` |
| Core parameter family sensitivity | Closed | `step42_core_parameter_sensitivity_*` |
| Threshold data calibration | Closed | `step43_threshold_calibration_5seed_*` |
| Threshold perturbation validation | Closed | `step44_threshold_validation_5seed_*` |

## 2. Parameter Audit Summary

| Priority | Layer | Count |
|---|---|---:|
| P0 | Core-method | 23 |
| P1 | Core-method | 7 |
| P1 | Scenario-definition | 8 |
| P1 | Simulation-environment | 40 |
| P2 | State-estimation-input | 37 |
| P3 | Baseline-only | 13 |
| P3 | Scenario-definition | 16 |
| P4 | Deprecated-or-legacy | 151 |

Interpretation: the project does not need to justify all parameters equally. The immediate credibility burden is concentrated on 23 P0 core-method parameters.

## 3. Threshold Calibration Result

| Parameter | Default | Calibrated | Delta | Calibration score |
|---|---:|---:|---:|---:|
| `utility_required_timely_qpos_high_threshold` | 0.7500 | 0.8398 | 0.0898 | 0.7597 |
| `utility_required_timely_qpos_low_threshold` | 0.5000 | 0.6407 | 0.1407 | 0.8031 |
| `blind_zone_trigger_threshold` | 0.5500 | 0.2000 | -0.3500 | 0.4106 |
| `utility_required_protection_activation_pos` | 0.4500 | 0.6253 | 0.1753 | NaN |
| `utility_required_protection_activation_blind` | 0.2200 | 0.1149 | -0.1051 | NaN |

Interpretation: Step43 converts key thresholds from pure defaults into data-backed candidates. The calibrated values should not automatically replace defaults unless Step44 shows stable behavior.

## 4. Threshold Validation Result

| Scene | Config | Timely delta calibrated-default (pp) | Emergency delta (pp) | Cost delta (%) | Worst perturb timely (pp) | Stability |
|---|---|---:|---:|---:|---:|---|
| 10014 | Default | 0.166 | 0.000 | 6.80 | -0.033 | Stable |
| 10014 | ForestGeometry | 0.166 | 0.000 | 5.56 | -0.100 | Stable |
| 10006 | Default | 0.067 | 0.000 | 1.06 | -0.067 | Stable |
| 10006 | ForestGeometry | 0.033 | 0.066 | 2.30 | -0.033 | Stable |
| 10011 | Default | 0.000 | 0.000 | 5.00 | 0.000 | Stable |
| 10011 | ForestGeometry | 0.133 | 0.000 | 4.06 | -0.100 | Stable |
| 10019 | Default | 0.000 | 0.000 | 0.86 | 0.000 | Stable |
| 10019 | ForestGeometry | -0.233 | -0.256 | 2.91 | 0.000 | Stable |
| 10017 | Default | 0.266 | 0.000 | 5.19 | -0.100 | Stable |
| 10017 | ForestGeometry | 0.200 | 0.000 | 11.10 | 0.000 | Stable |

Result: 10/10 scene-config rows are marked `Stable` under calibrated thresholds and +/-10% perturbations.

Caution rows where calibrated thresholds reduce timely or emergency performance:

| Scene | Config | Timely delta (pp) | Emergency delta (pp) |
|---|---|---:|---:|
| 10019 | ForestGeometry | -0.233 | -0.256 |

These rows mean Step44 should be claimed as robustness evidence, not as proof that calibrated thresholds always improve performance.

## 5. Link to Formal Main Results

Step40 provides the formal 50-seed main-result chain. Step43/44 do not replace Step40; they explain and stress-test the threshold choices used by the main method.

| Scene | Config | Decision |
|---|---|---|
| 10014 | Default | MainCandidate |
| 10014 | ForestGeometry | MainCandidate |
| 10006 | Default | MainCandidate |
| 10006 | ForestGeometry | MainCandidate |
| 10011 | Default | MainCandidate |
| 10011 | ForestGeometry | MainCandidate |
| 10019 | Default | MainCandidate |
| 10019 | ForestGeometry | MainCandidate |
| 10017 | Default | MainCandidate |
| 10017 | ForestGeometry | MainCandidate |

## 6. Remaining Parameter-Credibility Gaps

- Calibrated thresholds can increase cost by more than 10% in at least one row; cost-efficiency discussion is required if calibrated thresholds are used as the main setting.
- Step43 high-blockage labeling uses a broad rule: NLOS, PDR <= 0.70, or delay exceeding deadline. If reviewers challenge this, add a stricter alternative label and repeat Step43/44.
- Current recommendation: keep default thresholds for the main Step40 result, and use Step43/44 as evidence that conclusions are not brittle to data-backed threshold perturbations.

## 7. Project-Level Conclusion

The parameter-credibility issue is closed at the current VTC-project level: core parameters are audited, core parameter families have sensitivity evidence, and key thresholds have both data-backed calibration and perturbation validation. Remaining issues are discussion-level caveats, not missing evidence blocks.
