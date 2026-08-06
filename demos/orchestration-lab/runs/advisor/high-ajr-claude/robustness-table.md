# Robustness table: AJR (2001) headline IV result

2SLS path: `AER::ivreg` (available on this system) used for every specification;
reported first-stage F is the classical (homoskedastic) partial F on the excluded
instrument (`logem4`), read off `summary(ivreg_fit, diagnostics = TRUE)`. This is the
correct pairing with the Staiger-Stock ~10 rule used below, but it is not a
heteroskedasticity-robust or Montiel Olea-Pflueger effective F, which could differ
under non-classical errors. SEs on the OLS/2SLS coefficients are likewise classical.
N is `nobs()` on the fitted model, asserted equal across OLS and 2SLS per spec.

| Spec | N | OLS (avexpr), SE | 2SLS (avexpr), SE | 1st-stage coef (logem4) | 1st-stage F | Weak instrument (F<10)? |
|---|---|---|---|---|---|---|
| Headline (bivariate) | 64 | 0.522, 0.061 | 0.944, 0.157 | -0.607 | 22.95 | No |
| (a) + latitude | 64 | 0.468, 0.064 | 0.996, 0.222 | -0.510 | 13.09 | No |
| (b) + continent dummies | 64 | 0.434, 0.054 | 0.839, 0.191 | -0.533 | 11.01 | No |
| (c) drop neo-Europes | 60 | 0.487, 0.076 | [1.281], 0.358 | -0.391 | 8.65 | **YES** |
| (d) Africa only | 27 | 0.302, 0.106 | [2.400], 3.987 | -0.108 | 0.30 | **YES** |

Notes: Outcome is `logpgp95`; endogenous regressor is `avexpr`; excluded instrument is `logem4`.
Spec (a) adds `lat_abst`; (b) adds `africa` and `asia`; (c) drops AUS/CAN/NZL/USA (`shortnam`);
(d) restricts to `africa == 1`. Rule of thumb: first-stage F below ~10 flags a weak instrument;
2SLS point estimates in flagged rows are bracketed `[...]` and should not be read as reliable
point estimates of the causal effect -- the weak-instrument caveat travels with the number.

**Anderson-Rubin 95% confidence sets (weak-instrument specs only).** The Wald CI implied by
the 2SLS SE above assumes a strong instrument; AR inversion does not, so it is the right tool
to characterize what these two specs can and cannot pin down:

- (c) drop neo-Europes: [0.85, 3.30]
- (d) Africa only: essentially unbounded (95% set still open at grid edge +/-50)

The Africa-only set is essentially unbounded -- direct evidence, not an inference from a low F,
that this subsample cannot identify the coefficient with this instrument.
