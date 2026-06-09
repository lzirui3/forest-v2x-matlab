clc;
clear;
close all;

set(groot, 'defaultFigureWindowStyle', 'normal');
opengl software;
set(groot, 'defaultFigureColor', 'w');
set(groot, 'defaultAxesColor', 'w');
set(groot, 'defaultAxesXColor', 'k');
set(groot, 'defaultAxesYColor', 'k');
set(groot, 'defaultAxesFontName', 'Times New Roman');
set(groot, 'defaultTextFontName', 'Times New Roman');
set(groot, 'defaultAxesFontSize', 11);
set(groot, 'defaultTextFontSize', 11);
set(groot, 'defaultAxesLineWidth', 1.0);
set(groot, 'defaultLineLineWidth', 1.6);

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

num_seeds = get_num_seeds_from_env(3);
seed_list = 1:num_seeds;
scene_ids = get_env_string_list_local('STEP42_SCENES', ["10014", "10011", "10017"]);
config_names = get_env_string_list_local('STEP42_CONFIGS', ["Default", "ForestGeometry"]);
candidates = build_candidate_set();

rows = [];
scene_matrix = get_paper_scene_matrix();

for scene_id = scene_ids
    scene_meta = find_scene_meta(scene_matrix, scene_id);
    scene_cfg = get_step9_v2xseq_config_by_scene(scene_id);

    for cfg = config_names
        for seed = seed_list
            fprintf('Step42 sensitivity: scene=%s config=%s seed=%d/%d\n', ...
                scene_id, cfg, seed, num_seeds);
            T_seed = simulate_case(scene_meta, scene_cfg, cfg, seed, candidates);
            rows = append_table_local(rows, T_seed);
        end
    end
end

summary = build_step17_summary_table(rows);
decision = build_step42_decision_table(summary);

prefix = "step42_core_parameter_sensitivity_" + string(num_seeds) + "seed";
writetable(rows, prefix + "_raw.csv");
writetable(summary, prefix + "_summary.csv");
writetable(decision, prefix + "_decision_table.csv");
write_step42_report(decision, prefix + "_report.md");

disp(decision);
fprintf('Step 42 complete: core parameter sensitivity generated (%d seeds).\n', num_seeds);

function num_seeds = get_num_seeds_from_env(default_value)
env_value = str2double(getenv('STEP42_NUM_SEEDS'));
if isnan(env_value) || env_value < 1
    num_seeds = default_value;
else
    num_seeds = round(env_value);
end
end

function values = get_env_string_list_local(name, default_values)
raw = getenv(name);
if isempty(raw)
    values = default_values;
else
    parts = split(string(raw), ',');
    values = strtrim(parts(:)).';
    values = values(strlength(values) > 0);
end
end

function candidates = build_candidate_set()
candidates = repmat(struct('Name', "", 'TimelyScale', 1.0, ...
    'ProtectionScale', 1.0, 'EmergencyMinRate', 2.1), 7, 1);

candidates(1).Name = "Proposed";

candidates(2).Name = "TimelyLow";
candidates(2).TimelyScale = 0.90;

candidates(3).Name = "TimelyHigh";
candidates(3).TimelyScale = 1.10;

candidates(4).Name = "ProtectLow";
candidates(4).ProtectionScale = 0.90;

candidates(5).Name = "ProtectHigh";
candidates(5).ProtectionScale = 1.10;

candidates(6).Name = "EmergencyFloorLow";
candidates(6).EmergencyMinRate = 1.7;

candidates(7).Name = "EmergencyFloorHigh";
candidates(7).EmergencyMinRate = 2.5;
end

function T_seed = simulate_case(scene_meta, scene_cfg, cfg, seed, candidates)
if cfg == "Default"
    params = get_default_step9_mainline_params();
else
    params = get_forest_geometry_mainline_params();
end
params.scenario_input = scene_cfg;
params.random_seed = seed;
scenario = generate_step9_scenario(params);

results = cell(numel(candidates) + 2, 1);
results{1} = run_step9_baseline_link_delayaware(scenario, params);
results{2} = run_step9_confidence_driven_heuristic(scenario, params);

for i = 1:numel(candidates)
    params_i = apply_candidate(params, candidates(i));
    result = run_step9_proposed_method(scenario, params_i);
    result.name = candidates(i).Name;
    results{i + 2} = result;
end

T_seed = evaluate_step9_metrics(scenario, results);
T_seed.Scene = repmat(scene_meta.scene_id, height(T_seed), 1);
T_seed.SceneRole = repmat(scene_meta.scene_role, height(T_seed), 1);
T_seed.GeometryType = repmat(scene_meta.geometry_type, height(T_seed), 1);
T_seed.DensityClass = repmat(scene_meta.density_class, height(T_seed), 1);
T_seed.VegetationClass = repmat(scene_meta.vegetation_class, height(T_seed), 1);
T_seed.Config = repmat(cfg, height(T_seed), 1);
T_seed.Seed = repmat(seed, height(T_seed), 1);
T_seed = movevars(T_seed, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config','Seed'}, ...
    'Before', 'Method');
end

function params = apply_candidate(params, candidate)
params.risk_v4_actual_cost_weight = 0.060;
params.risk_v6_emergency_min_rate_multiplier = candidate.EmergencyMinRate;

timely_fields = {'utility_required_timely_bias', ...
    'utility_required_timely_urgency_scale', ...
    'utility_required_timely_link_risk_scale', ...
    'utility_required_timely_pos_risk_scale', ...
    'utility_required_timely_blind_scale'};
for i = 1:numel(timely_fields)
    field = timely_fields{i};
    params.(field) = params.(field) * candidate.TimelyScale;
end

protection_fields = {'utility_required_protection_pos_scale', ...
    'utility_required_protection_blind_scale', ...
    'utility_required_protection_urgency_scale', ...
    'utility_required_protection_link_scale'};
for i = 1:numel(protection_fields)
    field = protection_fields{i};
    params.(field) = params.(field) * candidate.ProtectionScale;
end
end

function scene_meta = find_scene_meta(scene_matrix, scene_id)
for i = 1:numel(scene_matrix)
    if scene_matrix(i).scene_id == scene_id
        scene_meta = scene_matrix(i);
        return;
    end
end
error('Unknown Step42 scene id: %s', scene_id);
end

function T_decision = build_step42_decision_table(summary)
key_vars = {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'};
keys = unique(summary(:, key_vars), 'rows', 'stable');
rows = [];
candidate_names = ["Proposed", "TimelyLow", "TimelyHigh", ...
    "ProtectLow", "ProtectHigh", "EmergencyFloorLow", "EmergencyFloorHigh"];

for i = 1:height(keys)
    mask = true(height(summary), 1);
    for k = 1:numel(key_vars)
        key = key_vars{k};
        mask = mask & summary.(key) == keys.(key)(i);
    end
    subT = summary(mask, :);
    h = subT(subT.Method == "Confidence-heuristic", :);
    linkd = subT(subT.Method == "Link-delay-aware", :);
    prop = subT(subT.Method == "Proposed", :);
    if isempty(h) || isempty(prop)
        continue;
    end

    for name = candidate_names
        cand = subT(subT.Method == name, :);
        if isempty(cand)
            continue;
        end
        row = keys(i, :);
        row.Candidate = name;
        row.TimelyRate = cand.TimelyRateMean(1);
        row.EmergencyTimely = cand.EmergencyTimelyRateMean(1);
        row.AvgDelay = cand.AvgDelayMean(1);
        row.AvgTxCost = cand.AvgTxCostMean(1);
        row.TimelyGainVsHeuristic_pp = 100.0 * (cand.TimelyRateMean(1) - h.TimelyRateMean(1));
        row.EmergencyGainVsHeuristic_pp = 100.0 * (cand.EmergencyTimelyRateMean(1) - h.EmergencyTimelyRateMean(1));
        if isempty(linkd)
            row.TimelyGainVsLink_pp = NaN;
        else
            row.TimelyGainVsLink_pp = 100.0 * (cand.TimelyRateMean(1) - linkd.TimelyRateMean(1));
        end
        row.CostDeltaVsProposedPct = 100.0 * (cand.AvgTxCostMean(1) - prop.AvgTxCostMean(1)) ...
            / max(abs(prop.AvgTxCostMean(1)), 1.0e-12);
        row.TimelyDeltaVsProposed_pp = 100.0 * (cand.TimelyRateMean(1) - prop.TimelyRateMean(1));
        rows = append_table_local(rows, row);
    end
end

T_decision = rows;
end

function write_step42_report(T, out_path)
fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step42 report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step42 Core Parameter Sensitivity Report\n\n');
fprintf(fid, 'Purpose: internal credibility check for the proposed method core parameter families.\n\n');
fprintf(fid, 'Candidate definitions:\n\n');
fprintf(fid, '- Proposed: current Risk-constrained-v6 setting.\n');
fprintf(fid, '- TimelyLow/TimelyHigh: required timely target family scaled by 0.90/1.10.\n');
fprintf(fid, '- ProtectLow/ProtectHigh: required protection target family scaled by 0.90/1.10.\n');
fprintf(fid, '- EmergencyFloorLow/High: emergency minimum rate multiplier set to 1.7/2.5.\n\n');

fprintf(fid, '## Candidate Table\n\n');
fprintf(fid, '| Scene | Config | Candidate | Timely Gain vs Heuristic (pp) | Emergency Gain vs Heuristic (pp) | Timely Delta vs Proposed (pp) | Cost Delta vs Proposed (%%) |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|\n');
for i = 1:height(T)
    fprintf(fid, '| %s | %s | %s | %.3f | %.3f | %.3f | %.2f |\n', ...
        T.Scene(i), T.Config(i), T.Candidate(i), ...
        T.TimelyGainVsHeuristic_pp(i), T.EmergencyGainVsHeuristic_pp(i), ...
        T.TimelyDeltaVsProposed_pp(i), T.CostDeltaVsProposedPct(i));
end
end

function T = append_table_local(T, rows)
if isempty(T)
    T = rows;
else
    T = [T; rows]; %#ok<AGROW>
end
end
