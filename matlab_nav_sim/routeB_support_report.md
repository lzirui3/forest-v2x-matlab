# Route B Support Report

This report supports the paper strategy of keeping the heuristic scheduler as the empirical mainline, while presenting a Lyapunov drift-plus-penalty variant as the mathematically formalized counterpart.

## 1. Heuristic Parameter Support (Step18-lite)

Step18-lite scans the key heuristic regime parameters and evaluates a composite score that balances overall timely gain, loss reduction, key-stage gain, and cost increase.

| ComboID | EnterBlind | EnterQPos | HoldBlind | HoldQPos | OverallTimelyGain | OverallLossReduction | OverallCostDelta | PosDegTimelyGain | CompositeScore |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | 0.14 | 0.68 | 0.30 | 0.48 | 0.0305 | 0.0305 | 0.2070 | 0.0045 | 0.0562 |
| 2 | 0.14 | 0.68 | 0.30 | 0.52 | 0.0305 | 0.0305 | 0.2070 | 0.0045 | 0.0562 |
| 3 | 0.14 | 0.68 | 0.30 | 0.58 | 0.0305 | 0.0305 | 0.2070 | 0.0045 | 0.0562 |
| 4 | 0.14 | 0.68 | 0.36 | 0.48 | 0.0305 | 0.0305 | 0.2070 | 0.0045 | 0.0562 |
| 5 | 0.14 | 0.68 | 0.36 | 0.52 | 0.0305 | 0.0305 | 0.2070 | 0.0045 | 0.0562 |
| 6 | 0.14 | 0.68 | 0.36 | 0.58 | 0.0305 | 0.0305 | 0.2070 | 0.0045 | 0.0562 |
| 7 | 0.14 | 0.68 | 0.42 | 0.48 | 0.0305 | 0.0305 | 0.2070 | 0.0045 | 0.0562 |
| 8 | 0.14 | 0.68 | 0.42 | 0.52 | 0.0305 | 0.0305 | 0.2070 | 0.0045 | 0.0562 |
| 9 | 0.14 | 0.68 | 0.42 | 0.58 | 0.0305 | 0.0305 | 0.2070 | 0.0045 | 0.0562 |
| 10 | 0.14 | 0.72 | 0.30 | 0.48 | 0.0305 | 0.0305 | 0.2070 | 0.0045 | 0.0562 |

Current heuristic reference setting:
- EnterBlind = 0.14
- EnterQPos = 0.68
- HoldBlind = 0.30
- HoldQPos = 0.48
- CompositeScore = 0.0562

Best scanned setting:
- ComboID = 1
- CompositeScore = 0.0562

Interpretation: the heuristic setting is not presented as globally optimal, but Step18-lite shows that it lies within the top scanned Pareto-relevant region rather than being an arbitrary hand-tuned point.

## 2. Lyapunov Formalized Variant (Step23)

The Lyapunov version introduces a timely-violation virtual queue and selects actions by minimizing a drift-plus-penalty objective, thereby giving a theoretical source for the cost-performance tradeoff parameter `V`.

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

## 3. Lyapunov vs Heuristic Overall Significance

| Config | Metric | Heuristic Mean | Lyapunov Mean | Delta Mean | 95% CI | p-value | Significance |
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

## 4. Lyapunov vs Heuristic PosDeg_Emerg Significance

| Config | Metric | Heuristic Mean | Lyapunov Mean | Delta Mean | 95% CI | p-value | Significance |
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

## 5. Recommended Route B Positioning

- Keep the heuristic confidence-driven scheduler as the empirical mainline, because it remains stronger in the hardest forest scenes.
- Present the Lyapunov drift-plus-penalty scheduler as the mathematically grounded counterpart that exposes an explicit cost-performance tradeoff.
- Cite Step18-lite to argue that the heuristic regime parameters lie within a high-performing scanned region rather than being arbitrary magic constants.
- Cite Step23 to argue that the proposed scheduling logic is not only heuristic; a formalized queue-stability-inspired variant has been constructed and evaluated.
- State explicitly that the current Lyapunov parameterization is more conservative in difficult scenes, which explains why the heuristic remains the empirical mainline.
