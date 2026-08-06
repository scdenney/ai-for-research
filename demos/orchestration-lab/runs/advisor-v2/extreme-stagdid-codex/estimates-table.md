| Estimator | ATT (log points) | Standard error | Control / comparison group |
|---|---:|---:|---|
| Naive TWFE | -0.0365 | 0.0133 | Post x ever-treated; county and year FE; county-clustered SE |
| Callaway-Sant'Anna | -0.0398 | 0.0129 | Not-yet-treated (includes never-treated); county-clustered multiplier bootstrap |
| Callaway-Sant'Anna | -0.0400 | 0.0122 | Never-treated; county-clustered multiplier bootstrap |
| Sun-Abraham interaction-weighted | -0.0400 | 0.0118 | Never-treated counties (first.treat = 0) as reference; county and year FE; county-clustered SE |

All estimates are unadjusted for covariates and use `lemp` as the outcome, matching the requested TWFE specification.
