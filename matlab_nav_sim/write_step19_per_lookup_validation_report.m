function write_step19_per_lookup_validation_report(T_overall, T_posdeg, T_sig, T_posdeg_sig, out_path)
%WRITE_STEP19_PER_LOOKUP_VALIDATION_REPORT Write a concise Step19 report.

lines = {};
lines{end+1} = '# Step 19 PER Lookup Validation Report';
lines{end+1} = '';
lines{end+1} = 'This report compares the end-to-end scheduling results under two physical-layer PDR mappings:';
lines{end+1} = '- `sigmoid`: fitted approximation used by the original mainline';
lines{end+1} = '- `per_lookup`: direct interpolation of WiLabV2Xsim PER tables';
lines{end+1} = '';
lines{end+1} = 'The comparison is performed under the same random seeds, scenarios, and scheduling methods.';
lines{end+1} = '';

lines{end+1} = '## Overall Delta Summary';
lines{end+1} = '';
lines{end+1} = table_to_markdown(T_overall);
lines{end+1} = '';
lines{end+1} = '## PosDeg_Emerg Delta Summary';
lines{end+1} = '';
lines{end+1} = table_to_markdown(T_posdeg);
lines{end+1} = '';
lines{end+1} = '## Overall Significance';
lines{end+1} = '';
lines{end+1} = table_to_markdown(T_sig);
lines{end+1} = '';
lines{end+1} = '## PosDeg_Emerg Significance';
lines{end+1} = '';
lines{end+1} = table_to_markdown(T_posdeg_sig);
lines{end+1} = '';
lines{end+1} = '## Interpretation';
lines{end+1} = '';
lines{end+1} = '- If the absolute deltas remain small while significance is weak, the sigmoid approximation is acceptable for mainline experimentation.';
lines{end+1} = '- If the key-stage deltas remain limited, the approximation error does not materially alter the scheduling conclusion.';
lines{end+1} = '- If large deltas appear in `ForestGeometry` or `PosDeg_Emerg`, the final paper should prefer `per_lookup` or explicitly report the approximation bias.';

fid = fopen(out_path, 'w');
cleanup = onCleanup(@() fclose(fid));
for i = 1:numel(lines)
    fprintf(fid, '%s\n', lines{i});
end
end

function md = table_to_markdown(T)
if isempty(T)
    md = '_No data_';
    return;
end

headers = cellstr(string(T.Properties.VariableNames));
sep = repmat({'---'}, size(headers));

lines = {};
lines{end+1} = ['| ' strjoin(headers, ' | ') ' |'];
lines{end+1} = ['| ' strjoin(sep, ' | ') ' |'];

for r = 1:height(T)
    cells = cell(1, width(T));
    for c = 1:width(T)
        value = T{r, c};
        if isstring(value) || ischar(value)
            cells{c} = char(string(value));
        elseif isnumeric(value)
            if isscalar(value)
                cells{c} = sprintf('%.4g', value);
            else
                cells{c} = char(string(value));
            end
        else
            cells{c} = char(string(value));
        end
    end
    lines{end+1} = ['| ' strjoin(cells, ' | ') ' |'];
end

md = strjoin(lines, newline);
end
