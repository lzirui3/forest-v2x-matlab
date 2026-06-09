# Step42 Core Parameter Sensitivity Report

Purpose: internal credibility check for the proposed method core parameter families.

Candidate definitions:

- Proposed: current Risk-constrained-v6 setting.
- TimelyLow/TimelyHigh: required timely target family scaled by 0.90/1.10.
- ProtectLow/ProtectHigh: required protection target family scaled by 0.90/1.10.
- EmergencyFloorLow/High: emergency minimum rate multiplier set to 1.7/2.5.

## Candidate Table

| Scene | Config | Candidate | Timely Gain vs Heuristic (pp) | Emergency Gain vs Heuristic (pp) | Timely Delta vs Proposed (pp) | Cost Delta vs Proposed (%) |
|---|---|---|---:|---:|---:|---:|
| 10014 | Default | Proposed | 1.997 | 0.000 | 0.000 | 0.00 |
| 10014 | Default | TimelyLow | 1.997 | 0.000 | 0.000 | 0.00 |
| 10014 | Default | TimelyHigh | 1.997 | 0.000 | 0.000 | 0.00 |
| 10014 | Default | ProtectLow | 1.997 | 0.000 | 0.000 | -0.69 |
| 10014 | Default | ProtectHigh | 1.997 | 0.000 | 0.000 | 0.60 |
| 10014 | Default | EmergencyFloorLow | 1.997 | 0.000 | 0.000 | 0.00 |
| 10014 | Default | EmergencyFloorHigh | 1.997 | 0.000 | 0.000 | 0.33 |
