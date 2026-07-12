# Robustness table — AJR headline IV result

Outcome: `logpgp95`. Endogenous regressor: `avexpr`. Excluded instrument: `logem4`.
2SLS estimated with `AER::ivreg`. First-stage F is the partial F-statistic
(via `car::linearHypothesis`) on `logem4` in the regression of `avexpr` on the
instrument and any included controls, within each spec's complete-case sample.

| Spec | N | OLS (avexpr) | 2SLS (avexpr) | First-stage coef. (logem4) | First-stage F | Weak instrument? |
|---|---:|---:|---:|---:|---:|:---:|
| (1) Baseline: bivariate | 64 | 0.522 (se 0.061) | 0.944 (se 0.157) | -0.607 | 22.95 | No |
| (2) + latitude | 64 | 0.468 (se 0.064) | 0.996 (se 0.222) | -0.510 | 13.09 | No |
| (3) + continent dummies | 64 | 0.434 (se 0.054) | 0.839 (se 0.191) | -0.533 | 11.01 | No |
| (4) Drop neo-Europes | 60 | 0.487 (se 0.076) | 1.281 (se 0.358) | -0.391 | 8.65 | **YES (F < 10)** |
| (5) Africa only | 27 | 0.302 (se 0.106) | 2.400 (se 3.987) | -0.108 | 0.30 | **YES (F < 10)** |

Note: standard errors for spec (5) (Africa only, N = 27) and any spec flagged
weak should be read with caution regardless of nominal significance. With a single
just-identified instrument, a weak first stage leaves the sampling distribution of
the 2SLS estimator badly behaved and invalidates conventional standard errors/CIs.
