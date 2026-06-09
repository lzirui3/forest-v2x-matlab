# Step 19 PER Lookup Validation Report

This report compares the end-to-end scheduling results under two physical-layer PDR mappings:
- `sigmoid`: fitted approximation used by the original mainline
- `per_lookup`: direct interpolation of WiLabV2Xsim PER tables

The comparison is performed under the same random seeds, scenarios, and scheduling methods.

## Overall Delta Summary

| Config | Method | Metric | SigmoidMean | PerLookupMean | DeltaMean | DeltaCI95 | MaxAbsDelta |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Default | Confidence-driven | TimelyRate | 0.9709 | 0.9857 | 0.01481 | 0.003963 | 0.02496 |
| Default | Confidence-driven | LossRate | 0.02912 | 0.01431 | -0.01481 | 0.003963 | 0.02496 |
| Default | Confidence-driven | AvgDelay | 0.02424 | 0.0216 | -0.002641 | 0.001683 | 0.007368 |
| Default | Confidence-driven | AvgTxCost | 1.905 | 2.094 | 0.1888 | 0.002173 | 0.1943 |
| Default | Confidence-driven | EmgTimely | 1 | 0.9833 | -0.01667 | 0.03267 | 0.1667 |
| ForestGeometry | Confidence-driven | TimelyRate | 0.7705 | 0.7882 | 0.01764 | 0.004514 | 0.02995 |
| ForestGeometry | Confidence-driven | LossRate | 0.2293 | 0.2116 | -0.01764 | 0.004514 | 0.02995 |
| ForestGeometry | Confidence-driven | AvgDelay | 0.09352 | 0.0852 | -0.008321 | 0.001957 | 0.01288 |
| ForestGeometry | Confidence-driven | AvgTxCost | 2.17 | 2.067 | -0.1032 | 0.001794 | 0.1097 |
| ForestGeometry | Confidence-driven | EmgTimely | 0.01667 | 0.01667 | 0 | 0 | 0 |

## PosDeg_Emerg Delta Summary

| Config | Method | Metric | SigmoidMean | PerLookupMean | DeltaMean | DeltaCI95 | MaxAbsDelta |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Default | Confidence-driven | TimelyRate | 1 | 0.9982 | -0.001818 | 0.002376 | 0.009091 |
| Default | Confidence-driven | LossRate | 0 | 0.001818 | 0.001818 | 0.002376 | 0.009091 |
| Default | Confidence-driven | AvgDelay | 0.0136 | 0.01453 | 0.0009369 | 8.672e-05 | 0.001155 |
| Default | Confidence-driven | AvgTxCost | 3.296 | 3.301 | 0.005155 | 0.005875 | 0.03036 |
| Default | Confidence-driven | EmgTimely | 1 | 0.9833 | -0.01667 | 0.03267 | 0.1667 |
| ForestGeometry | Confidence-driven | TimelyRate | 0.8282 | 0.8318 | 0.003636 | 0.00291 | 0.009091 |
| ForestGeometry | Confidence-driven | LossRate | 0.1709 | 0.1673 | -0.003636 | 0.00291 | 0.009091 |
| ForestGeometry | Confidence-driven | AvgDelay | 0.01302 | 0.01251 | -0.000513 | 0.0001985 | 0.001155 |
| ForestGeometry | Confidence-driven | AvgTxCost | 3.561 | 3.558 | -0.003182 | 0.002789 | 0.01273 |
| ForestGeometry | Confidence-driven | EmgTimely | 0.01667 | 0.01667 | 0 | 0 | 0 |

## Overall Significance

| Config | Metric | Baseline_Mean | Baseline_Std | Proposed_Mean | Proposed_Std | Delta_Mean | DeltaPct | CI_Lower | CI_Upper | P_Value | P_Value_Display | P_Value_Holm | P_Value_Holm_Display | Significant | Significant_Holm | EffectSize_RBC | EffectSize_CohenDz | PracticalNote |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Default | TimelyRate | 0.9709 | 0.006432 | 0.9857 | 0.003937 | 0.01481 | 1.481 | 0.01234 | 0.01727 | 2.425e-13 | p = 2.425e-13 | 9.699e-13 | p = 9.699e-13 | *** | *** | 1 | 2.316 | Meaningful |
| Default | LossRate | 0.02912 | 0.006432 | 0.01431 | 0.003937 | -0.01481 | -1.481 | -0.01727 | -0.01234 | 2.425e-13 | p = 2.425e-13 | 9.699e-13 | p = 9.699e-13 | *** | *** | -1 | -2.316 | Meaningful |
| Default | AvgDelay | 0.02424 | 0.002908 | 0.0216 | 0.001813 | -0.002641 | -10.9 | -0.003688 | -0.001595 | 0.002097 | p = 0.002097 | 0.004194 | p = 0.004194 | ** | ** | -0.8182 | -0.9728 | Meaningful |
| Default | AvgTxCost | 1.905 | 0.03207 | 2.094 | 0.02981 | 0.1888 | 9.913 | 0.1875 | 0.1902 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 53.86 | SeeDelta |
| Default | EmgTimely | 1 | 0 | 0.9833 | 0.0527 | -0.01667 | -1.667 | -0.03698 | 0.003645 | 0.3173 | p = 0.3173 | 0.3173 | p = 0.3173 | n.s. | n.s. | -1 | -0.3162 | Meaningful |
| ForestGeometry | TimelyRate | 0.7705 | 0.008855 | 0.7882 | 0.004644 | 0.01764 | 1.764 | 0.01483 | 0.02044 | 1.91e-14 | p = 1.910e-14 | 5.729e-14 | p = 5.729e-14 | *** | *** | 1 | 2.422 | Meaningful |
| ForestGeometry | LossRate | 0.2293 | 0.008692 | 0.2116 | 0.004353 | -0.01764 | -1.764 | -0.02044 | -0.01483 | 1.91e-14 | p = 1.910e-14 | 5.729e-14 | p = 5.729e-14 | *** | *** | -1 | -2.422 | Meaningful |
| ForestGeometry | AvgDelay | 0.09352 | 0.003156 | 0.0852 | 0.001834 | -0.008321 | -8.897 | -0.009538 | -0.007104 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -2.635 | Meaningful |
| ForestGeometry | AvgTxCost | 2.17 | 0.04227 | 2.067 | 0.0417 | -0.1032 | -4.757 | -0.1043 | -0.1021 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -35.66 | SeeDelta |
| ForestGeometry | EmgTimely | 0.01667 | 0.0527 | 0.01667 | 0.0527 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |

## PosDeg_Emerg Significance

| Config | Metric | Baseline_Mean | Baseline_Std | Proposed_Mean | Proposed_Std | Delta_Mean | DeltaPct | CI_Lower | CI_Upper | P_Value | P_Value_Display | P_Value_Holm | P_Value_Holm_Display | Significant | Significant_Holm | EffectSize_RBC | EffectSize_CohenDz | PracticalNote |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Default | TimelyRate | 1 | 0 | 0.9982 | 0.003833 | -0.001818 | -0.1818 | -0.003295 | -0.0003409 | 0.1336 | p = 0.1336 | 0.4008 | p = 0.4008 | n.s. | n.s. | -1 | -0.4743 | Below1pp |
| Default | LossRate | 0 | 0 | 0.001818 | 0.003833 | 0.001818 | 0.1818 | 0.0003409 | 0.003295 | 0.1336 | p = 0.1336 | 0.4008 | p = 0.4008 | n.s. | n.s. | 1 | 0.4743 | Below1pp |
| Default | AvgDelay | 0.0136 | 0.0005946 | 0.01453 | 0.0005898 | 0.0009369 | 6.891 | 0.0008829 | 0.0009908 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 6.696 | Sub-ms |
| Default | AvgTxCost | 3.296 | 0.1273 | 3.301 | 0.1227 | 0.005155 | 0.1564 | 0.001501 | 0.008808 | 0.08552 | p = 0.08552 | 0.3421 | p = 0.3421 | n.s. | n.s. | 1 | 0.5438 | SeeDelta |
| Default | EmgTimely | 1 | 0 | 0.9833 | 0.0527 | -0.01667 | -1.667 | -0.03698 | 0.003645 | 0.3173 | p = 0.3173 | 0.4008 | p = 0.4008 | n.s. | n.s. | -1 | -0.3162 | Meaningful |
| ForestGeometry | TimelyRate | 0.8282 | 0.006708 | 0.8318 | 0.004791 | 0.003636 | 0.3636 | 0.001827 | 0.005446 | 0.01431 | p = 0.01431 | 0.05722 | p = 0.05722 | * | n.s. | 1 | 0.7746 | Below1pp |
| ForestGeometry | LossRate | 0.1709 | 0.00575 | 0.1673 | 0.004695 | -0.003636 | -0.3636 | -0.005446 | -0.001827 | 0.01431 | p = 0.01431 | 0.05722 | p = 0.05722 | * | n.s. | -1 | -0.7746 | Below1pp |
| ForestGeometry | AvgDelay | 0.01302 | 0.0003918 | 0.01251 | 0.000311 | -0.000513 | -3.939 | -0.0006365 | -0.0003895 | 4.105e-07 | p = 4.105e-07 | 2.052e-06 | p = 2.052e-06 | *** | *** | -1 | -1.601 | Sub-ms |
| ForestGeometry | AvgTxCost | 3.561 | 0.1366 | 3.558 | 0.1394 | -0.003182 | -0.08934 | -0.004916 | -0.001448 | 0.02535 | p = 0.02535 | 0.05722 | p = 0.05722 | * | n.s. | -1 | -0.7071 | SeeDelta |
| ForestGeometry | EmgTimely | 0.01667 | 0.0527 | 0.01667 | 0.0527 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |

## Interpretation

- If the absolute deltas remain small while significance is weak, the sigmoid approximation is acceptable for mainline experimentation.
- If the key-stage deltas remain limited, the approximation error does not materially alter the scheduling conclusion.
- If large deltas appear in `ForestGeometry` or `PosDeg_Emerg`, the final paper should prefer `per_lookup` or explicitly report the approximation bias.
