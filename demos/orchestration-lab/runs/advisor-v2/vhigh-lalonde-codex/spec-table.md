# NSW--CPS specification table

Experimental benchmark (randomized NSW treated minus NSW control): **$1,794** (SE $671; 95% CI [$479, $3,109]).

| Covariate set | Estimator | Common support | Treated N | CPS-control candidates N | Estimate (USD) | SE | Estimate 95% CI | Gap from benchmark | Recovery-gap 95% CI | p (gap = 0) |
|---|---|:---:|---:|---:|---:|---:|---:|---:|---:|---:|
| None | Raw observational difference | No | 185 | 15992 | $-8,498 | $583 | [$-9,641, $-7,354] | $-10,292 | [$-10,975, $-9,609] | <0.001 |
| Demographics | 1-NN matching | No | 185 | 15992 | $-2,798 | $1,139 | [$-5,030, $-566] | $-4,592 | [$-6,640, $-2,544] | <0.001 |
| Demographics | Score stratification | No | 185 | 15992 | $-4,046 | $667 | [$-5,352, $-2,740] | $-5,840 | [$-6,791, $-4,890] | <0.001 |
| Demographics | 1-NN matching | Yes | 185 | 12706 | $-2,798 | $1,139 | [$-5,030, $-566] | $-4,592 | [$-6,640, $-2,544] | <0.001 |
| Demographics | Score stratification | Yes | 185 | 12706 | $-3,912 | $670 | [$-5,225, $-2,598] | $-5,706 | [$-6,667, $-4,745] | <0.001 |
| Demographics + prior earnings | 1-NN matching | No | 185 | 15992 | $1,712 | $810 | [$125, $3,300] | $-82 | [$-1,365, $1,200] | 0.900 |
| Demographics + prior earnings | Score stratification | No | 185 | 15992 | $-181 | $644 | [$-1,444, $1,082] | $-1,975 | [$-2,857, $-1,093] | <0.001 |
| Demographics + prior earnings | 1-NN matching | Yes | 185 | 5776 | $1,759 | $814 | [$164, $3,353] | $-36 | [$-1,327, $1,255] | 0.957 |
| Demographics + prior earnings | Score stratification | Yes | 185 | 5776 | $1,253 | $646 | [$-13, $2,518] | $-542 | [$-1,428, $344] | 0.231 |

## Post-adjustment balance and CPS-control use

| Covariate set | Estimator | Common support | Max \|SMD\| | Covariates \|SMD\| > 0.10 | CPS controls with positive weight | Effective CPS-control N |
|---|---|:---:|---:|---:|---:|---:|
| Demographics | 1-NN matching | No | 0.06 | 0 | 120 | 79.8 |
| Demographics | Score stratification | No | 0.27 | 3 | 15992 | 469.9 |
| Demographics | 1-NN matching | Yes | 0.06 | 0 | 120 | 79.8 |
| Demographics | Score stratification | Yes | 0.27 | 2 | 12706 | 451.1 |
| Demographics + prior earnings | 1-NN matching | No | 0.31 | 1 | 127 | 95.3 |
| Demographics + prior earnings | Score stratification | No | 0.29 | 7 | 15992 | 352.8 |
| Demographics + prior earnings | 1-NN matching | Yes | 0.30 | 1 | 127 | 95.3 |
| Demographics + prior earnings | Score stratification | Yes | 0.22 | 3 | 5776 | 346.6 |

For each covariate set, the propensity score is estimated once on the full NSW-treated/CPS-control composite and then held fixed for both the untrimmed and common-support-trimmed estimators. Common support is the intersection of its NSW-treated and CPS-control ranges. All 185 treated observations are retained in both models, so trimming removes only CPS candidates. The displayed candidate N is the pre-estimation CPS pool.

Balance diagnostics compare the NSW treated mean with the estimator-weighted CPS mean. Each absolute SMD uses the unadjusted full-composite pooled SD for that covariate, so values are comparable across the trimmed and untrimmed rows; the count is among the covariates listed for that specification. The CPS-control count is the number with positive analysis weight. Its effective N is `(sum w)^2 / sum(w^2)`; for 1-NN matching it is based on control reuse weights and therefore reports both distinct matched controls and their reuse concentration.

The recovery gap equals the observational estimate minus the experimental benchmark, which algebraically is the randomized NSW control mean minus the adjusted CPS control mean. Its interval and two-sided p-value use only those two control-side variance components: the shared NSW-treated outcome mean cancels. Thus they are direct recovery comparisons, unlike visual overlap of the estimator and benchmark intervals.

For 1-NN rows, MatchIt forms ATT matches with replacement. Estimate intervals use a conditional Abadie--Imbens-style approximation with three same-arm nearest neighbours for local outcome variances and control reuse counts; no ordinary bootstrap is used. Stratification uses five score strata defined by treated-score quintiles and a fixed-strata sampling variance. Neither the estimator nor recovery-gap intervals propagate propensity-score estimation uncertainty.
