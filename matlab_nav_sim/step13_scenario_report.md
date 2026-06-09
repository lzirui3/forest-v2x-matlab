# Step 13 Scenario Expansion Report

## Scope

- GNSS degradation levels: Weak, Medium, Strong
- RSU sparsity levels: Sparse, Medium, Dense
- Message load levels: Low, Medium, High
- Seeds per scenario: 6

## Scenario Summary Table

| Scenario | GNSS | RSU | Load | Full Emergency Timely | Link-Aware Emergency Timely | Gain | Full Effective Warning | Link-Aware Effective Warning | Effective Gain |
|---|---|---|---|---:|---:|---:|---:|---:|---:|
| GW_RS_LL | Weak | Sparse | Low | 1.000 | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 |
| GW_RS_LM | Weak | Sparse | Medium | 1.000 | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 |
| GW_RS_LH | Weak | Sparse | High | 1.000 | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 |
| GW_RM_LL | Weak | Medium | Low | 1.000 | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 |
| GW_RM_LM | Weak | Medium | Medium | 1.000 | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 |
| GW_RM_LH | Weak | Medium | High | 1.000 | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 |
| GW_RD_LL | Weak | Dense | Low | 1.000 | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 |
| GW_RD_LM | Weak | Dense | Medium | 1.000 | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 |
| GW_RD_LH | Weak | Dense | High | 1.000 | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 |
| GM_RS_LL | Medium | Sparse | Low | 1.000 | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 |
| GM_RS_LM | Medium | Sparse | Medium | 1.000 | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 |
| GM_RS_LH | Medium | Sparse | High | 1.000 | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 |
| GM_RM_LL | Medium | Medium | Low | 1.000 | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 |
| GM_RM_LM | Medium | Medium | Medium | 1.000 | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 |
| GM_RM_LH | Medium | Medium | High | 1.000 | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 |
| GM_RD_LL | Medium | Dense | Low | 1.000 | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 |
| GM_RD_LM | Medium | Dense | Medium | 1.000 | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 |
| GM_RD_LH | Medium | Dense | High | 1.000 | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 |
| GS_RS_LL | Strong | Sparse | Low | 1.000 | 1.000 | 0.000 | NaN | NaN | NaN |
| GS_RS_LM | Strong | Sparse | Medium | 1.000 | 1.000 | 0.000 | NaN | NaN | NaN |
| GS_RS_LH | Strong | Sparse | High | 1.000 | 1.000 | 0.000 | NaN | NaN | NaN |
| GS_RM_LL | Strong | Medium | Low | 1.000 | 1.000 | 0.000 | NaN | NaN | NaN |
| GS_RM_LM | Strong | Medium | Medium | 1.000 | 1.000 | 0.000 | NaN | NaN | NaN |
| GS_RM_LH | Strong | Medium | High | 1.000 | 1.000 | 0.000 | NaN | NaN | NaN |
| GS_RD_LL | Strong | Dense | Low | 1.000 | 1.000 | 0.000 | NaN | NaN | NaN |
| GS_RD_LM | Strong | Dense | Medium | 1.000 | 1.000 | 0.000 | NaN | NaN | NaN |
| GS_RD_LH | Strong | Dense | High | 1.000 | 1.000 | 0.000 | NaN | NaN | NaN |

Note: `Effective Warning` is defined only on `PosDeg_Emerg` emergency samples with `q_{pos} >= 0.50`. If scenario coverage collapses to zero, the rate is reported as `NaN` because no valid high-confidence warning samples remain.

## Key Observation

- Largest overall emergency-timely gain: **0.000** in scenario `GW_RS_LL`.
- Largest `PosDeg_Emerg` emergency-timely gain: **0.000** in scenario `GW_RS_LL`.
- Largest effective-warning gain under `q_{pos}` constraint: **0.000** in scenario `GW_RS_LL`.
- Best overall-gain scenario condition: GNSS=`Weak`, RSU=`Sparse`, Load=`Low`.
- Best critical-stage-gain scenario condition: GNSS=`Weak`, RSU=`Sparse`, Load=`Low`.
- Best effective-warning-gain scenario condition: GNSS=`Weak`, RSU=`Sparse`, Load=`Low`.
- This report is intended to show whether the proposed method remains beneficial under varying localization degradation, sparse V2I support, and communication load conditions.
