# Specification table — recovering the NSW experimental benchmark

**Experimental benchmark (unbiased target):** +$1,794  (SE 673; 95% CI [+$476, +$3,113]).

Estimand: ATT of NSW training on 1978 earnings (re78). Composite sample = 185 NSW treated + 15,992 CPS controls. `Gap = estimate - benchmark`. `Covers?` = does the estimate's 95% CI contain the benchmark point (+$1,794).

| Specification | Covariate set | Estimator | Treated N | Estimate | 95% CI | Gap vs. benchmark | Covers? |
|---|---|---|---:|---:|:---:|---:|:---:|
| Naive (observational) | - | unadjusted | 185 | -$8,498 | [-$9,644, -$7,351] | -$10,292 | **no** |
| NN · demog. · no-trim | Demographics only | 1-NN (replace) | 185 | -$2,798 | [-$4,866, -$730] | -$4,592 | **no** |
| NN · demog. · trim | Demographics only | 1-NN (replace) | 185 | -$2,798 | [-$4,866, -$730] | -$4,592 | **no** |
| Strat · demog. | Demographics only | Stratification (6) | 185 | -$3,622 | [-$4,924, -$2,319] | -$5,416 | **no** |
| NN · +re74/75 · no-trim | Demographics + re74/re75 | 1-NN (replace) | 185 | +$1,712 | [+$178, +$3,247] | -$82 | yes |
| NN · +re74/75 · trim | Demographics + re74/re75 | 1-NN (replace) | 185 | +$1,759 | [+$221, +$3,296] | -$36 | yes |
| Strat · +re74/75 | Demographics + re74/re75 | Stratification (6) | 185 | +$61 | [-$1,209, +$1,330] | -$1,734 | **no** |

**Benchmark row (reference):** Experimental | — | unadjusted | 185 | +$1,794 | [+$476, +$3,113] | +$0 | yes |

*SEs:* naive, stratification, and benchmark use HC3 heteroskedasticity-robust SEs; 1-NN specs use cluster-robust SEs clustered on the matched pair **and** the reused control unit (`~subclass + id` on `get_matches()`). The ordinary nonparametric bootstrap is **not** used — it is invalid for nearest-neighbour matching variances (Abadie & Imbens 2008). Cluster-robust matching SEs approximate but do not equal Abadie-Imbens analytic SEs (the `Matching` package is not installed).
