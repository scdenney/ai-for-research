# Fixed LaLonde specification curve

All amounts are 1978 dollars. The benchmark is the NSW experimental treated-minus-control contrast.

| Estimator | Covariates | Support | Estimate | 95% CI | Benchmark | Gap | Treated N | Control N | Control ESS |
|---|---|---|---:|---|---:|---:|---:|---:|---:|
| Raw difference | None | No trim | -$8,498 | [-$9,641, -$7,354] | $1,794 | -$10,292 | 185 | 15992 | 15,992 |
| 1-NN replacement | Demographics | No trim | -$2,655 | [-$4,749, -$561] | $1,794 | -$4,449 | 185 | 121 | 79 |
| 5 strata | Demographics | No trim | -$4,025 | [-$5,366, -$2,684] | $1,794 | -$5,820 | 185 | 15992 | 444 |
| 1-NN replacement | Demographics | Common support | -$2,951 | [-$5,027, -$875] | $1,794 | -$4,746 | 184 | 120 | 83 |
| 5 strata | Demographics | Common support | -$3,730 | [-$5,069, -$2,390] | $1,794 | -$5,524 | 184 | 8755 | 453 |
| 1-NN replacement | Demographics + earnings | No trim | $2,787 | [$1,213, $4,360] | $1,794 | $992 | 185 | 118 | 63 |
| 5 strata | Demographics + earnings | No trim | -$1 | [-$1,499, $1,498] | $1,794 | -$1,795 | 185 | 15992 | 138 |
| 1-NN replacement | Demographics + earnings | Common support | $1,773 | [-$105, $3,651] | $1,794 | -$22 | 181 | 114 | 62 |
| 5 strata | Demographics + earnings | Common support | $1,269 | [-$166, $2,703] | $1,794 | -$526 | 181 | 4544 | 152 |

## Methods

The observational composite contains all 185 NSW treated units and all 15,992 CPS controls. The naive row is an unweighted `lm(re78 ~ treat)`. Each adjusted row uses a propensity-score logit fit by MatchIt with ATT targeting and `distance = "glm"`; 1-NN uses replacement, ratio 1, and closest-first matching, while stratification uses exactly five subclasses. No-trim specifications set `discard = "none"` and `reestimate = FALSE`; common-support specifications set `discard = "both"` and `reestimate = TRUE`. Matched data retain only matched observations. Estimates come from `lm(re78 ~ treat)` using MatchIt weights, with HC2 sandwich standard errors and normal 95% intervals. Control N is the number of unique retained controls; control ESS is sum(w)^2/sum(w^2). These intervals condition on estimated scores and matches; they do not bootstrap nearest-neighbor matching.
