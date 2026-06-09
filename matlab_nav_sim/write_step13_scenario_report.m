function write_step13_scenario_report(T_summary, output_path, profiles)
%WRITE_STEP13_SCENARIO_REPORT Write a markdown summary for Step 13.

fid = fopen(output_path, 'w');
if fid == -1
    error('Could not open Step 13 scenario report file: %s', output_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 13 Scenario Expansion Report\n\n');
fprintf(fid, '## Scope\n\n');
fprintf(fid, '- GNSS degradation levels: %s\n', strjoin(cellstr(profiles.gnss_levels), ', '));
fprintf(fid, '- RSU sparsity levels: %s\n', strjoin(cellstr(profiles.rsu_levels), ', '));
fprintf(fid, '- Message load levels: %s\n', strjoin(cellstr(profiles.load_levels), ', '));
fprintf(fid, '- Seeds per scenario: %d\n\n', profiles.num_seeds);

fprintf(fid, '## Scenario Summary Table\n\n');
fprintf(fid, '| Scenario | GNSS | RSU | Load | Full Emergency Timely | Link-Aware Emergency Timely | Gain | Full Effective Warning | Link-Aware Effective Warning | Effective Gain |\n');
fprintf(fid, '|---|---|---|---|---:|---:|---:|---:|---:|---:|\n');

scenario_ids = unique(T_summary.ScenarioID, 'stable');
for i = 1:numel(scenario_ids)
    subT = T_summary(T_summary.ScenarioID == scenario_ids(i), :);
    full_row = subT(subT.Method == "Full", :);
    link_row = subT(subT.Method == "Link-aware", :);
    gain = full_row.EmergencyTimelyRateMean - link_row.EmergencyTimelyRateMean;
    effective_gain = full_row.EffectiveWarningRateMean - link_row.EffectiveWarningRateMean;

    fprintf(fid, '| %s | %s | %s | %s | %.3f | %.3f | %.3f | %.3f | %.3f | %.3f |\n', ...
        scenario_ids(i), full_row.GNSSLevel(1), full_row.RSULevel(1), full_row.LoadLevel(1), ...
        full_row.EmergencyTimelyRateMean(1), link_row.EmergencyTimelyRateMean(1), gain, ...
        full_row.EffectiveWarningRateMean(1), link_row.EffectiveWarningRateMean(1), effective_gain);
end

fprintf(fid, '\nNote: `Effective Warning` is defined only on `PosDeg_Emerg` emergency samples with `q_{pos} >= 0.50`. ');
fprintf(fid, 'If scenario coverage collapses to zero, the rate is reported as `NaN` because no valid high-confidence warning samples remain.\n');

[best_gain, idx_best] = get_best_gain(T_summary, 'EmergencyTimelyRateMean');
[best_posdeg_gain, idx_best_posdeg] = get_best_gain(T_summary, 'PosDegEmergencyTimelyRateMean');
[best_effective_gain, idx_best_effective] = get_best_gain(T_summary, 'EffectiveWarningRateMean');

fprintf(fid, '\n## Key Observation\n\n');
fprintf(fid, '- Largest overall emergency-timely gain: **%.3f** in scenario `%s`.\n', best_gain.value, best_gain.scenario_id);
fprintf(fid, '- Largest `PosDeg_Emerg` emergency-timely gain: **%.3f** in scenario `%s`.\n', best_posdeg_gain.value, best_posdeg_gain.scenario_id);
fprintf(fid, '- Largest effective-warning gain under `q_{pos}` constraint: **%.3f** in scenario `%s`.\n', best_effective_gain.value, best_effective_gain.scenario_id);
fprintf(fid, '- Best overall-gain scenario condition: GNSS=`%s`, RSU=`%s`, Load=`%s`.\n', ...
    idx_best.GNSSLevel(1), idx_best.RSULevel(1), idx_best.LoadLevel(1));
fprintf(fid, '- Best critical-stage-gain scenario condition: GNSS=`%s`, RSU=`%s`, Load=`%s`.\n', ...
    idx_best_posdeg.GNSSLevel(1), idx_best_posdeg.RSULevel(1), idx_best_posdeg.LoadLevel(1));
fprintf(fid, '- Best effective-warning-gain scenario condition: GNSS=`%s`, RSU=`%s`, Load=`%s`.\n', ...
    idx_best_effective.GNSSLevel(1), idx_best_effective.RSULevel(1), idx_best_effective.LoadLevel(1));
fprintf(fid, '- This report is intended to show whether the proposed method remains beneficial under varying localization degradation, sparse V2I support, and communication load conditions.\n');
end

function [gain_info, row_best] = get_best_gain(T_summary, metric_name)
scenario_ids = unique(T_summary.ScenarioID, 'stable');
best_val = -inf;
row_best = T_summary(1, :);
best_scenario = "";

for i = 1:numel(scenario_ids)
    subT = T_summary(T_summary.ScenarioID == scenario_ids(i), :);
    full_row = subT(subT.Method == "Full", :);
    link_row = subT(subT.Method == "Link-aware", :);
    gain = full_row.(metric_name)(1) - link_row.(metric_name)(1);
    if gain > best_val
        best_val = gain;
        row_best = full_row;
        best_scenario = scenario_ids(i);
    end
end

gain_info.value = best_val;
gain_info.scenario_id = best_scenario;
end
