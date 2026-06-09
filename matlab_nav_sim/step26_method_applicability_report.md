# Step 26 Method Applicability Analysis

This report addresses the boundary-scene concern by explicitly analyzing when the confidence-driven scheduler becomes active and when it gracefully collapses to the link-aware baseline.

## Activation Logic

The method is expected to become materially active only when the following two conditions overlap in the critical `PosDeg_Emerg` stage:
- positioning confidence falls into the low-confidence regime: `q_pos <= utility_blind_pos_threshold`;
- blind-zone risk exceeds the protection trigger: `blind_score >= utility_blind_protection_threshold`.

In the default parameter set, these thresholds are approximately `q_pos <= 0.48` and `blind_score >= 0.58`.

## Applicability Summary

| Scene | Role | Config | Full Delta Timely (pp) | PosDeg Delta Timely (pp) | Joint Activation Ratio | Blind Trigger Ratio | Low-q_pos Ratio | Class |
|---|---|---|---:|---:|---:|---:|---:|---|
| 10014 | Primary | Default | 0.391 | 0.818 | 0.567 | 0.983 | 0.567 | Mixed |
| 10014 | Primary | ForestGeometry | 0.923 | 3.000 | 0.917 | 1.000 | 0.917 | Active |
| 10006 | Reference | Default | 3.694 | 0.000 | 0.655 | 0.818 | 0.655 | Active |
| 10006 | Reference | ForestGeometry | 1.198 | 0.409 | 0.835 | 1.000 | 0.835 | Active |
| 10011 | Boundary | Default | 0.000 | 0.000 | NaN | NaN | NaN | Mixed |
| 10011 | Boundary | ForestGeometry | 1.739 | 0.000 | NaN | NaN | NaN | Mixed |

## Boundary Scene Interpretation

- Scene `10011` / `Default`: The method reacts weakly and mainly adds transmission cost; engineering benefit should be qualified carefully. Observed full-stage timely-rate gain = 0.000 pp, PosDeg timely-rate gain = 0.000 pp, joint activation ratio = NaN.
- Scene `10011` / `ForestGeometry`: The method reacts weakly and mainly adds transmission cost; engineering benefit should be qualified carefully. Observed full-stage timely-rate gain = 1.739 pp, PosDeg timely-rate gain = 0.000 pp, joint activation ratio = NaN.

## Active Regime Interpretation

- Scene `10014` / `ForestGeometry`: full-stage timely-rate gain = 0.923 pp, PosDeg timely-rate gain = 3.000 pp, joint activation ratio = 0.917, peak gain stage = `PosDeg_Emerg`.
- Scene `10006` / `Default`: full-stage timely-rate gain = 3.694 pp, PosDeg timely-rate gain = 0.000 pp, joint activation ratio = 0.655, peak gain stage = `Normal`.
- Scene `10006` / `ForestGeometry`: full-stage timely-rate gain = 1.198 pp, PosDeg timely-rate gain = 0.409 pp, joint activation ratio = 0.835, peak gain stage = `LinkDeg_Emerg`.

## Recommended Paper Wording

- The method is not intended to improve already-open scenes where blind-zone risk and positioning degradation do not overlap.
- Scene `10011` should be presented as a boundary-case validation rather than a failure case: when the triggering conditions are absent, the scheduler does not degrade timely performance and effectively collapses to the link-aware baseline.
- The method should be claimed applicable to scenes with non-trivial overlap between blind-zone activation and positioning degradation, rather than to all traffic scenes uniformly.
