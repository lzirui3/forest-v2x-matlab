clc;
clear;
close all;

% Step62: final VTC revised result pack.
% Integrates Step58-61 into paper-facing tables and figures while preserving
% explicit claim boundaries.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

prefix = "step62_vtc_revised";

required_files = [
    "step58_paper_ready_main_performance_table.csv"
    "step58_paper_ready_sota_baseline_table.csv"
    "step58_paper_ready_cost_efficiency_table.csv"
    "step58_paper_ready_negative_boundary_table.csv"
    "step59_stronger_literature_baselines_50seed_decision_table.csv"
    "step59_stronger_literature_baselines_50seed_summary.csv"
    "step60_moderate_forest_geometry_50seed_decision_table.csv"
    "step60_moderate_forest_geometry_50seed_summary.csv"
    "step61_applicability_boundary_update_applicability_table.csv"
    "step61_applicability_boundary_update_failure_boundary_table.csv"
    "step61_applicability_boundary_update_dcc_overtake_analysis_table.csv"
    "step61_applicability_boundary_update_small_gain_table.csv"
    ];
assert_files_exist_local(required_files);

T58_perf = readtable("step58_paper_ready_main_performance_table.csv", 'TextType', 'string');
T58_sota = readtable("step58_paper_ready_sota_baseline_table.csv", 'TextType', 'string');
T58_cost = readtable("step58_paper_ready_cost_efficiency_table.csv", 'TextType', 'string');
T58_neg = readtable("step58_paper_ready_negative_boundary_table.csv", 'TextType', 'string');
T59_dec = readtable("step59_stronger_literature_baselines_50seed_decision_table.csv", 'TextType', 'string');
T59_sum = readtable("step59_stronger_literature_baselines_50seed_summary.csv", 'TextType', 'string');
T60_dec = readtable("step60_moderate_forest_geometry_50seed_decision_table.csv", 'TextType', 'string');
T60_sum = readtable("step60_moderate_forest_geometry_50seed_summary.csv", 'TextType', 'string');
T61_app = readtable("step61_applicability_boundary_update_applicability_table.csv", 'TextType', 'string');
T61_fail = readtable("step61_applicability_boundary_update_failure_boundary_table.csv", 'TextType', 'string');
T61_dcc = readtable("step61_applicability_boundary_update_dcc_overtake_analysis_table.csv", 'TextType', 'string');
T61_small = readtable("step61_applicability_boundary_update_small_gain_table.csv", 'TextType', 'string');

main_performance = build_main_performance_table_local(T58_perf);
stronger_baseline = build_stronger_baseline_table_local(T58_sota, T59_dec);
moderate_forest = build_moderate_forest_table_local(T60_sum, T60_dec);
applicability = T61_app;
negative_boundary = build_negative_boundary_table_local(T58_neg, T61_fail);
cost_efficiency = build_cost_efficiency_table_local(T58_cost, T59_dec, T60_dec);
claim_boundary = build_claim_boundary_table_local(T61_app, T61_fail, T61_dcc, T61_small);

writetable(main_performance, prefix + "_main_performance_table.csv");
writetable(stronger_baseline, prefix + "_stronger_baseline_table.csv");
writetable(moderate_forest, prefix + "_moderate_forest_table.csv");
writetable(applicability, prefix + "_applicability_table.csv");
writetable(negative_boundary, prefix + "_negative_boundary_table.csv");
writetable(cost_efficiency, prefix + "_cost_efficiency_table.csv");
writetable(claim_boundary, prefix + "_paper_claim_boundary_table.csv");

fig_path = prefix + "_cost_efficiency_pareto.png";
plot_step62_cost_efficiency_local(cost_efficiency, fig_path);

write_step62_vtc_revised_report_cn(main_performance, stronger_baseline, ...
    moderate_forest, applicability, negative_boundary, cost_efficiency, ...
    claim_boundary, fig_path, prefix + "_result_pack_report_cn.md");

disp(claim_boundary);
fprintf('Step62 complete: final VTC revised result pack generated.\n');

function T = build_main_performance_table_local(T58_perf)
keep_methods = ["Risk-constrained-v6", "Confidence-heuristic", "Link-delay-aware", ...
    "DCC-like", "AoI-aware", "Constrained Oracle"];
T = T58_perf(ismember(T58_perf.Method, keep_methods), :);
T.ResultScope = repmat("Default+ForestGeometry-PERLookup", height(T), 1);
T = movevars(T, 'ResultScope', 'Before', 'Scene');
end

function T = build_stronger_baseline_table_local(T58_sota, T59_dec)
T = T59_dec(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config', ...
    'TimelyGainVsDCCWindow_pp','EmgGainVsDCCWindow_pp','CostDeltaVsDCCWindow_pct', ...
    'TimelyGainVsAoIGreedy_pp','EmgGainVsAoIGreedy_pp','CostDeltaVsAoIGreedy_pct', ...
    'TimelyGainVsDCCLike_pp','TimelyGainVsAoIAware_pp','TimelyGainVsHeuristic_pp', ...
    'TimelyGainVsLink_pp','StrongerBaselineDecision'});
T.BaselineClaimScope = repmat("Inspired baselines only; not full ETSI DCC or AoI-optimal implementation.", height(T), 1);
T = movevars(T, 'BaselineClaimScope', 'After', 'Config');

legacy = T58_sota(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass','Config', ...
    'TimelyGainVsDCC_pp','EmgGainVsDCC_pp','CostDeltaVsDCC_pct', ...
    'TimelyGainVsAoI_pp','EmgGainVsAoI_pp','CostDeltaVsAoI_pct', ...
    'TimelyGainVsHeuristic_pp','TimelyGainVsLink_pp','LiteratureBaselineDecision'});
legacy.BaselineClaimScope = repmat("Earlier DCC-like/AoI-aware inspired baselines.", height(legacy), 1);
legacy = movevars(legacy, 'BaselineClaimScope', 'After', 'Config');
legacy.TimelyGainVsDCCWindow_pp = legacy.TimelyGainVsDCC_pp;
legacy.EmgGainVsDCCWindow_pp = legacy.EmgGainVsDCC_pp;
legacy.CostDeltaVsDCCWindow_pct = legacy.CostDeltaVsDCC_pct;
legacy.TimelyGainVsAoIGreedy_pp = legacy.TimelyGainVsAoI_pp;
legacy.EmgGainVsAoIGreedy_pp = legacy.EmgGainVsAoI_pp;
legacy.CostDeltaVsAoIGreedy_pct = legacy.CostDeltaVsAoI_pct;
legacy.TimelyGainVsDCCLike_pp = legacy.TimelyGainVsDCC_pp;
legacy.TimelyGainVsAoIAware_pp = legacy.TimelyGainVsAoI_pp;
legacy.StrongerBaselineDecision = legacy.LiteratureBaselineDecision;
legacy = legacy(:, T.Properties.VariableNames);
T = [T; legacy];
end

function T = build_moderate_forest_table_local(T60_sum, T60_dec)
T = T60_sum;
T.ForestScenarioRole = repmat("Deployable moderate degradation; complements but does not replace ForestGeometry stress test.", height(T), 1);
T = movevars(T, 'ForestScenarioRole', 'After', 'Config');

decision_cols = T60_dec(:, {'Scene','Config','ModerateForestDecision', ...
    'TimelyGainVsHeuristic_pp','TimelyGainVsDCCWindow_pp','TimelyGainVsAoIGreedy_pp'});
T = outerjoin(T, decision_cols, 'Keys', {'Scene','Config'}, 'MergeKeys', true, 'Type', 'left');
end

function T = build_negative_boundary_table_local(T58_neg, T61_fail)
T = T61_fail;
T.OriginalStep58Boundary = ismember(T.Scene + "_" + T.Config, T58_neg.Scene + "_" + T58_neg.Config);
T.PaperHandling = repmat("Retain as limitation/applicability boundary; do not tune away.", height(T), 1);
end

function T = build_cost_efficiency_table_local(T58_cost, T59_dec, T60_dec)
T = T58_cost;
T.EvidenceSource = repmat("Step58", height(T), 1);
T = movevars(T, 'EvidenceSource', 'Before', 'Scene');

rows = [];
for i = 1:height(T59_dec)
    rows = append_cost_row_local(rows, T59_dec(i, :), "Step59", "DCC-CBR-window", ...
        T59_dec.TimelyGainVsDCCWindow_pp(i), T59_dec.EmgGainVsDCCWindow_pp(i), T59_dec.CostDeltaVsDCCWindow_pct(i));
    rows = append_cost_row_local(rows, T59_dec(i, :), "Step59", "AoI-greedy", ...
        T59_dec.TimelyGainVsAoIGreedy_pp(i), T59_dec.EmgGainVsAoIGreedy_pp(i), T59_dec.CostDeltaVsAoIGreedy_pct(i));
end
for i = 1:height(T60_dec)
    rows = append_cost_row_local(rows, T60_dec(i, :), "Step60", "DCC-CBR-window", ...
        T60_dec.TimelyGainVsDCCWindow_pp(i), NaN, NaN);
    rows = append_cost_row_local(rows, T60_dec(i, :), "Step60", "AoI-greedy", ...
        T60_dec.TimelyGainVsAoIGreedy_pp(i), NaN, NaN);
end
if ~isempty(rows)
    T = [T; rows(:, T.Properties.VariableNames)];
end
end

function rows = append_cost_row_local(rows, source_row, source_name, baseline, timely_gain, emg_gain, cost_delta)
row = table;
row.EvidenceSource = string(source_name);
row.Scene = source_row.Scene;
row.SceneRole = source_row.SceneRole;
row.GeometryType = source_row.GeometryType;
row.DensityClass = source_row.DensityClass;
row.VegetationClass = source_row.VegetationClass;
row.Config = source_row.Config;
row.BaselineMethod = string(baseline);
row.ProposedMethod = "Risk-constrained-v6";
row.DeltaTimely_pp = timely_gain;
row.DeltaEmergency_pp = emg_gain;
row.DeltaLoss_pp = NaN;
row.DeltaDelay_pct = NaN;
row.DeltaCost_pct = cost_delta;
row.DeltaCost_abs = NaN;
if isnan(cost_delta) || cost_delta <= 0
    row.TimelyGainPerCostPct = NaN;
    row.EmergencyGainPerCostPct = NaN;
else
    row.TimelyGainPerCostPct = timely_gain / cost_delta;
    row.EmergencyGainPerCostPct = emg_gain / cost_delta;
end
row.CostEfficiencyClass = classify_cost_efficiency_local(timely_gain, cost_delta);
rows = append_table_local(rows, row);
end

function T = build_claim_boundary_table_local(T61_app, T61_fail, T61_dcc, T61_small)
claim = [
    "Main method is a frozen-parameter finite-action online scheduler."
    "DCC/AoI baselines are inspired baselines, not full standards or optimal policies."
    "ForestGeometry is an extreme stress/boundary scenario."
    "ModerateForestGeometry is deployable moderate degradation evidence."
    "Lyapunov is not the main theoretical proof."
    "Constrained Oracle is a bounded-action diagnostic reference, not a global oracle."
    "Negative ForestGeometry cases are retained as applicability boundaries."
    ];
status = [
    "SupportedByCodeAndStep58To60"
    "MustBeStatedAsClaimLimit"
    "SupportedByStep58NegativeBoundary"
    "SupportedByStep60"
    "MustBeStatedAsClaimLimit"
    "MustBeStatedAsClaimLimit"
    "SupportedByStep61FailureBoundary"
    ];
evidence = [
    "run_step9_proposed_method -> Risk-constrained-v6; no retuning in Step59-62."
    "Step59/61 labels DCC-CBR-window and AoI-greedy as literature-inspired."
    sprintf("%d Step61 boundary rows.", height(T61_fail))
    "step60_moderate_forest_geometry_50seed_* outputs."
    "Use risk-constrained utility/finite-action online scheduling as main method; Lyapunov only optional discussion."
    "run_step9_baseline_oracle enumerates the same constrained action space."
    sprintf("%d small-gain/boundary interpretation rows.", height(T61_small))
    ];
T = table(claim, status, evidence, 'VariableNames', {'PaperClaim','ClaimStatus','Evidence'});
T.ApplicabilityClassCount = repmat(strjoin(unique(T61_app.ApplicabilityClass), "; "), height(T), 1);
T.StrongerBaselineBoundaryCount = repmat(sum(contains(T61_dcc.OvertakeClass, "Boundary") ...
    | contains(T61_dcc.OvertakeClass, "Overtakes")), height(T), 1);
end

function plot_step62_cost_efficiency_local(T, fig_path)
fig = figure('Color', 'w', 'Position', [100, 100, 980, 620]);
hold on;
grid on;
box off;
is_v6 = T.ProposedMethod == "Risk-constrained-v6";
T = T(is_v6, :);
classes = unique(T.EvidenceSource, 'stable');
colors = lines(max(numel(classes), 3));
for i = 1:numel(classes)
    subT = T(T.EvidenceSource == classes(i), :);
    scatter(subT.DeltaCost_pct, subT.DeltaTimely_pp, 58, colors(i, :), ...
        'filled', 'MarkerFaceAlpha', 0.72, 'DisplayName', classes(i));
end
xline(0, 'k--', 'LineWidth', 1.0);
yline(0, 'k--', 'LineWidth', 1.0);
xlabel('Cost delta vs baseline (%)');
ylabel('Timely-rate gain (percentage points)');
title('Step62 Cost-Efficiency Boundary of Risk-constrained-v6');
legend('Location', 'best');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 12, 'LineWidth', 1.0);
exportgraphics(fig, fig_path, 'Resolution', 300);
close(fig);
end

function label = classify_cost_efficiency_local(timely_gain, cost_delta)
if isnan(cost_delta)
    if timely_gain >= 0.5
        label = "GainCostNotAvailable";
    elseif timely_gain >= -0.2
        label = "BoundaryCostNotAvailable";
    else
        label = "NegativeCostNotAvailable";
    end
elseif timely_gain >= 0 && cost_delta <= 0
    label = "DominantOrCostSaving";
elseif timely_gain >= 1 && cost_delta <= 15
    label = "CostlyButMeaningful";
elseif timely_gain >= 0
    label = "WeakGainWithCost";
else
    label = "CostInefficientBoundary";
end
end

function assert_files_exist_local(files)
missing = files(~isfile(files));
if ~isempty(missing)
    error('Missing required Step62 input(s): %s', strjoin(missing, ", "));
end
end

function T = append_table_local(T, rows)
if isempty(T)
    T = rows;
else
    T = [T; rows]; %#ok<AGROW>
end
end
