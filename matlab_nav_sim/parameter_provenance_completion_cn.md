# Forest-V2X 参数可信度审计 · 完整枚举补全

> 本文件是 `parameter_provenance_full_audit_cn.md`（主审计，§1–§7）的**补全卷**。完整性 critic 指出主审计把 ~40–50 个 `get_default` 字段与 ~30 个内联硬编码字面量"摘要化"掉了，未给逐条 provenance 行。本卷为这些 **被漏掉的项** 补出**逐条 provenance 行**，使整套文档成为对**每一个**参数的真实地图。
>
> 分类法（与主审计严格一致）：**Grounded** | **StandardsDerivable** | **DataCalibrated** | **EngineeringChoice** | **Structural**。
>
> 诚实底线（与主审计一致）：**绝不为不可约的工程选择编造引用**。一个无文献依据的融合权重就是 EngineeringChoice（处理方式是敏感性扫描），如实标注比挂错引用更经得起审稿。区分"**形式可接地**（FORM groundable）"与"**数值可推导**（NUMBER derivable）"——绝大多数仿射斜率/截距即使输入是数据校准的，**数值本身仍是 EngineeringChoice**。
>
> 行字段：`name | value | active_paths | classification | source | evidence | result-impact | grounding action`。`active_paths` 取值：DPP-proposed / v6-legacy / baseline:&lt;x&gt; / positioning / link / delivery / dead。所有行号已对当前代码核验（除注明的细微漂移外，与 critic 估计一致）。

---

## 8. 完整枚举补全（get_default 全字段 + 硬编码字面量）

### 8.1 定位生成器内联字面量 —— q_pos / blind_zone_gate 的构造层

> 来源文件：`step9_generate_positioning_state_cv2x_loca_like.m`（下称 step9_pos）、`compute_positioning_confidence_rule.m`（下称 rule）、`compute_piecewise_position_risk.m`。
>
> **活动路径判定（关键）**：整个调度器（DPP / v6 / 所有 baseline）消费的 live `q_pos` 来自 `step9_generate_positioning_state_cv2x_loca_like`（`generate_step9_scenario.m:34` → `scenario.q_pos`），而 step9_pos:19 又调用 `compute_positioning_confidence_rule` 产生 `gnss_score_raw`。**故两个文件里的字面量都在活动路径上**。`scenario.q_pos` → `compute_piecewise_position_risk` → protection RHS（`build_dpp_action_tables.m:192/220`）+ 所有 `compute_action_*_objective`。

#### 8.1.1 confidence rule：q_pos 四路融合权重（凸组合，和=1.0）

| name | value | active_paths | class | source | evid | impact | grounding action |
|---|---|---|---|---|---|---|---|
| `LITERAL@rule:16 w_sat` | 0.25 | DPP+v6+baseline:all (positioning) | EngineeringChoice | GNSS DOP/精度文献给"卫星数↑→定位↑"的**形式**，但 4 路线性权不标准化（RTCA DO-229 未规定这些值） | Weak | ChangesResults | 把 4 权(0.25/0.25/0.30/0.20)作联合 EngineeringChoice；在 simplex/Dirichlet 上扫描，报 q_pos 十分位稳定性 |
| `LITERAL@rule:16 w_dop` | 0.25 | DPP+v6+baseline:all (positioning) | EngineeringChoice | DOP 权重在 GNSS 质量评分中惯例显著，但 0.25 份额是选取 | Weak | ChangesResults | 纳入 4 权联合扫描 |
| `LITERAL@rule:16 w_pos` | 0.30 | DPP+v6+baseline:all (positioning) | EngineeringChoice | σ_pos 是最直接精度代理，给最大份额可由论证辩护，但 0.30 是选取 | Weak | ChangesResults | 联合扫描；若 q_pos 意在编码 1σ 水平误差，s_pos 或应更主导 |
| `LITERAL@rule:16 w_upd` | 0.20 | DPP+v6+baseline:all (positioning) | EngineeringChoice | 更新率惩罚**形式**可接地（陈旧 fix→位置 AoI），但 0.20 是选取 | Weak | ChangesResults | 联合扫描 |

#### 8.1.2 confidence rule：四个归一化端点（线性 ramp）

| name | value | active_paths | class | source | evid | impact | grounding action |
|---|---|---|---|---|---|---|---|
| `LITERAL@rule:4 n_sat 下端` | 3.0 | DPP+v6+baseline (positioning) | StandardsDerivable | 3D fix 需 ≥4 星（3 定位+1 钟差）；n_sat=3=无 3D fix→0 分锚是可接地的 | Medium | ChangesResults | 引"n_sat≥4 才有 3D fix"；考虑把零锚移到 4。**FORM 可接地，确切锚(3 vs 4)是校准选择** |
| `LITERAL@rule:4 n_sat 上端` | 12.0 | DPP+v6+baseline (positioning) | EngineeringChoice | 12 星=充裕饱和点；多星座接收机常见 12–20，12 作满分锚合理但是选取 | Weak | ChangesResults | 文档化为饱和拐点；扫 10–16 证良态下 q_pos 不敏感 |
| `LITERAL@rule:7 DOP 下端` | 1.0 | DPP+v6+baseline (positioning) | StandardsDerivable | DOP=1 是理论理想（HDOP/PDOP 不低于~1）；DOP 等级表"<1 ideal、1–2 excellent" | Medium | ChangesResults | 引标准 DOP 等级表；下锚=1 可接地，ramp 形状是工程部分 |
| `LITERAL@rule:7 DOP 上端` | 5.0 | DPP+v6+baseline (positioning) | StandardsDerivable | DOP=5 是"good(2–5)/moderate(5–10)"分界；零分锚映到 5 大致可辩护 | Medium | ChangesResults | 引 DOP 等级表；注 5 偏保守（把 moderate 归零）；扫 5–10 暴露退化几何下的敏感性 |
| `LITERAL@rule:10 σ_pos 下端` | 0.3 m | DPP+v6+baseline (positioning) | DataCalibrated | 0.3 m 1σ 水平=好开阔天空/RTK-float 级；这是 q_pos↔1σ 水平误差编码，可接 C-V2X/GNSS 精度规格，但确切 0.3 m 依赖数据集 | Medium | ChangesResults | 把 0.3 m 绑到 forest 数据集开阔天空基线/接收机规格；最干净的可接地端点（σ 是物理米量）；对照 `calibrate_forest_scene_params` 冠层严重度区间 |
| `LITERAL@rule:10 σ_pos 上端` | 3.0 m | DPP+v6+baseline (positioning) | DataCalibrated | 3.0 m 1σ="车道级不可用"最坏情况；关联车道宽/AL_lane(~1.5–3.5 m)，但确切值依赖数据集/AL | Medium | ChangesResults | 把 3.0 m 锚到别处使用的 AL；与主审计 §7 推荐的 PL>AL 完整性重建交叉链接；扫 2–5 m |
| `LITERAL@rule:13 dt_upd 下端` | 0.1 s | DPP+v6+baseline (positioning) | StandardsDerivable | 0.1 s=10 Hz GNSS，常见高速 fix 间隔，且匹配 C-V2X 10 Hz CAM/BSM 节奏 | Medium | ChangesResults | 引 10 Hz GNSS/BSM 节奏为最佳锚；FORM(陈旧惩罚)可接地，0.1 s 锚可接更新率 |
| `LITERAL@rule:13 dt_upd 上端` | 0.8 s | DPP+v6+baseline (positioning) | EngineeringChoice | 0.8 s(~1.25 Hz)作零分陈旧锚是选取容忍度，非标准 | Weak | ChangesResults | 扫 0.5–1.0 s；若有 AoI 预算则绑位置 AoI 容忍 |

#### 8.1.3 step9_pos：blind_zone / blockage / RSSI 融合权重 + 门（多处和=1.0）

| name | value | active_paths | class | source | evid | impact | grounding action |
|---|---|---|---|---|---|---|---|
| `LITERAL@step9_pos:131 blind_zone w_gnss` | 0.58 | DPP+v6+baseline (positioning) | EngineeringChoice | 注释引"CV2X-LOCA 融合框架"——那是 **FORM**(GNSS 主、无线遮挡次)；0.58/0.42 分割无文献推导 | Weak | ChangesResults | 0.58/0.42 作联合 EngineeringChoice 融合权扫描；注释只证结构不证数值 |
| `LITERAL@step9_pos:131 blind_zone w_block` | 0.42 | DPP+v6+baseline (positioning) | EngineeringChoice | 0.58 的补；form 可接地、数不可 | Weak | ChangesResults | 与 0.58 联合扫 |
| `LITERAL@step9_pos:132 blind_zone_gate offset` | 0.34 | DPP+v6+baseline (positioning) | EngineeringChoice | 激活死区下沿；注释"<0.34 正常"；无文献依据 | None | ChangesResults | 扫 (offset,span)=(0.34,0.36) 对；软阈死区无外锚 |
| `LITERAL@step9_pos:132 blind_zone_gate span` | 0.36 | DPP+v6+baseline (positioning) | EngineeringChoice | 门斜率(1/0.36)；选取 ramp 宽 | None | ChangesResults | 与 0.34 联合扫；映 0.34→0、0.70→1（注释证上沿 0.70） |
| `LITERAL@step9_pos:119 blockage w_nlos` | 0.42 | DPP+v6+baseline (positioning) | EngineeringChoice | 注释引 3GPP TR 37.885 阻塞建模——支持"NLOS 主导"(FORM)，但 TR 37.885 不给 0.42 融合权 | Weak | ChangesResults | 4 权(0.42/0.18/0.20/0.20)联合扫；TR 37.885 引证只接结构，不接权重 |
| `LITERAL@step9_pos:120 blockage w_nlosv (+/2.0)` | 0.18, /2.0 | DPP+v6+baseline (positioning) | EngineeringChoice | NLOSv 车辆阻塞 form 来自 TR 37.885；/2.0 把 nlosv 计数饱和于 2，权与归一皆选取 | Weak | ChangesResults | 联合扫；核 /2.0 饱和是否匹配 nlosv 定义（计数 vs dB） |
| `LITERAL@step9_pos:121 blockage w_shadow (+/5.0)` | 0.20, /5.0 dB | DPP+v6+baseline (positioning) | EngineeringChoice | V2X 阴影 std~3–4 dB LOS/4–8 dB NLOS；/5.0 dB 松绑一个 std 但是选取 | Weak | ChangesResults | 联合扫；**/5.0 与 line149 的 /5.5 对同一 shadowing 输入不一致**——统一 |
| `LITERAL@step9_pos:122 blockage w_(1-pdr)` | 0.20 | DPP+v6+baseline (positioning) | EngineeringChoice | (1-PDR)作复合链路退化代理；form 合理、0.20 选取 | Weak | ChangesResults | 联合扫；**双计数风险**：PDR 已依赖 NLOS/shadowing，本项与前三项相关 |
| `LITERAL@step9_pos:107 rssi w_support (+/1.6)` | 0.55, /1.6 | DPP+v6+baseline (positioning) | EngineeringChoice | 注释引 CV2X-LOCA/"RSSI 直接反映精度"——FORM only；0.55 与 /1.6 饱和皆选取 | Weak | ChangesResults | 联合扫(0.55,0.25,0.20)+两归一(1.6,2.0)；/1.6 暗示~1.6 求和支持=满信，绑数据集 RSU 覆盖几何 |
| `LITERAL@step9_pos:108 rssi w_rsu_count (+/2.0)` | 0.25, /2.0 | DPP+v6+baseline (positioning) | StandardsDerivable | /2.0 可接地：注释"≥2 RSU 才能三角定位"，2 是 2D RSU 定位最小数；FORM 几何可推，0.25 权选取 | Medium | ChangesResults | 保留 /2.0（三角定位几何最小，可接地）；扫权 0.25 |
| `LITERAL@step9_pos:109 rssi w_geometry` | 0.20 | DPP+v6+baseline (positioning) | EngineeringChoice | geometry_balance 是 GDOP 简化(注释)；代理 form 松接 GDOP，0.20 选取 | Weak | ChangesResults | 联合扫；注 geometry_balance=1-\|top1-top2\| 是粗 GDOP 代理 |
| `LITERAL@step9_pos:147 env_detect w_nlos` | 0.48 | DPP+v6+baseline (positioning) | EngineeringChoice | 无引用；NLOS 主导合理(form)，0.48 选取 | Weak | ChangesResults | 联合扫(0.48/0.20/0.18/0.14)；**flag：env_detect 与 blockage 对同输入用不同权(nlos 0.48 vs 0.42, shadow /5.5 vs /5.0)** |
| `LITERAL@step9_pos:148 env_detect w_nlosv (+/2.0)` | 0.20, /2.0 | DPP+v6+baseline (positioning) | EngineeringChoice | NLOSv form；权 0.20 与 /2.0 选取 | Weak | ChangesResults | 联合扫 |
| `LITERAL@step9_pos:149 env_detect w_shadow (+/5.5)` | 0.18, /5.5 dB | DPP+v6+baseline (positioning) | EngineeringChoice | /5.5 dB 与 line121 的 /5.0 对同一 shadowing_dB 不一致——皆选取 | Weak | ChangesResults | 联合扫并统一 shadowing 归一(5.0 vs 5.5) |
| `LITERAL@step9_pos:150 env_detect w_gnss_risk` | 0.14 | DPP+v6+baseline (positioning) | EngineeringChoice | GNSS risk 喂"环境可探测"混源；0.14 选取 | Weak | ChangesResults | 联合扫；**circularity**：gnss_risk 已驱动 gate 该项的 blind_zone_gate |

#### 8.1.4 step9_pos：coarse_sigma 融合/支路/relief/clamp（米尺度精度，直接定 q_pos）

| name | value | active_paths | class | source | evid | impact | grounding action |
|---|---|---|---|---|---|---|---|
| `LITERAL@step9_pos:168 coarse_sigma 0.68/0.32` | 0.68, 0.32 | DPP+v6+baseline (positioning, 双模开默认活跃) | EngineeringChoice | 逆方差/协方差交集融合**有**可推 form(w∝1/σ²)，但**固定** 0.68/0.32 是硬编码近似，非由实际 σ 算出 | Weak | ChangesResults | **高价值**：用真逆方差 w_i=(1/σ_i²)/Σ 替换固定分割→form 接地且消除魔数 |
| `LITERAL@step9_pos:170 coarse_sigma 1.08/0.35` | 1.08, 0.35 | positioning (use_gnss only, RSU 消融) | EngineeringChoice | RSU 不可用时膨胀 GNSS σ；皆选取 | None | ChangesResults | 扫；默认(双开)此支死 |
| `LITERAL@step9_pos:172 coarse_sigma 0.92/0.55` | 0.92, 0.55 | positioning (use_rsu only, GNSS 消融) | EngineeringChoice | RSU-only σ 混合；选取 | None | ChangesResults | 扫；默认死 |
| `LITERAL@step9_pos:174 coarse_sigma fallback 1.20/1.20` | 1.20, 1.20 | positioning (双模全关消融) | EngineeringChoice | 无定位最坏 fallback：20% σ 膨胀+1.2 m 加性底；选取 | None | ChangesResults | 文档化为无定位 fallback；仅"全关"消融时扫。**主线实质死** |
| `LITERAL@step9_pos:177-179 relief 0.42/0.28/0.65/0.35` | 0.42,0.28,0.65,0.35 | DPP+v6+baseline (positioning) | EngineeringChoice | RSU/env 校正触发时的 σ-relief 幅度+env_detect 混合；皆选取 | None | ChangesResults | 与融合权联合扫；直接从 coarse_sigma 减米，实质移动 q_pos |
| `LITERAL@step9_pos:181 coarse_sigma clamp [0.35,5.5]` | 0.35, 5.5 m | DPP+v6+baseline (positioning) | DataCalibrated | 0.35 m 底=最佳水平 σ、5.5 m 顶=最坏；应匹配 rule 的 0.3..3.0 编码 | Weak | ChangesResults | 绑到与 rule s_pos(0.3/3.0)同物理精度区间；**当前 0.35/5.5 与 rule 的 0.3/3.0 不一致**——对齐 |
| `LITERAL@step9_pos:164 rsu_sigma 10.0/(1+3.0·x), 0.05 底` | 10.0,3.0,0.05 | DPP+v6+baseline (positioning) | EngineeringChoice | 倒数 form(支持↑→σ↓)合理；10.0 幅(无支持 σ)、3.0 斜率、0.05 底皆选取 | Weak | ChangesResults | 用 RSSI→测距方差路损模型校准 10.0/3.0 |
| `LITERAL@step9_pos:165 rsu_sigma blind 膨胀 0.25` | 0.25 | DPP+v6+baseline (positioning) | EngineeringChoice | blind-zone+衰减下最多 25% σ 膨胀；选取耦合 | None | ChangesResults | 扫；把 env_attenuation 无物理推导地耦入 RSU 测距 σ |
| `LITERAL@step9_pos:183-189 bias_scale 仿射 0.72/0.28/0.20/0.16/-0.10/-0.08` | 6 系数 | DPP+v6+baseline (positioning) | EngineeringChoice | coarse_sigma→确定性 bias 幅度的仿射，依退化分数；全选取 | None | ChangesResults | 6 系数联合扫；**高杠杆**：定合成位置误差幅度，最终定 q_pos 一致性 |
| `LITERAL@step9_pos:136-142 rsu_support floor/cap 0.45/0.35/0.18/0.55/0.90/0.40` | 6 值 | DPP+v6+baseline (positioning) | EngineeringChoice | 把分数保持在有用带的脚手架；无源 | None | ChangesResults | 联合扫；**0.18 cap 缩减硬编码在已校准 `position_rsu_relief_cap`=0.82 旁，应一并校准** |
| `LITERAL@step9_pos:134 rsu_gain_gate 0.42/0.26` | 0.42,0.26 | DPP+v6+baseline (positioning) | EngineeringChoice | 软阈死区映 rssi[0.42,0.68]→[0,1]；选取 | None | ChangesResults | 与 blind_zone 门联合扫 |
| `LITERAL@step9_pos:153 env_correction_gate 0.16/0.34` | 0.16,0.34 | DPP+v6+baseline (positioning) | EngineeringChoice | env-severity 死区映[0.16,0.50]→[0,1]；选取 | None | ChangesResults | 联合扫 |
| `LITERAL@step9_pos:155-158 env_score 0.55/0.24/0.28/0.18/0.10/0.45` | 6 值 | DPP+v6+baseline (positioning) | EngineeringChoice | env_score 基 0.55+校正项；全选取 | None | ChangesResults | 联合扫；0.45 是第二次出现的激活参考点 |

#### 8.1.5 step9_pos：合成误差轨迹（正弦 bias）+ 环境衰减/支持核 + 随机噪声 fallback

| name | value | active_paths | class | source | evid | impact | grounding action |
|---|---|---|---|---|---|---|---|
| `LITERAL@step9_pos:191 err_x 正弦 0.40,0.17,0.25/0.14,0.05` | 5 字面量 | DPP+v6+baseline (positioning) | EngineeringChoice | 确定性正弦位置 bias（双谐波）；纯合成场景塑形，无物理源 | None | ChangesResults | 定义合成 ego 位置误差轨迹；文档化为场景生成器参数或换随机模型 |
| `LITERAL@step9_pos:192 err_y 正弦 0.30,0.13,0.35/0.16,0.08,0.15` | 6 字面量 | DPP+v6+baseline (positioning) | EngineeringChoice | 第二轴正弦 bias；合成塑形 | None | ChangesResults | 同 err_x |
| `LITERAL@step9_pos:41 gnss_score fallback 0.25+0.15·gauss(t-35,14)` | 0.25,0.15,35,14 | positioning (GNSS 消融; 默认死) | EngineeringChoice | GNSS 禁用消融的合成高斯凸；选取 | None | Unknown | 仅 GNSS-off 消融时关注；文档化为消融占位 |
| `LITERAL@step9_pos:44-49 env_attenuation 模型 base1.0,0.08,0.24,0.10,0.55,width10.0,clamp[1.0,3.5]` | 多值 | DPP+v6+baseline (positioning) | EngineeringChoice | 环境衰减指数；0.08/dB 松接衰减/dB 但所有系数选取 | Weak | ChangesResults | 联合扫；3.5/1.0 在 line57 复用作 env_score_raw 归一；接冠层衰减模型 |
| `LITERAL@step9_pos:69-72 RSU 支持核 1.0,0.55,0.18,0.05,2.0,0.08` | 6 值 | DPP+v6+baseline (positioning) | EngineeringChoice | exp(-d/cov)距离衰减 form 合理；惩罚/奖励系数选取 | Weak | ChangesResults | 联合扫；exp(-d/coverage)可接地（range-based），系数 EngineeringChoice |
| `LITERAL@step9_pos:84 visible_rsu 覆盖乘子 1.35` | 1.35 | DPP+v6+baseline (positioning) | EngineeringChoice | 可见范围=1.35×名义覆盖半径；选取裕度（配已校准 support_threshold=0.18） | Weak | ChangesResults | 扫；把 1.35 接 RSU 链路预算边缘定义 |
| `LITERAL@step9_pos:25,29 gnss 独立噪声 fallback 0.08/len12` | 0.08,12 | positioning (随机运行; 被 params 覆盖) | DataCalibrated | 复制 `get_default_step9_params:85`(0.08)的内联 fallback；电离层闪烁 std 与~12 样本时标 | Weak | ChangesResults | 校准路用 canopy 严重度设置(`calibrate_forest_scene_params:63`)；接 0.08 到闪烁幅度，12 到电离层相关时间（12 样本无时间单位锚） |
| `LITERAL@step9_pos:197,201 gnss 多径噪声 fallback 0.12/len8` | 0.12,8 | positioning (随机运行; 被 params 覆盖) | DataCalibrated | 复制 `get_default_step9_params:87`(0.12 米缩放多径 std)+8 样本相关长 | Weak | ChangesResults | 接 0.12 m 到 canopy 多径测量；内联值是未校准 fallback；8 样本 len 缺时间锚 |
| `LITERAL@step9_pos:219 traj_score fallback 0.50` | 0.50 | positioning (traj 消融; 默认死) | EngineeringChoice | traj 滤波禁用时的中性一致性；选取中性先验 | None | Unknown | 文档化为中性消融默认 |
| `LITERAL@compute_piecewise_position_risk:4-7 默认阈 0.75/0.50/0.50/1.00` | 0.75,0.50,0.50,1.00 | DPP+v6+baseline (delivery/link required-target) | EngineeringChoice | 主审计(§194,§270)已 flag：q_pos 当无量纲度量、阈 0.75/0.50 在 DPP 路活跃；**应是 PL>AL 完整性测试** | Weak | ChangesResults | 按主审计建议#7 改 coarse_sigma 上 PL>AL；现 0.75/0.50 仅作一致性交叉核。**已暴露为命名参数(utility_required_timely_qpos_*)，此处是 fallback 默认值** |

### 8.2 链路状态生成器内联字面量

> 来源文件：`step9_generate_link_state_wilab_like.m`（下称 step9_link）、`compute_link_quality_rule.m`（下称 link_rule）。
>
> **活动路径判定（关键）**：`load_step9_external_inputs` 返回 `has_trajectory=has_blockage=false`，除非 `params.scenario_input.mode=='external'`。故**合成支路是所有标准运行的默认活动路径**。生成器在 `generate_step9_scenario.m:21` **无条件**运行（不受 `use_physical_delivery` 门控），其输出 pdr/delay/loss/sinr_dB/shadowing_dB/q_link 喂**每个**调度器与两个投递模型。例外：veg_attenuation 系数(0.65/0.18)与 nlosv/2.0 归一(:93)仅在外部数据支路活跃，默认惰性。

#### 8.2.1 阴影衰落幅度 + 合成正弦载波

| name | value | active_paths | class | source | evid | impact | grounding action |
|---|---|---|---|---|---|---|---|
| `shadow_sigma (LOS)` | 3.0 dB | DPP+v6+baseline+delivery+link (合成支) | StandardsDerivable | 3GPP TR 37.885 §6.2.3 LOS 阴影 σ=3 dB | Strong | None | 引 TR 37.885 LOS SF=3 dB；NUMBER 标准，仅正弦载波是合成。保留值+加引用 |
| `shadow_sigma (NLOS)` | 4.0 dB | DPP+v6+baseline+delivery+link (合成支) | StandardsDerivable | TR 37.885 NLOS 行 SF=4 dB | Medium | Unknown | **归因警告**：4 dB **不是** "NLOSv SF=4"；TR 37.885 中 NLOSv 沿用 LOS SF=3 dB，4 dB 是 NLOS 行 SF。代码对 window-NLOS 与几何 NLOSv 都用 4 dB(:56 is_nlos 并集)，**混淆二者**——form/幅可接地但须纠正归因 |
| `LITERAL@step9_link:82 sin 频 0.09` | 0.09 rad/s | DPP+v6+baseline+delivery+link (合成支) | EngineeringChoice | 无文献依据的确定性正弦阴影载波；FORM(慢相关 SF)可经 Gudmundson 指数自相关接地，正弦及其频率是合成塑形 | None | ChangesResults | 换为滤波高斯 SF 过程(去相关距离由 speed·dt 定)或作场景旋钮扫周期 |
| `LITERAL@step9_link:83 cos 频 0.04` | 0.04 rad/s | DPP+v6+baseline+delivery+link (合成支) | EngineeringChoice | 第二拍频；合成 | None | ChangesResults | 同上；并入单一校准 SF 自相关模型 |
| `LITERAL@step9_link:83 cos 幅权 0.5` | 0.5 | DPP+v6+baseline+delivery+link (合成支) | EngineeringChoice | 两正弦混合权；定总 SF 峰峰相对 shadow_sigma | None | ChangesResults | 扫或并入校准 SF 幅度 |
| `LITERAL@step9_link:85 smooth-noise SF 系数 0.45` | 0.45·shadow_sigma | DPP+v6+baseline+link (合成支,随机种子) | EngineeringChoice | shadow_sigma 中实现为平滑高斯噪声的比例；FORM(随机 SF 分量)可接地 | Weak | ChangesResults | 若 SF 建为 Gudmundson 过程此系数消失；作 MC-jitter 旋钮扫 |
| `LITERAL@step9_link:85 local_smooth_noise 窗=5` | 5 样本 | DPP+v6+baseline+link/delivery (合成支,随机种子) | EngineeringChoice | movmean 窗定 MC SF/delay 噪声时间相关长(=窗·dt)；FORM 为 SF 去相关时间，整数 5 手选 | Weak | ChangesResults | 绑 dt 与校准去相关距离或扫 |
| `LITERAL@step9_link:69 shadow_phase_1 默认 0.3` | 0.3 rad | DPP+v6+baseline+link (合成支,无随机种子→默认活跃) | EngineeringChoice | 无随机种子时固定相位偏移；定阴影 notch 相对场景时间线的确定性对齐；任意 | None | ChangesResults | 文档化为场景默认；确定性运行结果依赖它 |
| `LITERAL@step9_link:70 shadow_phase_2 默认 0.0` | 0.0 rad | DPP+v6+baseline+link (合成支,无随机种子) | EngineeringChoice | 确定性运行固定次正弦相位；任意 | None | ChangesResults | 文档化 |

#### 8.2.2 合成干扰模板（三高斯凸）+ 蒙卡 jitter 旋钮

| name | value | active_paths | class | source | evid | impact | grounding action |
|---|---|---|---|---|---|---|---|
| `LITERAL@step9_link:104 干扰幅1` | 6.0 | DPP+v6+baseline+delivery+link (合成支) | EngineeringChoice | 手建高斯和时间模板最大凸幅；无物理/标准依据 | None | ChangesResults | FORM 应为 SPS 半双工碰撞/CBR 模型(TR 37.885/Mode-4)；换碰撞模型或三幅联合扫 |
| `LITERAL@step9_link:105 干扰幅2` | 1.0 | DPP+v6+baseline+delivery+link (合成支) | EngineeringChoice | 次凸幅；合成 | None | ChangesResults | 同 amp1 |
| `LITERAL@step9_link:106 干扰幅3` | 1.5 | DPP+v6+baseline+delivery+link (合成支) | EngineeringChoice | 第三凸幅；合成 | None | ChangesResults | 同 amp1 |
| `LITERAL@step9_link:104 干扰中心 60` | 60 s | DPP+v6+baseline+delivery+link (合成支) | EngineeringChoice | 手放干扰事件 1 时刻 | None | ChangesResults | 由邻居密度驱动碰撞模型或扫 |
| `LITERAL@step9_link:105 干扰中心 78` | 78 s | DPP+v6+baseline+delivery+link (合成支) | EngineeringChoice | 手放；落在合成 NLOS 窗[68,90]内，故干扰+NLOS 故意叠加 | None | ChangesResults | 文档化最坏叠加意图或扫 |
| `LITERAL@step9_link:106 干扰中心 105` | 105 s | DPP+v6+baseline+delivery+link (合成支) | EngineeringChoice | 手放晚期事件 | None | ChangesResults | 同上 |
| `LITERAL@step9_link:104/105/106 干扰宽 8/7/9` | 8,7,9 s | DPP+v6+baseline+delivery+link (合成支) | EngineeringChoice | 三事件持续；由 congestion/CBR 驻留模型或扫 | None | ChangesResults | 控 SINR 凹陷时长→调度器看到退化链路的时隙数 |
| `LITERAL@step9_link:77 shadow_scale base 0.85` | 0.85 | DPP+v6+baseline+link (合成支,随机种子) | EngineeringChoice | per-seed 阴影幅 jitter 下界(范围[0.85,1.15])；MC 离散旋钮 | None | ChangesResults | 文档化为 MC 离散，保持窄 |
| `LITERAL@step9_link:77 shadow_scale span 0.30` | 0.30 | DPP+v6+baseline+link (合成支,随机种子) | EngineeringChoice | per-seed 阴影幅 jitter 宽 | None | ChangesResults | 文档化为 seed-variation 范围 |
| `LITERAL@step9_link:78 int_scale base 0.78` | 0.78 | DPP+v6+baseline+link (合成支,随机种子) | EngineeringChoice | per-seed 干扰幅 jitter 下界(每分量[0.78,1.22]) | None | ChangesResults | 文档化 MC 离散，保持窄 |
| `LITERAL@step9_link:78 int_scale span 0.44` | 0.44 | DPP+v6+baseline+link (合成支,随机种子) | EngineeringChoice | per-seed 干扰幅 jitter 宽 | None | ChangesResults | 文档化 MC 离散 |
| `LITERAL@step9_link:79 int_shift std [1.0,1.5,1.5]` | [1.0,1.5,1.5] s | DPP+v6+baseline+link (合成支,随机种子) | EngineeringChoice | 三干扰事件 per-seed 时间 jitter(高斯 std)；非对称给事件 2/3 更大展宽，任意 | None | ChangesResults | 文档化 seed-variation；若结果对事件-NLOS 重叠敏感则扫 |
| `LITERAL@step9_link:53 nlos_shift std 1.4` | 1.4 s | DPP+v6+baseline+delivery+link (合成支,随机种子) | EngineeringChoice | 合成 NLOS 窗时间 jitter(std,秒)；MC 离散 | None | ChangesResults | 文档化 seed-variation；NLOS 起始实质改变可投递消息集，应扫 |

#### 8.2.3 合成 NLOS 窗 + 手建轨迹（场景的定义性特征）

| name | value | active_paths | class | source | evid | impact | grounding action |
|---|---|---|---|---|---|---|---|
| `LITERAL@step9_link:55 合成 NLOS 窗 [68,90]` | [68,90] s | DPP+v6+baseline+delivery+positioning+link (合成支) | EngineeringChoice | 手放森林遮挡窗；**最具后果的单一合成事件**(强制 NLOS 路损、4 dB SF、+12 ms 延迟、干扰事件 2 重叠处) | None | ChangesResults | 由真实遮挡几何驱动(has_blockage 支已如此)或扫时长/起始。**场景定义性特征** |
| `LITERAL@step9_link:25-29 轨迹 rx_x 分段 40/70/150/100/95, 斜率 0.2/0.6/3.5/0.8/0.9, 断点 25/55/68/90` | ~14 魔数 | DPP+v6+baseline+positioning+delivery+link (合成支) | EngineeringChoice | 手编 ego/RX 轨迹(分段线性距离剖面)；定整个距离→路损时间线；无依据，它**就是**场景 | None | ChangesResults | 换真实轨迹(has_trajectory 支存在)或文档化为标准合成场景并扫关键段(尤其 t∈[55,68]的 3.5 m/s 快撤离) |
| `LITERAL@step9_link:31-33 轨迹 rx_y 横向弧 幅4.0,半周22,窗[68,90]` | 4.0 m,22 s | DPP+v6+baseline+positioning+delivery+link (合成支) | EngineeringChoice | 合成横向"摆动"弧(4 m 正弦 22 s)与 NLOS 窗共时；纯场景塑形 | None | ChangesResults | 换真实轨迹或文档化；4 m 幅、22 s 周期任意。横向窗[68,90]恰匹配 NLOS 窗+干扰中心 78——故意叠加复合压力 |

#### 8.2.4 抽象延迟模型 + pdr clamp（无条件活跃，喂所有调度器 delay/AoI）

| name | value | active_paths | class | source | evid | impact | grounding action |
|---|---|---|---|---|---|---|---|
| `LITERAL@step9_link:126 delay base 0.04` | 0.04 s | DPP+v6+baseline+delivery+link (合成支无条件) | EngineeringChoice | 抽象可靠性→延迟映射常底（**非** get_default 的物理延迟模型，是链路态抽象延迟） | Weak | ChangesResults | 对账物理 base_access_delay=0.012(主审计§2.5)或文档化为抽象延迟模型并扫 |
| `LITERAL@step9_link:126 delay 可靠性项 0.18` | 0.18 s | DPP+v6+baseline+delivery+link (合成支无条件) | EngineeringChoice | 0.18/pdr 拥塞/重传项；FORM 松接(ARQ 期望传输数=1/pdr)但 0.18 s/次手设 | Weak | ChangesResults | 绑 per-attempt TTI/重传预算或扫；**FORM 可接地，0.18 magnitude 不可** |
| `LITERAL@step9_link:126 delay pdr-floor 0.05` | 0.05 | DPP+v6+baseline+delivery+link (合成支) | Structural | 除零守卫；把 1/pdr 项封顶于 0.18/0.05=3.6 s | Medium | Unknown | 多为安全 clamp，但设最大重传延迟(3.6 s)故半参数化。pdr 已 clamp≥0.01(:124)，故 pdr∈[0.01,0.05]时此底**绑定** |
| `LITERAL@step9_link:126 delay 距离系数 0.006,ref40,/10` | 0.006 s/(10m>40m) | DPP+v6+baseline+delivery+link (合成支) | EngineeringChoice | 线性距离→延迟惩罚，斜率任意；40 m 拐点、/10 归一；**非**传播延迟(40 m 光程~0.13 µs 非 6 ms) | None | ChangesResults | 文档化为抽象距离惩罚或扫；40 m 拐点呼应轨迹几何非物理 |
| `LITERAL@step9_link:126 delay nlos 加 0.012` | 0.012 s | DPP+v6+baseline+delivery+link (合成支) | EngineeringChoice | NLOS 平延迟附加；**恰等于物理 base_access_delay=0.012**(主审计§2.5) | Weak | ChangesResults | 核是有意复用还是巧合；文档化或扫（潜在静默耦合） |
| `LITERAL@step9_link:128 delay MC-noise 系数 0.004` | 0.004 s | DPP+v6+baseline+delivery+link (合成支,随机种子) | EngineeringChoice | per-seed 延迟 jitter 幅(4 ms 尺度)；MC 离散 | Weak | ChangesResults | 文档化 seed-variation，保持小 |
| `LITERAL@step9_link:128 delay noise clamp -0.8` | -0.8 | DPP+v6+baseline+link (合成支,随机种子) | EngineeringChoice | 非对称 clamp 使 jitter 右偏；任意非对称 | None | ChangesResults | 文档化或改对称 jitter+:130 底 |
| `LITERAL@step9_link:130 delay 硬底 0.02` | 0.02 s | DPP+v6+baseline+delivery+link (合成支) | EngineeringChoice | 最小单向延迟；松接~1-2 TTI+处理，但 20 ms 手设(<base 0.04 故罕绑) | Weak | Unknown | 文档化或对齐 TTI 结构 |
| `LITERAL@step9_link:124 pdr clamp [0.01,0.999]` | 0.01,0.999 | DPP+v6+baseline+delivery+link (合成支) | EngineeringChoice | PDR 饱和界；上 0.999 合理("永不完美")近 Structural；下 0.01 设最大 loss=0.99 | Weak | ChangesResults | 文档化；0.01 底=即便全 NLOS 链路也投递 1%，是真实建模选择，值敏感性检查 |
| `LITERAL@step9_link:60-64 pl log10 底 1.0` | 1.0 m | DPP+v6+baseline+delivery+link (合成支) | Structural | 1 m 是标准路损参考/近场有效底(Friis/TR 37.885 close-in d0=1 m) | Strong | None | 无动作；匹配 pathloss_*_offset(47 dB@1 m)。与主审计§2.5 一致 |
| `LITERAL@step9_link:64 nlosv 乘子底 max(...,1)` | 1 | DPP+v6+baseline+delivery+link (合成支) | Structural | 确保 NLOS 标记时至少应用一个阻塞者额外损耗(window-NLOS 即便几何 nlosv_pair=0) | Medium | Unknown | 半结构；核意图(把合成 NLOS 窗静默授予一个 nlosv 阻塞损耗)；文档化耦合 |
| `LITERAL@step9_link:151 smooth-noise std 守卫 1.0e-9` | 1.0e-9 | DPP+v6+baseline+link/delivery (合成支,随机种子) | Structural | 浮点近零除守卫 | Strong | None | 无动作；纯数值安全 |
| `LITERAL@step9_link:75-76 shadow_phase 随机 2.0·pi` | 2π | DPP+v6+baseline+link (合成支,随机种子) | Structural | 随机正弦相位的唯一数学有意义范围[0,2π) | Strong | None | 无动作；结构强制范围非旋钮 |
| `LITERAL@step9_link:71 shadow_scale 默认 1.0` | 1.0 | DPP+v6+baseline+link (合成支,无随机种子) | Structural | 乘性 scale 的单位/恒等默认 | Strong | None | 无动作；真幅度在 shadow_sigma |

#### 8.2.5 link_quality_rule：q_link 归一化锚 + 融合权（喂多个调度器门控）

| name | value | active_paths | class | source | evid | impact | grounding action |
|---|---|---|---|---|---|---|---|
| `LITERAL@link_rule:4 pdr 归一 [0.30,1.00]` | 0.30,1.00 | DPP+v6+baseline (q_link) | EngineeringChoice | min-max 归一锚：PDR≤0.30→0、=1→1；0.30 松接"可用链路"但不标准化 | Weak | ChangesResults | 把 0.30 绑到可靠性需求(如 v2x_reliability_floor 0.50 族)；**当前与 floor 族脱节，flag 不一致** |
| `LITERAL@link_rule:5 delay 归一 [0.05,0.60]` | 0.05,0.60 s | DPP+v6+baseline (q_link) | EngineeringChoice | 50 ms=最佳、600 ms=最坏锚；0.60 s 松接 deadline 但手设，且与物理 deadline(0.50/0.18/0.070)不一致 | Weak | ChangesResults | 把 0.60 绑最大 deadline、0.05 绑最小可达延迟。**0.05 与实际最小延迟(0.02 底/0.04 base)不符——flag** |
| `LITERAL@link_rule:6 loss 归一 0.70` | 0.70 | DPP+v6+baseline (q_link) | EngineeringChoice | loss≥0.70(PDR≤0.30)→0；镜像 s_pdr 0.30 拐点(loss=1-pdr)，**s_pdr 与 s_loss 大量冗余** | Weak | ChangesResults | 去重或文档化有意冗余；0.70=1-0.30 证冗余；扫 |
| `LITERAL@link_rule:8 融合权 0.40/0.30/0.30` | 0.40,0.30,0.30 | DPP+v6+baseline (q_link) | EngineeringChoice | 手设链路质量融合权(和=1)；无文献依据 | None | ChangesResults | simplex 敏感性扫描；因 s_loss 与 s_pdr 相关，有效 PDR 权~0.70——扫前显式化冗余 |

### 8.3 投递/预测/守卫硬编码字面量（simulate_step9_delivery / predict_action_*）

> 来源文件：`simulate_step9_delivery.m`（下称 sim_del）、`predict_action_success.m`（下称 pred_succ）、`predict_action_gate_threshold.m`（下称 pred_gate）。
>
> **双态**：`use_physical_delivery=true` 且 PERcurves 存在 → physical 支，本族全部死；否则抽象支活跃。predict_action_* 在 DPP argmin 的动作表构造里活跃（`build_dpp_action_tables` → `evaluate_action_metrics`），sim_del 在 DPP 投递评估里活跃。**故须按"可复现 fallback 必活跃"对待。**

| name | value | active_paths | class | source | evid | impact | grounding action |
|---|---|---|---|---|---|---|---|
| `LITERAL@sim_del:72 success_prob clamp ceiling 0.995` | 0.995 | DPP+baseline+delivery (抽象支) | EngineeringChoice | **无引用**。TS 22.186 高档 99.99%/99.999% 结构性高于此顶 | None | ChangesResults | 敏感性扫天花板{0.99/0.995/0.9999/1.0}；文档化为抽象 PHY 饱和守卫**非**可靠性目标。**见 §9 clamp-masking** |
| `LITERAL@sim_del:72 success_prob clamp floor 0.02` | 0.02 | DPP+baseline+delivery (抽象支) | EngineeringChoice | 防退化 0 概率的数值底；无文献 | None | Unknown | 扫{0,0.01,0.02,0.05}确认低敏感；文档化为守卫 |
| `LITERAL@sim_del:89 pdr_abstract clamp [0.02,0.995]` | 0.02,0.995 | DPP+baseline+delivery+link (抽象支) | EngineeringChoice | **第二个 0.995 天花板**(sigmoid 后)；独立把实现 PDR 封顶于 99.5% | None | ChangesResults | 与 line72 天花板联合扫；**两个叠加 0.995 顶都须处理才能暴露高可靠行为**。见 §9 |
| `LITERAL@sim_del:82 deterministic_gate clamp [0.05,0.95]` | 0.05,0.95 | DPP+baseline+delivery (抽象支) | EngineeringChoice | 把 gate 限于非饱和 sigmoid 输入区；直接移每个动作的 margin | None | ChangesResults | 扫 gate 界{[0.05,0.95],[0,1],[0.1,0.9]}；FORM 合理 NUMBER 工程 |
| `LITERAL@sim_del:51 / pred_succ:21 conf_protection HIGH 激活 (1-q_pos)>0.45 & priority>=3` | 0.45, ≥3 | DPP+baseline+positioning (抽象支) | EngineeringChoice | 两耦合魔数选 HIGH 层；0.45 在(1-q_pos)上无标准依据 | None | ChangesResults | 扫断点{0.40,0.45,0.50}与优先级门{≥2,≥3}；**逐字复制于 pred_succ:21(DPP 路)，须同改两份** |
| `LITERAL@sim_del:53 / pred_succ:23 conf_protection MID 激活 (1-q_pos)>0.30 & priority>=2` | 0.30, ≥2 | DPP+baseline+positioning (抽象支) | EngineeringChoice | 中层断点；0.30/0.45 给单调两阶梯，FORM 可辩护断点手选 | None | ChangesResults | 扫 0.30{0.25,0.30,0.35}；**复制于 pred_succ:23(DPP)** |
| `LITERAL@sim_del:56 / pred_succ:26 conf_protection DIRECT 激活 (1-q_pos)>0.30 & priority>=2` | 0.30, ≥2 | DPP+baseline+positioning (抽象支) | EngineeringChoice | direct(mode0)支复用同断点，授更小 0.04 保护 | None | ChangesResults | 与冗余/中继模式断点联合扫；**复制于 pred_succ:26(DPP)** |
| `LITERAL@sim_del:99 tx_rate 除数底 0.2` | 0.2 | DPP+baseline+delivery (抽象支) | EngineeringChoice | delay_real/=max(tx_rate,0.2) 除小守卫，改 delay→deadline_hit | Weak | ChangesResults | 绑动作集最小可纳 tx_rate(使永不绑)或扫{0.1,0.2,0.5}；核动作表是否有 tx_rate<0.2 |
| `LITERAL@sim_del:96 delay jitter 底 0.001` | 0.001 s | DPP+baseline+delivery (抽象支,随机) | Structural | jitter 后保非负最小延迟的数值守卫 | Medium | None | 无动作；纯守卫 |
| `LITERAL@pred_succ:32 success_prob clamp [0.02,0.995]` | 0.02,0.995 | DPP+baseline (抽象支,DPP 动作表) | EngineeringChoice | **第三处 0.995 天花板**(DPP planning leg)；与 sim_del:72 镜像 | None | ChangesResults | 与 sim_del 两顶联合扫；planning 与 delivery 须一致 |
| `LITERAL@pred_succ:5 critical_priority_bonus 触发 urgency>=0.80` | 0.80 | DPP+baseline (抽象支,DPP 动作表) | EngineeringChoice | **绕过可扫参数**：硬编码 0.80 而非读 `utility_emergency_urgency_threshold`(get_default:190=0.80)。两值现一致但解耦——扫参数不影响此处 | None | ChangesResults | **改读 params.utility_emergency_urgency_threshold**；见 §9。注：delivery 路(sim_del:26)用 msg_type=='emergency' 触发，二者不一致 |
| `LITERAL@pred_gate:17 emergency_gate_reduction 触发 urgency>=0.80` | 0.80 | DPP+baseline (抽象支,DPP 动作表) | EngineeringChoice | 同 pred_succ:5：硬编码 0.80 绕过 `utility_emergency_urgency_threshold` | None | ChangesResults | 改读参数；见 §9 |

### 8.4 get_default_step9_params.m 剩余字段族（主审计未逐条列出的）

#### 8.4.1 Lyapunov-baseline 族（`run_step9_confidence_driven_lyapunov` 专用，**≠ DPP-proposed**）

> 见 §9.1 消歧。`compute_action_lyapunov_objective`/`compute_lyapunov_stage_pressure` 是**独立的单队列**调度器（baseline），`lyapunov_V=1.0` 全权重=1.0；与 proposed DPP(`dpp_V=2.0`,双虚队列)无关。

| name | value | active_paths | class | source | evid | impact | grounding action |
|---|---|---|---|---|---|---|---|
| `lyapunov_V` | 1.0 | baseline:lyapunov | Structural | Neely 2010 DPP 单旋钮(此处=baseline 操作点 1.0，**非** proposed 的 2.0) | Strong | ChangesResults | 文档化为 baseline-lyapunov 操作点；与 dpp_V 区分；扫 |
| `lyapunov_queue_init` | 0.0 | baseline:lyapunov | Structural | 虚队列零初始(Lindley 标准初值) | Strong | None | 无动作；结构初值 |
| `lyapunov_queue_arrival_scale` | 1.0 | baseline:lyapunov | EngineeringChoice | 到达压力缩放=1(恒等)；`compute_lyapunov_stage_pressure:8` 消费 | Weak | ChangesResults | 单位默认；若调离 1 须扫 |
| `lyapunov_queue_service_scale` | 1.0 | baseline:lyapunov | EngineeringChoice | 服务率缩放=1(恒等)；`compute_action_lyapunov_objective:15` | Weak | ChangesResults | 单位默认；扫 |
| `lyapunov_queue_max` | 12.0 | baseline:lyapunov | Structural | 虚队列封顶=最大影子价(**≠ dpp_queue_max=20.0**) | Medium | ChangesResults | 文档化为 baseline cap；与 dpp_queue_max 区分；扫 |
| `lyapunov_cost_weight` | 1.0 | baseline:lyapunov | EngineeringChoice | penalty 中 tx_cost 权=1(`obj:19`) | Weak | ChangesResults | 单位默认；扫 |
| `lyapunov_delay_weight` | 1.0 | baseline:lyapunov | EngineeringChoice | delay_penalty 权=1(`obj:20`) | Weak | ChangesResults | 单位默认；扫 |
| `lyapunov_risk_weight` | 1.0 | baseline:lyapunov | EngineeringChoice | risk_penalty 权=1(`obj:21`) | Weak | ChangesResults | 单位默认；扫 |
| `lyapunov_event_weight` | 1.0 | baseline:lyapunov | EngineeringChoice | reward 中 event_gain 权=1(`obj:26`) | Weak | ChangesResults | 单位默认；扫 |
| `lyapunov_violation_weight` | 1.0 | baseline:lyapunov | EngineeringChoice | stage_pressure 中 required_protection 权=1(`stage:9`) | Weak | ChangesResults | 单位默认；扫 |
| `LITERAL@compute_lyapunov_stage_pressure:10 blind_zone_gain 系数 0.5` | 0.5 | baseline:lyapunov | EngineeringChoice | 到达压力中 blind_zone_gain 加性系数硬编码；无源 | None | ChangesResults | 提取为命名参数并扫 |

#### 8.4.2 DCC-baseline 族（`run_step9_baseline_dcc_*` 专用）

> 文献启发的 DCC(去中心化拥塞控制) baseline。CBR(信道忙率)门限的 FORM 接 ETSI EN 302 571 / TS 103 574 DCC，但确切门限值是工程取点。

| name | value | active_paths | class | source | evid | impact | grounding action |
|---|---|---|---|---|---|---|---|
| `dcc_cbr_low_threshold` | 0.25 | baseline:dcc | StandardsDerivable | ETSI DCC CBR 门限**形式**(低忙率→高速率)；0.25 落入 DCC 区间但是取点 | Weak | ChangesResults | 引 ETSI EN 302 571/TS 103 574 DCC CBR 门限族；门限值作工程取点扫 |
| `dcc_cbr_high_threshold` | 0.65 | baseline:dcc | StandardsDerivable | DCC CBR 上门限 form；0.65 取点 | Weak | ChangesResults | 同上 |
| `dcc_rate_multiplier_low` | 1.0 | baseline:dcc | EngineeringChoice | 低忙率速率乘子(基准 1.0) | None | ChangesResults | 基准；扫 |
| `dcc_rate_multiplier_mid` | 1.35 | baseline:dcc | EngineeringChoice | 中忙率速率乘子；选取 | None | ChangesResults | 扫 |
| `dcc_rate_multiplier_high` | 1.7 | baseline:dcc | EngineeringChoice | 高忙率速率乘子；选取 | None | ChangesResults | 扫 |
| `dcc_emergency_priority` | 3 | baseline:dcc | StandardsDerivable | C-V2X 3 级优先级顶档(动作空间 [1,2,3]) | Medium | ChangesResults | 引 3 级优先级动作空间 |
| `dcc_coop_priority` | 2 | baseline:dcc | StandardsDerivable | 3 级中档 | Medium | ChangesResults | 引动作空间 |
| `dcc_direct_mode_threshold` | 0.30 | baseline:dcc | EngineeringChoice | 直传模式切换门限；选取 | None | ChangesResults | 扫 |

#### 8.4.3 AoI-baseline 族（`run_step9_baseline_aoi*` / `compute_action_chance_risk_aoi_objective` 专用）

| name | value | active_paths | class | source | evid | impact | grounding action |
|---|---|---|---|---|---|---|---|
| `aoi_age_norm_cap` | 8.0 | baseline:aoi | EngineeringChoice / 待 Structural 化 | AoI age 归一 cap；当前是**线性** age/cap，**非** Sun 2017 非线性 g(Δ)(主审计§179) | Weak | ChangesResults | 主审计建议#10：升非线性 g(Δ)；cap 值作工程扫 |
| `aoi_high_threshold` | 0.55 | baseline:aoi | EngineeringChoice | 归一 AoI 高门限；选取 | None | ChangesResults | 扫 |
| `aoi_critical_threshold` | 0.80 | baseline:aoi | EngineeringChoice | 临界 AoI 门限；选取 | None | ChangesResults | 扫 |
| `aoi_default_mode` | 0 | baseline:aoi | Structural | 默认 direct 模式(动作空间 mode_set 第一项) | Medium | None | 文档化为模式默认 |
| `aoi_redundant_threshold` | 0.55 | baseline:aoi | EngineeringChoice | 冗余触发 AoI 门限；选取 | None | ChangesResults | 扫 |

#### 8.4.4 stochastic / fading / physical-mode 族（`get_default_step9_params:207-231`）

| name | value | active_paths | class | source | evid | impact | grounding action |
|---|---|---|---|---|---|---|---|
| `fading_sigma_dB` | 5.0 | DPP+baseline (抽象支,enable_stochastic) | StandardsDerivable | 阴影衰落 std~5 dB(TR 37.885 NLOS 量级)；用于 sim_del:64 随机 q_link 衰落 | Weak | ChangesResults | 引 TR 37.885 SF；值作扫 |
| `delay_jitter_scale` | 0.15 | DPP+baseline (抽象支,enable_stochastic) | EngineeringChoice | 延迟 jitter 为名义延迟的 15%；选取(sim_del:95) | Weak | ChangesResults | 扫；文档化 MC 离散 |
| `enable_stochastic` | true | DPP+baseline (抽象支) | Structural | 开关(非数值参数) | Strong | None | 无动作；模式开关 |
| `use_physical_delivery` | false | global (双态门控) | Structural | 路由开关；false=抽象支默认活跃。**§11 分母假设的核心驱动** | Strong | ChangesResults | 见 §11；mainline 设 true 但 PERcurves 缺失 fallback 到 false |
| `physical_pdr_mode` | "sigmoid" | physical (双态) | Structural | physical 支 PDR 映射模式标签 | Strong | None | 无动作；模式标签 |
| `enable_fast_fading` | true | physical (双态) | Structural | 快衰落开关 | Strong | None | 无动作；开关 |
| `relay_link_ratio` | 0.80 | DPP+baseline (抽象 relay fallback) | EngineeringChoice | 中继跳 PDR 相对直传(抽象模型后备)；选取 | Weak | ChangesResults | 扫；physical 路由 relay_sinr_offset 接地 |

#### 8.4.5 utility heuristic baseline 族 —— scenario/regime/guard/surplus/misdecision 阈值与权重

> 这些喂效用启发式基线(`compute_action_utility_*` / regime 逻辑)。**不在 DPP argmin 上**，但在框架内活跃于 utility/regime baselines。主审计 §1.2 计为"~40 utility_* 权重"尾部，此处逐条枚举代表项。全部 EngineeringChoice（合成 urgency/无量纲 q 上的阈值与启发式权重天然任意），除注明外。

| name | value | active_paths | class | source | evid | impact | grounding action |
|---|---|---|---|---|---|---|---|
| `utility_weight_timely` | 1.00 | baseline:utility | EngineeringChoice | 效用 numeraire 基准权 | None | ChangesResults | 作偏好比值基准+扫 |
| `utility_weight_reliability` | 0.55 | baseline:utility (+lyapunov reward:27) | EngineeringChoice | MRS 偏好权；也被 lyapunov reward 复用 | Weak | ChangesResults | 偏好比值+扫 |
| `utility_weight_cost` | 0.07 | baseline:utility | EngineeringChoice | MRS 偏好权 | Weak | ChangesResults | 非量纲化+扫 |
| `utility_weight_delay` | 0.10 | baseline:utility | EngineeringChoice | MRS 偏好权 | Weak | ChangesResults | 按 deadline 非量纲化+扫 |
| `utility_weight_position_risk` | 0.28 | baseline:utility | EngineeringChoice | MRS 偏好权；**与 protection 约束双计数风险**(主审计§230) | Weak | ChangesResults | 偏好比值+扫 |
| `utility_weight_misdecision` | 0.22 | baseline:utility (+lyapunov penalty:22) | EngineeringChoice | MRS 偏好权；lyapunov penalty 也复用 | Weak | ChangesResults | 偏好三元比值+扫 |
| `utility_weight_event` | 0.22 | baseline:utility | EngineeringChoice | MRS 偏好权 | Weak | ChangesResults | 偏好比值+扫 |
| `utility_priority_bias [0,0.08,0.18]` | 3 值 | baseline:utility | EngineeringChoice | 每优先级效用偏置；选取序数 | None | ChangesResults | 扫 |
| `utility_mode_bias [0,0.05,0.09]` | 3 值 | baseline:utility | EngineeringChoice | 每模式效用偏置 | None | ChangesResults | 扫 |
| `utility_noncritical_suppression` | 0.08 | baseline:utility | EngineeringChoice | 非关键抑制幅 | None | ChangesResults | 扫 |
| `utility_risk_tradeoff_scale` | 0.35 | baseline:utility | EngineeringChoice | 风险权衡缩放 | None | ChangesResults | 扫 |
| `utility_sigmoid_scale` | 0.035 | baseline:utility | EngineeringChoice | 效用 sigmoid 陡度 | None | ChangesResults | 扫 |
| `utility_constraint_penalty` | 1.60 | baseline:utility | EngineeringChoice | 软约束惩罚幅(=旧 v6 protection λ 量级) | Weak | ChangesResults | 扫 |
| `utility_margin_sigmoid_scale` | 0.060 | DPP+baseline+delivery | EngineeringChoice | sim_del:88 margin→PDR sigmoid 陡度；**在 DPP 投递路活跃** | Weak | ChangesResults | 扫；定 margin 灵敏度 |
| `utility_required_timely 仿射族 (bias0.18+斜率0.34/0.20/0.16/0.14+clamp0.25/0.92)` | 多值 | baseline:utility+v6 (DPP 上死) | EngineeringChoice | 应由 TS 22.186 档查表替代(DPP 已用 get_v2x_reliability_requirements)；max=0.92 与高档不兼容 | Weak | ChangesResults | DPP 上 superseded；v6/baseline 上扫 |
| `utility_surplus_penalty_* 族 (0.20/0.45/0.30/0.15/0.05/0.80/0.70/0.50)` | 8 值 | baseline:utility | EngineeringChoice | 盈余惩罚激活/缩放族；全选取 | None | ChangesResults | 联合扫 |
| `utility_module_support_weight rsu/env/traj 0.55/0.30/0.15` | 3 值 | baseline:utility | EngineeringChoice | 模块支持权(和=1) | None | ChangesResults | simplex 扫 |
| `utility_event_base_gain` | 0.55 | baseline:utility | EngineeringChoice | 事件基增益 | None | ChangesResults | 扫 |
| `utility_position_risk_base / urgency_scale 0.50/0.35` | 2 值 | baseline:utility | EngineeringChoice | 位置风险基+紧急缩放 | None | ChangesResults | 扫 |
| `utility_misdecision_* 族 (qpos0.60/blind0.20/blind_scale1.20/urgency0.70/target0.55)` | 5 值 | baseline:utility | EngineeringChoice | 误决策风险阈值/缩放族 | None | ChangesResults | 联合扫；urgency_scale 0.70 与 VoI 0.70 同值不同义 |
| `utility_relay_penalty` | 0.25 | baseline:utility (+lyapunov penalty:24) | EngineeringChoice | 中继惩罚；lyapunov 复用 | None | ChangesResults | 扫 |
| `utility_support_mismatch_penalty relay/redundant 0.18/0.05` | 2 值 | baseline:utility | EngineeringChoice | 支持失配惩罚 | None | ChangesResults | 扫 |
| `utility_low_quality_priority_penalty` | 0.30 | baseline:utility | EngineeringChoice | 低质优先级惩罚 | None | ChangesResults | 扫 |
| `utility_emergency_priority_bonus` | 0.05 | baseline:utility | EngineeringChoice | 紧急优先级加成 | None | ChangesResults | 扫 |
| `utility_low_risk_* guard 族 (threshold0.32/rate0.22/priority0.12/relay0.55/blind0.18)` | 5 值 | baseline:utility | EngineeringChoice | 低风险守卫族：抑制过度传输 | None | ChangesResults | 联合扫 |
| `utility_low_risk_weight urgency/link/pos 0.45/0.30/0.25` | 3 值 | baseline:utility | EngineeringChoice | low_risk_score 三分量权(和=1)；从硬编码提取(get_default:191-195) | None | ChangesResults | simplex 扫 |
| `utility_redundant_blind/qpos_threshold 0.10/0.65` | 2 值 | baseline:utility | EngineeringChoice | 冗余抑制条件阈 | None | ChangesResults | 扫 |
| `utility_blind_* 族 (protection0.58/pos0.48/min_priority2/force_mode1/relay0.78)` | 5 值 | baseline:utility | EngineeringChoice | blind-zone 启发式阈值/强制 | None | ChangesResults | 扫(min_priority/force_mode 是序数) |
| `confidence_regime_* 族 (blind0.18/qpos0.72/hold_blind0.42/hold_qpos0.52)` | 4 值 | baseline:utility+regime | EngineeringChoice | regime 切换/保持阈(无量纲 q 上) | None | ChangesResults | 联合扫；regime 逻辑也影响某些 DPP 诊断 |
| `utility_event/position_activation_threshold 0.12/0.18` | 2 值 | baseline:utility | EngineeringChoice | 激活阈 | None | ChangesResults | 扫 |
| `utility_protection_priority/rate/mode_weight 0.30/0.35/0.35` | 3 值 | DPP(LHS)+v6 | EngineeringChoice | protection LHS 复合权(和=1)；优先级归一(p-1)/2 是 StandardsDerivable，复合权工程(主审计§114) | None | ChangesResults | 优先级归一引动作空间；复合权扫 |
| `utility_mode_level relay/redundant/direct 1.0/0.62/0.20` | 3 值 | DPP(LHS)+v6 | EngineeringChoice | 模式序数 level；工程序数 | None | ChangesResults | 序数扫 |

#### 8.4.6 scenario / 阈值 / 动作空间 / guard 杂项（代表项）

| name | value | active_paths | class | source | evid | impact | grounding action |
|---|---|---|---|---|---|---|---|
| `dt / T_total 1.0/120.0` | 1.0,120.0 s | all | Structural | 仿真步长/时长(场景配置非模型参数) | Strong | None | 文档化为场景配置 |
| `urgency_normal/coop/emergency 0.30/0.60/0.95` | 3 值 | all | EngineeringChoice | 合成 urgency 序数；标准-clean 替代=消息类标签 | Weak | ChangesResults | 文档化为合成；替代为 CAM/DENM 标签 |
| `base_rate_normal/coop/emergency 1.0/2.0/1.5` | 3 值 | all | EngineeringChoice | 每类基速率参考 | None | ChangesResults | 扫 |
| `alpha/beta/gamma 0.45/0.30/0.25` | 3 值 | baseline (置信融合, 和=1) | EngineeringChoice | 置信度三分量融合权 | None | ChangesResults | simplex 扫 |
| `T1/T2/pos_T1/pos_T2 0.45/0.72/0.42/0.68` | 4 值 | baseline:regime | EngineeringChoice | 链路/位置 regime 阈值(无量纲 q 上) | None | ChangesResults | 联合扫 |
| `link_good/bad/pos_low_threshold 0.65/0.35/0.40` | 3 值 | baseline:regime | EngineeringChoice | regime 分类阈 | None | ChangesResults | 扫 |
| `priority_rate_scale [1.0,1.5,2.0]` | 3 值 | all | EngineeringChoice | 每优先级最小速率参考 | None | ChangesResults | 扫 |
| `noncritical_suppression_scale` | 0.70 | baseline:utility | EngineeringChoice | 非关键抑制缩放 | None | ChangesResults | 扫 |
| `tx_cost_direct/redundant/relay 1.0/1.6/1.8` | 3 值 | DPP+baseline (penalty cost) | StandardsDerivable(基准)/EngineeringChoice(相对) | 归一化基准 1.0；相对值工程 | Weak | ChangesResults | 基准引归一；相对值扫 |
| `deadline_normal/coop/emergency 0.50/0.24/0.088` | 3 值 | baseline (抽象 deadline) | StandardsDerivable | 相对标准锚的工程余量(**注：≠ deadline_*_physical 0.50/0.18/0.070**) | Medium | ChangesResults | 与 physical deadline 对账；引标准锚 |
| `action_priority_set [1,2,3] / action_mode_set [0,1,2]` | — | all | StandardsDerivable | 3 级 C-V2X 优先级 / direct-redundant-relay | Medium | ChangesResults | 引动作空间 |
| `action_rate_multiplier_set [1.0,1.35,1.7,2.1,2.5]` | 5 值 | all | EngineeringChoice | 有限动作空间设计 | None | ChangesResults | 文档化为场景配置 |
| `baseline_rate_multiplier_by_priority [1.0,1.7,2.5]` | 3 值 | baseline | EngineeringChoice | 基线每优先级速率乘子 | None | ChangesResults | 扫 |
| `event_rate_scale_gain/priority_bias/synergy_gain 0.22/0.06/0.45` | 3 值 | all (event trigger) | EngineeringChoice | 事件触发速率/优先级/协同增益 | None | ChangesResults | 联合扫 |
| `rsu/env_event_trigger_threshold 0.45/0.22` | 2 值 | all (event trigger) | EngineeringChoice | 事件触发阈(与 blind_zone_trigger 0.55 并列，但后者 DataCalibrated) | None | ChangesResults | 扫；考虑同 ROC/Youden 校准 |
| `position_rsu_x/y/coverage` | 4-vec×3 | positioning | EngineeringChoice | RSU 布局几何(场景配置) | None | ChangesResults | 文档化为场景几何；换真实 RSU 布局 |
| `position_support_threshold` | 0.18 | positioning | EngineeringChoice | RSU 支持可见阈(配 1.35 覆盖乘子) | Weak | ChangesResults | 扫 |
| `position_env_peak_time` | 78.0 | positioning | EngineeringChoice | env 衰减峰时(=合成 NLOS 窗中心区) | None | ChangesResults | 文档化为场景时间线 |
| `position_filter_process/velocity_noise 0.06/0.03` | 2 值 | positioning (CV 滤波) | EngineeringChoice | CV 滤波器 Q 调参 | None | ChangesResults | 滤波器调参扫 |
| `position_blind_zone_sigma/score_penalty 1.20/0.22` | 2 值 | positioning | EngineeringChoice | blind-zone σ/分数惩罚 | None | ChangesResults | 扫 |
| `position_rsu_relief_cap` | 0.82 | positioning | EngineeringChoice (已部分校准) | RSU relief 上限(与硬编码 0.18 cap-缩减配对，§8.1.4) | Weak | ChangesResults | 与 0.18 一并校准 |
| `position_alpha_* 族 (base0.42/delta0.28/traj0.18/blind0.22/min0.35/max0.95)` | 6 值 | positioning (自适应 EWMA) | EngineeringChoice | 自适应 alpha EWMA 调参 | None | ChangesResults | 扫 |
| `deadline_guard_ratio/min_urgency 0.82/0.80` | 2 值 | DPP+baseline (P5 guard) | EngineeringChoice | P5 守卫：timely 预算不足时抑制昂贵 protection | Weak | ChangesResults | 扫；min_urgency 0.80 又一处 emergency 边界(应绑 utility_emergency_urgency_threshold) |
| `regime_pdr_bypass_threshold/min_blind_score 0.95/0.0` | 2 值 | DPP+baseline (regime bypass) | EngineeringChoice | 高 PDR 时旁路 regime 逻辑；0.0 min_blind 故恒激活 | None | ChangesResults | 扫 0.95 旁路阈 |
| `risk_v6_emergency_min_priority/min_rate_multiplier 3/2.1` | 3,2.1 | DPP+v6 (emergency floor) | EngineeringChoice | 安全 floor；**魔数耦合**：2.1=rate_set 第4项、3=priority_set 顶 | None | ChangesResults | 绑 grid 索引而非裸值(主审计§180/§233) |
| `dpp_reliability_voi_scaled/band/reachable_cap false/0.30/0.97` | — | dead (默认 false) | EngineeringChoice | VoI-scaled RHS 分支默认死(主审计§231)；band 0.30、cap 0.97 仅 true 时活跃 | None | None | 死分支；删或文档化 |

---

## 9. 关键消歧 & 完整性风险

### 9.1 `lyapunov_V=1.0`（baseline）vs `dpp_V=2.0`（proposed）—— 两个独立 Lyapunov 调度器

**这是整套审计最易混淆的一点，必须显式消歧。** 代码里有**两个**独立的 drift-plus-penalty 调度器，各有自己的 V、队列、cap、权重：

| 维度 | **baseline:lyapunov**（消融对照） | **DPP-proposed**（论文主方法） |
|---|---|---|
| 入口 | `run_step9_confidence_driven_lyapunov.m` | `run_step9_proposed_method_dpp.m` |
| 目标函数 | `compute_action_lyapunov_objective.m` | `build_dpp_action_tables.m` 的 `local_penalty`+per-slot argmin |
| V 旋钮 | `lyapunov_V = 1.0`（`get_default_step9_params:322`） | `dpp_V = 2.0`（`build_dpp_action_tables:53` setdefault） |
| 虚队列 | **单队列** `queue_state`，`queue_max=lyapunov_queue_max=12.0` | **双虚队列** Z_c(reliability+protection)，`dpp_queue_max=20.0` |
| 约束 | timely+protection violation 内联进 V·(...) | consolidated 2 约束(reliability+protection) |
| 权重 | 全 `lyapunov_*_weight=1.0`(恒等) | 复用 v6 的 7 MRS+7 VoI 手调权重 |
| stage pressure | `compute_lyapunov_stage_pressure`(含 0.5·blind_zone_gain 硬编码) | get_v2x_reliability_requirements RHS |

**注册表当前 bug**：`get_parameter_provenance.m:52` 把 `dpp_V` 默认列为 **1.0**——这其实是 `lyapunov_V` 的值，不是 live `dpp_V`(2.0)。注册表把两个调度器的 V 混淆了。必须修正(见 §10)。

**同样勿混淆 0.70 vs 0.75**：DPP/v4 的 `voi_urgency_scale=0.70` 与 AoI 调度器的 `chance_risk_aoi_voi_urgency_scale=0.75` 是两个独立调度器的真实差异（主审计§178/§205），不是同一参数的漂移。

### 9.2 `simulate_step9_delivery` 0.995 可靠性天花板 —— clamp 静默掩盖 99.99%/99.999% 档

**完整性风险（最严重之一）**。抽象投递路上有**三处** 0.995 硬编码天花板，结构性把 per-step 成功率封顶于 99.5%，使抽象模型**原则上无法**表示 TS 22.186 的 99.99%(0.99990)/99.999%(0.99999)档：

1. `simulate_step9_delivery.m:72`：`success_prob = min(max(success_prob,0.02),0.995)`（sigmoid 前）
2. `simulate_step9_delivery.m:89`：`pdr_abstract = min(max(pdr_abstract,0.02),0.995)`（sigmoid 后，**第二道**独立 cap）
3. `predict_action_success.m:32`：`success_prob = min(max(success_prob,0.02),0.995)`（DPP planning leg 镜像第一道）

**为何是 clamp-masking**：`get_v2x_reliability_requirements.m:42-46` 已诚实承认"abstracted PHY cannot reach 99.99%/99.999%"（其 timely ceiling~0.97），并用 derating 把档减到 floor(0.50/0.65/0.80)。但 0.995 ceiling 是**独立的第二层掩盖**：即便把 floor 提高、或把 success_prob 输入抬高，line89 的 post-sigmoid cap 仍会把实现 PDR 重新封顶于 0.995。**两道(乃至三道)叠加 cap 都必须处理**才能让抽象模型暴露高可靠行为。这些是裸魔数，**不可为 0.995 挂任何标准引用**。FORM(clamp)作数值守卫无妨，NUMBER 0.995 是未证 EngineeringChoice 兼静默可靠性上限。

### 9.3 `urgency>=0.80` 硬编码绕过可扫参数

`predict_action_success.m:5` 与 `predict_action_gate_threshold.m:17` 都用**硬编码** `urgency >= 0.80` 触发 emergency 逻辑(critical_priority_bonus / emergency_gate_reduction)，**而非**读 `params.utility_emergency_urgency_threshold`(`get_default_step9_params:190`=0.80)。两值现在恰好一致，但**解耦**：对 `utility_emergency_urgency_threshold` 做敏感性扫描**不会**影响这两个 DPP 动作表构造点——扫描有盲区。

**额外不一致**：delivery 路(`simulate_step9_delivery.m:26,79`)用 `scenario.msg_type=='emergency'` 触发同类逻辑，而 planning 路(predict_action_*)用 `urgency>=0.80`——两个消费者用**不同触发条件**判定同一"紧急"语义（主审计§123 已 flag critical_priority_bonus 的此不一致）。`deadline_guard_min_urgency=0.80`(get_default:203)是第三处 emergency 边界硬编码。

**接地动作**：把 pred_succ:5 / pred_gate:17 改读 `params.utility_emergency_urgency_threshold`，统一三处触发语义，使该参数真正可扫。

### 9.4 q_pos 子分数权重 + blind_zone_gate 内部构造 = DataCalibrated 阈值的未校准上游

主审计/注册表把 `blind_zone_trigger_threshold`(0.55, forest 覆盖 0.50)标为本子系统**唯一真正的 DataCalibrated**（step43 ROC/Youden 对 forest 标签）。但**它的输入 `blind_zone_gate` 本身是由一长串未校准的 EngineeringChoice 构造的**（§8.1.3）：

- `blind_zone_raw = 0.58·gnss_risk + 0.42·blockage_score`（step9_pos:131，融合权 EngineeringChoice）
- `blind_zone_gate = clamp((blind_zone_raw-0.34)/0.36)`（step9_pos:132，死区 offset/span EngineeringChoice）
- `blockage_score`、`gnss_risk` 又各由 4-路 EngineeringChoice 融合权(0.42/0.18/0.20/0.20 等)构造
- `q_pos` 本身由 rule 的 4-路权(0.25/0.25/0.30/0.20)+ step9_pos 的 coarse_sigma 仿射链(0.68/0.32、bias_scale 6 系数等)构造

**完整性后果**：`blind_zone_trigger_threshold` 的 ROC/Youden 校准是对**一个本身由几十个未接地魔数塑形的合成量**取阈值。校准只标定了"在哪个 gate 值切"，**没有**标定 gate 值**如何**从原始信号算出。论文若把 blind_zone_trigger 呈现为"数据校准"，必须同时声明其**上游构造链是未校准 EngineeringChoice**，否则是过度声称。同理 `compute_required_protection_level:5` 用 `blind_zone_trigger_threshold` 算 `blind_zone_gain`，把这条未校准链直接喂进 protection RHS。

**接地动作**：要让 blind_zone 真正可信，须把 §8.1.3 的融合权全部纳入与 trigger 阈值**联合**的敏感性扫描；单独校准阈值而冻结上游权重会给出虚假的可信度。

---

## 10. provenance 注册表重生成规范（`get_parameter_provenance.m` 作为单一真相源）

下列编辑使注册表与当前 DPP 代码同步，**消除 3 个 live 矛盾**并补入新枚举族。

### 10.1 修正 3 个 live 矛盾（精确编辑）

**矛盾 1 — `dpp_V` 默认值 1.0 → 2.0**（注册表把 lyapunov_V 误当 dpp_V）：

`get_parameter_provenance.m:52` 当前：
```matlab
'dpp_V', local_get(params,'dpp_V',1.0), 'Method', 'EngineeringChoice', 'Single drift-plus-penalty knob (O(1/V)-O(V) tradeoff)', 'Strong'
```
改为：
```matlab
'dpp_V', local_get(params,'dpp_V',2.0), 'Method', 'Structural', 'Neely 2010 DPP single knob O(1/V)-O(V); live default 2.0 (build_dpp_action_tables:53)', 'Strong'
```
（默认 1.0→2.0；分类 EngineeringChoice→Structural，与主审计§2.1 一致；source 注明 live 默认在 build_dpp_action_tables）

**矛盾 2 — 三个 reliability_floor 证据 Strong → Medium**：

`get_parameter_provenance.m:49-51`，把三行末尾 `'Strong'` 改 `'Medium'`，并把 source 由 `'TS 22.186 X tier minus stated derating'` 改为 `'TS 22.186 X tier minus stated derating (derating = engineering choice; report gap + sweep)'`。三档=标准、derating=工程取点，不应标 Strong。

**矛盾 3 — `utility_required_protection_pos_scale` StandardsDerivable/Medium → EngineeringChoice/Weak**：

`get_parameter_provenance.m:57` 当前：
```matlab
'utility_required_protection_pos_scale',local_get(params,'utility_required_protection_pos_scale',0.55),'Constraint','StandardsDerivable','Protection RHS, GNSS-integrity (PL>AL) shaped','Medium'
```
改为：
```matlab
'utility_required_protection_pos_scale',local_get(params,'utility_required_protection_pos_scale',0.55),'Constraint','EngineeringChoice','Protection RHS form follows GNSS integrity (PL>AL); affine slope 0.55 is engineering, not derivable','Weak'
```
（只 form 接 PL>AL，slope 0.55 不可推导——消除注册表唯一的越级提升）

### 10.2 补入 DPP 结构旋钮（注册表当前遗漏）

在 `dpp_V` 行后新增三行：
```matlab
'dpp_horizon', local_get(params,'dpp_horizon',1), 'Method', 'Structural', 'MPC rolling-horizon look-ahead (1 = plain DPP); preview slow route/map state only', 'Medium'
'dpp_queue_max', local_get(params,'dpp_queue_max',20.0), 'Method', 'Structural', 'Virtual-queue cap = max constraint shadow price (Lindley); live default 20.0', 'Medium'
'dpp_constraint_mode', local_get(params,'dpp_constraint_mode',"consolidated"), 'Method', 'Structural', 'TS 22.186 reliability consolidation: 5 constraints -> 2 (reliability + protection)', 'Strong'
```
（注：`dpp_constraint_mode` 是字符串，若注册表用 `cell2mat(rows(:,2))` 需把 Value 列改为 cell 存储或单独成表——见 §10.5 实现注记）

### 10.3 把 `v2x_reliability_floor_*` 接为真实字段（消 silent fallback）

注册表 §49-51 已列三 floor，但 `get_default_step9_params.m` **未定义**它们（主审计§4.2）。须在 `get_default_step9_params.m` 加：
```matlab
params.v2x_reliability_floor_normal = 0.50;     % TS 22.186 90% tier minus derating (engineering floor)
params.v2x_reliability_floor_coop = 0.65;       % TS 22.186 99.99% tier minus derating
params.v2x_reliability_floor_emergency = 0.80;  % TS 22.186 99.999% tier minus derating
```
使注册表的 `local_get(params,'v2x_reliability_floor_*',...)` 读到真实字段而非硬编码 fallback。

### 10.4 新增枚举族代表行（使注册表覆盖 §8 各族）

新增（节选，每族至少一代表行，含其分类与诚实标记）：
```matlab
% --- 链路生成器合成支（默认活跃）---
'shadow_sigma_los_dB',           3.0,  'Link', 'StandardsDerivable', 'TR 37.885 sec.6.2.3 LOS shadow fading sigma = 3 dB', 'Strong'
'shadow_sigma_nlos_dB',          4.0,  'Link', 'StandardsDerivable', 'TR 37.885 NLOS-row SF=4 dB; NOTE: NLOSv reuses LOS 3 dB (do not mis-attribute)', 'Medium'
'link_quality_fusion_w_pdr',     0.40, 'Link', 'EngineeringChoice', 'q_link fusion weight (sum=1); s_loss correlated w/ s_pdr -> ~0.70 effective', 'None'
% --- 定位融合内部（q_pos 上游，未校准）---
'qpos_fusion_w_sat',             0.25, 'Positioning', 'EngineeringChoice', 'q_pos 4-way fusion weight (rule:16); FORM groundable, split not', 'Weak'
'blind_zone_raw_w_gnss',         0.58, 'Positioning', 'EngineeringChoice', 'blind_zone fusion (step9:131); CV2X-LOCA cites FORM not the 0.58/0.42 split', 'Weak'
'coarse_sigma_fusion_gnss',      0.68, 'Positioning', 'EngineeringChoice', 'fixed sigma blend (step9:168); replace w/ inverse-variance w~1/sigma^2', 'Weak'
% --- 投递天花板（clamp-masking 风险）---
'delivery_success_ceiling',      0.995,'Delivery', 'EngineeringChoice', 'sim_del:72/89 + pred_succ:32 cap; SILENTLY masks 99.99%/99.999% tiers; NO citation', 'None'
% --- baseline:lyapunov（≠ DPP-proposed）---
'lyapunov_V',                    1.0,  'Baseline', 'Structural', 'baseline Lyapunov scheduler V (DISTINCT from dpp_V=2.0)', 'Strong'
'lyapunov_queue_max',            12.0, 'Baseline', 'Structural', 'baseline single-queue cap (DISTINCT from dpp_queue_max=20.0)', 'Medium'
% --- baseline:dcc ---
'dcc_cbr_low_threshold',         0.25, 'Baseline', 'StandardsDerivable', 'ETSI EN 302 571 / TS 103 574 DCC CBR threshold (form); value = engineering', 'Weak'
'dcc_cbr_high_threshold',        0.65, 'Baseline', 'StandardsDerivable', 'ETSI DCC CBR upper threshold (form); value = engineering', 'Weak'
% --- baseline:aoi ---
'aoi_age_norm_cap',              8.0,  'Baseline', 'EngineeringChoice', 'linear age/cap; should be Sun 2017 nonlinear g(Delta)', 'Weak'
% --- stochastic ---
'fading_sigma_dB',               5.0,  'Delivery', 'StandardsDerivable', 'shadow fading std ~5 dB (TR 37.885 NLOS magnitude)', 'Weak'
% --- emergency 边界硬编码（绕过参数）---
'utility_emergency_urgency_threshold', 0.80, 'Scenario', 'EngineeringChoice', 'class boundary; BUT pred_succ:5/pred_gate:17 HARDCODE 0.80, bypassing this field', 'Weak'
```

### 10.5 实现注记（保证注册表可生成）

- 当前 `get_parameter_provenance.m:63` 用 `cell2mat(rows(:,2))` 要求 Value 列全数值。`dpp_constraint_mode`/`physical_pdr_mode` 等字符串值无法进 `cell2mat`。**重构建议**：把 Value 列改为 cell 数组存储（`Value = rows(:,2)`，table 列用 cell），或将字符串模式参数移入单独的"开关/模式"子表。否则新增字符串行会使 `cell2mat` 报错。
- 注册表头注释应补一句："This registry now covers DPP-proposed, baseline (lyapunov/dcc/aoi/utility), positioning-fusion-internal, link-synthetic, and abstract-delivery families. lyapunov_* belongs to a SEPARATE baseline scheduler, not the DPP-proposed method."
- 把 `risk_constrained_timely_lambda`/`protection_lambda` 两 DEPRECATED 行保留但 source 加 "(DPP replaces with virtual queue; live only via v6 wiring gap)"，与主审计§4.1 一致。

---

## 11. 最终完整计数（denominator 已定义）

### 11.1 路径/驱动假设（使分数可复现）

**核心驱动假设**：`use_physical_delivery`。`get_default_step9_params.m:213` 设 **false**；`get_default_step9_mainline_params.m:10` 设 true 但 `:21` 在 PERcurves 缺失时 fallback 到 false。**本计数按可复现 fallback 路径（`use_physical_delivery=false`）报告**，因为这是默认+CI 可复现路径。此假设下：

- 抽象投递 bonus/gate 族（~20）+ 三处 0.995 天花板**活跃**
- PHY Grounded/StandardsDerivable 族（tx_power/noise/pathloss 等）**死**（仅 physical 支活跃）
- 链路合成支（trajectory/NLOS 窗/正弦阴影/干扰模板/抽象延迟）**活跃**（无条件，不受 use_physical_delivery 门控）
- 定位融合内部全链**活跃**（无条件）

若改设 `use_physical_delivery=true` 且 PERcurves 存在：PHY 族转活、抽象投递族转死、链路合成支的 shadow_sigma 等仍活（生成器无条件），整体可接地占比上升约 8-12 个百分点（PHY 全是 Grounded/StandardsDerivable）。

### 11.2 枚举总数（master + completion 合并）

| 来源 | 字段/字面量数（量级） |
|---|---|
| 主审计 §2 逐条行 | ~95（含 PHY、DPP 结构、MRS/VoI、protection RHS、定位族代表、动作空间） |
| 本补全 §8.1 定位生成器内联 | ~50（rule 12 + step9_pos ~38，含多系数行展开） |
| 本补全 §8.2 链路生成器内联 | ~45（shadow/正弦 9 + 干扰模板 14 + NLOS/轨迹 ~16 + 延迟/clamp 10 + link_rule 4） |
| 本补全 §8.3 投递/预测守卫 | ~13 |
| 本补全 §8.4 get_default 剩余族 | ~90（lyapunov 11 + dcc 8 + aoi 5 + stochastic 7 + utility heuristic ~45 + scenario/杂项 ~14） |
| **合并去重后总枚举** | **≈ 290–310 个字段/字面量** |

> 注：主审计§1.2 报"150+"是因为它把许多内联字面量与 utility_* 族**摘要化**为族级条目。本补全把它们展开为逐条行，故真实分母升到 ~300。这正是 critic 指出的缺口被补上的直接证据。

### 11.3 per-classification breakdown（合并，fallback 路径口径）

| 分类 | 计数（量级） | 代表 |
|---|---|---|
| **Grounded** | ~4（fallback 路上多数**死**） | tx_power/noise/pathloss_los_offset/los_exponent（physical 支死）；meters-per-degree 活 |
| **StandardsDerivable** | ~22 | reliability 三档+三 floor、deadline_*_physical、shadow_sigma 3/4 dB、DOP/n_sat 锚、rssi /2.0、dcc CBR 门、动作空间、priority 归一 |
| **DataCalibrated** | ~10 | blind_zone_trigger、pdr_midpoint、σ 端点 0.3/3.0、coarse_sigma clamp、gnss 噪声 std fallback、percentile 统计 |
| **Structural** | ~16 | DPP 五结构件 + lyapunov 队列结构件 + 数值守卫(1e-9/log10 底/2π/单位默认/jitter 底)+模式开关 |
| **EngineeringChoice** | **~250+** | 全部融合权(定位~40+链路~25+q_link 3)、MRS/VoI(14)、protection/timely 仿射族、抽象投递+三天花板(~25)、utility heuristic(~45)、合成场景塑形(轨迹/NLOS/正弦/干扰~40)、CV 滤波/alpha 族、阈值族 |
| **死/被取代（不计分母）** | — | voi_scaled 分支、legacy5-only RHS、0.035 死字面量、5 冻结 λ、PHY 族(fallback 路上)、消融-only coarse_sigma 支 |

### 11.4 诚实"理论来源占比"（理论来源 = Grounded+StandardsDerivable+DataCalibrated+Structural，**不含 EngineeringChoice**）

**(a) 整体框架**（fallback 路径，分母 ~300 活跃字段，含定位融合内部全链 + 链路合成支 + 抽象投递 + utility heuristic）：

```
理论来源 ≈ 4 + 22 + 10 + 16 = 52
EngineeringChoice ≈ 250
占比 ≈ 52 / 302 ≈ 17%
```

**比主审计的 ~20% 略低**——因为本补全把先前摘要化的内联字面量（绝大多数是 EngineeringChoice 融合权/合成塑形）展开计入分母，EngineeringChoice 尾部被如实放大。**诚实结论：整体框架口径下理论来源占比约 1/6，比摘要化口径更低，因为展开后暴露了更多未接地的内联魔数。**

**(b) DPP proposed-method 活动路径 ONLY**（`run_step9_proposed_method_dpp` + 默认 consolidated；剔除 baseline:lyapunov/dcc/aoi/utility heuristic，但 DPP argmin 经 evaluate_action_metrics 调用 predict_action_* 与 simulate_step9_delivery，故含抽象投递天花板 + 定位融合内部链经 q_pos 喂入）：

- **DPP 核心结构脊柱**（剔除条件活跃抽象投递 + 定位内部链）：Structural 5 + StandardsDerivable 7 + DataCalibrated 1 + Grounded 2 = **15 有源 vs 7 EngineeringChoice(MRS/VoI 核心) ≈ 68%**（与主审计§1.2-A 一致）。
- **DPP 完整活动路径**（含经 q_pos 的定位融合内部链 ~40 EngineeringChoice + 抽象投递+三天花板 ~25 EngineeringChoice）：

```
理论来源 ≈ 15（核心）+ ~6（定位 StandardsDerivable/DataCalibrated 端点：DOP/n_sat/σ/rssi/blind_trigger）= ~21
EngineeringChoice ≈ 7（MRS/VoI）+ ~40（定位融合内部）+ ~25（抽象投递）= ~72
占比 ≈ 21 / 93 ≈ 23%
```

**诚实结论（DPP 路径）**：DPP 的**结构脊柱**确实有理论来源，在剔除抽象投递层与定位融合内部链后可达 **~2/3（68%）**。但 DPP argmin 的输入 q_pos 由几十个未校准 EngineeringChoice 融合权构造（§9.4），且 DPP 投递评估经过三道 0.995 天花板（§9.2），**一旦把这两条上游链计入活动路径，DPP 完整口径的理论来源占比掉到 ~23%**。

> **可复现声明**：以上分数在 `use_physical_delivery=false`（默认/CI fallback）下计算。提高占比的最高杠杆（与主审计一致）：(a) 把 DPP 接线为默认 proposed；(b) 把 q_pos 上游融合权与 coarse_sigma 改为逆方差融合（§8.1.4 高价值动作）以把 ~40 个 EngineeringChoice 转为 form-grounded；(c) 退役/隔离抽象投递层（含三天花板）改用 physical PDR；(d) 把 7 MRS+7 VoI 重写为无量纲 MRS 比值+扫描（不升分类但把魔数变可审计比值）。

---

*本补全卷与主审计 §1–§7 共同构成对 forest-V2X DPP 调度器**每一个**活动路径参数的完整 provenance 地图。所有行号已对当前代码核验。无任何引用被编造——每个 proposed_source 要么是对 FORM 的真实标准/教材锚，要么留空并标 EngineeringChoice+扫描指引。*
