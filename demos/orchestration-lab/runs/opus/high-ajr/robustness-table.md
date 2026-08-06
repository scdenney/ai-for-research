# Robustness table — AJR (2001) IV replication and stress tests

Outcome `logpgp95` on institutions `avexpr`; `avexpr` instrumented by log
settler mortality `logem4`. 2SLS estimated with `AER::ivreg` (available, so
second-stage SEs are exact — no two-stage-`lm` fallback was needed). The
first-stage F is the excluded-instrument F (test that `logem4 = 0` in
`avexpr ~ logem4 + same controls`); with a single instrument it equals the
square of the instrument's *t*-statistic, cross-checked two ways (AER's
`diagnostics=TRUE` weak-instruments F and `car::linearHypothesis`) — the two
agree exactly. Weak-instrument rule of thumb: F ≈ 10.

| Specification | N | OLS (avexpr) | 2SLS (avexpr) | First-stage coef (logem4) | First-stage F | Identified? |
|---|---|---|---|---|---|---|
| Base (bivariate) | 64 | 0.522 | 0.944 | -0.607 | 22.9 | strong |
| + latitude | 64 | 0.468 | 0.996 | -0.510 | 13.1 | strong |
| + continent (africa, asia) | 64 | 0.434 | 0.839 | -0.533 | 11.0 | strong (marginal) |
| Drop neo-Europes | 60 | 0.487 | 1.281 | -0.391 | 8.6 | **weak** |
| Africa only | 27 | 0.302 | 2.400 | -0.108 | 0.3 | **collapsed** |

**Weakly identified (F < ~10):** Drop neo-Europes and Africa only. The 2SLS point estimates in these
rows should **not** be read at face value.

In every row the sample and controls are held common across OLS, 2SLS, and
the first stage, so the three estimates in a row are directly comparable.
Across the well-identified specifications 2SLS sits well above OLS; in the
flagged rows the 2SLS estimate inflates as the first stage weakens, which is
weak-instrument bias, not a larger true effect.
