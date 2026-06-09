# 运行说明

## 工作目录
- MATLAB 主目录：`D:\matlab bussiness\forest_v2x_matlab_package\matlab_nav_sim`
- 数据目录：`D:\matlab bussiness\forest_v2x_matlab_package\external_data`

## 推荐启动方式
在 MATLAB 中执行：
```matlab
cd('D:\matlab bussiness\forest_v2x_matlab_package\matlab_nav_sim');
```

## 推荐实验入口
### 基础层
```matlab
main_step1_truth
main_step2_imu
main_step3_fusion
```

### 论文主线
```matlab
main_step9_confidence_driven_scheduling
main_step10_position_ablation
main_step11_sensitivity
main_step12_multiseed_statistics
main_step13_scenario_expansion
```

## 当前主线说明
`main_step9_confidence_driven_scheduling` 默认走：
- V2X-Seq 数据驱动场景输入
- 物理投递模型 `simulate_step9_delivery_physical`

## 若运行时报 PER 曲线缺失
说明当前目录下缺少 WiLabV2Xsim 的 `PERcurves` 资源。可以通过以下任一方式补齐：
1. 在参数中设置 `params.per_curves_dir`
2. 设置环境变量 `STEP9_PER_CURVES_DIR`
3. 将 `PERcurves` 放入：
   - `external_data/WiLabV2Xsim/PERcurves`
   - `external_data/WiLabV2Xsim-main/PERcurves`
   - `external_data/CV2X-LOCA/PERcurves`

## 退回抽象投递模型的方法
如果暂时没有 PER 曲线文件，可先在：
- `get_default_step9_mainline_params.m`
中把：
```matlab
params.use_physical_delivery = true;
```
改为：
```matlab
params.use_physical_delivery = false;
```
这样可以得到与旧版近似一致的抽象调度实验结果。
