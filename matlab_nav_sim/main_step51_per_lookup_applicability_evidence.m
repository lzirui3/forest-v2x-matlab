clc;
clear;
close all;

% Step51: final applicability analysis under PER lookup.
% This replaces Step46 as the final applicability evidence because Step46
% used the earlier physical-layer setting.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

step49_prefix = get_env_string_local('STEP51_MAIN_PREFIX', ...
    "step49_per_lookup_final_validation_50seed");
step50_prefix = get_env_string_local('STEP51_HELDOUT_PREFIX', ...
    "step50_per_lookup_heldout_validation_50seed");
out_table = get_env_string_local('STEP51_OUT_TABLE', ...
    "step51_per_lookup_applicability_evidence_table.csv");
out_report = get_env_string_local('STEP51_OUT_REPORT', ...
    "step51_per_lookup_applicability_evidence_report_cn.md");

T_main = read_evidence_local(step49_prefix, "Main");
T_heldout = read_evidence_local(step50_prefix, "HeldOut");
T = append_table_local(T_main, T_heldout);

T_features = build_scene_feature_table_local(unique(T.Scene, 'stable'));
T_join = outerjoin(T, T_features, 'Keys', 'Scene', 'MergeKeys', true, 'Type', 'left');
T_join.RiskClass = classify_risk_class_local(T_join);
T_join.GainClass = classify_gain_class_local(T_join);
T_join.ApplicabilityClass = classify_applicability_local(T_join);
T_join.ApplicabilityNote = explain_applicability_local(T_join);

writetable(T_join, out_table);
write_report_local(T_join, out_report, ...
    step49_prefix, step50_prefix);

disp(T_join(:, {'Dataset','Scene','Config','RiskClass','GainClass','ApplicabilityClass', ...
    'TimelyGainVsHeuristic_pp','EmgGainVsHeuristic_pp','TimelyGainVsLink_pp', ...
    'CostDeltaVsHeuristic_pct','ApplicabilityNote'}));
fprintf('Step51 complete: PER-lookup applicability evidence generated.\n');

function T = read_evidence_local(prefix, dataset_name)
summary_path = prefix + "_summary.csv";
decision_path = prefix + "_decision_table.csv";

if ~isfile(summary_path)
    error('Missing Step51 summary input: %s. Run the corresponding validation first.', summary_path);
end
if ~isfile(decision_path)
    error('Missing Step51 decision input: %s. Run the corresponding validation first.', decision_path);
end

summary = normalize_table_local(readtable(summary_path, 'TextType', 'string'));
decision = normalize_table_local(readtable(decision_path, 'TextType', 'string'));
rows = [];

for i = 1:height(decision)
    subT = summary(summary.Scene == decision.Scene(i) & summary.Config == decision.Config(i), :);
    link = get_method_row_local(subT, "Link-delay-aware");
    heuristic = get_method_row_local(subT, "Confidence-heuristic");
    v6 = get_method_row_local(subT, "Risk-constrained-v6");
    oracle = get_method_row_local(subT, "Constrained Oracle");

    row = table( ...
        dataset_name, decision.Scene(i), decision.SceneRole(i), ...
        decision.GeometryType(i), decision.DensityClass(i), ...
        decision.VegetationClass(i), decision.Config(i), decision.Decision(i), ...
        link.TimelyRateMean, heuristic.TimelyRateMean, v6.TimelyRateMean, oracle.TimelyRateMean, ...
        link.EmergencyTimelyRateMean, heuristic.EmergencyTimelyRateMean, v6.EmergencyTimelyRateMean, oracle.EmergencyTimelyRateMean, ...
        link.AvgDelayMean, heuristic.AvgDelayMean, v6.AvgDelayMean, oracle.AvgDelayMean, ...
        link.AvgTxCostMean, heuristic.AvgTxCostMean, v6.AvgTxCostMean, oracle.AvgTxCostMean, ...
        decision.TimelyGainVsHeuristic_pp(i), decision.EmgGainVsHeuristic_pp(i), ...
        decision.TimelyGainVsLink_pp(i), decision.CostDeltaVsHeuristic_pct(i), ...
        decision.DelayDeltaVsHeuristic_pct(i), decision.OracleMinusV6Timely_pp(i), ...
        'VariableNames', {'Dataset','Scene','SceneRole','GeometryType','DensityClass', ...
        'VegetationClass','Config','Decision', ...
        'LinkTimely','HeuristicTimely','V6Timely','OracleTimely', ...
        'LinkEmgTimely','HeuristicEmgTimely','V6EmgTimely','OracleEmgTimely', ...
        'LinkDelay','HeuristicDelay','V6Delay','OracleDelay', ...
        'LinkCost','HeuristicCost','V6Cost','OracleCost', ...
        'TimelyGainVsHeuristic_pp','EmgGainVsHeuristic_pp', ...
        'TimelyGainVsLink_pp','CostDeltaVsHeuristic_pct', ...
        'DelayDeltaVsHeuristic_pct','OracleMinusV6Timely_pp'});
    rows = append_table_local(rows, row);
end

T = rows;
end

function row = get_method_row_local(T, method_name)
row = T(T.Method == method_name, :);
if isempty(row)
    row = table("", "", "", "", "", "", method_name, ...
        NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, ...
        'VariableNames', T.Properties.VariableNames);
else
    row = row(1, :);
end
end

function T = build_scene_feature_table_local(scene_ids)
data_dir = fullfile(fileparts(mfilename('fullpath')), 'step9_data_templates');
rows = [];

for i = 1:numel(scene_ids)
    scene = string(scene_ids(i));
    traj_path = fullfile(data_dir, sprintf('v2xseq_scene%s_trajectory.csv', scene));
    msg_path = fullfile(data_dir, sprintf('v2xseq_scene%s_message_profile.csv', scene));
    blk_path = fullfile(data_dir, sprintf('v2xseq_scene%s_blockage_profile.csv', scene));

    if ~isfile(traj_path) || ~isfile(msg_path) || ~isfile(blk_path)
        row = table(scene, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, ...
            'VariableNames', {'Scene','Samples','MinDistance_m','MeanDistance_m','MaxDistance_m', ...
            'NlosPct','EmergencyPct','CoopPct','RelayPct'});
        rows = append_table_local(rows, row);
        continue;
    end

    traj = readtable(traj_path, 'TextType', 'string');
    msg = readtable(msg_path, 'TextType', 'string');
    blk = readtable(blk_path, 'TextType', 'string');

    dist = hypot(traj.tx_x - traj.rx_x, traj.tx_y - traj.rx_y);
    row = table(scene, height(traj), min(dist), mean(dist), max(dist), ...
        100.0 * mean(double(blk.is_nlos) > 0), ...
        100.0 * mean(msg.msg_type == "emergency"), ...
        100.0 * mean(msg.msg_type == "coop"), ...
        100.0 * mean(double(traj.relay_available) > 0), ...
        'VariableNames', {'Scene','Samples','MinDistance_m','MeanDistance_m','MaxDistance_m', ...
        'NlosPct','EmergencyPct','CoopPct','RelayPct'});
    rows = append_table_local(rows, row);
end

T = rows;
end

function risk_class = classify_risk_class_local(T)
risk_class = strings(height(T), 1);
for i = 1:height(T)
    high_geometry = T.Config(i) == "ForestGeometry" && ...
        (T.NlosPct(i) >= 25.0 || T.MeanDistance_m(i) >= 45.0 || T.VegetationClass(i) == "Dense");
    moderate_geometry = T.Config(i) == "ForestGeometry" || T.NlosPct(i) >= 15.0 || T.MeanDistance_m(i) >= 40.0;

    if high_geometry
        risk_class(i) = "HighRiskForest";
    elseif moderate_geometry
        risk_class(i) = "ModerateRisk";
    elseif T.HeuristicTimely(i) >= 0.99
        risk_class(i) = "SaturatedLowRisk";
    else
        risk_class(i) = "LowRisk";
    end
end
end

function gain_class = classify_gain_class_local(T)
gain_class = strings(height(T), 1);
for i = 1:height(T)
    timely_h = T.TimelyGainVsHeuristic_pp(i);
    emg_h = T.EmgGainVsHeuristic_pp(i);
    timely_link = T.TimelyGainVsLink_pp(i);

    if timely_h >= 1.0 || emg_h >= 1.0
        gain_class(i) = "StrongGain";
    elseif timely_link >= 1.0 && timely_h >= -0.25 && emg_h >= -0.25
        gain_class(i) = "BaselineGain";
    elseif timely_h >= -0.10 && emg_h >= -0.25 && timely_link >= -0.10
        gain_class(i) = "WeakNonnegative";
    elseif timely_h >= -0.75 && emg_h >= -0.75
        gain_class(i) = "GracefulBoundary";
    else
        gain_class(i) = "RiskCase";
    end
end
end

function app_class = classify_applicability_local(T)
app_class = strings(height(T), 1);
for i = 1:height(T)
    if T.GainClass(i) == "StrongGain" && T.RiskClass(i) == "HighRiskForest"
        app_class(i) = "PrimaryApplicable";
    elseif T.GainClass(i) == "StrongGain"
        app_class(i) = "Applicable";
    elseif T.GainClass(i) == "BaselineGain"
        app_class(i) = "BaselineImprovement";
    elseif T.GainClass(i) == "WeakNonnegative"
        app_class(i) = "WeakButSafe";
    elseif T.GainClass(i) == "GracefulBoundary"
        app_class(i) = "BoundaryLimited";
    else
        app_class(i) = "LimitedRisk";
    end
end
end

function note = explain_applicability_local(T)
note = strings(height(T), 1);
for i = 1:height(T)
    if T.ApplicabilityClass(i) == "PrimaryApplicable"
        note(i) = "PER lookup confirms clear benefit in forest/risk-degraded operating region.";
    elseif T.ApplicabilityClass(i) == "Applicable"
        note(i) = "Clear gain exists, but the scene is not the primary dense-forest risk case.";
    elseif T.ApplicabilityClass(i) == "BaselineImprovement"
        note(i) = "Gain is stronger versus link-only scheduling than versus the confidence heuristic.";
    elseif T.ApplicabilityClass(i) == "WeakButSafe"
        note(i) = "Transfer is weak but nonnegative or near-nonnegative; report as safe boundary.";
    elseif T.ApplicabilityClass(i) == "BoundaryLimited"
        note(i) = "Small negative or boundary result; avoid all-scenario dominance claims.";
    else
        note(i) = "Negative PER-lookup case; treat as applicability limit and diagnose separately.";
    end
end
end

function write_report_local(T, out_path, step49_prefix, step50_prefix)
fid = fopen(out_path, 'w', 'n', 'UTF-8');
if fid == -1
    error('Could not open Step51 report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step51 PER Lookup 适用范围分析报告\n\n');
fprintf(fid, '本报告使用最终物理层口径 `per_lookup`，合并主场景 `%s` 与 held-out 场景 `%s`。\n\n', ...
    step49_prefix, step50_prefix);
fprintf(fid, '该报告替代早期 Step46，作为 VTC 投稿前的最终适用范围证据。\n\n');

fprintf(fid, '## 1. 总体分类统计\n\n');
classes = unique(T.ApplicabilityClass, 'stable');
fprintf(fid, '| Applicability class | Count |\n');
fprintf(fid, '|---|---:|\n');
for i = 1:numel(classes)
    fprintf(fid, '| %s | %d |\n', classes(i), sum(T.ApplicabilityClass == classes(i)));
end

fprintf(fid, '\n## 2. 逐场景适用范围表\n\n');
fprintf(fid, '| Dataset | Scene | Config | NLOS (%%) | Mean distance (m) | Timely gain vs heuristic (pp) | Emergency gain (pp) | Timely gain vs link (pp) | Cost delta (%%) | Risk class | Gain class | Applicability |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|---:|---:|---|---|---|\n');
for i = 1:height(T)
    fprintf(fid, '| %s | %s | %s | %.1f | %.1f | %.3f | %.3f | %.3f | %.2f | %s | %s | %s |\n', ...
        T.Dataset(i), T.Scene(i), T.Config(i), T.NlosPct(i), T.MeanDistance_m(i), ...
        T.TimelyGainVsHeuristic_pp(i), T.EmgGainVsHeuristic_pp(i), ...
        T.TimelyGainVsLink_pp(i), T.CostDeltaVsHeuristic_pct(i), ...
        T.RiskClass(i), T.GainClass(i), T.ApplicabilityClass(i));
end

fprintf(fid, '\n## 3. 审稿级结论口径\n\n');
fprintf(fid, '最终应表述为：本文方法不是全场景支配型调度器，而是面向林区遮挡、链路退化与定位风险叠加条件的风险约束在线调度方法。\n');
fprintf(fid, '在低风险或已接近饱和的场景中，收益可能表现为弱正收益、近似持平或边界退化；这些结果应作为适用范围边界，而不是继续调参掩盖。\n\n');

fprintf(fid, '## 4. 需要在论文中明确的限制\n\n');
fprintf(fid, '1. `LimitedRisk` 场景必须单独解释，不能并入平均值后宣称全局优势。\n');
fprintf(fid, '2. `WeakButSafe` 和 `BoundaryLimited` 场景适合支撑 graceful degradation，不适合支撑强性能提升。\n');
fprintf(fid, '3. 最终性能表应同时报告主场景与 held-out 场景，防止被质疑只在调参场景有效。\n');
end

function T = normalize_table_local(T)
names = {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','PdrMode','Method','Stage','Decision'};
for i = 1:numel(names)
    if ismember(names{i}, T.Properties.VariableNames)
        T.(names{i}) = string(T.(names{i}));
    end
end
end

function value = get_env_string_local(name, default_value)
raw = getenv(name);
if isempty(raw)
    value = default_value;
else
    value = string(raw);
end
end

function T = append_table_local(T, rows)
if isempty(rows)
    return;
end

if isempty(T)
    T = rows;
else
    T = [T; rows]; %#ok<AGROW>
end
end
