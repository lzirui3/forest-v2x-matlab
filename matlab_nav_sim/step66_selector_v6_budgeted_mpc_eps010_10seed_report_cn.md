# Step66 Selector-V6-BudgetedMPC 副本检验报告

本步骤为适用性选择器副本检验，不替换 Risk-constrained-v6 主线。

## 运行规模

- Seeds: 10
- Config: ModerateForestGeometry

## 判定结果

- Scene 10014: SelectorPromising, TimelyGainVsV6=0.116 pp, EmgGainVsV6=0.000 pp, CostDeltaVsV6=0.069, FallbackRate=1.16%
- Scene 10006: SelectorNeutral, TimelyGainVsV6=0.083 pp, EmgGainVsV6=-0.033 pp, CostDeltaVsV6=-0.049, FallbackRate=11.31%
- Scene 10011: SelectorPromising, TimelyGainVsV6=0.300 pp, EmgGainVsV6=0.000 pp, CostDeltaVsV6=-0.011, FallbackRate=0.15%
- Scene 10019: SelectorNeutral, TimelyGainVsV6=-0.100 pp, EmgGainVsV6=-0.110 pp, CostDeltaVsV6=-0.069, FallbackRate=85.19%
- Scene 10017: SelectorRisky, TimelyGainVsV6=0.566 pp, EmgGainVsV6=-0.278 pp, CostDeltaVsV6=0.531, FallbackRate=3.19%
- Scene 10013: SelectorPromising, TimelyGainVsV6=0.865 pp, EmgGainVsV6=0.073 pp, CostDeltaVsV6=-0.298, FallbackRate=22.66%
- Scene 10007: SelectorPromising, TimelyGainVsV6=0.100 pp, EmgGainVsV6=0.000 pp, CostDeltaVsV6=-0.001, FallbackRate=5.37%
- Scene 10015: SelectorNeutral, TimelyGainVsV6=-0.000 pp, EmgGainVsV6=0.000 pp, CostDeltaVsV6=-0.032, FallbackRate=0.03%

## 统计检验

V6 对比统计行数: 40
Budgeted-MPC 对比统计行数: 40
