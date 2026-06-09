# Step47 Current-Method PER Lookup Validation Report

Purpose: verify whether replacing the fitted sigmoid SINR-to-PDR approximation with WiLabV2Xsim PER-table lookup changes final-method conclusions.

Compared PDR modes: `sigmoid` vs `per_lookup`.

Target proposed method: `Risk-constrained-v6`.

## Decision Table

| Scene | Config | Timely delta (pp) | Emergency delta (pp) | Loss delta (pp) | Delay delta (%) | Cost delta (%) | Decision |
|---|---|---:|---:|---:|---:|---:|---|
| 10014 | Default | 0.300 | 0.000 | -0.300 | 13.87 | 9.36 | MaterialBias |
| 10014 | ForestGeometry | 1.065 | 0.000 | -1.065 | -3.65 | -4.41 | SmallBiasDiscuss |
| 10006 | Default | 0.632 | -0.526 | -0.699 | 19.62 | 11.11 | MaterialBias |
| 10006 | ForestGeometry | 0.499 | 0.000 | -0.499 | -1.79 | -2.00 | ApproximationStable |
| 10011 | Default | -0.266 | 0.000 | 0.266 | 4.11 | 0.66 | ApproximationStable |
| 10011 | ForestGeometry | 9.384 | 23.000 | -9.351 | -26.94 | -13.45 | MaterialBias |
| 10019 | Default | 0.000 | 0.000 | 0.000 | 0.00 | 0.00 | ApproximationStable |
| 10019 | ForestGeometry | -4.992 | -5.495 | 4.426 | 2.74 | 0.11 | MaterialBias |
| 10017 | Default | 1.963 | -1.111 | -1.997 | 23.62 | 25.03 | MaterialBias |
| 10017 | ForestGeometry | 0.233 | 0.000 | -0.233 | -0.37 | 0.00 | ApproximationStable |

## Overall Delta Table

| Scene | SceneRole | GeometryType | DensityClass | VegetationClass | Config | Method | Metric | SigmoidMean | PerLookupMean | DeltaMean | DeltaCI95 | MaxAbsDelta | DeltaPctOrPp |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Link-delay-aware | TimelyRate | 0.97 | 0.9384 | -0.03161 | 0.001786 | 0.03328 | -3.161 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Link-delay-aware | LossRate | 0.02995 | 0.06156 | 0.03161 | 0.001786 | 0.03328 | 3.161 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Link-delay-aware | AvgDelay | 0.0228 | 0.03539 | 0.0126 | 0.000443 | 0.01297 | 55.26 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Link-delay-aware | AvgTxCost | 1.629 | 1.629 | 0 | 0 | 0 | 0 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Link-delay-aware | EmgTimely | 1 | 0.9667 | -0.03333 | 0.06533 | 0.1667 | -3.333 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Confidence-heuristic | TimelyRate | 0.973 | 0.9913 | 0.0183 | 0.002729 | 0.02163 | 1.83 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Confidence-heuristic | LossRate | 0.02696 | 0.008652 | -0.0183 | 0.002729 | 0.02163 | -1.83 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Confidence-heuristic | AvgDelay | 0.02232 | 0.01911 | -0.003209 | 0.001047 | 0.004803 | -14.37 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Confidence-heuristic | AvgTxCost | 1.856 | 2.075 | 0.2196 | 0.009348 | 0.2339 | 11.83 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Confidence-heuristic | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Risk-constrained-v6 | TimelyRate | 0.989 | 0.992 | 0.002995 | 0.002163 | 0.006656 | 0.2995 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Risk-constrained-v6 | LossRate | 0.01098 | 0.007987 | -0.002995 | 0.002163 | 0.006656 | -0.2995 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Risk-constrained-v6 | AvgDelay | 0.01532 | 0.01745 | 0.002125 | 0.0009386 | 0.003186 | 13.87 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Risk-constrained-v6 | AvgTxCost | 1.817 | 1.987 | 0.17 | 0.001797 | 0.1723 | 9.357 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Risk-constrained-v6 | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Constrained Oracle | TimelyRate | 0.9937 | 0.9943 | 0.0006656 | 0.003358 | 0.004992 | 0.06656 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Constrained Oracle | LossRate | 0.006323 | 0.005657 | -0.0006656 | 0.003358 | 0.004992 | -0.06656 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Constrained Oracle | AvgDelay | 0.01513 | 0.01873 | 0.003601 | 0.001113 | 0.005 | 23.81 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Constrained Oracle | AvgTxCost | 1.884 | 2.091 | 0.2064 | 0.004978 | 0.2122 | 10.96 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Constrained Oracle | EmgTimely | 1 | 0.9667 | -0.03333 | 0.06533 | 0.1667 | -3.333 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Link-delay-aware | TimelyRate | 0.7398 | 0.787 | 0.04725 | 0.009542 | 0.06489 | 4.725 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Link-delay-aware | LossRate | 0.2602 | 0.213 | -0.04725 | 0.009542 | 0.06489 | -4.725 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Link-delay-aware | AvgDelay | 0.1049 | 0.08501 | -0.01991 | 0.003868 | 0.027 | -18.98 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Link-delay-aware | AvgTxCost | 1.698 | 1.698 | 0 | 0 | 0 | 0 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Link-delay-aware | EmgTimely | 0 | 0 | 0 | 0 | 0 | 0 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Confidence-heuristic | TimelyRate | 0.7727 | 0.789 | 0.01631 | 0.005094 | 0.02662 | 1.631 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Confidence-heuristic | LossRate | 0.2273 | 0.211 | -0.01631 | 0.005094 | 0.02662 | -1.631 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Confidence-heuristic | AvgDelay | 0.09226 | 0.08472 | -0.007538 | 0.001579 | 0.01072 | -8.17 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Confidence-heuristic | AvgTxCost | 2.162 | 2.057 | -0.1046 | 0.00432 | 0.1127 | -4.838 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Confidence-heuristic | EmgTimely | 0 | 0 | 0 | 0 | 0 | 0 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.7864 | 0.797 | 0.01065 | 0.005888 | 0.01664 | 1.065 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Risk-constrained-v6 | LossRate | 0.2136 | 0.203 | -0.01065 | 0.005888 | 0.01664 | -1.065 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.08429 | 0.08121 | -0.00308 | 0.002565 | 0.005894 | -3.654 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 2.371 | 2.267 | -0.1047 | 0.008407 | 0.1186 | -4.413 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Risk-constrained-v6 | EmgTimely | 0 | 0 | 0 | 0 | 0 | 0 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Constrained Oracle | TimelyRate | 0.7957 | 0.8 | 0.004326 | 0.006407 | 0.01165 | 0.4326 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Constrained Oracle | LossRate | 0.2043 | 0.2 | -0.004326 | 0.006407 | 0.01165 | -0.4326 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Constrained Oracle | AvgDelay | 0.08313 | 0.08074 | -0.002392 | 0.002625 | 0.005479 | -2.877 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Constrained Oracle | AvgTxCost | 2.602 | 2.395 | -0.2068 | 0.01008 | 0.2213 | -7.95 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Constrained Oracle | EmgTimely | 0 | 0 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Link-delay-aware | TimelyRate | 0.9474 | 0.9314 | -0.01597 | 0.008967 | 0.03161 | -1.597 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Link-delay-aware | LossRate | 0.05258 | 0.06822 | 0.01564 | 0.008416 | 0.02995 | 1.564 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Link-delay-aware | AvgDelay | 0.03287 | 0.04115 | 0.008283 | 0.00299 | 0.01372 | 25.2 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Link-delay-aware | AvgTxCost | 2.147 | 2.203 | 0.05649 | 0 | 0.05649 | 2.631 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Link-delay-aware | EmgTimely | 0.9993 | 0.9928 | -0.006579 | 0.004078 | 0.01316 | -0.6579 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Confidence-heuristic | TimelyRate | 0.982 | 0.983 | 0.0009983 | 0.004903 | 0.008319 | 0.09983 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Confidence-heuristic | LossRate | 0.01797 | 0.01631 | -0.001664 | 0.004252 | 0.008319 | -0.1664 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Confidence-heuristic | AvgDelay | 0.02145 | 0.0235 | 0.002056 | 0.002261 | 0.004596 | 9.587 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Confidence-heuristic | AvgTxCost | 2.468 | 2.717 | 0.2496 | 0.004922 | 0.2573 | 10.11 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Confidence-heuristic | EmgTimely | 0.9993 | 0.9941 | -0.005263 | 0.002579 | 0.009868 | -0.5263 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Risk-constrained-v6 | TimelyRate | 0.9837 | 0.99 | 0.006323 | 0.001902 | 0.008319 | 0.6323 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Risk-constrained-v6 | LossRate | 0.01631 | 0.009318 | -0.006988 | 0.001902 | 0.009983 | -0.6988 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Risk-constrained-v6 | AvgDelay | 0.01951 | 0.02334 | 0.003828 | 0.0005836 | 0.004353 | 19.62 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Risk-constrained-v6 | AvgTxCost | 2.558 | 2.843 | 0.2844 | 0.002933 | 0.2876 | 11.11 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Risk-constrained-v6 | EmgTimely | 0.9993 | 0.9941 | -0.005263 | 0.002579 | 0.009868 | -0.5263 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Constrained Oracle | TimelyRate | 0.9894 | 0.9963 | 0.006988 | 0.002163 | 0.009983 | 0.6988 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Constrained Oracle | LossRate | 0.01065 | 0.002329 | -0.008319 | 0.001458 | 0.009983 | -0.8319 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Constrained Oracle | AvgDelay | 0.01887 | 0.02187 | 0.003004 | 0.0005832 | 0.003837 | 15.92 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Constrained Oracle | AvgTxCost | 2.321 | 2.732 | 0.4101 | 0.005469 | 0.4157 | 17.67 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Constrained Oracle | EmgTimely | 0.9993 | 0.9954 | -0.003947 | 0.001289 | 0.006579 | -0.3947 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Link-delay-aware | TimelyRate | 0.6938 | 0.7075 | 0.01364 | 0.005779 | 0.01997 | 1.364 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Link-delay-aware | LossRate | 0.3048 | 0.2912 | -0.01364 | 0.005779 | 0.01997 | -1.364 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Link-delay-aware | AvgDelay | 0.09222 | 0.08828 | -0.003941 | 0.001585 | 0.006086 | -4.274 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Link-delay-aware | AvgTxCost | 2.265 | 2.265 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Link-delay-aware | EmgTimely | 0.8007 | 0.8007 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | TimelyRate | 0.7055 | 0.7075 | 0.001997 | 0.003162 | 0.006656 | 0.1997 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | LossRate | 0.2915 | 0.2895 | -0.001997 | 0.003162 | 0.006656 | -0.1997 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | AvgDelay | 0.08931 | 0.08828 | -0.001034 | 0.0008325 | 0.002494 | -1.158 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | AvgTxCost | 2.66 | 2.579 | -0.0807 | 1.742e-16 | 0.0807 | -3.034 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | EmgTimely | 0.8 | 0.8 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.7075 | 0.7125 | 0.004992 | 0.004252 | 0.009983 | 0.4992 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | LossRate | 0.2912 | 0.2862 | -0.004992 | 0.004252 | 0.009983 | -0.4992 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.08792 | 0.08634 | -0.001577 | 0.0008754 | 0.002607 | -1.794 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 2.941 | 2.882 | -0.0587 | 0.0005592 | 0.0594 | -1.996 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | EmgTimely | 0.8007 | 0.8007 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Constrained Oracle | TimelyRate | 0.7115 | 0.7121 | 0.0006656 | 0.002212 | 0.003328 | 0.06656 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Constrained Oracle | LossRate | 0.2869 | 0.2862 | -0.0006656 | 0.002212 | 0.003328 | -0.06656 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Constrained Oracle | AvgDelay | 0.08751 | 0.0865 | -0.001017 | 0.0005596 | 0.001726 | -1.162 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Constrained Oracle | AvgTxCost | 2.841 | 2.725 | -0.1164 | 1.742e-16 | 0.1164 | -4.096 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Constrained Oracle | EmgTimely | 0.7993 | 0.7993 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Link-delay-aware | TimelyRate | 0.998 | 0.9943 | -0.003661 | 0.001902 | 0.006656 | -0.3661 |
| 10011 | Boundary | Open | Low | Sparse | Default | Link-delay-aware | LossRate | 0.001997 | 0.005657 | 0.003661 | 0.001902 | 0.006656 | 0.3661 |
| 10011 | Boundary | Open | Low | Sparse | Default | Link-delay-aware | AvgDelay | 0.01252 | 0.01318 | 0.0006669 | 0.0003191 | 0.001167 | 5.328 |
| 10011 | Boundary | Open | Low | Sparse | Default | Link-delay-aware | AvgTxCost | 1.719 | 1.719 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Link-delay-aware | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Confidence-heuristic | TimelyRate | 0.9983 | 0.995 | -0.003328 | 0.001458 | 0.004992 | -0.3328 |
| 10011 | Boundary | Open | Low | Sparse | Default | Confidence-heuristic | LossRate | 0.001664 | 0.004992 | 0.003328 | 0.001458 | 0.004992 | 0.3328 |
| 10011 | Boundary | Open | Low | Sparse | Default | Confidence-heuristic | AvgDelay | 0.01246 | 0.01308 | 0.0006145 | 0.0002491 | 0.0009052 | 4.931 |
| 10011 | Boundary | Open | Low | Sparse | Default | Confidence-heuristic | AvgTxCost | 1.943 | 1.95 | 0.006988 | 0.005105 | 0.01631 | 0.3597 |
| 10011 | Boundary | Open | Low | Sparse | Default | Confidence-heuristic | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Risk-constrained-v6 | TimelyRate | 0.9983 | 0.9957 | -0.002662 | 0.002212 | 0.006656 | -0.2662 |
| 10011 | Boundary | Open | Low | Sparse | Default | Risk-constrained-v6 | LossRate | 0.001664 | 0.004326 | 0.002662 | 0.002212 | 0.006656 | 0.2662 |
| 10011 | Boundary | Open | Low | Sparse | Default | Risk-constrained-v6 | AvgDelay | 0.01246 | 0.01298 | 0.0005121 | 0.0003617 | 0.001167 | 4.109 |
| 10011 | Boundary | Open | Low | Sparse | Default | Risk-constrained-v6 | AvgTxCost | 1.863 | 1.875 | 0.01235 | 0.002117 | 0.01631 | 0.6627 |
| 10011 | Boundary | Open | Low | Sparse | Default | Risk-constrained-v6 | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Constrained Oracle | TimelyRate | 0.9983 | 0.9987 | 0.0003328 | 0.00122 | 0.001664 | 0.03328 |
| 10011 | Boundary | Open | Low | Sparse | Default | Constrained Oracle | LossRate | 0.001664 | 0.001331 | -0.0003328 | 0.00122 | 0.001664 | -0.03328 |
| 10011 | Boundary | Open | Low | Sparse | Default | Constrained Oracle | AvgDelay | 0.0128 | 0.01285 | 4.9e-05 | 0.000205 | 0.0003557 | 0.3829 |
| 10011 | Boundary | Open | Low | Sparse | Default | Constrained Oracle | AvgTxCost | 1.896 | 1.931 | 0.03494 | 3.077e-16 | 0.03494 | 1.843 |
| 10011 | Boundary | Open | Low | Sparse | Default | Constrained Oracle | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Link-delay-aware | TimelyRate | 0.582 | 0.6715 | 0.08952 | 0.01164 | 0.1048 | 8.952 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Link-delay-aware | LossRate | 0.4126 | 0.3268 | -0.08586 | 0.01179 | 0.1032 | -8.586 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Link-delay-aware | AvgDelay | 0.1564 | 0.1345 | -0.02191 | 0.002602 | 0.02496 | -14.01 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Link-delay-aware | AvgTxCost | 2.729 | 2.357 | -0.3724 | 0 | 0.3724 | -13.65 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Link-delay-aware | EmgTimely | 0.26 | 0.48 | 0.22 | 0.04997 | 0.3 | 22 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Confidence-heuristic | TimelyRate | 0.6749 | 0.7634 | 0.08852 | 0.01342 | 0.1098 | 8.852 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Confidence-heuristic | LossRate | 0.3221 | 0.2346 | -0.08752 | 0.01405 | 0.1098 | -8.752 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Confidence-heuristic | AvgDelay | 0.1387 | 0.1077 | -0.03102 | 0.00333 | 0.03622 | -22.37 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Confidence-heuristic | AvgTxCost | 3.411 | 2.99 | -0.4211 | 0.02143 | 0.4568 | -12.35 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Confidence-heuristic | EmgTimely | 0.26 | 0.51 | 0.25 | 0.05368 | 0.3 | 25 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.7111 | 0.805 | 0.09384 | 0.01633 | 0.1231 | 9.384 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Risk-constrained-v6 | LossRate | 0.2835 | 0.19 | -0.09351 | 0.01453 | 0.1181 | -9.351 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.1233 | 0.09009 | -0.03322 | 0.003678 | 0.03846 | -26.94 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 3.725 | 3.224 | -0.5011 | 0.0261 | 0.5341 | -13.45 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Risk-constrained-v6 | EmgTimely | 0.26 | 0.49 | 0.23 | 0.1372 | 0.5 | 23 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Constrained Oracle | TimelyRate | 0.6955 | 0.793 | 0.0975 | 0.01761 | 0.1265 | 9.75 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Constrained Oracle | LossRate | 0.2972 | 0.201 | -0.09617 | 0.01449 | 0.1165 | -9.617 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Constrained Oracle | AvgDelay | 0.1334 | 0.09811 | -0.03531 | 0.003724 | 0.0411 | -26.46 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Constrained Oracle | AvgTxCost | 4.009 | 3.5 | -0.5083 | 0.01317 | 0.5294 | -12.68 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Constrained Oracle | EmgTimely | 0.28 | 0.49 | 0.21 | 0.09501 | 0.4 | 21 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Link-delay-aware | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Link-delay-aware | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Link-delay-aware | AvgDelay | 0.01208 | 0.01208 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Link-delay-aware | AvgTxCost | 2.5 | 2.5 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Link-delay-aware | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Confidence-heuristic | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Confidence-heuristic | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Confidence-heuristic | AvgDelay | 0.01208 | 0.01208 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Confidence-heuristic | AvgTxCost | 2.988 | 2.988 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Confidence-heuristic | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Risk-constrained-v6 | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Risk-constrained-v6 | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Risk-constrained-v6 | AvgDelay | 0.01208 | 0.01208 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Risk-constrained-v6 | AvgTxCost | 3.045 | 3.045 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Risk-constrained-v6 | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Constrained Oracle | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Constrained Oracle | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Constrained Oracle | AvgDelay | 0.01208 | 0.01208 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Constrained Oracle | AvgTxCost | 2.504 | 2.504 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Constrained Oracle | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Link-delay-aware | TimelyRate | 0.6652 | 0.6213 | -0.04393 | 0.004903 | 0.04992 | -4.393 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Link-delay-aware | LossRate | 0.2772 | 0.3408 | 0.06356 | 0.006222 | 0.07155 | 6.356 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Link-delay-aware | AvgDelay | 0.03965 | 0.03994 | 0.0002917 | 0.0001383 | 0.0004367 | 0.7356 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Link-delay-aware | AvgTxCost | 2.958 | 2.842 | -0.1164 | 0 | 0.1164 | -3.933 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Link-delay-aware | EmgTimely | 0.6315 | 0.5832 | -0.04835 | 0.005397 | 0.05495 | -4.835 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Confidence-heuristic | TimelyRate | 0.6622 | 0.621 | -0.04126 | 0.003162 | 0.04659 | -4.126 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Confidence-heuristic | LossRate | 0.2679 | 0.3208 | 0.05291 | 0.006049 | 0.05824 | 5.291 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Confidence-heuristic | AvgDelay | 0.03987 | 0.0405 | 0.000634 | 0.0001085 | 0.0008212 | 1.59 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Confidence-heuristic | AvgTxCost | 3.363 | 3.373 | 0.009434 | 1.741e-16 | 0.009434 | 0.2805 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Confidence-heuristic | EmgTimely | 0.6282 | 0.5828 | -0.04542 | 0.00348 | 0.05128 | -4.542 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.6652 | 0.6153 | -0.04992 | 0.008186 | 0.06156 | -4.992 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Risk-constrained-v6 | LossRate | 0.2686 | 0.3128 | 0.04426 | 0.009816 | 0.05324 | 4.426 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.03985 | 0.04094 | 0.001091 | 0.0002356 | 0.001359 | 2.737 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 3.318 | 3.321 | 0.003774 | 0.001233 | 0.00629 | 0.1137 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Risk-constrained-v6 | EmgTimely | 0.6315 | 0.5766 | -0.05495 | 0.00901 | 0.06777 | -5.495 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Constrained Oracle | TimelyRate | 0.6599 | 0.6073 | -0.05258 | 0.009026 | 0.06489 | -5.258 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Constrained Oracle | LossRate | 0.2662 | 0.3115 | 0.04526 | 0.01028 | 0.05657 | 4.526 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Constrained Oracle | AvgDelay | 0.04002 | 0.04139 | 0.001365 | 0.000168 | 0.001538 | 3.411 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Constrained Oracle | AvgTxCost | 3.015 | 3.024 | 0.008865 | 0.01286 | 0.02146 | 0.294 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Constrained Oracle | EmgTimely | 0.6256 | 0.5678 | -0.05788 | 0.009935 | 0.07143 | -5.788 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Link-delay-aware | TimelyRate | 0.9072 | 0.8626 | -0.04459 | 0.004047 | 0.04992 | -4.459 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Link-delay-aware | LossRate | 0.09285 | 0.1374 | 0.04459 | 0.004047 | 0.04992 | 4.459 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Link-delay-aware | AvgDelay | 0.03873 | 0.05457 | 0.01584 | 0.001443 | 0.01719 | 40.91 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Link-delay-aware | AvgTxCost | 1.923 | 2.047 | 0.1239 | 0.0005592 | 0.1244 | 6.443 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Link-delay-aware | EmgTimely | 0.9944 | 0.9444 | -0.05 | 0.02667 | 0.08333 | -5 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Confidence-heuristic | TimelyRate | 0.9561 | 0.9764 | 0.0203 | 0.01002 | 0.03993 | 2.03 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Confidence-heuristic | LossRate | 0.04393 | 0.02329 | -0.02063 | 0.009924 | 0.03993 | -2.063 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Confidence-heuristic | AvgDelay | 0.02634 | 0.02876 | 0.002419 | 0.002086 | 0.0048 | 9.183 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Confidence-heuristic | AvgTxCost | 2.357 | 2.964 | 0.607 | 0.008677 | 0.6139 | 25.75 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Confidence-heuristic | EmgTimely | 1 | 0.9889 | -0.01111 | 0.01334 | 0.02778 | -1.111 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Risk-constrained-v6 | TimelyRate | 0.9634 | 0.983 | 0.01963 | 0.005592 | 0.02995 | 1.963 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Risk-constrained-v6 | LossRate | 0.03661 | 0.01664 | -0.01997 | 0.005742 | 0.02995 | -1.997 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Risk-constrained-v6 | AvgDelay | 0.02338 | 0.02891 | 0.005523 | 0.0008064 | 0.006651 | 23.62 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Risk-constrained-v6 | AvgTxCost | 2.289 | 2.862 | 0.573 | 0.00551 | 0.581 | 25.03 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Risk-constrained-v6 | EmgTimely | 1 | 0.9889 | -0.01111 | 0.01334 | 0.02778 | -1.111 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Constrained Oracle | TimelyRate | 0.9787 | 0.9907 | 0.01198 | 0.003775 | 0.01664 | 1.198 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Constrained Oracle | LossRate | 0.0213 | 0.008985 | -0.01231 | 0.003941 | 0.01664 | -1.231 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Constrained Oracle | AvgDelay | 0.02074 | 0.02854 | 0.0078 | 0.0003842 | 0.0083 | 37.6 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Constrained Oracle | AvgTxCost | 2.429 | 3.208 | 0.7783 | 0.002213 | 0.7821 | 32.04 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Constrained Oracle | EmgTimely | 0.9944 | 0.9778 | -0.01667 | 0.03267 | 0.05556 | -1.667 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Link-delay-aware | TimelyRate | 0.5225 | 0.5248 | 0.002329 | 0.001663 | 0.004992 | 0.2329 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Link-delay-aware | LossRate | 0.4772 | 0.4749 | -0.002329 | 0.001663 | 0.004992 | -0.2329 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Link-delay-aware | AvgDelay | 0.1278 | 0.1273 | -0.0004628 | 0.0003115 | 0.0009576 | -0.3622 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Link-delay-aware | AvgTxCost | 2.179 | 2.179 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Link-delay-aware | EmgTimely | 0.03333 | 0.03333 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | TimelyRate | 0.5251 | 0.5275 | 0.002329 | 0.001663 | 0.004992 | 0.2329 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | LossRate | 0.4745 | 0.4722 | -0.002329 | 0.001663 | 0.004992 | -0.2329 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | AvgDelay | 0.1275 | 0.127 | -0.0004628 | 0.0003115 | 0.0009576 | -0.3631 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | AvgTxCost | 2.65 | 2.65 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | EmgTimely | 0.03333 | 0.03333 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.5318 | 0.5341 | 0.002329 | 0.001663 | 0.004992 | 0.2329 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | LossRate | 0.4679 | 0.4656 | -0.002329 | 0.001663 | 0.004992 | -0.2329 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.1253 | 0.1248 | -0.0004628 | 0.0003115 | 0.0009576 | -0.3695 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 2.992 | 2.992 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | EmgTimely | 0.03333 | 0.03333 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Constrained Oracle | TimelyRate | 0.5384 | 0.5401 | 0.001664 | 0.002306 | 0.004992 | 0.1664 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Constrained Oracle | LossRate | 0.4612 | 0.4596 | -0.001664 | 0.002306 | 0.004992 | -0.1664 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Constrained Oracle | AvgDelay | 0.1254 | 0.1251 | -0.0003467 | 0.0004231 | 0.0009576 | -0.2764 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Constrained Oracle | AvgTxCost | 3.754 | 3.74 | -0.01398 | 5.222e-16 | 0.01398 | -0.3723 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Constrained Oracle | EmgTimely | 0.03333 | 0.03333 | 0 | 0 | 0 | 0 |

## PosDeg_Emerg Delta Table

| Scene | SceneRole | GeometryType | DensityClass | VegetationClass | Config | Method | Metric | SigmoidMean | PerLookupMean | DeltaMean | DeltaCI95 | MaxAbsDelta | DeltaPctOrPp |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Link-delay-aware | TimelyRate | 0.9873 | 0.9709 | -0.01636 | 0.01182 | 0.03636 | -1.636 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Link-delay-aware | LossRate | 0.01273 | 0.02909 | 0.01636 | 0.01182 | 0.03636 | 1.636 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Link-delay-aware | AvgDelay | 0.01231 | 0.01301 | 0.0007002 | 8.95e-05 | 0.0007782 | 5.69 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Link-delay-aware | AvgTxCost | 2.03 | 2.03 | 0 | 0 | 0 | 0 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Link-delay-aware | EmgTimely | 1 | 0.9667 | -0.03333 | 0.06533 | 0.1667 | -3.333 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Confidence-heuristic | TimelyRate | 0.9964 | 1 | 0.003636 | 0.004365 | 0.009091 | 0.3636 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Confidence-heuristic | LossRate | 0.003636 | 0 | -0.003636 | 0.004365 | 0.009091 | -0.3636 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Confidence-heuristic | AvgDelay | 0.01237 | 0.01426 | 0.001891 | 0.0002753 | 0.002388 | 15.29 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Confidence-heuristic | AvgTxCost | 3.109 | 3.239 | 0.1298 | 0.03673 | 0.1838 | 4.174 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Confidence-heuristic | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Risk-constrained-v6 | TimelyRate | 0.9927 | 0.9964 | 0.003636 | 0.004365 | 0.009091 | 0.3636 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Risk-constrained-v6 | LossRate | 0.007273 | 0.003636 | -0.003636 | 0.004365 | 0.009091 | -0.3636 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Risk-constrained-v6 | AvgDelay | 0.01234 | 0.01345 | 0.001108 | 0.0002215 | 0.001407 | 8.977 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Risk-constrained-v6 | AvgTxCost | 2.769 | 2.82 | 0.05091 | 0.01013 | 0.06364 | 1.839 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Risk-constrained-v6 | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Constrained Oracle | TimelyRate | 0.9964 | 0.9982 | 0.001818 | 0.003564 | 0.009091 | 0.1818 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Constrained Oracle | LossRate | 0.003636 | 0.001818 | -0.001818 | 0.003564 | 0.009091 | -0.1818 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Constrained Oracle | AvgDelay | 0.01417 | 0.0152 | 0.001036 | 0.0001592 | 0.001345 | 7.311 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Constrained Oracle | AvgTxCost | 2.877 | 2.978 | 0.1009 | 0.01694 | 0.1109 | 3.507 |
| 10014 | Primary | CurvedBlind | Medium | Dense | Default | Constrained Oracle | EmgTimely | 1 | 0.9667 | -0.03333 | 0.06533 | 0.1667 | -3.333 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Link-delay-aware | TimelyRate | 0.8073 | 0.8236 | 0.01636 | 0.01533 | 0.04545 | 1.636 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Link-delay-aware | LossRate | 0.1927 | 0.1764 | -0.01636 | 0.01533 | 0.04545 | -1.636 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Link-delay-aware | AvgDelay | 0.0126 | 0.01234 | -0.0002582 | 4.637e-05 | 0.0002891 | -2.05 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Link-delay-aware | AvgTxCost | 2.145 | 2.145 | 0 | 0 | 0 | 0 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Link-delay-aware | EmgTimely | 0 | 0 | 0 | 0 | 0 | 0 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Confidence-heuristic | TimelyRate | 0.8236 | 0.8309 | 0.007273 | 0.003564 | 0.009091 | 0.7273 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Confidence-heuristic | LossRate | 0.1764 | 0.1691 | -0.007273 | 0.003564 | 0.009091 | -0.7273 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Confidence-heuristic | AvgDelay | 0.01306 | 0.01259 | -0.0004647 | 0.000278 | 0.001015 | -3.559 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Confidence-heuristic | AvgTxCost | 3.593 | 3.589 | -0.003818 | 0.003055 | 0.006364 | -0.1063 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Confidence-heuristic | EmgTimely | 0 | 0 | 0 | 0 | 0 | 0 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.8182 | 0.8291 | 0.01091 | 0.008729 | 0.02727 | 1.091 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Risk-constrained-v6 | LossRate | 0.1818 | 0.1709 | -0.01091 | 0.008729 | 0.02727 | -1.091 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.01294 | 0.01258 | -0.0003677 | 0.0001052 | 0.0005315 | -2.841 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 3.321 | 3.313 | -0.008909 | 0.01157 | 0.03182 | -0.2682 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Risk-constrained-v6 | EmgTimely | 0 | 0 | 0 | 0 | 0 | 0 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Constrained Oracle | TimelyRate | 0.8255 | 0.8309 | 0.005455 | 0.004365 | 0.009091 | 0.5455 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Constrained Oracle | LossRate | 0.1745 | 0.1691 | -0.005455 | 0.004365 | 0.009091 | -0.5455 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Constrained Oracle | AvgDelay | 0.01447 | 0.01396 | -0.000502 | 0.0003235 | 0.001144 | -3.47 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Constrained Oracle | AvgTxCost | 3.446 | 3.425 | -0.02036 | 0.02412 | 0.06364 | -0.591 |
| 10014 | Primary | CurvedBlind | Medium | Dense | ForestGeometry | Constrained Oracle | EmgTimely | 0 | 0 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Link-delay-aware | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Link-delay-aware | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Link-delay-aware | AvgDelay | 0.01223 | 0.01227 | 3.745e-05 | 4.948e-05 | 0.0001384 | 0.3061 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Link-delay-aware | AvgTxCost | 2.55 | 2.55 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Link-delay-aware | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Confidence-heuristic | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Confidence-heuristic | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Confidence-heuristic | AvgDelay | 0.01223 | 0.01227 | 3.745e-05 | 4.948e-05 | 0.0001384 | 0.3061 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Confidence-heuristic | AvgTxCost | 2.671 | 2.671 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Confidence-heuristic | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Risk-constrained-v6 | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Risk-constrained-v6 | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Risk-constrained-v6 | AvgDelay | 0.01223 | 0.01227 | 3.745e-05 | 4.948e-05 | 0.0001384 | 0.3061 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Risk-constrained-v6 | AvgTxCost | 3.15 | 3.15 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Risk-constrained-v6 | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Constrained Oracle | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Constrained Oracle | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Constrained Oracle | AvgDelay | 0.01223 | 0.01227 | 3.745e-05 | 4.948e-05 | 0.0001384 | 0.3061 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Constrained Oracle | AvgTxCost | 2.55 | 2.55 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | Default | Constrained Oracle | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Link-delay-aware | TimelyRate | 0.8945 | 0.8945 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Link-delay-aware | LossRate | 0.1036 | 0.1036 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Link-delay-aware | AvgDelay | 0.01268 | 0.01268 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Link-delay-aware | AvgTxCost | 2.615 | 2.615 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Link-delay-aware | EmgTimely | 0.8945 | 0.8945 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | TimelyRate | 0.8945 | 0.8945 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | LossRate | 0.1018 | 0.1018 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | AvgDelay | 0.01287 | 0.01287 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | AvgTxCost | 2.916 | 2.916 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | EmgTimely | 0.8945 | 0.8945 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.8945 | 0.8945 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | LossRate | 0.1036 | 0.1036 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.01268 | 0.01268 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 3.15 | 3.15 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | EmgTimely | 0.8945 | 0.8945 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Constrained Oracle | TimelyRate | 0.8927 | 0.8927 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Constrained Oracle | LossRate | 0.1055 | 0.1055 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Constrained Oracle | AvgDelay | 0.01252 | 0.01252 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Constrained Oracle | AvgTxCost | 2.703 | 2.703 | 0 | 0 | 0 | 0 |
| 10006 | Reference | Mixed | Medium | Mixed | ForestGeometry | Constrained Oracle | EmgTimely | 0.8927 | 0.8927 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Link-delay-aware | TimelyRate | 0.9982 | 0.9982 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Link-delay-aware | LossRate | 0.001818 | 0.001818 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Link-delay-aware | AvgDelay | 0.01222 | 0.01222 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Link-delay-aware | AvgTxCost | 2 | 2 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Link-delay-aware | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN |
| 10011 | Boundary | Open | Low | Sparse | Default | Confidence-heuristic | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Confidence-heuristic | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Confidence-heuristic | AvgDelay | 0.01223 | 0.01223 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Confidence-heuristic | AvgTxCost | 2.993 | 2.993 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Confidence-heuristic | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN |
| 10011 | Boundary | Open | Low | Sparse | Default | Risk-constrained-v6 | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Risk-constrained-v6 | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Risk-constrained-v6 | AvgDelay | 0.01223 | 0.01223 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Risk-constrained-v6 | AvgTxCost | 2.657 | 2.657 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Risk-constrained-v6 | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN |
| 10011 | Boundary | Open | Low | Sparse | Default | Constrained Oracle | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Constrained Oracle | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Constrained Oracle | AvgDelay | 0.01407 | 0.01407 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Constrained Oracle | AvgTxCost | 2.833 | 2.833 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | Default | Constrained Oracle | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Link-delay-aware | TimelyRate | 0.7382 | 0.9291 | 0.1909 | 0.03695 | 0.2455 | 19.09 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Link-delay-aware | LossRate | 0.2618 | 0.07091 | -0.1909 | 0.03695 | 0.2455 | -19.09 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Link-delay-aware | AvgDelay | 0.01858 | 0.01292 | -0.005661 | 0.0001785 | 0.006006 | -30.47 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Link-delay-aware | AvgTxCost | 2 | 2 | 0 | 0 | 0 | 0 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Link-delay-aware | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Confidence-heuristic | TimelyRate | 0.9691 | 0.9927 | 0.02364 | 0.01448 | 0.04545 | 2.364 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Confidence-heuristic | LossRate | 0.03091 | 0.007273 | -0.02364 | 0.01448 | 0.04545 | -2.364 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Confidence-heuristic | AvgDelay | 0.02254 | 0.01382 | -0.00872 | 0.0008021 | 0.009998 | -38.69 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Confidence-heuristic | AvgTxCost | 3.585 | 3.077 | -0.508 | 0.0814 | 0.6549 | -14.17 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Confidence-heuristic | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.9673 | 0.9891 | 0.02182 | 0.009086 | 0.03636 | 2.182 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Risk-constrained-v6 | LossRate | 0.03273 | 0.01091 | -0.02182 | 0.009086 | 0.03636 | -2.182 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.02193 | 0.01373 | -0.008207 | 0.0005101 | 0.008958 | -37.42 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 3.5 | 2.875 | -0.6247 | 0.0681 | 0.7391 | -17.85 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Risk-constrained-v6 | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Constrained Oracle | TimelyRate | 0.9745 | 0.9891 | 0.01455 | 0.01652 | 0.02727 | 1.455 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Constrained Oracle | LossRate | 0.02545 | 0.01091 | -0.01455 | 0.01652 | 0.02727 | -1.455 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Constrained Oracle | AvgDelay | 0.0221 | 0.01494 | -0.007153 | 0.0004483 | 0.007595 | -32.37 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Constrained Oracle | AvgTxCost | 3.651 | 2.953 | -0.6989 | 0.1026 | 0.8082 | -19.14 |
| 10011 | Boundary | Open | Low | Sparse | ForestGeometry | Constrained Oracle | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Link-delay-aware | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Link-delay-aware | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Link-delay-aware | AvgDelay | 0.01223 | 0.01223 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Link-delay-aware | AvgTxCost | 2.55 | 2.55 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Link-delay-aware | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Confidence-heuristic | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Confidence-heuristic | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Confidence-heuristic | AvgDelay | 0.01223 | 0.01223 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Confidence-heuristic | AvgTxCost | 3.021 | 3.021 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Confidence-heuristic | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Risk-constrained-v6 | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Risk-constrained-v6 | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Risk-constrained-v6 | AvgDelay | 0.01223 | 0.01223 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Risk-constrained-v6 | AvgTxCost | 3.15 | 3.15 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Risk-constrained-v6 | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Constrained Oracle | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Constrained Oracle | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Constrained Oracle | AvgDelay | 0.01223 | 0.01223 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Constrained Oracle | AvgTxCost | 2.573 | 2.573 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | Default | Constrained Oracle | EmgTimely | 1 | 1 | 0 | 0 | 0 | 0 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Link-delay-aware | TimelyRate | 0.5873 | 0.4455 | -0.1418 | 0.02153 | 0.1636 | -14.18 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Link-delay-aware | LossRate | 0.2055 | 0.4073 | 0.2018 | 0.01728 | 0.2273 | 20.18 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Link-delay-aware | AvgDelay | 0.0531 | 0.04662 | -0.006478 | 0.001653 | 0.008917 | -12.2 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Link-delay-aware | AvgTxCost | 3.828 | 3.433 | -0.3952 | 0 | 0.3952 | -10.32 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Link-delay-aware | EmgTimely | 0.5873 | 0.4455 | -0.1418 | 0.02153 | 0.1636 | -14.18 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Confidence-heuristic | TimelyRate | 0.5836 | 0.4455 | -0.1382 | 0.01533 | 0.1636 | -13.82 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Confidence-heuristic | LossRate | 0.1673 | 0.3218 | 0.1545 | 0.02928 | 0.2 | 15.45 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Confidence-heuristic | AvgDelay | 0.05516 | 0.05338 | -0.001781 | 0.001918 | 0.004475 | -3.228 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Confidence-heuristic | AvgTxCost | 4.267 | 4.319 | 0.05155 | 3.482e-16 | 0.05155 | 1.208 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Confidence-heuristic | EmgTimely | 0.5836 | 0.4455 | -0.1382 | 0.01533 | 0.1636 | -13.82 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.5891 | 0.4091 | -0.18 | 0.03003 | 0.2182 | -18 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Risk-constrained-v6 | LossRate | 0.1745 | 0.2745 | 0.1 | 0.03822 | 0.1364 | 10 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.05481 | 0.05882 | 0.004011 | 0.001633 | 0.007111 | 7.318 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 4.215 | 4.421 | 0.2062 | 0 | 0.2062 | 4.891 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Risk-constrained-v6 | EmgTimely | 0.5891 | 0.4091 | -0.18 | 0.03003 | 0.2182 | -18 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Constrained Oracle | TimelyRate | 0.5727 | 0.3782 | -0.1945 | 0.02078 | 0.2273 | -19.45 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Constrained Oracle | LossRate | 0.1455 | 0.2473 | 0.1018 | 0.02783 | 0.1364 | 10.18 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Constrained Oracle | AvgDelay | 0.05648 | 0.06226 | 0.005774 | 0.001147 | 0.007698 | 10.22 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Constrained Oracle | AvgTxCost | 4.318 | 4.566 | 0.2487 | 0.01986 | 0.2864 | 5.759 |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense | ForestGeometry | Constrained Oracle | EmgTimely | 0.5727 | 0.3782 | -0.1945 | 0.02078 | 0.2273 | -19.45 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Link-delay-aware | TimelyRate | 0.9982 | 0.9982 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Link-delay-aware | LossRate | 0.001818 | 0.001818 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Link-delay-aware | AvgDelay | 0.01222 | 0.01222 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Link-delay-aware | AvgTxCost | 2 | 2 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Link-delay-aware | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Confidence-heuristic | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Confidence-heuristic | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Confidence-heuristic | AvgDelay | 0.01223 | 0.01223 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Confidence-heuristic | AvgTxCost | 2.993 | 2.993 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Confidence-heuristic | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Risk-constrained-v6 | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Risk-constrained-v6 | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Risk-constrained-v6 | AvgDelay | 0.01223 | 0.01223 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Risk-constrained-v6 | AvgTxCost | 2.657 | 2.657 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Risk-constrained-v6 | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Constrained Oracle | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Constrained Oracle | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Constrained Oracle | AvgDelay | 0.01409 | 0.01409 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Constrained Oracle | AvgTxCost | 2.83 | 2.83 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | Default | Constrained Oracle | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Link-delay-aware | TimelyRate | 0.9982 | 0.9982 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Link-delay-aware | LossRate | 0.001818 | 0.001818 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Link-delay-aware | AvgDelay | 0.01222 | 0.01222 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Link-delay-aware | AvgTxCost | 2 | 2 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Link-delay-aware | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | AvgDelay | 0.01223 | 0.01223 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | AvgTxCost | 2.959 | 2.959 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Confidence-heuristic | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.9982 | 0.9982 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | LossRate | 0.001818 | 0.001818 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.01222 | 0.01222 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 2.724 | 2.724 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Risk-constrained-v6 | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Constrained Oracle | TimelyRate | 1 | 1 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Constrained Oracle | LossRate | 0 | 0 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Constrained Oracle | AvgDelay | 0.01352 | 0.01352 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Constrained Oracle | AvgTxCost | 2.836 | 2.836 | 0 | 0 | 0 | 0 |
| 10017 | LongRange | LongMixed | Medium | Mixed | ForestGeometry | Constrained Oracle | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN |

## Overall Significance

| Scene | Config | TargetMethod | Metric | Baseline_Mean | Baseline_Std | Proposed_Mean | Proposed_Std | Delta_Mean | DeltaPct | CI_Lower | CI_Upper | P_Value | P_Value_Display | P_Value_Holm | P_Value_Holm_Display | Significant | Significant_Holm | EffectSize_RBC | EffectSize_CohenDz | PracticalNote |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 10014 | Default | Link-delay-aware | TimelyRate | 0.97 | 0.005883 | 0.9384 | 0.007441 | -0.03161 | -3.161 | -0.03283 | -0.0304 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -15.51 | Meaningful |
| 10014 | Default | Link-delay-aware | LossRate | 0.02995 | 0.005883 | 0.06156 | 0.007441 | 0.03161 | 3.161 | 0.0304 | 0.03283 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 15.51 | Meaningful |
| 10014 | Default | Link-delay-aware | AvgDelay | 0.0228 | 0.001894 | 0.03539 | 0.002276 | 0.0126 | 55.26 | 0.0123 | 0.0129 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 24.92 | Meaningful |
| 10014 | Default | Link-delay-aware | AvgTxCost | 1.629 | 2.483e-16 | 1.629 | 2.483e-16 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10014 | Default | Link-delay-aware | EmgTimely | 1 | 0 | 0.9667 | 0.07454 | -0.03333 | -3.333 | -0.07764 | 0.01097 | 0.3173 | p = 0.3173 | 0.6346 | p = 0.6346 | n.s. | n.s. | -1 | -0.4472 | Meaningful |
| 10014 | Default | Confidence-heuristic | TimelyRate | 0.973 | 0.004307 | 0.9913 | 0.002468 | 0.0183 | 1.83 | 0.01645 | 0.02015 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 5.88 | Meaningful |
| 10014 | Default | Confidence-heuristic | LossRate | 0.02696 | 0.004307 | 0.008652 | 0.002468 | -0.0183 | -1.83 | -0.02015 | -0.01645 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -5.88 | Meaningful |
| 10014 | Default | Confidence-heuristic | AvgDelay | 0.02232 | 0.00162 | 0.01911 | 0.0008728 | -0.003209 | -14.37 | -0.003919 | -0.002498 | 1.928e-09 | p = 1.928e-09 | 3.856e-09 | p = 3.856e-09 | *** | *** | -1 | -2.685 | Meaningful |
| 10014 | Default | Confidence-heuristic | AvgTxCost | 1.856 | 0.02112 | 2.075 | 0.026 | 0.2196 | 11.83 | 0.2133 | 0.2259 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 20.59 | SeeDelta |
| 10014 | Default | Confidence-heuristic | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10014 | Default | Risk-constrained-v6 | TimelyRate | 0.989 | 0.005468 | 0.992 | 0.003201 | 0.002995 | 0.2995 | 0.001528 | 0.004462 | 0.006656 | p = 0.006656 | 0.01997 | p = 0.01997 | ** | * | 1 | 1.214 | Below1pp |
| 10014 | Default | Risk-constrained-v6 | LossRate | 0.01098 | 0.005468 | 0.007987 | 0.003201 | -0.002995 | -0.2995 | -0.004462 | -0.001528 | 0.006656 | p = 0.006656 | 0.01997 | p = 0.01997 | ** | * | -1 | -1.214 | Below1pp |
| 10014 | Default | Risk-constrained-v6 | AvgDelay | 0.01532 | 0.001877 | 0.01745 | 0.001058 | 0.002125 | 13.87 | 0.001489 | 0.002762 | 9.091e-06 | p = 9.091e-06 | 3.636e-05 | p = 3.636e-05 | *** | *** | 1 | 1.985 | Meaningful |
| 10014 | Default | Risk-constrained-v6 | AvgTxCost | 1.817 | 0.01529 | 1.987 | 0.0158 | 0.17 | 9.357 | 0.1688 | 0.1713 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 82.94 | SeeDelta |
| 10014 | Default | Risk-constrained-v6 | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10014 | Default | Constrained Oracle | TimelyRate | 0.9937 | 0.003607 | 0.9943 | 0.002523 | 0.0006656 | 0.06656 | -0.001611 | 0.002943 | 0.6976 | p = 0.6976 | 1 | p = 1 | n.s. | n.s. | 0.2 | 0.1737 | Below1pp |
| 10014 | Default | Constrained Oracle | LossRate | 0.006323 | 0.003607 | 0.005657 | 0.002523 | -0.0006656 | -0.06656 | -0.002943 | 0.001611 | 0.6976 | p = 0.6976 | 1 | p = 1 | n.s. | n.s. | -0.2 | -0.1737 | Below1pp |
| 10014 | Default | Constrained Oracle | AvgDelay | 0.01513 | 0.001335 | 0.01873 | 0.0005713 | 0.003601 | 23.81 | 0.002846 | 0.004356 | 2.304e-10 | p = 2.304e-10 | 9.216e-10 | p = 9.216e-10 | *** | *** | 1 | 2.835 | Meaningful |
| 10014 | Default | Constrained Oracle | AvgTxCost | 1.884 | 0.01397 | 2.091 | 0.01587 | 0.2064 | 10.96 | 0.2031 | 0.2098 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 36.35 | SeeDelta |
| 10014 | Default | Constrained Oracle | EmgTimely | 1 | 0 | 0.9667 | 0.07454 | -0.03333 | -3.333 | -0.07764 | 0.01097 | 0.3173 | p = 0.3173 | 0.9519 | p = 0.9519 | n.s. | n.s. | -1 | -0.4472 | Meaningful |
| 10014 | ForestGeometry | Link-delay-aware | TimelyRate | 0.7398 | 0.01156 | 0.787 | 0.007625 | 0.04725 | 4.725 | 0.04078 | 0.05373 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 4.341 | Meaningful |
| 10014 | ForestGeometry | Link-delay-aware | LossRate | 0.2602 | 0.01156 | 0.213 | 0.007625 | -0.04725 | -4.725 | -0.05373 | -0.04078 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -4.341 | Meaningful |
| 10014 | ForestGeometry | Link-delay-aware | AvgDelay | 0.1049 | 0.004979 | 0.08501 | 0.002975 | -0.01991 | -18.98 | -0.02254 | -0.01729 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -4.512 | Meaningful |
| 10014 | ForestGeometry | Link-delay-aware | AvgTxCost | 1.698 | 0 | 1.698 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10014 | ForestGeometry | Link-delay-aware | EmgTimely | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10014 | ForestGeometry | Confidence-heuristic | TimelyRate | 0.7727 | 0.007857 | 0.789 | 0.007098 | 0.01631 | 1.631 | 0.01285 | 0.01976 | 3.538e-10 | p = 3.538e-10 | 1.062e-09 | p = 1.062e-09 | *** | *** | 1 | 2.806 | Meaningful |
| 10014 | ForestGeometry | Confidence-heuristic | LossRate | 0.2273 | 0.007857 | 0.211 | 0.007098 | -0.01631 | -1.631 | -0.01976 | -0.01285 | 3.538e-10 | p = 3.538e-10 | 1.062e-09 | p = 1.062e-09 | *** | *** | -1 | -2.806 | Meaningful |
| 10014 | ForestGeometry | Confidence-heuristic | AvgDelay | 0.09226 | 0.002897 | 0.08472 | 0.002944 | -0.007538 | -8.17 | -0.008608 | -0.006467 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -4.185 | Meaningful |
| 10014 | ForestGeometry | Confidence-heuristic | AvgTxCost | 2.162 | 0.03245 | 2.057 | 0.0328 | -0.1046 | -4.838 | -0.1075 | -0.1017 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -21.22 | SeeDelta |
| 10014 | ForestGeometry | Confidence-heuristic | EmgTimely | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10014 | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.7864 | 0.004496 | 0.797 | 0.008565 | 0.01065 | 1.065 | 0.006656 | 0.01464 | 0.0003932 | p = 3.932e-04 | 0.001573 | p = 0.001573 | *** | ** | 1 | 1.585 | Meaningful |
| 10014 | ForestGeometry | Risk-constrained-v6 | LossRate | 0.2136 | 0.004496 | 0.203 | 0.008565 | -0.01065 | -1.065 | -0.01464 | -0.006656 | 0.0003932 | p = 3.932e-04 | 0.001573 | p = 0.001573 | *** | ** | -1 | -1.585 | Meaningful |
| 10014 | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.08429 | 0.001346 | 0.08121 | 0.003419 | -0.00308 | -3.654 | -0.00482 | -0.001341 | 0.01859 | p = 0.01859 | 0.03719 | p = 0.03719 | * | * | -0.8667 | -1.053 | Meaningful |
| 10014 | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 2.371 | 0.02005 | 2.267 | 0.02418 | -0.1047 | -4.413 | -0.1104 | -0.09896 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -10.91 | SeeDelta |
| 10014 | ForestGeometry | Risk-constrained-v6 | EmgTimely | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10014 | ForestGeometry | Constrained Oracle | TimelyRate | 0.7957 | 0.00593 | 0.8 | 0.00757 | 0.004326 | 0.4326 | -1.899e-05 | 0.008671 | 0.1857 | p = 0.1857 | 0.5571 | p = 0.5571 | n.s. | n.s. | 0.6 | 0.5918 | Below1pp |
| 10014 | ForestGeometry | Constrained Oracle | LossRate | 0.2043 | 0.00593 | 0.2 | 0.00757 | -0.004326 | -0.4326 | -0.008671 | 1.899e-05 | 0.1857 | p = 0.1857 | 0.5571 | p = 0.5571 | n.s. | n.s. | -0.6 | -0.5918 | Below1pp |
| 10014 | ForestGeometry | Constrained Oracle | AvgDelay | 0.08313 | 0.001549 | 0.08074 | 0.002957 | -0.002392 | -2.877 | -0.004172 | -0.0006118 | 0.0741 | p = 0.0741 | 0.2964 | p = 0.2964 | n.s. | n.s. | -0.7333 | -0.7987 | Meaningful |
| 10014 | ForestGeometry | Constrained Oracle | AvgTxCost | 2.602 | 0.01986 | 2.395 | 0.02095 | -0.2068 | -7.95 | -0.2137 | -0.2 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -17.98 | SeeDelta |
| 10014 | ForestGeometry | Constrained Oracle | EmgTimely | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | Default | Link-delay-aware | TimelyRate | 0.9474 | 0.006718 | 0.9314 | 0.011 | -0.01597 | -1.597 | -0.02205 | -0.009892 | 0.0004804 | p = 4.804e-04 | 0.0009609 | p = 9.609e-04 | *** | *** | -1 | -1.561 | Meaningful |
| 10006 | Default | Link-delay-aware | LossRate | 0.05258 | 0.006718 | 0.06822 | 0.01032 | 0.01564 | 1.564 | 0.009933 | 0.02135 | 0.0002701 | p = 2.701e-04 | 0.0008104 | p = 8.104e-04 | *** | *** | 1 | 1.629 | Meaningful |
| 10006 | Default | Link-delay-aware | AvgDelay | 0.03287 | 0.001428 | 0.04115 | 0.004114 | 0.008283 | 25.2 | 0.006255 | 0.01031 | 5.673e-08 | p = 5.673e-08 | 2.269e-07 | p = 2.269e-07 | *** | *** | 1 | 2.428 | Meaningful |
| 10006 | Default | Link-delay-aware | AvgTxCost | 2.147 | 0 | 2.203 | 0 | 0.05649 | 2.631 | 0.05649 | 0.05649 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | Inf | SeeDelta |
| 10006 | Default | Link-delay-aware | EmgTimely | 0.9993 | 0.001471 | 0.9928 | 0.004289 | -0.006579 | -0.6579 | -0.009344 | -0.003814 | 0.001566 | p = 0.001566 | 0.001566 | p = 0.001566 | ** | ** | -1 | -1.414 | Below1pp |
| 10006 | Default | Confidence-heuristic | TimelyRate | 0.982 | 0.004765 | 0.983 | 0.003201 | 0.0009983 | 0.09983 | -0.002326 | 0.004323 | 0.6898 | p = 0.6898 | 0.8862 | p = 0.8862 | n.s. | n.s. | 0.3 | 0.1785 | Below1pp |
| 10006 | Default | Confidence-heuristic | LossRate | 0.01797 | 0.004765 | 0.01631 | 0.002976 | -0.001664 | -0.1664 | -0.004547 | 0.00122 | 0.4431 | p = 0.4431 | 0.8862 | p = 0.8862 | n.s. | n.s. | -0.4 | -0.343 | Below1pp |
| 10006 | Default | Confidence-heuristic | AvgDelay | 0.02145 | 0.002324 | 0.0235 | 0.001621 | 0.002056 | 9.587 | 0.0005229 | 0.00359 | 0.07469 | p = 0.07469 | 0.2241 | p = 0.2241 | n.s. | n.s. | 0.7333 | 0.7971 | Meaningful |
| 10006 | Default | Confidence-heuristic | AvgTxCost | 2.468 | 0.007468 | 2.717 | 0.005693 | 0.2496 | 10.11 | 0.2463 | 0.2529 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 44.45 | SeeDelta |
| 10006 | Default | Confidence-heuristic | EmgTimely | 0.9993 | 0.001471 | 0.9941 | 0.002752 | -0.005263 | -0.5263 | -0.007012 | -0.003514 | 6.337e-05 | p = 6.337e-05 | 0.0002535 | p = 2.535e-04 | *** | *** | -1 | -1.789 | Below1pp |
| 10006 | Default | Risk-constrained-v6 | TimelyRate | 0.9837 | 0.003607 | 0.99 | 0.004242 | 0.006323 | 0.6323 | 0.005033 | 0.007612 | 7.211e-11 | p = 7.211e-11 | 1.442e-10 | p = 1.442e-10 | *** | *** | 1 | 2.914 | Below1pp |
| 10006 | Default | Risk-constrained-v6 | LossRate | 0.01631 | 0.003607 | 0.009318 | 0.004007 | -0.006988 | -0.6988 | -0.008278 | -0.005699 | 5.935e-13 | p = 5.935e-13 | 1.781e-12 | p = 1.781e-12 | *** | *** | -1 | -3.221 | Below1pp |
| 10006 | Default | Risk-constrained-v6 | AvgDelay | 0.01951 | 0.001148 | 0.02334 | 0.001221 | 0.003828 | 19.62 | 0.003432 | 0.004224 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 5.749 | Meaningful |
| 10006 | Default | Risk-constrained-v6 | AvgTxCost | 2.558 | 0.001323 | 2.843 | 0.004528 | 0.2844 | 11.11 | 0.2824 | 0.2863 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 84.98 | SeeDelta |
| 10006 | Default | Risk-constrained-v6 | EmgTimely | 0.9993 | 0.001471 | 0.9941 | 0.002752 | -0.005263 | -0.5263 | -0.007012 | -0.003514 | 6.337e-05 | p = 6.337e-05 | 6.337e-05 | p = 6.337e-05 | *** | *** | -1 | -1.789 | Below1pp |
| 10006 | Default | Constrained Oracle | TimelyRate | 0.9894 | 0.001897 | 0.9963 | 0.0007441 | 0.006988 | 0.6988 | 0.005521 | 0.008455 | 2.435e-10 | p = 2.435e-10 | 4.87e-10 | p = 4.870e-10 | *** | *** | 1 | 2.832 | Below1pp |
| 10006 | Default | Constrained Oracle | LossRate | 0.01065 | 0.001897 | 0.002329 | 0.001488 | -0.008319 | -0.8319 | -0.009309 | -0.00733 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -5 | Below1pp |
| 10006 | Default | Constrained Oracle | AvgDelay | 0.01887 | 0.0007213 | 0.02187 | 0.0003869 | 0.003004 | 15.92 | 0.002608 | 0.003399 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 4.514 | Meaningful |
| 10006 | Default | Constrained Oracle | AvgTxCost | 2.321 | 0.00624 | 2.732 | 0.006251 | 0.4101 | 17.67 | 0.4064 | 0.4138 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 65.72 | SeeDelta |
| 10006 | Default | Constrained Oracle | EmgTimely | 0.9993 | 0.001471 | 0.9954 | 0.001802 | -0.003947 | -0.3947 | -0.004822 | -0.003073 | 1.98e-09 | p = 1.980e-09 | 1.98e-09 | p = 1.980e-09 | *** | *** | -1 | -2.683 | Below1pp |
| 10006 | ForestGeometry | Link-delay-aware | TimelyRate | 0.6938 | 0.006444 | 0.7075 | 0.001823 | 0.01364 | 1.364 | 0.009725 | 0.01756 | 3.705e-06 | p = 3.705e-06 | 1.482e-05 | p = 1.482e-05 | *** | *** | 1 | 2.069 | Meaningful |
| 10006 | ForestGeometry | Link-delay-aware | LossRate | 0.3048 | 0.00784 | 0.2912 | 0.001664 | -0.01364 | -1.364 | -0.01756 | -0.009725 | 3.705e-06 | p = 3.705e-06 | 1.482e-05 | p = 1.482e-05 | *** | *** | -1 | -2.069 | Meaningful |
| 10006 | ForestGeometry | Link-delay-aware | AvgDelay | 0.09222 | 0.001979 | 0.08828 | 0.0006338 | -0.003941 | -4.274 | -0.005016 | -0.002867 | 1.092e-06 | p = 1.092e-06 | 5.46e-06 | p = 5.460e-06 | *** | *** | -1 | -2.18 | Meaningful |
| 10006 | ForestGeometry | Link-delay-aware | AvgTxCost | 2.265 | 0 | 2.265 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10006 | ForestGeometry | Link-delay-aware | EmgTimely | 0.8007 | 0.003751 | 0.8007 | 0.003751 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | ForestGeometry | Confidence-heuristic | TimelyRate | 0.7055 | 0.00353 | 0.7075 | 0.0007441 | 0.001997 | 0.1997 | -0.0001476 | 0.004141 | 0.2158 | p = 0.2158 | 0.6475 | p = 0.6475 | n.s. | n.s. | 0.6 | 0.5535 | Below1pp |
| 10006 | ForestGeometry | Confidence-heuristic | LossRate | 0.2915 | 0.005568 | 0.2895 | 0.002038 | -0.001997 | -0.1997 | -0.004141 | 0.0001476 | 0.2158 | p = 0.2158 | 0.6475 | p = 0.6475 | n.s. | n.s. | -0.6 | -0.5535 | Below1pp |
| 10006 | ForestGeometry | Confidence-heuristic | AvgDelay | 0.08931 | 0.0007552 | 0.08828 | 0.0005714 | -0.001034 | -1.158 | -0.001599 | -0.0004694 | 0.01492 | p = 0.01492 | 0.0597 | p = 0.0597 | * | n.s. | -1 | -1.089 | Meaningful |
| 10006 | ForestGeometry | Confidence-heuristic | AvgTxCost | 2.66 | 0.04184 | 2.579 | 0.04184 | -0.0807 | -3.034 | -0.0807 | -0.0807 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -Inf | SeeDelta |
| 10006 | ForestGeometry | Confidence-heuristic | EmgTimely | 0.8 | 0.001471 | 0.8 | 0.001471 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.7075 | 0.003794 | 0.7125 | 0.001392 | 0.004992 | 0.4992 | 0.002108 | 0.007875 | 0.0214 | p = 0.0214 | 0.06419 | p = 0.06419 | * | n.s. | 0.8 | 1.029 | Below1pp |
| 10006 | ForestGeometry | Risk-constrained-v6 | LossRate | 0.2912 | 0.005262 | 0.2862 | 0.001177 | -0.004992 | -0.4992 | -0.007875 | -0.002108 | 0.0214 | p = 0.0214 | 0.06419 | p = 0.06419 | * | n.s. | -0.8 | -1.029 | Below1pp |
| 10006 | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.08792 | 0.00112 | 0.08634 | 0.0009695 | -0.001577 | -1.794 | -0.002171 | -0.0009835 | 0.0004135 | p = 4.135e-04 | 0.001654 | p = 0.001654 | *** | ** | -1 | -1.579 | Meaningful |
| 10006 | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 2.941 | 0.02655 | 2.882 | 0.02697 | -0.0587 | -1.996 | -0.05908 | -0.05832 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -92.02 | SeeDelta |
| 10006 | ForestGeometry | Risk-constrained-v6 | EmgTimely | 0.8007 | 0.003751 | 0.8007 | 0.003751 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | ForestGeometry | Constrained Oracle | TimelyRate | 0.7115 | 0.002523 | 0.7121 | 0.003113 | 0.0006656 | 0.06656 | -0.0008344 | 0.002166 | 0.5553 | p = 0.5553 | 1 | p = 1 | n.s. | n.s. | 0.4 | 0.2638 | Below1pp |
| 10006 | ForestGeometry | Constrained Oracle | LossRate | 0.2869 | 0.003244 | 0.2862 | 0.00353 | -0.0006656 | -0.06656 | -0.002166 | 0.0008344 | 0.5553 | p = 0.5553 | 1 | p = 1 | n.s. | n.s. | -0.4 | -0.2638 | Below1pp |
| 10006 | ForestGeometry | Constrained Oracle | AvgDelay | 0.08751 | 0.0007812 | 0.0865 | 0.0008314 | -0.001017 | -1.162 | -0.001397 | -0.0006376 | 0.0003676 | p = 3.676e-04 | 0.00147 | p = 0.00147 | *** | ** | -1 | -1.593 | Meaningful |
| 10006 | ForestGeometry | Constrained Oracle | AvgTxCost | 2.841 | 0.02921 | 2.725 | 0.02921 | -0.1164 | -4.096 | -0.1164 | -0.1164 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -Inf | SeeDelta |
| 10006 | ForestGeometry | Constrained Oracle | EmgTimely | 0.7993 | 0.002326 | 0.7993 | 0.002326 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10011 | Default | Link-delay-aware | TimelyRate | 0.998 | 0.002169 | 0.9943 | 0.002232 | -0.003661 | -0.3661 | -0.00495 | -0.002371 | 0.0001614 | p = 1.614e-04 | 0.0006455 | p = 6.455e-04 | *** | *** | -1 | -1.687 | Below1pp |
| 10011 | Default | Link-delay-aware | LossRate | 0.001997 | 0.002169 | 0.005657 | 0.002232 | 0.003661 | 0.3661 | 0.002371 | 0.00495 | 0.0001614 | p = 1.614e-04 | 0.0006455 | p = 6.455e-04 | *** | *** | 1 | 1.687 | Below1pp |
| 10011 | Default | Link-delay-aware | AvgDelay | 0.01252 | 0.0005975 | 0.01318 | 0.0005106 | 0.0006669 | 5.328 | 0.0004505 | 0.0008833 | 4.198e-05 | p = 4.198e-05 | 0.0002099 | p = 2.099e-04 | *** | *** | 1 | 1.832 | Sub-ms |
| 10011 | Default | Link-delay-aware | AvgTxCost | 1.719 | 0 | 1.719 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10011 | Default | Link-delay-aware | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10011 | Default | Confidence-heuristic | TimelyRate | 0.9983 | 0.001664 | 0.995 | 0.002038 | -0.003328 | -0.3328 | -0.004317 | -0.002339 | 7.751e-06 | p = 7.751e-06 | 3.1e-05 | p = 3.100e-05 | *** | *** | -1 | -2 | Below1pp |
| 10011 | Default | Confidence-heuristic | LossRate | 0.001664 | 0.001664 | 0.004992 | 0.002038 | 0.003328 | 0.3328 | 0.002339 | 0.004317 | 7.751e-06 | p = 7.751e-06 | 3.1e-05 | p = 3.100e-05 | *** | *** | 1 | 2 | Below1pp |
| 10011 | Default | Confidence-heuristic | AvgDelay | 0.01246 | 0.0004936 | 0.01308 | 0.000451 | 0.0006145 | 4.931 | 0.0004456 | 0.0007835 | 1.331e-06 | p = 1.331e-06 | 6.656e-06 | p = 6.656e-06 | *** | *** | 1 | 2.162 | Sub-ms |
| 10011 | Default | Confidence-heuristic | AvgTxCost | 1.943 | 0.0208 | 1.95 | 0.01722 | 0.006988 | 0.3597 | 0.003527 | 0.01045 | 0.00729 | p = 0.00729 | 0.01458 | p = 0.01458 | ** | * | 1 | 1.2 | SeeDelta |
| 10011 | Default | Confidence-heuristic | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10011 | Default | Risk-constrained-v6 | TimelyRate | 0.9983 | 0.001664 | 0.9957 | 0.001488 | -0.002662 | -0.2662 | -0.004162 | -0.001162 | 0.01832 | p = 0.01832 | 0.05496 | p = 0.05496 | * | n.s. | -1 | -1.055 | Below1pp |
| 10011 | Default | Risk-constrained-v6 | LossRate | 0.001664 | 0.001664 | 0.004326 | 0.001488 | 0.002662 | 0.2662 | 0.001162 | 0.004162 | 0.01832 | p = 0.01832 | 0.05496 | p = 0.05496 | * | n.s. | 1 | 1.055 | Below1pp |
| 10011 | Default | Risk-constrained-v6 | AvgDelay | 0.01246 | 0.0004936 | 0.01298 | 0.0002768 | 0.0005121 | 4.109 | 0.0002668 | 0.0007573 | 0.005519 | p = 0.005519 | 0.02207 | p = 0.02207 | ** | * | 1 | 1.241 | Sub-ms |
| 10011 | Default | Risk-constrained-v6 | AvgTxCost | 1.863 | 0.01252 | 1.875 | 0.01378 | 0.01235 | 0.6627 | 0.01091 | 0.01378 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 5.112 | SeeDelta |
| 10011 | Default | Risk-constrained-v6 | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10011 | Default | Constrained Oracle | TimelyRate | 0.9983 | 0.001664 | 0.9987 | 0.001392 | 0.0003328 | 0.03328 | -0.0004947 | 0.00116 | 0.593 | p = 0.593 | 1 | p = 1 | n.s. | n.s. | 0.3333 | 0.239 | Below1pp |
| 10011 | Default | Constrained Oracle | LossRate | 0.001664 | 0.001664 | 0.001331 | 0.001392 | -0.0003328 | -0.03328 | -0.00116 | 0.0004947 | 0.593 | p = 0.593 | 1 | p = 1 | n.s. | n.s. | -0.3333 | -0.239 | Below1pp |
| 10011 | Default | Constrained Oracle | AvgDelay | 0.0128 | 0.0005364 | 0.01285 | 0.0003718 | 4.9e-05 | 0.3829 | -9.002e-05 | 0.000188 | 0.6394 | p = 0.6394 | 1 | p = 1 | n.s. | n.s. | 0.06667 | 0.2095 | Sub-ms |
| 10011 | Default | Constrained Oracle | AvgTxCost | 1.896 | 0.0172 | 1.931 | 0.0172 | 0.03494 | 1.843 | 0.03494 | 0.03494 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | Inf | SeeDelta |
| 10011 | Default | Constrained Oracle | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10011 | ForestGeometry | Link-delay-aware | TimelyRate | 0.582 | 0.01649 | 0.6715 | 0.005953 | 0.08952 | 8.952 | 0.08162 | 0.09741 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 6.741 | Meaningful |
| 10011 | ForestGeometry | Link-delay-aware | LossRate | 0.4126 | 0.01705 | 0.3268 | 0.005074 | -0.08586 | -8.586 | -0.09385 | -0.07786 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -6.385 | Meaningful |
| 10011 | ForestGeometry | Link-delay-aware | AvgDelay | 0.1564 | 0.002549 | 0.1345 | 0.0007873 | -0.02191 | -14.01 | -0.02367 | -0.02014 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -7.379 | Meaningful |
| 10011 | ForestGeometry | Link-delay-aware | AvgTxCost | 2.729 | 0 | 2.357 | 0 | -0.3724 | -13.65 | -0.3724 | -0.3724 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -Inf | SeeDelta |
| 10011 | ForestGeometry | Link-delay-aware | EmgTimely | 0.26 | 0.04183 | 0.48 | 0.06708 | 0.22 | 22 | 0.1861 | 0.2539 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 3.859 | Meaningful |
| 10011 | ForestGeometry | Confidence-heuristic | TimelyRate | 0.6749 | 0.01514 | 0.7634 | 0.007195 | 0.08852 | 8.852 | 0.07942 | 0.09762 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 5.781 | Meaningful |
| 10011 | ForestGeometry | Confidence-heuristic | LossRate | 0.3221 | 0.01654 | 0.2346 | 0.008236 | -0.08752 | -8.752 | -0.09705 | -0.07799 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -5.46 | Meaningful |
| 10011 | ForestGeometry | Confidence-heuristic | AvgDelay | 0.1387 | 0.003411 | 0.1077 | 0.001719 | -0.03102 | -22.37 | -0.03328 | -0.02877 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -8.166 | Meaningful |
| 10011 | ForestGeometry | Confidence-heuristic | AvgTxCost | 3.411 | 0.06364 | 2.99 | 0.0634 | -0.4211 | -12.35 | -0.4356 | -0.4065 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -17.23 | SeeDelta |
| 10011 | ForestGeometry | Confidence-heuristic | EmgTimely | 0.26 | 0.06519 | 0.51 | 0.08944 | 0.25 | 25 | 0.2136 | 0.2864 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 4.082 | Meaningful |
| 10011 | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.7111 | 0.01203 | 0.805 | 0.007291 | 0.09384 | 9.384 | 0.08277 | 0.1049 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 5.039 | Meaningful |
| 10011 | ForestGeometry | Risk-constrained-v6 | LossRate | 0.2835 | 0.01144 | 0.19 | 0.0068 | -0.09351 | -9.351 | -0.1034 | -0.08366 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -5.643 | Meaningful |
| 10011 | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.1233 | 0.003134 | 0.09009 | 0.003587 | -0.03322 | -26.94 | -0.03571 | -0.03072 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -7.916 | Meaningful |
| 10011 | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 3.725 | 0.1157 | 3.224 | 0.09576 | -0.5011 | -13.45 | -0.5188 | -0.4834 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -16.83 | SeeDelta |
| 10011 | ForestGeometry | Risk-constrained-v6 | EmgTimely | 0.26 | 0.04183 | 0.49 | 0.1636 | 0.23 | 23 | 0.137 | 0.323 | 0.001017 | p = 0.001017 | 0.001017 | p = 0.001017 | ** | ** | 1 | 1.469 | Meaningful |
| 10011 | ForestGeometry | Constrained Oracle | TimelyRate | 0.6955 | 0.01493 | 0.793 | 0.006401 | 0.0975 | 9.75 | 0.08556 | 0.1094 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 4.853 | Meaningful |
| 10011 | ForestGeometry | Constrained Oracle | LossRate | 0.2972 | 0.01303 | 0.201 | 0.004465 | -0.09617 | -9.617 | -0.106 | -0.08635 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -5.818 | Meaningful |
| 10011 | ForestGeometry | Constrained Oracle | AvgDelay | 0.1334 | 0.003916 | 0.09811 | 0.001947 | -0.03531 | -26.46 | -0.03783 | -0.03278 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -8.311 | Meaningful |
| 10011 | ForestGeometry | Constrained Oracle | AvgTxCost | 4.009 | 0.01833 | 3.5 | 0.0239 | -0.5083 | -12.68 | -0.5173 | -0.4994 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -33.83 | SeeDelta |
| 10011 | ForestGeometry | Constrained Oracle | EmgTimely | 0.28 | 0.07583 | 0.49 | 0.1636 | 0.21 | 21 | 0.1456 | 0.2744 | 1.479e-05 | p = 1.479e-05 | 1.479e-05 | p = 1.479e-05 | *** | *** | 1 | 1.937 | Meaningful |
| 10019 | Default | Link-delay-aware | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Link-delay-aware | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Link-delay-aware | AvgDelay | 0.01208 | 8.243e-05 | 0.01208 | 8.243e-05 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10019 | Default | Link-delay-aware | AvgTxCost | 2.5 | 0 | 2.5 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10019 | Default | Link-delay-aware | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Confidence-heuristic | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Confidence-heuristic | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Confidence-heuristic | AvgDelay | 0.01208 | 8.243e-05 | 0.01208 | 8.243e-05 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10019 | Default | Confidence-heuristic | AvgTxCost | 2.988 | 0.01301 | 2.988 | 0.01301 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10019 | Default | Confidence-heuristic | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Risk-constrained-v6 | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Risk-constrained-v6 | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Risk-constrained-v6 | AvgDelay | 0.01208 | 8.243e-05 | 0.01208 | 8.243e-05 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10019 | Default | Risk-constrained-v6 | AvgTxCost | 3.045 | 0 | 3.045 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10019 | Default | Risk-constrained-v6 | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Constrained Oracle | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Constrained Oracle | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Constrained Oracle | AvgDelay | 0.01208 | 8.243e-05 | 0.01208 | 8.243e-05 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10019 | Default | Constrained Oracle | AvgTxCost | 2.504 | 0.004487 | 2.504 | 0.004487 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10019 | Default | Constrained Oracle | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | ForestGeometry | Link-delay-aware | TimelyRate | 0.6652 | 0.004765 | 0.6213 | 0.009886 | -0.04393 | -4.393 | -0.04725 | -0.0406 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -7.854 | Meaningful |
| 10019 | ForestGeometry | Link-delay-aware | LossRate | 0.2772 | 0.005716 | 0.3408 | 0.009801 | 0.06356 | 6.356 | 0.05934 | 0.06778 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 8.954 | Meaningful |
| 10019 | ForestGeometry | Link-delay-aware | AvgDelay | 0.03965 | 0.0001199 | 0.03994 | 0.0002717 | 0.0002917 | 0.7356 | 0.0001979 | 0.0003854 | 3.582e-05 | p = 3.582e-05 | 3.582e-05 | p = 3.582e-05 | *** | *** | 1 | 1.848 | Sub-ms |
| 10019 | ForestGeometry | Link-delay-aware | AvgTxCost | 2.958 | 0 | 2.842 | 0 | -0.1164 | -3.933 | -0.1164 | -0.1164 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -Inf | SeeDelta |
| 10019 | ForestGeometry | Link-delay-aware | EmgTimely | 0.6315 | 0.005245 | 0.5832 | 0.01088 | -0.04835 | -4.835 | -0.05201 | -0.04469 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -7.854 | Meaningful |
| 10019 | ForestGeometry | Confidence-heuristic | TimelyRate | 0.6622 | 0.007893 | 0.621 | 0.007195 | -0.04126 | -4.126 | -0.04341 | -0.03912 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -11.44 | Meaningful |
| 10019 | ForestGeometry | Confidence-heuristic | LossRate | 0.2679 | 0.009486 | 0.3208 | 0.01399 | 0.05291 | 5.291 | 0.04881 | 0.05701 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 7.668 | Meaningful |
| 10019 | ForestGeometry | Confidence-heuristic | AvgDelay | 0.03987 | 0.0003005 | 0.0405 | 0.0003572 | 0.000634 | 1.59 | 0.0005604 | 0.0007076 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 5.122 | Sub-ms |
| 10019 | ForestGeometry | Confidence-heuristic | AvgTxCost | 3.363 | 0.07376 | 3.373 | 0.07376 | 0.009434 | 0.2805 | 0.009434 | 0.009434 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | Inf | SeeDelta |
| 10019 | ForestGeometry | Confidence-heuristic | EmgTimely | 0.6282 | 0.008688 | 0.5828 | 0.00792 | -0.04542 | -4.542 | -0.04778 | -0.04306 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -11.44 | Meaningful |
| 10019 | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.6652 | 0.004765 | 0.6153 | 0.01242 | -0.04992 | -4.992 | -0.05547 | -0.04437 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -5.345 | Meaningful |
| 10019 | ForestGeometry | Risk-constrained-v6 | LossRate | 0.2686 | 0.00345 | 0.3128 | 0.01072 | 0.04426 | 4.426 | 0.0376 | 0.05092 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 3.952 | Meaningful |
| 10019 | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.03985 | 0.0001451 | 0.04094 | 0.0003326 | 0.001091 | 2.737 | 0.0009311 | 0.001251 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 4.058 | Meaningful |
| 10019 | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 3.318 | 0.001406 | 3.321 | 4.965e-16 | 0.003774 | 0.1137 | 0.002938 | 0.00461 | 1.98e-09 | p = 1.980e-09 | 1.98e-09 | p = 1.980e-09 | *** | *** | 1 | 2.683 | SeeDelta |
| 10019 | ForestGeometry | Risk-constrained-v6 | EmgTimely | 0.6315 | 0.005245 | 0.5766 | 0.01367 | -0.05495 | -5.495 | -0.06106 | -0.04883 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -5.345 | Meaningful |
| 10019 | ForestGeometry | Constrained Oracle | TimelyRate | 0.6599 | 0.003645 | 0.6073 | 0.007157 | -0.05258 | -5.258 | -0.0587 | -0.04646 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -5.106 | Meaningful |
| 10019 | ForestGeometry | Constrained Oracle | LossRate | 0.2662 | 0.007253 | 0.3115 | 0.01338 | 0.04526 | 4.526 | 0.03829 | 0.05223 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 3.858 | Meaningful |
| 10019 | ForestGeometry | Constrained Oracle | AvgDelay | 0.04002 | 9.831e-05 | 0.04139 | 0.0002369 | 0.001365 | 3.411 | 0.001251 | 0.001479 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 7.124 | Meaningful |
| 10019 | ForestGeometry | Constrained Oracle | AvgTxCost | 3.015 | 0.03602 | 3.024 | 0.04652 | 0.008865 | 0.294 | 0.0001427 | 0.01759 | 0.1767 | p = 0.1767 | 0.1767 | p = 0.1767 | n.s. | n.s. | 0.6 | 0.6041 | SeeDelta |
| 10019 | ForestGeometry | Constrained Oracle | EmgTimely | 0.6256 | 0.004013 | 0.5678 | 0.007878 | -0.05788 | -5.788 | -0.06461 | -0.05114 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -5.106 | Meaningful |
| 10017 | Default | Link-delay-aware | TimelyRate | 0.9072 | 0.01173 | 0.8626 | 0.01215 | -0.04459 | -4.459 | -0.04734 | -0.04185 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -9.658 | Meaningful |
| 10017 | Default | Link-delay-aware | LossRate | 0.09285 | 0.01173 | 0.1374 | 0.01215 | 0.04459 | 4.459 | 0.04185 | 0.04734 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 9.658 | Meaningful |
| 10017 | Default | Link-delay-aware | AvgDelay | 0.03873 | 0.002945 | 0.05457 | 0.003516 | 0.01584 | 40.91 | 0.01486 | 0.01682 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 9.625 | Meaningful |
| 10017 | Default | Link-delay-aware | AvgTxCost | 1.923 | 0 | 2.047 | 0.0006379 | 0.1239 | 6.443 | 0.1235 | 0.1243 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 194.2 | SeeDelta |
| 10017 | Default | Link-delay-aware | EmgTimely | 0.9944 | 0.01242 | 0.9444 | 0.02778 | -0.05 | -5 | -0.06809 | -0.03191 | 0.0002386 | p = 2.386e-04 | 0.0002386 | p = 2.386e-04 | *** | *** | -1 | -1.643 | Meaningful |
| 10017 | Default | Confidence-heuristic | TimelyRate | 0.9561 | 0.009309 | 0.9764 | 0.008598 | 0.0203 | 2.03 | 0.0135 | 0.02709 | 7.168e-05 | p = 7.168e-05 | 0.000215 | p = 2.150e-04 | *** | *** | 1 | 1.776 | Meaningful |
| 10017 | Default | Confidence-heuristic | LossRate | 0.04393 | 0.009309 | 0.02329 | 0.008151 | -0.02063 | -2.063 | -0.02736 | -0.0139 | 4.606e-05 | p = 4.606e-05 | 0.0001842 | p = 1.842e-04 | *** | *** | -1 | -1.822 | Meaningful |
| 10017 | Default | Confidence-heuristic | AvgDelay | 0.02634 | 0.00227 | 0.02876 | 0.001925 | 0.002419 | 9.183 | 0.001005 | 0.003834 | 0.02302 | p = 0.02302 | 0.04604 | p = 0.04604 | * | * | 0.8667 | 1.017 | Meaningful |
| 10017 | Default | Confidence-heuristic | AvgTxCost | 2.357 | 0.02101 | 2.964 | 0.02898 | 0.607 | 25.75 | 0.6011 | 0.6129 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 61.32 | SeeDelta |
| 10017 | Default | Confidence-heuristic | EmgTimely | 1 | 0 | 0.9889 | 0.01521 | -0.01111 | -1.111 | -0.02015 | -0.002067 | 0.1025 | p = 0.1025 | 0.1025 | p = 0.1025 | n.s. | n.s. | -1 | -0.7303 | Meaningful |
| 10017 | Default | Risk-constrained-v6 | TimelyRate | 0.9634 | 0.009486 | 0.983 | 0.00757 | 0.01963 | 1.963 | 0.01584 | 0.02343 | 5.942e-12 | p = 5.942e-12 | 1.783e-11 | p = 1.783e-11 | *** | *** | 1 | 3.078 | Meaningful |
| 10017 | Default | Risk-constrained-v6 | LossRate | 0.03661 | 0.009486 | 0.01664 | 0.007441 | -0.01997 | -1.997 | -0.02386 | -0.01607 | 9.446e-12 | p = 9.446e-12 | 1.889e-11 | p = 1.889e-11 | *** | *** | -1 | -3.048 | Meaningful |
| 10017 | Default | Risk-constrained-v6 | AvgDelay | 0.02338 | 0.002113 | 0.02891 | 0.001538 | 0.005523 | 23.62 | 0.004976 | 0.00607 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 6.003 | Meaningful |
| 10017 | Default | Risk-constrained-v6 | AvgTxCost | 2.289 | 0.01361 | 2.862 | 0.01122 | 0.573 | 25.03 | 0.5693 | 0.5767 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 91.15 | SeeDelta |
| 10017 | Default | Risk-constrained-v6 | EmgTimely | 1 | 0 | 0.9889 | 0.01521 | -0.01111 | -1.111 | -0.02015 | -0.002067 | 0.1025 | p = 0.1025 | 0.1025 | p = 0.1025 | n.s. | n.s. | -1 | -0.7303 | Meaningful |
| 10017 | Default | Constrained Oracle | TimelyRate | 0.9787 | 0.00341 | 0.9907 | 0.004936 | 0.01198 | 1.198 | 0.00942 | 0.01454 | 4.997e-10 | p = 4.997e-10 | 1.499e-09 | p = 1.499e-09 | *** | *** | 1 | 2.782 | Meaningful |
| 10017 | Default | Constrained Oracle | LossRate | 0.0213 | 0.00341 | 0.008985 | 0.005074 | -0.01231 | -1.231 | -0.01499 | -0.009641 | 9.145e-10 | p = 9.145e-10 | 1.829e-09 | p = 1.829e-09 | *** | *** | -1 | -2.739 | Meaningful |
| 10017 | Default | Constrained Oracle | AvgDelay | 0.02074 | 0.0006898 | 0.02854 | 0.0007206 | 0.0078 | 37.6 | 0.007539 | 0.00806 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 17.8 | Meaningful |
| 10017 | Default | Constrained Oracle | AvgTxCost | 2.429 | 0.01592 | 3.208 | 0.01664 | 0.7783 | 32.04 | 0.7768 | 0.7798 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 308.2 | SeeDelta |
| 10017 | Default | Constrained Oracle | EmgTimely | 0.9944 | 0.01242 | 0.9778 | 0.03043 | -0.01667 | -1.667 | -0.03882 | 0.005486 | 0.3173 | p = 0.3173 | 0.3173 | p = 0.3173 | n.s. | n.s. | -0.6667 | -0.4472 | Meaningful |
| 10017 | ForestGeometry | Link-delay-aware | TimelyRate | 0.5225 | 0.003113 | 0.5248 | 0.003023 | 0.002329 | 0.2329 | 0.001202 | 0.003457 | 0.00604 | p = 0.00604 | 0.02416 | p = 0.02416 | ** | * | 1 | 1.228 | Below1pp |
| 10017 | ForestGeometry | Link-delay-aware | LossRate | 0.4772 | 0.003201 | 0.4749 | 0.003023 | -0.002329 | -0.2329 | -0.003457 | -0.001202 | 0.00604 | p = 0.00604 | 0.02416 | p = 0.02416 | ** | * | -1 | -1.228 | Below1pp |
| 10017 | ForestGeometry | Link-delay-aware | AvgDelay | 0.1278 | 0.000452 | 0.1273 | 0.0003077 | -0.0004628 | -0.3622 | -0.0006741 | -0.0002516 | 0.003588 | p = 0.003588 | 0.01794 | p = 0.01794 | ** | * | -1 | -1.302 | Sub-ms |
| 10017 | ForestGeometry | Link-delay-aware | AvgTxCost | 2.179 | 0 | 2.179 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10017 | ForestGeometry | Link-delay-aware | EmgTimely | 0.03333 | 0.03622 | 0.03333 | 0.03622 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | ForestGeometry | Confidence-heuristic | TimelyRate | 0.5251 | 0.00345 | 0.5275 | 0.003721 | 0.002329 | 0.2329 | 0.001202 | 0.003457 | 0.00604 | p = 0.00604 | 0.02416 | p = 0.02416 | ** | * | 1 | 1.228 | Below1pp |
| 10017 | ForestGeometry | Confidence-heuristic | LossRate | 0.4745 | 0.003607 | 0.4722 | 0.003794 | -0.002329 | -0.2329 | -0.003457 | -0.001202 | 0.00604 | p = 0.00604 | 0.02416 | p = 0.02416 | ** | * | -1 | -1.228 | Below1pp |
| 10017 | ForestGeometry | Confidence-heuristic | AvgDelay | 0.1275 | 0.0003073 | 0.127 | 0.000266 | -0.0004628 | -0.3631 | -0.0006741 | -0.0002516 | 0.003588 | p = 0.003588 | 0.01794 | p = 0.01794 | ** | * | -1 | -1.302 | Sub-ms |
| 10017 | ForestGeometry | Confidence-heuristic | AvgTxCost | 2.65 | 0.04047 | 2.65 | 0.04047 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10017 | ForestGeometry | Confidence-heuristic | EmgTimely | 0.03333 | 0.03622 | 0.03333 | 0.03622 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.5318 | 0.004794 | 0.5341 | 0.004851 | 0.002329 | 0.2329 | 0.001202 | 0.003457 | 0.00604 | p = 0.00604 | 0.02416 | p = 0.02416 | ** | * | 1 | 1.228 | Below1pp |
| 10017 | ForestGeometry | Risk-constrained-v6 | LossRate | 0.4679 | 0.005443 | 0.4656 | 0.005443 | -0.002329 | -0.2329 | -0.003457 | -0.001202 | 0.00604 | p = 0.00604 | 0.02416 | p = 0.02416 | ** | * | -1 | -1.228 | Below1pp |
| 10017 | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.1253 | 0.0007833 | 0.1248 | 0.0007787 | -0.0004628 | -0.3695 | -0.0006741 | -0.0002516 | 0.003588 | p = 0.003588 | 0.01794 | p = 0.01794 | ** | * | -1 | -1.302 | Sub-ms |
| 10017 | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 2.992 | 0.04159 | 2.992 | 0.04159 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10017 | ForestGeometry | Risk-constrained-v6 | EmgTimely | 0.03333 | 0.03622 | 0.03333 | 0.03622 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | ForestGeometry | Constrained Oracle | TimelyRate | 0.5384 | 0.005953 | 0.5401 | 0.006718 | 0.001664 | 0.1664 | 0.0001001 | 0.003228 | 0.1573 | p = 0.1573 | 0.4719 | p = 0.4719 | n.s. | n.s. | 0.7 | 0.6325 | Below1pp |
| 10017 | ForestGeometry | Constrained Oracle | LossRate | 0.4612 | 0.006593 | 0.4596 | 0.007195 | -0.001664 | -0.1664 | -0.003228 | -0.0001001 | 0.1573 | p = 0.1573 | 0.4719 | p = 0.4719 | n.s. | n.s. | -0.7 | -0.6325 | Below1pp |
| 10017 | ForestGeometry | Constrained Oracle | AvgDelay | 0.1254 | 0.001128 | 0.1251 | 0.001215 | -0.0003467 | -0.2764 | -0.0006336 | -5.972e-05 | 0.1083 | p = 0.1083 | 0.4333 | p = 0.4333 | n.s. | n.s. | -0.7333 | -0.7181 | Sub-ms |
| 10017 | ForestGeometry | Constrained Oracle | AvgTxCost | 3.754 | 0.02035 | 3.74 | 0.02035 | -0.01398 | -0.3723 | -0.01398 | -0.01398 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -Inf | SeeDelta |
| 10017 | ForestGeometry | Constrained Oracle | EmgTimely | 0.03333 | 0.03622 | 0.03333 | 0.03622 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |

## PosDeg_Emerg Significance

| Scene | Config | TargetMethod | Metric | Baseline_Mean | Baseline_Std | Proposed_Mean | Proposed_Std | Delta_Mean | DeltaPct | CI_Lower | CI_Upper | P_Value | P_Value_Display | P_Value_Holm | P_Value_Holm_Display | Significant | Significant_Holm | EffectSize_RBC | EffectSize_CohenDz | PracticalNote |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 10014 | Default | Link-delay-aware | TimelyRate | 0.9873 | 0.008131 | 0.9709 | 0.009959 | -0.01636 | -1.636 | -0.02438 | -0.008348 | 0.006656 | p = 0.006656 | 0.02662 | p = 0.02662 | ** | * | -1 | -1.214 | Meaningful |
| 10014 | Default | Link-delay-aware | LossRate | 0.01273 | 0.008131 | 0.02909 | 0.009959 | 0.01636 | 1.636 | 0.008348 | 0.02438 | 0.006656 | p = 0.006656 | 0.02662 | p = 0.02662 | ** | * | 1 | 1.214 | Meaningful |
| 10014 | Default | Link-delay-aware | AvgDelay | 0.01231 | 0.0001407 | 0.01301 | 7.458e-05 | 0.0007002 | 5.69 | 0.0006395 | 0.0007609 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 6.858 | Sub-ms |
| 10014 | Default | Link-delay-aware | AvgTxCost | 2.03 | 0 | 2.03 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10014 | Default | Link-delay-aware | EmgTimely | 1 | 0 | 0.9667 | 0.07454 | -0.03333 | -3.333 | -0.07764 | 0.01097 | 0.3173 | p = 0.3173 | 0.6346 | p = 0.6346 | n.s. | n.s. | -1 | -0.4472 | Meaningful |
| 10014 | Default | Confidence-heuristic | TimelyRate | 0.9964 | 0.004979 | 1 | 0 | 0.003636 | 0.3636 | 0.0006765 | 0.006596 | 0.1025 | p = 0.1025 | 0.3074 | p = 0.3074 | n.s. | n.s. | 1 | 0.7303 | Below1pp |
| 10014 | Default | Confidence-heuristic | LossRate | 0.003636 | 0.004979 | 0 | 0 | -0.003636 | -0.3636 | -0.006596 | -0.0006765 | 0.1025 | p = 0.1025 | 0.3074 | p = 0.3074 | n.s. | n.s. | -1 | -0.7303 | Below1pp |
| 10014 | Default | Confidence-heuristic | AvgDelay | 0.01237 | 0.0001387 | 0.01426 | 0.0004045 | 0.001891 | 15.29 | 0.001704 | 0.002078 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 6.021 | Meaningful |
| 10014 | Default | Confidence-heuristic | AvgTxCost | 3.109 | 0.1016 | 3.239 | 0.09906 | 0.1298 | 4.174 | 0.1049 | 0.1547 | 4.383e-12 | p = 4.383e-12 | 1.753e-11 | p = 1.753e-11 | *** | *** | 1 | 3.097 | SeeDelta |
| 10014 | Default | Confidence-heuristic | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10014 | Default | Risk-constrained-v6 | TimelyRate | 0.9927 | 0.007606 | 0.9964 | 0.004979 | 0.003636 | 0.3636 | 0.0006765 | 0.006596 | 0.1025 | p = 0.1025 | 0.3074 | p = 0.3074 | n.s. | n.s. | 1 | 0.7303 | Below1pp |
| 10014 | Default | Risk-constrained-v6 | LossRate | 0.007273 | 0.007606 | 0.003636 | 0.004979 | -0.003636 | -0.3636 | -0.006596 | -0.0006765 | 0.1025 | p = 0.1025 | 0.3074 | p = 0.3074 | n.s. | n.s. | -1 | -0.7303 | Below1pp |
| 10014 | Default | Risk-constrained-v6 | AvgDelay | 0.01234 | 0.0001016 | 0.01345 | 0.0003329 | 0.001108 | 8.977 | 0.0009576 | 0.001258 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 4.384 | Meaningful |
| 10014 | Default | Risk-constrained-v6 | AvgTxCost | 2.769 | 0.07625 | 2.82 | 0.07996 | 0.05091 | 1.839 | 0.04404 | 0.05778 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 4.407 | SeeDelta |
| 10014 | Default | Risk-constrained-v6 | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10014 | Default | Constrained Oracle | TimelyRate | 0.9964 | 0.004979 | 0.9982 | 0.004066 | 0.001818 | 0.1818 | -0.0005985 | 0.004235 | 0.3173 | p = 0.3173 | 0.9519 | p = 0.9519 | n.s. | n.s. | 1 | 0.4472 | Below1pp |
| 10014 | Default | Constrained Oracle | LossRate | 0.003636 | 0.004979 | 0.001818 | 0.004066 | -0.001818 | -0.1818 | -0.004235 | 0.0005985 | 0.3173 | p = 0.3173 | 0.9519 | p = 0.9519 | n.s. | n.s. | -1 | -0.4472 | Below1pp |
| 10014 | Default | Constrained Oracle | AvgDelay | 0.01417 | 0.001588 | 0.0152 | 0.00174 | 0.001036 | 7.311 | 0.0009276 | 0.001144 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 5.701 | Meaningful |
| 10014 | Default | Constrained Oracle | AvgTxCost | 2.877 | 0.06725 | 2.978 | 0.07677 | 0.1009 | 3.507 | 0.08942 | 0.1124 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 5.221 | SeeDelta |
| 10014 | Default | Constrained Oracle | EmgTimely | 1 | 0 | 0.9667 | 0.07454 | -0.03333 | -3.333 | -0.07764 | 0.01097 | 0.3173 | p = 0.3173 | 0.9519 | p = 0.9519 | n.s. | n.s. | -1 | -0.4472 | Meaningful |
| 10014 | ForestGeometry | Link-delay-aware | TimelyRate | 0.8073 | 0.0217 | 0.8236 | 0.004979 | 0.01636 | 1.636 | 0.005969 | 0.02676 | 0.0364 | p = 0.0364 | 0.1456 | p = 0.1456 | * | n.s. | 1 | 0.9358 | Meaningful |
| 10014 | ForestGeometry | Link-delay-aware | LossRate | 0.1927 | 0.0217 | 0.1764 | 0.004979 | -0.01636 | -1.636 | -0.02676 | -0.005969 | 0.0364 | p = 0.0364 | 0.1456 | p = 0.1456 | * | n.s. | -1 | -0.9358 | Meaningful |
| 10014 | ForestGeometry | Link-delay-aware | AvgDelay | 0.0126 | 0.0003879 | 0.01234 | 0.0003571 | -0.0002582 | -2.05 | -0.0002897 | -0.0002268 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -4.881 | Sub-ms |
| 10014 | ForestGeometry | Link-delay-aware | AvgTxCost | 2.145 | 0 | 2.145 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10014 | ForestGeometry | Link-delay-aware | EmgTimely | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10014 | ForestGeometry | Confidence-heuristic | TimelyRate | 0.8236 | 0.008131 | 0.8309 | 0.008131 | 0.007273 | 0.7273 | 0.004856 | 0.009689 | 6.337e-05 | p = 6.337e-05 | 0.0003169 | p = 3.169e-04 | *** | *** | 1 | 1.789 | Below1pp |
| 10014 | ForestGeometry | Confidence-heuristic | LossRate | 0.1764 | 0.008131 | 0.1691 | 0.008131 | -0.007273 | -0.7273 | -0.009689 | -0.004856 | 6.337e-05 | p = 6.337e-05 | 0.0003169 | p = 3.169e-04 | *** | *** | -1 | -1.789 | Below1pp |
| 10014 | ForestGeometry | Confidence-heuristic | AvgDelay | 0.01306 | 0.0007481 | 0.01259 | 0.000773 | -0.0004647 | -3.559 | -0.0006532 | -0.0002761 | 0.001053 | p = 0.001053 | 0.003158 | p = 0.003158 | ** | ** | -1 | -1.465 | Sub-ms |
| 10014 | ForestGeometry | Confidence-heuristic | AvgTxCost | 3.593 | 0.1251 | 3.589 | 0.1258 | -0.003818 | -0.1063 | -0.00589 | -0.001746 | 0.01431 | p = 0.01431 | 0.02861 | p = 0.02861 | * | * | -1 | -1.095 | SeeDelta |
| 10014 | ForestGeometry | Confidence-heuristic | EmgTimely | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10014 | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.8182 | 0.01113 | 0.8291 | 0.004066 | 0.01091 | 1.091 | 0.004989 | 0.01683 | 0.01431 | p = 0.01431 | 0.05722 | p = 0.05722 | * | n.s. | 1 | 1.095 | Meaningful |
| 10014 | ForestGeometry | Risk-constrained-v6 | LossRate | 0.1818 | 0.01113 | 0.1709 | 0.004066 | -0.01091 | -1.091 | -0.01683 | -0.004989 | 0.01431 | p = 0.01431 | 0.05722 | p = 0.05722 | * | n.s. | -1 | -1.095 | Meaningful |
| 10014 | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.01294 | 0.0007256 | 0.01258 | 0.0007401 | -0.0003677 | -2.841 | -0.0004391 | -0.0002964 | 7.428e-12 | p = 7.428e-12 | 3.714e-11 | p = 3.714e-11 | *** | *** | -1 | -3.063 | Sub-ms |
| 10014 | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 3.321 | 0.1123 | 3.313 | 0.1063 | -0.008909 | -0.2682 | -0.01675 | -0.001065 | 0.1311 | p = 0.1311 | 0.2623 | p = 0.2623 | n.s. | n.s. | -1 | -0.6751 | SeeDelta |
| 10014 | ForestGeometry | Risk-constrained-v6 | EmgTimely | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10014 | ForestGeometry | Constrained Oracle | TimelyRate | 0.8255 | 0.007606 | 0.8309 | 0.008131 | 0.005455 | 0.5455 | 0.002495 | 0.008414 | 0.01431 | p = 0.01431 | 0.05722 | p = 0.05722 | * | n.s. | 1 | 1.095 | Below1pp |
| 10014 | ForestGeometry | Constrained Oracle | LossRate | 0.1745 | 0.007606 | 0.1691 | 0.008131 | -0.005455 | -0.5455 | -0.008414 | -0.002495 | 0.01431 | p = 0.01431 | 0.05722 | p = 0.05722 | * | n.s. | -1 | -1.095 | Below1pp |
| 10014 | ForestGeometry | Constrained Oracle | AvgDelay | 0.01447 | 0.001102 | 0.01396 | 0.001125 | -0.000502 | -3.47 | -0.0007214 | -0.0002826 | 0.002353 | p = 0.002353 | 0.01177 | p = 0.01177 | ** | * | -1 | -1.36 | Sub-ms |
| 10014 | ForestGeometry | Constrained Oracle | AvgTxCost | 3.446 | 0.09406 | 3.425 | 0.1031 | -0.02036 | -0.591 | -0.03672 | -0.004006 | 0.09799 | p = 0.09799 | 0.196 | p = 0.196 | n.s. | n.s. | -1 | -0.74 | SeeDelta |
| 10014 | ForestGeometry | Constrained Oracle | EmgTimely | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | Default | Link-delay-aware | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | Default | Link-delay-aware | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | Default | Link-delay-aware | AvgDelay | 0.01223 | 0.0001657 | 0.01227 | 0.0001882 | 3.745e-05 | 0.3061 | 3.89e-06 | 7.1e-05 | 0.138 | p = 0.138 | 0.69 | p = 0.69 | n.s. | n.s. | 1 | 0.6633 | Sub-ms |
| 10006 | Default | Link-delay-aware | AvgTxCost | 2.55 | 0 | 2.55 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10006 | Default | Link-delay-aware | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | Default | Confidence-heuristic | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | Default | Confidence-heuristic | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | Default | Confidence-heuristic | AvgDelay | 0.01223 | 0.0001657 | 0.01227 | 0.0001882 | 3.745e-05 | 0.3061 | 3.89e-06 | 7.1e-05 | 0.138 | p = 0.138 | 0.69 | p = 0.69 | n.s. | n.s. | 1 | 0.6633 | Sub-ms |
| 10006 | Default | Confidence-heuristic | AvgTxCost | 2.671 | 0.02627 | 2.671 | 0.02627 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10006 | Default | Confidence-heuristic | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | Default | Risk-constrained-v6 | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | Default | Risk-constrained-v6 | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | Default | Risk-constrained-v6 | AvgDelay | 0.01223 | 0.0001657 | 0.01227 | 0.0001882 | 3.745e-05 | 0.3061 | 3.89e-06 | 7.1e-05 | 0.138 | p = 0.138 | 0.69 | p = 0.69 | n.s. | n.s. | 1 | 0.6633 | Sub-ms |
| 10006 | Default | Risk-constrained-v6 | AvgTxCost | 3.15 | 0 | 3.15 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10006 | Default | Risk-constrained-v6 | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | Default | Constrained Oracle | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | Default | Constrained Oracle | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | Default | Constrained Oracle | AvgDelay | 0.01223 | 0.0001657 | 0.01227 | 0.0001882 | 3.745e-05 | 0.3061 | 3.89e-06 | 7.1e-05 | 0.138 | p = 0.138 | 0.69 | p = 0.69 | n.s. | n.s. | 1 | 0.6633 | Sub-ms |
| 10006 | Default | Constrained Oracle | AvgTxCost | 2.55 | 0 | 2.55 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10006 | Default | Constrained Oracle | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | ForestGeometry | Link-delay-aware | TimelyRate | 0.8945 | 0.004979 | 0.8945 | 0.004979 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | ForestGeometry | Link-delay-aware | LossRate | 0.1036 | 0.004979 | 0.1036 | 0.004979 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | ForestGeometry | Link-delay-aware | AvgDelay | 0.01268 | 0.0004525 | 0.01268 | 0.0004525 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10006 | ForestGeometry | Link-delay-aware | AvgTxCost | 2.615 | 0 | 2.615 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10006 | ForestGeometry | Link-delay-aware | EmgTimely | 0.8945 | 0.004979 | 0.8945 | 0.004979 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | ForestGeometry | Confidence-heuristic | TimelyRate | 0.8945 | 0.004979 | 0.8945 | 0.004979 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | ForestGeometry | Confidence-heuristic | LossRate | 0.1018 | 0.007606 | 0.1018 | 0.007606 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | ForestGeometry | Confidence-heuristic | AvgDelay | 0.01287 | 0.0007127 | 0.01287 | 0.0007127 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10006 | ForestGeometry | Confidence-heuristic | AvgTxCost | 2.916 | 0.1259 | 2.916 | 0.1259 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10006 | ForestGeometry | Confidence-heuristic | EmgTimely | 0.8945 | 0.004979 | 0.8945 | 0.004979 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.8945 | 0.004979 | 0.8945 | 0.004979 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | ForestGeometry | Risk-constrained-v6 | LossRate | 0.1036 | 0.004979 | 0.1036 | 0.004979 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.01268 | 0.0004525 | 0.01268 | 0.0004525 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10006 | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 3.15 | 0 | 3.15 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10006 | ForestGeometry | Risk-constrained-v6 | EmgTimely | 0.8945 | 0.004979 | 0.8945 | 0.004979 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | ForestGeometry | Constrained Oracle | TimelyRate | 0.8927 | 0.004066 | 0.8927 | 0.004066 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | ForestGeometry | Constrained Oracle | LossRate | 0.1055 | 0.004979 | 0.1055 | 0.004979 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10006 | ForestGeometry | Constrained Oracle | AvgDelay | 0.01252 | 0.0002994 | 0.01252 | 0.0002994 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10006 | ForestGeometry | Constrained Oracle | AvgTxCost | 2.703 | 0.1101 | 2.703 | 0.1101 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10006 | ForestGeometry | Constrained Oracle | EmgTimely | 0.8927 | 0.004066 | 0.8927 | 0.004066 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10011 | Default | Link-delay-aware | TimelyRate | 0.9982 | 0.004066 | 0.9982 | 0.004066 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10011 | Default | Link-delay-aware | LossRate | 0.001818 | 0.004066 | 0.001818 | 0.004066 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10011 | Default | Link-delay-aware | AvgDelay | 0.01222 | 0.0001727 | 0.01222 | 0.0001727 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10011 | Default | Link-delay-aware | AvgTxCost | 2 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10011 | Default | Link-delay-aware | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | NotApplicable |
| 10011 | Default | Confidence-heuristic | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10011 | Default | Confidence-heuristic | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10011 | Default | Confidence-heuristic | AvgDelay | 0.01223 | 0.0001657 | 0.01223 | 0.0001657 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10011 | Default | Confidence-heuristic | AvgTxCost | 2.993 | 0.1009 | 2.993 | 0.1009 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10011 | Default | Confidence-heuristic | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | NotApplicable |
| 10011 | Default | Risk-constrained-v6 | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10011 | Default | Risk-constrained-v6 | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10011 | Default | Risk-constrained-v6 | AvgDelay | 0.01223 | 0.0001657 | 0.01223 | 0.0001657 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10011 | Default | Risk-constrained-v6 | AvgTxCost | 2.657 | 0.06664 | 2.657 | 0.06664 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10011 | Default | Risk-constrained-v6 | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | NotApplicable |
| 10011 | Default | Constrained Oracle | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10011 | Default | Constrained Oracle | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10011 | Default | Constrained Oracle | AvgDelay | 0.01407 | 0.001922 | 0.01407 | 0.001922 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10011 | Default | Constrained Oracle | AvgTxCost | 2.833 | 0.07884 | 2.833 | 0.07884 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10011 | Default | Constrained Oracle | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | NotApplicable |
| 10011 | ForestGeometry | Link-delay-aware | TimelyRate | 0.7382 | 0.04035 | 0.9291 | 0.0217 | 0.1909 | 19.09 | 0.1659 | 0.216 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 4.529 | Meaningful |
| 10011 | ForestGeometry | Link-delay-aware | LossRate | 0.2618 | 0.04035 | 0.07091 | 0.0217 | -0.1909 | -19.09 | -0.216 | -0.1659 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -4.529 | Meaningful |
| 10011 | ForestGeometry | Link-delay-aware | AvgDelay | 0.01858 | 0.0001173 | 0.01292 | 0.0002346 | -0.005661 | -30.47 | -0.005782 | -0.00554 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -27.79 | Meaningful |
| 10011 | ForestGeometry | Link-delay-aware | AvgTxCost | 2 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10011 | ForestGeometry | Link-delay-aware | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | NotApplicable |
| 10011 | ForestGeometry | Confidence-heuristic | TimelyRate | 0.9691 | 0.01037 | 0.9927 | 0.007606 | 0.02364 | 2.364 | 0.01382 | 0.03345 | 0.001373 | p = 0.001373 | 0.004118 | p = 0.004118 | ** | ** | 1 | 1.431 | Meaningful |
| 10011 | ForestGeometry | Confidence-heuristic | LossRate | 0.03091 | 0.01037 | 0.007273 | 0.007606 | -0.02364 | -2.364 | -0.03345 | -0.01382 | 0.001373 | p = 0.001373 | 0.004118 | p = 0.004118 | ** | ** | -1 | -1.431 | Meaningful |
| 10011 | ForestGeometry | Confidence-heuristic | AvgDelay | 0.02254 | 0.0008568 | 0.01382 | 0.0004184 | -0.00872 | -38.69 | -0.009264 | -0.008176 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -9.53 | Meaningful |
| 10011 | ForestGeometry | Confidence-heuristic | AvgTxCost | 3.585 | 0.08642 | 3.077 | 0.1488 | -0.508 | -14.17 | -0.5632 | -0.4528 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -5.47 | SeeDelta |
| 10011 | ForestGeometry | Confidence-heuristic | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | NotApplicable |
| 10011 | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.9673 | 0.008131 | 0.9891 | 0.007606 | 0.02182 | 2.182 | 0.01566 | 0.02798 | 2.519e-06 | p = 2.519e-06 | 7.558e-06 | p = 7.558e-06 | *** | *** | 1 | 2.105 | Meaningful |
| 10011 | ForestGeometry | Risk-constrained-v6 | LossRate | 0.03273 | 0.008131 | 0.01091 | 0.007606 | -0.02182 | -2.182 | -0.02798 | -0.01566 | 2.519e-06 | p = 2.519e-06 | 7.558e-06 | p = 7.558e-06 | *** | *** | -1 | -2.105 | Meaningful |
| 10011 | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.02193 | 0.0005324 | 0.01373 | 0.0004035 | -0.008207 | -37.42 | -0.008552 | -0.007861 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -14.1 | Meaningful |
| 10011 | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 3.5 | 0.02172 | 2.875 | 0.09612 | -0.6247 | -17.85 | -0.6709 | -0.5785 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -8.041 | SeeDelta |
| 10011 | ForestGeometry | Risk-constrained-v6 | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | NotApplicable |
| 10011 | ForestGeometry | Constrained Oracle | TimelyRate | 0.9745 | 0.01494 | 0.9891 | 0.007606 | 0.01455 | 1.455 | 0.00334 | 0.02575 | 0.08447 | p = 0.08447 | 0.2534 | p = 0.2534 | n.s. | n.s. | 0.7333 | 0.7716 | Meaningful |
| 10011 | ForestGeometry | Constrained Oracle | LossRate | 0.02545 | 0.01494 | 0.01091 | 0.007606 | -0.01455 | -1.455 | -0.02575 | -0.00334 | 0.08447 | p = 0.08447 | 0.2534 | p = 0.2534 | n.s. | n.s. | -0.7333 | -0.7716 | Meaningful |
| 10011 | ForestGeometry | Constrained Oracle | AvgDelay | 0.0221 | 0.0006115 | 0.01494 | 0.001017 | -0.007153 | -32.37 | -0.007457 | -0.006849 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -13.99 | Meaningful |
| 10011 | ForestGeometry | Constrained Oracle | AvgTxCost | 3.651 | 0.08503 | 2.953 | 0.1125 | -0.6989 | -19.14 | -0.7685 | -0.6293 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -5.971 | SeeDelta |
| 10011 | ForestGeometry | Constrained Oracle | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | NotApplicable |
| 10019 | Default | Link-delay-aware | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Link-delay-aware | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Link-delay-aware | AvgDelay | 0.01223 | 0.0001657 | 0.01223 | 0.0001657 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10019 | Default | Link-delay-aware | AvgTxCost | 2.55 | 0 | 2.55 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10019 | Default | Link-delay-aware | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Confidence-heuristic | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Confidence-heuristic | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Confidence-heuristic | AvgDelay | 0.01223 | 0.0001657 | 0.01223 | 0.0001657 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10019 | Default | Confidence-heuristic | AvgTxCost | 3.021 | 0.02269 | 3.021 | 0.02269 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10019 | Default | Confidence-heuristic | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Risk-constrained-v6 | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Risk-constrained-v6 | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Risk-constrained-v6 | AvgDelay | 0.01223 | 0.0001657 | 0.01223 | 0.0001657 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10019 | Default | Risk-constrained-v6 | AvgTxCost | 3.15 | 0 | 3.15 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10019 | Default | Risk-constrained-v6 | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Constrained Oracle | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Constrained Oracle | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | Default | Constrained Oracle | AvgDelay | 0.01223 | 0.0001657 | 0.01223 | 0.0001657 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10019 | Default | Constrained Oracle | AvgTxCost | 2.573 | 0.02452 | 2.573 | 0.02452 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10019 | Default | Constrained Oracle | EmgTimely | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10019 | ForestGeometry | Link-delay-aware | TimelyRate | 0.5873 | 0.01379 | 0.4455 | 0.02802 | -0.1418 | -14.18 | -0.1564 | -0.1272 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -5.774 | Meaningful |
| 10019 | ForestGeometry | Link-delay-aware | LossRate | 0.2055 | 0.03188 | 0.4073 | 0.04518 | 0.2018 | 20.18 | 0.1901 | 0.2135 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 10.24 | Meaningful |
| 10019 | ForestGeometry | Link-delay-aware | AvgDelay | 0.0531 | 0.001426 | 0.04662 | 0.003053 | -0.006478 | -12.2 | -0.007599 | -0.005357 | 1.599e-14 | p = 1.599e-14 | 1.599e-14 | p = 1.599e-14 | *** | *** | -1 | -3.435 | Meaningful |
| 10019 | ForestGeometry | Link-delay-aware | AvgTxCost | 3.828 | 0 | 3.433 | 0 | -0.3952 | -10.32 | -0.3952 | -0.3952 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -Inf | SeeDelta |
| 10019 | ForestGeometry | Link-delay-aware | EmgTimely | 0.5873 | 0.01379 | 0.4455 | 0.02802 | -0.1418 | -14.18 | -0.1564 | -0.1272 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -5.774 | Meaningful |
| 10019 | ForestGeometry | Confidence-heuristic | TimelyRate | 0.5836 | 0.02353 | 0.4455 | 0.03857 | -0.1382 | -13.82 | -0.1486 | -0.1278 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -7.902 | Meaningful |
| 10019 | ForestGeometry | Confidence-heuristic | LossRate | 0.1673 | 0.03315 | 0.3218 | 0.05842 | 0.1545 | 15.45 | 0.1347 | 0.1744 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 4.627 | Meaningful |
| 10019 | ForestGeometry | Confidence-heuristic | AvgDelay | 0.05516 | 0.001894 | 0.05338 | 0.003544 | -0.001781 | -3.228 | -0.003081 | -0.0004801 | 0.06878 | p = 0.06878 | 0.06878 | p = 0.06878 | n.s. | n.s. | -0.7333 | -0.8139 | Meaningful |
| 10019 | ForestGeometry | Confidence-heuristic | AvgTxCost | 4.267 | 0.1607 | 4.319 | 0.1607 | 0.05155 | 1.208 | 0.05155 | 0.05155 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | Inf | SeeDelta |
| 10019 | ForestGeometry | Confidence-heuristic | EmgTimely | 0.5836 | 0.02353 | 0.4455 | 0.03857 | -0.1382 | -13.82 | -0.1486 | -0.1278 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -7.902 | Meaningful |
| 10019 | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.5891 | 0.01348 | 0.4091 | 0.0334 | -0.18 | -18 | -0.2004 | -0.1596 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -5.254 | Meaningful |
| 10019 | ForestGeometry | Risk-constrained-v6 | LossRate | 0.1745 | 0.02353 | 0.2745 | 0.04609 | 0.1 | 10 | 0.07408 | 0.1259 | 2.922e-07 | p = 2.922e-07 | 5.843e-07 | p = 5.843e-07 | *** | *** | 1 | 2.294 | Meaningful |
| 10019 | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.05481 | 0.0008633 | 0.05882 | 0.002446 | 0.004011 | 7.318 | 0.002903 | 0.005118 | 1.482e-06 | p = 1.482e-06 | 1.482e-06 | p = 1.482e-06 | *** | *** | 1 | 2.153 | Meaningful |
| 10019 | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 4.215 | 0 | 4.421 | 0 | 0.2062 | 4.891 | 0.2062 | 0.2062 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | Inf | SeeDelta |
| 10019 | ForestGeometry | Risk-constrained-v6 | EmgTimely | 0.5891 | 0.01348 | 0.4091 | 0.0334 | -0.18 | -18 | -0.2004 | -0.1596 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -5.254 | Meaningful |
| 10019 | ForestGeometry | Constrained Oracle | TimelyRate | 0.5727 | 0.01701 | 0.3782 | 0.02456 | -0.1945 | -19.45 | -0.2086 | -0.1805 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -8.207 | Meaningful |
| 10019 | ForestGeometry | Constrained Oracle | LossRate | 0.1455 | 0.03214 | 0.2473 | 0.04136 | 0.1018 | 10.18 | 0.08294 | 0.1207 | 7.55e-13 | p = 7.550e-13 | 7.55e-13 | p = 7.550e-13 | *** | *** | 1 | 3.207 | Meaningful |
| 10019 | ForestGeometry | Constrained Oracle | AvgDelay | 0.05648 | 0.001452 | 0.06226 | 0.00238 | 0.005774 | 10.22 | 0.004997 | 0.006552 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 4.414 | Meaningful |
| 10019 | ForestGeometry | Constrained Oracle | AvgTxCost | 4.318 | 0.04286 | 4.566 | 0.05576 | 0.2487 | 5.759 | 0.2352 | 0.2621 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | 1 | 10.98 | SeeDelta |
| 10019 | ForestGeometry | Constrained Oracle | EmgTimely | 0.5727 | 0.01701 | 0.3782 | 0.02456 | -0.1945 | -19.45 | -0.2086 | -0.1805 | 2.225e-308 | p < 2.3e-308 | 1.113e-307 | p < 2.3e-308 | *** | *** | -1 | -8.207 | Meaningful |
| 10017 | Default | Link-delay-aware | TimelyRate | 0.9982 | 0.004066 | 0.9982 | 0.004066 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | Default | Link-delay-aware | LossRate | 0.001818 | 0.004066 | 0.001818 | 0.004066 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | Default | Link-delay-aware | AvgDelay | 0.01222 | 0.0001727 | 0.01222 | 0.0001727 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10017 | Default | Link-delay-aware | AvgTxCost | 2 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10017 | Default | Link-delay-aware | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | NotApplicable |
| 10017 | Default | Confidence-heuristic | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | Default | Confidence-heuristic | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | Default | Confidence-heuristic | AvgDelay | 0.01223 | 0.0001657 | 0.01223 | 0.0001657 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10017 | Default | Confidence-heuristic | AvgTxCost | 2.993 | 0.1078 | 2.993 | 0.1078 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10017 | Default | Confidence-heuristic | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | NotApplicable |
| 10017 | Default | Risk-constrained-v6 | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | Default | Risk-constrained-v6 | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | Default | Risk-constrained-v6 | AvgDelay | 0.01223 | 0.0001657 | 0.01223 | 0.0001657 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10017 | Default | Risk-constrained-v6 | AvgTxCost | 2.657 | 0.06664 | 2.657 | 0.06664 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10017 | Default | Risk-constrained-v6 | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | NotApplicable |
| 10017 | Default | Constrained Oracle | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | Default | Constrained Oracle | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | Default | Constrained Oracle | AvgDelay | 0.01409 | 0.001927 | 0.01409 | 0.001927 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10017 | Default | Constrained Oracle | AvgTxCost | 2.83 | 0.07662 | 2.83 | 0.07662 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10017 | Default | Constrained Oracle | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | NotApplicable |
| 10017 | ForestGeometry | Link-delay-aware | TimelyRate | 0.9982 | 0.004066 | 0.9982 | 0.004066 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | ForestGeometry | Link-delay-aware | LossRate | 0.001818 | 0.004066 | 0.001818 | 0.004066 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | ForestGeometry | Link-delay-aware | AvgDelay | 0.01222 | 0.0001727 | 0.01222 | 0.0001727 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10017 | ForestGeometry | Link-delay-aware | AvgTxCost | 2 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10017 | ForestGeometry | Link-delay-aware | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | NotApplicable |
| 10017 | ForestGeometry | Confidence-heuristic | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | ForestGeometry | Confidence-heuristic | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | ForestGeometry | Confidence-heuristic | AvgDelay | 0.01223 | 0.0001657 | 0.01223 | 0.0001657 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10017 | ForestGeometry | Confidence-heuristic | AvgTxCost | 2.959 | 0.1239 | 2.959 | 0.1239 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10017 | ForestGeometry | Confidence-heuristic | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | NotApplicable |
| 10017 | ForestGeometry | Risk-constrained-v6 | TimelyRate | 0.9982 | 0.004066 | 0.9982 | 0.004066 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | ForestGeometry | Risk-constrained-v6 | LossRate | 0.001818 | 0.004066 | 0.001818 | 0.004066 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | ForestGeometry | Risk-constrained-v6 | AvgDelay | 0.01222 | 0.0001727 | 0.01222 | 0.0001727 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10017 | ForestGeometry | Risk-constrained-v6 | AvgTxCost | 2.724 | 0.0977 | 2.724 | 0.0977 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10017 | ForestGeometry | Risk-constrained-v6 | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | NotApplicable |
| 10017 | ForestGeometry | Constrained Oracle | TimelyRate | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | ForestGeometry | Constrained Oracle | LossRate | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Below1pp |
| 10017 | ForestGeometry | Constrained Oracle | AvgDelay | 0.01352 | 0.001106 | 0.01352 | 0.001106 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | Sub-ms |
| 10017 | ForestGeometry | Constrained Oracle | AvgTxCost | 2.836 | 0.09973 | 2.836 | 0.09973 | 0 | 0 | 0 | 0 | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | SeeDelta |
| 10017 | ForestGeometry | Constrained Oracle | EmgTimely | NaN | NaN | NaN | NaN | NaN | NaN | NaN | NaN | 1 | p = 1 | 1 | p = 1 | n.s. | n.s. | 0 | 0 | NotApplicable |

## Interpretation

- `ApproximationStable` means rate deltas are within 1 percentage point and delay/cost deltas are within 5%.
- `SmallBiasDiscuss` means the approximation is usable but should be explicitly discussed.
- `MaterialBias` means final results should either use PER lookup or report sigmoid approximation as a limitation.
