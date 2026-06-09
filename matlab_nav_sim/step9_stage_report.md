# Step 9 Stage-wise Report

## Stage Metrics

| Method | Stage | Avg Delay (s) | Timely Rate | Loss Rate | Avg Tx Cost | Emergency Timely Rate |
|---|---|---:|---:|---:|---:|---:|
| Fixed | Normal | 0.013 | 0.936 | 0.064 | 1.312 | NaN |
| Fixed | Coop_1 | 0.012 | 1.000 | 0.000 | 2.000 | NaN |
| Fixed | LinkDeg_Emerg | 0.012 | 1.000 | 0.000 | 2.000 | NaN |
| Fixed | PosDeg_Emerg | 0.012 | 1.000 | 0.000 | 1.973 | 1.000 |
| Fixed | Recovery | 0.012 | 1.000 | 0.000 | 1.073 | NaN |
| Fixed | Full | 0.012 | 0.987 | 0.013 | 1.619 | 1.000 |
| Priority-only | Normal | 0.013 | 0.944 | 0.056 | 1.749 | NaN |
| Priority-only | Coop_1 | 0.012 | 1.000 | 0.000 | 3.400 | NaN |
| Priority-only | LinkDeg_Emerg | 0.012 | 1.000 | 0.000 | 3.400 | NaN |
| Priority-only | PosDeg_Emerg | 0.013 | 1.000 | 0.000 | 3.542 | 1.000 |
| Priority-only | Recovery | 0.012 | 1.000 | 0.000 | 1.175 | NaN |
| Priority-only | Full | 0.012 | 0.988 | 0.012 | 2.523 | 1.000 |
| Link-aware | Normal | 0.033 | 1.000 | 0.000 | 2.527 | NaN |
| Link-aware | Coop_1 | 0.012 | 1.000 | 0.000 | 2.000 | NaN |
| Link-aware | LinkDeg_Emerg | 0.012 | 1.000 | 0.000 | 2.000 | NaN |
| Link-aware | PosDeg_Emerg | 0.012 | 1.000 | 0.000 | 2.132 | 1.000 |
| Link-aware | Recovery | 0.012 | 1.000 | 0.000 | 1.138 | NaN |
| Link-aware | Full | 0.016 | 1.000 | 0.000 | 1.917 | 1.000 |
| Link-delay-aware | Normal | 0.013 | 0.936 | 0.064 | 1.312 | NaN |
| Link-delay-aware | Coop_1 | 0.012 | 1.000 | 0.000 | 2.000 | NaN |
| Link-delay-aware | LinkDeg_Emerg | 0.012 | 1.000 | 0.000 | 2.000 | NaN |
| Link-delay-aware | PosDeg_Emerg | 0.012 | 1.000 | 0.000 | 2.030 | 1.000 |
| Link-delay-aware | Recovery | 0.012 | 0.993 | 0.007 | 1.073 | NaN |
| Link-delay-aware | Full | 0.012 | 0.985 | 0.015 | 1.629 | 1.000 |
| Position-only | Normal | 0.013 | 0.936 | 0.064 | 1.312 | NaN |
| Position-only | Coop_1 | 0.012 | 1.000 | 0.000 | 3.027 | NaN |
| Position-only | LinkDeg_Emerg | 0.012 | 1.000 | 0.000 | 3.400 | NaN |
| Position-only | PosDeg_Emerg | 0.014 | 1.000 | 0.000 | 3.846 | 1.000 |
| Position-only | Recovery | 0.012 | 1.000 | 0.000 | 1.175 | NaN |
| Position-only | Full | 0.013 | 0.987 | 0.013 | 2.395 | 1.000 |
| Fused-rule | Normal | 0.033 | 1.000 | 0.000 | 2.010 | NaN |
| Fused-rule | Coop_1 | 0.012 | 1.000 | 0.000 | 2.000 | NaN |
| Fused-rule | LinkDeg_Emerg | 0.012 | 1.000 | 0.000 | 2.000 | NaN |
| Fused-rule | PosDeg_Emerg | 0.014 | 1.000 | 0.000 | 2.889 | 1.000 |
| Fused-rule | Recovery | 0.012 | 1.000 | 0.000 | 1.156 | NaN |
| Fused-rule | Full | 0.017 | 1.000 | 0.000 | 1.953 | 1.000 |
| Blind-zone-event-only | Normal | 0.013 | 0.944 | 0.056 | 1.749 | NaN |
| Blind-zone-event-only | Coop_1 | 0.012 | 1.000 | 0.000 | 3.400 | NaN |
| Blind-zone-event-only | LinkDeg_Emerg | 0.012 | 1.000 | 0.000 | 3.400 | NaN |
| Blind-zone-event-only | PosDeg_Emerg | 0.014 | 1.000 | 0.000 | 3.879 | 1.000 |
| Blind-zone-event-only | Recovery | 0.013 | 1.000 | 0.000 | 1.363 | NaN |
| Blind-zone-event-only | Full | 0.013 | 0.988 | 0.012 | 2.632 | 1.000 |
| Oracle | Normal | 0.014 | 0.984 | 0.016 | 1.623 | NaN |
| Oracle | Coop_1 | 0.012 | 1.000 | 0.000 | 2.000 | NaN |
| Oracle | LinkDeg_Emerg | 0.012 | 1.000 | 0.000 | 2.000 | NaN |
| Oracle | PosDeg_Emerg | 0.012 | 1.000 | 0.000 | 2.030 | 1.000 |
| Oracle | Recovery | 0.012 | 0.993 | 0.007 | 1.073 | NaN |
| Oracle | Full | 0.012 | 0.995 | 0.005 | 1.694 | 1.000 |
| Confidence-driven | Normal | 0.013 | 0.944 | 0.056 | 1.346 | NaN |
| Confidence-driven | Coop_1 | 0.012 | 1.000 | 0.000 | 2.000 | NaN |
| Confidence-driven | LinkDeg_Emerg | 0.012 | 1.000 | 0.000 | 2.000 | NaN |
| Confidence-driven | PosDeg_Emerg | 0.013 | 1.000 | 0.000 | 2.237 | 1.000 |
| Confidence-driven | Recovery | 0.012 | 0.993 | 0.007 | 1.089 | NaN |
| Confidence-driven | Full | 0.012 | 0.987 | 0.013 | 1.678 | 1.000 |

## Relative to Link-aware Baseline

| Method | Stage | Timely Gain | Emergency Timely Gain | Avg Tx Cost Delta |
|---|---|---:|---:|---:|
| Fixed | Normal | -0.064 | NaN | -1.215 |
| Fixed | Coop_1 | 0.000 | NaN | 0.000 |
| Fixed | LinkDeg_Emerg | 0.000 | NaN | 0.000 |
| Fixed | PosDeg_Emerg | 0.000 | 0.000 | -0.159 |
| Fixed | Recovery | 0.000 | NaN | -0.065 |
| Fixed | Full | -0.013 | 0.000 | -0.298 |
| Priority-only | Normal | -0.056 | NaN | -0.778 |
| Priority-only | Coop_1 | 0.000 | NaN | 1.400 |
| Priority-only | LinkDeg_Emerg | 0.000 | NaN | 1.400 |
| Priority-only | PosDeg_Emerg | 0.000 | 0.000 | 1.410 |
| Priority-only | Recovery | 0.000 | NaN | 0.037 |
| Priority-only | Full | -0.012 | 0.000 | 0.606 |
| Link-delay-aware | Normal | -0.064 | NaN | -1.215 |
| Link-delay-aware | Coop_1 | 0.000 | NaN | 0.000 |
| Link-delay-aware | LinkDeg_Emerg | 0.000 | NaN | 0.000 |
| Link-delay-aware | PosDeg_Emerg | 0.000 | 0.000 | -0.102 |
| Link-delay-aware | Recovery | -0.007 | NaN | -0.065 |
| Link-delay-aware | Full | -0.015 | 0.000 | -0.288 |
| Position-only | Normal | -0.064 | NaN | -1.215 |
| Position-only | Coop_1 | 0.000 | NaN | 1.027 |
| Position-only | LinkDeg_Emerg | 0.000 | NaN | 1.400 |
| Position-only | PosDeg_Emerg | 0.000 | 0.000 | 1.714 |
| Position-only | Recovery | 0.000 | NaN | 0.037 |
| Position-only | Full | -0.013 | 0.000 | 0.478 |
| Fused-rule | Normal | 0.000 | NaN | -0.517 |
| Fused-rule | Coop_1 | 0.000 | NaN | 0.000 |
| Fused-rule | LinkDeg_Emerg | 0.000 | NaN | 0.000 |
| Fused-rule | PosDeg_Emerg | 0.000 | 0.000 | 0.757 |
| Fused-rule | Recovery | 0.000 | NaN | 0.019 |
| Fused-rule | Full | 0.000 | 0.000 | 0.036 |
| Blind-zone-event-only | Normal | -0.056 | NaN | -0.778 |
| Blind-zone-event-only | Coop_1 | 0.000 | NaN | 1.400 |
| Blind-zone-event-only | LinkDeg_Emerg | 0.000 | NaN | 1.400 |
| Blind-zone-event-only | PosDeg_Emerg | 0.000 | 0.000 | 1.747 |
| Blind-zone-event-only | Recovery | 0.000 | NaN | 0.225 |
| Blind-zone-event-only | Full | -0.012 | 0.000 | 0.715 |
| Oracle | Normal | -0.016 | NaN | -0.904 |
| Oracle | Coop_1 | 0.000 | NaN | 0.000 |
| Oracle | LinkDeg_Emerg | 0.000 | NaN | 0.000 |
| Oracle | PosDeg_Emerg | 0.000 | 0.000 | -0.102 |
| Oracle | Recovery | -0.007 | NaN | -0.065 |
| Oracle | Full | -0.005 | 0.000 | -0.223 |
| Confidence-driven | Normal | -0.056 | NaN | -1.181 |
| Confidence-driven | Coop_1 | 0.000 | NaN | 0.000 |
| Confidence-driven | LinkDeg_Emerg | 0.000 | NaN | 0.000 |
| Confidence-driven | PosDeg_Emerg | 0.000 | 0.000 | 0.105 |
| Confidence-driven | Recovery | -0.007 | NaN | -0.049 |
| Confidence-driven | Full | -0.013 | 0.000 | -0.239 |
