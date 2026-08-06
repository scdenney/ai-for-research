# Specification table — does PSM recover the LaLonde experimental benchmark?

**Experimental benchmark (NSW treated - NSW control, re78):** $1,794  (HC1 SE $671, 95% CI [$480, $3,109]).

**Naive observational (NSW treated - CPS controls, raw):** -$8,498  (HC1 SE $582, 95% CI [-$9,638, -$7,357]) — gap -$10,292 from benchmark.

Composite = 185 NSW treated + 15,992 CPS controls (n = 16,177). Estimand: ATT.
PSM: 1-NN with replacement (logit propensity). Stratification: 6 propensity strata, ATT weights.
SEs cluster-robust on matched set (and reused-control id for NN); the ordinary
nonparametric bootstrap is invalid for NN-matching variances (Abadie-Imbens 2008).
'CI covers benchmark?' asks whether the benchmark falls inside the spec's own 95% CI.

| Spec | Covariates | Estimator | Trim | Treated matched | ATT estimate | SE | 95% CI | Gap vs benchmark | CI covers benchmark? |
|---|---|---|---|---|---|---|---|---|---|
| S1 | Demographics | 1-NN PSM | none | 185 | -$2,798 | $1,055 | [-$4,866, -$730] | -$4,592 | no |
| S2 | Demographics | 1-NN PSM | common support | 185 | -$2,798 | $1,055 | [-$4,866, -$730] | -$4,592 | no |
| S3 | Demographics | Stratification | 6 strata | 185 | -$3,622 | $916 | [-$5,417, -$1,826] | -$5,416 | no |
| S4 | Demographics + re74/re75 | 1-NN PSM | none | 185 | $1,712 | $783 | [$178, $3,247] | -$82 | yes |
| S5 | Demographics + re74/re75 | 1-NN PSM | common support | 185 | $1,759 | $785 | [$221, $3,296] | -$36 | yes |
| S6 | Demographics + re74/re75 | Stratification | 6 strata | 185 | $61 | $1,617 | [-$3,108, $3,229] | -$1,734 | yes |
