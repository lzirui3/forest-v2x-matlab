# IEEE VTC 审稿意见：拒稿倾向，需大幅修改

**Paper ID**: [REDACTED]  
**Title**: Positioning-Confidence-Driven Adaptive Emergency Message Scheduling for V2X in Off-Grid Forest Scenarios  
**Reviewer**: VTC Technical Program Committee Member #3  
**Recommendation**: **REJECT** (可考虑 Major Revision 后重投)  
**Overall Score**: 3/10  
**Confidence**: High

---

## 审稿总结

作者试图解决林区 V2X 场景下的应急消息调度问题，提出了一个"定位可信度驱动"的自适应调度方法。虽然问题动机清晰，仿真框架完整，但本文存在**多处致命缺陷**，使其在当前状态下**不适合在 IEEE VTC 发表**。主要问题包括：

1. **核心方法是拼凑式启发规则，缺乏理论依据和优化目标**
2. **实验场景参数配置崩溃，关键指标降至 2%，无工程意义**
3. **所谓的"理论支撑"（Lyapunov 版本）性能更差，反而证伪了方法**
4. **50% 的测试场景提升不足 1%，统计显著但工程无意义**
5. **文献对比基线在简单场景下反超本方法**
6. **论文声称适用于"林区场景"但未明确边界条件**

本文更像是一个"能跑的原型"而非"经过充分验证的学术贡献"。作者需要在方法学、实验设计、结果分析三个维度上进行根本性重构。

---

## 主要问题（Major Issues）

### M1. 方法缺乏数学形式化——启发式权重完全是拍脑袋

**问题描述：**

作者在 `compute_action_utility.m` 和 `compute_regime_bias.m` 中使用了大量 magic numbers：

```matlab
utility = 1.00 * timely_prob + 0.55 * success_prob - 0.07 * tx_cost 
          - 0.10 * delay_penalty - 0.28 * risk_penalty - ...
          
regime_bias += 0.10  % 为什么是 0.10？
regime_bias += 0.06  % 为什么是 0.06？
regime_bias += 0.05  % 为什么是 0.05？
regime_bias += 0.08  % 为什么是 0.08？
```

**具体质疑：**

1. **权重从何而来？** 为什么 `utility_weight_timely = 1.00` 而 `utility_weight_cost = 0.07`？这个 14:1 的比例有任何理论或实验依据吗？
2. **regime_bias 的 0.06/0.05/0.08 是如何确定的？** 这些值是通过网格搜索得到的？还是作者随手写的？
3. **为什么不用优化框架？** 既然作者有 45 个候选动作，为什么不形式化为一个约束优化问题？

**作者的"理论支撑"不成立：**

作者在 Step 23 中声称提供了 Lyapunov drift-plus-penalty 框架作为理论支撑。但数据显示：

```
ForestParam:         Heuristic = 97.29%,  Lyapunov = 95.31%  (差 2%)
ForestGeometryDemo:  Heuristic = 84.44%,  Lyapunov = 81.63%  (差 2.8%)
```

**这说明什么？** 说明作者的"理论框架"推导出的决策在实际场景下更差。这只有两种可能：
- (a) Lyapunov 建模有问题（状态空间、约束、目标函数定义错误）
- (b) Heuristic 的 magic numbers 是通过某种隐式调优得到的，但作者没有透明化这个过程

无论哪种，都说明本文的方法学基础不扎实。

**VTC 要求：** 即使是启发式方法，也必须：
- 明确优化目标（显式写出目标函数）
- 给出参数选择的系统化方法（grid search / cross-validation / domain expertise）
- 或者提供理论分析（性能界、收敛性、最优性间隙）

本文三者都没有。

---

### M2. 实验场景配置崩溃——关键指标降至 2%，论文失去工程意义

**问题描述：**

在 ForestGeometry 配置下，Emergency Timely Rate 崩塌至接近零：

```
Scene 10014 / ForestGeometry:
  Link-delay-aware:   EmgTimely = 2.67%
  Confidence-driven:  EmgTimely = 2.00%
  Oracle:             EmgTimely = 2.00%
  
Scene 10017 / ForestGeometry:
  All methods:        EmgTimely = 2.00%
```

**这说明什么？**

1. **场景参数设置不合理。** 当 Oracle（知道所有未来信息的理想调度器）也只有 2% Emergency Timely 时，问题不在调度算法，而在场景本身物理不可解。
2. **作者的 ForestGeometry 参数配置过于极端。** Pathloss、interference、deadline 的组合让紧急消息在 deadline 内几乎不可能送达。
3. **这不是"林区场景"，这是"火星表面通信场景"。**

**VTC 审稿人会问：**

> "如果你的系统在最重要的林区场景下，紧急消息送达率只有 2%，那这个系统有什么实用价值？这篇论文在讨论一个纸面上存在但工程上不可能部署的系统。"

**作者需要做什么：**

1. **重新校准 ForestGeometry 参数。** 目标应该是 Oracle 达到 70-80% Emergency Timely，这样才有优化空间。
2. **或者明确承认 ForestGeometry 是"极端压力测试"，** 不代表实际部署条件，并在论文中降低其权重。

---

### M3. 50% 测试场景的提升不足 1 个百分点——统计显著但无工程意义

**问题描述：**

在 10 个测试配置中，5 个的 Timely Rate 提升 < 1%：

```
Scene 10014 / Default:        +0.29%
Scene 10011 / Default:        +0.01%
Scene 10019 / Default:        +0.00%
Scene 10019 / ForestGeometry: +0.17%
Scene 10017 / ForestGeometry: +0.31%
```

**VTC 审稿人会说：**

> "作者在 Abstract 中声称提出了'adaptive scheduling method'，但在一半的测试场景中，提升连 1 个百分点都不到。虽然 p < 0.001（统计显著），但 0.29% 的提升在工程上是噪声级别。这篇论文的实际贡献是什么？"

**更糟糕的是：** 作者没有在论文中明确说明方法的**适用边界**。读者无法从论文中得知：
- 在什么条件下方法有效（Delta > 3%）？
- 在什么条件下方法退化为基线（Delta < 1%）？
- 这些条件能否在部署前预判？

**正确的处理方式：**

论文应该分为三层展示：
1. **主阵地场景（Delta > 3%）：** 放在主结果表中，声称方法在这些条件下有效
2. **边界场景（Delta < 1%）：** 放在 Applicability Analysis 小节，明确说明方法在这些条件下"gracefully degrades to baseline"
3. **失效场景（如果有）：** 诚实报告方法在哪些条件下失效

当前论文把所有场景混在一起，给人一种"作者不清楚自己方法边界"的印象。

---

### M4. 文献对比基线反超本方法——DCC-like 在 Generic 下达到 99.97%

**问题描述：**

Step 25 的文献对比显示，在 Generic 配置下：

```
DCC-like:          Timely = 99.97%,  Cost = 4.42
Confidence-driven: Timely = 97.09%,  Cost = 1.90
```

DCC（一个标准的 ETSI 拥塞控制方法）的 Timely Rate **比作者的方法高 2.88%**。

**VTC 审稿人会问：**

> "如果一个 20 年前的标准方法（DCC）能在简单场景下达到接近 100% 的及时率，那作者提出复杂的'定位可信度驱动'方法的意义是什么？作者的回答是'DCC cost 更高'（4.42 vs 1.90），但这是在用 cost 为 timely 的劣势辩护——如果目标是 timely delivery，DCC 已经足够好了。"

**作者缺少的关键分析：**

1. **Pareto 前沿图：** 应该画 Timely Rate vs. Transmission Cost 的 scatter plot，证明 Confidence-driven 位于 Pareto 前沿上（最优 tradeoff），而 DCC 位于前沿之外（暴力发送）。
2. **Cost-Efficiency 指标：** 定义 Efficiency = Timely / Cost，证明 Confidence-driven 在 efficiency 上优于 DCC。
3. **场景分层讨论：** 承认 DCC 在简单场景下有效，但在复杂场景（ForestParam）下崩塌（86.5% vs 97.3%）。

**当前论文的问题：** 作者只报告了 DCC 在 Generic 下的反超，没有充分讨论为什么这不是问题。这给审稿人留下了"作者回避不利证据"的印象。

---

### M5. Lyapunov"理论支撑"性能更差——理论反而成了负面证据

**问题描述：**

作者在 Step 23 中试图用 Lyapunov drift-plus-penalty 框架为方法提供理论支撑，但数据显示理论版本在所有非 Generic 场景下**显著劣于**启发式版本：

```
Overall Timely:
  ForestParam:         Heuristic 97.29%  vs  Lyapunov 95.31%  (差 1.98%)
  ForestGeometryDemo:  Heuristic 84.44%  vs  Lyapunov 81.63%  (差 2.81%)

PosDeg_Emerg (关键阶段):
  ForestParam:         Heuristic 98.91%  vs  Lyapunov 97.73%  (差 1.18%)
  ForestGeometryDemo:  Heuristic 97.55%  vs  Lyapunov 93.36%  (差 4.19%)
```

**VTC 审稿人会说：**

> "作者声称 Lyapunov 框架提供了'theoretically grounded'版本，但实验证明理论版本性能更差。这只能说明两件事之一：(a) 作者的 Lyapunov 建模有误，或 (b) 启发式版本的 magic numbers 是通过某种隐式优化得到的，但作者没有说明。无论哪种，都说明本文缺乏理论深度。"

**Lyapunov 唯一的优势是 cost 更低：**

```
Generic:         Heuristic 1.90  vs  Lyapunov 1.82  (-4.5%)
ForestParam:     Heuristic 2.56  vs  Lyapunov 2.41  (-5.9%)
ForestGeometry:  Heuristic 2.20  vs  Lyapunov 1.80  (-18%)
```

但这个"优势"代价是 timely rate 下降 2-4%，这不是好的 tradeoff。

**正确的处理方式：**

作者应该：
1. **重新定位 Lyapunov：** 不再声称它是"等价的理论支撑"，而是"cost-优化变体"
2. **做 V-parameter sweep：** 展示 Lyapunov 的 V 参数如何控制 cost-timely tradeoff
3. **或者修复 Lyapunov 的建模：** 让理论版本至少与启发式版本性能可比

当前的处理（理论版本更差却不讨论）是不可接受的。

---

### M6. 关键阶段延迟反增——PosDeg_Emerg 延迟增加 12-62%

**问题描述：**

Confidence-driven 在最关键的 PosDeg_Emerg 阶段，平均延迟反而比 Link-delay-aware 更高：

```
Scene 10014 / Default:        +11.97%
Scene 10019 / Default:        +62.21%
Scene 10011 / ForestGeometry: +80.99%
```

**VTC 审稿人会问：**

> "作者声称要'improve timely delivery'，但在关键阶段延迟反而增加了 12-62%。虽然 timely rate 有提升，但更高的延迟意味着系统在 deadline 边缘运行，鲁棒性更差。作者有讨论这个 tradeoff 吗？"

**根因是显而易见的：**

方法在盲区阶段切换到 relay/redundant 模式，引入了 `mode_overhead_relay = 0.030s` 和多次重传的 `attempt_gap`。这些机制提高了 PDR 但也增加了延迟。

**问题在于：** 在 Scene 10019 Default，延迟增加 62% 但 timely rate 提升 0%——这是纯粹的负面效应，说明方法误触发了保护机制。

**作者需要：**

1. **加入 deadline-aware 约束：** 在预估延迟超过 deadline 的 80% 时，禁止切换到高 overhead 模式
2. **降低 mode_overhead 参数：** 当前 0.030s 可能偏高，应该基于实际 C-V2X 测量值
3. **在论文中明确讨论 delay-timely tradeoff**

---

## 次要问题（Minor Issues）

### m1. 参数标定的可追溯性不足

作者在 `get_forest_dataset_calibrated_params.m` 中声称使用了 USFS 道路数据、林下点云和 ForestPaths 栅格来标定参数，但实际只是检查文件是否存在，然后硬编码了一组值：

```matlab
params.pathloss_los_exponent = 21.0;  % 从何而来？
params.nlosv_extra_loss_dB = 6.0;     % 为什么是 6.0？
```

**VTC 要求：** 要么展示从原始数据到参数的拟合过程，要么引用文献来源。

### m2. 统计方法不规范

1. **缺少多重比较校正的讨论：** 虽然用了 Wilcoxon + Holm，但没有讨论为什么选择 Holm 而不是 Bonferroni 或 FDR
2. **p = 0 的报告不规范：** 应该写 `p < 1e-15` 而不是 `p = 0`
3. **缺少 effect size：** 只报告 p 值不报告 Cohen's d 或 rank-biserial correlation

### m3. 论文组织问题

1. **缺少系统架构图：** 读者无法快速理解系统各模块如何协同
2. **缺少算法伪代码：** `decide_schedule_action.m` 有 200+ 行，论文中需要提炼为伪代码
3. **缺少参数表：** 45 个关键参数散落在代码中，论文需要统一表格展示

### m4. 写作问题

1. **中英文混杂：** 代码注释中中英文混用，论文提交时需要统一
2. **Figure 质量：** 需要用 export_fig 或 print 生成高分辨率矢量图
3. **缺少 Discussion 章节：** 论文在 Results 之后直接跳到 Conclusion，缺少对结果的深入讨论

---

## 作者当前完成了什么（The Few Positives）

尽管存在上述问题，作者确实完成了一些有价值的工作：

### ✓ 仿真框架完整且可复现

- 5 个场景 × 2 个配置 × 50 个随机种子 = 500 次独立运行
- 统计检验规范（Wilcoxon + Holm + 95% CI）
- 代码组织清晰，可复现性强

### ✓ 实验维度充分

- 主方法对比（Step 9）
- 消融实验（Step 10）
- 敏感性分析（Step 11）
- 多种子统计（Step 12）
- 场景扩展（Step 13）
- 文献对比（Step 25）

### ✓ 问题动机清晰

林区消防场景下 GNSS 退化 + 链路波动 + RSU 稀疏的组合确实是一个实际问题。

### ✓ 数据量充足

50 seeds × 多场景的数据量足以支撑统计结论（如果场景配置合理的话）。

---

## 距离可接受的 VTC 论文还差什么（What's Missing）

### 关键缺失 #1：方法的数学形式化

**需要补充：**

```
minimize:   E[ transmission_cost ]
subject to: E[ timely_delivery_rate ] >= target
            E[ emergency_timely_rate ] >= emergency_target
            delay <= deadline (hard constraint)
```

然后论证为什么这个问题是 NP-hard，为什么需要启发式，以及启发式如何近似最优解。

或者，重构 Lyapunov 框架让其性能与 Heuristic 可比。

### 关键缺失 #2：场景参数的工程合理性

**需要修复：**

- ForestGeometry 的 Emergency Timely 提升到 50%+ (Oracle 70%+)
- 明确每个参数的来源（文献引用或实测拟合）
- 提供 sensitivity analysis 证明结论对参数变化鲁棒

### 关键缺失 #3：方法适用边界的明确定义

**需要补充：**

```
Method is effective when:
  - NLOS ratio > X%
  - Baseline timely rate in [Y%, Z%] (not too good, not impossible)
  - Blind-zone events overlap with GNSS degradation
  
Method gracefully degrades when:
  - Baseline timely rate > 99% (ceiling effect)
  - Channel uniformly bad (no localized blind zones)
```

### 关键缺失 #4：Pareto 分析

**需要补充：**

- Timely Rate vs. Cost 的 scatter plot
- Cost-Efficiency 指标 = Timely / Cost
- 证明 Confidence-driven 在 Pareto 前沿上

### 关键缺失 #5：论文写作完整性

**需要补充：**

- 系统架构图
- 算法伪代码
- 参数表（来源 + 默认值）
- Discussion 章节（讨论 M1-M6 中的 tradeoff）
- Limitation 小节（诚实报告方法边界）

---

## 具体修复建议（Concrete Solutions）

### 修复路径 A：保留启发式，强化实验与讨论

**适合人群：** 如果作者时间紧迫（< 1 个月）

**核心策略：** 承认方法是启发式，但通过充分的实验和分析证明其有效性

**需要做的：**

1. **修复 ForestGeometry 参数**（2 小时）
   ```matlab
   params.deadline_emergency_physical = 0.150;  % 从 0.075 放宽
   params.pathloss_nlos_exponent = 24.5;        % 从 25.0 降低
   params.sinr_floor_dB = -2.0;                 % 新增 SINR 保护
   ```

2. **重跑 Step 17 + Step 25**（3 小时）

3. **生成 Pareto 图和 Efficiency 表**（1 小时）

4. **写 Applicability Boundary 分析**（2 小时）

5. **重写论文 Discussion，明确讨论所有 tradeoff**（4 小时）

**预期结果：** 论文可以投 IEEE VTC，但仍会被质疑"理论深度不足"，适合作为 Conference 级别工作。

---

### 修复路径 B：理论化重构，冲击期刊

**适合人群：** 如果作者希望投 IEEE Transactions (TVT/TITS)（需 2-3 个月）

**核心策略：** 用优化框架替代启发式，或修复 Lyapunov 让其性能可比

**方案 B1：约束优化重构**

```matlab
% 将 decide_schedule_action 改为求解：
% min_{a ∈ A} c(a)
% s.t.  P_timely(a) >= required_target
%       delay(a) <= deadline
%       a ∈ feasible_set

cvx_begin
  variable x(N_actions)
  minimize( c' * x )
  subject to
    P_timely' * x >= target
    delay' * x <= deadline
    sum(x) == 1
    x >= 0
cvx_end
```

将启发式的 regime_bias 替换为约束优化的 Lagrange 乘子。

**方案 B2：修复 Lyapunov**

```matlab
% 加入 event-triggered queue boost
if blind_zone_gate > threshold
    Q(t) = Q(t) + boost;  % 立即响应突发事件
end

% 或者：自适应 V 参数
V_effective = V_base / (1 + urgency_scale * urgency);
```

做 V-parameter sweep，证明存在 V 值使得 Lyapunov 性能 >= Heuristic - 0.5%。

**预期结果：** 论文可以投 IEEE TVT，理论深度足以通过审稿，但工作量显著增加。

---

## 修复优先级矩阵

| 问题 | 严重性 | 修复难度 | 优先级 | 预计工时 |
|------|--------|----------|--------|----------|
| M2 (ForestGeometry 崩塌) | 致命 | 低 | **P0** | 2 小时代码 + 3 小时重跑 |
| M3 (50% Below1pp) | 严重 | 低 | **P0** | 2 小时论文重写 |
| M4 (DCC 反超) | 严重 | 中 | **P1** | 1 小时 Pareto 图 + 1 小时讨论 |
| M1 (缺乏理论) | 致命（期刊）| 高 | P1/P2 | 路径 A: 跳过；路径 B: 2-4 周 |
| M5 (Lyapunov 更差) | 严重 | 中 | **P1** | 路径 A: 重新定位（2 小时）；路径 B: 修复（1 周）|
| M6 (延迟增加) | 中等 | 中 | P2 | 1 小时代码 + 讨论 |
| m1-m4 (次要问题) | 轻微 | 低-中 | P3 | 各 0.5-2 小时 |

**建议执行顺序（路径 A，投 VTC Conference）：**

```
Week 1: P0 问题（M2 + M3）
  - Day 1: 修复 ForestGeometry 参数
  - Day 2-3: 重跑 Step 17 + Step 25
  - Day 4: 生成 Pareto 图 + Efficiency 表
  - Day 5: 写 Applicability Boundary 分析

Week 2: P1 问题（M4 + M5）
  - Day 1: DCC 反超的 Pareto 讨论
  - Day 2: Lyapunov 重新定位为 cost-variant
  - Day 3-4: 重写 Discussion 章节
  - Day 5: 处理 m1-m4 次要问题

Week 3: 论文完稿
  - Day 1-2: 系统图 + 伪代码 + 参数表
  - Day 3-4: Introduction + Related Work 完善
  - Day 5: 全文润色 + 投稿
```

---

## 最终判断

**当前状态：** 6/10（有潜力的原型，但不是可发表的论文）

**修复后预期（路径 A）：** 7.5/10（可接受的 VTC Conference 论文）

**修复后预期（路径 B）：** 8.5/10（有竞争力的 TVT 期刊论文）

**核心建议：** 作者不要急于投稿。用 2-3 周时间修复 M2-M4，然后投 VTC。如果被拒（边缘），按照 review comments 修改后投 Access 或 VTC 下一届。如果想冲期刊，走路径 B，但需要 2-3 个月。

**一句话：** 这是一个**工程完成度高但方法学深度不足**的工作。适合 Conference，但需要修复关键缺陷才能投。

---

**Reviewer Signature**: VTC-2026-TPC-R3  
**Date**: 2026-06-08
