function T_stat = compute_step12_statistical_tests(T_raw, baseline_name, proposed_name)
%COMPUTE_STEP12_STATISTICAL_TESTS Paired statistical comparison with correction and effect size.

seeds = unique(T_raw.Seed);
num_seeds = numel(seeds);

metric_names = {'TimelyRate', 'LossRate', 'AvgDelay_s', 'AvgTxCost', 'EmergencyTimelyRate'};
metric_labels = {'TimelyRate', 'LossRate', 'AvgDelay', 'AvgTxCost', 'EmgTimely'};
n_metrics = numel(metric_names);

Metric = strings(n_metrics, 1);
Baseline_Mean = zeros(n_metrics, 1);
Baseline_Std = zeros(n_metrics, 1);
Proposed_Mean = zeros(n_metrics, 1);
Proposed_Std = zeros(n_metrics, 1);
Delta_Mean = zeros(n_metrics, 1);
DeltaPct = zeros(n_metrics, 1);
CI_Lower = zeros(n_metrics, 1);
CI_Upper = zeros(n_metrics, 1);
P_Value = zeros(n_metrics, 1);
P_Value_Display = strings(n_metrics, 1);
P_Value_Holm = zeros(n_metrics, 1);
P_Value_Holm_Display = strings(n_metrics, 1);
Significant = strings(n_metrics, 1);
Significant_Holm = strings(n_metrics, 1);
EffectSize_RBC = zeros(n_metrics, 1);
EffectSize_CohenDz = zeros(n_metrics, 1);
PracticalNote = strings(n_metrics, 1);

for m = 1:n_metrics
    mname = metric_names{m};
    Metric(m) = metric_labels{m};

    idx_base = T_raw.Method == baseline_name;
    idx_prop = T_raw.Method == proposed_name;

    vals_base = T_raw.(mname)(idx_base);
    vals_prop = T_raw.(mname)(idx_prop);

    if numel(vals_base) ~= num_seeds || numel(vals_prop) ~= num_seeds
        warning('Seed count mismatch: %s vs %s for %s', baseline_name, proposed_name, mname);
        continue;
    end

    Baseline_Mean(m) = mean(vals_base, 'omitnan');
    Baseline_Std(m) = std(vals_base, 0, 'omitnan');
    Proposed_Mean(m) = mean(vals_prop, 'omitnan');
    Proposed_Std(m) = std(vals_prop, 0, 'omitnan');

    delta = vals_prop - vals_base;
    Delta_Mean(m) = mean(delta, 'omitnan');
    DeltaPct(m) = compute_delta_percent(Baseline_Mean(m), Proposed_Mean(m), Metric(m));

    se = std(delta, 0, 'omitnan') / sqrt(num_seeds);
    t_crit = tinv_local(0.975, max(num_seeds - 1, 1));
    CI_Lower(m) = Delta_Mean(m) - t_crit * se;
    CI_Upper(m) = Delta_Mean(m) + t_crit * se;

    P_Value(m) = paired_pvalue(vals_prop, vals_base);
    P_Value_Display(m) = format_pvalue(P_Value(m));

    EffectSize_RBC(m) = paired_rank_biserial(delta);
    EffectSize_CohenDz(m) = paired_cohen_dz(delta);
    PracticalNote(m) = practical_note(Metric(m), DeltaPct(m), Delta_Mean(m));
end

P_Value_Holm = holm_bonferroni(P_Value);
for m = 1:n_metrics
    P_Value_Holm_Display(m) = format_pvalue(P_Value_Holm(m));
    Significant(m) = significance_mark(P_Value(m));
    Significant_Holm(m) = significance_mark(P_Value_Holm(m));
end

T_stat = table(Metric, Baseline_Mean, Baseline_Std, Proposed_Mean, Proposed_Std, ...
    Delta_Mean, DeltaPct, CI_Lower, CI_Upper, P_Value, P_Value_Display, ...
    P_Value_Holm, P_Value_Holm_Display, Significant, Significant_Holm, ...
    EffectSize_RBC, EffectSize_CohenDz, PracticalNote);
end

function p = paired_pvalue(vals_prop, vals_base)
try
    p = signrank(vals_prop, vals_base);
catch
    delta = vals_prop - vals_base;
    delta = delta(~isnan(delta));
    n = numel(delta);

    if n <= 1
        p = 1.0;
        return;
    end

    sd = std(delta, 0);
    if sd <= 1.0e-12
        if abs(mean(delta)) <= 1.0e-12
            p = 1.0;
        else
            p = realmin('double');
        end
        return;
    end

    t_stat = mean(delta) / (sd / sqrt(n));
    p = 2.0 * (1.0 - normcdf_local(abs(t_stat)));
end

p = max(min(p, 1.0), realmin('double'));
end

function p_adj = holm_bonferroni(p_raw)
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

function value = paired_rank_biserial(delta)
delta = delta(~isnan(delta));
delta = delta(abs(delta) > 1.0e-12);

if isempty(delta)
    value = 0.0;
    return;
end

abs_delta = abs(delta);
[sorted_abs, sort_idx] = sort(abs_delta);
ranks = zeros(size(sorted_abs));

i = 1;
while i <= numel(sorted_abs)
    j = i;
    while j < numel(sorted_abs) && abs(sorted_abs(j + 1) - sorted_abs(i)) <= 1.0e-12
        j = j + 1;
    end
    ranks(i:j) = mean(i:j);
    i = j + 1;
end

full_ranks = zeros(size(delta));
full_ranks(sort_idx) = ranks;
w_pos = sum(full_ranks(delta > 0));
w_neg = sum(full_ranks(delta < 0));

den = w_pos + w_neg;
if den <= 0
    value = 0.0;
else
    value = (w_pos - w_neg) / den;
end
end

function value = paired_cohen_dz(delta)
delta = delta(~isnan(delta));
if numel(delta) <= 1
    value = 0.0;
    return;
end

sd = std(delta, 0);
if sd <= 1.0e-12
    if abs(mean(delta)) <= 1.0e-12
        value = 0.0;
    else
        value = sign(mean(delta)) * Inf;
    end
else
    value = mean(delta) / sd;
end
end

function pct = compute_delta_percent(base_mean, prop_mean, metric_label)
if strcmp(metric_label, "AvgDelay") || strcmp(metric_label, "AvgTxCost")
    denom = max(abs(base_mean), 1.0e-12);
    pct = 100.0 * (prop_mean - base_mean) / denom;
else
    pct = 100.0 * (prop_mean - base_mean);
end
end

function note = practical_note(metric_label, delta_pct, delta_mean)
if isnan(delta_pct) || isnan(delta_mean)
    note = "NotApplicable";
    return;
end

if strcmp(metric_label, "TimelyRate") || strcmp(metric_label, "LossRate") || strcmp(metric_label, "EmgTimely")
    if abs(delta_pct) < 1.0
        note = "Below1pp";
    else
        note = "Meaningful";
    end
elseif strcmp(metric_label, "AvgDelay")
    if abs(delta_mean) < 1.0e-3
        note = "Sub-ms";
    else
        note = "Meaningful";
    end
else
    note = "SeeDelta";
end
end

function s = significance_mark(p)
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

function s = format_pvalue(p)
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

function t = tinv_local(p, df)
if df >= 30
    t = norminv_local(p);
else
    z = norminv_local(p);
    g1 = (z^3 + z) / (4 * df);
    g2 = (5*z^5 + 16*z^3 + 3*z) / (96 * df^2);
    t = z + g1 + g2;
end
end

function z = norminv_local(p)
a = p - 0.5;
if abs(a) <= 0.42
    r = a * a;
    z = a * ((((-25.44106049637 * r + 41.39119773534) * r ...
        - 18.61500062529) * r + 2.506628277459) ...
        / ((((3.13082909833 * r - 21.06224101826) * r ...
        + 23.08336743743) * r - 8.47351093090) * r + 1.0));
else
    r = p;
    if a > 0
        r = 1 - p;
    end
    r = log(-log(r));
    z = 0.195740115269792 + r * (0.652871358248692 + r * ...
        (0.0422087028700104 + r * (0.00927052226489354 + r * ...
        (0.000148753612908506 + r * (0.0000267376153890389 + r * ...
        1.2424673964832e-08)))));
    if a < 0
        z = -z;
    end
end
end

function y = normcdf_local(z)
y = 0.5 * (1.0 + erf_local(z / sqrt(2.0)));
end

function y = erf_local(x)
sgn = sign(x);
x = abs(x);
t = 1.0 / (1.0 + 0.3275911 * x);
y = 1.0 - (((((1.061405429*t - 1.453152027)*t) + 1.421413741)*t ...
    - 0.284496736)*t + 0.254829592) * t * exp(-x*x);
y = sgn * y;
end
