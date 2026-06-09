# Step 9 Weight Calibration Report

## Calibration Objective

- Objective = overall emergency timely + 0.85 * PosDeg emergency timely + 0.20 * overall timely - 0.05 * average Tx cost - 0.02 * PosDeg Tx cost - 0.50 * loss rate.

## Top Configurations

| Rank | WTimely | WReliability | WCost | WPosRisk | WEvent | Objective | EmergencyTimely | PosDegEmergencyTimely | AvgTxCost |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | 0.90 | 0.55 | 0.10 | 0.18 | 0.12 | 1.0473 | 0.7946 | 0.7216 | 4.9977 |
| 2 | 0.90 | 0.55 | 0.10 | 0.18 | 0.22 | 1.0473 | 0.7946 | 0.7216 | 4.9977 |
| 3 | 0.90 | 0.55 | 0.10 | 0.18 | 0.32 | 1.0473 | 0.7946 | 0.7216 | 4.9977 |
| 4 | 0.90 | 0.55 | 0.10 | 0.28 | 0.12 | 1.0473 | 0.7946 | 0.7216 | 4.9977 |
| 5 | 0.90 | 0.55 | 0.10 | 0.28 | 0.22 | 1.0473 | 0.7946 | 0.7216 | 4.9977 |
| 6 | 0.90 | 0.55 | 0.10 | 0.28 | 0.32 | 1.0473 | 0.7946 | 0.7216 | 4.9977 |
| 7 | 0.90 | 0.55 | 0.10 | 0.38 | 0.12 | 1.0473 | 0.7946 | 0.7216 | 4.9977 |
| 8 | 0.90 | 0.55 | 0.10 | 0.38 | 0.22 | 1.0473 | 0.7946 | 0.7216 | 4.9977 |
| 9 | 0.90 | 0.55 | 0.10 | 0.38 | 0.32 | 1.0473 | 0.7946 | 0.7216 | 4.9977 |
| 10 | 1.10 | 0.55 | 0.10 | 0.18 | 0.12 | 1.0459 | 0.7946 | 0.7216 | 5.0102 |

## Recommended Configuration

- WTimely = 0.90
- WReliability = 0.55
- WCost = 0.10
- WPosRisk = 0.18
- WEvent = 0.12
- Objective = 1.0473
- Mean emergency timely rate = 0.7946
- Mean PosDeg emergency timely rate = 0.7216
- Mean transmission cost = 4.9977
