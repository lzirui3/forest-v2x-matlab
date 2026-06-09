function metrics = compute_stage_metrics(err, stages)
%COMPUTE_STAGE_METRICS Compute stage-wise mean/RMSE/max/availability for one method.

num_stages = numel(stages);
metrics = struct('stage', [], 'mean_err', [], 'rmse', [], 'max_err', [], 'availability', []);
metrics = repmat(metrics, num_stages, 1);

for i = 1:num_stages
    mask = stages(i).mask;
    err_stage = err(mask);
    valid_mask = ~isnan(err_stage);
    err_valid = err_stage(valid_mask);

    metrics(i).stage = stages(i).name;
    metrics(i).availability = sum(valid_mask) / numel(err_stage);

    if isempty(err_valid)
        metrics(i).mean_err = NaN;
        metrics(i).rmse = NaN;
        metrics(i).max_err = NaN;
    else
        metrics(i).mean_err = mean(err_valid);
        metrics(i).rmse = sqrt(mean(err_valid .^ 2));
        metrics(i).max_err = max(err_valid);
    end
end
