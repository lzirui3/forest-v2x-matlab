# Step50 PER Lookup Held-Out Validation Report

PDR mode is fixed to `per_lookup` for all held-out cases.

Seeds per scene/config: 50.

Held-out scenes: `10013`, `10007`, `10015`.

| Scene | Config | Timely gain vs heuristic (pp) | Emergency gain vs heuristic (pp) | Timely gain vs link (pp) | Cost delta vs heuristic (%) | Decision |
|---|---|---:|---:|---:|---:|---|
| 10013 | Default | 0.000 | 0.000 | 0.023 | 2.54 | PerLookupHeldoutWeak |
| 10013 | ForestGeometry | -0.459 | -0.536 | -0.589 | 6.25 | PerLookupHeldoutBoundary |
| 10007 | Default | 0.063 | 0.000 | 3.957 | 2.90 | PerLookupHeldoutWeak |
| 10007 | ForestGeometry | 0.120 | 0.000 | 1.381 | 9.02 | PerLookupHeldoutWeak |
| 10015 | Default | 0.017 | 0.000 | 2.103 | -1.08 | PerLookupHeldoutWeak |
| 10015 | ForestGeometry | 2.789 | 0.000 | 6.602 | 12.98 | PerLookupHeldoutStrong |

Interpretation: this is the held-out counterpart of Step49 under the final PER lookup physical-layer setting. It must be used together with Step49 before making final VTC claims.
