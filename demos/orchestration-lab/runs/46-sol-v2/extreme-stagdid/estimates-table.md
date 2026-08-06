# ATT estimates

All effects are in log points of teen employment.

| Estimator | ATT | Standard error | Control/comparison group |
|---|---:|---:|---|
| Naive TWFE (post x ever-treated) | -0.0365 | 0.0133 | Pooled TWFE; already-treated counties may act as controls |
| Callaway-Sant'Anna | -0.0398 | 0.0121 | Never-treated and not-yet-treated counties |
| Callaway-Sant'Anna | -0.0400 | 0.0120 | Never-treated counties only |
| Sun-Abraham | -0.0400 | 0.0118 | Never-treated reference cohort; cohort x event-time interactions |
| Roth-Sant'Anna (staggered) | -0.0471 | 0.0116 | Not-yet-/never-treated cohorts; native efficient adjustment |

*Notes:* TWFE and Sun-Abraham standard errors are clustered by county. Callaway-Sant'Anna uses analytical county-level clustered inference. Roth-Sant'Anna reports `staggered`'s native unit-level standard error. All estimators are unweighted and include no covariates.
