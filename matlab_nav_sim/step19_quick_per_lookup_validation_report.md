# Step 19 PER Lookup Validation Report

This report compares the end-to-end scheduling results under two physical-layer PDR mappings:
- `sigmoid`: fitted approximation used by the original mainline
- `per_lookup`: direct interpolation of WiLabV2Xsim PER tables

The comparison is performed under the same random seeds, scenarios, and scheduling methods.

## Overall Delta Summary

| Config | Method | Metric | SigmoidMean | PerLookupMean | DeltaMean | DeltaCI95 | MaxAbsDelta |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Default | Confidence-driven | TimelyRate | 0.9695 | 0.9878 | 0.0183 | 0.003766 | 0.02163 |
| Default | Confidence-driven | LossRate | 0.0305 | 0.0122 | -0.0183 | 0.003766 | 0.02163 |
| Default | Confidence-driven | AvgDelay | 0.02416 | 0.02077 | -0.003397 | 0.001257 | 0.004521 |
| Default | Confidence-driven | AvgTxCost | 1.903 | 2.092 | 0.189 | 0.001773 | 0.1905 |
| Default | Confidence-driven | EmgTimely | 1 | 1 | 0 | 0 | 0 |
| ForestGeometry | Confidence-driven | TimelyRate | 0.7776 | 0.7898 | 0.0122 | 0.01037 | 0.0183 |
| ForestGeometry | Confidence-driven | LossRate | 0.2224 | 0.2102 | -0.0122 | 0.01037 | 0.0183 |
| ForestGeometry | Confidence-driven | AvgDelay | 0.09102 | 0.08503 | -0.005992 | 0.005066 | 0.008736 |
| ForestGeometry | Confidence-driven | AvgTxCost | 2.166 | 2.062 | -0.104 | 0.005651 | 0.1097 |
| ForestGeometry | Confidence-driven | EmgTimely | 0 | 0 | 0 | 0 | 0 |

## PosDeg_Emerg Delta Summary

| Config | Method | Metric | SigmoidMean | PerLookupMean | DeltaMean | DeltaCI95 | MaxAbsDelta |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Default | Confidence-driven | TimelyRate | 1 | 1 | 0 | 0 | 0 |
| Default | Confidence-driven | LossRate | 0 | 0 | 0 | 0 | 0 |
| Default | Confidence-driven | AvgDelay | 0.01383 | 0.01474 | 0.0009096 | 0.0002472 | 0.001155 |
| Default | Confidence-driven | AvgTxCost | 3.352 | 3.355 | 0.002818 | 0.005524 | 0.008455 |
| Default | Confidence-driven | EmgTimely | 1 | 1 | 0 | 0 | 0 |
| ForestGeometry | Confidence-driven | TimelyRate | 0.8303 | 0.8333 | 0.00303 | 0.005939 | 0.009091 |
| ForestGeometry | Confidence-driven | LossRate | 0.1697 | 0.1667 | -0.00303 | 0.005939 | 0.009091 |
| ForestGeometry | Confidence-driven | AvgDelay | 0.01307 | 0.01275 | -0.0003217 | 0.0001027 | 0.0004265 |
| ForestGeometry | Confidence-driven | AvgTxCost | 3.603 | 3.601 | -0.002121 | 0.004158 | 0.006364 |
| ForestGeometry | Confidence-driven | EmgTimely | 0 | 0 | 0 | 0 | 0 |

## Overall Significance

| Config | Metric | Baseline_Mean | Baseline_Std | Proposed_Mean | Proposed_Std | Delta_Mean | CI_Lower | CI_Upper | P_Value | Significant |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Default | TimelyRate | 0.9695 | 0.005843 | 0.9878 | 0.002542 | 0.0183 | 0.0153 | 0.02131 | 0 | *** |
| Default | LossRate | 0.0305 | 0.005843 | 0.0122 | 0.002542 | -0.0183 | -0.02131 | -0.0153 | 0 | *** |
| Default | AvgDelay | 0.02416 | 0.002296 | 0.02077 | 0.001281 | -0.003397 | -0.004401 | -0.002393 | 1.191e-07 | *** |
| Default | AvgTxCost | 1.903 | 0.01407 | 2.092 | 0.01373 | 0.189 | 0.1876 | 0.1904 | 0 | *** |
| Default | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 1 | n.s. |
| ForestGeometry | TimelyRate | 0.7776 | 0.008375 | 0.7898 | 0.004803 | 0.0122 | 0.00392 | 0.02048 | 0.0211 | * |
| ForestGeometry | LossRate | 0.2224 | 0.008375 | 0.2102 | 0.004803 | -0.0122 | -0.02048 | -0.00392 | 0.0211 | * |
| ForestGeometry | AvgDelay | 0.09102 | 0.003012 | 0.08503 | 0.002201 | -0.005992 | -0.01004 | -0.001946 | 0.02045 | * |
| ForestGeometry | AvgTxCost | 2.166 | 0.04017 | 2.062 | 0.04077 | -0.104 | -0.1085 | -0.09944 | 0 | *** |
| ForestGeometry | EmgTimely | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | n.s. |

## PosDeg_Emerg Significance

| Config | Metric | Baseline_Mean | Baseline_Std | Proposed_Mean | Proposed_Std | Delta_Mean | CI_Lower | CI_Upper | P_Value | Significant |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Default | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 1 | n.s. |
| Default | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | n.s. |
| Default | AvgDelay | 0.01383 | 0.0004981 | 0.01474 | 0.0006931 | 0.0009096 | 0.0007121 | 0.001107 | 5.564e-13 | *** |
| Default | AvgTxCost | 3.352 | 0.1198 | 3.355 | 0.1154 | 0.002818 | -0.001593 | 0.00723 | 0.3173 | n.s. |
| Default | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 1 | n.s. |
| ForestGeometry | TimelyRate | 0.8303 | 0.005249 | 0.8333 | 0.005249 | 0.00303 | -0.001713 | 0.007774 | 0.3173 | n.s. |
| ForestGeometry | LossRate | 0.1697 | 0.005249 | 0.1667 | 0.005249 | -0.00303 | -0.007774 | 0.001713 | 0.3173 | n.s. |
| ForestGeometry | AvgDelay | 0.01307 | 0.0004051 | 0.01275 | 0.00032 | -0.0003217 | -0.0004038 | -0.0002397 | 8.393e-10 | *** |
| ForestGeometry | AvgTxCost | 3.603 | 0.1425 | 3.601 | 0.1414 | -0.002121 | -0.005442 | 0.001199 | 0.3173 | n.s. |
| ForestGeometry | EmgTimely | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | n.s. |

## Interpretation

- If the absolute deltas remain small while significance is weak, the sigmoid approximation is acceptable for mainline experimentation.
- If the key-stage deltas remain limited, the approximation error does not materially alter the scheduling conclusion.
- If large deltas appear in `ForestGeometry` or `PosDeg_Emerg`, the final paper should prefer `per_lookup` or explicitly report the approximation bias.
