# 审稿人视角项目审查报告

## 一、致命缺陷（会导致拒稿）

### 1.1 投递模型缺乏物理基础
`simulate_step9_delivery.m` 的核心判定 `delivered(k) = success_prob >= deterministic_gate` 
没有任何物理对应。success_prob 和 gate 都是多个加权项的线性组合，
既不是 SINR→PDR 的标准映射，也不是信息论中的信道容量公式。

- success_prob 中同时包含链路质量(q_link)、优先级加成(0.05*(p-1))、
  模式加成(0.10/0.15)等不同量纲的量，直接相加没有物理意义
- gate 中混合了链路权重、位置权重、紧急度权重，clamp 到[0.05, 0.95]后
  作为"门限"，但这个门限不对应任何实际通信指标

**审稿人会问**：为什么不直接用 SINR→PDR 曲线做概率投递？
你们的 step9_wilab_like_sinr_to_pdr.m 已经有 PER 曲线，
为什么最终投递判定不用它？

**修复方案**：Phase 3 的随机衰落部分地缓解了这个问题（将确定性判定变为
随机的），但核心模型仍然不是物理驱动的。建议在论文中明确说明这是一个
**抽象调度层模型**，物理层通过 q_link 参数化，并引用 WiLabV2Xsim 的
PER 曲线作为 q_link 的来源依据。

### 1.2 基线方法被系统性削弱

对比四个方法的"能力范围"：

| 方法 | 速率倍率范围 | 模式选择 | 风险信息 |
|------|:---:|---------|---------|
| Fixed | 1.0x (固定) | 仅 direct | 无 |
| Link-aware | 1.0-2.0x | relay/redundant (不检查delay) | 仅 q_link |
| Position-only | 1.0-2.0x | direct/redundant | 仅 q_pos |
| Confidence-driven | 1.0-2.5x | 全部 (delay-aware) | q_link + q_pos + utility优化 |

**关键不公平**：
- Confidence-driven 独享 2.5x 速率倍率（其他方法最大 2.0x），
  这是通过 `action_rate_multiplier_set=[1.0,1.35,1.7,2.1,2.5]` 实现的，
  而基线使用 `priority_rate_scale=[1.0,1.5,2.0]`
- Confidence-driven 有 delay-aware 模式选择（通过 utility 优化器），
  其他方法用简单规则盲目选模式
- Confidence-driven 有 90+ 个精心调参的 utility 权重，
  基线方法只有 2-3 个简单阈值

**审稿人会问**：如果给 Link-aware 同样的 2.5x 速率范围和 delay-aware 
模式选择，差异还存在吗？你的方法论贡献到底是"融合多源信息"还是
"更大的动作空间+更精细的参数"？

**修复方案**：
1. 统一所有方法的动作空间（都用 [1.0-2.5x] 速率范围）
2. 给 Link-aware 也加 delay-aware 模式选择（只是缺少 q_pos 信息）
3. 在消融实验中隔离每个因素的贡献

### 1.3 92个参数过度拟合风险

`get_default_step9_params.m` 包含 92 个参数，其中大量参数
（utility_weight_*, utility_priority_bias, utility_mode_bias 等）
只对 Confidence-driven 有效。

**审稿人会问**：这些参数是怎么选的？有没有对参数空间做过交叉验证？
如果在不同场景下这些参数需要重新调整，你的方法还有优势吗？

**修复方案**：Step 11 灵敏度分析必须覆盖关键参数，
证明在 ±20% 扰动下方法排序不变。

---

## 二、重大缺陷（需要大改）

### 2.1 缺少关键对比基线

缺少以下标准基线：
- **离线最优（Oracle）**：知道所有未来信息的上界，
  证明 Confidence-driven 接近最优
- **联合 Link+Position 简单规则**：不用 utility 优化，
  只用简单 if-else 融合 q_link 和 q_pos，
  证明 utility 优化的必要性
- **文献中的现有方法**：如 ETSI DCC（分布式拥塞控制）、
  3GPP Mode 4 Semi-Persistent Scheduling

### 2.2 场景物理参数不合规

与 3GPP 标准的偏差：
- 通信距离 40-150m（林火场景应 200-500m）
- 干扰峰值仅 6 dB（多车 SCI 冲突应 10-15 dB）
- 消息频率 1.5 Hz（C-V2X 标准 10-25 Hz）
- 路径损耗模型标签为 urban_los/urban_nlos（应为 Rural NLOS）
- tx_power=17 dBm（标准 C-V2X 为 20-23 dBm）

### 2.3 样本量不足

PosDeg_Emerg 阶段仅 22 条消息（22秒 × 1 Hz），
样本量过小导致 Timely Rate 的分辨率仅为 1/22 ≈ 4.5%。
即使两个方法有 5% 的真实差异也无法在单次运行中检测。

**修复**：将 emergency 消息频率提升至 5-10 Hz，
PosDeg_Emerg 延长至 40s，使样本量达到 200-400 条。

---

## 三、中等缺陷（需要解释）

### 3.1 confidence_protection 仅在 mode>=1 时生效

`simulate_step9_delivery.m` 第44行：
`if policy.mode(k) >= 1  % redundant or relay`

这个设计给了使用 redundant/relay 模式的方法额外优势，
而 Fixed（始终 direct）和 Position-only（多数情况 direct）
被剥夺了这个加成。

**审稿人会问**：为什么 direct 模式不能利用位置感知？
在 C-V2X 中，即使不重复发送，知道位置信息也可以调整
MCS 或功率来提升成功率。

### 3.2 gate 中的 emergency 减免被完全取消

`deterministic_gate = deterministic_gate - 0.00;`

这使得 emergency 消息的投递门限与普通消息相同，
但在现实 C-V2X 中，emergency 消息有更高的 QoS 优先级
（更低的 PDB、更高的资源分配优先级）。

### 3.3 确定性模型 vs 随机模型的选择

`params.enable_stochastic = true` 控制模型类型。
但 predict_action_success.m 和 predict_action_delay.m
（utility 优化器的预估模型）**不包含随机性**，
这意味着 Confidence-driven 的决策基于确定性预估，
而实际投递是随机的。

**审稿人会问**：在随机信道下，基于确定性预估的决策是否最优？
应该至少讨论鲁棒优化或期望效用最大化。

---

## 四、小问题

1. **参数文件不一致**：get_default_step9_params.m 中
   link_delay_scale=0.45，但 mainline 版本覆盖为 0.28，
   容易造成混淆
2. **硬编码魔数**：compute_action_utility.m 中有
   0.55, 0.30, 0.15, 0.18 等多个硬编码权重未移入 params
3. **PER 曲线路径硬编码**：step9_wilab_like_sinr_to_pdr.m
   中的文件路径指向本地 D:\matrix\... 不可移植
4. **事件状态初始化不透明**：run_step9_confidence_driven.m
   中 event_state 的构造逻辑分散在多个条件分支中，
   难以追踪数据流
5. **Position-only 基线使用相同的阈值 T1/T2**：
   这些阈值是为 Link-aware 设计的（0.60*urgency + 0.40*risk），
   对 Position-only 不一定最优

---

## 五、优先修复建议

### 立即行动（投稿前必须完成）：
1. 统一所有方法的动作空间（速率范围 1.0-2.5x）
2. 给 Link-aware 加 delay-aware 模式选择
3. 添加 Oracle 上界基线
4. 添加简单融合规则基线（证明 utility 优化的必要性）
5. 灵敏度分析覆盖所有 utility 权重

### 中期行动（修改后提升论文质量）：
1. 扩大通信距离至 200-400m
2. 提升干扰强度至 12-15 dB
3. 增加消息密度至 5-10 Hz
4. 使用 3GPP Rural NLOS 路径损耗模型
5. 在论文中明确说明投递模型是抽象调度层模型

### 长期行动（可选但加分）：
1. 接入真实 C-V2X 测量数据验证
2. 与 ETSI DCC 标准方法对比
3. 多场景泛化性验证（城市、高速公路、林区）