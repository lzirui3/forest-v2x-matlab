# Paper Method Section Draft — Predictive Drift-Plus-Penalty Scheduler

Drop-in draft for the methods/experiments sections. Wording follows the verified
parameter-grounding audit (`parameter_theoretical_grounding_audit_cn.md`); keep
the allowed/forbidden phrasing in §5.

---

## 1. System model and decision problem

At each discrete slot \(t\) a vehicle selects a transmission action
\(a_t=(\pi,m,\rho)\) from a finite set \(\mathcal{A}\): priority class
\(\pi\in\{1,2,3\}\), redundancy mode \(m\in\{\text{direct},\text{redundant},\text{relay}\}\),
and rate multiplier \(\rho\). The forest channel state (slow SINR envelope,
NLOSv geometry, blind-zone gate) and the positioning-confidence state
\(q_{\mathrm{pos}}\) evolve along the route. The scheduler minimises long-run
communication cost subject to two **time-average constraints**:

- **Reliability** \( \overline{\mathrm{PRR}} \ge R_{\mathrm{req}}(\text{class}) \),
  where reliability is, per 3GPP TS 22.186, the fraction of messages delivered
  within the required latency. We therefore use a single timely-delivery metric
  \(\Pr[\text{delivered}\wedge\text{within deadline}]\) rather than separate
  "success" and "timeliness" objectives.
- **Positioning integrity** \( \mathrm{prot}(a_t)\ge P_{\mathrm{req}}(\text{state}) \),
  a protection-level requirement that rises with positioning risk in the
  canopy-occluded (blind-zone) stages.

## 2. Predictive drift-plus-penalty controller

We replace fixed objective weights with **virtual queues** (Lyapunov
drift-plus-penalty [Neely]). For each constraint \(c\) with instantaneous
slack \(g_c(t)=R_c-\mathrm{ach}_c(a_t)\) we maintain
\[
Z_c(t+1)=\min\!\big(\max(Z_c(t)+g_c(t),0),\,Z_{\max}\big),
\]
and choose the action sequence minimising, over a receding horizon \(H\),
\[
\min_{a_t,\dots,a_{t+H-1}}\ \sum_{\tau=0}^{H-1}\Big[\,V\,p(a_{t+\tau})+\sum_c Z_c(t+\tau)\,g_c(a_{t+\tau})\Big],
\]
applying only \(a_t\) and receding (model predictive control). Here \(p(\cdot)\)
is the per-slot penalty (communication cost and risk regularisation minus a
value-of-information reward), and the backlog \(Z_c(t)\) acts as the
time-varying Lagrange multiplier \(V\lambda_c\). This yields the standard
\(O(1/V)\) optimality / \(O(V)\) backlog trade-off and time-average constraint
satisfaction (mean-rate stability), neither of which a fixed-weight penalty
provides. The route-predictable blind-zone / relay-window / message-stage
structure is used as a deterministic forecast over the horizon (per-packet fast
fading is not previewed); \(H=1\) recovers plain drift-plus-penalty.

The controller exposes **two interpretable knobs** — \(V\) (optimality–feasibility
trade-off) and \(Z_{\max}\) (maximum constraint shadow price) — in place of the
five hand-set multipliers of the prior heuristic.

## 3. Parameter provenance

Physical-layer parameters are standards-derived: transmit power 23 dBm (C-V2X
Power Class 3, 3GPP TS 36.101); noise floor \(-94\) dBm
(\(-174+10\log_{10}B+\mathrm{NF}\)); LOS path-loss intercept 47.8 dB (Friis at
5.9 GHz, equivalently TR 37.885); NLOSv excess loss \(\mu=5/9\) dB,
\(\sigma=4/4.5\) dB (TR 37.885 §6.2.1). Per-class reliability targets follow the
TS 22.186 tiers (90% / 99.99% / 99.999%) with an explicitly reported
simulator-achievability derating; latency anchors follow TS 22.185 and ETSI
TR 102 638 / EN 302 637-2. The mapping of message classes to tiers is stated as
an engineering interpretation, not a normative clause. Cost/risk preference
weights are reported as dimensionless engineering choices with a sensitivity
sweep, not derived constants.

## 4. Validation

On the forest-geometry tuning scene (20 seeds, common random numbers), the
frozen-parameter predictive controller is statistically indistinguishable from
the deployed hand-tuned heuristic on **both** reliability (\(\Delta=-0.0009\),
\(p=0.21\)) and cost (\(p=0.09\)). In a **frozen-parameter held-out study** over
the framework's held-out V2X-Seq scenes (10013/10007/10015) and two unseen
degradation regimes, the controller — kept at its single tuned operating point —
matches or exceeds the heuristic's reliability on every regime (significantly
higher on all three held-out V2X-Seq scenes, including the hardest, at a higher
transmission cost), with timely-rate differences \(\le 0.3\) percentage points
throughout. Emergency delivery within the 77 ms deadline is infeasible for every
method inside the deepest blind-zone stage; we report this as an applicability
boundary, quantified by the growth of the reliability virtual queue there.

## 5. Allowed / forbidden wording (reviewer safety)

| Claim | Allowed | Forbidden |
|---|---|---|
| Multipliers | "time-varying virtual-queue multipliers with a mean-rate-stability feasibility certificate" | "globally optimal weights" |
| Reliability targets | "3GPP TS 22.186-tiered targets with a reported achievability derating; class→tier is an engineering interpretation" | "standards-mandated per-class requirements" |
| Physical layer | "standards-derived (TS 36.101 / Friis / TR 37.885)" | "field-measured forest V2X PER" |
| Held-out result | "frozen-parameter generalisation: matches/exceeds the heuristic on held-out scenes" | "uniformly outperforms" (it costs more on some scenes) |
| Negative cases | "applicability boundary quantified by virtual-queue growth" | hide in averages / tune away |
| Cost weights | "dimensionless engineering preference weights, reported with sensitivity" | "theoretically derived" |
