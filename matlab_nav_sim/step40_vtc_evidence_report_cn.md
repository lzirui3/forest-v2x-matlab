# Step40 VTC 级 50-seed 证据链报告

## 1. 本轮实验目的

本轮实验用于验证当前主方法 `Risk-constrained-v6` 是否可以作为论文主方法，而不是只作为启发式规则的局部改动。

当前主方法的论文定位应表述为：

```text
actual-cost-aware risk-constrained emergency-safe V2X scheduling
```

也就是：面向林区/准林区道路环境，将预警消息调度建模为有限动作空间下的风险约束在线决策问题，在及时投递、链路可靠性、通信代价与应急消息保护之间进行权衡。

本轮实验不宣称全局最优，也不宣称在所有场景下都有大幅提升。更合理的结论是：

```text
该方法在存在明显林区几何退化、遮挡、长距离链路或定位/通信风险重叠的场景中具有稳定收益；在低风险或性能饱和场景中表现为不恶化或弱收益。
```

## 2. 实验配置

实验脚本：

```text
main_step40_proposed_method_vtc_resume.m
```

结果前缀：

```text
step40_proposed_method_vtc_50seed
```

实验规模：

```text
5 scenes × 2 configs × 50 seeds = 500 seeds
```

场景集合：

| Scene | Role | Geometry | Density | Vegetation |
|---|---|---|---|---|
| 10014 | Primary | CurvedBlind | Medium | Dense |
| 10006 | Reference | Mixed | Medium | Mixed |
| 10011 | Boundary | Open | Low | Sparse |
| 10019 | DenseBlind | ShortRangeOccluded | High | Dense |
| 10017 | LongRange | LongMixed | Medium | Mixed |

配置集合：

| Config | 含义 |
|---|---|
| Default | 默认/准林区参数配置 |
| ForestGeometry | 引入林区几何、遮挡和退化驱动的配置 |

对比方法：

| Method | 角色 |
|---|---|
| Link-delay-aware | 强链路与时延感知基线 |
| Confidence-heuristic | 早期置信度启发式方法 |
| V4Cost0060 | 成本权重消融版本 |
| Risk-constrained-v6 | 当前主方法 |
| Constrained Oracle | 受约束上界参考，不作为现实可部署方法 |

## 3. 代码与实验完整性

本轮 10 个 scene-config checkpoint 均已完成：

```text
10014 Default: 50/50
10014 ForestGeometry: 50/50
10006 Default: 50/50
10006 ForestGeometry: 50/50
10011 Default: 50/50
10011 ForestGeometry: 50/50
10019 Default: 50/50
10019 ForestGeometry: 50/50
10017 Default: 50/50
10017 ForestGeometry: 50/50
```

最终输出文件：

```text
step40_proposed_method_vtc_50seed_raw.csv
step40_proposed_method_vtc_50seed_summary.csv
step40_proposed_method_vtc_50seed_decision_table.csv
step40_proposed_method_vtc_50seed_heuristic_vs_v6_significance.csv
step40_proposed_method_vtc_50seed_link_vs_v6_significance.csv
step40_proposed_method_vtc_50seed_v4_vs_v6_significance.csv
step40_proposed_method_vtc_50seed_report.md
```

三份显著性文件均为 50 行，且未发现空单元格。显著性分析包含均值、标准差、置信区间、Wilcoxon 检验、Holm 多重比较校正、rank-biserial effect size 与 Cohen's dz。

## 4. 决策表核心结果

| Scene | Config | Timely Gain vs Heuristic | Emergency Gap vs Heuristic | Cost Delta vs Heuristic | Delay Delta vs Heuristic | Timely Gain vs Link | Decision |
|---|---|---:|---:|---:|---:|---:|---|
| 10014 | Default | +1.601 pp | 0.000 pp | -1.86% | -31.26% | +1.890 pp | MainCandidate |
| 10014 | ForestGeometry | +1.674 pp | +0.333 pp | +9.31% | -10.00% | +5.111 pp | MainCandidate |
| 10006 | Default | +0.489 pp | 0.000 pp | +3.55% | -15.23% | +4.090 pp | MainCandidate |
| 10006 | ForestGeometry | +0.349 pp | -0.007 pp | +9.70% | -2.22% | +1.887 pp | MainCandidate |
| 10011 | Default | 0.000 pp | 0.000 pp | -3.98% | 0.00% | +0.013 pp | MainCandidate |
| 10011 | ForestGeometry | +3.724 pp | 0.000 pp | +9.09% | -11.02% | +12.652 pp | MainCandidate |
| 10019 | Default | 0.000 pp | 0.000 pp | +2.16% | 0.00% | 0.000 pp | MainCandidate |
| 10019 | ForestGeometry | +0.053 pp | +0.059 pp | -0.44% | +0.06% | +0.133 pp | MainCandidate |
| 10017 | Default | +0.992 pp | 0.000 pp | -2.82% | -16.68% | +5.887 pp | MainCandidate |
| 10017 | ForestGeometry | +0.619 pp | 0.000 pp | +12.12% | -1.73% | +0.908 pp | MainCandidate |

整体看，10 个 scene-config 行均被判为 `MainCandidate`，但强度并不相同。应将结果分为强证据、普通证据和边界证据三类，而不是统一称为显著优越。

## 5. 强证据场景

### 5.1 10011 ForestGeometry

这是本轮最强的林区几何退化场景之一。

关键结果：

```text
TimelyRate vs Confidence-heuristic: +3.724 pp
TimelyRate vs Link-delay-aware: +12.652 pp
AvgDelay vs Confidence-heuristic: -11.02%
Cost vs Confidence-heuristic: +9.09%
```

解释：

该场景说明主方法在 ForestGeometry 退化条件下能够用可接受的通信代价换取明显的及时投递收益。相比 Link-delay-aware，收益非常明显，说明仅考虑链路和时延不足以处理定位可信度、盲区风险和应急约束耦合的问题。

注意：

`Constrained Oracle` 在该场景的 TimelyRate 低于 V6，说明当前 Oracle 定义更偏向受约束参考策略，而不是无条件性能上界。论文中应避免把它称为绝对最优上界，应使用 `Constrained Oracle Reference` 或 `Constrained Oracle`。

### 5.2 10014 ForestGeometry

关键结果：

```text
TimelyRate vs Confidence-heuristic: +1.674 pp
TimelyRate vs Link-delay-aware: +5.111 pp
AvgDelay vs Confidence-heuristic: -10.00%
Cost vs Confidence-heuristic: +9.31%
EmergencyTimely vs Confidence-heuristic: +0.333 pp
```

解释：

该场景是典型弯道/盲区林路。主方法在及时投递和时延上都有稳定收益，代价是约 9% 的通信成本增加。这个结果适合支撑“风险约束调度在弯道遮挡环境中有效”。

### 5.3 10017 Default

关键结果：

```text
TimelyRate vs Confidence-heuristic: +0.992 pp
TimelyRate vs Link-delay-aware: +5.887 pp
AvgDelay vs Confidence-heuristic: -16.68%
Cost vs Confidence-heuristic: -2.82%
EmergencyTimely vs Link-delay-aware: +1.111 pp
```

解释：

该场景很适合作为“长距离混合链路”证据。主方法不仅提升及时率，还降低了平均时延和相对 heuristic 的成本，说明方法不是单纯通过增加发送代价换性能。

### 5.4 10014 Default

关键结果：

```text
TimelyRate vs Confidence-heuristic: +1.601 pp
TimelyRate vs Link-delay-aware: +1.890 pp
AvgDelay vs Confidence-heuristic: -31.26%
Cost vs Confidence-heuristic: -1.86%
```

解释：

这是成本和性能同时改善的强场景。论文中可作为主方法优于早期 heuristic 的代表结果。

## 6. 普通证据场景

### 6.1 10006 Default

关键结果：

```text
TimelyRate vs Confidence-heuristic: +0.489 pp
TimelyRate vs Link-delay-aware: +4.090 pp
AvgDelay vs Confidence-heuristic: -15.23%
Cost vs Confidence-heuristic: +3.55%
```

解释：

对 heuristic 的及时率提升低于 1 pp，但时延改善明显；对 Link-delay-aware 的及时率提升较强。论文中不宜只强调对 heuristic 的 TimelyRate，而应强调“及时率、时延和链路基线对比的综合收益”。

### 6.2 10006 ForestGeometry

关键结果：

```text
TimelyRate vs Confidence-heuristic: +0.349 pp
TimelyRate vs Link-delay-aware: +1.887 pp
AvgDelay vs Confidence-heuristic: -2.22%
Cost vs Confidence-heuristic: +9.70%
```

解释：

该场景收益存在，但代价也明显。更适合用于说明方法在中等混合林区环境中仍保持正收益，而不是作为强性能场景。

### 6.3 10017 ForestGeometry

关键结果：

```text
TimelyRate vs Confidence-heuristic: +0.619 pp
TimelyRate vs Link-delay-aware: +0.908 pp
AvgDelay vs Confidence-heuristic: -1.73%
Cost vs Confidence-heuristic: +12.12%
```

解释：

这是需要谨慎表述的场景。主方法提升及时率，但成本上升较高，且相对 Link-delay-aware 的提升不足 1 pp。论文中应将它作为“复杂林区几何下仍保持正收益但成本敏感”的场景，用于引出代价-性能权衡。

## 7. 边界与弱收益场景

### 7.1 10011 Default

关键结果：

```text
TimelyRate vs Confidence-heuristic: 0.000 pp
Cost vs Confidence-heuristic: -3.98%
Delay change: 0.00%
```

解释：

该场景属于开阔、低密度、稀疏植被的边界场景，基线已经接近饱和，主方法没有及时率提升空间。它的价值不是证明性能提升，而是证明主方法在低风险场景下不会恶化性能，并可略微降低成本。

论文写法：

```text
In low-risk open-road cases, the proposed method gracefully degenerates to conservative low-cost decisions without sacrificing timely delivery.
```

### 7.2 10019 Default

关键结果：

```text
TimelyRate vs Confidence-heuristic: 0.000 pp
TimelyRate vs Link-delay-aware: 0.000 pp
Cost vs Confidence-heuristic: +2.16%
```

解释：

该场景性能已经饱和，所有主要方法的 TimelyRate 接近 1。它不能作为主方法优势场景。该结果应作为“饱和条件下收益受限”的边界情况讨论。

### 7.3 10019 ForestGeometry

关键结果：

```text
TimelyRate vs Confidence-heuristic: +0.053 pp
TimelyRate vs Link-delay-aware: +0.133 pp
EmergencyTimely vs V4Cost0060: +0.407 pp
Cost vs Confidence-heuristic: -0.44%
```

解释：

该场景的及时率提升很弱，且对 heuristic 和 Link-delay-aware 的 TimelyRate 提升不显著。它更适合作为“弱收益/不恶化”场景。唯一较有价值的是，相比 V4Cost0060，EmergencyTimely 有一定提升。

论文中不能将该场景包装为强优势，只能说主方法在短距离高遮挡场景下收益有限，但没有造成明显性能退化。

## 8. 统计显著性结论

### 8.1 对 Confidence-heuristic

显著性统计：

```text
30 / 50 metric rows pass family-wise Holm correction
TimelyRate: 7 / 10 scene-config rows significant
LossRate: 7 / 10 scene-config rows significant
AvgDelay: 7 / 10 scene-config rows significant
AvgTxCost: 9 / 10 scene-config rows significant
EmgTimely: 0 / 10 scene-config rows significant
```

关键 TimelyRate 结果：

| Scene | Config | Timely Gain | 95% CI | Holm | Effect Size |
|---|---|---:|---:|---|---:|
| 10014 | Default | +1.601 pp | [1.532, 1.669] | p < 1e-15 | 1.000 |
| 10014 | ForestGeometry | +1.674 pp | [1.564, 1.784] | p < 1e-15 | 1.000 |
| 10006 | Default | +0.489 pp | [0.418, 0.561] | p = 1.599e-13 | 0.884 |
| 10006 | ForestGeometry | +0.349 pp | [0.292, 0.407] | p = 7.094e-11 | 0.885 |
| 10011 | Default | 0.000 pp | [0.000, 0.000] | n.s. | 0.000 |
| 10011 | ForestGeometry | +3.724 pp | [3.589, 3.859] | p < 1e-15 | 1.000 |
| 10019 | Default | 0.000 pp | [0.000, 0.000] | n.s. | 0.000 |
| 10019 | ForestGeometry | +0.053 pp | [-0.055, 0.161] | n.s. | 0.076 |
| 10017 | Default | +0.992 pp | [0.904, 1.080] | p < 1e-15 | 0.995 |
| 10017 | ForestGeometry | +0.619 pp | [0.573, 0.665] | p < 1e-15 | 1.000 |

解释：

主方法相对 early heuristic 的提升是存在的，但并非所有场景都强。`10011 Default` 和 `10019 Default` 是饱和/低风险场景，`10019 ForestGeometry` 是弱收益场景。

### 8.2 对 Link-delay-aware

显著性统计：

```text
35 / 50 metric rows pass family-wise Holm correction
TimelyRate: 7 / 10 scene-config rows significant
LossRate: 8 / 10 scene-config rows significant
AvgDelay: 8 / 10 scene-config rows significant
AvgTxCost: 10 / 10 scene-config rows significant
EmgTimely: 2 / 10 scene-config rows significant
```

关键 TimelyRate 结果：

| Scene | Config | Timely Gain | 95% CI | Holm | Effect Size |
|---|---|---:|---:|---|---:|
| 10014 | Default | +1.890 pp | [1.826, 1.955] | p < 1e-15 | 1.000 |
| 10014 | ForestGeometry | +5.111 pp | [4.971, 5.252] | p < 1e-15 | 1.000 |
| 10006 | Default | +4.090 pp | [3.973, 4.207] | p < 1e-15 | 1.000 |
| 10006 | ForestGeometry | +1.887 pp | [1.792, 1.982] | p < 1e-15 | 1.000 |
| 10011 | Default | +0.013 pp | [0.006, 0.021] | n.s. | 1.000 |
| 10011 | ForestGeometry | +12.652 pp | [12.414, 12.890] | p < 1e-15 | 1.000 |
| 10019 | Default | 0.000 pp | [0.000, 0.000] | n.s. | 0.000 |
| 10019 | ForestGeometry | +0.133 pp | [0.067, 0.199] | n.s. | 0.377 |
| 10017 | Default | +5.887 pp | [5.752, 6.022] | p < 1e-15 | 1.000 |
| 10017 | ForestGeometry | +0.908 pp | [0.841, 0.976] | p < 1e-15 | 1.000 |

解释：

相比 Link-delay-aware，主方法的优势更清晰，尤其在 `10014 ForestGeometry`、`10011 ForestGeometry`、`10017 Default` 等场景。这支撑了论文中的一个核心论点：只考虑链路和时延是不够的，定位可信度、盲区风险和应急保护约束需要进入调度决策。

### 8.3 对 V4Cost0060

对 V4Cost0060 的比较不应作为主性能提升论据，而应作为机制消融。

关键结论：

```text
AvgTxCost: 10 / 10 rows significant
EmergencyTimely: 4 / 10 rows significant or marginally useful
TimelyRate: 多数场景差异低于 1 pp
```

较有价值的 EmergencyTimely 结果：

| Scene | Config | EmergencyTimely Gain vs V4 | 95% CI | Holm |
|---|---|---:|---:|---|
| 10006 | Default | +0.164 pp | [0.127, 0.202] | p = 1.952e-05 |
| 10011 | ForestGeometry | +1.100 pp | [0.762, 1.438] | p = 0.005231 |
| 10019 | ForestGeometry | +0.407 pp | [0.353, 0.460] | p < 1e-15 |
| 10017 | Default | +1.111 pp | [0.825, 1.397] | p = 2.771e-04 |

解释：

V4Cost0060 与 V6 的差异主要体现为 emergency action floor 和风险约束细化，而不是普通 TimelyRate 的大幅提升。论文中应将这部分写成“应急消息保护机制消融”，而不是把 V6 相对 V4 的普通及时率作为主贡献。

## 9. 成本-收益解释

主方法并不是无代价提升。部分 ForestGeometry 场景成本上升明显：

```text
10014 ForestGeometry: +9.31%
10006 ForestGeometry: +9.70%
10011 ForestGeometry: +9.09%
10017 ForestGeometry: +12.12%
```

这说明方法本质是风险约束调度：在高风险场景中主动增加通信资源使用，以换取及时投递率和时延表现。

论文中应避免写成：

```text
The proposed method improves performance with negligible cost.
```

更严谨的写法是：

```text
The proposed method improves timely delivery under risk-degraded forest geometry at the cost of additional transmissions. The cost increase is explicitly controlled by the actual-cost-aware penalty and remains interpretable as a risk-performance tradeoff.
```

同时，部分 Default 场景成本没有上升，甚至下降：

```text
10014 Default: -1.86%
10011 Default: -3.98%
10017 Default: -2.82%
```

这可以说明在风险较低或默认配置下，主方法不会必然导致过度通信。

## 10. 当前可以支撑的论文贡献

基于 Step40 结果，当前可以写成以下贡献：

1. 提出一种实际通信代价感知的风险约束 V2X 预警消息调度方法，将定位可信度、链路可靠性、盲区风险和应急消息保护纳入统一有限动作优化框架。
2. 将早期启发式 confidence-driven 规则升级为可解释的 constrained utility decision，避免仅依赖人工优先级覆盖。
3. 引入 emergency action floor，使普通及时率优化不会牺牲应急消息的最低保护需求。
4. 在 5 类道路几何、2 类参数配置、50 seeds 的实验矩阵中验证方法，并使用 Holm 多重比较校正和 effect size 报告统计证据。
5. 结果显示方法在林区几何退化、弯道盲区、长距离混合链路等场景中具有稳定收益；在低风险或饱和场景中表现为 graceful degradation。

## 11. 当前不能过度宣称的内容

以下表述不建议出现在论文中：

```text
The proposed method is globally optimal.
```

原因：当前方法是在线有限动作风险约束优化，不是全局最优控制或全局最优调度。

```text
The proposed method significantly outperforms all baselines in all scenarios.
```

原因：`10011 Default`、`10019 Default`、`10019 ForestGeometry` 并没有强提升。

```text
The communication cost is negligible.
```

原因：多个 ForestGeometry 场景成本增加约 9% 到 12%。

```text
Constrained Oracle is a strict upper bound.
```

原因：至少 `10011 ForestGeometry` 和 `10019 ForestGeometry` 中 V6 TimelyRate 高于 Constrained Oracle，说明当前 Oracle 是受约束参考策略，不是绝对上界。

## 12. 面向 VTC 的审稿风险

### 12.1 方法强度风险

Step40 已经支持主方法作为 `risk-constrained scheduling`，但论文中必须给出清楚的优化问题定义：

```text
max_a P_timely(a) - lambda_c C(a) - lambda_r R(a) - lambda_d D(a)
s.t. P_success(a) >= P_min
     D(a) <= D_max
     emergency floor condition
```

否则审稿人仍可能认为这是规则拼接。

### 12.2 场景真实性风险

ForestGeometry 提升了场景说服力，但仍要说明：

```text
geometry-driven blockage and degradation model
```

具体来自哪些道路几何、遮挡 profile、植被/林区退化映射。如果论文写作中只说“林区参数”，说服力仍然不足。

### 12.3 物理层验证风险

当前已有 PER 曲线和自建物理层校准，但如果目标提升到更高层级，仍建议补充：

```text
WiLabV2Xsim PER lookup vs sigmoid approximation sensitivity
```

对于 VTC，离线 PER 表交叉验证通常比完整嵌入 WiLabV2Xsim 更现实。

### 12.4 适用范围风险

必须明确方法适用条件：

```text
NLOS/遮挡比例较高
定位可信度下降与应急消息时间窗存在重叠
链路质量、时延和风险并非同时饱和
通信代价预算允许约 5% 到 12% 的额外开销
```

不满足这些条件时，方法主要表现为不恶化或弱收益。

## 13. 建议论文结果写法

可以作为论文主结论的表述：

```text
Across five scene types and two configurations with 50 random seeds, the proposed risk-constrained scheduler improves TimelyRate over the confidence heuristic in 7 out of 10 scene-config cases after family-wise Holm correction. The strongest gains appear in forest-geometry degraded cases, e.g., +3.724 pp over the confidence heuristic and +12.652 pp over the link-delay-aware baseline in Scene 10011 ForestGeometry. The method also reduces average delay in 7 out of 10 cases compared with the confidence heuristic, while the additional transmission cost remains interpretable as a risk-performance tradeoff.
```

中文对应：

```text
在 5 类场景、2 类配置、50 个随机种子的实验矩阵下，所提风险约束调度方法在 7/10 个 scene-config 中相对于置信度启发式方法取得了通过 family-wise Holm 校正的 TimelyRate 提升。最明显的收益出现在林区几何退化场景，例如在 Scene 10011 ForestGeometry 中，相对置信度启发式方法提升 3.724 个百分点，相对 Link-delay-aware 基线提升 12.652 个百分点。同时，该方法在 7/10 个 scene-config 中降低了平均时延，但在部分 ForestGeometry 场景中需要约 9% 到 12% 的额外通信代价，体现出明确的风险-性能权衡。
```

## 14. 下一步建议

最优先补的不是继续扩大 seed，而是把证据链转成论文材料：

1. 写 `Method` 小节：风险约束目标函数、动作空间、约束、emergency floor、actual-cost penalty。
2. 写 `Experimental Setup` 小节：5 scenes、2 configs、50 seeds、对比方法、指标、Holm 校正。
3. 写 `Results` 小节：主表、强场景、弱场景、成本-收益讨论。
4. 补一张 cost-efficiency 或 Pareto 图，突出 ForestGeometry 下的收益与代价。
5. 补一段 applicability analysis，明确低风险/饱和场景下为什么无明显提升。

## 15. 总结判断

从 MATLAB 项目层面看，Step40 已经把主方法推进到 VTC 投稿前实验主线的可用状态：

```text
可作为主方法，但必须按“风险约束在线调度 + 成本收益权衡 + 适用范围分析”来写。
```

当前证据足以支持一篇偏仿真、方法与实验结合的 VTC 级论文初稿，但还不宜按 IEEE 期刊强理论稿的标准过度包装。最稳妥的路线是将贡献定位为工程上可部署、统计上充分验证、场景上面向林区退化的风险约束 V2X 预警消息调度方法。
