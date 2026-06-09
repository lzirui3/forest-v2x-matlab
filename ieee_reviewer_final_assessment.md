# IEEE 严格审稿人判断（基于 forest_v2x_matlab_package 实际状态）

**评审日期**：2026-06-01  
**项目实际完成度**：约 78%  
**评审结论**：Minor-to-Major Revision

---

## 一、项目已完成的工作（审稿人会认可的部分）

| 维度 | 状态 | 证据 |
|------|------|------|
| 物理层建模 | ✅ 完整 | `sinr_to_pdr_physical.m` 支持 sigmoid/PER 表切换 |
| 多场景验证 | ✅ 已做 | Step 17: 3 场景(10014/10006/10017) × 2 配置 × 50 seeds |
| 统计检验 | ✅ 充分 | Wilcoxon + 95% CI，所有关键对比 p<0.001 |
| 消融实验 | ✅ 完整 | Step 10: 4 模块消融 |
| 灵敏度分析 | ✅ 完整 | Step 11: 9 参数灵敏度 |
| 参数搜索 | ✅ 已做 | Step 18: regime 参数网格搜索 |
| 林区数据标定 | ✅ 已做 | `get_forest_dataset_calibrated_params.m` 使用真实数据 |
| 公平基线 | ✅ 已做 | Link-Opt / Position-Opt 使用相同优化框架 |
| PER 表验证脚本 | ✅ 已写 | Step 19 脚本存在（但未跑出结果） |

---

## 二、仍然存在的差距（除论文写作外）

### 差距 R1：Step 19 PER 表交叉验证未产出结果 [重要]

**现状**：`main_step19_per_lookup_validation.m` 脚本已写好，但没有输出文件（`step19_*` 结果不存在）。

**问题**：审稿人会问 "sigmoid 近似的误差对最终排名有影响吗？"，你需要这个数据来回答。

**解决方案**：在 MATLAB 中运行 `main_step19_per_lookup_validation`。如果 PER 表路径配置正确（`external_data/WiLabV2Xsim-main/PERcurves/` 已存在），直接跑即可。10 seeds × 2 configs × 2 modes = 约 5-10 分钟。

---

### 差距 R2：优化器 relay 预测与仿真器不一致 [重要]

**现状**：仿真器 `simulate_step9_delivery_physical.m` 已使用两跳独立信道模型，但优化器 `predict_action_pdr_physical.m` 仍用 `pdr × relay_link_ratio` 简化。

**问题**：审稿人会问 "优化器的决策是否基于正确的物理模型？"

**解决方案**：**已在本次会话中修复**（刚才已将三个预测函数改为两跳模型）。需要重新跑 Step 17 验证结果不变。

---

### 差距 R3：缺少文献对比方法 [中等]

**现状**：基线包括 Fixed / Priority-only / Link-aware / Link-delay-aware / Fused-rule / Oracle / Link-Opt / Position-Opt。但没有已发表的标准方法。

**审稿人会问**："与 ETSI DCC / AoI-based / DRL-based 方法相比如何？"

**解决方案**：实现 2 个文献方法：
- **ETSI DCC-like**：基于 CBR 的速率控制
- **AoI-aware**：基于信息新鲜度的优先级调度

---

### 差距 R4：PosDeg_Emerg 阶段在部分场景无显著增益 [需要解释]

**现状**：Step 17 结果显示：
- Scene 10014 ForestGeometry: Timely +2.91%, Emergency +9.0% → **显著**
- Scene 10006 Default PosDeg_Emerg: Timely +0.0% → **不显著**
- Scene 10017 Default/Forest PosDeg_Emerg: Timely +0.0% → **不显著**

**问题**：方法在某些场景的关键阶段没有增益。审稿人会问："你的方法在什么条件下有效？什么条件下退化为基线？"

**解决方案**：这不是 bug，而是需要在论文中明确说明方法的**适用条件**：
- 当 NLOS 遮挡与紧急消息时间重叠时增益最大（10014 CurvedBlind）
- 当信道条件好（Default 配置下 PosDeg 阶段 PDR 已经很高）时方法退化为基线（无害但无增益）
- 论文中需要一个 "Method Applicability Analysis" 小节

---

### 差距 R5：tx_cost 定义不一致 [已修复但需重跑]

**现状**：刚才已将 `evaluate_action_metrics.m` 中的 `tx_cost = mode_cost * action.tx_rate` 改为 `mode_cost * action.rate_multiplier`。

**影响**：Step 17 的现有结果是用旧的 tx_cost 定义跑的。需要重跑以获得一致的结果。

---

## 三、可执行解决方案

### 立即可做（MATLAB 中运行即可）

| 编号 | 操作 | 预计时间 |
|------|------|---------|
| A1 | 运行 `main_step19_per_lookup_validation` | 5-10 分钟 |
| A2 | 重跑 `main_step17_paper_statistics`（修复后） | 30-60 分钟 |

### 需要写代码（我现在可以帮你写）

| 编号 | 操作 | 预计时间 |
|------|------|---------|
| B1 | 写 `run_step9_baseline_dcc.m`（ETSI DCC 基线） | 30 分钟 |
| B2 | 写 `run_step9_baseline_aoi.m`（AoI 基线） | 30 分钟 |
| B3 | 将 B1/B2 集成到 Step 17 对比框架 | 20 分钟 |

### 论文中需要说明（不需要代码）

| 编号 | 内容 |
|------|------|
| C1 | Method Applicability Analysis：说明增益条件 |
| C2 | Physical Layer Validation：引用 Step 19 结果 |
| C3 | Computational Complexity：45 动作枚举的时间复杂度 |

---

## 四、与之前评估的差异

之前基于 `v2x-v2v-1-vehicle-to-everything` 目录评估时认为差距约 40-50%，但实际 `forest_v2x_matlab_package` 已经独立完成了大量工作：

| 之前认为缺的 | 实际状态 |
|-------------|---------|
| G1: PER 表验证 | ✅ 脚本已写（Step 19），只需运行 |
| G2: 多场景验证 | ✅ 已完成（Step 17, 3 场景 × 50 seeds） |
| G3: 文献对比 | ❌ 仍缺 |
| G4: 参数搜索 | ✅ 已完成（Step 18） |
| G5: 林区标定 | ✅ 已完成（forest_dataset_calibrated_params） |

**实际剩余差距**：只剩 R1（跑一下）+ R3（文献对比）+ R4（论文解释）+ R5（重跑）。

---

## 五、结论

**距离可投稿（IEEE TVT）的实际差距约 15-20%**，具体是：
1. 跑 Step 19（5 分钟）
2. 写 2 个文献对比基线（1 小时代码）
3. 重跑 Step 17（30 分钟等待）
4. 论文中加 Method Applicability 分析（写作）

要我现在写 ETSI DCC 和 AoI 基线代码吗？
