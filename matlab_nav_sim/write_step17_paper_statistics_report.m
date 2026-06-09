function write_step17_paper_statistics_report(T_summary, T_stage_summary, T_sig, T_sig_posdeg, output_path)
%WRITE_STEP17_PAPER_STATISTICS_REPORT Write paper-level statistics summary.

fid = fopen(output_path, 'w');
if fid == -1
    error('Could not open Step17 report file: %s', output_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 17 Paper-Level Statistics Report\n\n');
fprintf(fid, 'This report consolidates the main evidence chain for the paper:\n');
fprintf(fid, '- multi-seed overall comparison,\n');
fprintf(fid, '- multi-seed key-stage comparison,\n');
fprintf(fid, '- default vs forest-geometry parameter settings,\n');
fprintf(fid, '- main comparison focus: `Confidence-driven` vs `Link-delay-aware`.\n\n');

fprintf(fid, '## Formal Scene Matrix\n\n');
fprintf(fid, '| Scene | Role | Geometry | Density | Vegetation |\n');
fprintf(fid, '|---|---|---|---|---|\n');
scene_meta = unique(T_summary(:, {'Scene','SceneRole','GeometryType','DensityClass','VegetationClass'}), 'rows', 'stable');
for i = 1:height(scene_meta)
    fprintf(fid, '| %s | %s | %s | %s | %s |\n', ...
        text_value(scene_meta.Scene, i), text_value(scene_meta.SceneRole, i), ...
        text_value(scene_meta.GeometryType, i), text_value(scene_meta.DensityClass, i), ...
        text_value(scene_meta.VegetationClass, i));
end

fprintf(fid, '## Overall Mean Summary\n\n');
fprintf(fid, '| Scene | Role | Config | Method | Timely Mean | Loss Mean | Avg Tx Cost Mean | Emergency Timely Mean |\n');
fprintf(fid, '|---|---|---|---|---:|---:|---:|---:|\n');
for i = 1:height(T_summary)
    fprintf(fid, '| %s | %s | %s | %s | %.4f | %.4f | %.4f | %.4f |\n', ...
        text_value(T_summary.Scene, i), text_value(T_summary.SceneRole, i), ...
        text_value(T_summary.Config, i), text_value(T_summary.Method, i), ...
        T_summary.TimelyRateMean(i), T_summary.LossRateMean(i), ...
        T_summary.AvgTxCostMean(i), T_summary.EmergencyTimelyRateMean(i));
end

fprintf(fid, '\n## Overall Significance: Confidence-driven vs Link-delay-aware\n\n');
fprintf(fid, '| Scene | Config | Metric | Delta Mean | Delta %% | 95%% CI | p-value | Holm(all) | Effect(RBC) | Practical |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---|---|---:|---|\n');
for i = 1:height(T_sig)
    fprintf(fid, '| %s | %s | %s | %.4f | %.4f | [%.4f, %.4f] | %s | %s | %.4f | %s |\n', ...
        text_value(T_sig.Scene, i), text_value(T_sig.Config, i), text_value(T_sig.Metric, i), ...
        T_sig.Delta_Mean(i), T_sig.DeltaPct(i), T_sig.CI_Lower(i), T_sig.CI_Upper(i), ...
        text_value(T_sig.P_Value_Display, i), text_value(T_sig.P_Value_Holm_Family_Display, i), ...
        T_sig.EffectSize_RBC(i), text_value(T_sig.PracticalNote, i));
end

T_eff = build_cost_efficiency_table(T_summary, "Link-delay-aware");
fprintf(fid, '\n## Cost-Efficiency Summary\n\n');
fprintf(fid, '| Scene | Config | Method | Timely/Cost | Emergency/Cost | Delta Timely (pp) | Delta Emergency (pp) | Delta Cost | Gain Class |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(T_eff)
    fprintf(fid, '| %s | %s | %s | %.4f | %.4f | %.3f | %.3f | %.4f | %s |\n', ...
        text_value(T_eff.Scene, i), text_value(T_eff.Config, i), text_value(T_eff.Method, i), ...
        T_eff.TimelyPerCost(i), T_eff.EmergencyTimelyPerCost(i), ...
        T_eff.DeltaTimely_pp(i), T_eff.DeltaEmergencyTimely_pp(i), ...
        T_eff.DeltaAvgTxCost(i), text_value(T_eff.CostEfficiencyClass, i));
end

fprintf(fid, '\n## PosDeg_Emerg Stage Summary\n\n');
fprintf(fid, '| Scene | Role | Config | Method | Timely Mean | Loss Mean | Avg Tx Cost Mean | Emergency Timely Mean |\n');
fprintf(fid, '|---|---|---|---|---:|---:|---:|---:|\n');
posdeg = T_stage_summary(as_string_column(T_stage_summary.Stage) == "PosDeg_Emerg", :);
for i = 1:height(posdeg)
    fprintf(fid, '| %s | %s | %s | %s | %.4f | %.4f | %.4f | %.4f |\n', ...
        text_value(posdeg.Scene, i), text_value(posdeg.SceneRole, i), ...
        text_value(posdeg.Config, i), text_value(posdeg.Method, i), ...
        posdeg.TimelyRateMean(i), posdeg.LossRateMean(i), ...
        posdeg.AvgTxCostMean(i), posdeg.EmergencyTimelyRateMean(i));
end

fprintf(fid, '\n## PosDeg_Emerg Significance: Confidence-driven vs Link-delay-aware\n\n');
fprintf(fid, '| Scene | Config | Metric | Delta Mean | Delta %% | 95%% CI | p-value | Holm(all) | Effect(RBC) | Practical |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---|---|---:|---|\n');
for i = 1:height(T_sig_posdeg)
    fprintf(fid, '| %s | %s | %s | %.4f | %.4f | [%.4f, %.4f] | %s | %s | %.4f | %s |\n', ...
        text_value(T_sig_posdeg.Scene, i), text_value(T_sig_posdeg.Config, i), ...
        text_value(T_sig_posdeg.Metric, i), ...
        T_sig_posdeg.Delta_Mean(i), T_sig_posdeg.DeltaPct(i), T_sig_posdeg.CI_Lower(i), T_sig_posdeg.CI_Upper(i), ...
        text_value(T_sig_posdeg.P_Value_Display, i), text_value(T_sig_posdeg.P_Value_Holm_Family_Display, i), ...
        T_sig_posdeg.EffectSize_RBC(i), text_value(T_sig_posdeg.PracticalNote, i));
end

fprintf(fid, '\n## Recommended Narrative\n\n');
fprintf(fid, '- The overall gain should be described as a stable but moderate improvement under repeated random realizations.\n');
fprintf(fid, '- The PosDeg\\_Emerg results should be emphasized as the main source of method value, especially under forest-geometry calibration.\n');
fprintf(fid, '- The forest-geometry setting should be presented as the more application-relevant evidence for the paper topic.\n');
fprintf(fid, '- Results marked `Below1pp` or `Sub-ms` should be interpreted cautiously even when uncorrected p-values are small.\n');

fprintf(fid, '\n## Method Applicability Analysis\n\n');
fprintf(fid, 'The confidence-driven scheduler is not expected to improve every scene uniformly. ');
fprintf(fid, 'Its intended activation regime is the overlap between blind-zone risk and positioning-confidence degradation, especially in the `PosDeg_Emerg` stage.\n\n');
fprintf(fid, 'A scene should therefore be interpreted as method-applicable only when two conditions co-occur:\n');
fprintf(fid, '- low positioning confidence (`q_{pos}` falls into the low-confidence regime);\n');
fprintf(fid, '- blind-zone risk exceeds the protection trigger and overlaps the emergency time window.\n\n');
fprintf(fid, 'The boundary scene `10011` should be interpreted as positive evidence of graceful degradation rather than as a failure case. ');
fprintf(fid, 'In the open/low/sparse setting, the confidence-driven scheduler does not improve timely performance because the critical trigger overlap is absent; however, it also does not degrade timely performance relative to the link-aware baseline. ');
fprintf(fid, 'This indicates that the proposed scheduler collapses to the baseline behavior under easy conditions, while its gain is concentrated in the risk-dominant scenes such as `10014 / ForestGeometry`.\n');
end

function value = text_value(column, idx)
if iscell(column)
    value = char(string(column{idx}));
else
    value = char(string(column(idx)));
end
end

function values = as_string_column(column)
if iscell(column)
    values = string(column);
else
    values = string(column);
end
end
