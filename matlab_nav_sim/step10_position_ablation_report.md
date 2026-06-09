# Step 10 Position-Confidence Ablation Report

## Overall Metrics

| Method | Avg Delay (s) | Timely Rate | Loss Rate | Avg Tx Cost | Emergency Timely Rate |
|---|---:|---:|---:|---:|---:|
| Link-aware | 0.016 | 1.000 | 0.000 | 1.917 | 1.000 |
| No-Regime-Gate | 0.023 | 0.973 | 0.027 | 1.678 | 1.000 |
| Full | 0.024 | 0.972 | 0.028 | 1.678 | 1.000 |
| No-GNSS | 0.024 | 0.965 | 0.035 | 1.642 | 1.000 |
| No-RSU | 0.025 | 0.970 | 0.030 | 1.684 | 1.000 |
| No-Env | 0.019 | 0.982 | 0.018 | 1.668 | 1.000 |
| No-Traj | 0.022 | 0.977 | 0.023 | 1.691 | 1.000 |

## Delta Relative to Full

| Method | Avg Delay Delta | Timely Gain | Loss Delta | Avg Tx Cost Delta | Emergency Timely Gain |
|---|---:|---:|---:|---:|---:|
| Link-aware | -0.008 | 0.028 | -0.028 | 0.239 | 0.000 |
| No-Regime-Gate | -0.001 | 0.002 | -0.002 | 0.000 | 0.000 |
| No-GNSS | -0.000 | -0.007 | 0.007 | -0.036 | 0.000 |
| No-RSU | 0.001 | -0.002 | 0.002 | 0.006 | 0.000 |
| No-Env | -0.005 | 0.010 | -0.010 | -0.010 | 0.000 |
| No-Traj | -0.003 | 0.005 | -0.005 | 0.013 | 0.000 |

## PosDeg_Emerg Focus

| Method | Avg Delay (s) | Timely Rate | Loss Rate | Avg Tx Cost | Emergency Timely Rate |
|---|---:|---:|---:|---:|---:|
| Link-aware | 0.012 | 1.000 | 0.000 | 2.132 | 1.000 |
| No-Regime-Gate | 0.013 | 1.000 | 0.000 | 2.237 | 1.000 |
| Full | 0.013 | 1.000 | 0.000 | 2.237 | 1.000 |
| No-GNSS | 0.012 | 0.991 | 0.009 | 2.063 | 1.000 |
| No-RSU | 0.014 | 1.000 | 0.000 | 2.237 | 1.000 |
| No-Env | 0.013 | 1.000 | 0.000 | 2.205 | 1.000 |
| No-Traj | 0.013 | 1.000 | 0.000 | 2.237 | 1.000 |

## PosDeg_Emerg Delta Relative to Full

| Method | Timely Gain | Emergency Timely Gain | Avg Tx Cost Delta |
|---|---:|---:|---:|
| Link-aware | 0.000 | 0.000 | -0.105 |
| No-Regime-Gate | 0.000 | 0.000 | 0.000 |
| No-GNSS | -0.009 | 0.000 | -0.175 |
| No-RSU | 0.000 | 0.000 | 0.000 |
| No-Env | 0.000 | 0.000 | -0.033 |
| No-Traj | 0.000 | 0.000 | 0.000 |

## Position-Confidence-Constrained Effective Warning

Threshold: `q_{pos} >= 0.50` within `PosDeg_Emerg` emergency samples.

| Method | Effective Warning Rate | Effective Coverage | Effective Count | Effective Avg Delay (s) |
|---|---:|---:|---:|---:|
| Link-aware | NaN | 0.000 | 0 | NaN |
| No-Regime-Gate | NaN | 0.000 | 0 | NaN |
| Full | NaN | 0.000 | 0 | NaN |
| No-GNSS | 1.000 | 1.000 | 6 | 0.010 |
| No-RSU | NaN | 0.000 | 0 | NaN |
| No-Env | NaN | 0.000 | 0 | NaN |
| No-Traj | NaN | 0.000 | 0 | NaN |

## Effective Warning Delta Relative to Full

| Method | Effective Warning Rate Gain | Effective Coverage Gain | Effective Count Delta | Effective Avg Delay Delta (s) |
|---|---:|---:|---:|---:|
| Link-aware | NaN | 0.000 | 0 | NaN |
| No-Regime-Gate | NaN | 0.000 | 0 | NaN |
| No-GNSS | NaN | 1.000 | 6 | NaN |
| No-RSU | NaN | 0.000 | 0 | NaN |
| No-Env | NaN | 0.000 | 0 | NaN |
| No-Traj | NaN | 0.000 | 0 | NaN |

## Observation

- Full model emergency timely rate: **1.000**.
- The largest overall emergency-timely degradation comes from removing **No-Regime-Gate**.
- Under the `q_{pos}`-constrained effective-warning metric, the largest degradation comes from removing **No-Regime-Gate**.
- This ablation is intended to identify which positioning-confidence submodule contributes most to the scheduling gain.
- Full effective-warning rate under `q_{pos}` constraint: **NaN** with coverage **0.000**.
