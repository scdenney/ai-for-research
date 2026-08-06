# ATT estimates

| Estimator | ATT | Standard error | Control/comparison group | Inference |
|:--|--:|--:|:--|:--|
| Naive TWFE | -0.0365 | 0.0133 | Implicit Bacon mix of never-, not-yet-, and already-treated comparisons | County-clustered |
| Callaway-Sant'Anna | -0.0398 | 0.0123 | Not-yet-treated (including never-treated) | County-level multiplier bootstrap |
| Callaway-Sant'Anna | -0.0400 | 0.0119 | Never-treated only (`first.treat = 0`) | County-level multiplier bootstrap |
| Sun-Abraham | -0.0400 | 0.0118 | Never-treated reference cohort (`first.treat = 0`) | County-clustered |
| Roth-Sant'Anna | -0.0471 | 0.0116 | Eligible not-yet-treated cohorts; never-treated recoded to `Inf` | Native design-based SE |

All specifications use `lemp` as the outcome and are unadjusted for `lpop`, so differences are not due to different covariate sets. Callaway-Sant'Anna uses the doubly robust estimator with an intercept-only covariate formula and 999 multiplier-bootstrap iterations.
