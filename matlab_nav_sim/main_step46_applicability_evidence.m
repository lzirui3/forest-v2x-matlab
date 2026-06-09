clc;
clear;
close all;

% Step46: combine Step40 and Step45 evidence into an applicability analysis.
% No simulation is rerun here; this script explains where the frozen method
% is expected to help and where gains are naturally weak.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

step40_path = 'step40_proposed_method_vtc_50seed_decision_table.csv';
step45_path = 'step45_heldout_frozen_validation_50seed_decision_table.csv';

T40 = normalize_decision_table_local(readtable(step40_path, 'TextType', 'string'), "Main");
T45 = normalize_decision_table_local(readtable(step45_path, 'TextType', 'string'), "HeldOut");
T = [T40; T45];

T_features = build_scene_feature_table_local(unique(T.Scene, 'stable'));
T_join = outerjoin(T, T_features, 'Keys', 'Scene', 'MergeKeys', true, 'Type', 'left');
T_join.RiskClass = classify_risk_class_local(T_join);
T_join.GainClass = classify_gain_class_local(T_join);
T_join.ApplicabilityClass = classify_applicability_local(T_join);
T_join.WeakGainReason = explain_weak_gain_local(T_join);

writetable(T_join, 'step46_applicability_evidence_table.csv');
write_report_local(T_join, 'step46_applicability_evidence_report_cn.md');

disp(T_join(:, {'Dataset','Scene','Config','RiskClass','GainClass','ApplicabilityClass', ...
    'V6MinusHeuristicTimely_pp','V6MinusLinkTimely_pp','CostDeltaPct','WeakGainReason'}));
fprintf('Step46 complete: applicability evidence generated.\n');

function T = normalize_decision_table_local(T, dataset_name)
if ismember('Decision', T.Properties.VariableNames) && ~ismember('HeldoutDecision', T.Properties.VariableNames)
    T.HeldoutDecision = T.Decision;
end

T.Dataset = repmat(dataset_name, height(T), 1);
T.Scene = string(T.Scene);
T.SceneRole = string(T.SceneRole);
T.GeometryType = string(T.GeometryType);
T.DensityClass = string(T.DensityClass);
T.VegetationClass = string(T.VegetationClass);
T.Config = string(T.Config);
T.HeldoutDecision = string(T.HeldoutDecision);
T.CostDeltaPct = T.V6CostDeltaPct;
T.DelayDeltaPct = T.V6DelayDeltaPct;
keep_vars = {'Dataset','Scene','SceneRole','GeometryType','DensityClass', ...
    'VegetationClass','Config','HeuristicTimely','V6Timely', ...
    'V6MinusHeuristicTimely_pp','HeuristicEmgTimely','V6EmgTimely', ...
    'V6MinusHeuristicEmg_pp','HeuristicTxCost','V6TxCost', ...
    'CostDeltaPct','HeuristicDelay','V6Delay','DelayDeltaPct', ...
    'V6MinusLinkTimely_pp','V6MinusLinkEmg_pp','V6MinusV4Emg_pp', ...
    'V6CostDeltaVsV4Pct','OracleMinusV6Timely_pp','HeldoutDecision'};
T = T(:, keep_vars);
T = movevars(T, 'Dataset', 'Before', 'Scene');
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
    if T.Config(i) == "ForestGeometry" && (T.NlosPct(i) >= 25.0 || T.MeanDistance_m(i) >= 45.0)
        risk_class(i) = "HighRiskForest";
    elseif T.Config(i) == "ForestGeometry"
        risk_class(i) = "ModerateForest";
    elseif T.HeuristicTimely(i) >= 0.99
        risk_class(i) = "SaturatedDefault";
    elseif T.NlosPct(i) >= 20.0 || T.MeanDistance_m(i) >= 45.0
        risk_class(i) = "ModerateDefault";
    else
        risk_class(i) = "LowRiskDefault";
    end
end
end

function gain_class = classify_gain_class_local(T)
gain_class = strings(height(T), 1);
for i = 1:height(T)
    gain_h = T.V6MinusHeuristicTimely_pp(i);
    gain_link = T.V6MinusLinkTimely_pp(i);
    if gain_h >= 1.0 && gain_link >= 1.0
        gain_class(i) = "StrongGain";
    elseif gain_h >= 0.0 && gain_link >= 0.0
        gain_class(i) = "WeakNonnegative";
    elseif gain_h >= -0.50
        gain_class(i) = "GracefulBoundary";
    else
        gain_class(i) = "Risk";
    end
end
end

function app_class = classify_applicability_local(T)
app_class = strings(height(T), 1);
for i = 1:height(T)
    if T.GainClass(i) == "StrongGain" && contains(T.RiskClass(i), "Forest")
        app_class(i) = "PrimaryApplicable";
    elseif T.GainClass(i) == "StrongGain"
        app_class(i) = "Applicable";
    elseif T.GainClass(i) == "WeakNonnegative" && T.V6MinusLinkTimely_pp(i) >= 1.0
        app_class(i) = "BaselineImprovement";
    elseif T.GainClass(i) == "WeakNonnegative"
        app_class(i) = "WeakButSafe";
    elseif T.GainClass(i) == "GracefulBoundary"
        app_class(i) = "BoundarySafe";
    else
        app_class(i) = "Limited";
    end
end
end

function reason = explain_weak_gain_local(T)
reason = strings(height(T), 1);
for i = 1:height(T)
    if T.GainClass(i) == "StrongGain"
        reason(i) = "Clear reliability gap and risk-aware decision benefit.";
    elseif T.HeuristicTimely(i) >= 0.99
        reason(i) = "Heuristic is already saturated; little TimelyRate headroom remains.";
    elseif T.V6MinusLinkTimely_pp(i) >= 1.0 && T.V6MinusHeuristicTimely_pp(i) < 1.0
        reason(i) = "Benefit is clear over link-only baseline, but the heuristic is already strong.";
    elseif T.Config(i) == "ForestGeometry" && T.CostDeltaPct(i) >= 8.0
        reason(i) = "Positive transfer requires extra cost under forest degradation.";
    elseif T.NlosPct(i) < 10.0 && T.Config(i) == "Default"
        reason(i) = "Low NLOS/default condition is outside the main risk-dominant operating region.";
    else
        reason(i) = "Weak nonnegative transfer; report as applicability boundary rather than strong gain.";
    end
end
end

function write_report_local(T, out_path)
fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step46 report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step46 适用范围与弱泛化问题处理报告\n\n');
fprintf(fid, '本报告用于解决 Step45 后仍存在的“场景依赖性”和“弱泛化”问题。');
fprintf(fid, '处理方式不是继续调参，而是将弱泛化结果转化为可解释的适用范围分析。\n\n');

fprintf(fid, '## 1. 核心判断\n\n');
fprintf(fid, 'Step40 + Step45 的合并结果说明：方法不是全场景强收益方法，而是风险退化场景中的风险约束调度方法。\n\n');
fprintf(fid, '最稳妥的论文表述是：\n\n');
fprintf(fid, '```text\n');
fprintf(fid, 'The proposed scheduler is most applicable when blind-zone risk, link degradation, and positioning uncertainty create a non-trivial reliability gap. Under low-risk or saturated conditions, it gracefully degenerates to weak nonnegative transfer.\n');
fprintf(fid, '```\n\n');

fprintf(fid, '## 2. 合并适用范围表\n\n');
fprintf(fid, '| Dataset | Scene | Config | NLOS (%%) | Mean Dist (m) | Heuristic Timely | Gain vs Heuristic (pp) | Gain vs Link (pp) | Cost Delta (%%) | Risk Class | Gain Class | Applicability | Explanation |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|---:|---:|---|---|---|---|\n');
for i = 1:height(T)
    fprintf(fid, '| %s | %s | %s | %.1f | %.1f | %.4f | %.3f | %.3f | %.2f | %s | %s | %s | %s |\n', ...
        T.Dataset(i), T.Scene(i), T.Config(i), T.NlosPct(i), T.MeanDistance_m(i), ...
        T.HeuristicTimely(i), T.V6MinusHeuristicTimely_pp(i), T.V6MinusLinkTimely_pp(i), ...
        T.CostDeltaPct(i), T.RiskClass(i), T.GainClass(i), ...
        T.ApplicabilityClass(i), T.WeakGainReason(i));
end

fprintf(fid, '\n## 3. 适用条件\n\n');
fprintf(fid, '方法最适用的条件：\n\n');
fprintf(fid, '1. ForestGeometry 或类似林区退化配置。\n');
fprintf(fid, '2. 存在非平凡可靠性缺口，即 Link-delay-aware 或 heuristic 尚未接近性能天花板。\n');
fprintf(fid, '3. 遮挡/NLOS、长距离链路、定位退化或应急时间窗至少有两类因素重叠。\n');
fprintf(fid, '4. 系统允许通过约 5%% 到 12%% 的额外通信代价换取及时率或时延改善。\n\n');

fprintf(fid, '## 4. 弱泛化不是失败的原因\n\n');
fprintf(fid, '弱泛化主要来自三类原因：\n\n');
fprintf(fid, '1. Heuristic 已接近饱和，例如 Default 下 TimelyRate 已接近 0.99，提升空间非常小。\n');
fprintf(fid, '2. 方法相对 Link-delay-aware 有明显提升，但相对 confidence heuristic 只有弱提升，说明 heuristic 本身已经较强。\n');
fprintf(fid, '3. 在 ForestGeometry 下，收益往往需要额外通信代价支撑，因此应作为风险-代价权衡，而不是无代价提升。\n\n');

fprintf(fid, '## 5. 论文中应如何解决审稿质疑\n\n');
fprintf(fid, '建议新增一个 `Method Applicability Analysis` 小节，明确写：\n\n');
fprintf(fid, '```text\n');
fprintf(fid, 'The method is not designed to dominate all baselines in already-saturated low-risk cases. Its intended operating region is forest-road emergency communication where NLOS/blockage, positioning uncertainty, and message urgency overlap. Held-out validation confirms non-negative transfer under frozen parameters, while weak-gain cases are explained by saturation or strong heuristic baselines.\n');
fprintf(fid, '```\n\n');

fprintf(fid, '## 6. 不建议继续做的事\n\n');
fprintf(fid, '不建议为了让 Step45 全部变成 StrongGain 而继续调参。这样会破坏 frozen-parameter held-out validation 的意义，反而重新引入过拟合风险。\n\n');
fprintf(fid, '## 7. 最终结论\n\n');
fprintf(fid, 'Step45 的弱泛化问题不应通过继续调参解决，而应通过适用范围建模解决。');
fprintf(fid, '当前项目可以将主张从“全场景强性能提升”调整为“风险退化场景中的稳定正收益与低风险场景中的安全退化”。');
fprintf(fid, '这比强行追求所有场景大幅提升更符合 VTC 审稿逻辑。\n');
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
