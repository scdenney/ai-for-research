# Estimates table — EXTREME (staggered-adoption DiD reconciliation)

500 counties, 2003–2007, ATT on log teen employment (`lemp`), `did::mpdta`.

| Estimator | Control/comparison group | ATT | SE | 95% CI |
|---|---|---:|---:|---|
| Naive TWFE | all counties, county+year FE | −0.0365 | 0.0133 | [−0.063, −0.010] |
| Callaway-Sant'Anna | not-yet-treated | −0.0398 | 0.0117 | [−0.063, −0.017] |
| Callaway-Sant'Anna | never-treated | −0.0400 | 0.0130 | [−0.065, −0.014] |
| Sun-Abraham (`fixest::sunab`) | never-treated (last-cohort ref.) | −0.0400 | 0.0118 | [−0.063, −0.017] |
| Roth-Sant'Anna (`staggered`), **correctly coded** (`Inf`) | never-treated | −0.0471 | 0.0116 | [−0.070, −0.024] |
| Roth-Sant'Anna (`staggered`), **wrongly coded** (`0`) — the trap | (misspecified: `0` read as a real early cohort, not never-treated) | −0.3704 | 0.1256 | [−0.617, −0.124] |

**The five correctly-specified estimators agree**: ATT ≈ −0.037 to −0.047 (a 3.7–4.7% decline in teen employment following a state minimum-wage increase). The sixth row is not a sixth estimate of the same quantity — it is what happens when `mpdta$first.treat`'s own convention (`0` = never treated) is passed unchanged into a package whose documented convention is `Inf` = never treated. The result is ten times too large in magnitude, wrong enough that a naive reading of it in isolation (a supposed 37% employment decline from a minimum-wage increase) should itself have been a stop signal.

## Goodman-Bacon decomposition of the naive TWFE

| Comparison type | Weight | Avg. 2×2 estimate |
|---|---:|---:|
| Treated vs. untreated | 86.3% | −0.0407 |
| Earlier vs. later treated | 8.3% | −0.0198 |
| **Later vs. earlier treated (the "forbidden"/negative-weight-risk type)** | **5.4%** | +0.0046 |

Only 5.4% of the naive TWFE's identifying weight sits on the comparison type that can carry negative weight under treatment-effect heterogeneity. That is why the naive TWFE estimate (−0.0365) sits inside the range the modern estimators produce rather than diverging from it: the textbook critique is real in general, but in this application the design is close enough to a clean treated-vs-never-treated comparison that it does not materially bite.

## Event-study / pre-trend check (Callaway-Sant'Anna, not-yet-treated controls)

| Event time | ATT | SE | 95% simultaneous CI |
|---:|---:|---:|---|
| −2 | −0.0024 | 0.0136 | [−0.037, 0.032] |
| −1 | −0.0243 | 0.0148 | [−0.061, 0.013] |
| 0 | −0.0189 | 0.0130 | [−0.051, 0.014] |
| +1 | −0.0536 | 0.0177 | [−0.098, −0.009] |

Both pre-treatment coefficients (−2, −1) are statistically indistinguishable from zero, supporting parallel trends. The effect is not statistically significant in the treatment year itself but grows and becomes significant by the following year — the pooled single-number ATT (−0.04-ish) understates that the effect appears to build over time rather than land all at once.
