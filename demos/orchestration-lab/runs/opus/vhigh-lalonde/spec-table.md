# Specification table — does matching recover the NSW benchmark?

**Experimental benchmark (treated − control in `nsw_mixtape`): $1,794** (HC3 SE $673, 95% CI [$476, $3,113]).
This is the unbiased target. Estimator = ATT on `re78`. Positive **gap** = estimate above benchmark; negative = below.

| Spec | Covariates | Estimator | Common support | Treated used | ATT estimate | 95% CI | Benchmark | Gap vs benchmark | CI covers benchmark? |
|---|---|---|---|---:|---:|---|---:|---:|:--:|
| Naive | — (raw diff) | none | all | 185 | -$8,498 | [-$9,644, -$7,351] | $1,794 | -$10,292 | **no** |
| S1 | Demographics only | 1-NN (replace) | none | 185 | -$2,798 | [-$4,866, -$730] | $1,794 | -$4,592 | **no** |
| S2 | Demographics only | 1-NN (replace) | common support | 185 | -$2,798 | [-$4,866, -$730] | $1,794 | -$4,592 | **no** |
| S3 | Demographics only | Stratification (5) | none | 185 | -$4,137 | [-$5,492, -$2,782] | $1,794 | -$5,931 | **no** |
| S4 | Demographics + re74/re75 | 1-NN (replace) | none | 185 | $1,712 | [$178, $3,247] | $1,794 | -$82 | yes |
| S5 | Demographics + re74/re75 | 1-NN (replace) | common support | 185 | $1,759 | [$221, $3,296] | $1,794 | -$36 | yes |
| S6 | Demographics + re74/re75 | Stratification (5) | none | 185 | -$144 | [-$1,439, $1,152] | $1,794 | -$1,938 | **no** |

**Standard errors.** Benchmark and naive: HC3 heteroskedasticity-robust. 1-NN specs: cluster-robust sandwich on the matched sample (matched set + reused-control identity; ~185 matched-set clusters). Stratification specs: HC3 robust — units within a subclass are independent by design, so clustering on only 5 subclasses would be invalid few-cluster inference. The ordinary nonparametric bootstrap is **not** used — Abadie & Imbens (2008) show it is invalid for nearest-neighbour matching variances. The 1-NN cluster-robust SEs are defensible *working* SEs, not the Abadie-Imbens analytic matching variance (the `Matching` package is unavailable); they also treat the propensity score as known (AI 2016), which for the ATT is typically conservative.

**Notes.** ATT via weighted outcome regression on the MatchIt sample (`estimand = "ATT"`, 1-NN with `replace = TRUE`; logit propensity score). Common-support trimming (`discard = "both"`) discards units outside the propensity-score overlap. It was **non-binding for the ATT**: no treated unit fell outside the CPS controls' score range (all 185 retained, so S1≡S2 and S4/S5 differ only trivially); it trimmed many never-matched controls (≈3,300 in demo-only, ≈10,200 in demo+earn) that were not selected as neighbours anyway. The sensitivity here is driven by the covariate set and the estimator, not by trimming.

