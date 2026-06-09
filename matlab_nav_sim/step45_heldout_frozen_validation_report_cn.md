# Step45 冻结参数 Held-out 泛化验证报告

## 1. 验证目的

本轮实验用于回答一个明确审稿问题：

```text
当前 Risk-constrained-v6 是否只是调到了 Step40 的 5 个场景上？
```

因此 Step45 不再调参，不修改主方法，不修改参数文件，只在未参与 Step40 主实验矩阵的 V2X-Seq 场景上直接测试。

当前验证逻辑是：

```text
冻结 Step40 主方法参数
选择未参与调参的新场景
直接运行 50 seeds
观察是否仍然保持正收益或至少不恶化
```

这不是新的调参循环，而是 out-of-sample held-out validation。

## 2. 实验文件

新增脚本：

```text
get_heldout_scene_matrix.m
main_step45_heldout_frozen_validation.m
launch_step45_after_idle.ps1
```

正式结果前缀：

```text
step45_heldout_frozen_validation_50seed
```

关键输出：

```text
step45_heldout_frozen_validation_50seed_raw.csv
step45_heldout_frozen_validation_50seed_summary.csv
step45_heldout_frozen_validation_50seed_decision_table.csv
step45_heldout_frozen_validation_50seed_heuristic_vs_v6_significance.csv
step45_heldout_frozen_validation_50seed_link_vs_v6_significance.csv
step45_heldout_frozen_validation_50seed_v4_vs_v6_significance.csv
step45_heldout_frozen_validation_50seed_report.md
```

正式运行规模：

```text
3 held-out scenes × 2 configs × 50 seeds = 300 seeds
```

## 3. Held-out 场景选择

Step40 已使用场景：

```text
10014, 10006, 10011, 10019, 10017
```

Step45 使用的新场景：

| Scene | Role | Geometry | Density | Vegetation | 选择理由 |
|---|---|---|---|---|---|
| 10013 | HeldOutHighNLOS | ShortHighNLOS | High | Dense | 高 NLOS、短距离、强遮挡候选 |
| 10007 | HeldOutLongMixed | LongMixed | Medium | Mixed | 长距离混合几何候选 |
| 10015 | HeldOutBoundary | LongLowNLOS | Low | Sparse | 低 NLOS、长距离边界候选 |

这些场景没有进入 Step40 主实验矩阵，因此适合作为冻结参数泛化验证。

## 4. 决策表结果

| Scene | Config | Timely Gain vs Heuristic | Emergency Gap vs Heuristic | Cost Delta vs Heuristic | Delay Delta vs Heuristic | Timely Gain vs Link | Decision |
|---|---|---:|---:|---:|---:|---:|---|
| 10013 | Default | 0.000 pp | 0.000 pp | +2.54% | 0.00% | +0.003 pp | GeneralizesWeak |
| 10013 | ForestGeometry | +0.166 pp | +0.154 pp | +3.77% | +0.18% | +0.566 pp | GeneralizesWeak |
| 10007 | Default | +0.153 pp | 0.000 pp | +3.54% | -6.95% | +4.113 pp | GeneralizesWeak |
| 10007 | ForestGeometry | +0.047 pp | 0.000 pp | +7.28% | -1.65% | +4.965 pp | GeneralizesWeak |
| 10015 | Default | +0.103 pp | 0.000 pp | -2.06% | -5.23% | +1.574 pp | GeneralizesWeak |
| 10015 | ForestGeometry | +3.255 pp | +0.308 pp | +12.39% | -21.92% | +22.632 pp | GeneralizesStrong |

结论：

```text
6/6 held-out scene-config rows are non-negative transfer.
1/6 is strong generalization.
5/6 are weak generalization.
0/6 are HeldoutRisk.
```

## 5. 统计显著性结果

### 5.1 对 Confidence-heuristic

显著性统计：

```text
TimelyRate: 2 / 6 rows pass Holm correction
LossRate: 3 / 6 rows pass Holm correction
AvgDelay: 5 / 6 rows pass Holm correction
AvgTxCost: 6 / 6 rows pass Holm correction
EmgTimely: 0 / 6 rows pass Holm correction
```

关键 TimelyRate：

| Scene | Config | Timely Gain | 95% CI | Holm | 解释 |
|---|---|---:|---:|---|---|
| 10013 | Default | 0.000 pp | [0.000, 0.000] | n.s. | 饱和/无提升空间 |
| 10013 | ForestGeometry | +0.166 pp | [0.048, 0.285] | n.s. | 弱正收益 |
| 10007 | Default | +0.153 pp | [0.096, 0.210] | p = 0.03726 | 弱正收益 |
| 10007 | ForestGeometry | +0.047 pp | [0.004, 0.089] | n.s. | 极弱正收益 |
| 10015 | Default | +0.103 pp | [0.046, 0.160] | n.s. | 弱正收益 |
| 10015 | ForestGeometry | +3.255 pp | [3.147, 3.362] | p < 1e-15 | 强泛化 |

解释：

对 heuristic 的结果不是“全面大幅提升”，而是“没有出现负迁移，且在 10015 ForestGeometry 中出现强 out-of-sample 提升”。

### 5.2 对 Link-delay-aware

显著性统计：

```text
TimelyRate: 5 / 6 rows pass Holm correction
LossRate: 5 / 6 rows pass Holm correction
AvgDelay: 6 / 6 rows pass Holm correction
AvgTxCost: 6 / 6 rows pass Holm correction
EmgTimely: 1 / 6 rows pass Holm correction
```

解释：

相对于 Link-delay-aware，held-out 结果更强。尤其：

```text
10007 Default: +4.113 pp
10007 ForestGeometry: +4.965 pp
10015 ForestGeometry: +22.632 pp
```

这说明在未见过场景中，仅使用链路/时延感知仍不足，风险约束与定位/遮挡相关信息仍有价值。

### 5.3 对 V4Cost0060

对 V4 的普通 TimelyRate 差异多数不显著，主要作用仍是消融：

```text
AvgTxCost: 6 / 6 rows pass Holm correction
TimelyRate: 1 / 6 rows pass Holm correction
EmgTimely: 1 / 6 rows pass Holm correction
```

其中 `10015 ForestGeometry` 的 EmergencyTimely 相对 V4 提升：

```text
+0.923 pp
```

这说明 V6 的 emergency floor 在部分 held-out 场景中仍然有效，但不能宣称所有场景都显著改善 emergency delivery。

## 6. 对过拟合问题的判断

Step45 之后，对“是否过拟合”的判断应更新为：

```text
不存在明显的严重过拟合证据，但仍存在场景依赖性和弱泛化风险。
```

支持“不严重过拟合”的证据：

1. 新场景没有参与 Step40 调参。
2. 参数冻结后，6/6 个 held-out scene-config 没有出现负迁移。
3. `10015 ForestGeometry` 出现强泛化收益：TimelyRate 相对 heuristic +3.255 pp，相对 Link-delay-aware +22.632 pp。
4. 对 Link-delay-aware 的 TimelyRate 在 5/6 个 held-out rows 中通过 Holm 校正。

仍需保留的风险：

1. 对 heuristic 的 TimelyRate 只有 2/6 个 held-out rows 显著，说明相对强 heuristic 的泛化提升并不全面。
2. 多数 held-out 场景只是弱正收益，不能写成全面强泛化。
3. 成本在 ForestGeometry 场景仍会上升，例如 `10015 ForestGeometry` 成本增加 +12.39%。
4. 所有 held-out 场景仍来自同一 V2X-Seq 模板转换与同一仿真器，不等于真实林区实测泛化。

## 7. 论文中建议写法

英文建议：

```text
To assess overfitting risk, all parameters of the proposed scheduler were frozen after the main validation and evaluated on three held-out V2X-Seq scenes that were not used in parameter selection. The frozen method shows non-negative transfer in all six held-out scene-configuration cases, with one strong forest-geometry case achieving +3.255 pp TimelyRate over the confidence heuristic and +22.632 pp over the link-delay-aware baseline. This result suggests that the method is not merely tuned to the main five-scene matrix, although its gains remain scenario-dependent.
```

中文建议：

```text
为评估场景调参过拟合风险，本文在主实验完成后冻结所提方法全部参数，并选取 3 个未参与参数选择的 V2X-Seq 场景进行 held-out 验证。结果表明，冻结参数方法在 6 个 held-out scene-config 中均未出现负迁移，其中 10015 ForestGeometry 场景相对置信度启发式方法提升 3.255 个百分点，相对 Link-delay-aware 基线提升 22.632 个百分点。该结果说明所提方法并非仅对主实验的 5 个场景有效，但其收益仍具有场景依赖性。
```

## 8. 当前最稳结论

Step45 后，论文可以更有底气地写：

```text
The proposed method is evaluated on both the main multi-scene matrix and held-out scenes under frozen parameters.
```

但不能写：

```text
The proposed method generalizes strongly to all unseen scenes.
```

最稳判断：

```text
Step45 已显著降低“场景调参过拟合”的审稿风险，但没有完全消除真实性与跨数据集泛化风险。
```

## 9. 下一步建议

如果继续补强，优先级如下：

1. 把 Step45 的 held-out 结果加入论文实验设计，作为 overfitting-risk check。
2. 画一张 Step40 主场景 vs Step45 held-out 场景的 TimelyRate gain 对比图。
3. 在论文 Discussion 中明确：held-out 结果多数是 weak generalization，强收益集中在 ForestGeometry 高退化场景。
4. 不建议继续为 held-out 结果调参，否则会破坏“冻结参数验证”的意义。
