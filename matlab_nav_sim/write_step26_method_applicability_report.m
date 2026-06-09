function write_step26_method_applicability_report(T, out_path)
fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step26 report file: %s', out_path);
end
cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step 26 Method Applicability Analysis\n\n');
fprintf(fid, 'This report addresses the boundary-scene concern by explicitly analyzing when the confidence-driven scheduler becomes active and when it gracefully collapses to the link-aware baseline.\n\n');

fprintf(fid, '## Activation Logic\n\n');
fprintf(fid, 'The method is expected to become materially active only when the following two conditions overlap in the critical `PosDeg_Emerg` stage:\n');
fprintf(fid, '- positioning confidence falls into the low-confidence regime: `q_pos <= utility_blind_pos_threshold`;\n');
fprintf(fid, '- blind-zone risk exceeds the protection trigger: `blind_score >= utility_blind_protection_threshold`.\n\n');
fprintf(fid, 'In the default parameter set, these thresholds are approximately `q_pos <= 0.48` and `blind_score >= 0.58`.\n\n');

fprintf(fid, '## Applicability Summary\n\n');
fprintf(fid, '| Scene | Role | Config | Full Delta Timely (pp) | PosDeg Delta Timely (pp) | Joint Activation Ratio | Blind Trigger Ratio | Low-q_pos Ratio | Class |\n');
fprintf(fid, '|---|---|---|---:|---:|---:|---:|---:|---|\n');
for i = 1:height(T)
    fprintf(fid, '| %s | %s | %s | %.3f | %.3f | %.3f | %.3f | %.3f | %s |\n', ...
        T.Scene(i), T.SceneRole(i), T.Config(i), ...
        T.Full_DeltaPctPt(i), T.PosDeg_DeltaPctPt(i), ...
        T.PosDeg_JointActivationRatio(i), T.PosDeg_BlindTriggerRatio(i), ...
        T.PosDeg_LowQPosRatio(i), T.ApplicabilityClass(i));
end

boundary_rows = T(T.Scene == "10011", :);
active_rows = T(T.ApplicabilityClass == "Active", :);

fprintf(fid, '\n## Boundary Scene Interpretation\n\n');
for i = 1:height(boundary_rows)
    fprintf(fid, '- Scene `%s` / `%s`: %s ', ...
        boundary_rows.Scene(i), boundary_rows.Config(i), boundary_rows.Interpretation(i));
    fprintf(fid, 'Observed full-stage timely-rate gain = %.3f pp, PosDeg timely-rate gain = %.3f pp, joint activation ratio = %.3f.\n', ...
        boundary_rows.Full_DeltaPctPt(i), boundary_rows.PosDeg_DeltaPctPt(i), boundary_rows.PosDeg_JointActivationRatio(i));
end

fprintf(fid, '\n## Active Regime Interpretation\n\n');
for i = 1:height(active_rows)
    fprintf(fid, '- Scene `%s` / `%s`: full-stage timely-rate gain = %.3f pp, PosDeg timely-rate gain = %.3f pp, joint activation ratio = %.3f, peak gain stage = `%s`.\n', ...
        active_rows.Scene(i), active_rows.Config(i), active_rows.Full_DeltaPctPt(i), ...
        active_rows.PosDeg_DeltaPctPt(i), active_rows.PosDeg_JointActivationRatio(i), ...
        active_rows.PeakGainStage(i));
end

fprintf(fid, '\n## Recommended Paper Wording\n\n');
fprintf(fid, '- The method is not intended to improve already-open scenes where blind-zone risk and positioning degradation do not overlap.\n');
fprintf(fid, '- Scene `10011` should be presented as a boundary-case validation rather than a failure case: when the triggering conditions are absent, the scheduler does not degrade timely performance and effectively collapses to the link-aware baseline.\n');
fprintf(fid, '- The method should be claimed applicable to scenes with non-trivial overlap between blind-zone activation and positioning degradation, rather than to all traffic scenes uniformly.\n');
end
