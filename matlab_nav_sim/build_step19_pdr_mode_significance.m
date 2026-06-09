function T = build_step19_pdr_mode_significance(T_raw, target_method)
%BUILD_STEP19_PDR_MODE_SIGNIFICANCE Paired significance: PER lookup vs sigmoid.

T_raw.Config = string(T_raw.Config);
T_raw.PdrMode = string(T_raw.PdrMode);
T_raw.Method = string(T_raw.Method);
target_method = string(target_method);

configs = unique(T_raw.Config, 'stable');
rows = [];

for c = 1:numel(configs)
    sub_sig = T_raw(T_raw.Config == configs(c) & T_raw.PdrMode == "sigmoid" & T_raw.Method == target_method, :);
    sub_per = T_raw(T_raw.Config == configs(c) & T_raw.PdrMode == "per_lookup" & T_raw.Method == target_method, :);
    if isempty(sub_sig) || isempty(sub_per)
        continue;
    end

    [~, idx_sig] = sort(sub_sig.Seed);
    [~, idx_per] = sort(sub_per.Seed);
    sub_sig = sub_sig(idx_sig, :);
    sub_per = sub_per(idx_per, :);

    sub_sig.Method = repmat("Sigmoid", height(sub_sig), 1);
    sub_per.Method = repmat("PerLookup", height(sub_per), 1);
    T_stat = compute_step12_statistical_tests([sub_sig; sub_per], "Sigmoid", "PerLookup");
    T_stat.Config = repmat(configs(c), height(T_stat), 1);
    T_stat = movevars(T_stat, 'Config', 'Before', 'Metric');

    if isempty(rows)
        rows = T_stat;
    else
        rows = [rows; T_stat]; %#ok<AGROW>
    end
end

T = rows;
end
