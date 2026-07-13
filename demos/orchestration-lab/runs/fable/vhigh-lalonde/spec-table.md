# Specification table -- does PS matching recover the LaLonde benchmark?

**Experimental benchmark** (NSW treated - control on `re78`): **1,794** (95% CI [479, 3,109]).

**Naive observational** (NSW treated - CPS controls, no adjustment): **-8,498** (95% CI [-9,641, -7,354]).

Composite = 185 NSW treated + 15,992 CPS controls. ATT estimand throughout.
Gap = estimate - benchmark; "recovers" means the 95% CI covers the benchmark point.

| Covariate set | Estimator | Estimate | 95% CI | Gap vs. benchmark | Benchmark | Covers? |
|---|---|---:|---|---:|---:|:---:|
| Demographics | 1-NN | -2,798 | [-4,866, -730] | -4,592 | 1,794 | no |
| Demographics | 1-NN + trim | -2,798 | [-4,866, -730] | -4,592 | 1,794 | no |
| Demographics | Stratify (5) | -4,162 | [-5,491, -2,833] | -5,956 | 1,794 | no |
| + re74/re75 | 1-NN | 1,712 | [178, 3,247] | -82 | 1,794 | yes |
| + re74/re75 | 1-NN + trim | 1,759 | [221, 3,296] | -36 | 1,794 | yes |
| + re74/re75 | Stratify (5) | -144 | [-1,406, 1,119] | -1,938 | 1,794 | no |

**Standard errors.** Benchmark and naive: HC2 heteroskedasticity-robust.
1-NN matching (with replacement): cluster-robust on matched pair and reused
unit id -- a design-based *approximation* to the Abadie-Imbens (2006) analytic
matching variance (the exact estimator lives in `Matching`, not installed);
the nonparametric bootstrap is ruled out, being invalid for nearest-neighbour
matching variances (Abadie & Imbens 2008). Stratification: analytic delta-method
variance from within-stratum sampling variances, conditional on the estimated strata.
