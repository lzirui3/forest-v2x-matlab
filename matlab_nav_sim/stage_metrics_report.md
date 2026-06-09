# Stage Metrics Report

## Headline Findings

- Best full-stage RMSE method: **Residual-adaptive + NHC** (1.634 m)
- Relative to `Baseline fusion`, `Residual-adaptive + NHC` RMSE change:
  - Degraded stage: 4.28%
  - Outage stage: 40.84%
  - Recovery stage: 6.07%

## Interpretation Template

The results indicate that the multi-constraint residual-adaptive strategy improves positioning performance compared with the baseline fusion method, especially in stages where GNSS observations become unreliable. In the degraded stage, the adaptive weighting mechanism reduces the influence of low-quality GNSS observations. In the outage stage, the IMU and motion constraints sustain the navigation solution, while in the recovery stage the method regains accuracy after GNSS observations return.
