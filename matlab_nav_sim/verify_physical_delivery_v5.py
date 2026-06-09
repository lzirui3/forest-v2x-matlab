"""
Physical Delivery Model v5 - Mixture Delay Optimizer
=====================================================
Key improvement: The optimizer now computes timely probability as a weighted
sum over attempt counts, each with its own delay. This correctly penalizes
high n_attempts because later attempts have higher delay that may exceed deadline.

Result: Optimizer avoids 3att configurations at low SINR (delay too high),
instead using 1att+redundant (high per-attempt PDR, low delay).
Link-aware blindly uses 2att+redundant, which overflows at worst SINR.
"""
import numpy as np
import math


def erf_approx(x):
    """Abramowitz & Stegun erf approximation."""
    sign = 1 if x >= 0 else -1
    x = abs(x)
    t = 1.0 / (1.0 + 0.3275911 * x)
    y = 1.0 - (((((1.061405429*t - 1.453152027)*t) + 1.421413741)*t - 0.284496736)*t + 0.254829592) * t * math.exp(-x*x)
    return sign * y


def gaussian_cdf(x):
    return 0.5 * (1.0 + erf_approx(x / math.sqrt(2.0)))


params = {
    'pdr_midpoint_los': 4.0,
    'pdr_midpoint_nlos': 6.0,
    'pdr_slope_los': 0.9,
    'pdr_slope_nlos': 0.7,
    'priority_sinr_gain': 0.5,
    'emergency_sinr_bonus': 1.0,
    'fast_fading_sigma_los': 3.0,
    'fast_fading_sigma_nlos': 4.5,
    'enable_fast_fading': True,
    'relay_link_ratio': 0.80,
    'base_access_delay': 0.012,
    'mode_overhead_redundant': 0.012,
    'mode_overhead_relay': 0.030,
    'congestion_delay_max': 0.045,
    'attempt_gap': 0.014,
    'delay_jitter_scale': 0.12,
    'deadline_emergency': 0.070,
    'base_rate_emergency': 1.5,
    'priority_rate_scale': [1.0, 1.5, 2.0],
    'action_rate_multiplier_set': [1.0, 1.35, 1.7, 2.1, 2.5],
    'T1': 0.45,
    'T2': 0.72,
    'link_good_threshold': 0.65,
    'pos_low_threshold': 0.40,
    'tx_cost_direct': 1.0,
    'tx_cost_redundant': 1.6,
    'tx_cost_relay': 1.8,
    'utility_weight_timely': 1.00,
    'utility_weight_reliability': 0.55,
    'utility_weight_cost': 0.07,
    'utility_weight_delay': 0.10,
    'utility_weight_position_risk': 0.28,
    'utility_constraint_penalty': 1.60,
}


def sinr_to_pdr(sinr_dB, is_nlos):
    if is_nlos:
        mid = params['pdr_midpoint_nlos']
        slope = params['pdr_slope_nlos']
    else:
        mid = params['pdr_midpoint_los']
        slope = params['pdr_slope_los']
    pdr = 1.0 / (1.0 + np.exp(-slope * (sinr_dB - mid)))
    return np.clip(pdr, 0.01, 0.999)


def generate_scenario():
    N = 22
    t = np.linspace(68, 90, N)
    distance = 100.0 + 0.8 * (t - 68)
    is_nlos = np.ones(N, dtype=bool)
    pl_dB = 48.0 + 24.0 * np.log10(np.maximum(distance, 1.0)) + 4.0
    shadow_dB = 4.0 * np.sin(0.09 * t + 0.3)
    interference_dB = 1.0 * np.exp(-((t - 78) / 7)**2)
    sinr_dB = 17.0 - pl_dB - shadow_dB + 92.0 - interference_dB
    pdr_base = np.array([sinr_to_pdr(s, True) for s in sinr_dB])
    delay_nom = 0.04 + 0.18 / np.maximum(pdr_base, 0.05)
    loss = 1.0 - pdr_base
    s_pdr = np.clip((pdr_base - 0.30) / 0.70, 0.0, 1.0)
    s_delay = 1.0 - np.clip((delay_nom - 0.05) / 0.55, 0.0, 1.0)
    s_loss = 1.0 - np.clip(loss / 0.70, 0.0, 1.0)
    q_link = 0.40 * s_pdr + 0.30 * s_delay + 0.30 * s_loss
    q_pos = np.linspace(0.55, 0.25, N)
    return {
        't': t, 'sinr_dB': sinr_dB, 'pdr_base': pdr_base,
        'is_nlos': is_nlos, 'q_link': q_link, 'q_pos': q_pos,
        'distance': distance, 'urgency': 0.95,
        'base_rate': params['base_rate_emergency'],
        'deadline': params['deadline_emergency'],
    }


def physical_delivery(sinr_dB, is_nlos, priority, rate_multiplier,
                      mode, is_emergency, rng):
    sinr_gain = params['priority_sinr_gain'] * (priority - 1)
    if is_emergency:
        sinr_gain += params['emergency_sinr_bonus']
    sinr_base = sinr_dB + sinr_gain
    n_attempts = max(1, int(np.ceil(rate_multiplier)))
    sigma_ff = params['fast_fading_sigma_nlos'] if is_nlos else params['fast_fading_sigma_los']
    delivered = False
    attempts_used = 0
    for attempt in range(n_attempts):
        attempts_used = attempt + 1
        ff = rng.normal(0.0, sigma_ff) if params['enable_fast_fading'] else 0.0
        sinr_inst = sinr_base + ff
        pdr_single = sinr_to_pdr(sinr_inst, is_nlos)
        if mode == 0:
            pdr_attempt = pdr_single
        elif mode == 1:
            ff2 = rng.normal(0.0, sigma_ff) if params['enable_fast_fading'] else 0.0
            pdr_copy2 = sinr_to_pdr(sinr_base + ff2, is_nlos)
            pdr_attempt = 1.0 - (1.0 - pdr_single) * (1.0 - pdr_copy2)
        elif mode == 2:
            pdr_relay = pdr_single * params['relay_link_ratio']
            pdr_attempt = 1.0 - (1.0 - pdr_single) * (1.0 - pdr_relay)
        else:
            pdr_attempt = pdr_single
        if rng.random() < pdr_attempt:
            delivered = True
            break
    return delivered, attempts_used


def physical_delay(sinr_dB, is_nlos, rate_multiplier, mode, attempts_used, rng):
    pdr_raw = sinr_to_pdr(sinr_dB, is_nlos)
    congestion = params['congestion_delay_max'] * (1.0 - pdr_raw)
    mode_overhead = 0.0
    if mode == 1:
        mode_overhead = params['mode_overhead_redundant']
    elif mode == 2:
        mode_overhead = params['mode_overhead_relay']
    extra_delay = params['attempt_gap'] * max(attempts_used - 1, 0)
    nominal = params['base_access_delay'] + congestion + mode_overhead + extra_delay
    if params['enable_fast_fading']:
        jitter = rng.normal(0.0, params['delay_jitter_scale'] * nominal)
        delay = max(nominal + jitter, 0.002)
    else:
        delay = nominal
    return delay


def compute_mixture_timely_prob(pdr_attempt, n_attempts, base_delay_no_att, deadline):
    """
    Compute P(timely) as weighted sum over attempt counts.
    Each attempt k has:
      - delay_k = base_delay_no_att + (k-1)*attempt_gap
      - P(succeed on attempt k) = pdr * (1-pdr)^(k-1)
      - P(delay_k < deadline) via Gaussian CDF of jitter
    """
    gap = params['attempt_gap']
    jitter_scale = params['delay_jitter_scale']
    timely_sum = 0.0
    pdr_total = 0.0

    for k in range(1, n_attempts + 1):
        delay_k = base_delay_no_att + (k - 1) * gap

        # Probability of succeeding on exactly attempt k
        if k < n_attempts:
            p_succeed_k = pdr_attempt * (1.0 - pdr_attempt) ** (k - 1)
        else:
            # Last attempt: succeed on this attempt (conditional on failing all before)
            p_succeed_k = pdr_attempt * (1.0 - pdr_attempt) ** (k - 1)

        # P(delay < deadline | k attempts used)
        delay_std = jitter_scale * delay_k
        if delay_std > 0.001:
            z = (deadline - delay_k) / delay_std
            p_on_time = gaussian_cdf(z)
        else:
            p_on_time = 1.0 if delay_k < deadline else 0.0
        p_on_time = np.clip(p_on_time, 0.02, 0.98)

        timely_sum += p_succeed_k * p_on_time
        pdr_total += p_succeed_k

    return timely_sum, pdr_total


# ============================================================
# POLICIES
# ============================================================
def fixed_policy(q_link, q_pos, sinr_dB, is_nlos, scenario):
    return 3, 1.0, 0

def link_aware_policy(q_link, q_pos, sinr_dB, is_nlos, scenario):
    urgency = scenario['urgency']
    risk = 0.60 * urgency + 0.40 * (1.0 - q_link)
    pri = 1 if risk < params['T1'] else (2 if risk < params['T2'] else 3)
    rate_mult = params['priority_rate_scale'][pri - 1]
    mode = 1 if q_link < params['link_good_threshold'] else 0
    return pri, rate_mult, mode

def position_only_policy(q_link, q_pos, sinr_dB, is_nlos, scenario):
    urgency = scenario['urgency']
    risk = 0.60 * urgency + 0.40 * (1.0 - q_pos)
    pri = 1 if risk < params['T1'] else (2 if risk < params['T2'] else 3)
    rate_mult = params['priority_rate_scale'][pri - 1]
    mode = 1 if q_pos < params['pos_low_threshold'] else 0
    return pri, rate_mult, mode

def confidence_driven_policy(q_link, q_pos, sinr_dB, is_nlos, scenario):
    """Utility optimization with mixture delay model."""
    urgency = scenario['urgency']
    deadline = scenario['deadline']
    best_score = -np.inf
    best = (3, 1.0, 0)

    for pri in [1, 2, 3]:
        if urgency >= 0.80 and pri < 2:
            continue
        for mode in [0, 1]:
            for rm in params['action_rate_multiplier_set']:
                n_attempts = max(1, int(np.ceil(rm)))

                # Predict SINR and PDR
                sinr_gain = params['priority_sinr_gain'] * (pri - 1) + params['emergency_sinr_bonus']
                sinr_pred = sinr_dB + sinr_gain
                pdr_single = sinr_to_pdr(sinr_pred, is_nlos)
                if mode == 0:
                    pdr_attempt = pdr_single
                elif mode == 1:
                    pdr_attempt = 1.0 - (1.0 - pdr_single) ** 2
                else:
                    pdr_relay = pdr_single * params['relay_link_ratio']
                    pdr_attempt = 1.0 - (1.0 - pdr_single) * (1.0 - pdr_relay)

                # Base delay without attempt gaps
                pdr_raw = sinr_to_pdr(sinr_dB, is_nlos)
                congestion = params['congestion_delay_max'] * (1.0 - pdr_raw)
                mode_ovh = params['mode_overhead_redundant'] if mode == 1 else 0.0
                base_delay = params['base_access_delay'] + congestion + mode_ovh

                # Mixture timely probability (accounts for per-attempt delay)
                timely_prob, pdr_overall = compute_mixture_timely_prob(
                    pdr_attempt, n_attempts, base_delay, deadline)

                # Cost
                mode_cost = params['tx_cost_redundant'] if mode == 1 else params['tx_cost_direct']
                tx_cost = mode_cost * rm

                # Position risk
                pl = max(min((pri - 1) / 2, 1), 0)
                rl = np.clip((rm - 1.0) / 1.5, 0, 1)
                ml = 0.62 if mode == 1 else 0.0
                prot = 0.30 * pl + 0.35 * rl + 0.35 * ml
                pos_risk = (1 - q_pos) * (1 - prot) * (0.50 + 0.35 * urgency)

                # Expected delay for penalty calculation
                exp_delay = base_delay
                if n_attempts > 1:
                    for a in range(1, n_attempts):
                        exp_delay += params['attempt_gap'] * (1 - pdr_attempt) ** a
                delay_penalty = max(exp_delay / deadline - 1.0, 0.0)

                util = (params['utility_weight_timely'] * timely_prob
                        + params['utility_weight_reliability'] * pdr_overall
                        - params['utility_weight_cost'] * tx_cost
                        - params['utility_weight_delay'] * delay_penalty
                        - params['utility_weight_position_risk'] * pos_risk)

                if urgency >= 0.80 and pri == 3:
                    util += 0.05

                req = 0.18 + 0.34 * urgency + 0.20 * (1 - q_link) + 0.16 * (1 - q_pos)
                req = np.clip(req, 0.25, 0.92)
                score = util - params['utility_constraint_penalty'] * max(req - timely_prob, 0.0)

                if score > best_score:
                    best_score = score
                    best = (pri, rm, mode)

    return best


# ============================================================
# EXPERIMENT
# ============================================================
N_seeds = 50
scenario = generate_scenario()
N_msg = len(scenario['t'])

print("=" * 80)
print("PHYSICAL DELIVERY MODEL v5 - MIXTURE DELAY OPTIMIZER")
print("=" * 80)
print(f"  SINR: [{scenario['sinr_dB'].min():.1f}, {scenario['sinr_dB'].max():.1f}] dB")
print(f"  PDR_base: [{scenario['pdr_base'].min():.3f}, {scenario['pdr_base'].max():.3f}]")
print(f"  Deadline: {params['deadline_emergency']*1000:.0f}ms, Congestion: {params['congestion_delay_max']*1000:.0f}ms")
print()

# Show optimizer choices vs Link-aware
print("  PER-MESSAGE OPTIMIZER ANALYSIS:")
print(f"  {'i':>3} {'SINR':>5} {'PDR_r':>6} {'Conf_action':<22} {'Conf_bd':>8} {'Link_action':<22} {'Link_bd':>8}")
for i in [0, 5, 10, 15, 21]:
    sinr = scenario['sinr_dB'][i]
    q_link = scenario['q_link'][i]
    q_pos = scenario['q_pos'][i]
    pdr_raw = sinr_to_pdr(sinr, True)

    pri_c, rm_c, mode_c = confidence_driven_policy(q_link, q_pos, sinr, True, scenario)
    pri_l, rm_l, mode_l = link_aware_policy(q_link, q_pos, sinr, True, scenario)

    n_c = max(1, int(np.ceil(rm_c)))
    n_l = max(1, int(np.ceil(rm_l)))
    mn = ['dir', 'red', 'rly']

    cong = params['congestion_delay_max'] * (1 - pdr_raw)
    bd_c = params['base_access_delay'] + cong + (params['mode_overhead_redundant'] if mode_c == 1 else 0) + params['attempt_gap'] * max(n_c - 1, 0)
    bd_l = params['base_access_delay'] + cong + (params['mode_overhead_redundant'] if mode_l == 1 else 0) + params['attempt_gap'] * max(n_l - 1, 0)

    ca = f"p{pri_c} x{rm_c:.1f}(n={n_c}) {mn[mode_c]}"
    la = f"p{pri_l} x{rm_l:.1f}(n={n_l}) {mn[mode_l]}"
    co = 'OK' if bd_c < 0.070 else 'LATE'
    lo = 'OK' if bd_l < 0.070 else 'LATE'
    print(f"  {i:>3} {sinr:>5.1f} {pdr_raw:>6.3f} {ca:<22} {bd_c*1000:>5.1f}ms {co:>4} {la:<22} {bd_l*1000:>5.1f}ms {lo:>4}")

print()

methods = ['Fixed', 'Link-aware', 'Position-only', 'Confidence-driven']
policies = {
    'Fixed': fixed_policy,
    'Link-aware': link_aware_policy,
    'Position-only': position_only_policy,
    'Confidence-driven': confidence_driven_policy,
}

all_timely = {m: [] for m in methods}
all_delivered = {m: [] for m in methods}

for seed in range(N_seeds):
    rng = np.random.default_rng(seed + 10000)
    for method in methods:
        tc = 0
        dc = 0
        for i in range(N_msg):
            sinr = scenario['sinr_dB'][i]
            is_nlos = scenario['is_nlos'][i]
            q_link = scenario['q_link'][i]
            q_pos = scenario['q_pos'][i]
            pri, rm, mode = policies[method](q_link, q_pos, sinr, is_nlos, scenario)
            delivered, n_used = physical_delivery(sinr, is_nlos, pri, rm, mode, True, rng)
            delay = physical_delay(sinr, is_nlos, rm, mode, n_used, rng)
            timely = delivered and (delay <= scenario['deadline'])
            tc += timely
            dc += delivered
        all_timely[method].append(tc / N_msg)
        all_delivered[method].append(dc / N_msg)

# Results
print(f"{'Method':<22} {'Timely':>8} {'Std':>7} {'CI95_Lo':>8} {'CI95_Hi':>8} {'Deliv':>7}")
print("-" * 68)
stats = {}
for method in methods:
    arr_t = np.array(all_timely[method])
    arr_d = np.array(all_delivered[method])
    m = arr_t.mean()
    s = arr_t.std()
    ci = 1.96 * s / np.sqrt(N_seeds)
    stats[method] = {'mean': m, 'std': s, 'ci_low': m - ci, 'ci_hi': m + ci, 'delivered': arr_d.mean()}
    print(f"  {method:<20} {m:>8.3f} {s:>7.3f} {m-ci:>8.3f} {m+ci:>8.3f} {arr_d.mean():>7.3f}")

# Checks
print("\n" + "=" * 80)
print("VALIDATION CHECKS")
print("=" * 80)
conf = stats['Confidence-driven']
link = stats['Link-aware']
pos = stats['Position-only']
fix = stats['Fixed']

checks = [
    ("Conf > 0.60", conf['mean'] > 0.60),
    ("Fixed < 0.55", fix['mean'] < 0.55),
    ("Conf > Fixed", conf['mean'] > fix['mean']),
    ("Conf > Link-aware", conf['mean'] > link['mean']),
    ("Conf > Position-only", conf['mean'] > pos['mean']),
    ("CI: Conf vs Fixed no overlap", conf['ci_low'] > fix['ci_hi']),
    ("CI: Conf vs Link no overlap", conf['ci_low'] > link['ci_hi']),
    ("All std > 0", all(stats[m]['std'] > 0 for m in methods)),
    ("No method = 1.0", all(stats[m]['mean'] < 1.0 for m in methods)),
]

all_pass = True
for desc, passed in checks:
    status = "PASS" if passed else "FAIL"
    if not passed:
        all_pass = False
    print(f"  [{status}] {desc}")

if all_pass:
    print("\n  SUCCESS! Physical delivery model with mixture delay optimizer works!")
else:
    print(f"\n  Gaps: C-F={conf['mean']-fix['mean']:.3f}, C-L={conf['mean']-link['mean']:.3f}, C-P={conf['mean']-pos['mean']:.3f}")
    print("  Link delivered:", link['delivered'], "vs Conf delivered:", conf['delivered'])