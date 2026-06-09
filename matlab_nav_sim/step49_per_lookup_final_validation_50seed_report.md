# Step49 PER-Lookup Final Validation Report

PDR mode is fixed to `per_lookup` for all cases.

Seeds per scene/config: 50.

| Scene | Config | Timely gain vs heuristic (pp) | Emergency gain vs heuristic (pp) | Timely gain vs link (pp) | Cost delta vs heuristic (%) | Decision |
|---|---|---:|---:|---:|---:|---|
| 10014 | Default | 0.343 | 0.000 | 5.724 | -4.40 | PerLookupWeak |
| 10014 | ForestGeometry | 1.032 | 0.333 | 1.181 | 9.40 | PerLookupStrong |
| 10006 | Default | 0.176 | 0.000 | 5.900 | 4.53 | PerLookupWeak |
| 10006 | ForestGeometry | 0.522 | -0.007 | 0.619 | 10.86 | PerLookupWeak |
| 10011 | Default | 0.123 | 0.000 | 0.233 | -3.63 | PerLookupWeak |
| 10011 | ForestGeometry | 4.100 | 0.100 | 12.889 | 7.31 | PerLookupStrong |
| 10019 | Default | 0.000 | 0.000 | 0.000 | 2.16 | PerLookupWeak |
| 10019 | ForestGeometry | -0.672 | -0.740 | -0.715 | -0.53 | PerLookupRisk |
| 10017 | Default | 0.173 | 0.000 | 11.085 | -3.77 | PerLookupWeak |
| 10017 | ForestGeometry | 0.619 | 0.000 | 0.905 | 12.12 | PerLookupWeak |

Interpretation: this report is the candidate replacement for Step40 if the paper uses WiLab PER lookup as the final physical-layer model.
