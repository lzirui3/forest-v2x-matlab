# Step 23 Lyapunov vs Heuristic Report

This report compares the legacy heuristic confidence scheduler with the Lyapunov drift-plus-penalty scheduler.

## Overall Mean Summary

| Config | Method | Timely Mean | Loss Mean | Avg Delay Mean | Avg Tx Cost Mean | Emergency Timely Mean |
|---|---|---:|---:|---:|---:|---:|
| Generic | Link-delay-aware | 0.9687 | 0.0313 | 0.0242 | 1.6295 | 1.0000 |
| Generic | Confidence-heuristic | 0.9709 | 0.0291 | 0.0242 | 1.9048 | 1.0000 |
| Generic | Confidence-lyapunov | 0.9707 | 0.0293 | 0.0244 | 1.8197 | 1.0000 |
| Generic | Oracle | 0.9930 | 0.0070 | 0.0157 | 1.8903 | 1.0000 |
| ForestParam | Link-delay-aware | 0.9621 | 0.0376 | 0.0360 | 2.2112 | 0.7833 |
| ForestParam | Confidence-heuristic | 0.9729 | 0.0261 | 0.0349 | 2.5622 | 0.8833 |
| ForestParam | Confidence-lyapunov | 0.9531 | 0.0459 | 0.0421 | 2.4095 | 0.8833 |
| ForestParam | Oracle | 0.9727 | 0.0261 | 0.0353 | 2.5507 | 0.8667 |
| ForestGeometryDemo | Link-delay-aware | 0.8226 | 0.1772 | 0.0919 | 1.8266 | 0.9710 |
| ForestGeometryDemo | Confidence-heuristic | 0.8444 | 0.1552 | 0.0871 | 2.1975 | 0.9869 |
| ForestGeometryDemo | Confidence-lyapunov | 0.8163 | 0.1834 | 0.0919 | 1.8006 | 0.9766 |
| ForestGeometryDemo | Oracle | 0.8571 | 0.1426 | 0.0829 | 2.2575 | 0.9879 |

## PosDeg_Emerg Mean Summary

| Config | Method | Timely Mean | Loss Mean | Avg Delay Mean | Avg Tx Cost Mean | Emergency Timely Mean |
|---|---|---:|---:|---:|---:|---:|
| Generic | Link-delay-aware | 0.9909 | 0.0091 | 0.0121 | 2.0300 | 1.0000 |
| Generic | Confidence-heuristic | 1.0000 | 0.0000 | 0.0136 | 3.2962 | 1.0000 |
| Generic | Confidence-lyapunov | 0.9991 | 0.0009 | 0.0147 | 2.9005 | 1.0000 |
| Generic | Oracle | 0.9991 | 0.0009 | 0.0147 | 2.9018 | 1.0000 |
| ForestParam | Link-delay-aware | 0.9591 | 0.0391 | 0.0174 | 2.2227 | 0.7833 |
| ForestParam | Confidence-heuristic | 0.9891 | 0.0055 | 0.0197 | 3.5407 | 0.8833 |
| ForestParam | Confidence-lyapunov | 0.9773 | 0.0173 | 0.0199 | 3.1593 | 0.8833 |
| ForestParam | Oracle | 0.9882 | 0.0055 | 0.0211 | 3.3953 | 0.8667 |
| ForestGeometryDemo | Link-delay-aware | 0.9209 | 0.0791 | 0.0247 | 3.0001 | 0.9661 |
| ForestGeometryDemo | Confidence-heuristic | 0.9755 | 0.0236 | 0.0280 | 3.9410 | 0.9898 |
| ForestGeometryDemo | Confidence-lyapunov | 0.9336 | 0.0655 | 0.0250 | 3.0858 | 0.9780 |
| ForestGeometryDemo | Oracle | 0.9818 | 0.0173 | 0.0284 | 3.7711 | 0.9932 |

## Lyapunov vs Heuristic Overall Significance

| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | 95% CI | p-value | Significance |
|---|---|---:|---:|---:|---:|---:|---|
| Generic | TimelyRate | 0.9709 | 0.9707 | -0.0002 | [-0.0004, 0.0000] | 0.3173 | n.s. |
| Generic | LossRate | 0.0291 | 0.0293 | 0.0002 | [-0.0000, 0.0004] | 0.3173 | n.s. |
| Generic | AvgDelay | 0.0242 | 0.0244 | 0.0001 | [0.0000, 0.0002] | 0.07538 | n.s. |
| Generic | AvgTxCost | 1.9048 | 1.8197 | -0.0851 | [-0.0925, -0.0777] | 0 | *** |
| Generic | EmgTimely | 1.0000 | 1.0000 | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| ForestParam | TimelyRate | 0.9729 | 0.9531 | -0.0198 | [-0.0218, -0.0178] | 0 | *** |
| ForestParam | LossRate | 0.0261 | 0.0459 | 0.0198 | [0.0178, 0.0218] | 0 | *** |
| ForestParam | AvgDelay | 0.0349 | 0.0421 | 0.0071 | [0.0064, 0.0079] | 0 | *** |
| ForestParam | AvgTxCost | 2.5622 | 2.4095 | -0.1527 | [-0.1582, -0.1473] | 0 | *** |
| ForestParam | EmgTimely | 0.8833 | 0.8833 | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| ForestGeometryDemo | TimelyRate | 0.8444 | 0.8163 | -0.0281 | [-0.0319, -0.0244] | 0 | *** |
| ForestGeometryDemo | LossRate | 0.1552 | 0.1834 | 0.0281 | [0.0244, 0.0319] | 0 | *** |
| ForestGeometryDemo | AvgDelay | 0.0871 | 0.0919 | 0.0048 | [0.0040, 0.0056] | 3.841e-14 | *** |
| ForestGeometryDemo | AvgTxCost | 2.1975 | 1.8006 | -0.3970 | [-0.4132, -0.3808] | 0 | *** |
| ForestGeometryDemo | EmgTimely | 0.9869 | 0.9766 | -0.0103 | [-0.0134, -0.0071] | 7.108e-05 | *** |

## Lyapunov vs Heuristic PosDeg_Emerg Significance

| Config | Metric | Baseline Mean | Proposed Mean | Delta Mean | 95% CI | p-value | Significance |
|---|---|---:|---:|---:|---:|---:|---|
| Generic | TimelyRate | 1.0000 | 0.9991 | -0.0009 | [-0.0020, 0.0002] | 0.3173 | n.s. |
| Generic | LossRate | 0.0000 | 0.0009 | 0.0009 | [-0.0002, 0.0020] | 0.3173 | n.s. |
| Generic | AvgDelay | 0.0136 | 0.0147 | 0.0011 | [0.0005, 0.0016] | 0.01546 | * |
| Generic | AvgTxCost | 3.2962 | 2.9005 | -0.3957 | [-0.4280, -0.3633] | 0 | *** |
| Generic | EmgTimely | 1.0000 | 1.0000 | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| ForestParam | TimelyRate | 0.9891 | 0.9773 | -0.0118 | [-0.0165, -0.0071] | 0.002115 | ** |
| ForestParam | LossRate | 0.0055 | 0.0173 | 0.0118 | [0.0071, 0.0165] | 0.002115 | ** |
| ForestParam | AvgDelay | 0.0197 | 0.0199 | 0.0002 | [-0.0002, 0.0005] | 0.5457 | n.s. |
| ForestParam | AvgTxCost | 3.5407 | 3.1593 | -0.3814 | [-0.4030, -0.3598] | 0 | *** |
| ForestParam | EmgTimely | 0.8833 | 0.8833 | 0.0000 | [0.0000, 0.0000] | 1 | n.s. |
| ForestGeometryDemo | TimelyRate | 0.9755 | 0.9336 | -0.0418 | [-0.0553, -0.0284] | 0.0001491 | *** |
| ForestGeometryDemo | LossRate | 0.0236 | 0.0655 | 0.0418 | [0.0284, 0.0553] | 0.0001491 | *** |
| ForestGeometryDemo | AvgDelay | 0.0280 | 0.0250 | -0.0031 | [-0.0038, -0.0024] | 1.429e-07 | *** |
| ForestGeometryDemo | AvgTxCost | 3.9410 | 3.0858 | -0.8552 | [-0.9149, -0.7956] | 0 | *** |
| ForestGeometryDemo | EmgTimely | 0.9898 | 0.9780 | -0.0119 | [-0.0181, -0.0057] | 0.01963 | * |

## Interpretation

- The Lyapunov scheduler provides a mathematically grounded drift-plus-penalty control law instead of a purely heuristic score combiner.
- If performance remains comparable while cost-performance tradeoff becomes tunable through `V`, the formalized scheduler resolves the main theoretical criticism.
- If Lyapunov significantly underperforms in specific scenes, the paper should present it as a theoretically grounded variant and discuss the gap to the heuristic baseline.
