# AJR IV robustness checks

Outcome: `logpgp95`; endogenous regressor: `avexpr`; excluded instrument: `logem4`.
Each row constructs one complete-case sample before estimating both OLS and 2SLS, so the two estimates in a row use identical observations.

| Specification | Controls in OLS, 2SLS, and first stage | N | OLS: avexpr | 2SLS: avexpr | First stage: logem4 | Partial F for logem4 | F-test p-value | Weak IV (F < 10)? |
|---|---|---:|---:|---:|---:|---:|---:|---|
| Bivariate | None | 64 | 0.522 | 0.944 | -0.607 | 22.947 | <0.001 | No |
| Absolute latitude | lat_abst | 64 | 0.468 | 0.996 | -0.510 | 13.093 | <0.001 | No |
| Africa and Asia indicators | africa, asia | 64 | 0.434 | 0.839 | -0.533 | 11.006 | 0.002 | No |
| Exclude AUS/CAN/NZL/USA | None | 60 | 0.487 | 1.281 | -0.391 | 8.646 | 0.005 | Yes |
| Africa only | None | 27 | 0.302 | 2.400 | -0.108 | 0.298 | 0.590 | Yes |

Notes: 2SLS is estimated with `AER::ivreg()`. The reported partial F is the conventional homoskedastic first-stage F test for adding `logem4` to a first stage that already includes the row's controls (computed with `car::linearHypothesis()`; equivalently, the nested-model F test). `Yes` applies the common rule-of-thumb threshold F < 10; it is a diagnostic, not a formal validity test.
