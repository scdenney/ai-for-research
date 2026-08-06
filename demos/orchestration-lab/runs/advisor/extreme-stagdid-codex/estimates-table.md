# Staggered-adoption DiD estimates

Outcome: log teen employment (`lemp`).

| Estimator | ATT | SE | Control/comparison group |
|---|---:|---:|---|
| Naive TWFE | -0.0365 | 0.0133 | Implicit mixture of treated-versus-never and cross-timing treated-cohort comparisons; county/year FE |
| Callaway--Sant'Anna | -0.0398 | 0.0127 | Not-yet-treated (includes never-treated); county-clustered multiplier bootstrap |
| Callaway--Sant'Anna | -0.0400 | 0.0130 | Never-treated only; county-clustered multiplier bootstrap |
| Sun--Abraham | -0.0400 | 0.0118 | Never-treated reference cohort; cohort x event-time interactions; county clustered |

Callaway--Sant'Anna uses its unconditional doubly robust estimator (equivalent to unconditional 2x2 DiD here) with 999 multiplier-bootstrap draws. `lpop` is deliberately omitted throughout; a consistently specified `lpop` sensitivity analysis would be useful, but it should not be mixed selectively across estimators.
