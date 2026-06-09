clc;
clear;
close all;

% Step45: consolidate parameter credibility evidence.
% This is a reporting step only. It does not run simulations or change params.

base_dir = fileparts(mfilename('fullpath'));
cd(base_dir);

out_path = "step45_parameter_credibility_closure_report.md";

audit = readtable("step41_parameter_audit_table.csv", 'TextType', 'string');
step40_decision = readtable("step40_proposed_method_vtc_50seed_decision_table.csv", 'TextType', 'string');
thresholds = readtable("step43_threshold_calibration_5seed_threshold_table.csv", 'TextType', 'string');
threshold_validation = readtable("step44_threshold_validation_5seed_decision_table.csv", 'TextType', 'string');

step42_exists = isfile("step42_core_parameter_sensitivity_3seed_decision_table.csv") ...
    || isfile("step42_core_parameter_sensitivity_5seed_decision_table.csv");

write_closure_report_local(out_path, audit, step40_decision, thresholds, threshold_validation, step42_exists);
fprintf('Step45 complete: %s\n', out_path);

function write_closure_report_local(out_path, audit, step40_decision, thresholds, threshold_validation, step42_exists)
fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step45 report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step45 Parameter Credibility Closure Report\n\n');
fprintf(fid, 'Purpose: close the project-level credibility gap for hand-set thresholds and method parameters before paper writing.\n\n');

write_evidence_status_local(fid, step42_exists);
write_parameter_audit_local(fid, audit);
write_threshold_calibration_local(fid, thresholds);
write_threshold_validation_local(fid, threshold_validation);
write_step40_scope_local(fid, step40_decision);
write_remaining_gaps_local(fid, step42_exists, threshold_validation);
end

function write_evidence_status_local(fid, step42_exists)
fprintf(fid, '## 1. Evidence Status\n\n');
fprintf(fid, '| Evidence block | Status | Artifact |\n');
fprintf(fid, '|---|---|---|\n');
fprintf(fid, '| Formal main-result run | Closed | `step40_proposed_method_vtc_50seed_*` |\n');
fprintf(fid, '| Parameter layer audit | Closed | `step41_parameter_audit_table.csv` |\n');
if step42_exists
    fprintf(fid, '| Core parameter family sensitivity | Closed | `step42_core_parameter_sensitivity_*` |\n');
else
    fprintf(fid, '| Core parameter family sensitivity | Open | `main_step42_core_parameter_sensitivity.m` exists but formal output was not found |\n');
end
fprintf(fid, '| Threshold data calibration | Closed | `step43_threshold_calibration_5seed_*` |\n');
fprintf(fid, '| Threshold perturbation validation | Closed | `step44_threshold_validation_5seed_*` |\n\n');
end

function write_parameter_audit_local(fid, audit)
fprintf(fid, '## 2. Parameter Audit Summary\n\n');
[keys, ~, idx] = unique(audit(:, {'Priority','Layer'}), 'rows', 'stable');
counts = accumarray(idx, 1);
fprintf(fid, '| Priority | Layer | Count |\n');
fprintf(fid, '|---|---|---:|\n');
for i = 1:height(keys)
    fprintf(fid, '| %s | %s | %d |\n', keys.Priority(i), keys.Layer(i), counts(i));
end

p0 = audit(audit.Priority == "P0", :);
fprintf(fid, '\nInterpretation: the project does not need to justify all parameters equally. The immediate credibility burden is concentrated on %d P0 core-method parameters.\n\n', height(p0));
end

function write_threshold_calibration_local(fid, thresholds)
fprintf(fid, '## 3. Threshold Calibration Result\n\n');
fprintf(fid, '| Parameter | Default | Calibrated | Delta | Calibration score |\n');
fprintf(fid, '|---|---:|---:|---:|---:|\n');
for i = 1:height(thresholds)
    delta = thresholds.RecommendedValue(i) - thresholds.DefaultValue(i);
    fprintf(fid, '| `%s` | %.4f | %.4f | %.4f | %.4f |\n', ...
        thresholds.Parameter(i), thresholds.DefaultValue(i), ...
        thresholds.RecommendedValue(i), delta, thresholds.CalibrationScore(i));
end

fprintf(fid, '\nInterpretation: Step43 converts key thresholds from pure defaults into data-backed candidates. The calibrated values should not automatically replace defaults unless Step44 shows stable behavior.\n\n');
end

function write_threshold_validation_local(fid, validation)
fprintf(fid, '## 4. Threshold Validation Result\n\n');
fprintf(fid, '| Scene | Config | Timely delta calibrated-default (pp) | Emergency delta (pp) | Cost delta (%%) | Worst perturb timely (pp) | Stability |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---|\n');
for i = 1:height(validation)
    fprintf(fid, '| %s | %s | %.3f | %.3f | %.2f | %.3f | %s |\n', ...
        string(validation.Scene(i)), string(validation.Config(i)), ...
        validation.TimelyDeltaCalVsDefault_pp(i), ...
        validation.EmgDeltaCalVsDefault_pp(i), ...
        validation.CostDeltaCalVsDefault_pct(i), ...
        validation.WorstPerturbTimelyDelta_pp(i), ...
        string(validation.StabilityFlag(i)));
end

stable_count = sum(validation.StabilityFlag == "Stable");
fprintf(fid, '\nResult: %d/%d scene-config rows are marked `Stable` under calibrated thresholds and +/-10%% perturbations.\n', ...
    stable_count, height(validation));

bad = validation(validation.TimelyDeltaCalVsDefault_pp < -0.1 | validation.EmgDeltaCalVsDefault_pp < -0.1, :);
if ~isempty(bad)
    fprintf(fid, '\nCaution rows where calibrated thresholds reduce timely or emergency performance:\n\n');
    fprintf(fid, '| Scene | Config | Timely delta (pp) | Emergency delta (pp) |\n');
    fprintf(fid, '|---|---|---:|---:|\n');
    for i = 1:height(bad)
        fprintf(fid, '| %s | %s | %.3f | %.3f |\n', ...
            string(bad.Scene(i)), string(bad.Config(i)), ...
            bad.TimelyDeltaCalVsDefault_pp(i), bad.EmgDeltaCalVsDefault_pp(i));
    end
    fprintf(fid, '\nThese rows mean Step44 should be claimed as robustness evidence, not as proof that calibrated thresholds always improve performance.\n');
end
fprintf(fid, '\n');
end

function write_step40_scope_local(fid, step40_decision)
fprintf(fid, '## 5. Link to Formal Main Results\n\n');
fprintf(fid, 'Step40 provides the formal 50-seed main-result chain. Step43/44 do not replace Step40; they explain and stress-test the threshold choices used by the main method.\n\n');
fprintf(fid, '| Scene | Config | Decision |\n');
fprintf(fid, '|---|---|---|\n');

var_names = step40_decision.Properties.VariableNames;
decision_col = "";
if any(strcmp(var_names, 'Decision'))
    decision_col = "Decision";
elseif any(strcmp(var_names, 'MethodDecision'))
    decision_col = "MethodDecision";
elseif any(strcmp(var_names, 'Conclusion'))
    decision_col = "Conclusion";
end

for i = 1:height(step40_decision)
    if decision_col ~= ""
        decision = step40_decision.(decision_col)(i);
    else
        decision = "See decision table";
    end
    fprintf(fid, '| %s | %s | %s |\n', ...
        string(step40_decision.Scene(i)), string(step40_decision.Config(i)), string(decision));
end
fprintf(fid, '\n');
end

function write_remaining_gaps_local(fid, step42_exists, validation)
fprintf(fid, '## 6. Remaining Parameter-Credibility Gaps\n\n');
if ~step42_exists
    fprintf(fid, '- `Step42` is still open: run core parameter family sensitivity for timely-target, protection-target, and emergency-floor families.\n');
end

if any(validation.CostDeltaCalVsDefault_pct > 10)
    fprintf(fid, '- Calibrated thresholds can increase cost by more than 10%% in at least one row; cost-efficiency discussion is required if calibrated thresholds are used as the main setting.\n');
end

fprintf(fid, '- Step43 high-blockage labeling uses a broad rule: NLOS, PDR <= 0.70, or delay exceeding deadline. If reviewers challenge this, add a stricter alternative label and repeat Step43/44.\n');
fprintf(fid, '- Current recommendation: keep default thresholds for the main Step40 result, and use Step43/44 as evidence that conclusions are not brittle to data-backed threshold perturbations.\n\n');

fprintf(fid, '## 7. Project-Level Conclusion\n\n');
if step42_exists
    fprintf(fid, 'The parameter-credibility issue is closed at the current VTC-project level: core parameters are audited, core parameter families have sensitivity evidence, and key thresholds have both data-backed calibration and perturbation validation. Remaining issues are discussion-level caveats, not missing evidence blocks.\n');
else
    fprintf(fid, 'The threshold issue is partially closed at VTC-project level: thresholds have provenance and perturbation evidence. The remaining open item is Step42 core parameter family sensitivity.\n');
end
end
