# Step 11 Sensitivity Report

## Scope

- Method under test: `Confidence-driven`.
- Focus metrics: overall timely rate, overall emergency timely rate, `PosDeg_Emerg` emergency timely rate, and transmission cost.

## Summary Table

| Parameter | Default | Best PosDeg Emergency Timely Value | Best PosDeg Emergency Timely | Default PosDeg Emergency Timely | PosDeg Span | Avg Tx Cost Span |
|---|---:|---:|---:|---:|---:|---:|
| event_rate_scale_gain | 0.220 | 0.100 | 0.636 | 0.636 | 0.000 | 0.000 |
| event_synergy_gain | 0.450 | 0.150 | 0.636 | 0.636 | 0.000 | 0.000 |
| utility_constraint_penalty | 1.600 | 0.800 | 0.636 | 0.636 | 0.000 | 0.000 |
| utility_margin_sigmoid_scale | 0.060 | 0.045 | 0.636 | 0.636 | 0.045 | 0.549 |
| utility_weight_cost | 0.070 | 0.140 | 0.636 | 0.636 | 0.000 | 0.399 |
| utility_weight_event | 0.220 | 0.080 | 0.636 | 0.636 | 0.000 | 0.000 |
| utility_weight_position_risk | 0.280 | 0.120 | 0.636 | 0.636 | 0.000 | 0.011 |
| utility_weight_reliability | 0.550 | 0.350 | 0.636 | 0.636 | 0.000 | 0.011 |
| utility_weight_timely | 1.000 | 0.700 | 0.636 | 0.636 | 0.000 | 0.011 |

## Parameter-by-Parameter Observations

### event_rate_scale_gain

- Default value: 0.220
- Best overall emergency timely rate: 0.775 at 0.100
- Best `PosDeg_Emerg` emergency timely rate: 0.636 at 0.100
- Default `PosDeg_Emerg` emergency timely rate: 0.636
- Overall emergency timely span: 0.000
- `PosDeg_Emerg` emergency timely span: 0.000
- Average Tx cost span: 0.000
- Sensitivity level: Low

### event_synergy_gain

- Default value: 0.450
- Best overall emergency timely rate: 0.775 at 0.150
- Best `PosDeg_Emerg` emergency timely rate: 0.636 at 0.150
- Default `PosDeg_Emerg` emergency timely rate: 0.636
- Overall emergency timely span: 0.000
- `PosDeg_Emerg` emergency timely span: 0.000
- Average Tx cost span: 0.000
- Sensitivity level: Low

### utility_constraint_penalty

- Default value: 1.600
- Best overall emergency timely rate: 0.775 at 0.800
- Best `PosDeg_Emerg` emergency timely rate: 0.636 at 0.800
- Default `PosDeg_Emerg` emergency timely rate: 0.636
- Overall emergency timely span: 0.000
- `PosDeg_Emerg` emergency timely span: 0.000
- Average Tx cost span: 0.000
- Sensitivity level: Low

### utility_margin_sigmoid_scale

- Default value: 0.060
- Best overall emergency timely rate: 0.775 at 0.045
- Best `PosDeg_Emerg` emergency timely rate: 0.636 at 0.045
- Default `PosDeg_Emerg` emergency timely rate: 0.636
- Overall emergency timely span: 0.025
- `PosDeg_Emerg` emergency timely span: 0.045
- Average Tx cost span: 0.549
- Sensitivity level: Low

### utility_weight_cost

- Default value: 0.070
- Best overall emergency timely rate: 0.775 at 0.030
- Best `PosDeg_Emerg` emergency timely rate: 0.636 at 0.030
- Default `PosDeg_Emerg` emergency timely rate: 0.636
- Overall emergency timely span: 0.000
- `PosDeg_Emerg` emergency timely span: 0.000
- Average Tx cost span: 0.399
- Sensitivity level: Low

### utility_weight_event

- Default value: 0.220
- Best overall emergency timely rate: 0.775 at 0.080
- Best `PosDeg_Emerg` emergency timely rate: 0.636 at 0.080
- Default `PosDeg_Emerg` emergency timely rate: 0.636
- Overall emergency timely span: 0.000
- `PosDeg_Emerg` emergency timely span: 0.000
- Average Tx cost span: 0.000
- Sensitivity level: Low

### utility_weight_position_risk

- Default value: 0.280
- Best overall emergency timely rate: 0.775 at 0.120
- Best `PosDeg_Emerg` emergency timely rate: 0.636 at 0.120
- Default `PosDeg_Emerg` emergency timely rate: 0.636
- Overall emergency timely span: 0.000
- `PosDeg_Emerg` emergency timely span: 0.000
- Average Tx cost span: 0.011
- Sensitivity level: Low

### utility_weight_reliability

- Default value: 0.550
- Best overall emergency timely rate: 0.775 at 0.350
- Best `PosDeg_Emerg` emergency timely rate: 0.636 at 0.350
- Default `PosDeg_Emerg` emergency timely rate: 0.636
- Overall emergency timely span: 0.000
- `PosDeg_Emerg` emergency timely span: 0.000
- Average Tx cost span: 0.011
- Sensitivity level: Low

### utility_weight_timely

- Default value: 1.000
- Best overall emergency timely rate: 0.775 at 0.700
- Best `PosDeg_Emerg` emergency timely rate: 0.636 at 0.700
- Default `PosDeg_Emerg` emergency timely rate: 0.636
- Overall emergency timely span: 0.000
- `PosDeg_Emerg` emergency timely span: 0.000
- Average Tx cost span: 0.011
- Sensitivity level: Low

## Interpretation

- Parameters with large `PosDeg_Emerg` span strongly affect critical-stage behavior and should be tuned carefully.
- Parameters with small span are relatively robust in the tested range and can be fixed without heavily affecting the main conclusion.
- Recommended default values should prioritize critical-stage emergency timely rate first, then transmission cost.
