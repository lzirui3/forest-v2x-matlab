function T_wide = build_rmse_wide_table(T)
%BUILD_RMSE_WIDE_TABLE Convert long-format stage metrics to a wide RMSE table.

stages = unique(T.Stage, 'stable');
methods = unique(T.Method, 'stable');
num_methods = numel(methods);
num_stages = numel(stages);

rmse_mat = nan(num_methods, num_stages);

for i = 1:num_methods
    for j = 1:num_stages
        idx = (T.Method == methods(i)) & (T.Stage == stages(j));
        if any(idx)
            rmse_mat(i, j) = T.RMSE_m(find(idx, 1, 'first'));
        end
    end
end

T_wide = array2table(rmse_mat, 'VariableNames', cellstr(stages));
T_wide = addvars(T_wide, methods, 'Before', 1, 'NewVariableNames', 'Method');
