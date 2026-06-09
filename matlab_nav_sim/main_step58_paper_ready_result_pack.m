clc;
clear;
close all;

% Step58: paper-ready result pack.
% This script only aggregates the final PER-lookup evidence chain. It does
% not rerun simulations, retune Risk-constrained-v6, or overwrite earlier
% Step40/45/46/49/50/51/52/53 artifacts.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

prefix = "step58_paper_ready";

inputs.step54_summary = "step54_literature_baselines_per_lookup_50seed_summary.csv";
inputs.step54_decision = "step54_literature_baselines_per_lookup_50seed_decision_table.csv";
inputs.step54_coverage = "step54_literature_baselines_per_lookup_50seed_coverage.csv";
inputs.step55_core = "step55_final_statistical_evidence_core_results.csv";
inputs.step55_sig = "step55_final_statistical_evidence_all_comparisons_significance.csv";
inputs.step55_interp = "step55_final_statistical_evidence_interpretation_table.csv";
inputs.step56_eff = "step56_cost_efficiency_pareto_efficiency_table.csv";
inputs.step56_pareto = "step56_cost_efficiency_pareto_pareto_membership.csv";
inputs.step56_pareto_png = "step56_cost_efficiency_pareto_overall_pareto.png";
inputs.step56_delta_png = "step56_cost_efficiency_pareto_delta_tradeoff.png";
inputs.step57_resources = "step57_parameter_credibility_closure_resources.csv";
inputs.step57_categories = "step57_parameter_credibility_closure_parameter_categories.csv";
inputs.step57_values = "step57_parameter_credibility_closure_key_parameter_values.csv";
inputs.step57_claims = "step57_parameter_credibility_closure_claim_boundaries.csv";
inputs.step51_app = "step51_per_lookup_applicability_evidence_table.csv";
inputs.step52_failure = "step52_10019_forestgeometry_failure_summary.csv";
inputs.step52_overall = "step52_10019_forestgeometry_overall_delta.csv";

validate_required_files_local(inputs);

T54_summary = normalize_table_local(readtable(inputs.step54_summary, 'TextType', 'string'));
T54_decision = normalize_table_local(readtable(inputs.step54_decision, 'TextType', 'string'));
T54_coverage = normalize_table_local(readtable(inputs.step54_coverage, 'TextType', 'string'));
T55_core = normalize_table_local(readtable(inputs.step55_core, 'TextType', 'string'));
T55_sig = normalize_table_local(readtable(inputs.step55_sig, 'TextType', 'string'));
T55_interp = normalize_table_local(readtable(inputs.step55_interp, 'TextType', 'string'));
T56_eff = normalize_table_local(readtable(inputs.step56_eff, 'TextType', 'string'));
T56_pareto = normalize_table_local(readtable(inputs.step56_pareto, 'TextType', 'string'));
T57_resources = normalize_table_local(readtable(inputs.step57_resources, 'TextType', 'string'));
T57_categories = normalize_table_local(readtable(inputs.step57_categories, 'TextType', 'string'));
T57_values = normalize_table_local(read_string_table_local(inputs.step57_values));
T57_claims = normalize_table_local(readtable(inputs.step57_claims, 'TextType', 'string'));
T51_app = normalize_table_local(readtable(inputs.step51_app, 'TextType', 'string'));
T52_failure = normalize_table_local(readtable(inputs.step52_failure, 'TextType', 'string'));
T52_overall = normalize_table_local(readtable(inputs.step52_overall, 'TextType', 'string'));

audit = build_completion_audit_local(T54_coverage, T55_core, T55_sig, T55_interp, ...
    T56_eff, T56_pareto, T57_values);

T_main = build_main_performance_table_local(T55_core);
T_sota = build_sota_baseline_table_local(T54_decision);
T_stat = build_statistical_table_local(T55_interp);
T_cost = build_cost_efficiency_table_local(T56_eff);
T_app = build_applicability_table_local(T51_app);
T_negative = build_negative_boundary_table_local(T56_eff, T55_interp, T52_failure);
T_param = build_parameter_credibility_table_local(T57_categories, T57_values, T57_claims);

writetable(T_main, prefix + "_main_performance_table.csv");
writetable(T_sota, prefix + "_sota_baseline_table.csv");
writetable(T_stat, prefix + "_statistical_table.csv");
writetable(T_cost, prefix + "_cost_efficiency_table.csv");
writetable(T_app, prefix + "_applicability_table.csv");
writetable(T_negative, prefix + "_negative_boundary_table.csv");
writetable(T_param, prefix + "_parameter_credibility_table.csv");
writetable(audit, prefix + "_completion_audit.csv");

copyfile(inputs.step56_pareto_png, prefix + "_overall_pareto.png");
copyfile(inputs.step56_delta_png, prefix + "_delta_tradeoff.png");

write_step58_paper_ready_result_pack_cn(T_main, T_sota, T_stat, T_cost, ...
    T_app, T_negative, T_param, T54_coverage, T56_pareto, T57_resources, ...
    T57_values, T52_overall, audit, prefix + "_overall_pareto.png", ...
    prefix + "_delta_tradeoff.png", prefix + "_result_pack_report_cn.md");

disp(audit);
fprintf('Step58 complete: paper-ready result pack generated with prefix %s.\n', prefix);

function validate_required_files_local(inputs)
fields = fieldnames(inputs);
for i = 1:numel(fields)
    path = inputs.(fields{i});
    if ~isfile(path)
        error('Missing Step58 input: %s', path);
    end
end
end

function audit = build_completion_audit_local(T54_coverage, T55_core, T55_sig, ...
    T55_interp, T56_eff, T56_pareto, T57_values)
rows = [];
rows = add_audit_row_local(rows, "Step54 coverage rows", height(T54_coverage), 96, ...
    height(T54_coverage) == 96);
bad_cov = nnz(T54_coverage.RawSeeds ~= T54_coverage.ExpectedSeeds | ...
    T54_coverage.StageSeeds ~= T54_coverage.ExpectedSeeds);
rows = add_audit_row_local(rows, "Step54 bad coverage rows", bad_cov, 0, bad_cov == 0);
rows = add_audit_row_local(rows, "Step55 core rows", height(T55_core), 96, ...
    height(T55_core) == 96);
rows = add_audit_row_local(rows, "Step55 significance rows", height(T55_sig), 400, ...
    height(T55_sig) == 400);
rows = add_audit_row_local(rows, "Step55 interpretation rows", height(T55_interp), 80, ...
    height(T55_interp) == 80);
rows = add_audit_row_local(rows, "Step56 cost-efficiency rows", height(T56_eff), 64, ...
    height(T56_eff) == 64);
rows = add_audit_row_local(rows, "Step56 Pareto rows", height(T56_pareto), 96, ...
    height(T56_pareto) == 96);

    mode_row = T57_values(T57_values.Parameter == "final_physical_pdr_mode", :);
    has_per_lookup = ~isempty(mode_row) && all(contains(mode_row.DefaultValue, "per_lookup")) ...
        && all(contains(mode_row.ForestGeometryValue, "per_lookup"));
rows = add_audit_row_local(rows, "Step57 final physical mode", double(has_per_lookup), 1, ...
    has_per_lookup);

required_params = ["objective_timely_lambda","objective_success_lambda", ...
    "risk_v4_actual_cost_weight","risk_v6_emergency_floor"];
has_params = all(ismember(required_params, T57_values.Parameter));
rows = add_audit_row_local(rows, "Step57 V6 parameter rows", double(has_params), 1, has_params);
audit = rows;
end

function rows = add_audit_row_local(rows, item, observed, expected, pass)
row = table(string(item), observed, expected, string(pass), ...
    'VariableNames', {'Item','Observed','Expected','Pass'});
rows = append_table_local(rows, row);
end

function T = build_main_performance_table_local(T55_core)
T = T55_core(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','Method','TimelyRateMean','TimelyRateCI95', ...
    'EmergencyTimelyRateMean','EmergencyTimelyRateCI95','LossRateMean','LossRateCI95', ...
    'AvgDelayMean','AvgDelayCI95','AvgTxCostMean','AvgTxCostCI95'});
T.TimelyRate_pct = 100.0 * T.TimelyRateMean;
T.TimelyRateCI95_pp = 100.0 * T.TimelyRateCI95;
T.EmergencyTimelyRate_pct = 100.0 * T.EmergencyTimelyRateMean;
T.EmergencyTimelyRateCI95_pp = 100.0 * T.EmergencyTimelyRateCI95;
T.LossRate_pct = 100.0 * T.LossRateMean;
T.LossRateCI95_pp = 100.0 * T.LossRateCI95;
end

function T = build_sota_baseline_table_local(T54_decision)
T = T54_decision(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','TimelyGainVsDCC_pp','EmgGainVsDCC_pp','CostDeltaVsDCC_pct', ...
    'TimelyGainVsAoI_pp','EmgGainVsAoI_pp','CostDeltaVsAoI_pct', ...
    'TimelyGainVsHeuristic_pp','TimelyGainVsLink_pp','LiteratureBaselineDecision'});
end

function T = build_statistical_table_local(T55_interp)
T = T55_interp(:, {'Scene','SceneRole','GeometryType','Config','BaselineMethod', ...
    'ProposedMethod','TimelyDelta_pp','TimelyHolmP','TimelyEffectRBC', ...
    'EmgDelta_pp','CostDelta_pct','PracticalClass'});
end

function T = build_cost_efficiency_table_local(T56_eff)
T = T56_eff(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','BaselineMethod','ProposedMethod','DeltaTimely_pp','DeltaEmergency_pp', ...
    'DeltaLoss_pp','DeltaDelay_pct','DeltaCost_pct','DeltaCost_abs', ...
    'TimelyGainPerCostPct','EmergencyGainPerCostPct','CostEfficiencyClass'});
end

function T = build_applicability_table_local(T51_app)
T = T51_app(:, {'Dataset','Scene','SceneRole','GeometryType','DensityClass', ...
    'VegetationClass','Config','Decision','RiskClass','GainClass','ApplicabilityClass', ...
    'TimelyGainVsHeuristic_pp','EmgGainVsHeuristic_pp','TimelyGainVsLink_pp', ...
    'CostDeltaVsHeuristic_pct','OracleMinusV6Timely_pp','NlosPct','EmergencyPct', ...
    'ApplicabilityNote'});
end

function T = build_negative_boundary_table_local(T56_eff, T55_interp, T52_failure)
heuristic_rows = T56_eff(T56_eff.BaselineMethod == "Confidence-heuristic", :);
neg_eff = heuristic_rows(heuristic_rows.DeltaTimely_pp < 0 | ...
    heuristic_rows.DeltaEmergency_pp < 0 | ...
    heuristic_rows.CostEfficiencyClass == "CostInefficientBoundary" | ...
    heuristic_rows.CostEfficiencyClass == "MixedBoundary", :);
if isempty(neg_eff)
    T = table();
    return;
end

T = neg_eff(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','BaselineMethod','DeltaTimely_pp','DeltaEmergency_pp', ...
    'DeltaLoss_pp','DeltaDelay_pct','DeltaCost_pct','CostEfficiencyClass'});
T.BoundaryEvidence = repmat("Step56 negative/boundary cost-efficiency case", height(T), 1);
for i = 1:height(T)
    interp_row = T55_interp(T55_interp.Scene == T.Scene(i) & ...
        T55_interp.Config == T.Config(i) & ...
        T55_interp.BaselineMethod == T.BaselineMethod(i), :);
    if ~isempty(interp_row)
        T.BoundaryEvidence(i) = "Step55 class: " + interp_row.PracticalClass(1);
    end
end
if ~isempty(T52_failure)
    for i = 1:height(T)
        failure_row = T52_failure(T52_failure.Scene == T.Scene(i) & ...
            T52_failure.Config == T.Config(i), :);
        if ~isempty(failure_row)
            T.BoundaryEvidence(i) = failure_row.FailureMode(1) + ": " + failure_row.Evidence(1);
        end
    end
end
end

function T = build_parameter_credibility_table_local(T57_categories, T57_values, T57_claims)
rows = [];
for i = 1:height(T57_categories)
    row = table("Category", T57_categories.Category(i), T57_categories.SourceType(i), ...
        T57_categories.EvidenceStrength(i), "", "", ...
        T57_categories.PaperClaimAllowed(i), T57_categories.PaperClaimForbidden(i), ...
        'VariableNames', {'RecordType','Item','SourceOrDefault','EvidenceStrength', ...
        'ForestGeometryValue','SourceNote','AllowedWording','ForbiddenWording'});
    rows = append_table_local(rows, row);
end
for i = 1:height(T57_values)
    row = table("KeyParameter", T57_values.Parameter(i), T57_values.DefaultValue(i), ...
        "", T57_values.ForestGeometryValue(i), T57_values.SourceNote(i), "", "", ...
        'VariableNames', {'RecordType','Item','SourceOrDefault','EvidenceStrength', ...
        'ForestGeometryValue','SourceNote','AllowedWording','ForbiddenWording'});
    rows = append_table_local(rows, row);
end
for i = 1:height(T57_claims)
    row = table("ClaimBoundary", T57_claims.Claim(i), "", "", "", "", ...
        T57_claims.AllowedWording(i), T57_claims.ForbiddenWording(i), ...
        'VariableNames', {'RecordType','Item','SourceOrDefault','EvidenceStrength', ...
        'ForestGeometryValue','SourceNote','AllowedWording','ForbiddenWording'});
    rows = append_table_local(rows, row);
end
T = rows;
end

function T = normalize_table_local(T)
string_names = {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass', ...
    'Config','Method','BaselineMethod','ProposedMethod','LiteratureBaselineDecision', ...
    'CostEfficiencyClass','PracticalClass','Dataset','Decision','RiskClass','GainClass', ...
    'ApplicabilityClass','ApplicabilityNote','Parameter','DefaultValue', ...
    'ForestGeometryValue','SourceNote','Category','SourceType','EvidenceStrength', ...
    'PaperClaimAllowed','PaperClaimForbidden','Claim','AllowedWording', ...
    'ForbiddenWording','FailureMode','Evidence','Metric','Unit'};
for i = 1:numel(string_names)
    name = string_names{i};
    if ismember(name, T.Properties.VariableNames)
        T.(name) = string(T.(name));
    end
end
end

function T = read_string_table_local(path)
opts = detectImportOptions(path, 'TextType', 'string');
opts = setvartype(opts, opts.VariableNames, 'string');
T = readtable(path, opts);
end

function T = append_table_local(T, rows)
if isempty(T)
    T = rows;
else
    T = [T; rows]; %#ok<AGROW>
end
end
