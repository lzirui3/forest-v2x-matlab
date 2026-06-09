function [chosen_idx, chosen_score, chosen_margin, feasible_found] = ...
    select_min_cost_feasible_action(actions, cache, fallback_scores, required_timely, hard_feasible_mask)
%SELECT_MIN_COST_FEASIBLE_ACTION Choose the minimum-cost action satisfying the timely target.

if nargin < 5 || isempty(hard_feasible_mask)
    hard_feasible_mask = true(numel(actions), 1);
end

feasible_found = false;
chosen_idx = 1;
chosen_score = -inf;
chosen_margin = -inf;
best_cost = inf;

for i = 1:numel(actions)
    if ~hard_feasible_mask(i)
        continue;
    end
    aux = cache(i).aux;
    if ~isfield(aux, 'timely_prob') || isnan(aux.timely_prob)
        continue;
    end
    if aux.timely_prob < required_timely
        continue;
    end

    margin = aux.timely_prob - required_timely;
    tx_cost = aux.tx_cost;
    score = fallback_scores(i);

    if ~feasible_found ...
            || tx_cost < best_cost - 1.0e-9 ...
            || (abs(tx_cost - best_cost) <= 1.0e-9 && margin > chosen_margin + 1.0e-9) ...
            || (abs(tx_cost - best_cost) <= 1.0e-9 && abs(margin - chosen_margin) <= 1.0e-9 && score > chosen_score)
        feasible_found = true;
        chosen_idx = i;
        chosen_score = score;
        chosen_margin = margin;
        best_cost = tx_cost;
    end
end
end
