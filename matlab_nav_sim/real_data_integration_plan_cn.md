# 真实数据接入计划（面向 Step9-13 主线）

## 1. 什么时候开始

结论：`现在就开始`，不要再把 `Step1-8` 当成主论文主线继续增强。

- `Step1-8` 的定位：
  - 机制验证
  - 代码平台搭建
  - 可放附录或前置基础实验
- `Step9-13` 的定位：
  - 主方法验证
  - 主实验与主图表
  - 主投稿证据链

也就是说，从 `2026-05-27` 这一步开始，真实数据应优先接入 `Step9` 的外部输入层，而不是回头继续美化 `Step1-8`。

## 2. 当前代码已经具备的真实数据接口

现有主线已经支持五类外部输入：

- 轨迹：`trajectory_file`
- RSU 布局：`rsu_layout_file`
- 遮挡/盲区：`blockage_profile_file`
- GNSS 退化：`gnss_config_file`
- 消息事件：`message_profile_file`

相关代码入口：

- [get_default_step9_data_backed_config.m](C:\Users\11820\Documents\Codex\2026-05-22\v2x-v2v-1-vehicle-to-everything\matlab_nav_sim\get_default_step9_data_backed_config.m)
- [load_step9_external_inputs.m](C:\Users\11820\Documents\Codex\2026-05-22\v2x-v2v-1-vehicle-to-everything\matlab_nav_sim\load_step9_external_inputs.m)
- [generate_step9_scenario.m](C:\Users\11820\Documents\Codex\2026-05-22\v2x-v2v-1-vehicle-to-everything\matlab_nav_sim\generate_step9_scenario.m)
- [step9_generate_link_state_wilab_like.m](C:\Users\11820\Documents\Codex\2026-05-22\v2x-v2v-1-vehicle-to-everything\matlab_nav_sim\step9_generate_link_state_wilab_like.m)

## 3. 先接哪些真实数据集

### 第一优先级：V2X-Seq

用途：优先提供 `时序轨迹`、`路侧单元场景关系`、`事件时序`。

适合原因：

- 是顺序型 V2X 数据，不是纯单帧
- 有 trajectories / vector maps / traffic lights
- 比 DAIR-V2X 更适合你现在这种“时序调度”主线

建议接入字段：

- `trajectory_file`
- `message_profile_file`
- 部分 `rsu_layout_file`

### 第二优先级：DAIR-V2X

用途：补 `车-路配对关系`、`路侧位置`、`遮挡场景标签提取`。

适合原因：

- 真实 V2I 数据
- 车端与路侧同步关系明确
- 很适合抽取“关键盲区”和“稀疏 RSU 覆盖”场景

建议接入字段：

- `rsu_layout_file`
- `blockage_profile_file`
- `trajectory_file`

### 第三优先级：UrbanNav 或 Boreas

用途：补 `GNSS/IMU 退化序列`，给 `q_pos` 提供真实退化来源。

适合原因：

- 你现在主线里最虚的一层，不是调度本身，而是 `GNSS 质量退化` 还主要靠规则构造
- 这类数据集可以给你真实的 GNSS/INS 时序特征

建议接入字段：

- `gnss_config_file`

## 4. 为什么不是“找一个数据集全包”

当前题目不是传统感知任务，也不是单纯定位 benchmark。

你要验证的是：

1. 定位可信度如何变化
2. 稀疏路侧辅助何时值得触发
3. 遮挡盲区下应急消息如何调度

公开数据集通常只覆盖其中一部分，所以更合理的做法不是强行找一个“全能数据集”，而是做 `分层拼接`：

- V2X 数据集负责 `轨迹/路侧/遮挡`
- GNSS/INS 数据集负责 `定位退化`
- 链路层用 `文献校准 + 外部遮挡输入`

这条路线比“全靠理想化手工曲线”真实，也比“空等一个完美林区数据集”可执行。

## 5. 具体怎么喂到现有代码

### 5.1 轨迹层

目标：生成 `trajectory_file`

CSV 目标字段：

- `t`
- `tx_x`
- `tx_y`
- `rx_x`
- `rx_y`
- `relay_available`（可选）

做法：

1. 从 V2X-Seq 或 DAIR-V2X 提取车端与路侧/对向体的时序坐标
2. 统一到同一时间轴
3. 重采样到当前 `Step9` 使用的采样间隔
4. 导出为 CSV

### 5.2 RSU 布局层

目标：生成 `rsu_layout_file`

CSV 目标字段：

- `rsu_x`
- `rsu_y`
- `coverage`

做法：

1. 从 DAIR-V2X / V2X-Seq 提取路侧设备坐标
2. 若原数据没有直接覆盖半径，则按场景范围估算初值
3. 后续在灵敏度分析中对 `coverage` 做扰动

### 5.3 遮挡层

目标：生成 `blockage_profile_file`

CSV 目标字段：

- `t`
- `is_nlos`
- `nlosv`
- `shadowing_dB`
- `interference_dB`

做法：

1. 从时序标注中识别“遮挡发生区段”
2. 将遮挡先离散成 `LOS / NLOS`
3. 再把遮挡强度映射成 `shadowing_dB`
4. 若没有真实通信测量值，不要伪装成实测，明确写成“由视觉遮挡状态映射得到的链路退化代理变量”

### 5.4 GNSS 退化层

目标：生成 `gnss_config_file`

CSV 目标字段：

- `t`
- `n_sat`
- `dop`
- `sigma_pos`
- `dt_upd`

做法：

1. 从 UrbanNav / Boreas 提取可用的 GNSS/INS 质量信息
2. 若原始数据没有完整四项，就先保证 `sigma_pos` 与 `dt_upd`
3. `n_sat`、`dop` 缺失时可用数据集已有质量指标做代理，但必须在论文中声明

### 5.5 消息事件层

目标：生成 `message_profile_file`

CSV 目标字段：

- `t`
- `msg_type`
- `relay_available`

做法：

1. 依据时序轨迹和盲区事件定义 `routine / cooperative / emergency`
2. 在盲区接近、会车风险上升、定位可信度下降等时段插入 `emergency`
3. 不要把事件完全随机生成，要让事件与真实轨迹和遮挡区段对齐

## 6. 你现在最该做的顺序

### 第一步：先把 V2X-Seq 接进来

原因：

- 对 Step9 主线最直接
- 最容易先产出真实时序轨迹
- 能最早替换掉你现在模板里的假轨迹

产出物：

- 一份真实版 `trajectory.csv`
- 一份真实版 `message_profile.csv`

### 第二步：再用 DAIR-V2X 补 RSU 与遮挡

原因：

- 你的题目核心是“关键盲区的稀疏 V2I 辅助”
- 只换轨迹还不够，必须把 `盲区` 和 `RSU 位置` 也接实

产出物：

- 一份真实版 `rsu_layout.csv`
- 一份真实版 `blockage_profile.csv`

### 第三步：最后用 UrbanNav / Boreas 补 GNSS 退化

原因：

- 这样 `q_pos` 的变化不再主要由手工参数决定
- 可以明显增强“定位可信度驱动调度”这条主线的可信度

产出物：

- 一份真实版 `gnss_config.csv`

## 7. 对论文主线最关键的说法

你后面论文里不要写成：

- “本文基于完全真实的林区实测数据进行验证”

因为这不成立。

更稳妥的写法是：

- “本文采用公开真实数据集提取时序轨迹、路侧布局与定位退化特征，并结合面向林区应急场景的可解释参数化链路模型，构建数据支撑的半实景仿真框架。”

这句话是能站住的。

## 8. 现阶段的最小可执行目标

在下一轮，不要同时接五类数据。

最小闭环应是：

1. 用 `V2X-Seq` 生成真实 `trajectory_file`
2. 生成与轨迹对齐的 `message_profile_file`
3. 让 `main_step9_confidence_driven_scheduling.m` 跑通
4. 对比“模板轨迹”与“真实轨迹输入”下的 `Step9/10/12`

只要这一步打通，你的主线就已经从“理想化原型”跨到“数据支撑仿真主线”。

## 9. 参考来源

- DAIR-V2X 官方 GitHub: https://github.com/AIR-THU/DAIR-V2X
- DAIR-V2X CVPR 2022: https://openaccess.thecvf.com/content/CVPR2022/papers/Yu_DAIR-V2X_A_Large-Scale_Dataset_for_Vehicle-Infrastructure_Cooperative_3D_Object_Detection_CVPR_2022_paper.pdf
- V2X-Seq 论文入口: https://arxiv.org/abs/2305.05938
- V2X-Real 官方页面: https://mobility-lab.seas.ucla.edu/v2x-real/
- UrbanNav 官方仓库: https://github.com/IPNL-POLYU/UrbanNavDataset
- Boreas 数据集页面: https://registry.opendata.aws/boreas/
