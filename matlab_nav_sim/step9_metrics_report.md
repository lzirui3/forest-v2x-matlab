# Step 9 Scheduling Comparison Report

## Summary Table

| Method | Avg Delay (s) | Timely Rate | Loss Rate | Avg Tx Cost | Emergency Timely Rate |
|---|---:|---:|---:|---:|---:|
| Fixed | 0.018 | 0.987 | 0.013 | 1.619 | 1.000 |
| Priority-only | 0.018 | 0.988 | 0.012 | 2.523 | 1.000 |
| Link-aware | 0.016 | 1.000 | 0.000 | 1.917 | 1.000 |
| Link-delay-aware | 0.018 | 0.985 | 0.015 | 1.629 | 1.000 |
| Position-only | 0.019 | 0.987 | 0.013 | 2.395 | 1.000 |
| Fused-rule | 0.017 | 1.000 | 0.000 | 1.953 | 1.000 |
| Blind-zone-event-only | 0.018 | 0.988 | 0.012 | 2.632 | 1.000 |
| Oracle | 0.014 | 0.995 | 0.005 | 1.694 | 1.000 |
| Confidence-driven | 0.018 | 0.987 | 0.013 | 1.678 | 1.000 |

## Observation

- The best emergency timely-delivery method is **Fixed**.
- This report is intended to support the first-step validation of whether positioning confidence provides incremental scheduling value.
