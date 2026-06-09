clc;
clear;
close all;

% Step61: applicability boundary update.
% Aggregates Step58/59/60 evidence without retuning V6 or removing negative
% ForestGeometry boundary cases.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

prefix = "step61_applicability_boundary_update";

required_files = [
    "step58_paper_ready_applicability_table.csv"
    "step58_paper_ready_negative_boundary_table.csv"
    "step58_paper_ready_cost_efficiency_table.csv"
    "step58_paper_ready_main_performance_table.csv"
    "step59_stronger_literature_baselines_50seed_decision_table.csv"
    "step59_stronger_literature_baselines_50seed_summary.csv"
    "step60_moderate_forest_geometry_50seed_decision_table.csv"
    "step60_moderate_forest_geometry_50seed_summary.csv"
    "step60_moderate_forest_geometry_50seed_coverage.csv"
    ];
assert_files_exist_local(required_files);

T58_app = readtable("step58_paper_ready_applicability_table.csv", 'TextType', 'string');
T58_neg = readtable("step58_paper_ready_negative_boundary_table.csv", 'TextType', 'string');
T58_cost = readtable("step58_paper_ready_cost_efficiency_table.csv", 'TextType', 'string');
T58_perf = readtable("step58_paper_ready_main_performance_table.csv", 'TextType', 'string');
T59_dec = readtable("step59_stronger_literature_baselines_50seed_decision_table.csv", 'TextType', 'string');
T59_sum = readtable("step59_stronger_literature_baselines_50seed_summary.csv", 'TextType', 'string');
T60_dec = readtable("step60_moderate_forest_geometry_50seed_decision_table.csv", 'TextType', 'string');
T60_sum = readtable("step60_moderate_forest_geometry_50seed_summary.csv", 'TextType', 'string');
T60_cov = readtable("step60_moderate_forest_geometry_50seed_coverage.csv", 'TextType', 'string');

assert_step60_coverage_local(T60_cov);

applicability = build_applicability_update_local(T58_app, T59_dec, T60_dec);
failure_boundary = build_failure_boundary_table_local(T58_neg, T59_dec, T60_dec);
dcc_overtake = build_dcc_overtake_table_local(T59_dec, T60_dec);
small_gain = build_small_gain_table_local(T58_app, T59_dec, T60_dec);

writetable(applicability, prefix + "_applicability_table.csv");
writetable(failure_boundary, prefix + "_failure_boundary_table.csv");
writetable(dcc_overtake, prefix + "_dcc_overtake_analysis_table.csv");
writetable(small_gain, prefix + "_small_gain_table.csv");
write_step61_applicability_boundary_report_cn(applicability, failure_boundary, ...
    dcc_overtake, small_gain, prefix + "_report_cn.md");

disp(applicability);
disp(failure_boundary);
fprintf('Step61 complete: applicability and boundary evidence updated.\n');

function applicability = build_applicability_update_local(T58_app, T59_dec, T60_dec)
rows = [];

for i = 1:height(T58_app)
    row = T58_app(i, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'});
    row.Dataset = T58_app.Dataset(i);
    row.EvidenceSource = "Step58+Step59";
    row.BaselineTimelyCeiling = classify_baseline_ceiling_local(T58_app.TimelyGainVsLink_pp(i));
    row.EmergencyFeasibility = classify_emergency_feasibility_local(T58_app.EmgGainVsHeuristic_pp(i), ...
        T58_app.OracleMinusV6Timely_pp(i), T58_app.EmergencyPct(i));
    row.NlosBlindGnssOverlap = classify_overlap_local(T58_app.NlosPct(i), T58_app.EmergencyPct(i), ...
        T58_app.DensityClass(i), T58_app.VegetationClass(i));
    row.CostGainTradeoff = classify_cost_gain_local(T58_app.TimelyGainVsHeuristic_pp(i), ...
        T58_app.CostDeltaVsHeuristic_pct(i));
    row.StrongerBaselineDecision = lookup_step59_decision_local(T59_dec, T58_app.Scene(i), T58_app.Config(i));
    row.ApplicabilityClass = classify_applicability_local( ...
        T58_app.ApplicabilityClass(i), row.StrongerBaselineDecision, ...
        row.EmergencyFeasibility, row.CostGainTradeoff, false);
    row.ApplicabilityNote = build_note_local(row.ApplicabilityClass, row.StrongerBaselineDecision, ...
        row.NlosBlindGnssOverlap, row.CostGainTradeoff);
    rows = append_table_local(rows, row);
end

for i = 1:height(T60_dec)
    row = T60_dec(i, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'});
    row.Dataset = infer_dataset_local(T60_dec.SceneRole(i));
    row.EvidenceSource = "Step60-ModerateForestGeometry";
    row.BaselineTimelyCeiling = classify_baseline_ceiling_local(T60_dec.TimelyGainVsLink_pp(i));
    row.EmergencyFeasibility = classify_moderate_emergency_local( ...
        T60_dec.V6EmergencyTimely_pct(i), T60_dec.OracleEmergencyTimely_pct(i));
    row.NlosBlindGnssOverlap = classify_overlap_local(NaN, NaN, ...
        T60_dec.DensityClass(i), T60_dec.VegetationClass(i));
    row.CostGainTradeoff = classify_cost_gain_local(T60_dec.TimelyGainVsHeuristic_pp(i), 0.0);
    row.StrongerBaselineDecision = classify_moderate_stronger_one_local(T60_dec(i, :));
    row.ApplicabilityClass = classify_applicability_local( ...
        T60_dec.ModerateForestDecision(i), row.StrongerBaselineDecision, ...
        row.EmergencyFeasibility, row.CostGainTradeoff, true);
    row.ApplicabilityNote = build_note_local(row.ApplicabilityClass, row.StrongerBaselineDecision, ...
        row.NlosBlindGnssOverlap, row.CostGainTradeoff);
    rows = append_table_local(rows, row);
end

applicability = rows;
applicability = movevars(applicability, {'Dataset','EvidenceSource'}, 'Before', 'Scene');
end

function failure_boundary = build_failure_boundary_table_local(T58_neg, T59_dec, T60_dec)
rows = [];
for i = 1:height(T58_neg)
    row = T58_neg(i, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'});
    row.EvidenceSource = "Step58-negative-boundary";
    row.BoundaryClass = "FailureBoundary";
    row.PrimaryReason = T58_neg.BoundaryEvidence(i);
    row.TimelyDeltaVsHeuristic_pp = T58_neg.DeltaTimely_pp(i);
    row.EmergencyDeltaVsHeuristic_pp = T58_neg.DeltaEmergency_pp(i);
    row.CostDeltaVsHeuristic_pct = T58_neg.DeltaCost_pct(i);
    row.StrongerBaselineDecision = lookup_step59_decision_local(T59_dec, T58_neg.Scene(i), T58_neg.Config(i));
    rows = append_table_local(rows, row);
end

moderate_hard = T60_dec(contains(T60_dec.ModerateForestDecision, "Boundary") ...
    | contains(T60_dec.ModerateForestDecision, "Risk"), :);
for i = 1:height(moderate_hard)
    row = moderate_hard(i, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'});
    row.EvidenceSource = "Step60-ModerateForestGeometry";
    if contains(moderate_hard.ModerateForestDecision(i), "HardEmergency")
        row.BoundaryClass = "PhysicalEmergencyBoundary";
    else
        row.BoundaryClass = "GracefulDegradation";
    end
    row.PrimaryReason = "Moderate forest evidence shows low emergency headroom or weak/negative gain; report as applicability boundary.";
    row.TimelyDeltaVsHeuristic_pp = moderate_hard.TimelyGainVsHeuristic_pp(i);
    row.EmergencyDeltaVsHeuristic_pp = moderate_hard.EmgGainVsHeuristic_pp(i);
    row.CostDeltaVsHeuristic_pct = NaN;
    row.StrongerBaselineDecision = classify_moderate_stronger_one_local(moderate_hard(i, :));
    rows = append_table_local(rows, row);
end
failure_boundary = rows;
end

function dcc_overtake = build_dcc_overtake_table_local(T59_dec, T60_dec)
rows = [];
for i = 1:height(T59_dec)
    row = T59_dec(i, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'});
    row.EvidenceSource = "Step59";
    row.TimelyGainVsDCCWindow_pp = T59_dec.TimelyGainVsDCCWindow_pp(i);
    row.EmgGainVsDCCWindow_pp = T59_dec.EmgGainVsDCCWindow_pp(i);
    row.TimelyGainVsAoIGreedy_pp = T59_dec.TimelyGainVsAoIGreedy_pp(i);
    row.OvertakeClass = classify_overtake_local(row.TimelyGainVsDCCWindow_pp, row.TimelyGainVsAoIGreedy_pp);
    rows = append_table_local(rows, row);
end
for i = 1:height(T60_dec)
    row = T60_dec(i, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'});
    row.EvidenceSource = "Step60";
    row.TimelyGainVsDCCWindow_pp = T60_dec.TimelyGainVsDCCWindow_pp(i);
    row.EmgGainVsDCCWindow_pp = NaN;
    row.TimelyGainVsAoIGreedy_pp = T60_dec.TimelyGainVsAoIGreedy_pp(i);
    row.OvertakeClass = classify_overtake_local(row.TimelyGainVsDCCWindow_pp, row.TimelyGainVsAoIGreedy_pp);
    rows = append_table_local(rows, row);
end
dcc_overtake = rows;
end

function small_gain = build_small_gain_table_local(T58_app, T59_dec, T60_dec)
rows = [];
for i = 1:height(T58_app)
    min_gain = min([abs(T58_app.TimelyGainVsHeuristic_pp(i)), abs(T58_app.TimelyGainVsLink_pp(i))]);
    if min_gain > 1.0 && ~contains(T58_app.ApplicabilityClass(i), "Boundary")
        continue;
    end
    row = T58_app(i, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'});
    row.EvidenceSource = "Step58";
    row.ReferenceGain_pp = T58_app.TimelyGainVsHeuristic_pp(i);
    row.ReferenceBaseline = "Confidence-heuristic";
    row.StrongerBaselineDecision = lookup_step59_decision_local(T59_dec, T58_app.Scene(i), T58_app.Config(i));
    row.SmallGainInterpretation = "Small gain: use as graceful degradation or boundary evidence, not as dominance claim.";
    rows = append_table_local(rows, row);
end
for i = 1:height(T60_dec)
    if abs(T60_dec.TimelyGainVsHeuristic_pp(i)) > 1.0 && ~contains(T60_dec.ModerateForestDecision(i), "Boundary")
        continue;
    end
    row = T60_dec(i, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config'});
    row.EvidenceSource = "Step60";
    row.ReferenceGain_pp = T60_dec.TimelyGainVsHeuristic_pp(i);
    row.ReferenceBaseline = "Confidence-heuristic";
    row.StrongerBaselineDecision = classify_moderate_stronger_one_local(T60_dec(i, :));
    row.SmallGainInterpretation = "Moderate forest small gain: acceptable only with explicit applicability boundary.";
    rows = append_table_local(rows, row);
end
small_gain = rows;
end

function label = classify_baseline_ceiling_local(gain_vs_link)
if gain_vs_link >= 3.0
    label = "LowBaselineCeiling";
elseif gain_vs_link >= 0.5
    label = "ModerateBaselineCeiling";
else
    label = "HighBaselineCeiling";
end
end

function label = classify_emergency_feasibility_local(emg_gain, oracle_gap, emergency_pct)
if emergency_pct >= 80 && oracle_gap <= 0.5 && emg_gain < -0.1
    label = "EmergencySaturatedOrHard";
elseif emg_gain >= 0.1
    label = "EmergencyImproved";
elseif abs(emg_gain) <= 0.1
    label = "EmergencyNeutral";
else
    label = "EmergencyWeakNegative";
end
end

function label = classify_moderate_emergency_local(v6_emg_pct, oracle_emg_pct)
if oracle_emg_pct < 10.0
    label = "PhysicallyHardEmergency";
elseif v6_emg_pct >= 90.0
    label = "EmergencyHighHeadroom";
elseif v6_emg_pct >= 50.0
    label = "EmergencyModerateHeadroom";
else
    label = "EmergencyLowHeadroom";
end
end

function label = classify_overlap_local(nlos_pct, emergency_pct, density_class, vegetation_class)
if ismissing(string(density_class))
    density_class = "";
end
if ismissing(string(vegetation_class))
    vegetation_class = "";
end
if strcmpi(char(density_class), 'High') || strcmpi(char(vegetation_class), 'Dense')
    label = "HighBlindVegetationOverlap";
elseif ~isnan(nlos_pct) && ~isnan(emergency_pct) && nlos_pct >= 30 && emergency_pct >= 40
    label = "NlosEmergencyOverlap";
elseif ~isnan(nlos_pct) && nlos_pct <= 10
    label = "LowOverlapOpenRoad";
else
    label = "ModerateOverlap";
end
end

function label = classify_cost_gain_local(timely_gain, cost_delta)
if timely_gain >= 1.0 && cost_delta <= 10.0
    label = "EfficientGain";
elseif timely_gain >= 0.0 && cost_delta <= 0.0
    label = "CostSavingOrNeutral";
elseif timely_gain >= 0.0
    label = "CostlySmallGain";
else
    label = "CostInefficientBoundary";
end
end

function label = classify_applicability_local(base_class, stronger_decision, emergency_feasibility, cost_tradeoff, is_moderate)
if contains(base_class, "HardEmergency") || emergency_feasibility == "PhysicallyHardEmergency"
    label = "FailureBoundary";
elseif contains(base_class, "Risk") || contains(stronger_decision, "Boundary") ...
        || contains(base_class, "Boundary") || contains(cost_tradeoff, "Boundary")
    label = "GracefulDegradation";
elseif contains(stronger_decision, "Gain") || contains(base_class, "Primary") ...
        || contains(base_class, "Improvement") || is_moderate
    label = "EffectiveRegime";
else
    label = "GracefulDegradation";
end
end

function note = build_note_local(app_class, stronger_decision, overlap, cost_tradeoff)
if app_class == "EffectiveRegime"
    note = "Applicable when risk/degradation creates exploitable scheduling headroom; stronger baselines are outperformed or nonnegative.";
elseif app_class == "FailureBoundary"
    note = "Physical deadline-reliability headroom is insufficient; do not claim method dominance.";
else
    note = "Use as boundary evidence: gains are small, baseline ceiling is high, or cost-gain tradeoff is weak.";
end
note = note + " Stronger=" + string(stronger_decision) + "; overlap=" + string(overlap) + "; cost=" + string(cost_tradeoff) + ".";
end

function decision = lookup_step59_decision_local(T59_dec, scene, cfg)
idx = T59_dec.Scene == scene & T59_dec.Config == cfg;
if any(idx)
    decision = T59_dec.StrongerBaselineDecision(find(idx, 1));
else
    decision = "NotAvailable";
end
end

function decision = classify_moderate_stronger_local(T60_dec)
decision = strings(height(T60_dec), 1);
for i = 1:height(T60_dec)
    decision(i) = classify_moderate_stronger_one_local(T60_dec(i, :));
end
end

function decision = classify_moderate_stronger_one_local(row)
if row.TimelyGainVsDCCWindow_pp >= 0.5 && row.TimelyGainVsAoIGreedy_pp >= -0.1
    decision = "StrongerBaselineGain";
elseif row.TimelyGainVsDCCWindow_pp >= -0.5 && row.TimelyGainVsAoIGreedy_pp >= -0.5
    decision = "StrongerBaselineBoundary";
else
    decision = "StrongerBaselineNegative";
end
end

function label = classify_overtake_local(gain_dccw, gain_aoig)
if gain_dccw >= 0.5 && gain_aoig >= 0.5
    label = "V6OvertakesBoth";
elseif gain_dccw >= -0.2 && gain_aoig >= -0.2
    label = "NearTieOrBoundary";
else
    label = "StrongerBaselineOvertakes";
end
end

function dataset = infer_dataset_local(scene_role)
if contains(scene_role, "HeldOut")
    dataset = "HeldOut";
else
    dataset = "Main";
end
end

function assert_files_exist_local(files)
missing = files(~isfile(files));
if ~isempty(missing)
    error('Missing required Step61 input(s): %s', strjoin(missing, ", "));
end
end

function assert_step60_coverage_local(T60_cov)
bad = T60_cov(T60_cov.RawSeeds ~= 50 | T60_cov.StageSeeds ~= 50 | T60_cov.ExpectedSeeds ~= 50, :);
if ~isempty(bad)
    disp(bad);
    error('Step61 requires complete Step60 50-seed coverage.');
end
expected_rows = 8 * 8;
if height(T60_cov) ~= expected_rows
    error('Step60 coverage row count mismatch: got %d, expected %d.', height(T60_cov), expected_rows);
end
end

function T = append_table_local(T, rows)
if isempty(T)
    T = rows;
else
    T = [T; rows]; %#ok<AGROW>
end
end
