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
| 10014 | Default | Proposed | 1.597 | 0.000 | 0.000 | 0.00 |
| 10014 | Default | TimelyLow | 1.597 | 0.000 | 0.000 | 0.00 |
| 10014 | Default | TimelyHigh | 1.597 | 0.000 | 0.000 | 0.00 |
| 10014 | Default | ProtectLow | 1.597 | 0.000 | 0.000 | -0.60 |
| 10014 | Default | ProtectHigh | 1.631 | 0.000 | 0.033 | 0.47 |
| 10014 | Default | EmergencyFloorLow | 1.597 | 0.000 | 0.000 | 0.00 |
| 10014 | Default | EmergencyFloorHigh | 1.597 | 0.000 | 0.000 | 0.33 |
| 10014 | ForestGeometry | Proposed | 1.364 | 0.000 | 0.000 | 0.00 |
| 10014 | ForestGeometry | TimelyLow | 1.364 | 0.000 | 0.000 | 0.00 |
| 10014 | ForestGeometry | TimelyHigh | 1.364 | 0.000 | 0.000 | 0.00 |
| 10014 | ForestGeometry | ProtectLow | 1.331 | 0.000 | -0.033 | -0.52 |
| 10014 | ForestGeometry | ProtectHigh | 1.398 | 0.000 | 0.033 | 0.60 |
| 10014 | ForestGeometry | EmergencyFloorLow | 1.364 | 0.000 | 0.000 | 0.00 |
| 10014 | ForestGeometry | EmergencyFloorHigh | 1.364 | 0.000 | 0.000 | 0.25 |
| 10006 | Default | Proposed | 0.166 | 0.000 | 0.000 | 0.00 |
| 10006 | Default | TimelyLow | 0.166 | 0.000 | 0.000 | 0.00 |
| 10006 | Default | TimelyHigh | 0.166 | 0.000 | 0.000 | 0.00 |
| 10006 | Default | ProtectLow | 0.166 | 0.000 | 0.000 | -0.01 |
| 10006 | Default | ProtectHigh | 0.166 | 0.000 | 0.000 | 0.02 |
| 10006 | Default | EmergencyFloorLow | 0.166 | 0.000 | 0.000 | 0.00 |
| 10006 | Default | EmergencyFloorHigh | 0.166 | 0.000 | 0.000 | 11.86 |
| 10006 | ForestGeometry | Proposed | 0.200 | 0.066 | 0.000 | 0.00 |
| 10006 | ForestGeometry | TimelyLow | 0.200 | 0.066 | 0.000 | 0.00 |
| 10006 | ForestGeometry | TimelyHigh | 0.200 | 0.066 | 0.000 | 0.00 |
| 10006 | ForestGeometry | ProtectLow | 0.200 | 0.066 | 0.000 | -0.01 |
| 10006 | ForestGeometry | ProtectHigh | 0.200 | 0.066 | 0.000 | 0.02 |
| 10006 | ForestGeometry | EmergencyFloorLow | 0.200 | 0.066 | 0.000 | 0.00 |
| 10006 | ForestGeometry | EmergencyFloorHigh | 0.200 | 0.066 | 0.000 | 10.32 |
| 10011 | Default | Proposed | 0.000 | 0.000 | 0.000 | 0.00 |
| 10011 | Default | TimelyLow | 0.000 | 0.000 | 0.000 | 0.00 |
| 10011 | Default | TimelyHigh | 0.000 | 0.000 | 0.000 | 0.00 |
| 10011 | Default | ProtectLow | 0.000 | 0.000 | 0.000 | -0.55 |
| 10011 | Default | ProtectHigh | 0.000 | 0.000 | 0.000 | 0.38 |
| 10011 | Default | EmergencyFloorLow | 0.000 | 0.000 | 0.000 | 0.00 |
| 10011 | Default | EmergencyFloorHigh | 0.000 | 0.000 | 0.000 | 1.07 |
| 10011 | ForestGeometry | Proposed | 3.627 | 0.000 | 0.000 | 0.00 |
| 10011 | ForestGeometry | TimelyLow | 3.627 | 0.000 | 0.000 | 0.00 |
| 10011 | ForestGeometry | TimelyHigh | 3.627 | 0.000 | 0.000 | 0.00 |
| 10011 | ForestGeometry | ProtectLow | 3.627 | 0.000 | 0.000 | -0.19 |
| 10011 | ForestGeometry | ProtectHigh | 3.627 | 0.000 | 0.000 | 0.31 |
| 10011 | ForestGeometry | EmergencyFloorLow | 3.627 | 0.000 | 0.000 | 0.00 |
| 10011 | ForestGeometry | EmergencyFloorHigh | 3.627 | 0.000 | 0.000 | 0.63 |
| 10019 | Default | Proposed | 0.000 | 0.000 | 0.000 | 0.00 |
| 10019 | Default | TimelyLow | 0.000 | 0.000 | 0.000 | 0.00 |
| 10019 | Default | TimelyHigh | 0.000 | 0.000 | 0.000 | 0.00 |
| 10019 | Default | ProtectLow | 0.000 | 0.000 | 0.000 | 0.00 |
| 10019 | Default | ProtectHigh | 0.000 | 0.000 | 0.000 | 0.00 |
| 10019 | Default | EmergencyFloorLow | 0.000 | 0.000 | 0.000 | 0.00 |
| 10019 | Default | EmergencyFloorHigh | 0.000 | 0.000 | 0.000 | 17.90 |
| 10019 | ForestGeometry | Proposed | 0.300 | 0.330 | 0.000 | 0.00 |
| 10019 | ForestGeometry | TimelyLow | 0.300 | 0.330 | 0.000 | 0.00 |
| 10019 | ForestGeometry | TimelyHigh | 0.300 | 0.330 | 0.000 | 0.00 |
| 10019 | ForestGeometry | ProtectLow | 0.300 | 0.330 | 0.000 | 0.00 |
| 10019 | ForestGeometry | ProtectHigh | 0.300 | 0.330 | 0.000 | 0.09 |
| 10019 | ForestGeometry | EmergencyFloorLow | 0.300 | 0.330 | 0.000 | 0.00 |
| 10019 | ForestGeometry | EmergencyFloorHigh | 0.333 | 0.366 | 0.033 | 17.73 |
| 10017 | Default | Proposed | 0.732 | 0.000 | 0.000 | 0.00 |
| 10017 | Default | TimelyLow | 0.732 | 0.000 | 0.000 | 0.00 |
| 10017 | Default | TimelyHigh | 0.732 | 0.000 | 0.000 | 0.00 |
| 10017 | Default | ProtectLow | 0.732 | 0.000 | 0.000 | -0.47 |
| 10017 | Default | ProtectHigh | 0.732 | 0.000 | 0.000 | 0.30 |
| 10017 | Default | EmergencyFloorLow | 0.732 | 0.000 | 0.000 | 0.00 |
| 10017 | Default | EmergencyFloorHigh | 0.732 | 0.000 | 0.000 | 1.57 |
| 10017 | ForestGeometry | Proposed | 0.666 | 0.000 | 0.000 | 0.00 |
| 10017 | ForestGeometry | TimelyLow | 0.666 | 0.000 | 0.000 | 0.00 |
| 10017 | ForestGeometry | TimelyHigh | 0.666 | 0.000 | 0.000 | 0.00 |
| 10017 | ForestGeometry | ProtectLow | 0.666 | 0.000 | 0.000 | -0.50 |
| 10017 | ForestGeometry | ProtectHigh | 0.666 | 0.000 | 0.000 | 0.51 |
| 10017 | ForestGeometry | EmergencyFloorLow | 0.666 | 0.000 | 0.000 | 0.00 |
| 10017 | ForestGeometry | EmergencyFloorHigh | 0.666 | 0.000 | 0.000 | 1.20 |
