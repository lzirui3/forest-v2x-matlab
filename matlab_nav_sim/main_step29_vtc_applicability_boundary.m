clc;
clear;
close all;

base_dir = 'D:/matlab bussiness/forest_v2x_matlab_package/matlab_nav_sim';
cd(base_dir);

prefix = "step17_vtc_final";

T_summary = readtable(prefix + "_paper_statistics_summary.csv");
T_stage_raw = readtable(prefix + "_paper_statistics_stage_raw.csv");
T_sig = readtable(prefix + "_paper_statistics_significance.csv");
T_pos_sig = readtable(prefix + "_paper_statistics_posdeg_significance.csv");

T_summary = normalize_text_columns(T_summary);
T_stage_raw = normalize_text_columns(T_stage_raw);
T_sig = normalize_text_columns(T_sig);
T_pos_sig = normalize_text_columns(T_pos_sig);

scene_matrix = get_paper_scene_matrix();
scene_ids = unique(T_summary.Scene, 'stable');
config_names = unique(T_summary.Config, 'stable');

rows = table();

for s = 1:numel(scene_ids)
    scene_id = scene_ids(s);
    scene_meta = lookup_scene_meta(scene_matrix, scene_id);

    for c = 1:numel(config_names)
        cfg_name = config_names(c);
        fprintf('Step29: Scene=%s, Config=%s\n', scene_id, cfg_name);

        summary_sub = T_summary(T_summary.Scene == scene_id & T_summary.Config == cfg_name, :);
        stage_sub = T_stage_raw(T_stage_raw.Scene == scene_id & T_stage_raw.Config == cfg_name, :);

        base = pick_method(summary_sub, "Link-delay-aware");
        prop = pick_method(summary_sub, "Confidence-driven");
        oracle = pick_method(summary_sub, "Constrained Oracle");

        sig_sub = T_sig(T_sig.Scene == scene_id & T_sig.Config == cfg_name, :);
        pos_sub = T_pos_sig(T_pos_sig.Scene == scene_id & T_pos_sig.Config == cfg_name, :);

        full_timely = pick_metric(sig_sub, "TimelyRate");
        full_emg = pick_metric(sig_sub, "EmgTimely");
        full_delay = pick_metric(sig_sub, "AvgDelay");
        full_cost = pick_metric(sig_sub, "AvgTxCost");
        pos_timely = pick_metric(pos_sub, "TimelyRate");
        pos_emg = pick_metric(pos_sub, "EmgTimely");
        pos_delay = pick_metric(pos_sub, "AvgDelay");

        stage_gain = compute_peak_stage_gain(stage_sub);
        desc = compute_result_space_descriptors(summary_sub, stage_sub);

        [feasibility_band, app_class, paper_use, interpretation] = classify_boundary( ...
            base.TimelyRateMean, prop.TimelyRateMean, oracle.TimelyRateMean, ...
            base.EmergencyTimelyRateMean, prop.EmergencyTimelyRateMean, oracle.EmergencyTimelyRateMean, ...
            full_timely.DeltaPct, pos_timely.DeltaPct, full_emg.DeltaPct, ...
            full_cost.DeltaPct, desc.JointActivationProxy);

        row = table( ...
            scene_id, scene_meta.scene_role, scene_meta.geometry_type, ...
            scene_meta.density_class, scene_meta.vegetation_class, cfg_name, ...
            base.TimelyRateMean, prop.TimelyRateMean, oracle.TimelyRateMean, full_timely.DeltaPct, ...
            base.EmergencyTimelyRateMean, prop.EmergencyTimelyRateMean, oracle.EmergencyTimelyRateMean, full_emg.DeltaPct, ...
            base.AvgTxCostMean, prop.AvgTxCostMean, full_cost.Delta_Mean, full_cost.DeltaPct, ...
            full_delay.Delta_Mean, pos_timely.DeltaPct, pos_emg.DeltaPct, pos_delay.Delta_Mean, ...
            desc.PosDegBaseTimely, desc.PosDegOracleTimely, desc.PosDegOracleHeadroom, desc.PosDegStageShare, ...
            desc.EmergencyFeasibilityGap, desc.CostNormalizedGain, desc.JointActivationProxy, ...
            stage_gain.PeakStage, stage_gain.PeakDeltaPct, ...
            string(feasibility_band), string(app_class), string(paper_use), string(interpretation), ...
            'VariableNames', { ...
            'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config', ...
            'BaseTimely','ConfTimely','OracleTimely','FullDeltaTimely_pp', ...
            'BaseEmgTimely','ConfEmgTimely','OracleEmgTimely','FullDeltaEmg_pp', ...
            'BaseTxCost','ConfTxCost','DeltaTxCost','DeltaTxCostPct', ...
            'FullDeltaDelay_s','PosDegDeltaTimely_pp','PosDegDeltaEmg_pp','PosDegDeltaDelay_s', ...
            'PosDegBaseTimely','PosDegOracleTimely','PosDegOracleHeadroom_pp','PosDegStageShare', ...
            'EmergencyFeasibilityGap','CostNormalizedGain','JointActivationProxy', ...
            'PeakGainStage','PeakGainDelta_pp', ...
            'FeasibilityBand','ApplicabilityClass','PaperUse','Interpretation'});

        rows = [rows; row]; %#ok<AGROW>
    end
end

writetable(rows, 'step29_vtc_applicability_boundary_summary.csv');
write_step29_vtc_applicability_report(rows, 'step29_vtc_applicability_boundary_report.md');

disp(rows);
disp('Step 29 complete: VTC applicability boundary report generated.');

function T = normalize_text_columns(T)
text_vars = {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config','Method','Stage','Metric'};
for i = 1:numel(text_vars)
    name = text_vars{i};
    if ismember(name, T.Properties.VariableNames)
        T.(name) = string(T.(name));
    end
end
end

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

function row = pick_method(T, method_name)
row = T(T.Method == method_name, :);
if isempty(row)
    error('Method not found: %s', method_name);
end
row = row(1, :);
end

function row = pick_metric(T, metric_name)
row = T(T.Metric == metric_name, :);
if isempty(row)
    error('Metric not found: %s', metric_name);
end
row = row(1, :);
end

function stage_gain = compute_peak_stage_gain(stage_sub)
stage_names = unique(stage_sub.Stage, 'stable');
best_stage = "";
best_delta = -inf;

for i = 1:numel(stage_names)
    stage_name = stage_names(i);
    if stage_name == "Full"
        continue;
    end
    base_vals = stage_sub.TimelyRate(stage_sub.Stage == stage_name & stage_sub.Method == "Link-delay-aware");
    prop_vals = stage_sub.TimelyRate(stage_sub.Stage == stage_name & stage_sub.Method == "Confidence-driven");
    if isempty(base_vals) || isempty(prop_vals)
        continue;
    end
    delta_pp = 100.0 * (mean(prop_vals, 'omitnan') - mean(base_vals, 'omitnan'));
    if delta_pp > best_delta
        best_delta = delta_pp;
        best_stage = stage_name;
    end
end

stage_gain.PeakStage = best_stage;
stage_gain.PeakDeltaPct = best_delta;
end

function desc = compute_result_space_descriptors(summary_sub, stage_sub)
base = pick_method(summary_sub, "Link-delay-aware");
prop = pick_method(summary_sub, "Confidence-driven");
oracle = pick_method(summary_sub, "Constrained Oracle");

pos_stage = stage_sub(stage_sub.Stage == "PosDeg_Emerg", :);
pos_base = pos_stage(pos_stage.Method == "Link-delay-aware", :);
pos_prop = pos_stage(pos_stage.Method == "Confidence-driven", :);
pos_oracle = pos_stage(pos_stage.Method == "Constrained Oracle", :);

desc.PosDegBaseTimely = mean(pos_base.TimelyRate, 'omitnan');
desc.PosDegConfTimely = mean(pos_prop.TimelyRate, 'omitnan');
desc.PosDegOracleTimely = mean(pos_oracle.TimelyRate, 'omitnan');
desc.PosDegOracleHeadroom = 100.0 * (desc.PosDegOracleTimely - desc.PosDegBaseTimely);
desc.PosDegStageShare = height(pos_base) / max(height(stage_sub(stage_sub.Method == "Link-delay-aware", :)), 1);
desc.EmergencyFeasibilityGap = oracle.EmergencyTimelyRateMean - base.EmergencyTimelyRateMean;
desc.CostNormalizedGain = (prop.TimelyRateMean - base.TimelyRateMean) ...
    / max(prop.AvgTxCostMean - base.AvgTxCostMean, 1.0e-12);

% This is a result-space proxy, not a regenerated scenario-state ratio.
% It estimates whether the critical stage has both headroom and realized gain.
realized_pos_gain = 100.0 * (desc.PosDegConfTimely - desc.PosDegBaseTimely);
desc.JointActivationProxy = max(0.0, min(1.0, ...
    0.5 * max(desc.PosDegOracleHeadroom, 0.0) / 10.0 ...
    + 0.5 * max(realized_pos_gain, 0.0) / 10.0));
end

function [feasibility_band, app_class, paper_use, interpretation] = classify_boundary( ...
    base_timely, conf_timely, oracle_timely, base_emg, conf_emg, oracle_emg, ...
    full_delta_pp, pos_delta_pp, emg_delta_pp, cost_delta_pct, joint_ratio)

oracle_headroom_pp = 100.0 * (oracle_timely - base_timely);

if oracle_emg < 0.10
    feasibility_band = "NearImpossibleEmergency";
elseif oracle_emg < 0.50
    feasibility_band = "MarginalEmergency";
else
    feasibility_band = "FeasibleEmergency";
end

if oracle_emg < 0.10
    app_class = "NearImpossible";
    paper_use = "StressBoundary";
    interpretation = "Emergency delivery is bounded by the physical/channel configuration; use this row as feasibility-boundary evidence, not as a scheduler superiority claim.";
elseif base_timely >= 0.98 && abs(full_delta_pp) < 1.0
    app_class = "CeilingBoundary";
    paper_use = "BoundaryOnly";
    interpretation = "The link-delay-aware baseline is already near saturation; the method has little room to improve and should be discussed as graceful degradation.";
elseif base_timely < 0.70 && oracle_headroom_pp < 2.0 && abs(full_delta_pp) < 1.0
    app_class = "UniformHardBoundary";
    paper_use = "BoundaryOnly";
    interpretation = "The scene is uniformly hard and the constrained oracle offers limited headroom; localized confidence triggering cannot create large global gains.";
elseif full_delta_pp >= 3.0
    app_class = "ActiveGain";
    paper_use = "PrimaryEvidence";
    interpretation = "The method provides a material timely-rate gain and can be used as a primary performance-claim scene.";
elseif full_delta_pp >= 1.0
    app_class = "ModerateGain";
    paper_use = "SupportingEvidence";
    interpretation = "The method provides a moderate gain and should support the main claim without being overstated.";
elseif ~isnan(joint_ratio) && joint_ratio >= 0.05 && cost_delta_pct > 10.0
    app_class = "CostlyLowGain";
    paper_use = "BoundaryOnly";
    interpretation = "The trigger condition exists but the global timely gain is below 1 pp while cost increases; use only for cost-boundary discussion.";
elseif abs(full_delta_pp) < 1.0 && abs(pos_delta_pp) < 1.0
    app_class = "LowGainBoundary";
    paper_use = "BoundaryOnly";
    interpretation = "The method effect is below practical-gain threshold and should not be counted as main evidence.";
else
    app_class = "Mixed";
    paper_use = "SupportingEvidence";
    interpretation = "The row has mixed evidence; discuss with activation and cost qualifiers.";
end

if emg_delta_pp < -1.0 && oracle_emg >= 0.10
    interpretation = interpretation + " Emergency-timely direction is negative and must be reported as a limitation.";
end

if conf_emg < base_emg && oracle_emg < 0.10
    interpretation = interpretation + " The negative emergency delta is not a valid method-failure claim because the constrained-oracle upper bound is also near zero.";
end
end
