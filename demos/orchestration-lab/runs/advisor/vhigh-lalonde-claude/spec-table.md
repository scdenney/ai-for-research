# Specification table: LaLonde NSW vs. CPS-composite matching estimates

Benchmark = experimental treated-control difference in `re78` within `nsw_mixtape`.
Gap = specification estimate minus benchmark (positive = overstates program effect).
Standard errors: HC1-robust for difference-in-means rows; for matching rows, the
ordinary nonparametric bootstrap is invalid (Abadie-Imbens 2008), so we do not
bootstrap, but the two estimators need different sandwich corrections. 1-NN rows
use two-way cluster-robust SEs (`vcovCL(cluster = ~subclass + id)`): matching with
replacement reuses CPS controls across pairs, so clustering on the match pair alone
misses the correlation induced by reusing the same physical unit. Stratification rows
use ordinary HC1-robust SEs (no clustering): with only 5-10 strata, cluster-robust
sandwich asymptotics do not apply.

N for 1-NN rows is the matched-data row count. N for stratification rows is an
effective sample size (treated N + Kish effective sample size of the weighted
controls), not the raw CPS pool size — under the ATT stratification weights the
control side's effective contribution is a small fraction of the full 16,177-row pool.

The two demographics-only 1-NN rows (no trim / trimmed) are numerically identical.
This is not a coincidence: with these covariates, common-support discarding removes
only CPS controls that were never any treated unit's nearest neighbor, so the ATT
match assignment — and the estimate — is unchanged. (Confirmed directly: discarding
removes 3,286 controls and 0 treated units, and the matched-unit id sets are
identical with and without discarding.) With `re74`/`re75` added, discarding removes
10,216 controls and does change some best-match assignments, so those two rows differ.

| Specification | Covariates | Estimator | Trimmed | N | Estimate | 95% CI | Gap vs. benchmark |
|---|---|---|---|---|---|---|---|
| Experimental benchmark (NSW treated - control) | — | difference in means | — | 445 | $1,794 | [$480, $3,109] | $0 |
| Naive observational (NSW treated - CPS control) | — | difference in means | — | 16177 | $-8,498 | [$-9,638, $-7,357] | $-10,292 |
| Demographics - 1-NN, no trim | demographics | nn | no | 370 | $-2,798 | [$-4,866, $-730] | $-4,592 |
| Demographics - 1-NN, trimmed | demographics | nn | yes | 370 | $-2,798 | [$-4,866, $-730] | $-4,592 |
| Demographics - Stratification (5 strata) | demographics | strat | no | 616 | $-4,137 | [$-5,484, $-2,789] | $-5,931 |
| Demographics + re74/re75 - 1-NN, no trim | demographics + re74/re75 | nn | no | 370 | $1,712 | [$178, $3,247] | $-82 |
| Demographics + re74/re75 - 1-NN, trimmed | demographics + re74/re75 | nn | yes | 370 | $1,759 | [$221, $3,296] | $-36 |
| Demographics + re74/re75 - Stratification, coarse (5 strata, untrimmed) | demographics + re74/re75 | strat | no | 540 | $-144 | [$-1,433, $1,146] | $-1,938 |
| Demographics + re74/re75 - Stratification, trimmed (5 strata) | demographics + re74/re75 | strat | yes | 534 | $1,290 | [$17, $2,563] | $-505 |
| Demographics + re74/re75 - Stratification, finer (10 strata, untrimmed) | demographics + re74/re75 | strat | no | 518 | $660 | [$-620, $1,940] | $-1,134 |
