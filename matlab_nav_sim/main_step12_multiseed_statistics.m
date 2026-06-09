clc;
clear;
close all;

% Step 12:
% 多种子统计验证——100 次独立重复实验，Wilcoxon 符号秩检验 + 95% CI。
% 包含公平效用优化基线（Link-aware-Opt、Position-aware-Opt）和全部消融。

set(groot, 'defaultFigureWindowStyle', 'normal');
opengl software;
set(groot, 'defaultFigureColor', 'w');
set(groot, 'defaultAxesColor', 'w');
set(groot, 'defaultAxesXColor', 'k');
set(groot, 'defaultAxesYColor', 'k');
set(groot, 'defaultAxesZColor', 'k');
set(groot, 'defaultAxesFontName', 'Times New Roman');
set(groot, 'defaultTextFontName', 'Times New Roman');
set(groot, 'defaultAxesFontSize', 11);
set(groot, 'defaultTextFontSize', 11);
set(groot, 'defaultAxesLineWidth', 1.0);
set(groot, 'defaultLineLineWidth', 1.6);
set(groot, 'defaultTextColor', 'k');
set(groot, 'defaultLegendTextColor', 'k');
set(groot, 'defaultColorBarColor', 'k');

%% ===== 参数配置 =====
num_seeds = 100;          % 从 20 提升至 100，满足统计显著性要求
seed_list = 1:num_seeds;
cases = get_default_step10_ablation_cases();

% 方法数量：4 基线 + 5 消融变体 = 9
num_methods = 9;
method_names = { ...
    "Link-aware", ...          % 1: 启发式链路基线
    "Position-only", ...       % 2: 启发式定位基线
    "Link-aware-Opt", ...      % 3: 公平效用优化链路基线（q_pos=0.5）
    "Position-aware-Opt", ...  % 4: 公平效用优化定位基线（q_link=0.5）
    "Full", ...                % 5: 置信度驱动完整方法（提议方法）
    "No-GNSS", ...             % 6: 消融 - 无 GNSS
    "No-RSU", ...              % 7: 消融 - 无 RSU
    "No-Env", ...              % 8: 消融 - 无环境感知
    "No-Traj" ...              % 9: 消融 - 无轨迹预测
};

%% ===== 多种子循环 =====
T_raw = [];
T_stage_raw = [];
T_effective_raw = [];

fprintf('开始 %d 种子统计验证...\n', num_seeds);
t_start = tic;

for seed_idx = 1:num_seeds
    seed = seed_list(seed_idx);
    params = get_default_step9_mainline_params();
    params.random_seed = seed;

    % 使用 Full 模块生成基准场景
    base_modules = cases(1).modules;
    base_scenario = generate_step9_scenario(params, base_modules);

    results = cell(num_methods, 1);

    % --- 基线方法（均使用 base_scenario）---
    % 1: 启发式链路基线
    results{1} = run_step9_baseline_link_only(base_scenario, params);
    results{1}.name = "Link-aware";

    % 2: 启发式定位基线
    results{2} = run_step9_baseline_position_only(base_scenario, params);
    results{2}.name = "Position-only";

    % 3: 公平效用优化链路基线（q_pos 固定 0.5）
    results{3} = run_step9_baseline_link_only_opt(base_scenario, params);
    results{3}.name = "Link-aware-Opt";

    % 4: 公平效用优化定位基线（q_link 固定 0.5）
    results{4} = run_step9_baseline_position_only_opt(base_scenario, params);
    results{4}.name = "Position-aware-Opt";

    % --- 提议方法及消融变体 ---
    % 5: Full（所有模块启用）— 复用 base_scenario 确保配对一致性
    results{5} = run_step9_confidence_driven(base_scenario, params);
    results{5}.name = "Full";

    % 6-9: 消融变体（需要不同模块配置，重新设置 RNG 确保场景基础一致）
    for i = 2:5
        rng(seed * 1000 + i, 'twister');  % 独立种子避免 RNG 漂移
        scenario_case = generate_step9_scenario(params, cases(i).modules);
        result_case = run_step9_confidence_driven(scenario_case, params);
        result_case.name = cases(i).name;
        results{i + 4} = result_case;
    end

    % --- 指标评估 ---
    T_seed = evaluate_step9_metrics(base_scenario, results);
    T_seed.Seed = repmat(seed, height(T_seed), 1);
    T_seed = movevars(T_seed, 'Seed', 'Before', 'Method');

    if isempty(T_raw)
        T_raw = T_seed;
    else
        T_raw = [T_raw; T_seed]; %#ok<AGROW>
    end

    % --- 阶段指标 ---
    stages = define_step9_stage_masks(base_scenario.t);
    metrics_list = cell(num_methods, 1);
    for i = 1:num_methods
        metrics_list{i} = compute_step9_stage_metrics(base_scenario, results{i}, stages);
    end

    T_stage_seed = build_step9_stage_metrics_table(method_names, metrics_list);
    T_stage_seed.Seed = repmat(seed, height(T_stage_seed), 1);
    T_stage_seed = movevars(T_stage_seed, 'Seed', 'Before', 'Method');

    if isempty(T_stage_raw)
        T_stage_raw = T_stage_seed;
    else
        T_stage_raw = [T_stage_raw; T_stage_seed]; %#ok<AGROW>
    end

    % --- 有效预警分析 ---
    effective_cases = cell(1, num_methods);
    effective_cases{1} = base_scenario;  % Link-aware
    effective_cases{2} = base_scenario;  % Position-only
    effective_cases{3} = base_scenario;  % Link-aware-Opt
    effective_cases{4} = base_scenario;  % Position-aware-Opt
    effective_cases{5} = base_scenario;  % Full（复用 base_scenario）
    for i = 2:5
        rng(seed * 1000 + i, 'twister');  % 与消融变体使用相同独立种子
        effective_cases{i + 4} = generate_step9_scenario(params, cases(i).modules);
    end
    T_effective_seed = build_step10_effective_warning_table(method_names, effective_cases, results, 0.50);
    T_effective_seed.Seed = repmat(seed, height(T_effective_seed), 1);
    T_effective_seed = movevars(T_effective_seed, 'Seed', 'Before', 'Method');

    if isempty(T_effective_raw)
        T_effective_raw = T_effective_seed;
    else
        T_effective_raw = [T_effective_raw; T_effective_seed]; %#ok<AGROW>
    end

    % 进度显示
    if mod(seed_idx, 10) == 0
        elapsed = toc(t_start);
        eta = elapsed / seed_idx * (num_seeds - seed_idx);
        fprintf('  种子 %d/%d 完成 (%.1fs 已用, 预计剩余 %.1fs)\n', ...
            seed_idx, num_seeds, elapsed, eta);
    end
end

elapsed_total = toc(t_start);
fprintf('全部 %d 种子完成，耗时 %.1f 秒。\n', num_seeds, elapsed_total);

%% ===== 汇总统计 =====
T_summary = build_step12_summary_table(T_raw);
T_stage_summary = build_step12_stage_summary_table(T_stage_raw);
T_effective_summary = build_step12_effective_warning_summary_table(T_effective_raw);

%% ===== 统计显著性检验 =====
% 提议方法（Full）对比所有基线的 Wilcoxon 符号秩检验 + 95% CI
proposed_name = "Full";
baseline_names = ["Link-aware", "Position-only", "Link-aware-Opt", "Position-aware-Opt"];

fprintf('\n===== 统计显著性检验 (Wilcoxon signed-rank, n=%d) =====\n', num_seeds);
T_stat_all = [];
for b = 1:numel(baseline_names)
    fprintf('\n--- %s vs %s ---\n', proposed_name, baseline_names(b));
    T_stat = compute_step12_statistical_tests(T_raw, baseline_names(b), proposed_name);
    T_stat.Comparison = repmat(sprintf("%s vs %s", proposed_name, baseline_names(b)), height(T_stat), 1);
    T_stat = movevars(T_stat, 'Comparison', 'Before', 'Metric');
    disp(T_stat);

    if isempty(T_stat_all)
        T_stat_all = T_stat;
    else
        T_stat_all = [T_stat_all; T_stat]; %#ok<AGROW>
    end
end

% 消融对比：Full vs 各消融变体
ablation_names = ["No-GNSS", "No-RSU", "No-Env", "No-Traj"];
fprintf('\n===== 消融显著性检验 =====\n');
T_ablation_stat = [];
for a = 1:numel(ablation_names)
    fprintf('\n--- %s vs %s ---\n', proposed_name, ablation_names(a));
    T_stat = compute_step12_statistical_tests(T_raw, ablation_names(a), proposed_name);
    T_stat.Comparison = repmat(sprintf("%s vs %s", proposed_name, ablation_names(a)), height(T_stat), 1);
    T_stat = movevars(T_stat, 'Comparison', 'Before', 'Metric');
    disp(T_stat);

    if isempty(T_ablation_stat)
        T_ablation_stat = T_stat;
    else
        T_ablation_stat = [T_ablation_stat; T_stat]; %#ok<AGROW>
    end
end

%% ===== 输出结果 =====
disp('===== 汇总统计表 =====');
disp(T_summary);
disp(T_stage_summary(T_stage_summary.Stage == "PosDeg_Emerg", :));

% 保存 CSV
writetable(T_raw, 'step12_multiseed_metrics_raw.csv');
writetable(T_stage_raw, 'step12_multiseed_stage_metrics_raw.csv');
writetable(T_effective_raw, 'step12_multiseed_effective_warning_raw.csv');
writetable(T_summary, 'step12_multiseed_metrics.csv');
writetable(T_stage_summary, 'step12_multiseed_stage_metrics.csv');
writetable(T_effective_summary, 'step12_multiseed_effective_warning.csv');
writetable(T_stat_all, 'step12_statistical_tests_vs_baselines.csv');
writetable(T_ablation_stat, 'step12_statistical_tests_ablation.csv');

% 生成报告
write_step12_multiseed_report(T_summary, T_stage_summary, T_effective_summary, ...
    'step12_multiseed_report.md', num_seeds);

% 绘图
plot_step12_multiseed_results(T_raw, T_stage_raw, T_summary, T_stage_summary);

fprintf('\nStep 12 完成: %d 种子统计验证 + 显著性检验已生成。\n', num_seeds);
fprintf('统计检验结果已保存至:\n');
fprintf('  - step12_statistical_tests_vs_baselines.csv\n');
fprintf('  - step12_statistical_tests_ablation.csv\n');