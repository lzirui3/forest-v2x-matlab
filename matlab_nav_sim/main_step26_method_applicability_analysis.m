clc;
clear;
close all;

base_dir = 'D:/matlab bussiness/forest_v2x_matlab_package/matlab_nav_sim';
cd(base_dir);

T_raw = readtable('step17_paper_statistics_raw.csv');
T_stage_raw = readtable('step17_paper_statistics_stage_raw.csv');

T_raw.Scene = string(T_raw.Scene);
T_raw.Config = string(T_raw.Config);
T_raw.Method = string(T_raw.Method);
T_stage_raw.Scene = string(T_stage_raw.Scene);
T_stage_raw.Config = string(T_stage_raw.Config);
T_stage_raw.Method = string(T_stage_raw.Method);
T_stage_raw.Stage = string(T_stage_raw.Stage);

scene_ids = unique(T_raw.Scene, 'stable');
config_names = unique(T_raw.Config, 'stable');
scene_matrix = get_paper_scene_matrix();

% Step26 targets the preview paper set that contains the boundary scene 10011.
target_scenes = ["10014", "10006", "10011"];
scene_ids = scene_ids(ismember(scene_ids, target_scenes));

rows = [];

for s = 1:numel(scene_ids)
    scene_id = scene_ids(s);
    scene_meta = lookup_scene_meta(scene_matrix, scene_id);

    for c = 1:numel(config_names)
        cfg_name = config_names(c);
        fprintf('Step26: Scene=%s, Config=%s\n', scene_id, cfg_name);

        raw_sub = T_raw(T_raw.Scene == scene_id & T_raw.Config == cfg_name, :);
        stage_sub = T_stage_raw(T_stage_raw.Scene == scene_id & T_stage_raw.Config == cfg_name, :);

        T_sig = compute_step12_statistical_tests(raw_sub, "Link-delay-aware", "Confidence-driven");
        T_sig = apply_familywise_holm_to_stats_table(T_sig);
        T_pos = compute_step12_statistical_tests( ...
            stage_sub(stage_sub.Stage == "PosDeg_Emerg", :), ...
            "Link-delay-aware", "Confidence-driven");
        T_pos = apply_familywise_holm_to_stats_table(T_pos);

        timely_full = local_pick_metric(T_sig, "TimelyRate");
        timely_pos = local_pick_metric(T_pos, "TimelyRate");
        delay_full = local_pick_metric(T_sig, "AvgDelay");
        cost_full = local_pick_metric(T_sig, "AvgTxCost");

        stage_gain = compute_stage_timeline_gain(stage_sub);

        seeds = unique(raw_sub.Seed, 'stable');
        seeds = seeds(1:min(3, numel(seeds)));
        [qpos_mean, qlink_mean, blind_mean, nlos_ratio, lowq_ratio, blind_ratio, joint_ratio] = ...
            compute_scene_activation_descriptors(scene_id, cfg_name, seeds);

        [applicability_class, interpretation] = classify_applicability( ...
            timely_full.DeltaPct, timely_pos.DeltaPct, joint_ratio, blind_ratio, lowq_ratio, cost_full.DeltaPct);

        row = table( ...
            scene_id, scene_meta.scene_role, scene_meta.geometry_type, scene_meta.density_class, scene_meta.vegetation_class, ...
            cfg_name, ...
            timely_full.Baseline_Mean, timely_full.Proposed_Mean, timely_full.Delta_Mean, timely_full.DeltaPct, timely_full.P_Value_Holm_Family, ...
            timely_pos.Baseline_Mean, timely_pos.Proposed_Mean, timely_pos.Delta_Mean, timely_pos.DeltaPct, timely_pos.P_Value_Holm_Family, ...
            delay_full.Delta_Mean, cost_full.Delta_Mean, cost_full.DeltaPct, ...
            qpos_mean, qlink_mean, blind_mean, nlos_ratio, lowq_ratio, blind_ratio, joint_ratio, ...
            stage_gain.PeakStage, stage_gain.PeakDeltaPct, ...
            string(applicability_class), string(interpretation), ...
            'VariableNames', { ...
            'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config', ...
            'Full_BaseTimely','Full_ConfTimely','Full_DeltaTimely','Full_DeltaPctPt','Full_P_HolmFamily', ...
            'PosDeg_BaseTimely','PosDeg_ConfTimely','PosDeg_DeltaTimely','PosDeg_DeltaPctPt','PosDeg_P_HolmFamily', ...
            'Full_DeltaDelay_s','Full_DeltaTxCost','Full_DeltaTxCostPct', ...
            'PosDeg_QPosMean','PosDeg_QLinkMean','PosDeg_BlindScoreMean','PosDeg_NlosRatio', ...
            'PosDeg_LowQPosRatio','PosDeg_BlindTriggerRatio','PosDeg_JointActivationRatio', ...
            'PeakGainStage','PeakGainPctPt','ApplicabilityClass','Interpretation'});

        if isempty(rows)
            rows = row;
        else
            rows = [rows; row]; %#ok<AGROW>
        end
    end
end

writetable(rows, 'step26_method_applicability_summary.csv');
write_step26_method_applicability_report(rows, 'step26_method_applicability_report.md');

disp(rows);
disp('Step 26 complete: method applicability analysis generated.');

function meta = lookup_scene_meta(scene_matrix, scene_id)
meta.scene_role = "Unknown";
meta.geometry_type = "Unknown";
meta.density_class = "Unknown";
meta.vegetation_class = "Unknown";

for i = 1:numel(scene_matrix)
    if scene_matrix(i).scene_id == scene_id
        meta.scene_role = scene_matrix(i).scene_role;
        meta.geometry_type = scene_matrix(i).geometry_type;
        meta.density_class = scene_matrix(i).density_class;
        meta.vegetation_class = scene_matrix(i).vegetation_class;
        return;
    end
end
end

function metric_row = local_pick_metric(T, metric_name)
metric_row = T(T.Metric == metric_name, :);
if isempty(metric_row)
    error('Metric not found: %s', metric_name);
end
metric_row = metric_row(1, :);
end

function stage_gain = compute_stage_timeline_gain(stage_sub)
stage_names = unique(stage_sub.Stage, 'stable');
best_stage = "";
best_delta = -inf;

for i = 1:numel(stage_names)
    sname = stage_names(i);
    base_vals = stage_sub.TimelyRate(stage_sub.Stage == sname & stage_sub.Method == "Link-delay-aware");
    prop_vals = stage_sub.TimelyRate(stage_sub.Stage == sname & stage_sub.Method == "Confidence-driven");
    if isempty(base_vals) || isempty(prop_vals)
        continue;
    end
    delta_pct_pt = 100.0 * (mean(prop_vals, 'omitnan') - mean(base_vals, 'omitnan'));
    if delta_pct_pt > best_delta
        best_delta = delta_pct_pt;
        best_stage = sname;
    end
end

stage_gain.PeakStage = best_stage;
stage_gain.PeakDeltaPct = best_delta;
end

function [qpos_mean, qlink_mean, blind_mean, nlos_ratio, lowq_ratio, blind_ratio, joint_ratio] = ...
    compute_scene_activation_descriptors(scene_id, cfg_name, seeds)

qpos_vals = zeros(numel(seeds), 1);
qlink_vals = zeros(numel(seeds), 1);
blind_vals = zeros(numel(seeds), 1);
nlos_vals = zeros(numel(seeds), 1);
lowq_vals = zeros(numel(seeds), 1);
blindtrig_vals = zeros(numel(seeds), 1);
joint_vals = zeros(numel(seeds), 1);

for k = 1:numel(seeds)
    if cfg_name == "Default"
        params = get_default_step9_mainline_params();
    else
        params = get_forest_geometry_mainline_params();
    end

    params.scenario_input = get_step9_v2xseq_config_by_scene(scene_id);
    params.random_seed = seeds(k);

    scenario = generate_step9_scenario(params);
    stages = define_step9_stage_masks(scenario.t);
    pos_mask = stages(4).mask & (scenario.msg_type == "emergency");

    blind_score = max( ...
        scenario.blind_zone_gate, ...
        0.45 * scenario.urgency + 0.30 * (1.0 - scenario.q_link) + 0.25 * (1.0 - scenario.q_pos));

    qpos_vals(k) = mean(scenario.q_pos(pos_mask), 'omitnan');
    qlink_vals(k) = mean(scenario.q_link(pos_mask), 'omitnan');
    blind_vals(k) = mean(blind_score(pos_mask), 'omitnan');
    nlos_vals(k) = mean(double(scenario.is_nlos(pos_mask)), 'omitnan');
    lowq_vals(k) = mean(double(scenario.q_pos(pos_mask) <= params.utility_blind_pos_threshold), 'omitnan');
    blindtrig_vals(k) = mean(double(blind_score(pos_mask) >= params.utility_blind_protection_threshold), 'omitnan');
    joint_vals(k) = mean(double( ...
        scenario.q_pos(pos_mask) <= params.utility_blind_pos_threshold ...
        & blind_score(pos_mask) >= params.utility_blind_protection_threshold), 'omitnan');
end

qpos_mean = mean(qpos_vals, 'omitnan');
qlink_mean = mean(qlink_vals, 'omitnan');
blind_mean = mean(blind_vals, 'omitnan');
nlos_ratio = mean(nlos_vals, 'omitnan');
lowq_ratio = mean(lowq_vals, 'omitnan');
blind_ratio = mean(blindtrig_vals, 'omitnan');
joint_ratio = mean(joint_vals, 'omitnan');
end

function [applicability_class, interpretation] = classify_applicability(full_delta_pp, pos_delta_pp, joint_ratio, blind_ratio, lowq_ratio, cost_delta_pct)
if isnan(joint_ratio)
    applicability_class = "GracefulBoundary";
    interpretation = "No critical emergency-overlap samples exist in PosDeg_Emerg; the method is effectively inactive in the target regime and should be treated as graceful boundary behavior.";
elseif joint_ratio < 0.05 && abs(pos_delta_pp) < 1.0 && abs(full_delta_pp) < 1.0
    applicability_class = "GracefulBoundary";
    interpretation = "Critical trigger overlap is absent; the method collapses to the baseline without harming timely performance.";
elseif joint_ratio >= 0.05 && (pos_delta_pp >= 1.0 || full_delta_pp >= 1.0)
    applicability_class = "Active";
    interpretation = "Critical trigger overlap is present; the confidence-driven logic is activated and produces measurable gain.";
elseif joint_ratio < 0.05 && full_delta_pp >= 1.0
    applicability_class = "Stage-Misaligned";
    interpretation = "Gain exists mainly outside the intended critical stage; the scene is too easy in PosDeg_Emerg but not globally trivial.";
else
    applicability_class = "Mixed";
    if cost_delta_pct > 1.0
        interpretation = "The method reacts weakly and mainly adds transmission cost; engineering benefit should be qualified carefully.";
    else
        interpretation = "The scene only partially satisfies the activation condition; gains are limited and should be interpreted conservatively.";
    end
end
end
