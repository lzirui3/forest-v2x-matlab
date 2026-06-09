# Step 12 Multi-Seed Statistical Report

## Scope

- Number of seeds: 20
- Methods: `Link-aware`, `Full`, `No-GNSS`, `No-RSU`, `No-Env`

## Overall Summary

| Method | Emergency Timely Mean | Emergency Timely Std | Emergency Timely CI95 | Avg Tx Cost Mean | Avg Tx Cost Std |
|---|---:|---:|---:|---:|---:|
| Link-aware | 1.000 | 0.000 | 0.000 | 5.316 | 0.000 |
| Full | 1.000 | 0.000 | 0.000 | 5.549 | 0.000 |
| No-GNSS | 1.000 | 0.000 | 0.000 | 5.543 | 0.000 |
| No-RSU | 1.000 | 0.000 | 0.000 | 5.567 | 0.001 |
| No-Env | 1.000 | 0.000 | 0.000 | 5.549 | 0.000 |

## PosDeg_Emerg Summary

| Method | PosDeg Emergency Timely Mean | PosDeg Emergency Timely Std | PosDeg Emergency Timely CI95 | PosDeg Avg Tx Cost Mean |
|---|---:|---:|---:|---:|
| Link-aware | 1.000 | 0.000 | 0.000 | 7.500 |
| Full | 1.000 | 0.000 | 0.000 | 8.500 |
| No-GNSS | 1.000 | 0.000 | 0.000 | 8.500 |
| No-RSU | 1.000 | 0.000 | 0.000 | 8.500 |
| No-Env | 1.000 | 0.000 | 0.000 | 8.500 |

## Effective Warning Under Position-Confidence Constraint

| Method | q_pos Threshold | Effective Warning Mean | Effective Warning Std | Effective Warning CI95 | Effective Coverage Mean |
|---|---:|---:|---:|---:|---:|
| Link-aware | 0.50 | 1.000 | 0.000 | 0.000 | 0.273 |
| Full | 0.50 | 1.000 | 0.000 | 0.000 | 0.273 |
| No-GNSS | 0.50 | 1.000 | 0.000 | 0.000 | 1.000 |
| No-RSU | 0.50 | 1.000 | 0.000 | 0.000 | 0.136 |
| No-Env | 0.50 | 1.000 | 0.000 | 0.000 | 0.273 |

## Observation

- `Full` overall emergency timely mean: **1.000**.
- `Link-aware` overall emergency timely mean: **1.000**.
- `Full` PosDeg emergency timely mean: **1.000**.
- `Link-aware` PosDeg emergency timely mean: **1.000**.
- `Full` effective warning mean under `q_{pos}` constraint: **1.000**.
- `Link-aware` effective warning mean under `q_{pos}` constraint: **1.000**.
- This report is intended to verify that the main advantage of the full method remains statistically stable across randomized scenario seeds.
