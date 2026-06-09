function T = apply_familywise_holm_to_stats_table(T)
%APPLY_FAMILYWISE_HOLM_TO_STATS_TABLE Apply Holm-Bonferroni across all rows in a stats table.

if isempty(T) || ~ismember('P_Value', T.Properties.VariableNames)
    return;
end

p_raw = T.P_Value;
p_adj = holm_bonferroni_local(p_raw);

T.P_Value_Holm_Family = p_adj;
T.P_Value_Holm_Family_Display = arrayfun(@format_pvalue_local, p_adj);
T.Significant_Holm_Family = arrayfun(@significance_mark_local, p_adj);
end

function p_adj = holm_bonferroni_local(p_raw)
n = numel(p_raw);
[p_sorted, order] = sort(p_raw(:), 'ascend');
p_step = zeros(size(p_sorted));

for i = 1:n
    p_step(i) = (n - i + 1) * p_sorted(i);
end

for i = 2:n
    p_step(i) = max(p_step(i), p_step(i - 1));
end

p_step = min(p_step, 1.0);
p_adj = zeros(size(p_raw(:)));
p_adj(order) = p_step;
p_adj = reshape(p_adj, size(p_raw));
end

function s = significance_mark_local(p)
if p < 0.001
    s = "***";
elseif p < 0.01
    s = "**";
elseif p < 0.05
    s = "*";
else
    s = "n.s.";
end
end

function s = format_pvalue_local(p)
if isnan(p)
    s = "NaN";
elseif p <= realmin('double') * 10
    s = "p < 2.3e-308";
elseif p < 1.0e-15
    s = "p < 1e-15";
elseif p < 1.0e-3
    s = "p = " + string(sprintf('%.3e', p));
else
    s = "p = " + string(sprintf('%.4g', p));
end
end
