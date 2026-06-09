clc;
clear;

num_seeds = 10;
seed_override = getenv('STEP28_NUM_SEEDS');
if ~isempty(seed_override)
    num_seeds = str2double(seed_override);
end
seed_list = 1:num_seeds;

target_scenes = get_env_string_list('STEP28_SCENES', ["10014", "10017", "10011"]);
profile_names = get_env_string_list('STEP28_PROFILES', ["Strict-75ms", "Forest-150ms", "Moderate-Forest"]);
method_names = ["Link-delay-aware", "Confidence-driven", "Constrained Oracle"];

default_base = get_default_step9_mainline_params();
forest_base = get_forest_geometry_mainline_params();
profile_params = build_profile_params(profile_names, default_base, forest_base);
profile_table = build_profile_table(profile_names, profile_params);

rows = [];
stage_rows = [];
T_sig = [];
scene_matrix = get_paper_scene_matrix();

for scene_id = target_scenes
    scene_meta = find_scene_meta(scene_matrix, scene_id);
    scene_cfg = get_step9_v2xseq_config_by_scene(scene_id);

    for p = 1:numel(profile_names)
        profile_name = profile_names(p);
        base_params = profile_params{p};

        for seed = seed_list
            params = base_params;
            params.scenario_input = scene_cfg;
            params.random_seed = seed;

            scenario = generate_step9_scenario(params);

            rng(seed, 'twister');
            linkd = run_step9_baseline_link_delayaware(scenario, params);
            rng(seed, 'twister');
            conf = run_step9_confidence_driven(scenario, params);
            rng(seed, 'twister');
            oracle = run_step9_baseline_oracle(scenario, params);

            results = {linkd, conf, oracle};
            T_seed = evaluate_step9_metrics(scenario, results);
            T_seed.Scene = repmat(scene_id, height(T_seed), 1);
            T_seed.SceneRole = repmat(scene_meta.scene_role, height(T_seed), 1);
            T_seed.GeometryType = repmat(scene_meta.geometry_type, height(T_seed), 1);
            T_seed.DensityClass = repmat(scene_meta.density_class, height(T_seed), 1);
            T_seed.VegetationClass = repmat(scene_meta.vegetation_class, height(T_seed), 1);
            T_seed.Config = repmat(profile_name, height(T_seed), 1);
            T_seed.Seed = repmat(seed, height(T_seed), 1);
            T_seed = movevars(T_seed, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config','Seed'}, 'Before', 'Method');
            rows = append_table(rows, T_seed);

            stages = define_step9_stage_masks(scenario.t);
            metrics_list = cell(numel(results), 1);
            for i = 1:numel(results)
                metrics_list{i} = compute_step9_stage_metrics(scenario, results{i}, stages);
            end
            T_stage = build_step9_stage_metrics_table(cellstr(method_names), metrics_list);
            T_stage.Scene = repmat(scene_id, height(T_stage), 1);
            T_stage.SceneRole = repmat(scene_meta.scene_role, height(T_stage), 1);
            T_stage.GeometryType = repmat(scene_meta.geometry_type, height(T_stage), 1);
            T_stage.DensityClass = repmat(scene_meta.density_class, height(T_stage), 1);
            T_stage.VegetationClass = repmat(scene_meta.vegetation_class, height(T_stage), 1);
            T_stage.Config = repmat(profile_name, height(T_stage), 1);
            T_stage.Seed = repmat(seed, height(T_stage), 1);
            T_stage = movevars(T_stage, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config','Seed'}, 'Before', 'Method');
            stage_rows = append_table(stage_rows, T_stage);
        end

        T_cfg = rows(rows.Scene == scene_id & rows.Config == profile_name, :);
        T_cfg_stat = compute_step12_statistical_tests(T_cfg, "Link-delay-aware", "Confidence-driven");
        T_cfg_stat.Scene = repmat(scene_id, height(T_cfg_stat), 1);
        T_cfg_stat.Config = repmat(profile_name, height(T_cfg_stat), 1);
        T_cfg_stat = movevars(T_cfg_stat, {'Scene','Config'}, 'Before', 'Metric');
        T_sig = append_table(T_sig, T_cfg_stat);
    end
end

summary = build_step17_summary_table(rows);
stage_summary = build_step17_stage_summary_table(stage_rows);
T_sig = apply_familywise_holm_to_stats_table(T_sig);
emergency_delta = build_emergency_delta_table(summary);
T_eff = build_cost_efficiency_table(summary, "Link-delay-aware");

writetable(profile_table, 'step28_p1_sensitivity_profile_table.csv');
writetable(rows, 'step28_p1_sensitivity_raw.csv');
writetable(stage_rows, 'step28_p1_sensitivity_stage_raw.csv');
writetable(summary, 'step28_p1_sensitivity_summary.csv');
writetable(stage_summary, 'step28_p1_sensitivity_stage_summary.csv');
writetable(T_sig, 'step28_p1_sensitivity_significance.csv');
writetable(emergency_delta, 'step28_p1_sensitivity_emergency_delta.csv');
writetable(T_eff, 'step28_p1_sensitivity_cost_efficiency.csv');
plot_cost_efficiency_pareto(summary, 'step28_p1_sensitivity');
write_step28_p1_sensitivity_report(profile_table, summary, emergency_delta, T_sig, ...
    'step28_p1_sensitivity_report.md');

disp(profile_table);
disp(emergency_delta);
disp(T_sig(T_sig.Metric == "EmgTimely", :));
fprintf('Step 28 complete: P1 sensitivity experiment (%d seeds, %d scenes, %d profiles).\n', ...
    num_seeds, numel(target_scenes), numel(profile_names));

function profile_params = build_profile_params(profile_names, default_base, forest_base)
profile_params = cell(numel(profile_names), 1);
for i = 1:numel(profile_names)
    name = profile_names(i);
    switch lower(char(name))
        case 'strict-75ms'
            params = forest_base;
            params = set_emergency_deadline(params, 0.075);
            params.p1_sensitivity_profile = "Strict-75ms";
            params.p1_sensitivity_note = "ForestGeometry channel with strict 75 ms emergency deadline.";
        case 'forest-150ms'
            params = forest_base;
            params = set_emergency_deadline(params, 0.150);
            params.p1_sensitivity_profile = "Forest-150ms";
            params.p1_sensitivity_note = "ForestGeometry channel with 150 ms forest emergency deadline.";
        case 'moderate-forest'
            params = interpolate_physical_forest_params(default_base, forest_base, 0.5);
            params = set_emergency_deadline(params, 0.150);
            params.p1_sensitivity_profile = "Moderate-Forest";
            params.p1_sensitivity_note = "Midpoint physical degradation between Default and ForestGeometry, with 150 ms emergency deadline.";
        otherwise
            error('Unknown Step28 P1 sensitivity profile: %s', name);
    end
    profile_params{i} = params;
end
end

function params = set_emergency_deadline(params, deadline_s)
params.deadline_emergency = deadline_s;
params.deadline_emergency_physical = deadline_s;
end

function params = interpolate_physical_forest_params(default_base, forest_base, alpha)
params = forest_base;
fields = { ...
    'link_distance_scale', ...
    'tx_power_dBm', ...
    'pathloss_los_offset_dB', ...
    'pathloss_los_exponent', ...
    'pathloss_nlos_offset_dB', ...
    'pathloss_nlos_exponent', ...
    'nlosv_extra_loss_dB', ...
    'interference_scale', ...
    'blind_link_loss_scale_dB', ...
    'blind_interference_scale_dB'};

for i = 1:numel(fields)
    field = fields{i};
    params.(field) = default_base.(field) + alpha * (forest_base.(field) - default_base.(field));
end
end

function T = build_profile_table(profile_names, profile_params)
rows = [];
for i = 1:numel(profile_names)
    params = profile_params{i};
    row = table( ...
        profile_names(i), ...
        params.deadline_emergency, ...
        params.deadline_coop, ...
        params.link_distance_scale, ...
        params.tx_power_dBm, ...
        params.pathloss_los_offset_dB, ...
        params.pathloss_los_exponent, ...
        params.pathloss_nlos_offset_dB, ...
        params.pathloss_nlos_exponent, ...
        params.nlosv_extra_loss_dB, ...
        params.interference_scale, ...
        params.blind_link_loss_scale_dB, ...
        params.blind_interference_scale_dB, ...
        string(params.p1_sensitivity_note), ...
        'VariableNames', { ...
        'Profile','DeadlineEmergency_s','DeadlineCoop_s','LinkDistanceScale', ...
        'TxPower_dBm','PathlossLosOffset_dB','PathlossLosExponent', ...
        'PathlossNlosOffset_dB','PathlossNlosExponent','NlosvExtraLoss_dB', ...
        'InterferenceScale','BlindLinkLossScale_dB','BlindInterferenceScale_dB','Definition'});
    rows = append_table(rows, row);
end
T = rows;
end

function T_delta = build_emergency_delta_table(T_summary)
key_vars = {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'};
keys = unique(T_summary(:, key_vars), 'rows', 'stable');
rows = [];

for i = 1:height(keys)
    mask = true(height(T_summary), 1);
    for j = 1:numel(key_vars)
        key = key_vars{j};
        mask = mask & T_summary.(key) == keys.(key)(i);
    end

    linkd = T_summary(mask & T_summary.Method == "Link-delay-aware", :);
    conf = T_summary(mask & T_summary.Method == "Confidence-driven", :);
    oracle = T_summary(mask & is_constrained_oracle(T_summary.Method), :);
    if isempty(linkd) || isempty(conf) || isempty(oracle)
        continue;
    end

    row = keys(i, :);
    row.LinkEmergencyTimelyMean = linkd.EmergencyTimelyRateMean(1);
    row.ConfidenceEmergencyTimelyMean = conf.EmergencyTimelyRateMean(1);
    row.ConstrainedOracleEmergencyTimelyMean = oracle.EmergencyTimelyRateMean(1);
    row.ConfidenceMinusLink_pp = 100.0 * (conf.EmergencyTimelyRateMean(1) - linkd.EmergencyTimelyRateMean(1));
    row.ConstrainedOracleMinusLink_pp = 100.0 * (oracle.EmergencyTimelyRateMean(1) - linkd.EmergencyTimelyRateMean(1));
    row.ConstrainedOracleFeasibilityBand = classify_constrained_oracle_feasibility(oracle.EmergencyTimelyRateMean(1));
    rows = append_table(rows, row);
end

T_delta = rows;
end

function label = classify_constrained_oracle_feasibility(value)
if value >= 0.60
    label = "Feasible";
elseif value >= 0.30
    label = "Marginal";
else
    label = "Near-impossible";
end
end

function idx = is_constrained_oracle(methods)
idx = methods == "Constrained Oracle" | methods == "Oracle";
end

function scene_meta = find_scene_meta(scene_matrix, scene_id)
idx = find([scene_matrix.scene_id] == scene_id, 1);
if isempty(idx)
    error('Unknown scene id for Step28: %s', scene_id);
end
scene_meta = scene_matrix(idx);
end

function values = get_env_string_list(name, default_values)
raw = strtrim(string(getenv(name)));
if strlength(raw) == 0
    values = default_values;
    return;
end

parts = strtrim(split(raw, ','));
values = parts(strlength(parts) > 0).';
end

function T = append_table(T, rows)
if isempty(T)
    T = rows;
else
    T = [T; rows]; %#ok<AGROW>
end
end
