function T_sig = build_step21_stage_significance(T_raw, stage_name, baseline_name, proposed_name)
%BUILD_STEP21_STAGE_SIGNIFICANCE Paired stage significance per forest config.

configs = unique(T_raw.Config, 'stable');
rows = [];

for i = 1:numel(configs)
    subT = T_raw(T_raw.Config == configs(i) & T_raw.Stage == stage_name, :);
    T_stat = compute_step12_statistical_tests(subT, baseline_name, proposed_name);
    T_stat.Config = repmat(configs(i), height(T_stat), 1);
    T_stat.Profile = repmat(subT.Profile(1), height(T_stat), 1);
    T_stat.Vegetation = repmat(subT.Vegetation(1), height(T_stat), 1);
    T_stat.Stage = repmat(string(stage_name), height(T_stat), 1);
    T_stat = movevars(T_stat, {'Config','Profile','Vegetation','Stage'}, 'Before', 'Metric');

    if isempty(rows)
        rows = T_stat;
    else
        rows = [rows; T_stat]; %#ok<AGROW>
    end
end

T_sig = rows;
end
