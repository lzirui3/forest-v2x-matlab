# IEEE VTC 升级状态总览

## 1. 当前判断

当前项目已经从“可运行原型”升级到“接近 IEEE VTC 级别的实验型稿件基础”。

最核心的提升已经完成：
- 主方法主线已稳定
- 林区几何驱动场景链已形成
- 文献来源基线已补入
- 物理层一致性问题已修复并重跑主统计链
- 启发式主线已有 `Lyapunov drift-plus-penalty` 理论化变体支撑

但距离真正可投 `IEEE VTC`，仍有两个最关键缺口：
- `G1`：WiLab PER 表交叉验证尚未形成正式结果包
- `论文组织层`：尚未把现有代码与结果整理成完整投稿稿件结构

## 2. 已基本解决项

### F1. 数学形式化缺失
状态：`部分解决，已足以缓解拒稿风险`

证据：
- `routeB_support_report.md`
- `step23_lyapunov_vs_heuristic_report.md`

结论：
- 启发式主线仍保留为经验性能最佳版本
- `Lyapunov` 版本已形成正式理论化变体
- `Step23` 证明理论版本不是空壳，而是一个明确体现 cost-performance tradeoff 的调度器

当前最合理定位：
- 主文：heuristic mainline
- 理论支撑：Lyapunov counterpart

### F2. 仿真器与决策器物理模型不一致
状态：`已解决`

证据：
- `simulate_step9_delivery_physical.m`
- `predict_action_pdr_physical.m`
- `predict_mixture_timely_prob.m`
- `predict_action_delay_physical.m`
- `step17_main3_paper_statistics_report.md`

结论：
- relay 模式的两跳独立信道模型已在仿真器与预测器中统一
- `Step17 main3` 已按修复后一致模型重跑
- 主结论未翻转

### F3. 缺少已发表文献方法对比
状态：`已解决`

证据：
- `run_step9_baseline_dcc_like.m`
- `run_step9_baseline_aoi.m`
- `step25_literature_baselines_report.md`

结论：
- 已有两个文献来源思路 baseline：
  - `DCC-like`
  - `AoI-aware`
- 在 `ForestParam` 与 `ForestGeometryDemo` 下，`Confidence-driven` 仍保持领先

### S1. 场景真实性存疑 / 林区参数标定不可追溯
状态：`大体解决`

证据：
- `calibrate_forest_scene_params.m`
- `forest_calibration_report.md`
- `get_forest_dataset_calibrated_params.m`

结论：
- 已从“存在文件即硬编码参数”升级为“数据统计 + 文献引导映射”的可追溯标定链
- `pathloss_exponent` 的量纲问题已被显式解释为仿真器内部 `10*alpha` 表示法

### G5. 林区特异性建模
状态：`强解决`

证据：
- `prepare_step9_forest_geometry_inputs.m`
- `main_step20_forest_geometry_multiseed.m`
- `main_step21_forest_geometry_matrix_multiseed.m`
- `step20_forest_geometry_multiseed_report.md`
- `step21_forest_geometry_matrix_report.md`
- `step22_forest_geometry_plus_report.md`

结论：
- 已形成：
  - 单一林区几何驱动 demo
  - `3 路型 × 3 植被密度` 的场景矩阵
  - 方法二 `plus` 真实性增强补充分支
- 结果已表明方法优势主要集中在：
  - `curved/blind + medium/dense`

## 3. 部分解决项

### G4. 参数选择缺乏系统化方法
状态：`部分解决`

证据：
- `step18_lite_parameter_grid_search.csv`
- `routeB_support_report.md`

结论：
- 关键 heuristic 参数已经做过 reduced grid search
- 可以证明当前 heuristic 设置位于高分区域，而非纯随意选取

仍不足之处：
- 尚未形成全参数或关键参数的系统优化报告
- 尚未给出严格的 Pareto 前沿图或更完整的稳定区间分析

## 4. 仍未完成的 VTC 级关键缺口

### G1. WiLab PER 表交叉验证
状态：`未正式完成`

现状：
- 代码链已铺好：
  - `sinr_to_pdr_physical.m`
  - `step9_wilab_like_sinr_to_pdr.m`
  - `main_step19_per_lookup_validation.m`
- 但尚未形成一套最终可引用的正式报告，明确回答：
  - sigmoid 近似对端到端指标偏差是否足够小
  - 方法排序是否保持不变

这项是当前最值得优先补齐的 VTC 级硬缺口。

### 论文组织层
状态：`未开始系统收口`

当前缺少：
- 系统模型图
- 算法伪代码
- 参数表与来源表
- 实验章节正式叙述
- related work 与 baseline 位置说明
- “heuristic 主线 + Lyapunov 支撑 + realism augmentation + literature baselines” 的统一结构

## 5. 当前最合理的 VTC 投稿定位

更合适的投稿叙述是：
- 主方法：`Confidence-driven heuristic mainline`
- 理论支撑：`Lyapunov formalized counterpart`
- 场景贡献：`Forest geometry / vegetation matrix`
- 补充真实性实验：`ForestGeometryPlus`
- 文献基线：`DCC-like + AoI-aware`

不建议当前定位为：
- “纯理论最优调度稿”
- “强物理传播测量拟合稿”

更适合定位为：
- `面向林区 V2X 预警调度的实验型/系统型稿件`

## 6. 下一步优先级

### 第一优先级
完成 `Step19` 正式结果包：
- `PER lookup vs sigmoid`
- 输出正式 report
- 确认端到端排序稳定

### 第二优先级
把现有结果整理成投稿所需结构：
- 方法章节
- 实验章节
- 图表与参数表

### 第三优先级
如果还有时间，再加强：
- 参数系统化搜索（G4）
- 方法二 `plus` 的轻量回调

## 7. 一句话总结

当前项目已经具备 `IEEE VTC` 级别的核心实验骨架和主要证据链，
距离正式投稿还差：
- `Step19` 物理层真实性交叉验证正式结果
- 论文组织与写作层的系统收口
