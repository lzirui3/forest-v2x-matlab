# Step56 成本收益与 Pareto trade-off 报告

本报告用于回应审稿人关于“是否用更高通信成本换取微小收益”的问题。输入来自 Step54/Step55，不重新运行仿真。

Pareto 图：`step56_cost_efficiency_pareto_overall_pareto.png`，差分 trade-off 图：`step56_cost_efficiency_pareto_delta_tradeoff.png`。

## 1. 成本收益分类统计

| Class | Count |
|---|---:|
| DominantOrCostSaving | 22 |
| CostlyButMeaningful | 17 |
| WeakGainWithCost | 18 |
| CostInefficientBoundary | 6 |
| MixedBoundary | 1 |

## 2. Risk-constrained-v6 相对各 baseline 的逐场景成本收益

| Scene | Config | Baseline | ΔTimely (pp) | ΔEmergency (pp) | ΔLoss (pp) | ΔCost (%) | Gain/cost | Class |
|---|---|---|---:|---:|---:|---:|---:|---|
| 10014 | Default | DCC-like | 1.195 | 0.000 | -1.195 | -50.88 | NaN | DominantOrCostSaving |
| 10014 | Default | AoI-aware | 1.478 | 13.667 | -1.478 | -9.04 | NaN | DominantOrCostSaving |
| 10014 | Default | Link-delay-aware | 5.724 | 1.667 | -5.724 | 22.77 | 0.251 | CostlyButMeaningful |
| 10014 | Default | Confidence-heuristic | 0.343 | 0.000 | -0.343 | -4.40 | NaN | DominantOrCostSaving |
| 10014 | ForestGeometry | DCC-like | -0.043 | 1.333 | 0.037 | -40.95 | NaN | DominantOrCostSaving |
| 10014 | ForestGeometry | AoI-aware | 0.612 | 0.667 | -0.616 | -3.58 | NaN | DominantOrCostSaving |
| 10014 | ForestGeometry | Link-delay-aware | 1.181 | 0.000 | -1.181 | 34.50 | 0.034 | CostlyButMeaningful |
| 10014 | ForestGeometry | Confidence-heuristic | 1.032 | 0.333 | -1.018 | 9.40 | 0.110 | CostlyButMeaningful |
| 10006 | Default | DCC-like | 7.155 | -0.046 | -7.201 | -36.23 | NaN | DominantOrCostSaving |
| 10006 | Default | AoI-aware | 1.797 | 0.533 | -1.760 | 20.14 | 0.089 | CostlyButMeaningful |
| 10006 | Default | Link-delay-aware | 5.900 | 0.434 | -5.960 | 29.31 | 0.201 | CostlyButMeaningful |
| 10006 | Default | Confidence-heuristic | 0.176 | 0.000 | -0.176 | 4.53 | 0.039 | WeakGainWithCost |
| 10006 | ForestGeometry | DCC-like | 0.419 | 0.151 | -0.479 | -30.30 | NaN | DominantOrCostSaving |
| 10006 | ForestGeometry | AoI-aware | 0.116 | 0.125 | 0.080 | 9.29 | 0.013 | WeakGainWithCost |
| 10006 | ForestGeometry | Link-delay-aware | 0.619 | 0.000 | -0.619 | 28.01 | 0.022 | WeakGainWithCost |
| 10006 | ForestGeometry | Confidence-heuristic | 0.522 | -0.007 | -0.429 | 10.86 | 0.048 | WeakGainWithCost |
| 10011 | Default | DCC-like | -0.486 | 0.000 | 0.486 | -47.90 | NaN | DominantOrCostSaving |
| 10011 | Default | AoI-aware | 0.190 | 0.300 | -0.190 | 2.87 | 0.066 | WeakGainWithCost |
| 10011 | Default | Link-delay-aware | 0.233 | 0.000 | -0.233 | 9.86 | 0.024 | WeakGainWithCost |
| 10011 | Default | Confidence-heuristic | 0.123 | 0.000 | -0.123 | -3.63 | NaN | DominantOrCostSaving |
| 10011 | ForestGeometry | DCC-like | 19.441 | 9.300 | -19.844 | 8.85 | 2.196 | CostlyButMeaningful |
| 10011 | ForestGeometry | AoI-aware | -0.273 | 15.800 | -0.223 | -20.15 | NaN | DominantOrCostSaving |
| 10011 | ForestGeometry | Link-delay-aware | 12.889 | 3.400 | -13.211 | 36.84 | 0.350 | CostlyButMeaningful |
| 10011 | ForestGeometry | Confidence-heuristic | 4.100 | 0.100 | -4.399 | 7.31 | 0.561 | CostlyButMeaningful |
| 10019 | Default | DCC-like | -0.013 | 0.000 | 0.013 | -33.53 | NaN | DominantOrCostSaving |
| 10019 | Default | AoI-aware | 0.193 | 0.212 | -0.193 | 80.44 | 0.002 | WeakGainWithCost |
| 10019 | Default | Link-delay-aware | 0.000 | 0.000 | 0.000 | 21.81 | 0.000 | WeakGainWithCost |
| 10019 | Default | Confidence-heuristic | 0.000 | 0.000 | 0.000 | 2.16 | 0.000 | WeakGainWithCost |
| 10019 | ForestGeometry | DCC-like | 0.572 | 0.645 | -6.146 | -12.06 | NaN | DominantOrCostSaving |
| 10019 | ForestGeometry | AoI-aware | -0.832 | -0.916 | 0.526 | 0.23 | -3.670 | CostInefficientBoundary |
| 10019 | ForestGeometry | Link-delay-aware | -0.715 | -0.788 | -2.729 | 16.93 | -0.042 | CostInefficientBoundary |
| 10019 | ForestGeometry | Confidence-heuristic | -0.672 | -0.740 | -0.626 | -0.53 | NaN | CostInefficientBoundary |
| 10017 | Default | DCC-like | 8.476 | -1.222 | -8.469 | -39.30 | NaN | DominantOrCostSaving |
| 10017 | Default | AoI-aware | 3.042 | 3.889 | -3.042 | -13.80 | NaN | DominantOrCostSaving |
| 10017 | Default | Link-delay-aware | 11.085 | 4.944 | -11.098 | 40.17 | 0.276 | CostlyButMeaningful |
| 10017 | Default | Confidence-heuristic | 0.173 | 0.000 | -0.173 | -3.77 | NaN | DominantOrCostSaving |
| 10017 | ForestGeometry | DCC-like | 1.138 | 0.278 | -1.171 | -25.64 | NaN | DominantOrCostSaving |
| 10017 | ForestGeometry | AoI-aware | -0.479 | -0.611 | 0.606 | -26.73 | NaN | CostInefficientBoundary |
| 10017 | ForestGeometry | Link-delay-aware | 0.905 | 0.000 | -0.905 | 37.84 | 0.024 | WeakGainWithCost |
| 10017 | ForestGeometry | Confidence-heuristic | 0.619 | 0.000 | -0.616 | 12.12 | 0.051 | WeakGainWithCost |
| 10013 | Default | DCC-like | -0.745 | 0.000 | 0.745 | -33.92 | NaN | DominantOrCostSaving |
| 10013 | Default | AoI-aware | 0.552 | 0.650 | -0.552 | 80.39 | 0.007 | WeakGainWithCost |
| 10013 | Default | Link-delay-aware | 0.023 | 0.026 | -0.023 | 21.77 | 0.001 | WeakGainWithCost |
| 10013 | Default | Confidence-heuristic | 0.000 | 0.000 | 0.000 | 2.54 | 0.000 | WeakGainWithCost |
| 10013 | ForestGeometry | DCC-like | 0.872 | 0.851 | -6.309 | 2.36 | 0.369 | WeakGainWithCost |
| 10013 | ForestGeometry | AoI-aware | -0.103 | 0.048 | -1.225 | 1.58 | -0.065 | MixedBoundary |
| 10013 | ForestGeometry | Link-delay-aware | -0.589 | -0.694 | -2.316 | 17.17 | -0.034 | CostInefficientBoundary |
| 10013 | ForestGeometry | Confidence-heuristic | -0.459 | -0.536 | -2.087 | 6.25 | -0.073 | CostInefficientBoundary |
| 10007 | Default | DCC-like | 6.899 | 0.000 | -6.899 | -41.45 | NaN | DominantOrCostSaving |
| 10007 | Default | AoI-aware | 1.787 | 0.071 | -1.787 | 23.11 | 0.077 | CostlyButMeaningful |
| 10007 | Default | Link-delay-aware | 3.957 | 0.000 | -3.957 | 25.33 | 0.156 | CostlyButMeaningful |
| 10007 | Default | Confidence-heuristic | 0.063 | 0.000 | -0.063 | 2.90 | 0.022 | WeakGainWithCost |
| 10007 | ForestGeometry | DCC-like | -0.466 | 0.000 | 0.466 | -44.15 | NaN | DominantOrCostSaving |
| 10007 | ForestGeometry | AoI-aware | 0.908 | 0.071 | -0.908 | 17.17 | 0.053 | WeakGainWithCost |
| 10007 | ForestGeometry | Link-delay-aware | 1.381 | 0.000 | -1.381 | 22.75 | 0.061 | CostlyButMeaningful |
| 10007 | ForestGeometry | Confidence-heuristic | 0.120 | 0.000 | -0.120 | 9.02 | 0.013 | WeakGainWithCost |
| 10015 | Default | DCC-like | 3.298 | 0.000 | -3.298 | -24.64 | NaN | DominantOrCostSaving |
| 10015 | Default | AoI-aware | 1.478 | 0.154 | -1.478 | 4.02 | 0.367 | CostlyButMeaningful |
| 10015 | Default | Link-delay-aware | 2.103 | 0.000 | -2.103 | 21.13 | 0.100 | CostlyButMeaningful |
| 10015 | Default | Confidence-heuristic | 0.017 | 0.000 | -0.017 | -1.08 | NaN | DominantOrCostSaving |
| 10015 | ForestGeometry | DCC-like | -0.809 | 0.000 | 0.809 | -13.73 | NaN | DominantOrCostSaving |
| 10015 | ForestGeometry | AoI-aware | 4.865 | 1.385 | -4.865 | 9.05 | 0.537 | CostlyButMeaningful |
| 10015 | ForestGeometry | Link-delay-aware | 6.602 | 0.154 | -6.602 | 38.31 | 0.172 | CostlyButMeaningful |
| 10015 | ForestGeometry | Confidence-heuristic | 2.789 | 0.000 | -2.789 | 12.98 | 0.215 | CostlyButMeaningful |

## 3. Pareto 前沿成员

| Scene | Config | Method | Cost | Timely | Emergency timely | Timely front | Emergency front |
|---|---|---|---:|---:|---:|---|---|
| 10014 | Default | Link-delay-aware | 1.6295 | 0.9346 | 0.9833 | true | true |
| 10014 | Default | Risk-constrained-v6 | 2.0006 | 0.9918 | 1.0000 | true | true |
| 10014 | Default | Constrained Oracle | 2.1027 | 0.9961 | 0.9833 | true | false |
| 10014 | ForestGeometry | Link-delay-aware | 1.6983 | 0.7876 | 0.0233 | true | true |
| 10014 | ForestGeometry | Confidence-heuristic | 2.0880 | 0.7891 | 0.0200 | true | false |
| 10014 | ForestGeometry | Risk-constrained-v6 | 2.2843 | 0.7994 | 0.0233 | true | false |
| 10014 | ForestGeometry | Constrained Oracle | 2.4153 | 0.8023 | 0.0200 | true | false |
| 10006 | Default | Link-delay-aware | 2.2032 | 0.9310 | 0.9907 | true | true |
| 10006 | Default | Confidence-heuristic | 2.7255 | 0.9882 | 0.9951 | true | true |
| 10006 | Default | Risk-constrained-v6 | 2.8490 | 0.9900 | 0.9951 | false | false |
| 10006 | Default | Constrained Oracle | 2.7322 | 0.9952 | 0.9962 | true | true |
| 10006 | Default | AoI-aware | 2.3713 | 0.9720 | 0.9897 | true | false |
| 10006 | ForestGeometry | Link-delay-aware | 2.2646 | 0.7069 | 0.7999 | true | true |
| 10006 | ForestGeometry | Confidence-heuristic | 2.6148 | 0.7079 | 0.7999 | true | true |
| 10006 | ForestGeometry | Risk-constrained-v6 | 2.8988 | 0.7131 | 0.7999 | false | false |
| 10006 | ForestGeometry | Constrained Oracle | 2.7448 | 0.7138 | 0.7995 | true | false |
| 10006 | ForestGeometry | AoI-aware | 2.6525 | 0.7119 | 0.7986 | true | false |
| 10011 | Default | Link-delay-aware | 1.7188 | 0.9928 | 1.0000 | true | true |
| 10011 | Default | Risk-constrained-v6 | 1.8882 | 0.9951 | 1.0000 | true | false |
| 10011 | Default | Constrained Oracle | 1.9434 | 0.9987 | 1.0000 | true | false |
| 10011 | Default | DCC-like | 3.6240 | 1.0000 | 1.0000 | true | false |
| 10011 | Default | AoI-aware | 1.8355 | 0.9932 | 0.9970 | true | false |
| 10011 | ForestGeometry | Link-delay-aware | 2.3561 | 0.6730 | 0.4510 | true | true |
| 10011 | ForestGeometry | Confidence-heuristic | 3.0044 | 0.7609 | 0.4840 | true | true |
| 10011 | ForestGeometry | Risk-constrained-v6 | 3.2240 | 0.8019 | 0.4850 | true | true |
| 10011 | ForestGeometry | AoI-aware | 4.0374 | 0.8046 | 0.3270 | true | false |
| 10019 | Default | Link-delay-aware | 2.4997 | 0.9999 | 1.0000 | true | true |
| 10019 | Default | Risk-constrained-v6 | 3.0448 | 0.9999 | 1.0000 | false | false |
| 10019 | Default | DCC-like | 4.5807 | 1.0000 | 1.0000 | true | false |
| 10019 | Default | AoI-aware | 1.6874 | 0.9979 | 0.9979 | true | true |
| 10019 | ForestGeometry | Link-delay-aware | 2.8420 | 0.6250 | 0.5873 | true | true |
| 10019 | ForestGeometry | Risk-constrained-v6 | 3.3230 | 0.6178 | 0.5795 | false | false |
| 10019 | ForestGeometry | AoI-aware | 3.3155 | 0.6261 | 0.5886 | true | true |
| 10017 | Default | Link-delay-aware | 2.0472 | 0.8682 | 0.9317 | true | true |
| 10017 | Default | Risk-constrained-v6 | 2.8695 | 0.9790 | 0.9811 | true | true |
| 10017 | Default | Constrained Oracle | 3.2205 | 0.9890 | 0.9728 | true | false |
| 10017 | Default | DCC-like | 4.7276 | 0.8942 | 0.9933 | false | true |
| 10017 | ForestGeometry | Link-delay-aware | 2.1792 | 0.5236 | 0.0244 | true | true |
| 10017 | ForestGeometry | Confidence-heuristic | 2.6790 | 0.5264 | 0.0244 | true | false |
| 10017 | ForestGeometry | Risk-constrained-v6 | 3.0038 | 0.5326 | 0.0244 | true | false |
| 10017 | ForestGeometry | Constrained Oracle | 3.7640 | 0.5387 | 0.0228 | true | false |
| 10017 | ForestGeometry | AoI-aware | 4.0994 | 0.5374 | 0.0306 | false | true |
| 10013 | Default | Link-delay-aware | 2.4988 | 0.9922 | 0.9997 | true | true |
| 10013 | Default | Confidence-heuristic | 2.9676 | 0.9924 | 1.0000 | false | true |
| 10013 | Default | Risk-constrained-v6 | 3.0428 | 0.9924 | 1.0000 | false | false |
| 10013 | Default | Constrained Oracle | 2.5384 | 0.9964 | 0.9997 | true | false |
| 10013 | Default | DCC-like | 4.6047 | 0.9999 | 1.0000 | true | false |
| 10013 | Default | AoI-aware | 1.6868 | 0.9869 | 0.9935 | true | true |
| 10013 | ForestGeometry | Link-delay-aware | 2.9715 | 0.5587 | 0.6146 | true | true |
| 10013 | ForestGeometry | Risk-constrained-v6 | 3.4816 | 0.5528 | 0.6077 | false | false |
| 10007 | Default | Link-delay-aware | 2.2573 | 0.9562 | 1.0000 | true | true |
| 10007 | Default | Risk-constrained-v6 | 2.8292 | 0.9957 | 1.0000 | false | false |
| 10007 | Default | Constrained Oracle | 2.6836 | 0.9970 | 1.0000 | true | false |
| 10007 | Default | AoI-aware | 2.2981 | 0.9779 | 0.9993 | true | false |
| 10007 | ForestGeometry | Link-delay-aware | 2.1938 | 0.8516 | 1.0000 | true | true |
| 10007 | ForestGeometry | Confidence-heuristic | 2.4700 | 0.8642 | 1.0000 | true | false |
| 10007 | ForestGeometry | Risk-constrained-v6 | 2.6927 | 0.8654 | 1.0000 | false | false |
| 10007 | ForestGeometry | Constrained Oracle | 2.6651 | 0.8699 | 1.0000 | true | false |
| 10007 | ForestGeometry | DCC-like | 4.8213 | 0.8700 | 1.0000 | true | false |
| 10007 | ForestGeometry | AoI-aware | 2.2981 | 0.8563 | 0.9993 | true | false |
| 10015 | Default | Link-delay-aware | 1.1085 | 0.9759 | 1.0000 | true | true |
| 10015 | Default | Risk-constrained-v6 | 1.3427 | 0.9969 | 1.0000 | true | false |
| 10015 | Default | Constrained Oracle | 1.3670 | 0.9983 | 1.0000 | true | false |
| 10015 | Default | AoI-aware | 1.2907 | 0.9821 | 0.9985 | true | false |
| 10015 | ForestGeometry | Link-delay-aware | 1.0904 | 0.8422 | 0.9985 | true | true |
| 10015 | ForestGeometry | Confidence-heuristic | 1.3350 | 0.8803 | 1.0000 | true | true |
| 10015 | ForestGeometry | Risk-constrained-v6 | 1.5082 | 0.9082 | 1.0000 | true | false |
| 10015 | ForestGeometry | Constrained Oracle | 1.5334 | 0.9135 | 0.9985 | true | false |
| 10015 | ForestGeometry | DCC-like | 1.7483 | 0.9163 | 1.0000 | true | false |

## 4. 与 Step55 实践显著性的一致性

| Practical class | Count |
|---|---:|
| MeaningfulGain | 16 |
| WeakNonnegative | 33 |
| Boundary | 18 |
| CostlyGain | 11 |
| Risk | 2 |

## 5. 审稿口径

1. 若 `DeltaCost_pct > 0` 且 `DeltaTimely_pp < 1`，不能表述为强性能提升，只能作为弱收益或边界结果。
2. 若相对 DCC 出现负成本且正及时率收益，可作为 cost-saving evidence。
3. 对 `Link-delay-aware` 的比较经常是 costly gain，论文中必须同时报告成本，否则会被认为隐藏通信开销。
4. 对 `10019 ForestGeometry` 和 `10013 ForestGeometry` 不应调参修正，应与 Step52/Step51 一起作为适用边界讨论。
