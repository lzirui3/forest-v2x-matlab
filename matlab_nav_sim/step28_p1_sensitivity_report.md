# Step 28 P1 Sensitivity Report

This report addresses P1 without tuning the mainline parameters to make the results look better. It separates emergency-message performance into three scenario-pressure profiles:

- `Strict-75ms`: ForestGeometry channel with strict 75 ms emergency deadline.
- `Forest-150ms`: ForestGeometry channel with relaxed 150 ms forest emergency deadline.
- `Moderate-Forest`: midpoint physical degradation between Default and ForestGeometry, with 150 ms emergency deadline.

## Profile Definitions

| Profile | Emergency Deadline (s) | Link Scale | Tx Power (dBm) | LOS Exp. | NLOS Exp. | NLOSv Extra Loss (dB) | Interference Scale |
|---|---:|---:|---:|---:|---:|---:|---:|
| Strict-75ms | 0.075 | 1.800 | 22.00 | 28.50 | 37.50 | 7.00 | 2.30 |
| Forest-150ms | 0.150 | 1.800 | 22.00 | 28.50 | 37.50 | 7.00 | 2.30 |
| Moderate-Forest | 0.150 | 1.400 | 22.50 | 24.25 | 30.75 | 6.00 | 2.05 |

## Emergency Feasibility Summary

| Scene | Role | Profile | Link EmgTimely | Confidence EmgTimely | Constrained Oracle EmgTimely | Confidence-Link (pp) | ConstrainedOracle-Link (pp) | Feasibility Band |
|---|---|---|---:|---:|---:|---:|---:|---|
| 10014 | Primary | Strict-75ms | 0.0167 | 0.0167 | 0.0167 | 0.000 | 0.000 | Near-impossible |
| 10014 | Primary | Forest-150ms | 0.0167 | 0.0333 | 0.0333 | 1.667 | 1.667 | Near-impossible |
| 10014 | Primary | Moderate-Forest | 0.1333 | 0.2000 | 0.2000 | 6.667 | 6.667 | Near-impossible |
| 10017 | LongRange | Strict-75ms | 0.0139 | 0.0139 | 0.0111 | 0.000 | -0.278 | Near-impossible |
| 10017 | LongRange | Forest-150ms | 0.0278 | 0.0333 | 0.0528 | 0.556 | 2.500 | Near-impossible |
| 10017 | LongRange | Moderate-Forest | 0.0611 | 0.0694 | 0.1222 | 0.833 | 6.111 | Near-impossible |
| 10011 | Boundary | Strict-75ms | 0.2850 | 0.2650 | 0.2650 | -2.000 | -2.000 | Near-impossible |
| 10011 | Boundary | Forest-150ms | 0.5450 | 0.5500 | 0.5600 | 0.500 | 1.500 | Marginal |
| 10011 | Boundary | Moderate-Forest | 0.9750 | 0.9750 | 0.9850 | 0.000 | 1.000 | Feasible |

## Confidence-driven vs Link-delay-aware Emergency Statistics

| Scene | Profile | Link Mean | Confidence Mean | Delta | Delta (pp) | 95% CI | p-value | Holm(all) | Effect RBC | Practical |
|---|---|---:|---:|---:|---:|---:|---|---|---:|---|
| 10014 | Strict-75ms | 0.0167 | 0.0167 | 0.0000 | 0.000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.000 | Below1pp |
| 10014 | Forest-150ms | 0.0167 | 0.0333 | 0.0167 | 1.667 | [-0.0036, 0.0370] | p = 0.3173 | p = 1 | 1.000 | Meaningful |
| 10014 | Moderate-Forest | 0.1333 | 0.2000 | 0.0667 | 6.667 | [0.0218, 0.1116] | p = 0.07044 | p = 0.8453 | 1.000 | Meaningful |
| 10017 | Strict-75ms | 0.0139 | 0.0139 | 0.0000 | 0.000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.000 | Below1pp |
| 10017 | Forest-150ms | 0.0278 | 0.0333 | 0.0056 | 0.556 | [0.0010, 0.0101] | p = 0.1336 | p = 1 | 1.000 | Below1pp |
| 10017 | Moderate-Forest | 0.0611 | 0.0694 | 0.0083 | 0.833 | [0.0011, 0.0156] | p = 0.1599 | p = 1 | 1.000 | Below1pp |
| 10011 | Strict-75ms | 0.2850 | 0.2650 | -0.0200 | -2.000 | [-0.0362, -0.0038] | p = 0.1336 | p = 1 | -0.667 | Meaningful |
| 10011 | Forest-150ms | 0.5450 | 0.5500 | 0.0050 | 0.500 | [-0.0011, 0.0111] | p = 0.3173 | p = 1 | 1.000 | Below1pp |
| 10011 | Moderate-Forest | 0.9750 | 0.9750 | 0.0000 | 0.000 | [0.0000, 0.0000] | p = 1 | p = 1 | 0.000 | Below1pp |

## Overall Method Summary

| Scene | Profile | Method | Timely | Loss | Avg Delay | Avg Tx Cost | Emergency Timely |
|---|---|---|---:|---:|---:|---:|---:|
| 10014 | Strict-75ms | Link-delay-aware | 0.7391 | 0.2609 | 0.1055 | 1.6983 | 0.0167 |
| 10014 | Strict-75ms | Confidence-driven | 0.7704 | 0.2295 | 0.0936 | 2.1720 | 0.0167 |
| 10014 | Strict-75ms | Constrained Oracle | 0.8008 | 0.1990 | 0.0815 | 2.6106 | 0.0167 |
| 10014 | Forest-150ms | Link-delay-aware | 0.7391 | 0.2609 | 0.1062 | 1.6983 | 0.0167 |
| 10014 | Forest-150ms | Confidence-driven | 0.7705 | 0.2295 | 0.0943 | 2.1753 | 0.0333 |
| 10014 | Forest-150ms | Constrained Oracle | 0.8010 | 0.1990 | 0.0822 | 2.6250 | 0.0333 |
| 10014 | Moderate-Forest | Link-delay-aware | 0.8038 | 0.1962 | 0.0791 | 1.6983 | 0.1333 |
| 10014 | Moderate-Forest | Confidence-driven | 0.8078 | 0.1922 | 0.0787 | 2.0696 | 0.2000 |
| 10014 | Moderate-Forest | Constrained Oracle | 0.8153 | 0.1847 | 0.0765 | 2.3801 | 0.2000 |
| 10017 | Strict-75ms | Link-delay-aware | 0.5213 | 0.4779 | 0.1277 | 2.1792 | 0.0139 |
| 10017 | Strict-75ms | Confidence-driven | 0.5243 | 0.4749 | 0.1274 | 2.6696 | 0.0139 |
| 10017 | Strict-75ms | Constrained Oracle | 0.5396 | 0.4601 | 0.1249 | 3.7618 | 0.0111 |
| 10017 | Forest-150ms | Link-delay-aware | 0.5221 | 0.4779 | 0.1321 | 2.1792 | 0.0278 |
| 10017 | Forest-150ms | Confidence-driven | 0.5255 | 0.4745 | 0.1317 | 2.6782 | 0.0333 |
| 10017 | Forest-150ms | Constrained Oracle | 0.5421 | 0.4579 | 0.1292 | 3.9070 | 0.0528 |
| 10017 | Moderate-Forest | Link-delay-aware | 0.5326 | 0.4674 | 0.1306 | 2.1792 | 0.0611 |
| 10017 | Moderate-Forest | Confidence-driven | 0.5399 | 0.4601 | 0.1298 | 2.6623 | 0.0694 |
| 10017 | Moderate-Forest | Constrained Oracle | 0.5656 | 0.4344 | 0.1263 | 3.8930 | 0.1222 |
| 10011 | Strict-75ms | Link-delay-aware | 0.5902 | 0.4042 | 0.1556 | 2.7289 | 0.2850 |
| 10011 | Strict-75ms | Confidence-driven | 0.6790 | 0.3170 | 0.1377 | 3.3981 | 0.2650 |
| 10011 | Strict-75ms | Constrained Oracle | 0.7008 | 0.2899 | 0.1326 | 4.0060 | 0.2650 |
| 10011 | Forest-150ms | Link-delay-aware | 0.5988 | 0.4012 | 0.1568 | 2.7635 | 0.5450 |
| 10011 | Forest-150ms | Confidence-driven | 0.6885 | 0.3115 | 0.1390 | 3.4524 | 0.5500 |
| 10011 | Forest-150ms | Constrained Oracle | 0.7106 | 0.2894 | 0.1337 | 4.0164 | 0.5600 |
| 10011 | Moderate-Forest | Link-delay-aware | 0.9521 | 0.0479 | 0.0216 | 1.7547 | 0.9750 |
| 10011 | Moderate-Forest | Confidence-driven | 0.9531 | 0.0469 | 0.0215 | 2.0297 | 0.9750 |
| 10011 | Moderate-Forest | Constrained Oracle | 0.9626 | 0.0374 | 0.0209 | 2.1717 | 0.9850 |

## Cost-Efficiency Summary

| Scene | Profile | Method | Timely/Cost | Emergency/Cost | Delta Timely (pp) | Delta Emergency (pp) | Delta Cost | Gain Class |
|---|---|---|---:|---:|---:|---:|---:|---|
| 10014 | Strict-75ms | Link-delay-aware | 0.4352 | 0.0098 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10014 | Strict-75ms | Confidence-driven | 0.3547 | 0.0077 | 3.128 | 0.000 | 0.4737 | CostlyGain |
| 10014 | Strict-75ms | Constrained Oracle | 0.3068 | 0.0064 | 6.173 | 0.000 | 0.9122 | CostlyGain |
| 10014 | Forest-150ms | Link-delay-aware | 0.4352 | 0.0098 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10014 | Forest-150ms | Confidence-driven | 0.3542 | 0.0153 | 3.145 | 1.667 | 0.4770 | CostlyGain |
| 10014 | Forest-150ms | Constrained Oracle | 0.3051 | 0.0127 | 6.190 | 1.667 | 0.9266 | CostlyGain |
| 10014 | Moderate-Forest | Link-delay-aware | 0.4733 | 0.0785 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10014 | Moderate-Forest | Confidence-driven | 0.3903 | 0.0966 | 0.399 | 6.667 | 0.3713 | CostlyGain |
| 10014 | Moderate-Forest | Constrained Oracle | 0.3426 | 0.0840 | 1.148 | 6.667 | 0.6818 | CostlyGain |
| 10017 | Strict-75ms | Link-delay-aware | 0.2392 | 0.0064 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10017 | Strict-75ms | Confidence-driven | 0.1964 | 0.0052 | 0.300 | 0.000 | 0.4904 | CostlyGain |
| 10017 | Strict-75ms | Constrained Oracle | 0.1434 | 0.0030 | 1.830 | -0.278 | 1.5826 | CostlyGain |
| 10017 | Forest-150ms | Link-delay-aware | 0.2396 | 0.0127 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10017 | Forest-150ms | Confidence-driven | 0.1962 | 0.0124 | 0.333 | 0.556 | 0.4990 | CostlyGain |
| 10017 | Forest-150ms | Constrained Oracle | 0.1388 | 0.0135 | 1.997 | 2.500 | 1.7278 | CostlyGain |
| 10017 | Moderate-Forest | Link-delay-aware | 0.2444 | 0.0280 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10017 | Moderate-Forest | Confidence-driven | 0.2028 | 0.0261 | 0.732 | 0.833 | 0.4831 | CostlyGain |
| 10017 | Moderate-Forest | Constrained Oracle | 0.1453 | 0.0314 | 3.295 | 6.111 | 1.7138 | CostlyGain |
| 10011 | Strict-75ms | Link-delay-aware | 0.2163 | 0.1044 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10011 | Strict-75ms | Confidence-driven | 0.1998 | 0.0780 | 8.885 | -2.000 | 0.6692 | CostlyGain |
| 10011 | Strict-75ms | Constrained Oracle | 0.1749 | 0.0662 | 11.065 | -2.000 | 1.2771 | CostlyGain |
| 10011 | Forest-150ms | Link-delay-aware | 0.2167 | 0.1972 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10011 | Forest-150ms | Confidence-driven | 0.1994 | 0.1593 | 8.968 | 0.500 | 0.6890 | CostlyGain |
| 10011 | Forest-150ms | Constrained Oracle | 0.1769 | 0.1394 | 11.181 | 1.500 | 1.2529 | CostlyGain |
| 10011 | Moderate-Forest | Link-delay-aware | 0.5426 | 0.5556 | 0.000 | 0.000 | 0.0000 | Baseline |
| 10011 | Moderate-Forest | Confidence-driven | 0.4696 | 0.4804 | 0.100 | 0.000 | 0.2750 | CostlyGain |
| 10011 | Moderate-Forest | Constrained Oracle | 0.4432 | 0.4536 | 1.048 | 1.000 | 0.4169 | CostlyGain |

## Interpretation

- Rows classified as `Near-impossible` should not be used as primary evidence for scheduler superiority, because the constrained-oracle upper bound is also low.
- `Forest-150ms` isolates the deadline effect. If the constrained oracle remains low after relaxing the deadline, the bottleneck is the physical link rather than the scheduler.
- `Moderate-Forest` should be interpreted as a sensitivity profile defining the workable forest operating region, not as a tuned replacement for ForestGeometry.
- The current 10-seed run contains 7 near-impossible rows, 1 marginal rows, and 1 feasible rows.

## Paper Usage Recommendation

- Present P1 as a feasibility-boundary finding: strong ForestGeometry pressure can push emergency delivery into a physically near-impossible region.
- Keep Strict-75ms and Forest-150ms as stress tests or appendix evidence.
- Use feasible or marginal profiles for method-performance claims, and explicitly state that near-impossible profiles evaluate robustness rather than expected deployment performance.
- Do not claim that deadline relaxation alone solves P1; the sensitivity results show that link degradation dominates in the hardest scenes.
