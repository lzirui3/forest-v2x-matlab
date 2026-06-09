# Forest-V2X 参数可信度全量审计（DPP 版 · 当前代码核准）

> 本报告替代旧的 v6-scoped 报告（`parameter_theoretical_grounding_audit_cn.md`），范围扩展到**当前代码全部活动路径**，并以 **drift-plus-penalty（DPP）proposed 方法**为主审计对象。
>
> 生成方式：8 个子系统的代码追踪 + 对抗式引用核验 + 与两份既有文档（旧 v6 审计 / `get_parameter_provenance.m` 注册表）对账。旧审计中已坐实（supported/refuted/unverifiable）的引用结论被**复用**，不重新推导。
>
> 分类法（严格使用）：**Grounded**（可由物理常数/标准直接推导）、**StandardsDerivable**（落入已发布标准区间，但确切数值是区间内工程取点）、**DataCalibrated**（由外部真实数据统计算出）、**EngineeringChoice**（设计偏好，诚实处理是敏感性扫描而非编造引用）、**Structural**（非魔数，而是算法/结构元素，其依据是方法/定理）。
>
> 诚实底线：**绝不为不可约的工程选择编造引用**。把某物标为 EngineeringChoice + 敏感性扫描，比挂一个错误引用更经得起审稿。区分"形式可接地"（仿射结构遵循某框架）与"数值可推导"（绝大多数仿射斜率/截距即使输入是数据校准的，数值本身仍是 EngineeringChoice）。

---

## 1. 执行摘要

### 1.1 关键现状（已直接读码核准，是后续分析的锚点）

1. **当前 proposed 方法是 DPP 调度器**：`run_step9_proposed_method_dpp.m` + `build_dpp_action_tables.m`。它用**时变虚队列** `Z_c(t+1)=min(max(Z_c+g_c,0),dpp_queue_max)`、**单旋钮 V**（O(1/V)–O(V) 权衡，Neely 2010）和**滚动时域 MPC**（`dpp_horizon`）替换了旧的五个冻结 λ=(3.20,2.20,1.25,1.60,0.75)，并把 5 约束合并为 2（reliability + protection）。`legacy5` 仅作消融。

2. **致命接线缺口（headline）**：`run_step9_proposed_method.m:7` —— 文件自称"Paper main method entry point" —— 仍**硬路由到 `run_step9_confidence_driven_risk_constrained_v6`（冻结 λ）**，而非 DPP。所有生产/验证驱动（main_step40/42/44/45/47/49/50/60/62）经此入口跑的都是**旧的冻结-λ v6**；DPP 路径只被 main_step66–75 通过**直接调用** `run_step9_proposed_method_dpp` 触达。**结构修复已存在，但论文主入口未接线到它。**

3. **DPP 惩罚仍复用 v6 的手调权重**：`build_dpp_action_tables.m` 的 `local_penalty` 用**同一套** MRS 权重（actual_cost=0.060、delay=0.08、position_risk=0.20、misdecision=0.28、relay=0.06、reward 0.45/0.12）与**同一套** VoI 仿射常数（bias=0.65 + 斜率 0.70/0.24/0.14/0.28，min/max=0.50/1.90）。结构修复只动了 **λ 乘子**，没动**惩罚内部权重**。

4. **`v2x_reliability_floor_{normal,coop,emergency}`（0.50/0.65/0.80）未在 `get_default_step9_params.m` 定义**，仅以 paramsafe 默认散落在 `get_v2x_reliability_requirements.m:44/48/52` —— 这是 DPP 默认路径上**唯一活跃的 reliability RHS**，却没有审计落点（silent fallback）。

5. **存在一份制造分离的调参文档** `parameter_tuning_analysis_cn.md`：明确记录了把抽象投递权重（base_success_bias、priority bonuses、gate weights）调成当前值，目的是"在方法间制造有意义的性能差异"。代码现值（critical_priority_bonus=0.03、priority_gate_bonus=0.02 等）正是该文档的 **post-tuning 值** —— **重大诚实风险**。

### 1.2 参数计数与"理论来源占比"（两个口径）

口径定义："理论来源占比" = (Grounded + StandardsDerivable + DataCalibrated + Structural) / 全部活动路径参数；分母不含纯数值守卫（1e-6/1e-9 等）与死参数。占比的"诚实分子"**不包含 EngineeringChoice**。

#### A. DPP proposed-method 活动路径（`run_step9_proposed_method_dpp` + 默认 consolidated）

| 分类 | 计数 | 代表参数 |
|---|---|---|
| **Structural** | 5 | dpp_V, dpp_horizon, dpp_queue_max, dpp_constraint_mode, 虚队列更新 |
| **Grounded** | 2 | tx_power_dBm, noise_floor_dBm（PHY，仅 use_physical_delivery=true 时活跃；见注） |
| **StandardsDerivable** | 7 | 3 个 reliability_floor + 3 个 deadline_*_physical + protection-LHS 优先级归一 |
| **DataCalibrated** | 1 | blind_zone_trigger_threshold（forest ROC/Youden） |
| **EngineeringChoice** | ~34 | 7 MRS 惩罚权重 + 7 VoI 仿射常数 + protection-RHS 仿射族（10）+ qpos 阈值（4）+ 抽象投递权重族（~20，条件活跃）+ 2 emergency floor |
| **死/被取代（不计入分母）** | — | voi_scaled RHS+band+cap、legacy5-only timely/success RHS、0.035 死字面量、5 个冻结 λ（DPP 上 deprecated） |

- **DPP 路径核心结构 + 约束 RHS 子集**（剔除条件活跃的抽象投递权重族后）约 **22 个核心参数**：Structural 5 + StandardsDerivable 7 + DataCalibrated 1 + Grounded 2 = **15 有源 vs 7 EngineeringChoice** → **理论来源占比 ≈ 68%**。
- **若把条件活跃的抽象投递权重族（~20 个 EngineeringChoice）计入**（use_physical_delivery=false / PERcurves 缺失的可复现 fallback 路径会激活它们），占比掉到 **≈ 35–40%**。
- **诚实结论**：DPP 的**结构脊柱**（V/horizon/queue/consolidation + 虚队列更新）确实有理论来源，可接地占比在剔除抽象投递层后能到 **~2/3**；但只要跑 fallback 抽象投递，大量 EngineeringChoice 权重重新进入活动路径，占比腰斩。**"绝大多数参数有理论来源"目前在 DPP 核心成立、在含抽象投递的可复现路径上不成立。**

> 注（PHY 双态）：tx_power/noise/pathloss 等 Grounded/StandardsDerivable 的 PHY 参数仅在 `use_physical_delivery=true` 且 PERcurves 存在时活跃；fallback 时改由抽象投递权重族驱动。`get_default_step9_mainline_params.m:10` 设 true，但 `:21` 在 PERcurves 缺失时 fallback 到 false。

#### B. 整体框架（含 v6-legacy / 基线 / 抽象投递 / 定位 / 校准）

| 分类 | 计数（量级） | 占比贡献 |
|---|---|---|
| Grounded | ~4 | tx_power, noise_floor, pathloss_los_offset, los_exponent |
| StandardsDerivable | ~14 | nlosv, nlos_exponent, deadline 三档, reliability 三档/三 floor, priority 归一, base_access 结构 |
| DataCalibrated | ~8 | blind_zone_trigger, pdr_midpoint_los/nlos, cover/attenuation/canopy percentile, forest 校准输入统计 |
| Structural | 5 | DPP 五结构件 |
| **EngineeringChoice** | **~110+** | 全部 MRS/VoI 权重、抽象投递权重族、protection/timely 仿射族、定位融合权、CV 滤波器常数、urgency/类边界、action set、forest 校准的所有映射斜率/截距 |
| **整体理论来源占比** | **≈ 31 / 150+ ≈ 20%** | |

- **整体框架口径下，理论来源占比仅约 1/5**。框架庞大的 EngineeringChoice 尾部主要来自：①抽象投递与门限模型（~20）；②定位置信度融合与 CV 滤波器（~30）；③forest 校准的每一个仿射映射系数（旧审计问题 4：真实数据进去，但每步斜率/截距手选，~20）；④效用启发式基线的全套 `utility_*` 权重（~40，不在 DPP argmin 上但在框架内）。

**给用户的真实数字**：要让"绝大多数参数有理论来源"成立，最高杠杆的路径是 **(a) 把 DPP 接线为默认 proposed（锁定 ~68% 的核心口径）**，**(b) 退役/隔离抽象投递与效用启发式两大 EngineeringChoice 尾部**（它们不在 DPP 核心上），**(c) 把 7 MRS + 7 VoI 权重重写为无量纲 MRS 比值 + 敏感性扫描**（不提升分类，但把"手调魔数"变成"可审计偏好比值"）。

---

## 2. 主 provenance 表（按子系统）

证据强度：Strong / Medium / Weak / None。`result_impact_if_grounded` 指"若改变该参数是否改变调度结果"。

### 2.1 DPP 核心：结构旋钮（`run_step9_proposed_method_dpp.m` / `build_dpp_action_tables.m`）

| 参数 | 值 | active_paths | 分类 | 来源 | 证据 | 结果影响 | grounding action |
|---|---|---|---|---|---|---|---|
| dpp_V | 2.0 | DPP | Structural | Neely 2010 DPP Ch.4-5：单旋钮 O(1/V)–O(V) | Strong | ChangesResults | 保留为唯一原则旋钮；用 main_step68/70/72 的 V-Pareto 扫描证 2.0 操作点；引 Neely Ch.4 主性能定理，**不写具体定理号** |
| dpp_horizon | 1（默认）/3（PDPP main_step67/71/73/74） | DPP | Structural | MPC/滚动时域；H=1 退化为纯 DPP，H>1 看 route-geometry 预览 | Medium | ChangesResults | 把 forecast 框为 route/map 慢状态（不预览随机快衰落，文件头已诚实声明）；扫 H∈{1,2,3} |
| dpp_queue_max | 20.0 | DPP | Structural | Lindley/虚队列封顶 = 最大影子价 | Medium | ChangesResults | 呈现为最大可容影子价；扫 cap（main_step68/72 已做）证均值率稳定 |
| dpp_constraint_mode | "consolidated"（默认）/"legacy5"（消融） | DPP | Structural | TS 22.186 reliability 定义 → timely/success/deadline 合并为单一 reliability，position 折入 protection | Strong | ChangesResults | 默认 consolidated；legacy5 仅消融；引 TS 22.186 reliability 定义 |
| 虚队列更新 Z=min(max(Z+g,0),Zmax) | — | DPP | Structural | Neely Lindley 递归；下界 0 = 非负性，上界 = cap | Strong | ChangesResults | 一句话说明封顶后均值率稳定仍成立 |

### 2.2 DPP 核心：惩罚 MRS 权重 + VoI 仿射常数（DPP 与 v6 **逐字共享**，均手调）

| 参数 | 值 | active_paths | 分类 | 来源（仅形式可接地） | 证据 | 结果影响 | grounding action |
|---|---|---|---|---|---|---|---|
| risk_v4_actual_cost_weight | 0.060 | DPP, v6 | EngineeringChoice | Marler&Arora 2004 加权和需非量纲化（仅方法论） | Weak | ChangesResults | 重写 cost_weight=ratio/s_cost；报偏好比值 + 扫描；**不引物理源**。注：v4 的 0.035 默认是死字面量（永被覆盖） |
| risk_constrained_delay_weight | 0.08 | DPP, v6 | EngineeringChoice | MRS / s_delay=deadline | Weak | ChangesResults | 按 deadline 非量纲化 + 扫描 |
| risk_constrained_position_risk_weight | 0.20 | DPP, v6 | EngineeringChoice | MRS / s_risk=1 | Weak | ChangesResults | 偏好比值 + 扫描 |
| risk_constrained_misdecision_weight | 0.28 | DPP, v6 | EngineeringChoice | MRS（misdecision:delay:relay≈4.7:1.3:1） | Weak | ChangesResults | 显式化偏好三元比值 + 扫描；最大权重，最影响 emergency |
| risk_constrained_relay_penalty_weight | 0.06 | DPP, v6 | EngineeringChoice | MRS numeraire | Weak | ChangesResults | 作三元比值的基准 |
| risk_constrained_success_reward_weight | 0.45 | DPP, v6 | EngineeringChoice | 对 VoI numeraire 的 MRS（Sun 2017 / Marler&Arora） | Weak | ChangesResults | 表为相对 info_value 的 MRS + 扫描 |
| risk_constrained_event_reward_weight | 0.12 | DPP, v6 | EngineeringChoice | 对 VoI numeraire 的 MRS | Weak | ChangesResults | 偏好比值 + 扫描 |
| risk_constrained_voi_bias | 0.65 | DPP, v6 | EngineeringChoice | **形式** = Howard 1966 VPI（info_value·timely_prob 恰为及时交付才兑现的 VPI，supported）；**截距 0.65** 手调 | Medium | ChangesResults | 形式接 Howard VPI（VoI=C−C'）；要接数值需定义 misdecision 成本 C(·) 或读 CV 滤波器 trace(P)（P0=diag([4,4,1,1]））；否则报 bias+斜率为 elicited + 扫描 |
| risk_constrained_voi_urgency_scale | 0.70 | DPP, v6 | EngineeringChoice | Howard VPI 斜率 | Medium | ChangesResults | 报仿射斜率为 elicited + 扫描。**勿与 AoI 调度器的 0.75 混淆（两个独立调度器）** |
| risk_constrained_voi_pos/link/blind_scale | 0.24/0.14/0.28 | DPP, v6 | EngineeringChoice | VPI 斜率 | Weak | ChangesResults | elicited 斜率 + 扫描。注：blind_risk 输入在 DPP（build_dpp:194 `max(gate−thr,0)`）与 v4（v4:24-25）不同，同斜率作用于不同输入 |
| risk_constrained_voi_min/max | 0.50/1.90 | DPP, v6 | EngineeringChoice | VPI 有界性（残值下限/避损上限），数值为 conditioning/anti-windup | Weak | Unknown | 表为饱和守卫（"objective conditioning；语义随 VPI 有界，数值为工程"），不作接地值 |

### 2.3 约束 RHS：reliability 档/floor、protection、position（活动于 DPP）

| 参数 | 值 | active_paths | 分类 | 来源 | 证据 | 结果影响 | grounding action |
|---|---|---|---|---|---|---|---|
| reliability 三档 0.90/0.99990/0.99999 | — | DPP（默认仅诊断，VoI ceiling 被 gated off） | StandardsDerivable | TS 22.186 三档（verbatim，supported） | Strong | None（默认路径仅 req.derating 诊断） | 引 TS 22.186；class→tier 映射是**工程解释**（文件头/honesty boundary 已声明） |
| v2x_reliability_floor_normal | 0.50 | DPP（**绑定 RHS**） | StandardsDerivable | TS 22.186 90% 档**减 derating**到仿真可达 floor | **Medium**（非 Strong） | Unknown | **加入 get_default**；档=标准、derating=工程取点，报 derating 缺口 + 扫描 |
| v2x_reliability_floor_coop | 0.65 | DPP（绑定 RHS） | StandardsDerivable | TS 22.186 99.99% 档减 derating | **Medium** | Unknown | 同上 |
| v2x_reliability_floor_emergency | 0.80 | DPP（绑定 RHS） | StandardsDerivable | TS 22.186 99.999% 档减 derating | **Medium** | Unknown | 同上 |
| deadline_standard 0.050/0.100/0.100 | — | **死输出**（无消费者） | StandardsDerivable | ETSI TR 102 638 50ms / TS 22.185-186 100ms | Strong | None | 文档字段；或接为 deadline RHS source-of-truth。活动 deadline 是 deadline_*_physical |
| utility_required_protection_base | 0.00 | DPP, v6, 基线 | EngineeringChoice | 仿射截距（=0 故惰性） | None | None | 报为仿射基线 |
| utility_required_protection_pos_scale | 0.55 | DPP, v6, 基线 | **EngineeringChoice**（非 StandardsDerivable） | **形式**接 GNSS 完整性 PL>AL；**斜率 0.55 不可推导** | **Weak** | ChangesResults | **修正注册表的 StandardsDerivable/Medium 过度声称**；只 form 可接地，number 工程；或在 coarse_sigma 上重建 PL=k·σ vs AL 让斜率自然落出 |
| utility_required_protection_blind/urgency/link_scale | 0.35/0.12/0.10 | DPP, v6, 基线 | EngineeringChoice | 无标准支配 | None | ChangesResults | 扫描 |
| utility_required_protection_activation_pos/blind | 0.45/0.22 | DPP, v6, 基线 | EngineeringChoice | 死区参考点；形式可接 AL 越限 | Weak/None | ChangesResults | 扫描；若在 coarse_sigma 重建可接 AL |
| utility_required_protection_pos/blind_shape | 1.35/1.20 | DPP, v6, 基线 | EngineeringChoice | 幂律凸性指数，无标准 | None | ChangesResults | 扫描 |
| utility_required_protection_min/max | 0.08/0.82 | DPP, v6, 基线 | EngineeringChoice | 饱和守卫 | None | ChangesResults | 表为 conditioning 守卫 + 扫描 |
| utility_required_timely_qpos_high/low_threshold | 0.75/0.50 | **DPP 活跃**（经 compute_piecewise_position_risk）, v6, 基线 | EngineeringChoice | 形式接 Stanford/PL>AL；0.75/0.50→σ≈0.97/1.65m 落入已发表 AV AL 带（**一致性佐证，非推导**） | Weak | ChangesResults | **改名**（误挂 timely 前缀，实为 position-risk 阈值）；扫描；或由 PL>AL 反演（避开 refuted 的 k-组合） |
| utility_required_timely_qpos_mid/low_scale | 0.50/1.00 | DPP 活跃, v6, 基线 | EngineeringChoice | 分段形状常数 | None | ChangesResults | 扫描 |
| **utility_required_timely_* 仿射族**（bias 0.18 + 斜率 0.34/0.20/0.16/0.14 + clamp 0.25/0.92） | — | **DPP 上死**（仅 legacy5 + v6 + 基线） | EngineeringChoice | 应由 TS 22.186 档查表替代（DPP 已用 get_v2x_reliability_requirements 替代） | Weak/None | ChangesResults | DPP 上 superseded；v6 上 EngineeringChoice + 扫描；max=0.92 与高档不兼容（同 floor/derating 问题） |
| blind_zone_trigger_threshold | 0.55（forest 覆盖 0.50） | DPP, v6, 基线 | **DataCalibrated** | step43 ROC/Youden 对 forest 高遮挡标签（NLOS/PDR≤0.70/delay>deadline） | Medium | ChangesResults | **本子系统唯一真正的 DataCalibrated**；引 ROC/Youden 标定 + percentile provenance |
| compute_action_protection_level 复合权 0.30/0.35/0.35; mode_level 1.0/0.62/0.20 | — | DPP（LHS）, v6 | EngineeringChoice | 优先级归一 (p-1)/2 是 StandardsDerivable（3 级动作空间）；复合权/序数 level 工程 | None | ChangesResults | 优先级归一引动作空间；复合权 + 序数扫描 |

### 2.4 动作-投递抽象模型（`evaluate_action_metrics` / `simulate_step9_delivery` / `predict_action_*`）—— 条件活跃，全 EngineeringChoice

> **双态**：use_physical_delivery=false（get_default）或 PERcurves 缺失（mainline fallback）→ 抽象分支活跃于 DPP 平滑测试/消融/可复现 fallback；use_physical_delivery=true 且 PERcurves 存在 → physical 分支，整个抽象 bonus/gate 族**死**。**故须按"可复现/fallback 必活跃"对待，绝非平凡死参。**

| 参数 | 值 | 分类 | 证据 | 诚实风险标记 |
|---|---|---|---|---|
| base_success_bias | -0.02 | EngineeringChoice | None | **tuning 文档显式列出**（制造分离） |
| critical_priority_bonus | 0.03 | EngineeringChoice | None | **post-tuning 值**（0.08→0.03）；触发不一致：success 用 urgency≥0.80，delivery 用 msg_type=='emergency' |
| redundant_success_bonus | 0.10 | EngineeringChoice | Weak | 形式应为 1−(1−p)^k 分集增益；加性近似 |
| relay_success_bonus | 0.15 | EngineeringChoice | Weak | physical 模型用 relay_sinr_offset 等接地，抽象 0.15 是其未接地影子；**tuning 文档列出** |
| position_risk_penalty | 0.14 | EngineeringChoice | None | **无信道理由**让定位置信降 PDR；与 protection 约束**双计数风险**；**tuning 文档列出** |
| abstract_priority_bonus_per_level | 0.05 | EngineeringChoice | None | physical 路径由 priority_sinr_gain 承担 |
| abstract_rate_bonus_scale | 0.03 | EngineeringChoice | None | **符号异常**：物理上高 rate 通常降可靠性；且两消费者参数不一致（planning vs delivery，潜在 bug） |
| abstract_confidence_protection_high/mid/direct | 0.14/0.08/0.04 | EngineeringChoice | None | 单调结构合理，绝对值手选 |
| emergency_gate_reduction | 0.03 | EngineeringChoice | None | **post-tuning**（0.04→0.03，文档曾提议 0.00） |
| link/pos/urgency_gate_weight | 0.48/0.16/0.08 | EngineeringChoice | None | **gate 主导项 0.48 被 tuning 文档显式调以设 gate 水平** |
| mode_gate_bonus / priority_gate_bonus | 0.10 / 0.02 | EngineeringChoice | None | priority_gate_bonus 是 **post-tuning**（0.06→0.02） |
| base_delay / link_delay_scale / *_delay_penalty | 0.05/0.45/0.08/0.12 | EngineeringChoice | None/Weak | 抽象延迟模型；planning leg only |

### 2.5 PHY（`get_default_step9_params.m` / `step9_generate_link_state_*`）—— 仅 physical 路径活跃

| 参数 | 值 | 分类 | 来源 | 证据 |
|---|---|---|---|---|
| tx_power_dBm | 23.0 | Grounded | C-V2X Power Class 3（TS 36.101） | Strong |
| noise_floor_dBm | -94.0 | Grounded | -174+10log10(10e6)+10dB NF | Strong |
| pathloss_los_offset_dB | 47.0 | Grounded | Friis 1m@5.9GHz=47.8dB（=TR 37.885 LOS 截距） | Strong |
| pathloss_los_exponent | 20.0 | Grounded/StandardsDerivable | n_LOS=2.0 自由空间/TR 37.885 highway-LOS | Strong |
| pathloss_nlos_exponent | 24.0 | StandardsDerivable | n_NLOS∈[2.7,3.9] TR 38.901 RMa-NLOS（夹端） | Medium |
| nlosv_extra_loss_dB | 5.0（calib 3.5+3.5·norm） | StandardsDerivable | TR 37.885 **§6.2.1** μ=5/9dB σ=4/4.5dB | Strong |
| fast_fading_sigma_los/nlos | 2.0/5.0 | StandardsDerivable | Rician K≈3dB / Rayleigh dB-spread（TR 37.885 / Molisch Ch.7） | Medium |
| pdr_midpoint_los/nlos | 4.0/6.0 | DataCalibrated | MCS 所需 SINR（WiLabV2Xsim PER 拟合） | Medium |
| pdr_slope_los/nlos | 0.9/0.7 | EngineeringChoice | 经验 sigmoid 陡度 | Weak |
| interference_scale | 1.8（calib 1.6+0.7·veg） | EngineeringChoice | 无标准；理想用 SPS 碰撞模型 | Weak |
| base_access_delay / mode_overhead_* / attempt_gap | 0.012/0.012/0.030/0.014 | StandardsDerivable（形式）/ EngineeringChoice（数值） | 1ms TTI + 预留周期结构；具体 ms 非标准规定 | Medium |
| congestion_delay_max | 0.045 | EngineeringChoice | 裸幅值 | Weak |
| priority_sinr_gain / emergency_sinr_bonus | 0.5/1.0 | EngineeringChoice | 资源优先级增益 | Weak |
| relay_sinr_offset/hop2/nlos_to_los_prob | 2.5/1.5/0.35 | EngineeringChoice | 两跳几何/空间分集 | Weak |
| deadline_*_physical | 0.50/0.18/0.070 | StandardsDerivable | 相对标准锚（100/100/50ms）的显式工程余量 | Medium/Strong |

### 2.6 定位/置信度融合 & forest 校准 —— 大部分 EngineeringChoice（输入 DataCalibrated）

| 参数族 | 值 | 分类 | 说明 |
|---|---|---|---|
| position_weight_gnss/rsu/env/traj | 0.45/0.22/0.15/0.18 | EngineeringChoice | CV2X-LOCA 仅框架名，无数值文献 |
| position_alpha_*（base/delta/traj/blind/min/max） | 多值 | EngineeringChoice | 自适应 EWMA 调参 |
| position_gnss_independent/multipath_noise_std | 0.08/0.12（+sev） | EngineeringChoice（形式可接地） | C/N0 跌→测距噪声桥；**引用须谨慎**（4–5dB-Hz 误引 Sensors 2022） |
| gnss_independent/multipath_temporal_len | 12/8 | EngineeringChoice（形式可接地） | 窗=τ/dt；多径<慢偏序正确（一阶 GM，supported） |
| cover/attenuation/canopy_density_norm percentile | p75/p99 | **DataCalibrated** | 真实栅格/点云 percentile（已 data_calibrated） |
| calibrate 全部仿射映射（gnss_severity=0.55cover+0.45canopy, alpha_los=2.1+0.45curv+0.30cover, nlosv=3.5+3.5norm, /60, /0.08 锚） | 多值 | EngineeringChoice | **旧审计问题 4**：真实数据进去，每步斜率/截距/归一化除数手选；端点可锚标准，内部斜率工程 |
| CV 滤波器 P0/Q/R/consistency（diag([4,4,1,1]) 等） | 多值 | EngineeringChoice | 滤波器调参 |
| meters-per-degree | 111320 | Grounded | 标准大圆 m/deg |

### 2.7 场景/动作空间 & AoI 调度器

| 参数 | 值 | 分类 | 说明 |
|---|---|---|---|
| action_priority_set / mode_set | [1,2,3]/[0,1,2] | StandardsDerivable | 3 级 C-V2X 优先级 / direct-redundant-relay |
| action_rate_multiplier_set | [1.0,1.35,1.7,2.1,2.5] | EngineeringChoice | 有限动作空间设计 |
| priority_rate_scale | [1.0,1.5,2.0] | EngineeringChoice | 每优先级最小速率参考 |
| tx_cost_direct/redundant/relay | 1.0/1.6/1.8 | StandardsDerivable（基准）/EngineeringChoice（相对值） | 归一化基准 1.0 |
| urgency_normal/coop/emergency | 0.30/0.60/0.95 | EngineeringChoice | 合成序数；标准-clean 替代=消息类标签 |
| utility_emergency_urgency_threshold | 0.80 | EngineeringChoice | 类边界；介于 0.60/0.95；**IS 定义于 get_default:190** 但 DPP/v6 又有 paramsafe 0.80 fallback |
| chance_risk_aoi_voi_urgency_scale | 0.75 | EngineeringChoice | AoI 调度器；**≠ DPP/v4 的 0.70**（两独立调度器，旧审计 sec3.6 已澄清） |
| AoI age 项 = age/cap（cap=aoi_age_norm_cap=8.0） | 线性后夹 | **EngineeringChoice / 待 Structural 化** | 当前是**线性** age/cap，**非** Sun 2017 的非线性 g(Δ)（幂/指数）；接地动作仍 OPEN（见 §4） |
| risk_v6_emergency_min_priority / min_rate_multiplier | 3 / 2.1 | EngineeringChoice | 安全 floor；2.1=rate_set 第 4 项、3=priority_set 顶（**魔数耦合**，应绑 grid 索引） |

---

## 3. 自旧 v6 审计以来"发生了什么变化"

### 3.1 已被 DPP 调度器解决的旧问题（引代码）

- **旧问题 1（最严重：冻结-λ "Lagrangian" 无可行性/最优性证书，绝对值无依据）—— 结构上已解决**。`run_step9_proposed_method_dpp.m:66,157,204` 用 `J=V·penalty+Z·g` 替换冻结加权和；`run_step9_proposed_method_dpp.m:111,158,164` 实现 `Z=min(max(Z+g,0),Zmax)` 虚队列；单旋钮 V（setdefault 2.0）带 O(1/V)–O(V) 证书。**但仅在 DPP 路径上解决，v6 入口仍 live（见 §4 接线缺口）。**
- **旧问题 2（required_timely / required_success 双计数 TS 22.186 可靠性）—— 在 consolidated 模式下已解决**。`build_dpp_action_tables.m:79-83` 的 cset 只含 {reliability, protection}；reliability RHS 改由 `get_v2x_reliability_requirements.m` 单一来源给出（合并 timely+success+deadline）。旧的 timely/success 两条仿射在 DPP 默认路径上**死**（仅 legacy5 消融保留）。
- **旧问题 5（约束冗余）—— 部分解决**。5→2 合并把 position 折入 protection、timely/deadline 折入 reliability，自由度从 5 降到 2。

### 3.2 仍然 OPEN 的旧问题

- **旧问题 3（q_pos 当度量量用，应 PL>AL）—— 仍 OPEN**。`compute_piecewise_position_risk.m:4-7` 仍对无量纲 q_pos 设阈 0.75/0.50，**在 DPP 路径上活跃**（喂 protection RHS + 惩罚）。coarse_sigma 已算但未用于完整性判据。
- **旧问题 4（forest 校准映射系数手选）—— 仍 OPEN**。`calibrate_forest_scene_params.m:47-69` 全部仿射斜率/截距/归一化除数仍手选（gnss_severity=0.55cover+0.45canopy 等），仅 percentile 统计是真数据。
- **MRS/VoI 权重接地 —— 仍 OPEN**。DPP 惩罚逐字复用 v6 的 7 MRS + 7 VoI 手调权重（§2.2）。旧审计 rows 66-73、sec3.6、honesty boundary 措辞**逐字适用**于 DPP 惩罚。
- **AoI 非线性 age-penalty —— 仍 OPEN**。当前 age 项是线性 `age/cap`（`compute_action_chance_risk_aoi_objective.m:104-106`），尚未升为 Sun 2017 的非线性 g(Δ)。

### 3.3 旧文档现已 STALE 之处

- **`get_parameter_provenance.m:52` 列 dpp_V=1.0**，live 默认是 **2.0**（setdefault）；且**遗漏** dpp_horizon/dpp_queue_max/dpp_constraint_mode；只列 2/5 个 λ、2/14 个惩罚/VoI 权重；registry 覆盖 <30 参数，与 DPP 代码不同步。
- **`get_parameter_provenance.m:49-51`** 把三个 reliability_floor 标 **StandardsDerivable/Strong** —— 应降为 **Medium**（档=标准、derating=工程取点）。
- **`get_parameter_provenance.m:57`** 把 `utility_required_protection_pos_scale=0.55` 标 **StandardsDerivable/'GNSS-integrity (PL>AL) shaped'/Medium** —— **过度声称**，应改 **EngineeringChoice/Weak**（PL>AL 只接 form，不接斜率）。这是注册表在 protection 族唯一的越级提升，过于慷慨。
- **旧审计 `parameter_theoretical_grounding_audit_cn.md`** 是 v6-scoped：把 5 个 λ 当 live 讨论。在 DPP 设计下它们 deprecated（但因接线缺口仍 live via v6）。其 MRS/VoI 裁决（rows 66-73、lines 252-253）仍**逐字适用**于 DPP 惩罚（权重未变）—— **复用，不重derive**。
- 旧审计 sec3.6 line 208 修正的是 `run_step9_chance_risk_aoi_scheduler` 的 voi_urgency_scale=0.75；DPP/v4 路径是 0.70。**0.70 vs 0.75 是两个独立调度器的真实差异，勿混淆。**

---

## 4. 结构 / 接线问题（专章）

### 4.1 接线缺口（headline，最高杠杆）

`run_step9_proposed_method.m:7` 硬路由 `result = run_step9_confidence_driven_risk_constrained_v6(scenario, params);`。文件头自称"Paper main method entry point"，但跑的是**冻结-λ v6**。后果：

- main_step40/42/44/45/47/49/50/60/62 全部经此入口 → 跑旧方法。
- DPP 只被 main_step66–75 通过**直接调用** `run_step9_proposed_method_dpp` 触达（已核实：10 个 main_step66-75 直调 DPP；10+ 个 main_step40-60 调非-DPP proposed）。
- **"已改进的方法"不是论文主入口当前跑的方法。** 这是让 §1.2 的"理论来源占比"在生产路径上**塌缩**的根本原因。

### 4.2 `v2x_reliability_floor_*` 缺定义（silent fallback）

0.50/0.65/0.80 仅以 paramsafe 默认存在于 `get_v2x_reliability_requirements.m:44,48,52`，**未在 get_default_step9_params.m 定义**。它们是 DPP 默认路径上**唯一绑定的 reliability RHS**，却无审计落点 —— 任何传入的 params 静默继承硬编码默认。

### 4.3 惩罚 MRS 权重 & VoI 常数仍手调（在 DPP 内）

结构修复动了 **λ 乘子**，没动**惩罚内部** 7 MRS + 7 VoI 权重（§2.2）。它们与 v6 逐字共享，仍是手调魔数。

### 4.4 双计数 / 死参数 / 默认漂移

- **双计数（仅 legacy 路径）**：required_timely 与 required_success 两条仿射都编码同一 TS 22.186 量；DPP consolidated 已修，但 v6 入口仍 live 此双计数。
- **position_risk_penalty 跨子系统双计数风险**：抽象投递里 position 置信降 PDR，与 protection 约束、utility_weight_position_risk 重叠。
- **死分支/死参**：① `dpp_reliability_voi_scaled` 默认 false 且无处置 true → 整个 VoI-scaled RHS 分支（+`dpp_reliability_band` 0.30 +`dpp_reliability_reachable_cap` 0.97）死；② legacy5-only 的 required.timely/required.success + 7 个 success-RHS 参数在默认 consolidated 路径死；③ `risk_v4_actual_cost_weight` 的 0.035 字面量是死字面量（永被 0.060 覆盖）；④ `req.deadline_standard` 是死输出（无消费者）。
- **默认双定义漂移**：dpp_* 与 3 个 emergency/cost 默认在 `run_step9_proposed_method_dpp.m:215-237` 与 `build_dpp_action_tables.m:48-70` **逐字重复**；risk_v4_actual_cost_weight 还有第三处 0.035 已不一致。
- **魔数耦合**：risk_v6_emergency_min_rate_multiplier=2.1 / min_priority=3 是 action_rate_multiplier_set/action_priority_set 条目的静默引用；集合变了会静默错引。
- **VoI 输入跨路径不一致**：blind_risk 喂同一 voi_blind_scale，DPP（build_dpp:194）与 v4（v4:24-25）算法不同 → 同权重作用于不同输入。

---

## 5. 过度声称 & 引用错误（合并自全部核验，附 paper-safe 措辞）

| # | 问题 | 位置 | 修正 / paper-safe 措辞 |
|---|---|---|---|
| 1 | 冻结加权和命名 "Lagrangian"（无对偶更新、权重非 KKT 对偶） | `compute_action_risk_constrained_objective_v4.m` 头 + `lagrangian_penalty` 术语；`compute_action_risk_constrained_objective.m` 同 | 改名 "weighted soft-penalty score"，删最优性措辞。**最高优先级诚实修复**（DPP 文件头已正确加引号 'Lagrangian'） |
| 2 | reliability_floor 0.50/0.65/0.80 标 Strong | `get_parameter_provenance.m:49-51` | 降 Medium。"使用 TS 22.186 X 档，derate 到操作 floor；derating 缺口作为工程选择公开报告并附扫描，非标准值。" |
| 3 | pos_scale=0.55 标 StandardsDerivable/GNSS-integrity | `get_parameter_provenance.m:57` | 改 EngineeringChoice/Weak。"protection RHS 遵循 GNSS 完整性结构（风险越限即高保护），但仿射斜率含 0.55 是工程选择 + 扫描；只 form 接地，magnitude 不接地。" |
| 4 | 标准引述过度："reliability = 时延 **AND 通信范围**内成功接收" | `get_v2x_reliability_requirements.m:10-14` | TS 22.186 reliability 是 latency-centric（时延界内成功率）；"AND range" 属 TR 37.885 PRR 框架。收紧为"在时延界内成功投递…（在更广 V2X 可靠性框架中亦含通信范围）"。下游逻辑（timely==reliability）成立 |
| 5 | class→tier→deadline 三元配对当条款 | `get_v2x_reliability_requirements.m` | 保留 honesty boundary：class{normal,coop,emergency}→tier 是工程解释，非 TS 22.186 条款；0.99999 配 0.050s ETSI 预碰撞是混用两标准用例 |
| 6 | 抽象投递权重为"制造方法分离"而调 | `parameter_tuning_analysis_cn.md` 记录的 base_success_bias/critical_priority_bonus/gate weights | **最严重诚实风险**：论文不可呈现"性能差异"为方法优越性证据，除非改用 physical PDR（use_physical_delivery=true）或公开声明抽象投递仅作 smoke test。删除/隔离该 tuning 文档的结论 |
| **不可照搬的旧引用**（贯穿论文，旧审计已坐实，继续生效） | | | |
| 7 | PL k-分位数组合 k=√(−2lnIR) 配 3.29/4.42/5.33/5.73 **自相矛盾** | refuted | 2D-Rayleigh 正确值 3.717/4.799/5.678/6.070；3.29/4.42/5.33/5.73 是 1D 双侧高斯。**二选一并标维度**（水平 2D 用 Rayleigh），勿照搬混合组合 |
| 8 | "Theorem 4.8" unverifiable | — | 写"Neely 2010 drift-plus-penalty Ch.4 主性能定理"，不写定理号 |
| 9 | COST 235 / FITU-R 作 5.9GHz 植被衰减依据 | 红线 | 只用 ITU-R P.833 / Weissberger（230MHz–95GHz, 指数 **0.588** 非 0.558）；COST235/FITU-R 不覆盖 5.9GHz |
| 10 | Kaartinen 2015 标题/期刊错 | — | 正确："Accuracy of Kinematic Positioning Using GNSS under Forest Canopies", Forests 6(9):3218-3236 |
| 11 | C/N0 "4–5 dB-Hz 跌" 误引 Sensors 2022；DRMS 上界应 14.59m 非 8.05m；"多径占~50%" 是综述转述；PMC3345834 unverifiable | — | 用正确森林 GNSS 文献；可坐实 Remote Sensing 2021 13(12):2325 的 12.13/15.11m、USDA-FS treesearch 68916 |

---

## 6. 分阶段行动计划（按杠杆排序，标 [SAFE] / [STRUCTURAL]）

### P0 —— 最高杠杆，先做

1. **[SAFE] 术语去过度声称**：`compute_action_risk_constrained_objective_v4.m` / `compute_action_risk_constrained_objective.m` 头部 + `lagrangian_penalty` → "weighted soft-penalty score"，删最优性措辞。无结果变化，最高诚实收益。
2. **[SAFE] 定义 3 个 v2x_reliability_floor_ 到 get_default_step9_params.m**（值取当前 effective 0.50/0.65/0.80，**不改数值**）+ derating 注释。消除 silent fallback。
3. **[SAFE] 修正注册表/引用细节**：`get_parameter_provenance.m` 把 floor 降 Medium、pos_scale 改 EngineeringChoice/Weak、dpp_V 改 2.0、补 dpp_horizon/queue_max/constraint_mode；收紧 reliability "AND range" 引述；全文修正 refuted k-组合 / Theorem 4.8 / COST235 / Kaartinen / Sensors 2022 引用。
4. **[SAFE] 隔离 tuning 文档结论**：明确声明抽象投递权重仅作 smoke test，不作方法分离证据；论文主结果用 physical PDR。
5. **[STRUCTURAL] 把 DPP 接线为默认 proposed 方法**：`run_step9_proposed_method.m:7` 路由到 `run_step9_proposed_method_dpp`（或加开关）。**改变全部生产/验证结果，需对 V/cap/horizon 做与基线同等扫描后重跑**。这是让"理论来源占比"在生产路径成立的根本前提。

### P1 —— 强化接地

6. **[STRUCTURAL] 把 7 MRS 惩罚权重重写为无量纲 MRS**（`build_dpp_action_tables.m:179-183,167-168`）：weight_j=ratio_j/s_j，s_j 来自场景（deadline、mode_cost）；显式化 misdecision:delay:relay 偏好比值 + 扫描。**不改分类但把魔数变可审计比值；若 s_j 引入会改结果，需重验。**
7. **[STRUCTURAL] q_pos 决策改 PL>AL 完整性判据**（`compute_piecewise_position_risk.m`）：暴露 {AL_lane, AL_road, IR, k} 命名参数，由 coarse_sigma 反演切点；现值 0.75/0.50 作一致性佐证（**避开 refuted k-组合**）。
8. **[STRUCTURAL] protection RHS 在 coarse_sigma 上重建为 PL=k·σ vs AL**，让 pos_scale 等斜率自然落出（替代手选 0.55）。
9. **[STRUCTURAL] info_value 接 Howard VPI + CV 滤波器 trace(P)**（`build_dpp_action_tables.m:235-242`）：读 P 协方差作不确定性项，免 voi_bias/scale 调参；定义 misdecision 成本 C(·)。
10. **[STRUCTURAL] AoI age-penalty 升为非线性 g(Δ)**（`compute_action_chance_risk_aoi_objective.m:104-106`）：现 age/cap 线性 → Sun 2017 幂/指数 g(Δ)，交付价值=g(Δ+T)−g(Δ)。

### P2 —— 卫生与可选

11. **[SAFE] 消死参/去重**：删 voi_scaled RHS 分支（+band+cap）、legacy5-only success-RHS 7 参、0.035 死字面量、deadline_standard 死输出（或接为 RHS）；合并 dpp_* 双定义到单一来源；emergency floor 绑 grid 索引。
12. **[SAFE] 改名误挂前缀**：utility_required_timely_qpos_* → position-risk 前缀（实为定位风险阈值，活跃于 DPP protection）。
13. **[STRUCTURAL] forest 校准两点拟合**（`calibrate_forest_scene_params.m:62-64`）：用正确引用的开阔/密林 DRMS 锚定 GNSS 噪声斜率；端点锚标准、内部插值明确为工程。
14. **[SAFE] nlosv 仿射重锚** `5+4·norm`（calibrate:56）使端点=标准 μ={5,9}。

---

## 7. 诚实边界：应做敏感性扫描而非引用的不可约 EngineeringChoice

以下参数族**确实无法从标准/理论推导数值**，论文必须作为工程选择呈现 + 敏感性分析。**通用安全措辞模板**：

> "This parameter is an engineering design choice; we do not claim a theoretical derivation. We report a one-factor sensitivity sweep over [range] showing the reported metrics vary by < X% within the operating band."

| 参数族 | 为何不可推导 | 安全措辞 |
|---|---|---|
| 7 MRS reward/cost 权重（0.45,0.12,0.060,0.08,0.20,0.28,0.06） | 加权和偏好比值是陈述偏好，非物理常数；MRS 框架只给形式不给数 | "dimensionless MRS preference weights; we report elicited ratios + sensitivity sweep, not a derivation." |
| 7 VoI 仿射常数（bias 0.65 + 斜率 0.70/0.24/0.14/0.28 + min/max 0.50/1.90） | VPI 框架接 form，截距/斜率/夹是 conditioning | "form follows Howard VPI; intercept/slopes/saturation guards are engineering, reported with a sweep." |
| protection-RHS 仿射族（slopes/activation/shape/min/max） | 仿射作用于无量纲 q_pos，非 PL=k·σ vs AL | "affine-on-state form inspired by GNSS integrity; magnitudes are engineering, reported with sweeps." |
| qpos 阈值 0.75/0.50/0.50/1.00 | 无量纲 q_pos 分区切点 | "integrity-inspired partition; cut points engineering, cross-checked vs published AV alert-limit bands." |
| 抽象投递 bonus/gate 全族（~20） | 无信道/标准支配；理想用 physical PDR | "abstract delivery surrogate for smoke tests; production results use the physical SINR→PDR curve." |
| 定位融合权 / CV 滤波器 P0/Q/R / temporal_len | 仅框架名 CV2X-LOCA，无数值文献；滤波器调参 | "sensor-fusion mixing weights / filter tuning; ordering rationale + sweep." |
| forest 校准仿射映射系数 | 真实数据进、每步斜率/截距/除数手选 | "data inputs are real percentiles; the mapping coefficients are engineering interpolation, reported with ablation." |
| 类边界 urgency 0.80/0.50/0.30/0.60/0.95 | 合成 urgency 标量上的阈值天然任意 | "class boundaries on a synthetic urgency scalar; standards-clean alternative is message-type tags (CAM/DENM/pre-crash)." |
| interference_scale 1.8 + veg 耦合 | 无标准；"植被升干扰"反直觉 | "co-channel interference abstraction; ideally an SPS collision model." |
| pdr_slope 0.9/0.7 / C-V2X 时延 ms 值 | 经验拟合 / 1ms TTI 结构外的具体 ms | "empirically fitted; only midpoint / TTI structure tied to standard." |
| action_rate_set / base_rate / priority_rate_scale | 有限动作空间设计 | "finite action-space design parameters reported as scenario configuration." |

**最重要的诚实底线**（沿用旧审计）：把冻结-λ 打分命名 "Lagrangian" 是过度声称 —— DPP 已用虚队列真正实现 drift-plus-penalty，但 v6 入口仍 live；要么接线 DPP 为默认、要么在 v6 上改名，现状不诚实。这仍是整份报告优先级最高的单点修复。
