# AJR IV robustness analysis

All estimates use `AER::ivreg` for 2SLS. Within each row, one complete-case sample (for `logpgp95`, `avexpr`, `logem4`, and that row's controls) is used consistently for OLS, IV, and both first-stage regressions.

The reported first-stage F is the excluded-instrument partial F: the nested-model F comparison of a first stage without `logem4` against the otherwise identical first stage including `logem4`. With one excluded instrument, it equals the squared `logem4` t statistic (verified in `script.R`). Values below 10 are flagged; their 2SLS point estimates should not be treated as reliable.

| Specification | N | OLS: avexpr | 2SLS: avexpr | First stage: logem4 | Partial F (logem4) | Identification status |
|---|---:|---:|---:|---:|---:|---|
| Bivariate full sample | 64 | 0.522 | 0.944 | -0.607 | 22.947 | Not weak |
| Full sample + latitude | 64 | 0.468 | 0.996 | -0.510 | 13.093 | Not weak |
| Full sample + Africa and Asia | 64 | 0.434 | 0.839 | -0.533 | 11.006 | Not weak |
| Bivariate, excluding neo-Europes | 60 | 0.487 | 1.281 | -0.391 | 8.646 | Weak (F < 10; 2SLS not reliable) |
| Bivariate, Africa only | 27 | 0.302 | 2.400 | -0.108 | 0.298 | Weak (F < 10; 2SLS not reliable) |
