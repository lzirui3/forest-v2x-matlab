function write_step57_parameter_credibility_report_cn(T_resources, T_categories, T_values, T_claims, out_path)
%WRITE_STEP57_PARAMETER_CREDIBILITY_REPORT_CN Write parameter credibility report.

fid = fopen(out_path, 'w');
if fid == -1
    error('Could not open Step57 report file: %s', out_path);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

fprintf(fid, '# Step57 参数可信度闭环报告\n\n');
fprintf(fid, '本报告用于说明最终 VTC 版本中的参数来源、证据强度和论文表述边界。该 Step 不重新调参、不重新运行仿真。\n\n');

fprintf(fid, '## 1. 外部资源检查\n\n');
fprintf(fid, '| Resource | Role | Exists | Size bytes |\n');
fprintf(fid, '|---|---|---|---:|\n');
for i = 1:height(T_resources)
    fprintf(fid, '| %s | %s | %s | %d |\n', ...
        T_resources.Name(i), T_resources.Role(i), string(T_resources.Exists(i)), T_resources.FileSizeBytes(i));
end

fprintf(fid, '\n## 2. 参数类别、证据强度与论文边界\n\n');
fprintf(fid, '| Category | Source type | Evidence strength | Allowed claim | Forbidden claim |\n');
fprintf(fid, '|---|---|---|---|---|\n');
for i = 1:height(T_categories)
    fprintf(fid, '| %s | %s | %s | %s | %s |\n', ...
        T_categories.Category(i), T_categories.SourceType(i), T_categories.EvidenceStrength(i), ...
        T_categories.PaperClaimAllowed(i), T_categories.PaperClaimForbidden(i));
end

fprintf(fid, '\n## 3. 关键参数值\n\n');
fprintf(fid, '| Parameter | Default | ForestGeometry | Source note |\n');
fprintf(fid, '|---|---:|---:|---|\n');
for i = 1:height(T_values)
    fprintf(fid, '| %s | %s | %s | %s |\n', ...
        T_values.Parameter(i), T_values.DefaultValue(i), ...
        T_values.ForestGeometryValue(i), T_values.SourceNote(i));
end

fprintf(fid, '\n## 4. 论文可用表述与禁用表述\n\n');
fprintf(fid, '| Claim | Allowed wording | Forbidden wording |\n');
fprintf(fid, '|---|---|---|\n');
for i = 1:height(T_claims)
    fprintf(fid, '| %s | %s | %s |\n', ...
        T_claims.Claim(i), T_claims.AllowedWording(i), T_claims.ForbiddenWording(i));
end

fprintf(fid, '\n## 5. 审稿口径\n\n');
fprintf(fid, '1. 当前项目的真实性应表述为 `forestry-data-informed PER-lookup simulation`，不是实车或真实林区通信实测。\n');
fprintf(fid, '2. 风险约束权重是冻结工程权重，不能声称通过理论推导得到唯一最优值。\n');
fprintf(fid, '3. 参数可信度的核心证据来自 Step54/55/56 的冻结参数、多场景、held-out 和成本收益闭环。\n');
fprintf(fid, '4. 若投 VTC，建议在方法和实验设置中单独列出本报告的 allowed/forbidden wording，避免过度主张。\n');
end
