# Step51 PER Lookup 适用范围分析报告

本报告使用最终物理层口径 `per_lookup`，合并主场景 `step49_per_lookup_final_validation_50seed` 与 held-out 场景 `step50_per_lookup_heldout_validation_50seed`。

该报告替代早期 Step46，作为 VTC 投稿前的最终适用范围证据。

## 1. 总体分类统计

| Applicability class | Count |
|---|---:|
| BaselineImprovement | 6 |
| WeakButSafe | 5 |
| PrimaryApplicable | 3 |
| BoundaryLimited | 2 |

## 2. 逐场景适用范围表

| Dataset | Scene | Config | NLOS (%) | Mean distance (m) | Timely gain vs heuristic (pp) | Emergency gain (pp) | Timely gain vs link (pp) | Cost delta (%) | Risk class | Gain class | Applicability |
|---|---|---|---:|---:|---:|---:|---:|---:|---|---|---|
| Main | 10006 | Default | 30.0 | 51.5 | 0.176 | 0.000 | 5.900 | 4.53 | ModerateRisk | BaselineGain | BaselineImprovement |
| Main | 10006 | ForestGeometry | 30.0 | 51.5 | 0.522 | -0.007 | 0.619 | 10.86 | HighRiskForest | WeakNonnegative | WeakButSafe |
| HeldOut | 10007 | Default | 13.0 | 54.4 | 0.063 | 0.000 | 3.957 | 2.90 | ModerateRisk | BaselineGain | BaselineImprovement |
| HeldOut | 10007 | ForestGeometry | 13.0 | 54.4 | 0.120 | 0.000 | 1.381 | 9.02 | HighRiskForest | BaselineGain | BaselineImprovement |
| Main | 10011 | Default | 6.0 | 98.8 | 0.123 | 0.000 | 0.233 | -3.63 | ModerateRisk | WeakNonnegative | WeakButSafe |
| Main | 10011 | ForestGeometry | 6.0 | 98.8 | 4.100 | 0.100 | 12.889 | 7.31 | HighRiskForest | StrongGain | PrimaryApplicable |
| HeldOut | 10013 | Default | 53.0 | 21.5 | 0.000 | 0.000 | 0.023 | 2.54 | ModerateRisk | WeakNonnegative | WeakButSafe |
| HeldOut | 10013 | ForestGeometry | 53.0 | 21.5 | -0.459 | -0.536 | -0.589 | 6.25 | HighRiskForest | GracefulBoundary | BoundaryLimited |
| Main | 10014 | Default | 20.0 | 64.9 | 0.343 | 0.000 | 5.724 | -4.40 | ModerateRisk | BaselineGain | BaselineImprovement |
| Main | 10014 | ForestGeometry | 20.0 | 64.9 | 1.032 | 0.333 | 1.181 | 9.40 | HighRiskForest | StrongGain | PrimaryApplicable |
| HeldOut | 10015 | Default | 7.0 | 81.7 | 0.017 | 0.000 | 2.103 | -1.08 | ModerateRisk | BaselineGain | BaselineImprovement |
| HeldOut | 10015 | ForestGeometry | 7.0 | 81.7 | 2.789 | 0.000 | 6.602 | 12.98 | HighRiskForest | StrongGain | PrimaryApplicable |
| Main | 10017 | Default | 48.0 | 62.1 | 0.173 | 0.000 | 11.085 | -3.77 | ModerateRisk | BaselineGain | BaselineImprovement |
| Main | 10017 | ForestGeometry | 48.0 | 62.1 | 0.619 | 0.000 | 0.905 | 12.12 | HighRiskForest | WeakNonnegative | WeakButSafe |
| Main | 10019 | Default | 44.0 | 22.8 | 0.000 | 0.000 | 0.000 | 2.16 | ModerateRisk | WeakNonnegative | WeakButSafe |
| Main | 10019 | ForestGeometry | 44.0 | 22.8 | -0.672 | -0.740 | -0.715 | -0.53 | HighRiskForest | GracefulBoundary | BoundaryLimited |

## 3. 审稿级结论口径

最终应表述为：本文方法不是全场景支配型调度器，而是面向林区遮挡、链路退化与定位风险叠加条件的风险约束在线调度方法。
在低风险或已接近饱和的场景中，收益可能表现为弱正收益、近似持平或边界退化；这些结果应作为适用范围边界，而不是继续调参掩盖。

## 4. 需要在论文中明确的限制

1. `LimitedRisk` 场景必须单独解释，不能并入平均值后宣称全局优势。
2. `WeakButSafe` 和 `BoundaryLimited` 场景适合支撑 graceful degradation，不适合支撑强性能提升。
3. 最终性能表应同时报告主场景与 held-out 场景，防止被质疑只在调参场景有效。
