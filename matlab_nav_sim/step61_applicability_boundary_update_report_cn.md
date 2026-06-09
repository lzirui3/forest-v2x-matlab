# Step61 适用边界更新报告

本步骤汇总 Step58、Step59、Step60 证据链，目标是明确主方法的有效区间、平稳退化区间和失败边界。该步骤不重调 `Risk-constrained-v6`，不删除 `10019/10013 ForestGeometry` 负例。

## 1. 适用性分类统计

| ApplicabilityClass | Count |
|---|---:|
| EffectiveRegime | 7 |
| FailureBoundary | 2 |
| GracefulDegradation | 15 |

## 2. 适用性总表

| Source | Scene | Config | Class | Baseline ceiling | Emergency feasibility | Overlap | Cost-gain | Stronger baseline | Note |
|---|---|---|---|---|---|---|---|---|---|
| Step58+Step59 | 10006 | Default | EffectiveRegime | LowBaselineCeiling | EmergencyNeutral | NlosEmergencyOverlap | CostlySmallGain | StrongerBaselineGain | Applicable when risk/degradation creates exploitable scheduling headroom; stronger baselines are outperformed or nonnegative. Stronger=StrongerBaselineGain; overlap=NlosEmergencyOverlap; cost=CostlySmallGain. |
| Step58+Step59 | 10006 | ForestGeometry | GracefulDegradation | ModerateBaselineCeiling | EmergencyNeutral | NlosEmergencyOverlap | CostlySmallGain | StrongerBaselineNonnegative | Use as boundary evidence: gains are small, baseline ceiling is high, or cost-gain tradeoff is weak. Stronger=StrongerBaselineNonnegative; overlap=NlosEmergencyOverlap; cost=CostlySmallGain. |
| Step58+Step59 | 10007 | Default | EffectiveRegime | LowBaselineCeiling | EmergencyNeutral | ModerateOverlap | CostlySmallGain | StrongerBaselineGain | Applicable when risk/degradation creates exploitable scheduling headroom; stronger baselines are outperformed or nonnegative. Stronger=StrongerBaselineGain; overlap=ModerateOverlap; cost=CostlySmallGain. |
| Step58+Step59 | 10007 | ForestGeometry | GracefulDegradation | ModerateBaselineCeiling | EmergencyNeutral | ModerateOverlap | CostlySmallGain | StrongerBaselineBoundary | Use as boundary evidence: gains are small, baseline ceiling is high, or cost-gain tradeoff is weak. Stronger=StrongerBaselineBoundary; overlap=ModerateOverlap; cost=CostlySmallGain. |
| Step58+Step59 | 10011 | Default | GracefulDegradation | HighBaselineCeiling | EmergencyNeutral | LowOverlapOpenRoad | CostSavingOrNeutral | StrongerBaselineBoundary | Use as boundary evidence: gains are small, baseline ceiling is high, or cost-gain tradeoff is weak. Stronger=StrongerBaselineBoundary; overlap=LowOverlapOpenRoad; cost=CostSavingOrNeutral. |
| Step58+Step59 | 10011 | ForestGeometry | EffectiveRegime | LowBaselineCeiling | EmergencyNeutral | LowOverlapOpenRoad | EfficientGain | StrongerBaselineGain | Applicable when risk/degradation creates exploitable scheduling headroom; stronger baselines are outperformed or nonnegative. Stronger=StrongerBaselineGain; overlap=LowOverlapOpenRoad; cost=EfficientGain. |
| Step58+Step59 | 10013 | Default | GracefulDegradation | HighBaselineCeiling | EmergencyNeutral | HighBlindVegetationOverlap | CostlySmallGain | StrongerBaselineBoundary | Use as boundary evidence: gains are small, baseline ceiling is high, or cost-gain tradeoff is weak. Stronger=StrongerBaselineBoundary; overlap=HighBlindVegetationOverlap; cost=CostlySmallGain. |
| Step58+Step59 | 10013 | ForestGeometry | GracefulDegradation | HighBaselineCeiling | EmergencySaturatedOrHard | HighBlindVegetationOverlap | CostInefficientBoundary | StrongerBaselineBoundary | Use as boundary evidence: gains are small, baseline ceiling is high, or cost-gain tradeoff is weak. Stronger=StrongerBaselineBoundary; overlap=HighBlindVegetationOverlap; cost=CostInefficientBoundary. |
| Step58+Step59 | 10014 | Default | EffectiveRegime | LowBaselineCeiling | EmergencyNeutral | HighBlindVegetationOverlap | CostSavingOrNeutral | StrongerBaselineGain | Applicable when risk/degradation creates exploitable scheduling headroom; stronger baselines are outperformed or nonnegative. Stronger=StrongerBaselineGain; overlap=HighBlindVegetationOverlap; cost=CostSavingOrNeutral. |
| Step58+Step59 | 10014 | ForestGeometry | GracefulDegradation | ModerateBaselineCeiling | EmergencyImproved | HighBlindVegetationOverlap | EfficientGain | StrongerBaselineBoundary | Use as boundary evidence: gains are small, baseline ceiling is high, or cost-gain tradeoff is weak. Stronger=StrongerBaselineBoundary; overlap=HighBlindVegetationOverlap; cost=EfficientGain. |
| Step58+Step59 | 10015 | Default | EffectiveRegime | ModerateBaselineCeiling | EmergencyNeutral | LowOverlapOpenRoad | CostSavingOrNeutral | StrongerBaselineGain | Applicable when risk/degradation creates exploitable scheduling headroom; stronger baselines are outperformed or nonnegative. Stronger=StrongerBaselineGain; overlap=LowOverlapOpenRoad; cost=CostSavingOrNeutral. |
| Step58+Step59 | 10015 | ForestGeometry | GracefulDegradation | LowBaselineCeiling | EmergencyNeutral | LowOverlapOpenRoad | CostlySmallGain | StrongerBaselineBoundary | Use as boundary evidence: gains are small, baseline ceiling is high, or cost-gain tradeoff is weak. Stronger=StrongerBaselineBoundary; overlap=LowOverlapOpenRoad; cost=CostlySmallGain. |
| Step58+Step59 | 10017 | Default | EffectiveRegime | LowBaselineCeiling | EmergencyNeutral | ModerateOverlap | CostSavingOrNeutral | StrongerBaselineGain | Applicable when risk/degradation creates exploitable scheduling headroom; stronger baselines are outperformed or nonnegative. Stronger=StrongerBaselineGain; overlap=ModerateOverlap; cost=CostSavingOrNeutral. |
| Step58+Step59 | 10017 | ForestGeometry | GracefulDegradation | ModerateBaselineCeiling | EmergencyNeutral | ModerateOverlap | CostlySmallGain | StrongerBaselineBoundary | Use as boundary evidence: gains are small, baseline ceiling is high, or cost-gain tradeoff is weak. Stronger=StrongerBaselineBoundary; overlap=ModerateOverlap; cost=CostlySmallGain. |
| Step58+Step59 | 10019 | Default | GracefulDegradation | HighBaselineCeiling | EmergencyNeutral | HighBlindVegetationOverlap | CostlySmallGain | StrongerBaselineBoundary | Use as boundary evidence: gains are small, baseline ceiling is high, or cost-gain tradeoff is weak. Stronger=StrongerBaselineBoundary; overlap=HighBlindVegetationOverlap; cost=CostlySmallGain. |
| Step58+Step59 | 10019 | ForestGeometry | GracefulDegradation | HighBaselineCeiling | EmergencySaturatedOrHard | HighBlindVegetationOverlap | CostInefficientBoundary | StrongerBaselineBoundary | Use as boundary evidence: gains are small, baseline ceiling is high, or cost-gain tradeoff is weak. Stronger=StrongerBaselineBoundary; overlap=HighBlindVegetationOverlap; cost=CostInefficientBoundary. |
| Step60-ModerateForestGeometry | 10014 | ModerateForestGeometry | FailureBoundary | ModerateBaselineCeiling | PhysicallyHardEmergency | HighBlindVegetationOverlap | CostSavingOrNeutral | StrongerBaselineGain | Physical deadline-reliability headroom is insufficient; do not claim method dominance. Stronger=StrongerBaselineGain; overlap=HighBlindVegetationOverlap; cost=CostSavingOrNeutral. |
| Step60-ModerateForestGeometry | 10006 | ModerateForestGeometry | GracefulDegradation | HighBaselineCeiling | EmergencyModerateHeadroom | ModerateOverlap | CostSavingOrNeutral | StrongerBaselineGain | Use as boundary evidence: gains are small, baseline ceiling is high, or cost-gain tradeoff is weak. Stronger=StrongerBaselineGain; overlap=ModerateOverlap; cost=CostSavingOrNeutral. |
| Step60-ModerateForestGeometry | 10011 | ModerateForestGeometry | EffectiveRegime | ModerateBaselineCeiling | EmergencyHighHeadroom | ModerateOverlap | CostSavingOrNeutral | StrongerBaselineGain | Applicable when risk/degradation creates exploitable scheduling headroom; stronger baselines are outperformed or nonnegative. Stronger=StrongerBaselineGain; overlap=ModerateOverlap; cost=CostSavingOrNeutral. |
| Step60-ModerateForestGeometry | 10019 | ModerateForestGeometry | GracefulDegradation | ModerateBaselineCeiling | EmergencyHighHeadroom | HighBlindVegetationOverlap | CostSavingOrNeutral | StrongerBaselineBoundary | Use as boundary evidence: gains are small, baseline ceiling is high, or cost-gain tradeoff is weak. Stronger=StrongerBaselineBoundary; overlap=HighBlindVegetationOverlap; cost=CostSavingOrNeutral. |
| Step60-ModerateForestGeometry | 10017 | ModerateForestGeometry | FailureBoundary | ModerateBaselineCeiling | PhysicallyHardEmergency | ModerateOverlap | EfficientGain | StrongerBaselineGain | Physical deadline-reliability headroom is insufficient; do not claim method dominance. Stronger=StrongerBaselineGain; overlap=ModerateOverlap; cost=EfficientGain. |
| Step60-ModerateForestGeometry | 10013 | ModerateForestGeometry | GracefulDegradation | HighBaselineCeiling | EmergencyModerateHeadroom | HighBlindVegetationOverlap | CostInefficientBoundary | StrongerBaselineGain | Use as boundary evidence: gains are small, baseline ceiling is high, or cost-gain tradeoff is weak. Stronger=StrongerBaselineGain; overlap=HighBlindVegetationOverlap; cost=CostInefficientBoundary. |
| Step60-ModerateForestGeometry | 10007 | ModerateForestGeometry | GracefulDegradation | HighBaselineCeiling | EmergencyHighHeadroom | ModerateOverlap | CostSavingOrNeutral | StrongerBaselineBoundary | Use as boundary evidence: gains are small, baseline ceiling is high, or cost-gain tradeoff is weak. Stronger=StrongerBaselineBoundary; overlap=ModerateOverlap; cost=CostSavingOrNeutral. |
| Step60-ModerateForestGeometry | 10015 | ModerateForestGeometry | GracefulDegradation | HighBaselineCeiling | EmergencyHighHeadroom | ModerateOverlap | CostSavingOrNeutral | StrongerBaselineBoundary | Use as boundary evidence: gains are small, baseline ceiling is high, or cost-gain tradeoff is weak. Stronger=StrongerBaselineBoundary; overlap=ModerateOverlap; cost=CostSavingOrNeutral. |

## 3. 失败/边界场景

| Source | Scene | Config | Boundary class | Delta timely vs heuristic (pp) | Delta emergency vs heuristic (pp) | Cost delta (%) | Stronger baseline | Reason |
|---|---|---|---|---:|---:|---:|---|---|
| Step58-negative-boundary | 10006 | ForestGeometry | FailureBoundary | 0.522 | -0.007 | 10.865 | StrongerBaselineNonnegative | Step55 class: WeakNonnegative |
| Step58-negative-boundary | 10019 | ForestGeometry | FailureBoundary | -0.672 | -0.740 | -0.527 | StrongerBaselineBoundary | DeadlineReliabilityTradeoff: V6 improves packet loss versus heuristic but loses timely/emergency delivery, indicating deadline mismatch rather than pure reliability failure. |
| Step58-negative-boundary | 10013 | ForestGeometry | FailureBoundary | -0.459 | -0.536 | 6.252 | StrongerBaselineBoundary | Step55 class: Boundary |
| Step60-ModerateForestGeometry | 10014 | ModerateForestGeometry | PhysicalEmergencyBoundary | 0.745 | -0.667 | NaN | StrongerBaselineGain | Moderate forest evidence shows low emergency headroom or weak/negative gain; report as applicability boundary. |
| Step60-ModerateForestGeometry | 10006 | ModerateForestGeometry | GracefulDegradation | 0.087 | -1.342 | NaN | StrongerBaselineGain | Moderate forest evidence shows low emergency headroom or weak/negative gain; report as applicability boundary. |
| Step60-ModerateForestGeometry | 10017 | ModerateForestGeometry | PhysicalEmergencyBoundary | 1.238 | -0.056 | NaN | StrongerBaselineGain | Moderate forest evidence shows low emergency headroom or weak/negative gain; report as applicability boundary. |
| Step60-ModerateForestGeometry | 10013 | ModerateForestGeometry | GracefulDegradation | -0.133 | -0.356 | NaN | StrongerBaselineGain | Moderate forest evidence shows low emergency headroom or weak/negative gain; report as applicability boundary. |

## 4. DCC/AoI strengthened baseline overtake analysis

`DCC-CBR-window` 与 `AoI-greedy` 是 literature-inspired baselines，不是完整 ETSI DCC 协议栈或 AoI 最优调度策略。该表用于说明主方法面对更强简化基线时的胜负边界。

| Source | Scene | Config | Delta vs DCC-CBR (pp) | Delta vs AoI-greedy (pp) | Overtake class |
|---|---|---|---:|---:|---|
| Step59 | 10014 | Default | 1.304 | 2.639 | V6OvertakesBoth |
| Step59 | 10014 | ForestGeometry | -0.050 | 0.003 | NearTieOrBoundary |
| Step59 | 10006 | Default | 6.166 | 2.915 | V6OvertakesBoth |
| Step59 | 10006 | ForestGeometry | 0.366 | 0.033 | NearTieOrBoundary |
| Step59 | 10011 | Default | -0.436 | -0.416 | StrongerBaselineOvertakes |
| Step59 | 10011 | ForestGeometry | 18.789 | 4.569 | V6OvertakesBoth |
| Step59 | 10019 | Default | -0.013 | -0.013 | NearTieOrBoundary |
| Step59 | 10019 | ForestGeometry | -0.842 | -0.549 | StrongerBaselineOvertakes |
| Step59 | 10017 | Default | 8.649 | 2.669 | V6OvertakesBoth |
| Step59 | 10017 | ForestGeometry | 1.095 | 0.273 | NearTieOrBoundary |
| Step59 | 10013 | Default | -0.732 | -0.745 | StrongerBaselineOvertakes |
| Step59 | 10013 | ForestGeometry | -0.732 | -0.369 | StrongerBaselineOvertakes |
| Step59 | 10007 | Default | 6.875 | 1.993 | V6OvertakesBoth |
| Step59 | 10007 | ForestGeometry | -0.300 | -0.546 | StrongerBaselineOvertakes |
| Step59 | 10015 | Default | 2.998 | 1.414 | V6OvertakesBoth |
| Step59 | 10015 | ForestGeometry | -0.812 | 2.077 | StrongerBaselineOvertakes |
| Step60 | 10014 | ModerateForestGeometry | 1.148 | 0.532 | V6OvertakesBoth |
| Step60 | 10006 | ModerateForestGeometry | 1.285 | 0.406 | NearTieOrBoundary |
| Step60 | 10011 | ModerateForestGeometry | 0.705 | 0.203 | NearTieOrBoundary |
| Step60 | 10019 | ModerateForestGeometry | -0.419 | 0.140 | StrongerBaselineOvertakes |
| Step60 | 10017 | ModerateForestGeometry | 2.483 | 0.626 | V6OvertakesBoth |
| Step60 | 10013 | ModerateForestGeometry | 3.521 | 1.441 | V6OvertakesBoth |
| Step60 | 10007 | ModerateForestGeometry | 0.389 | 0.110 | NearTieOrBoundary |
| Step60 | 10015 | ModerateForestGeometry | 0.250 | 0.193 | NearTieOrBoundary |

## 5. 小增益场景解释口径

| Source | Scene | Config | Baseline | Gain (pp) | Stronger decision | Interpretation |
|---|---|---|---|---:|---|---|
| Step58 | 10006 | Default | Confidence-heuristic | 0.176 | StrongerBaselineGain | Small gain: use as graceful degradation or boundary evidence, not as dominance claim. |
| Step58 | 10006 | ForestGeometry | Confidence-heuristic | 0.522 | StrongerBaselineNonnegative | Small gain: use as graceful degradation or boundary evidence, not as dominance claim. |
| Step58 | 10007 | Default | Confidence-heuristic | 0.063 | StrongerBaselineGain | Small gain: use as graceful degradation or boundary evidence, not as dominance claim. |
| Step58 | 10007 | ForestGeometry | Confidence-heuristic | 0.120 | StrongerBaselineBoundary | Small gain: use as graceful degradation or boundary evidence, not as dominance claim. |
| Step58 | 10011 | Default | Confidence-heuristic | 0.123 | StrongerBaselineBoundary | Small gain: use as graceful degradation or boundary evidence, not as dominance claim. |
| Step58 | 10013 | Default | Confidence-heuristic | 0.000 | StrongerBaselineBoundary | Small gain: use as graceful degradation or boundary evidence, not as dominance claim. |
| Step58 | 10013 | ForestGeometry | Confidence-heuristic | -0.459 | StrongerBaselineBoundary | Small gain: use as graceful degradation or boundary evidence, not as dominance claim. |
| Step58 | 10014 | Default | Confidence-heuristic | 0.343 | StrongerBaselineGain | Small gain: use as graceful degradation or boundary evidence, not as dominance claim. |
| Step58 | 10015 | Default | Confidence-heuristic | 0.017 | StrongerBaselineGain | Small gain: use as graceful degradation or boundary evidence, not as dominance claim. |
| Step58 | 10017 | Default | Confidence-heuristic | 0.173 | StrongerBaselineGain | Small gain: use as graceful degradation or boundary evidence, not as dominance claim. |
| Step58 | 10017 | ForestGeometry | Confidence-heuristic | 0.619 | StrongerBaselineBoundary | Small gain: use as graceful degradation or boundary evidence, not as dominance claim. |
| Step58 | 10019 | Default | Confidence-heuristic | 0.000 | StrongerBaselineBoundary | Small gain: use as graceful degradation or boundary evidence, not as dominance claim. |
| Step58 | 10019 | ForestGeometry | Confidence-heuristic | -0.672 | StrongerBaselineBoundary | Small gain: use as graceful degradation or boundary evidence, not as dominance claim. |
| Step60 | 10014 | ModerateForestGeometry | Confidence-heuristic | 0.745 | StrongerBaselineGain | Moderate forest small gain: acceptable only with explicit applicability boundary. |
| Step60 | 10006 | ModerateForestGeometry | Confidence-heuristic | 0.087 | StrongerBaselineGain | Moderate forest small gain: acceptable only with explicit applicability boundary. |
| Step60 | 10011 | ModerateForestGeometry | Confidence-heuristic | 0.379 | StrongerBaselineGain | Moderate forest small gain: acceptable only with explicit applicability boundary. |
| Step60 | 10019 | ModerateForestGeometry | Confidence-heuristic | 0.120 | StrongerBaselineBoundary | Moderate forest small gain: acceptable only with explicit applicability boundary. |
| Step60 | 10017 | ModerateForestGeometry | Confidence-heuristic | 1.238 | StrongerBaselineGain | Moderate forest small gain: acceptable only with explicit applicability boundary. |
| Step60 | 10013 | ModerateForestGeometry | Confidence-heuristic | -0.133 | StrongerBaselineGain | Moderate forest small gain: acceptable only with explicit applicability boundary. |
| Step60 | 10007 | ModerateForestGeometry | Confidence-heuristic | 0.356 | StrongerBaselineBoundary | Moderate forest small gain: acceptable only with explicit applicability boundary. |
| Step60 | 10015 | ModerateForestGeometry | Confidence-heuristic | 0.319 | StrongerBaselineBoundary | Moderate forest small gain: acceptable only with explicit applicability boundary. |

## 6. 论文写作约束

1. `EffectiveRegime` 可作为主结果讨论，但不得推广为所有林区场景支配。
2. `GracefulDegradation` 应写为高基线天花板、低风险开放道路或弱 cost-gain 区间中的平稳退化。
3. `FailureBoundary` 必须保留，尤其是原 `10019/10013 ForestGeometry` 负例和 Step60 中的物理 emergency headroom 边界。
4. `ModerateForestGeometry` 是补充可部署场景；原 `ForestGeometry` 仍是 extreme stress / boundary case。
