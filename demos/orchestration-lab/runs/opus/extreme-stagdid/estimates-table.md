# Estimates — ATT of a state minimum-wage increase on log county teen employment

Outcome: `lemp` (log employment). Panel: 500 counties, 2003-2007 (`did::mpdta`).
All estimators are unconditional (no covariates) for a clean cross-estimator comparison.

| Estimator | ATT | Std. error | Control / comparison group |
|---|---|---|---|
| (a) Naive static TWFE (post x ever-treated, county+year FE) | -0.0365 | 0.0133 | All units; FE-implied (Goodman-Bacon weighted); cluster = county |
| (b) Callaway-Sant'Anna, aggte(simple) | -0.0398 | 0.0120 | Not-yet-treated (incl. never-treated); native county bootstrap |
| (b) Callaway-Sant'Anna, aggte(simple) | -0.0400 | 0.0124 | Never-treated only; native county bootstrap |
| (c) Sun-Abraham (fixest::sunab), agg=ATT | -0.0400 | 0.0118 | Never-treated cohort as clean controls; cluster = county |
| (c) Roth-Sant'Anna (staggered::staggered, simple) | -0.0471 | 0.0116 | Never-treated (g = Inf); native unit-level (Neyman) SE |

Reference (not a step-1 estimator):
| Callaway-Sant'Anna, aggte(dynamic) overall | -0.0774 | 0.0206 | Not-yet-treated; avg of post-treatment event-time ATTs |

## Goodman-Bacon decomposition of the naive TWFE (step 2)

| 2x2 comparison type | Weight | Avg. estimate | Can carry negative weight? |
|---|---|---|---|
| Treated vs Untreated (clean, vs never-treated) | 0.8628 | -0.0407 | No |
| Earlier vs Later Treated (later group = not-yet-treated control) | 0.0833 | -0.0198 | No |
| Later vs Earlier Treated (already-treated used as control) | 0.0539 | 0.0046 | **Yes** |

- Weighted average of all 2x2s reproduces TWFE: **-0.0365** (feols TWFE: -0.0365).
- Share of identifying weight on the negative-weight-prone bucket: **5.4%**.
- Share on clean treated-vs-never comparisons: **86.3%**.

## Pre-trends (step 3)

- Pre-treatment event-time ATTs (e < 0): largest pointwise |t| = **2.06**; uniform-band critical value = 2.53; any pre-period significant under the uniform band? **no**.
- Event-time estimates: e=-3: 0.0298 (se 0.0144); e=-2: -0.0024 (se 0.0133); e=-1: -0.0243 (se 0.0152); e=0: -0.0189 (se 0.0122); e=1: -0.0536 (se 0.0172); e=2: -0.1363 (se 0.0371); e=3: -0.1008 (se 0.0363)

