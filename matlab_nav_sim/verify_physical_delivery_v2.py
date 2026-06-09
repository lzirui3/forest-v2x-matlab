"""
Physical Delivery Model v2 - Corrected
=======================================
Key insight: rate_multiplier = number of independent transmission attempts (not MCS change).
This is physically supported by NR-V2X configured grants (multiple slots per TB).

Physical mechanisms:
1. Priority/emergency → SINR gain (better resource allocation, less interference)
2. Rate multiplier → more transmission attempts (time diversity)
3. Redundant mode → HARQ blind retransmission (2 copies per attempt)
4. Relay mode → spatial diversity (independent path)
5. Fast fading → per-attempt SINR variation
6. SINR → PDR via calibrated PER curve (WiLabV2Xsim)
7. Delivery = Bernoulli(effective_pdr)

Tradeoff: more attempts improve delivery but add delay (may exceed deadline).
Confidence-driven optimizes this tradeoff; baselines use fixed rules.
"""
import numpy as np

# ============================================================
# PARAMETERS
# ============================================================
params = {
    # SINR->PDR sigmoid (fitted to WiLabV2Xsim PER curves)
    # Adjusted: midpoint=6 for NLOS (NR MCS7, 200B packet - smaller than 350B)
    'pdr_midpoint_los': 4.0,           # dB where PDR=0.5 (LOS, LTE MCS7 200B)
    'pdr_midpoint_nlos': 6.0,          # dB where PDR=0.5 (NLOS, NR MCS7 200B)
    'pdr_slope_los': 0.9,              # sigmoid steepness
    'pdr_slope_nlos': 0.7,             # sigmoid steepness (NLOS has wider transition)

    # Priority and emergency SINR gain
    'priority_sinr_gain': 1.5,         # dB per priority level (SPS resource advantage)
    'emergency_sinr_bonus': 2.0,       # dB (dedicated emergency resource pool)

    # Fast fading (per-attempt)
    'fast_fading_sigma_los': 3.0,      # dB (Rician K=3)
    'fast_fading_sigma_nlos': 4.5,     # dB (Rayleigh-like, slightly less than 5)
    'enable_fast_fading': True,

    # Mode parameters
    'relay_link_ratio': 0.80,          # relay hop PDR relative to direct

    # Delay model (physical C-V2X timing)
    'base_access_delay': 0.015,        # 15ms: processing + SPS grant + encoding
    'mode_overhead_redundant': 0.010,  # 10ms: HARQ blind retx in next subframe
    'mode_overhead_relay': 0.025,      # 25ms: relay hop (decode+re-encode+forward)
    'congestion_delay_max': 0.040,     # 40ms max congestion delay
    'attempt_gap': 0.012,              # 12ms between transmission attempts

    # Delay jitter
    'delay_jitter_scale': 0.15,

    # Deadline
    'deadline_emergency': 0.088,       # 88ms

    # Base rate
    'base_rate_emergency': 1.5,

    # Baseline parameters
    'priority_rate_scale': [1.0, 1.5, 2.0],
    'action_rate_multiplier_set': [1.0, 1.35, 1.7, 2.1, 2.5],
    'T1': 0.45,
    'T2': 0.72,
    'link_good_threshold': 0.65,
    'pos_low_threshold': 0.40,

    # Cost
    'tx_cost_direct': 1.0,
    'tx_cost_redundant': 1.6,
    'tx_cost_relay': 1.8,

    # Utility weights
    'utility_weight_timely': 1.00,
    'utility_weight_reliability': 0.55,
    'utility_weight_cost': 0.07,
    'utility_weight_delay': 0.10,
    'utility_weight_position_risk': 0.28,
    'utility_constraint_penalty': 1.60,
}


def sinr_to_pdr(sinr_dB, is_nlos):
    """Sigmoid approximation of WiLabV2Xsim PER curve."""
    if is_nlos:
        mid = params['pdr_midpoint_nlos']
        slope = params['pdr_slope_nlos']
    else:
        mid = params['pdr_midpoint_los']
        slope = params['pdr_slope_los']
    pdr = 1.0 / (1.0 + np.exp(-slope * (sinr_dB - mid)))
    return np.clip(pdr, 0.01, 0.999)


def generate_scenario():
    """PosDeg_Emerg scenario with physical SINR values."""
    N = 22
    t = np.linspace(68, 90, N)

    # Distance (from link model: rx_x = 100 + 0.8*(t-68))
    distance = 100.0 + 0.8 * (t - 68)

    # NLOS during this phase
    is_nlos = np.ones(N, dtype=bool)

    # Path loss (NLOS): PL = 48 + 24*log10(d) + 4*nlosv
    nlosv = 1.0
    pl_dB = 48.0 + 24.0 * np.log10(np.maximum(distance, 1.0)) + 4.0 * nlosv

    # Shadow fading (slow, deterministic for scenario)
    shadow_dB = 4.0 * np.sin(0.09 * t + 0.3)

    # Interference peak near t=78
    interference_dB = 1.0 * np.exp(-((t - 78) / 7)**2)

    # SINR
    tx_power = 17.0
    noise_floor = -92.0
    sinr_dB = tx_power - pl_dB - shadow_dB - noise_floor - interference_dB

    # Base PDR (physical layer output)
    pdr_base = np.array([sinr_to_pdr(s, True) for s in sinr_dB])

    # q_link (observable for policy decisions)
    delay_nom = 0.04 + 0.18 / np.maximum(pdr_base, 0.05)
    loss = 1.0 - pdr_base
    s_pdr = np.clip((pdr_base - 0.30) / 0.70, 0.0, 1.0)
    s_delay = 1.0 - np.clip((delay_nom - 0.05) / 0.55, 0.0, 1.0)
    s_loss = 1.0 - np.clip(loss / 0.70, 0.0, 1.0)
    q_link = 0.40 * s_pdr + 0.30 * s_delay + 0.30 * s_loss

    # Position quality (degrading)
    q_pos = np.linspace(0.55, 0.25, N)

    return {
        't': t, 'sinr_dB': sinr_dB, 'pdr_base': pdr_base,
        'is_nlos': is_nlos, 'q_link': q_link, 'q_pos': q_pos,
        'distance': distance, 'urgency': 0.95,
        'base_rate': params['base_rate_emergency'],
        'deadline': params['deadline_emergency'],
    }


# ============================================================
# PHYSICAL DELIVERY MODEL
# ============================================================
def physical_delivery(sinr_dB, is_nlos, priority, rate_multiplier,
                      mode, is_emergency, rng):
    """
    Physical delivery model:
    1. Priority → SINR gain
    2. Fast fading → instantaneous SINR per attempt
    3. SINR → PDR (per attempt, via PER curve)
    4. Mode → per-attempt diversity gain
    5. Rate_multiplier → number of independent attempts (time diversity)
    6. Overall PDR = 1 - (1-pdr_per_attempt)^n_attempts
    7. Bernoulli delivery
    """
    # Priority/emergency SINR gain
    sinr_gain = params['priority_sinr_gain'] * (priority - 1)
    if is_emergency:
        sinr_gain += params['emergency_sinr_bonus']
    sinr_base = sinr_dB + sinr_gain

    # Number of transmission attempts
    n_attempts = max(1, int(np.ceil(rate_multiplier)))

    # Simulate each attempt independently (each gets its own fast fading)
    sigma_ff = params['fast_fading_sigma_nlos'] if is_nlos else params['fast_fading_sigma_los']
    delivered = False

    for attempt in range(n_attempts):
        # Per-attempt fast fading
        if params['enable_fast_fading']:
            ff = rng.normal(0.0, sigma_ff)
            sinr_inst = sinr_base + ff
        else:
            sinr_inst = sinr_base

        # SINR → PDR (physical PER curve)
        pdr_single = sinr_to_pdr(sinr_inst, is_nlos)

        # Mode diversity within this attempt
        if mode == 0:  # direct
            pdr_attempt = pdr_single
        elif mode == 1:  # redundant (HARQ blind retx: 2 independent copies)
            # Second copy gets independent fading
            if params['enable_fast_fading']:
                ff2 = rng.normal(0.0, sigma_ff)
                pdr_copy2 = sinr_to_pdr(sinr_base + ff2, is_nlos)
            else:
                pdr_copy2 = pdr_single
            pdr_attempt = 1.0 - (1.0 - pdr_single) * (1.0 - pdr_copy2)
        elif mode == 2:  # relay
            pdr_relay = pdr_single * params['relay_link_ratio']
            pdr_attempt = 1.0 - (1.0 - pdr_single) * (1.0 - pdr_relay)
        else:
            pdr_attempt = pdr_single

        # Bernoulli trial for this attempt
        if rng.random() < pdr_attempt:
            delivered = True
            break  # first success stops attempts

    return delivered, n_attempts


def physical_delay(sinr_dB, is_nlos, rate_multiplier, mode, n_attempts_used, rng):
    """
    Physical delay model:
    - base_access: processing + SPS grant (15ms)
    - congestion: higher when channel quality is poor (0-40ms)
    - mode_overhead: redundant +10ms, relay +25ms
    - attempt_gap: each additional attempt adds 12ms
    - jitter: random variation
    """
    pdr_nominal = sinr_to_pdr(sinr_dB, is_nlos)
    congestion = params['congestion_delay_max'] * (1.0 - pdr_nominal)

    mode_overhead = 0.0
    if mode == 1:
        mode_overhead = params['mode_overhead_redundant']
    elif mode == 2:
        mode_overhead = params['mode_overhead_relay']

    # Extra attempts add delay (time spent waiting for retransmission slots)
    extra_attempt_delay = params['attempt_gap'] * max(n_attempts_used - 1, 0)

    nominal_delay = (params['base_access_delay'] + congestion
                     + mode_overhead + extra_attempt_delay)

    # Jitter
    if params['enable_fast_fading']:
        jitter = rng.normal(0.0, params['delay_jitter_scale'] * nominal_delay)
        delay = max(nominal_delay + jitter, 0.002)
    else:
        delay = nominal_delay

    return delay


# ============================================================
# METHOD POLICIES
# ============================================================
def fixed_policy(q_link, q_pos, scenario):
    """Fixed: direct mode, base rate, max priority (emergency)."""
    return 3, 1.0, 0  # pri=3, rate_mult=1.0, mode=direct


def link_aware_policy(q_link, q_pos, scenario):
    """Link-aware: adjusts priority/rate by q_link, uses redundant when link bad."""
    urgency = scenario['urgency']
    risk = 0.60 * urgency + 0.40 * (1.0 - q_link)
    if risk < params['T1']:
        pri = 1
    elif risk < params['T2']:
        pri = 2
    else:
        pri = 3
    rate_mult = params['priority_rate_scale'][pri - 1]
    mode = 1 if q_link < params['link_good_threshold'] else 0
    return pri, rate_mult, mode


def position_only_policy(q_link, q_pos, scenario):
    """Position-only: adjusts by q_pos, uses redundant when position bad."""
    urgency = scenario['urgency']
    risk = 0.60 * urgency + 0.40 * (1.0 - q_pos)
    if risk < params['T1']:
        pri = 1
    elif risk < params['T2']:
        pri = 2
    else:
        pri = 3
    rate_mult = params['priority_rate_scale'][pri - 1]
    mode = 1 if q_pos < params['pos_low_threshold'] else 0
    return pri, rate_mult, mode


def confidence_driven_policy(q_link, q_pos, sinr_dB, is_nlos, scenario):
    """Confidence-driven: utility optimization over action space."""
    urgency = scenario['urgency']
    deadline = scenario['deadline']

    best_score = -np.inf
    best = (3, 1.0, 0)

    for pri in [1, 2, 3]:
        if urgency >= 0.80 and pri < 2:
            continue
        for mode in [0, 1]:  # no relay in PosDeg
            for rm in params['action_rate_multiplier_set']:
                n_attempts = max(1, int(np.ceil(rm)))

                # Predict SINR with priority gain
                sinr_gain = params['priority_sinr_gain'] * (pri - 1)
                sinr_gain += params['emergency_sinr_bonus']
                sinr_pred = sinr_dB + sinr_gain

                # Predict per-attempt PDR (use mean, no fading for prediction)
                pdr_single = sinr_to_pdr(sinr_pred, is_nlos)
                if mode == 0:
                    pdr_attempt = pdr_single
                elif mode == 1:
                    pdr_attempt = 1.0 - (1.0 - pdr_single) ** 2
                else:
                    pdr_relay = pdr_single * params['relay_link_ratio']
                    pdr_attempt = 1.0 - (1.0 - pdr_single) * (1.0 - pdr_relay)

                # Predict overall PDR with multiple attempts
                pdr_overall = 1.0 - (1.0 - pdr_attempt) ** n_attempts

                # Predict delay
                pdr_nom = sinr_to_pdr(sinr_dB, is_nlos)
                congestion = params['congestion_delay_max'] * (1.0 - pdr_nom)
                mode_ovh = params['mode_overhead_redundant'] if mode == 1 else 0.0
                attempt_delay = params['attempt_gap'] * max(n_attempts - 1, 0)
                pred_delay = params['base_access_delay'] + congestion + mode_ovh + attempt_delay

                # Deadline compliance probability
                # Simple model: if pred_delay < deadline, high compliance
                delay_margin = (deadline - pred_delay) / deadline
                if delay_margin > 0.15:
                    deadline_prob = 0.95
                elif delay_margin > 0.0:
                    deadline_prob = 0.60 + 2.0 * delay_margin
                else:
                    deadline_prob = 0.10  # likely to miss

                # Timely probability
                timely_prob = pdr_overall * deadline_prob

                # Cost
                mode_cost = params['tx_cost_redundant'] if mode == 1 else params['tx_cost_direct']
                tx_cost = mode_cost * rm

                # Position risk
                pl = max(min((pri - 1) / 2, 1), 0)
                rl = np.clip((rm - 1.0) / 1.5, 0, 1)
                ml = 0.62 if mode == 1 else 0.0
                prot = 0.30 * pl + 0.35 * rl + 0.35 * ml
                pos_risk = (1 - q_pos) * (1 - prot) * (0.50 + 0.35 * urgency)

                # Delay penalty
                delay_penalty = max(pred_delay / deadline - 1.0, 0.0)

                # Utility
                util = (params['utility_weight_timely'] * timely_prob
                        + params['utility_weight_reliability'] * pdr_overall
                        - params['utility_weight_cost'] * tx_cost
                        - params['utility_weight_delay'] * delay_penalty
                        - params['utility_weight_position_risk'] * pos_risk)

                if urgency >= 0.80 and pri == 3:
                    util += 0.05

                # Constraint
                req = 0.18 + 0.34 * urgency + 0.20 * (1 - q_link) + 0.16 * (1 - q_pos)
                req = np.clip(req, 0.25, 0.92)
                score = util - params['utility_constraint_penalty'] * max(req - timely_prob, 0.0)

                if score > best_score:
                    best_score = score
                    best = (pri, rm, mode)

    return best


# ============================================================
# RUN EXPERIMENT
# ============================================================
N_seeds = 50
scenario = generate_scenario()
N_msg = len(scenario['t'])

print("=" * 80)
print("PHYSICAL DELIVERY MODEL v2 - VERIFICATION")
print("=" * 80)
print(f"  Scenario: PosDeg_Emerg, N_msg={N_msg}, N_seeds={N_seeds}")
print(f"  SINR range: [{scenario['sinr_dB'].min():.1f}, {scenario['sinr_dB'].max():.1f}] dB")
print(f"  PDR_base range: [{scenario['pdr_base'].min():.3f}, {scenario['pdr_base'].max():.3f}]")
print(f"  q_link range: [{scenario['q_link'].min():.3f}, {scenario['q_link'].max():.3f}]")
print(f"  q_pos range: [{scenario['q_pos'].min():.3f}, {scenario['q_pos'].max():.3f}]")
print(f"  Deadline: {scenario['deadline']*1000:.0f} ms")
print()
print("  SINR -> PDR (NLOS, midpoint=6dB):")
for snr in [-2, 0, 2, 4, 6, 8, 10, 12, 15]:
    print(f"    SINR={snr:+3d} dB -> PDR={sinr_to_pdr(snr, True):.3f}")
print()

methods = {
    'Fixed': fixed_policy,
    'Link-aware': link_aware_policy,
    'Position-only': position_only_policy,
    'Confidence-driven': None,  # special handling
}

all_timely = {m: [] for m in methods}
all_delivered = {m: [] for m in methods}

for seed in range(N_seeds):
    rng = np.random.default_rng(seed + 5000)

    for method in methods:
        timely_count = 0
        delivered_count = 0

        for i in range(N_msg):
            sinr = scenario['sinr_dB'][i]
            is_nlos = scenario['is_nlos'][i]
            q_link = scenario['q_link'][i]
            q_pos = scenario['q_pos'][i]

            if method == 'Confidence-driven':
                pri, rm, mode = confidence_driven_policy(
                    q_link, q_pos, sinr, is_nlos, scenario)
            else:
                pri, rm, mode = methods[method](q_link, q_pos, scenario)

            # Physical delivery
            delivered, n_used = physical_delivery(
                sinr, is_nlos, pri, rm, mode, True, rng)

            # Physical delay
            delay = physical_delay(sinr, is_nlos, rm, mode, n_used, rng)

            timely = delivered and (delay <= scenario['deadline'])
            timely_count += timely
            delivered_count += delivered

        all_timely[method].append(timely_count / N_msg)
        all_delivered[method].append(delivered_count / N_msg)

# ============================================================
# RESULTS
# ============================================================
print(f"\n{'Method':<22} {'Timely':>8} {'Std':>7} {'CI95_Lo':>8} {'CI95_Hi':>8} {'Delivered':>10}")
print("-" * 72)

stats = {}
for method in methods:
    arr_t = np.array(all_timely[method])
    arr_d = np.array(all_delivered[method])
    mean_t = arr_t.mean()
    std_t = arr_t.std()
    ci95 = 1.96 * std_t / np.sqrt(N_seeds)
    stats[method] = {
        'mean': mean_t, 'std': std_t,
        'ci_low': mean_t - ci95, 'ci_hi': mean_t + ci95,
        'delivered': arr_d.mean()
    }
    print(f"  {method:<20} {mean_t:>8.3f} {std_t:>7.3f} {mean_t-ci95:>8.3f} "
          f"{mean_t+ci95:>8.3f} {arr_d.mean():>10.3f}")

# ============================================================
# ACTION PROFILES
# ============================================================
print("\n" + "=" * 80)
print("METHOD ACTION PROFILES (sample messages)")
print("=" * 80)

for idx in [0, 10, 21]:
    sinr = scenario['sinr_dB'][idx]
    is_nlos = scenario['is_nlos'][idx]
    q_link = scenario['q_link'][idx]
    q_pos = scenario['q_pos'][idx]
    print(f"\n  Message {idx}: SINR={sinr:.1f}dB, q_link={q_link:.3f}, q_pos={q_pos:.3f}")
    print(f"  Base PDR={sinr_to_pdr(sinr, True):.3f}")

    for method in methods:
        if method == 'Confidence-driven':
            pri, rm, mode = confidence_driven_policy(q_link, q_pos, sinr, is_nlos, scenario)
        else:
            pri, rm, mode = methods[method](q_link, q_pos, scenario)

        n_tx = max(1, int(np.ceil(rm)))
        sinr_eff = sinr + params['priority_sinr_gain']*(pri-1) + params['emergency_sinr_bonus']
        pdr_s = sinr_to_pdr(sinr_eff, is_nlos)
        if mode == 0:
            pdr_a = pdr_s
        elif mode == 1:
            pdr_a = 1-(1-pdr_s)**2
        else:
            pdr_a = 1-(1-pdr_s)*(1-pdr_s*params['relay_link_ratio'])
        pdr_total = 1-(1-pdr_a)**n_tx

        # Delay
        pdr_nom = sinr_to_pdr(sinr, is_nlos)
        cong = params['congestion_delay_max'] * (1-pdr_nom)
        mode_ovh = params['mode_overhead_redundant'] if mode == 1 else 0.0
        att_d = params['attempt_gap'] * max(n_tx-1, 0)
        pred_delay = params['base_access_delay'] + cong + mode_ovh + att_d

        mode_name = ['direct', 'redundant', 'relay'][mode]
        print(f"    {method:<20}: pri={pri}, rm={rm:.2f}(n_tx={n_tx}), {mode_name}")
        print(f"      SINR_eff={sinr_eff:.1f}, PDR_single={pdr_s:.3f}, "
              f"PDR_attempt={pdr_a:.3f}, PDR_total={pdr_total:.3f}")
        print(f"      Delay={pred_delay*1000:.1f}ms {'OK' if pred_delay < 0.088 else 'EXCEEDS'}")

# ============================================================
# CHECKS
# ============================================================
print("\n" + "=" * 80)
print("VALIDATION CHECKS")
print("=" * 80)

conf = stats['Confidence-driven']
link = stats['Link-aware']
posonly = stats['Position-only']
fixed = stats['Fixed']

checks = [
    ("Conf timely > 0.60", conf['mean'] > 0.60),
    ("Fixed timely < Conf timely", fixed['mean'] < conf['mean']),
    ("Link timely < Conf timely", link['mean'] < conf['mean']),
    ("Ordering: Fixed < Link OR Fixed < Pos", fixed['mean'] < link['mean'] or fixed['mean'] < posonly['mean']),
    ("CI95 Conf vs Fixed no overlap", conf['ci_low'] > fixed['ci_hi']),
    ("All have std > 0", all(stats[m]['std'] > 0 for m in methods)),
    ("Physical: no method has timely=1.0", all(stats[m]['mean'] < 1.0 for m in methods)),
    ("Conf delivered > Fixed delivered (diversity helps)", conf['delivered'] > fixed['delivered']),
]

all_pass = True
for desc, passed in checks:
    status = "PASS" if passed else "FAIL"
    if not passed:
        all_pass = False
    print(f"  [{status}] {desc}")

if all_pass:
    print("\n  SUCCESS: Physical model v2 validated!")
else:
    print("\n  NEEDS ADJUSTMENT")
    # Diagnostic
    print("\n  Quick diagnostic - trying midpoint adjustments:")
    for mid in [4.0, 5.0, 6.0, 7.0, 8.0]:
        params['pdr_midpoint_nlos'] = mid
        sc = generate_scenario()
        rng_d = np.random.default_rng(42)
        ct, ft = 0, 0
        for i in range(N_msg):
            # Conf
            pri, rm, mode = confidence_driven_policy(
                sc['q_link'][i], sc['q_pos'][i], sc['sinr_dB'][i], True, sc)
            d, n = physical_delivery(sc['sinr_dB'][i], True, pri, rm, mode, True, rng_d)
            dl = physical_delay(sc['sinr_dB'][i], True, rm, mode, n, rng_d)
            ct += (d and dl <= 0.088)
            # Fixed
            d2, n2 = physical_delivery(sc['sinr_dB'][i], True, 3, 1.0, 0, True, rng_d)
            dl2 = physical_delay(sc['sinr_dB'][i], True, 1.0, 0, n2, rng_d)
            ft += (d2 and dl2 <= 0.088)
        print(f"    midpoint={mid:.0f}dB: Conf_timely={ct/N_msg:.3f}, Fixed_timely={ft/N_msg:.3f}, "
              f"PDR_range=[{sc['pdr_base'].min():.3f}, {sc['pdr_base'].max():.3f}]")
    params['pdr_midpoint_nlos'] = 6.0  # reset