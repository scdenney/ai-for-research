# Robustness table — AJR (2001) IV headline: `logpgp95 ~ avexpr`, instrument `logem4`

**Structural model:** `logpgp95 ~ avexpr`, with `avexpr` (expropriation-risk institutions) instrumented by `logem4` (log settler mortality). Base sample: 64 countries (`ivdoctr::colonial`).
**2SLS engine:** `AER::ivreg` (available) — reported 2SLS standard errors are the correct IV standard errors, not the naive two-stage approximation.
**First-stage F:** partial *F* on the *excluded* instrument `logem4`, via `car::linearHypothesis(fs, "logem4 = 0")` (correct with or without controls). Weak-instrument flag: first-stage *F* < 10.

| Specification | N | OLS β̂(avexpr) (SE) | 2SLS β̂(avexpr) (SE) | 2SLS 95% CI | 1st-stage β̂(logem4) (SE) | 1st-stage F | Identification |
|---|---:|---:|---:|---:|---:|---:|---|
| Base (bivariate) | 64 | 0.52 (0.06) | **0.94 (0.16)** | [0.64, 1.25] | −0.61 (0.13) | **22.9** | strong |
| + latitude (`lat_abst`) | 64 | 0.47 (0.06) | 1.00 (0.22) | [0.56, 1.43] | −0.51 (0.14) | 13.1 | strong |
| + continents (`africa`, `asia`) | 64 | 0.43 (0.05) | 0.84 (0.19) | [0.46, 1.21] | −0.53 (0.16) | 11.0 | strong (marginal) |
| Drop neo-Europes (AUS/CAN/NZL/USA) | 60 | 0.49 (0.08) | 1.28 (0.36) | [0.58, 1.98] | −0.39 (0.13) | 8.6 | ⚠️ **WEAK** (F < 10) |
| Africa only (`africa == 1`) | 27 | 0.30 (0.11) | 2.40 (3.99) | [−5.41, 10.21] | −0.11 (0.20) | 0.3 | ⚠️ **COLLAPSED** (F ≈ 0) |

**Reading the table.**

- The headline replicates: in the base sample the 2SLS coefficient (0.94) is far above its OLS counterpart (0.52), on a strong first stage (F = 22.9; instrument coefficient −0.61, correctly signed — higher settler mortality → worse institutions).
- Adding latitude or continent controls leaves the 2SLS estimate in the same 0.84–1.00 band, still well above OLS, with a first stage that weakens but stays above the rule-of-thumb threshold (F = 13.1 and 11.0).
- **Weakly-identified specs — 2SLS point estimates in these rows are not reliable:**
  - *Drop neo-Europes* (F = 8.6): first stage falls below 10. The 2SLS estimate (1.28) is subject to weak-instrument bias and its SE is understated; treat it as uninformative, not as evidence.
  - *Africa only* (F = 0.3): the first stage has collapsed — the instrument coefficient (−0.11) is statistically indistinguishable from zero. The 2SLS estimate (2.40, SE 3.99, CI spanning [−5.4, 10.2]) is meaningless and must not be reported as a point estimate.

Numbers independently reproduced from scratch by a second, blind estimation (different vendor) — see `memo.md`. Full precision in `results.csv`; figure in `robustness-figure.png`.
