# Forest-V2X 调度器（Risk-constrained-v6）参数可信度与理论框架报告

> 范围说明：本报告只针对 **v6 主路径实际激活**的参数（`active_in_proposed_method=true`）给出接地方案；`is_action_feasible.m` 系列、`per_lookup`、`veg_attenuation_*`、`fast_fading_*`、单队列 Lyapunov 等 **不在 v6 活动路径**上的参数仅在"诚实边界"与诊断中提及，不计入需接地的主目标。所有引用严格遵循对抗性核查结论：被 `refuted`/`unverifiable` 的具体数字一律标注，不作为已坐实证据呈现。
>
> 生成方式：5 路代码追踪 + 5 个理论透镜（约束优化乘子 / V2X 可靠性与时延标准 / 森林 RF 植被衰减 / GNSS 完好性 / VoI 与代价）的标准检索 + 对抗式引用核验 + 综合，共 16 个 agent。

---

## 1. 框架理论性问题诊断（按严重度排序）

### 问题 1（最严重）：固定权重"Lagrangian"既无可行性也无最优性保证，且 λ 绝对值无依据

`compute_action_risk_constrained_objective_v4.m:38–42` 用五个**冻结常数** λ = (3.20, 2.20, 1.25, 1.60, 0.75) 对五个违反量加权求和，文件头却自称 "Lagrangian"。

- **为什么是理论缺陷**：真正的 Lagrangian 方法要么在对偶上做更新（对偶上升 / drift-plus-penalty），要么 λ 取最优对偶变量 λ\*。本实现既不更新 λ，λ 也不是任何 KKT 点的对偶变量，因此：
  1. **无可行性证书** —— 冻结 λ 不能保证时间平均约束 E[g_i]≤0 被满足；只有虚队列均值率稳定才能给出该保证（Neely 2010，核查 `supported`）。
  2. **无 O(1/V) 最优性界** —— drift-plus-penalty 的"惩罚距最优 O(1/V)、积压 O(V)"权衡是冻结权重**根本不具备**的（核查 `supported`）。
  3. **绝对值不可辨识** —— 按 KKT 灵敏度 λ\*_i = −∂p\*/∂b_i（Boyd & Vandenberghe §5.6，核查 `supported`），只有 λ 之间的**比值**有意义；3.20 这个绝对数没有任何推导。
- **审稿人会攻击**："你把加权软惩罚打分函数命名为 Lagrangian，但既没做对偶更新、权重也不是对偶变量，这是术语过度声称（overclaim）。请么真做对偶上升、么改名为 weighted soft-penalty score 并删去最优性措辞。"
- **额外的诚实点**：仓库自身证据显示现有单队列 Lyapunov 在 step23/step30 **输给**冻结启发式（TimelyRate 0.9531 vs 0.9729），但该 Lyapunov 变体 **从未获得与启发式同等的调参预算**（V=1.0 全程未调，`get_default_step9_params.m:292–301`）。因此"固定胜过 Lyapunov"实为"已调胜过未调"，不能作为反对 drift-plus-penalty 的证据。

### 问题 2：required_timely / required_success 是合成仿射函数，与标准可靠性定义脱节甚至重复计数

`compute_required_timely_target.m` 用 `required_timely = 0.18 + 0.34·urgency + …`，`compute_action_risk_constrained_objective_v4.m:76–77` 用 `required_success = 0.50 + 0.24·urgency + …`，两条独立仿射曲线。

- **为什么是理论缺陷**：3GPP TS 22.186 把"可靠性"**定义为**"在要求时延与通信范围内成功接收消息的百分比"（核查 `supported`），即 required_timely（延迟内成功）与 required_success（成功）在标准语义下**是同一个量**，分两条仿射曲线拟合属于**双重计数**。更糟的是：当前输出（normal≈0.57/0.28、coop≈0.64/0.38、emergency≈0.73/0.50）比任何标准可靠性档（90% / 99.99% / 99.999%）低一个数量级，且 `success_max=0.94` 的上夹直接与 99.99%/99.999% 档不兼容。
- **审稿人会攻击**："你的可靠性目标既非标准档，也不符合标准对可靠性的定义；两条仿射斜率（0.34、0.24）和截距（0.18、0.50）是凭空设定的拟合数，不是 QoS RHS。"

### 问题 3：0..1 的 q_pos 置信度被当作度量量使用，而它本是一个被仿射编码的米级误差

piecewise position-risk 与多处门限（`utility_required_timely_qpos_high_threshold=0.75`、`utility_required_timely_qpos_low_threshold=0.50`、blind/regime 门）直接对 q_pos 设阈。

- **为什么是理论缺陷**：q_pos 并非自由的 0..1 分数——`compute_positioning_confidence_rule.m:10` 将其线性编码为 1‑σ 水平定位误差 σ_pos∈[0.3 m, 3.0 m]。导航完整性理论（ESA Navipedia "Integrity"，核查 `supported`）的标准判据是 **PL>AL 时宣告不可用**，即应对 `PL=k·σ` 与告警限 AL 比较，而不是对一个无量纲分数手设阈。当前做法绕过了 protection level / alert limit / integrity risk 这一整套有理论基础的框架。
- **审稿人会攻击**："0.75/0.50 这些 q_pos 阈值是无量纲魔数；你已经在算 coarse_sigma（`step9_generate_positioning_state_*:168–174`），为什么不直接按完整性判据 PL>AL 触发？"
- ⚠️ **必须避免的错误**：grounding 文档给出的 PL 分位数 `k=sqrt(-2 ln IR)` 与其列出的数值（3.29/4.42/5.33/5.73）**自相矛盾**（核查 `refuted`）：该公式实为 2D Rayleigh 分位数，正确值是 3.717/4.799/5.678/6.070；而列出的 3.29/4.42/5.33/5.73 是 **1D 双侧高斯**分位数 `−Φ⁻¹(IR/2)`。论文中**只能二选一**且必须明确标注维度，不能照搬该不一致组合。

### 问题 4："已校准"的 forest 函数其实只有数据输入是真的，每个映射系数仍是手选

`calibrate_forest_scene_params.m` 读入三套真实外部数据（USFS 道路 .shp、ForestPaths .tif、below-canopy .pcd）得到 `curvature_norm / cover_density_norm / canopy_density_norm`，但**每个仿射映射系数**（截距、斜率、`/60`、`/0.08` 锚点）都是手选的。

- **为什么是理论缺陷**：把"数据驱动校准"作为卖点，但 `gnss_severity = 0.55·cover + 0.45·canopy`、`nlosv_extra_loss = 3.5 + 3.5·attenuation_norm`、`alpha_los = 2.1 + 0.45·curvature + 0.30·cover` 等的系数没有任何回归或文献依据。归一化锚点 `/0.08`（曲率）、`/60`（道路长度）同样是手选除数。**真实成分仅限于 percentile 统计本身**（`cover_density_norm/attenuation_norm/canopy_density_norm` 已被合理归为 data_calibrated）。
- **审稿人会攻击**："这是把手调系数包了一层数据外壳。真实数据进去，但从数据到参数的每一步斜率/截距都是你定的，可重复性无从谈起。"

### 问题 5（次要但应处理）：约束冗余 / 隐式重参数化未被显式承认

- `position_violation = pos_risk · protection_violation`（按 trace），即 position 约束**不是独立约束**，λ_protection + pos_risk·λ_position 实为**单一状态相关 protection 价格**；0.75 应被重述为"protection 价格对 pos_risk 的斜率"，而非独立影子价。
- `deadline_violation` 与 `timely_violation` 都编码时延，高度重叠，存在双计数风险。
- **审稿人会攻击**："你的五约束里至少两个是另两个的重参数化，五个 λ 的自由度被高估了。"

---

## 2. 参数来源全景表（v6 活动路径）

证据强度图例：★★★ = 已被核查 `supported` 的标准/文献可直接坐实；★★ = `partially_supported` 或需经内部单位桥接/推导；★ = `medium/low confidence` 或仅形式可接地、数值仍为工程选择；✎ = 诚实工程选择（不可推导）。状态：**已接地** / **可接地** / **工程选择**。

### 2.1 拉格朗日乘子 & 目标权重（`compute_action_risk_constrained_objective_v4.m`）

| 参数 | 当前值 | 当前归类 | 建议理论来源 | 证据强度/状态 |
|---|---|---|---|---|
| risk_constrained_timely_lambda | 3.20 | hand_tuned | 虚队列 Z_timely/V（Neely 2010 Ch.4-5）；或保留为比值锚（Boyd §5.6） | ★★★ 可接地（adaptive） |
| risk_constrained_success_lambda | 2.20 | hand_tuned | 虚队列 Z_success/V | ★★★ 可接地 |
| risk_constrained_deadline_lambda | 1.25 | hand_tuned | 与 timely 合并为单一时延队列（建议消除） | ★★ 可接地/可消除 |
| risk_constrained_protection_lambda | 1.60 | hand_tuned | 虚队列 Z_protection/V；约束 RHS 由 PL>AL 给出 | ★★★ 可接地 |
| risk_constrained_position_lambda | 0.75 | hand_tuned | 非独立约束，重述为 protection 价格对 pos_risk 的斜率 | ★★ 可接地/可重参数化 |
| 五 λ 之间的比值 | 3.20:2.20:1.25:1.60:0.75 | hand_tuned | KKT 影子价比值，单次灵敏度扫描可测（Boyd §5.6） | ★★★ 可接地 |
| risk_constrained_success_reward_weight | 0.45 | hand_tuned | 对 VoI numeraire 的 MRS = g'(late)/g'(timely)（Sun 2017） | ★ 工程选择（形式可接地） |
| risk_constrained_event_reward_weight | 0.12 | hand_tuned | 对 VoI numeraire 的 MRS | ★ 工程选择 |
| risk_v4_actual_cost_weight | 0.060（v6 覆盖） | hand_tuned | 重述为无量纲 MRS（Marler & Arora 2004） | ★ 工程选择 |
| risk_constrained_delay_weight | 0.08 | hand_tuned | MRS / s_delay=deadline | ★ 工程选择 |
| risk_constrained_position_risk_weight | 0.20 | hand_tuned | MRS / s_risk=1 | ★ 工程选择 |
| risk_constrained_misdecision_weight | 0.28 | hand_tuned | MRS（misdecision:delay:relay≈4.7:1.3:1） | ★ 工程选择 |
| risk_constrained_relay_penalty_weight | 0.06 | hand_tuned | MRS numeraire | ★ 工程选择 |
| voi_bias / urgency/pos/link/blind_scale | 0.65/0.70/0.24/0.14/0.28 | hand_tuned | VPI = C−C'（Howard 1966）+ 读取 CV 滤波器 trace(P) | ★ 可接地（框架强、数值需成本模型） |
| voi_min / voi_max | 0.50 / 1.90 | hand_tuned | 重述为 [min 残值, max 避损]；宽度为饱和保护 | ✎ 工程选择 |
| success_bias/urgency/link/pos/blind_scale | 0.50/0.24/0.12/0.10/0.12 | hand_tuned | 截距锚到标准档，斜率为风险自适应余量策略 | ★ 工程选择（截距可接地） |
| success_min / success_max | 0.45 / 0.94 | hand_tuned | 上夹与 99.99%/99.999% 档冲突，需重解释为仿真可达 derating | ★★ 需重解释 |

### 2.2 约束 RHS / required-target（`compute_required_*` 系列）

| 参数 | 当前值 | 当前归类 | 建议理论来源 | 证据强度/状态 |
|---|---|---|---|---|
| utility_required_timely_bias/urgency/link/pos/blind_scale | 0.18/0.34/0.20/0.16/0.14 | hand_tuned | 按类查表至 TS 22.186 档（90/99.99/99.999%）+ 延迟 CDF 拆分 | ★★★ 可接地（类映射为解释） |
| utility_required_timely_min/max | 0.25/0.92 | hand_tuned | 由标准档替代仿射夹 | ★★ 可接地 |
| utility_required_timely_qpos_high/low_threshold | 0.75/0.50 | hand_tuned | 由 PL>AL 反演（ESA Navipedia） | ★★ 可接地（数值需 k/AL） |
| utility_required_timely_qpos_mid/low_scale | 0.50/1.00 | hand_tuned | Stanford 图分区 | ✎ 工程选择 |
| utility_required_protection_*（activation/shape/scale/min/max 全族） | 多值 | hand_tuned | RHS 由 PL=k·σ vs AL 给出；λ 本身保留为工程权重 | ★ RHS 可接地 / 权重工程选择 |
| utility_required_protection urgency-0.5 / link-0.2 offsets | 0.5 / 0.2 | hand_tuned | 激活参考点，工程选择 | ✎ 工程选择 |
| blind_zone_trigger_threshold | 0.55（forest 覆盖 0.50） | data_calibrated | 森林数据校准（已标 data_calibrated） | ★★ 已部分接地 |
| utility_protection_priority/rate/mode_weight | 0.30/0.35/0.35 | hand_tuned | protection LHS 复合权，工程选择 | ✎ 工程选择 |
| utility_mode_level_relay/redundant/direct | 1.0/0.62/0.20 | hand_tuned | mode 保护层级序数，工程选择 | ✎ 工程选择 |
| priority 归一 (priority-1)/2 | 1,2 | standards_derivable | 由 3 级动作空间定义直接导出 | ★★★ 已接地 |
| utility_emergency_urgency_threshold | 0.80 | hand_tuned | 合成 urgency 轴上的类边界；建议改为消息类标签 | ✎ 工程选择 |
| coop-deadline urgency≥0.50 | 0.50 | hand_tuned | 同上，类边界 | ✎ 工程选择 |
| utility_redundant_blind/qpos_threshold | 0.10/0.65 | hand_tuned | 冗余模式失配判据，工程选择 | ✎ 工程选择 |

### 2.3 物理层（`get_default_step9_params.m` / `step9_generate_link_state_*`）

| 参数 | 当前值 | 当前归类 | 建议理论来源 | 证据强度/状态 |
|---|---|---|---|---|
| tx_power_dBm | 23.0 / 22.0 | standards_derivable | C-V2X Power Class 3 = 23 dBm（TS 36.101） | ★★★ 已接地 |
| noise_floor_dBm | −94.0 | standards_derivable | −174+10log10(10e6)+NF(10dB)=−94 dBm | ★★★ 已接地 |
| pathloss_los_offset_dB | 47.0（calib 46.5+1.8·veg） | standards_derivable | 20log10(4π·fc/c)\|_{1m,5.9GHz}=47.8 dB（Friis；= TR 37.885 的 32.4 展开） | ★★★ 已接地 |
| pathloss_los_exponent (20·α) | 20.0 | standards_derivable | n_LOS=2.0（TR 37.885 高速 LOS） | ★★★ 已接地 |
| pathloss_nlos_offset_dB | 50.0 | standards_derivable | LOS+~3 dB 偏移 | ★★ 可接地 |
| pathloss_nlos_exponent | 24.0 | standards_derivable | n_NLOS∈[2.7,3.9]（TR 38.901 RMa NLOS） | ★★★ 可接地（夹端坐实） |
| nlosv_extra_loss_dB | 5.0（calib 3.5+3.5·norm） | standards_derivable | μ=5 dB（一般）/9 dB（高遮挡），σ=4/4.5（TR 37.885 §6.2.1）；建议 5+4·norm | ★★★ 可接地 |
| interference_scale | 1.8（calib 1.6+0.7·veg） | hand_tuned | 无植被标准支配；应来自 SPS 碰撞模型或保留工程 | ✎ 工程选择 |
| shadow_sigma LOS/NLOS | 3.0 / 4.0 | hand_tuned | TR 37.885：SF σ=3 dB(LOS)；**NLOSv 复用 LOS=3 dB**，4 dB 属 NLOS 行或 blockage σ | ★★ 可接地（需修正归属，见 §3） |
| priority_sinr_gain / emergency_sinr_bonus | 0.5 / 1.0 | hand_tuned | 资源分配优先级增益，工程选择 | ✎ 工程选择 |
| relay_sinr_offset / hop2 / nlos_to_los_prob | 2.5/1.5/0.35 | hand_tuned | 两跳几何/空间分集，工程选择 | ✎ 工程选择 |
| base_access_delay / attempt_gap | 0.012 / 0.014 | standards_derivable | 形式锚到 1 ms TTI + 预留周期；**具体 ms 值非标准规定** | ★★ 形式可接地/数值工程 |
| mode_overhead_redundant / relay | 0.012 / 0.030 | standards_derivable | 整数子帧计数；relay≈一次额外 SPS 选择窗 | ★★ 形式可接地 |
| congestion_delay_max | 0.045 | hand_tuned | 裸幅值，工程选择 | ✎ 工程选择 |
| pdr_midpoint_los/nlos | 4.0 / 6.0 | data_calibrated | MCS 所需 SINR（QPSK½ ~10% BLER @2–4 dB，TR 36.885/38.901） | ★ 可接地（中点）/拟合 |
| pdr_slope_los/nlos | 0.9 / 0.7 | data_calibrated | 衰落 BLER 滚降，经验拟合保留 | ✎ 工程选择 |
| deadline_normal_physical | 0.50 | standards_derivable | 见 §3 类映射；0.50 非条款值 | ★★ 需重锚 |
| deadline_coop_physical | 0.18 | standards_derivable | 标准档 0.100 s（TS 22.186 协作碰撞规避）；0.18 是 1.8× 工程余量 | ★★★ 可接地 |
| deadline_emergency_physical | 0.070 | standards_derivable | ETSI 预碰撞 0.050 s / TS 22.185 0.020 s / TS 22.186 0.003 s；0.070 比三者都松 | ★★★ 可接地 |
| delay_jitter_scale | 0.15 | hand_tuned | mixture timely CDF 的 delay_std，工程选择 | ✎ 工程选择 |

### 2.4 定位 / 置信度融合 & forest 校准

| 参数 | 当前值 | 当前归类 | 建议理论来源 | 证据强度/状态 |
|---|---|---|---|---|
| position_weight_gnss/rsu/env/traj | 0.45/0.22/0.15/0.18 | hand_tuned | CV2X-LOCA 框架（仅框架名，无数值文献） | ✎ 工程选择 |
| position_alpha_*（base/delta/traj/blind/min/max） | 多值 | hand_tuned | 自适应 EWMA，工程选择 | ✎ 工程选择 |
| position_gnss_independent_noise_std | 0.08(+0.06·sev) | hand_tuned | C/N0 跌 4–5 dB-Hz → 测距噪声×1.68，经 s_pos 映射（见 §3）；**注意 4–5 dB-Hz 数被核查为 Sensors 2022 误引** | ★ 可接地（需正确引用源） |
| position_gnss_multipath_noise_std | 0.12(+0.10·sev) | hand_tuned | 多径占水平误差~50%（核查：属文献综述转述，非该文原创结论） | ★ 可接地（需谨慎引用） |
| gnss_independent/multipath_temporal_len | 12/15, 8/10 | hand_tuned | 窗=τ_decorr/dt；多径<慢偏序正确（一阶 GM 模型，核查 supported） | ★ 形式可接地/数值工程 |
| gnss_severity = 0.55·cover+0.45·canopy | 权重 0.55/0.45 | hand_tuned | 输入与单调关系有文献支撑；**权重分配本身需回归，否则工程选择** | ✎ 工程选择（输入可接地） |
| blockage_score / blind_zone / env 复合权 | 多组 | standards_derivable/hand_tuned | TR 37.885 遮挡建模（仅效应范围），权重分裂手选 | ✎ 工程选择 |
| cover/attenuation/canopy_density_norm percentile 锚 | p75/p99 等 | data_calibrated | 真实栅格/点云 percentile（已 data_calibrated） | ★★ 已部分接地 |
| meters-per-degree | 111320 | standards_derivable | 标准大圆 m/deg 常数 | ★★★ 已接地 |
| road/veg/pcd 采样上限、bbox | 多值 | data_calibrated | 数据处理限额 | ✎ 工程选择 |
| calibrate 所有仿射截距/斜率（alpha_los/nlos、nlosv、deadline_coop/emergency 等） | 多值 | hand_tuned/standards_derivable | 端点夹可锚标准，内部斜率为工程插值 | ★/✎ 端点可接地、斜率工程 |
| filter P0/Q/R/consistency 常数 | diag([4,4,1,1]) 等 | hand_tuned | CV 滤波器调参，工程选择 | ✎ 工程选择 |

### 2.5 场景定义 / 动作空间

| 参数 | 当前值 | 当前归类 | 建议理论来源 | 证据强度/状态 |
|---|---|---|---|---|
| action_priority_set | [1,2,3] | standards_derivable | 映射 3 级 C-V2X 优先级/PPPP 桶 | ★★ 可接地 |
| action_mode_set | [0,1,2] | standards_derivable | direct/redundant/relay 离散模式 | ★★ 可接地 |
| action_rate_multiplier_set | [1.0,1.35,1.7,2.1,2.5] | hand_tuned | 速率档，工程选择 | ✎ 工程选择 |
| priority_rate_scale | [1.0,1.5,2.0] | hand_tuned | 每优先级最小速率参考，工程选择 | ✎ 工程选择 |
| tx_cost_direct/redundant/relay | 1.0/1.6/1.8 | standards_derivable/hand_tuned | 归一化基准 1.0；冗余/中继相对成本工程选择 | ★/✎ 基准可接地、相对值工程 |
| urgency_normal/coop/emergency | 0.30/0.60/0.95 | hand_tuned | 合成序数；建议改为消息类标签驱动 RHS | ✎ 工程选择 |
| base_rate_normal/coop/emergency | 1.0/2.0/1.5 | hand_tuned | 消息生成率，工程选择 | ✎ 工程选择 |

---

## 3. 分组接地方案

### 3.1 五个 λ → 五个虚队列（drift-plus-penalty）—— 高置信，但改变结果需重验

**核查支持**：Neely 2010《Stochastic Network Optimization》Morgan & Claypool（书目 `supported`）；Ch.4-5 涵盖 drift-plus-penalty 与时间平均约束虚队列（`supported`）；Lindley 更新 `Z_i(t+1)=max(Z_i(t)+g_i(t),0)` 与"均值率稳定⇒约束满足"（`supported`）；O(1/V)–O(V) 权衡（`supported`）。仓库已为**单个**聚合队列实现该机制（`compute_action_lyapunov_objective.m:17/33/44`，三处行号与内容均核查为 `supported`）。

**方案**：把单标量队列拆为**五个**虚队列，各由自身违反量驱动（违反量 `timely/success/deadline/protection/position_violation` 已在 `compute_action_risk_constrained_objective_v4.m:28–32` 算出，核查 `supported`）：
```
Z_i(t+1) = max(Z_i(t) + g_i(t), 0);   λ_i(t) = Z_i(t)/V
每步选 argmin  V·penalty + Σ_i Z_i(t)·g_i(action) − reward
```
- ⚠️ **不要照搬两处标注**：① "Theorem 4.8" 的具体编号被核查为 `unverifiable`（结论正确但编号未能在公开源坐实）——论文中引用时只写"Neely 2010 的 drift-plus-penalty 主性能定理（Ch.4）"，不写具体定理号，除非核对实体书。② "Z_i = V·λ_i" 是**渐近对应**而非逐步严格等式（`partially_supported`）；措辞用"队列积压渐近聚集于 V 倍最优乘子"。
- **诚实框架**：不得声称对偶更新"提升指标"；只声称它"把五个无依据常数换成一个可调 V，并附带冻结权重所缺的可行性/最优性证书"。把冻结-λ 与 drift-plus-penalty 呈现为**同一 Pareto 前沿上的两点**（冻结=高可靠部署点，对偶=单旋钮可调+证书）。
- **权衡**：切换会改变结果，必须**重新验证**；且公平比较要求对 V 与步长做与启发式同等的扫描（否则重复"已调 vs 未调"的混淆）。
- **冗余化简（中置信）**：`deadline` 与 `timely` 重叠 → 测试合并为单一时延队列，若结果不变则**直接删除 `risk_constrained_deadline_lambda`**；`position_violation = pos_risk·protection_violation` → 取消独立 position 队列，令 protection 价格为 `1.60 + 0.75·pos_risk`，把 0.75 重述为**斜率系数**。如此 5 个魔数降为 ~3 个队列 + 可解释斜率。

### 3.2 比值锚定（保留现有数字的最省力方案）—— 高置信

若不做对偶更新，则按 Boyd & Vandenberghe §5.6（`supported`）把五 λ 解释为影子价，**只声称四个比值有意义**（3.20/1.25=2.56、3.20/1.60=2.0、1.60/0.75=2.13），并用**一次约束 RHS 灵敏度扫描**测 ∂(objective)/∂b_i 来坐实比值；绝对尺度由一个 exactness 锚固定（Bertsekas 精确罚：λ≥λ\* 即精确）。这把 5 个无约束自由度降为 4 个可测比值 + 1 个锚。

### 3.3 required_success / required_timely → 标准可靠性档 —— 高置信（类映射须标注为解释）

**核查支持的数值锚**：TS 22.186 三档 90% / 99.99% / 99.999%（`supported`）；TS 22.185 通用 100 ms（`supported`）、预碰撞 20 ms（`supported`）；ETSI EN 302 637-2 CAM `T_GenCamMin=100 ms`、`T_GenCamMax=1000 ms`（逐字 `supported`）；ETSI TR 102 638 预碰撞预警 50 ms（`supported`）；TS 22.186 最严 3 ms（`supported`）；TR 37.885 PRR=R/T，20 m 分箱至 320 m（`supported`）。

**方案**：用**按消息类查表**替代两条仿射曲线，并把 required_timely 与 required_success 统一为同一档（TS 22.186 把可靠性定义为"时延内成功"，`supported`）：

| 类 | required_success / required_timely | deadline | 备注 |
|---|---|---|---|
| NORMAL | 0.90 | 0.100 s（逐包）/ 1.0 s（CAM 陈旧度） | 两种解释二选一并标注 |
| COOPERATIVE | 0.9999 | 0.100 s | 0.18 是 1.8× 工程余量 |
| EMERGENCY | 0.99999 | 0.050 s（ETSI 预碰撞） | 0.070 比三档都松 |

- ⚠️ **必须标注的解释边界**（核查 `partially_supported`）：标准并未定义"normal/cooperative/emergency"类，也未把这些档指派给它们——90% 实为 platooning 最低自动化档、99.999%/3 ms 属 platooning/advanced-driving 最严档而非专指"预碰撞"。**把 0.99999 与 0.050 s ETSI 预碰撞配对是混用了两个标准的不同用例**，论文须写明"类到档为工程解释，非条款"。
- `success_max=0.94` 与高档不兼容：把标准档作为**约束 RHS**存储，把仿真不可达的差额作为**显式 derating 偏移**记录，而非偷偷夹住。
- **风险自适应斜率**（success/timely 的 link/pos/blind_scale）无标准支配（核查方向 medium）：把截距锚到标准档作为 floor，斜率作为"风险之上的自适应余量"策略保留，并归一化使零风险时恰等于标准档。

### 3.4 q_pos 阈值 → 完整性判据 PL>AL —— 中置信（数值需 k/AL 表）

**核查支持**：ESA Navipedia "Integrity"：IR=P(误差>AL)、PL>AL 时宣告不可用（逐字 `supported`）；自动驾驶 IR∈[1e-7,1e-8]/h（`supported`）。

**方案**：绕过 q_pos 直接对已算出的 `coarse_sigma`（`step9_generate_positioning_state_*:168–174`）构造 `PL=k·σ` 并与按类 AL（lane≈1.5 m、road≈5 m）比较；把 piecewise position-risk 与 blind/regime 门统一为 Stanford 图分区。当前 0.75/0.50 经 `s_pos` 映射对应 σ≈0.97 m / 1.65 m，落在已发表自动驾驶 AL 带（0.5–10 m）内——说明现值**与完整性一致**，可作为佐证。
- ⚠️ **绝对禁止**照搬 grounding 的 `k` 数值组合：`k=sqrt(−2 ln IR)`（2D Rayleigh）正确值 3.717/4.799/5.678/6.070；列出的 3.29/4.42/5.33/5.73 是 1D 双侧高斯 `−Φ⁻¹(IR/2)`，二者**不能并存**（核查 `refuted`）。论文须二选一并写明维度（水平 2D 误差通常用 Rayleigh）。
- **诚实caveat**：`s_pos` 权重 0.30 意味 q_pos 还混入 sat/dop/upd 子分数，反演仅在那些子分数饱和时精确——故首选直接对 PL 设阈而非反演 q_pos。

### 3.5 物理层标准锚定 —— 高置信（少数需修正归属）

- **tx_power 23 dBm**：C-V2X Power Class 3（TS 36.101，`supported`）；**noise −94 dBm**：−174+70+10（算术 `supported`，10 MHz BW + 10 dB NF）。两者从 hand-set 升为已接地，文档写明推导。
- **pathloss_los_offset 47 dB**：Friis 1 m@5.9 GHz = 47.8 dB（`supported`），等于 TR 37.885 的 32.4 展开。LOS 指数下夹应改为 **2.0**（自由空间），非 2.1。
- **nlosv_extra_loss**：TR 37.885 §**6.2.1**（核查修正：非 §6.2）单遮挡 μ=5 dB、高遮挡 μ=9 dB，σ=4/4.5 dB（`partially_supported`，数值精确）。建议 `5 + 4·attenuation_norm` 命中两端点。⚠️ 距离项 `15·log10(d)−41` 在 d<**541 m** 时为零（核查修正了 grounding 误写的 80 m），故 V2V 全程取 μ={5,9}。
- ⚠️ **shadow_sigma 3.0/4.0 的归属须修正**（核查 `partially_supported`）：TR 37.885 LOS SF=3 dB 精确；但 **NLOSv 复用 LOS shadowing=3 dB**，4 dB 实为 NLOS 行的 SF 或 NLOSv blockage 对数正态的 σ。论文正确表述应为"LOS/NLOSv SF=3 dB；NLOS SF=4 dB；NLOSv 额外遮挡 σ=4/4.5 dB"，**不要写成"NLOSv SF=4 dB"**。
- **C-V2X 时延常数**（base_access/attempt_gap/mode_overhead）：1 ms TTI + 预留周期结构可引（`partially_supported`），但 **12/14/30 ms 具体值非标准规定**，须作为"受标准结构约束的工程离散化"，表述为整数子帧计数，不可声称"由标准推导"。
- ⚠️ **mm-wave 模型红线**：COST 235（9.6–57.6 GHz）与 FITU-R（10–40 GHz）**不覆盖 5.9 GHz**（核查 `supported` 该警告）。论文**只能**用 ITU-R P.833 MED、Weissberger（230 MHz–95 GHz）、MEL=0.79·f^0.61=2.33 dB/m 作 5.9 GHz 植被衰减依据；COST 235/FITU-R 仅作上下文，否则审稿人会直接挑出。Weissberger 指数为 **0.588**（非部分二手源误印的 0.558）。

### 3.6 VoI / AoI 接地 —— AoI 高置信，VPI 框架高/数值中

- **AoI 惩罚**（`success`/freshness 时间驱动）：用非递减非线性 age-penalty g(Δ)（幂 Δ^a / 指数 e^{aΔ}）替代线性 urgency 项；"交付价值=避免的惩罚 g(Δ+T)−g(Δ)"。核查全部 `supported`：Kaul/Yates/Gruteser INFOCOM 2012（AoI）、Sun et al. IEEE T-IT 2017 vol.63 no.11 pp.7492–7508（g(Δ) 幂与指数形式逐字）、Yates et al. JSAC 2021。代码已有 `age/cap` 与 deadline-pressure 项（`compute_action_chance_risk_aoi_objective.m:106` 核查 `supported`），属"提升既有但未充分使用的机制"。
  - ⚠️ **代码细节核查更正**：urgency 斜率在代码中是 `voi_urgency_scale=0.75`（line 90），grounding 文中写的 0.70 实为 `chance_risk_aoi_voi_bias`（line 89）。报告内部引用以 0.75 为准。
- **VPI 框架**（info_value）：info_value 结构上是 Howard 1966《Information Value Theory》IEEE TSSC 2(1):22–26 的 VPI 权（核查 `supported`）：`VoI=C(state)−C'(state)`，且 `info_value·timely_prob` 恰为"仅当及时交付才兑现的 VoI"。可读取 CV 滤波器已维护的 `trace(P)` 作为不确定性项（P0=diag([4,4,1,1])），免去 voi_bias/scale 调参。**框架高置信、精确减少公式中置信**（需定义 misdecision 成本模型 C(·)）。
- **代价权重 → 无量纲 MRS**：Marler & Arora 2004（`supported` 为方法论文献，加权和需先非量纲化）。把 actual_cost/delay/position/misdecision/relay 重写为 `weight_j = w̃_j/s_j`，特征尺度 s_j 来自场景（deadline、mode_cost）。当前隐含比值 misdecision:delay:relay≈4.7:1.3:1 显式化为偏好比值。**降魔数为可审计比值，但数值仍为陈述偏好**。

### 3.7 GNSS 噪声 std 锚定 —— 低/中置信，引用须谨慎

- 形式可接地：C/N0 跌 → 测距噪声 ×10^(ΔC/N0/20)，经 `s_pos` 仿射桥（σ∈[0.3,3.0] m ↔ [1,0]）换算到 q_pos 扰动幅度。多径占~50% 水平误差用于拆分。严重度斜率用开阔/密林两点拟合（开阔 DRMS~3 m，密林~12–15 m）。
- ⚠️ **引用核查警告**：① "4–5 dB-Hz C/N0 跌"被核查为**误引** Sensors 2022（该文只定性提及 C/N0 多次掉落）——须引森林 GNSS 其他文献（低成本接收机/RTKLIB 研究）。② Sensors 2022 的 DRMS 上界应为 **14.59 m**（非 grounding 写的 8.05 m），8.05 m 仅是 S5 单机值（`partially_supported`）。③ "多径占~50%"是该文综述转述、非原创结论。④ **Kaartinen et al. 2015 标题/期刊被核查错误**（`partially_supported`）：正确为《Accuracy of Kinematic Positioning Using GNSS under Forest Canopies》Forests 6(9):3218–3236——论文中**必须用正确标题**。⑤ PMC3345834 `unverifiable`，不要作为坐实引用。可坐实的：Remote Sensing 2021 13(12):2325 的 12.13/15.11 m（`supported`）、USDA-FS treesearch 68916（`supported`）。

---

## 4. 优先级行动计划

### P0 必须做（直接影响审稿可信度）

1. **术语去过度声称**（`compute_action_risk_constrained_objective_v4.m` / `compute_action_risk_constrained_objective.m` 文件头）：要么实现对偶更新真名为 Lagrangian，要么改名 "weighted soft-penalty score" 并删去最优性/Lagrangian 措辞。**最低成本、最高收益的诚实修复。**
2. **required_timely/required_success 改为按类查表至 TS 22.186 档**（`compute_required_timely_target.m`、`compute_action_risk_constrained_objective_v4.m:76–84`）：存标准档为 RHS，仿真差额记为显式 derating；统一 timely 与 success 语义，消除双计数。必须在论文写明"类→档为工程解释"。**权衡**：改变约束 RHS → 需重跑全部对比实验。
3. **物理层标准引用补全 + 归属修正**（`get_default_step9_params.m:260–266`、`step9_generate_link_state_*:66–67`）：tx/noise/pathloss_offset/los_exponent/nlosv 全部加推导注释；**修正 shadow_sigma 4 dB 的归属表述**；删除任何对 COST 235/FITU-R 作 5.9 GHz 依据的引用。
4. **deadline 重锚**（`get_default_step9_params.m:255–257`）：把 0.50/0.18/0.070 表述为相对标准锚（0.100/0.100/0.050 s）的显式工程余量，不再当作条款值。
5. **修正所有不可照搬的引用细节**（贯穿论文）：不写 "Theorem 4.8"；PL 分位数 k 只取一套并标维度（禁用 refuted 组合）；Kaartinen 2015 用正确标题；C/N0 4–5 dB-Hz 不引 Sensors 2022；删除 PMC3345834。

### P1 强化

6. **五 λ → 五虚队列 drift-plus-penalty**（新增/扩展 `compute_action_lyapunov_objective.m` 至五队列；驱动源改为各自 g_i 而非 `compute_lyapunov_stage_pressure.m` 的聚合压力）：给出可行性/最优性证书。**权衡**：改变结果，需对 V 与步长做与启发式同等扫描后再比较；把两者呈现为 Pareto 两点。
7. **约束去冗余**：合并 deadline+timely 队列测试，若无差则删 `risk_constrained_deadline_lambda`；取消独立 position 队列，0.75 重述为 protection 价格对 pos_risk 的斜率。
8. **q_pos 决策改为 PL>AL 完整性判据**（`compute_piecewise_position_risk.m`、blind/regime 门）：暴露 {AL_lane, AL_road, IR, k} 为命名参数，由其反演 q_pos 切点；现值 0.75/0.50 作一致性佐证。
9. **info_value 接 VPI + trace(P)**（`compute_action_risk_constrained_objective_v4.m:88–96`）：读 CV 滤波器协方差作不确定性项；AoI age-penalty g(Δ) 升为时间主驱动（`compute_action_chance_risk_aoi_objective.m`）。
10. **代价权重重写为无量纲 MRS**（`compute_action_risk_constrained_objective_v4.m:44–48`）：除以场景特征尺度，显式化偏好比值。

### P2 可选

11. **比值锚定灵敏度扫描**：即使保留固定 λ，也用一次 RHS 扫描坐实四个比值（替代 P1.6 的最省力路线）。
12. **GNSS 噪声 std 两点拟合**（`calibrate_forest_scene_params.m:63–64`）：用正确引用的开阔/密林 DRMS 锚定，存文献值于校准 provenance。
13. **nlosv 仿射重锚** `5 + 4·norm`（`calibrate_forest_scene_params.m:56`）使端点等于标准 μ={5,9}。
14. **gnss_severity 0.55/0.45 权重回归**：若有冠层闭合度标注则回归，否则明确标注为融合工程选择。

---

## 5. 诚实边界

以下参数**确实无法从标准/理论推导**，论文必须作为工程选择呈现，并配**敏感性分析**（扫描区间内指标稳定性）：

| 参数族 | 为何不可推导 | 安全论文措辞 |
|---|---|---|
| reward/cost MRS 数值（0.45, 0.12, 0.060, 0.08, 0.20, 0.28, 0.06） | 加权和的偏好比值是陈述偏好，非物理常数；MRS 框架只给形式不给数 | "These are dimensionless marginal-rate-of-substitution preference weights; we report their elicited ratios and a sensitivity sweep, not a derivation." |
| voi_min/max 0.50/1.90、各 *_min/max 夹 | 一旦 VoI=避损则语义为 [min 残值, max 避损]，但具体宽度是饱和/抗积分保护 | "Saturation guards for objective conditioning; semantics follow VPI boundedness, magnitudes are engineering." |
| interference_scale 1.8 及 veg 干扰耦合 | 无植被标准支配干扰缩放；真实机制是 SPS 碰撞模型；植被同时衰减信号与干扰，"植被升干扰"物理上反直觉 | "Abstraction of co-channel interference; ideally replaced by an SPS collision model. We flag the veg-interference coupling as a desensitization proxy, not foliage physics." |
| C-V2X 时延 ms 具体值（12/14/30/45） | 标准只给 1 ms TTI + 预留周期结构，未规定具体 ms | "Engineering discretization of the SPS subframe/HARQ timing; bounded-by not derived-from the standard." |
| pdr_slope 0.9/0.7 | 衰落 BLER 滚降本质经验拟合 | "Empirically fitted sigmoid steepness; only the midpoint is tied to the MCS required-SINR." |
| 定位融合权重（position_weight_*、blockage/blind/env 复合权、CV2X-LOCA 0.55/0.25/0.20 等） | 仅有框架名（CV2X-LOCA），无数值文献；多为传感器融合混合权 | "Sensor-fusion mixing weights following the CV2X-LOCA framework structure; the specific splits are design choices reported with ablation." |
| gnss_severity 0.55/0.45、blind_zone_raw 0.58/0.42 | 特征融合分配，缺标注真值无法回归 | "Feature-fusion weights; inputs and monotone severity→degradation relation are literature-grounded, the split itself is an engineering choice." |
| 类边界阈值（urgency 0.80/0.50、emergency_urgency_threshold） | 合成 urgency 标量上的阈值天然任意 | "Class boundaries on a synthetic urgency scalar; the standards-clean alternative is per-packet message-type tags (CAM/DENM/pre-crash)." |
| CV 滤波器 P0/Q/R/consistency 常数、temporal_len 样本数 | 滤波器调参；窗长是 τ/dt 离散化，缺测量 τ | "Filter tuning and τ/dt window discretization; we report the ordering rationale (multipath faster than scintillation) and a sensitivity sweep." |
| action_rate_multiplier_set、base_rate_*、priority_rate_scale | 有限动作空间设计与生成率设定 | "Finite action-space design parameters reported as scenario configuration." |

**通用安全措辞模板**：对所有 ✎ 工程选择参数，论文统一声明——"This parameter is an engineering design choice; we do not claim a theoretical derivation. We report a one-factor sensitivity sweep over [范围] showing the reported metrics vary by < X within the operating band." 这比强行套一个不成立的引用更经得起审稿。

**最重要的诚实底线**：当前把冻结-λ 打分函数命名为 "Lagrangian" 是过度声称（无对偶更新、权重非对偶变量）。要么真做对偶上升如实称之，要么改名并删最优性措辞——两条都诚实，**现状不诚实**。这是整份报告中优先级最高的单点修复。
