function T_sig = build_step20_significance(T_raw, baseline_name, proposed_name)
%BUILD_STEP20_SIGNIFICANCE Build paired significance tables across Step20 configs.

configs = unique(T_raw.Config, 'stable');
rows = [];

for i = 1:numel(configs)
    subT = T_raw(T_raw.Config == configs(i), :);
    T_stat = compute_step12_statistical_tests(subT, baseline_name, proposed_name);
    T_stat.Config = repmat(configs(i), height(T_stat), 1);
    T_stat = movevars(T_stat, 'Config', 'Before', 'Metric');

    if isempty(rows)
        rows = T_stat;
    else
        rows = [rows; T_stat]; %#ok<AGROW>
    end
end

T_sig = rows;
end
