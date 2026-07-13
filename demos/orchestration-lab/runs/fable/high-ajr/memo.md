# Memo: how much weight will the AJR headline bear?

**Estimation path.** 2SLS via `AER::ivreg` (available; no two-stage `lm` fallback needed).
The first-stage F is the F-test on the excluded instrument `logem4` in the first-stage
regression `avexpr ~ logem4 + controls`, with any controls partialled out — the correct
weak-instrument diagnostic. OLS and 2SLS are deterministic.

## The headline replicates

On the full 64-country base sample the manuscript's headline reproduces cleanly. OLS
regresses log 1995 income on expropriation-risk protection at **0.52**; instrumenting
`avexpr` with settler mortality lifts the coefficient to **0.94** — roughly 1.8× OLS, the
gap AJR emphasize. The first stage is strong (settler-mortality coefficient −0.61,
**F = 22.9**), so the instrument is doing real work. This is a faithful replication.

## What survives the stress tests

The headline is robust to the two control-set perturbations. Adding **latitude** leaves a
2SLS estimate of 1.00 with **F = 13.1**; adding **continent dummies** (`africa`, `asia`)
gives 2SLS 0.84 with **F = 11.0**. In both, 2SLS stays well above OLS and the first stage
clears the rule-of-thumb F ≈ 10 (the continent spec only marginally). The core claim —
institutions instrumented by settler mortality predict long-run income, more strongly than
OLS — holds across reasonable observable controls.

## What does not survive

The result is **not** robust to sample composition. Dropping the four neo-Europes
(AUS, CAN, NZL, USA) pushes the first stage into weak territory: **F = 8.65**, below 10.
The 2SLS point estimate *rises* to 1.28 — but that inflation is the expected symptom of a
weakening instrument, not corroboration, and the estimate is not reliable. Restricting to
**Africa only** (n = 27) collapses identification entirely: the first-stage coefficient is
−0.11 with **F = 0.30**. Settler mortality carries essentially no information about
expropriation risk within Africa, and the 2SLS figure of 2.40 is noise, not a coefficient.

## What the manuscript may and may not claim

It **may** claim that AJR's headline replicates on this sample and is robust to latitude and
continent controls: a strong-to-adequate first stage and a 2SLS effect near 0.8–1.0,
materially above OLS.

It **may not** claim the result is robust to sample restriction, nor that the IV identifies
the institutions→income effect within Africa. Critically, the collapse cuts **neither** way:
a weak or dead instrument is *uninformative*. The Africa-only 2.40 is not evidence against
the effect, and the drop-neo-Europes 1.28 is not evidence for it — both first stages are too
weak to license any 2SLS reading. The honest summary: the headline is identified in the
broad cross-continental sample and silent — not contradicted — in the narrow ones. The
manuscript is entitled to the replication; it is not entitled to treat the finding as
established beyond the sample whose variation identifies it.
