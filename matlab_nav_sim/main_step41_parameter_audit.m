clc;
clear;

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

params_default = get_default_step9_mainline_params();
params_forest = get_forest_geometry_mainline_params();

T = build_parameter_audit_table(params_default, params_forest);
writetable(T, 'step41_parameter_audit_table.csv');
write_parameter_audit_report(T, 'step41_parameter_audit_report_cn.md');

disp(groupcounts(T, {'Layer','CredibilityAction'}));
fprintf('Step 41 complete: parameter audit generated (%d parameters).\n', height(T));

function T = build_parameter_audit_table(params_default, params_forest)
flat_default = flatten_struct(params_default, "");
flat_forest = flatten_struct(params_forest, "");
names = union(flat_default.Parameter, flat_forest.Parameter, 'stable');

Parameter = strings(numel(names), 1);
Layer = strings(numel(names), 1);
Role = strings(numel(names), 1);
DefaultValue = strings(numel(names), 1);
ForestValue = strings(numel(names), 1);
ChangedInForest = false(numel(names), 1);
CredibilityAction = strings(numel(names), 1);
Priority = strings(numel(names), 1);
EvidenceStatus = strings(numel(names), 1);

for i = 1:numel(names)
    name = names(i);
    Parameter(i) = name;

    default_idx = find(flat_default.Parameter == name, 1);
    forest_idx = find(flat_forest.Parameter == name, 1);
    has_default = ~isempty(default_idx);
    has_forest = ~isempty(forest_idx);
    if has_default
        default_value = flat_default.Value{default_idx};
    else
        default_value = [];
    end
    if has_forest
        forest_value = flat_forest.Value{forest_idx};
    else
        forest_value = [];
    end

    DefaultValue(i) = value_to_string(default_value);
    ForestValue(i) = value_to_string(forest_value);
    ChangedInForest(i) = ~strcmp(DefaultValue(i), ForestValue(i));

    [Layer(i), Role(i), CredibilityAction(i), Priority(i), EvidenceStatus(i)] = classify_parameter(name, ChangedInForest(i));
end

T = table(Parameter, Layer, Role, DefaultValue, ForestValue, ChangedInForest, ...
    CredibilityAction, Priority, EvidenceStatus);
T = sortrows(T, {'Priority','Layer','Parameter'});
end

function flat = flatten_struct(s, prefix)
Parameter = strings(0, 1);
Value = {};
fields = fieldnames(s);
for i = 1:numel(fields)
    field = fields{i};
    value = s.(field);
    if strlength(prefix) == 0
        name = string(field);
    else
        name = prefix + "." + string(field);
    end

    if isstruct(value) && isscalar(value)
        nested = flatten_struct(value, name);
        Parameter = [Parameter; nested.Parameter]; %#ok<AGROW>
        Value = [Value; nested.Value]; %#ok<AGROW>
    else
        Parameter(end + 1, 1) = name; %#ok<AGROW>
        Value{end + 1, 1} = value; %#ok<AGROW>
    end
end
flat = table(Parameter, Value);
end

function s = value_to_string(value)
if isempty(value)
    s = "";
elseif isstring(value)
    s = strjoin(value(:).', ",");
elseif ischar(value)
    s = string(value);
elseif islogical(value)
    s = string(mat2str(value));
elseif isnumeric(value)
    if isscalar(value)
        s = string(sprintf('%.6g', value));
    else
        flat = value(:).';
        max_items = min(numel(flat), 8);
        parts = strings(1, max_items);
        for i = 1:max_items
            parts(i) = string(sprintf('%.6g', flat(i)));
        end
        if numel(flat) > max_items
            s = "[" + strjoin(parts, ",") + ",...]";
        else
            s = "[" + strjoin(parts, ",") + "]";
        end
    end
else
    s = string(class(value));
end
end

function [layer, role, action, priority, status] = classify_parameter(name, changed_in_forest)
name = string(name);
layer = "Deprecated-or-legacy";
role = "Legacy or auxiliary parameter not used as the Step40 proposed-method claim.";
action = "KeepSeparate";
priority = "P4";
status = "NotClaimed";

if startsWith(name, "risk_constrained_") || startsWith(name, "risk_v4_") || startsWith(name, "risk_v6_")
    layer = "Core-method";
    role = "Risk-constrained objective, cost tradeoff, or emergency action floor.";
    action = "CalibrateAndSensitivity";
    priority = "P0";
    status = "Partial: Step36/Step38/Step39 evidence exists; needs Step40 50-seed closure.";
elseif startsWith(name, "utility_required_timely") || startsWith(name, "utility_required_protection") ...
        || name == "utility_emergency_urgency_threshold"
    layer = "Core-method";
    role = "Maps state risk to timely/protection requirements.";
    action = "SensitivityAndJustification";
    priority = "P0";
    status = "Partial: structure exists; thresholds still need bounded sensitivity evidence.";
elseif startsWith(name, "action_") || startsWith(name, "priority_rate_scale") ...
        || startsWith(name, "tx_cost_")
    layer = "Core-method";
    role = "Finite action space and communication-cost model.";
    action = "AblationOrRangeCheck";
    priority = "P1";
    status = "Partial: cost efficiency evidence exists; action-space robustness still useful.";
elseif startsWith(name, "deadline_")
    layer = "Scenario-definition";
    role = "Message latency requirement.";
    action = "ScenarioSensitivity";
    priority = "P1";
    status = "Partial: Step28 sensitivity exists; align future runs with proposed method.";
elseif startsWith(name, "pathloss_") || startsWith(name, "nlosv_") || startsWith(name, "blind_") ...
        || startsWith(name, "interference") || startsWith(name, "link_distance") ...
        || startsWith(name, "tx_power") || startsWith(name, "noise_floor") ...
        || startsWith(name, "veg_") || startsWith(name, "use_veg")
    layer = "Simulation-environment";
    role = "Forest/channel/occlusion physical environment parameter.";
    action = "SourceOrCalibration";
    priority = "P1";
    if changed_in_forest
        status = "Partial: forest calibration changes this parameter; verify source mapping.";
    else
        status = "Needs source or range citation if reported.";
    end
elseif startsWith(name, "relay_") || startsWith(name, "fast_fading") || startsWith(name, "pdr_") ...
        || startsWith(name, "per_curve") || startsWith(name, "mode_overhead") ...
        || startsWith(name, "base_access") || startsWith(name, "congestion") ...
        || startsWith(name, "attempt_gap") || startsWith(name, "priority_sinr") ...
        || startsWith(name, "emergency_sinr")
    layer = "Simulation-environment";
    role = "Physical delivery, PER, relay, and MAC-delay approximation.";
    action = "CrossValidateOrCite";
    priority = "P1";
    status = "Partial: PER lookup and relay random consistency evidence exists.";
elseif startsWith(name, "position_") || contains(name, "gnss") || startsWith(name, "rsu_") ...
        || startsWith(name, "env_event") || startsWith(name, "event_") ...
        || startsWith(name, "confidence_regime")
    layer = "State-estimation-input";
    role = "Positioning confidence, sparse support, or risk-state construction.";
    action = "AblationAndMapping";
    priority = "P2";
    status = "Partial: module ablation exists; mapping still should be documented.";
elseif startsWith(name, "dcc_") || startsWith(name, "aoi_")
    layer = "Baseline-only";
    role = "Literature-inspired baseline setting.";
    action = "KeepAsBaselineSetting";
    priority = "P3";
    status = "Not part of proposed method; report as baseline configuration.";
elseif startsWith(name, "lyapunov_") || startsWith(name, "abstract_") ...
        || startsWith(name, "base_success") || startsWith(name, "critical_") ...
        || startsWith(name, "redundant_success") || startsWith(name, "relay_success") ...
        || startsWith(name, "link_gate") || startsWith(name, "pos_gate") ...
        || startsWith(name, "urgency_gate") || startsWith(name, "mode_gate") ...
        || startsWith(name, "priority_gate") || startsWith(name, "fading_") ...
        || startsWith(name, "enable_stochastic")
    layer = "Deprecated-or-legacy";
    role = "Old abstract model, Lyapunov attempt, or legacy heuristic setting.";
    action = "DoNotClaim";
    priority = "P4";
    status = "Keep for reproducibility, but do not present as main-method parameter.";
elseif startsWith(name, "scenario_input") || name == "dt" || name == "T_total" ...
        || startsWith(name, "base_rate_") || startsWith(name, "urgency_")
    layer = "Scenario-definition";
    role = "Scenario timing, message generation, and external input configuration.";
    action = "ReportSetting";
    priority = "P3";
    status = "Scenario setup parameter.";
end
end

function write_parameter_audit_report(T, out_path)
fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step41 参数可信度审计报告\n\n');
fprintf(fid, '本报告用于项目内部控制经验参数风险，不是论文正文草稿。\n\n');
fprintf(fid, '总参数数：%d。\n\n', height(T));

layers = unique(T.Layer, 'stable');
fprintf(fid, '## 1. 参数分层统计\n\n');
fprintf(fid, '| Layer | Count |\n');
fprintf(fid, '|---|---:|\n');
for i = 1:numel(layers)
    fprintf(fid, '| %s | %d |\n', layers(i), sum(T.Layer == layers(i)));
end

fprintf(fid, '\n## 2. 需要优先处理的参数\n\n');
priority_rows = T(T.Priority == "P0" | T.Priority == "P1", :);
fprintf(fid, '| Priority | Parameter | Layer | Action | EvidenceStatus |\n');
fprintf(fid, '|---|---|---|---|---|\n');
for i = 1:height(priority_rows)
    fprintf(fid, '| %s | `%s` | %s | %s | %s |\n', ...
        priority_rows.Priority(i), priority_rows.Parameter(i), priority_rows.Layer(i), ...
        priority_rows.CredibilityAction(i), priority_rows.EvidenceStatus(i));
end

fprintf(fid, '\n## 3. 项目内部处理原则\n\n');
fprintf(fid, '- P0 参数必须有校准、消融或敏感性证据，不能只靠工程直觉。\n');
fprintf(fid, '- P1 参数必须有来源、范围依据或跨场景敏感性验证。\n');
fprintf(fid, '- P2 参数作为状态输入构造参数，需要用消融证明其贡献。\n');
fprintf(fid, '- P3 参数只作为 baseline 或 scenario setting 报告，不作为创新点。\n');
fprintf(fid, '- P4 参数保留用于复现旧实验，但不进入主方法叙事。\n\n');

fprintf(fid, '## 4. 下一步建议\n\n');
fprintf(fid, '1. 对 `risk_constrained_*` 与 `risk_v6_*` 做小范围敏感性/校准闭环。\n');
fprintf(fid, '2. 用 Step40 50-seed 验证固定后的 Proposed Method。\n');
fprintf(fid, '3. 对 `deadline_*`、`pathloss_*`、`relay_*`、`veg_*` 做来源或范围表。\n');
fprintf(fid, '4. 旧 `utility_*` 中未被 v6 主方法直接依赖的参数降级为 legacy，不进入主方法贡献。\n');
end
