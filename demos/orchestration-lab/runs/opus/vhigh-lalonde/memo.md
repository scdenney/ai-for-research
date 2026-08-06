# Adjudication: does propensity-score matching recover the LaLonde benchmark?

The National Supported Work experiment fixes the target. Within `nsw_mixtape`, treated
units out-earn controls by **+$1,794** in 1978 (HC1 95% CI [$480, $3,109]), an unbiased
effect because randomization balances everything, observed and unobserved. Replacing the
260 experimental controls with 15,992 CPS controls destroys that balance. The naive
observational contrast is **−$8,498**, a $10,300 swing driven entirely by selection: NSW
enrollees were far more disadvantaged than the CPS population, so any credible observational
estimate must undo roughly $10,000 of composition before it can be believed.

**What conditioning does, and does not, do.** Matching on demographics alone (age,
education, race, marital status, degree) removes most of that gap, moving the estimate from
−$8,498 to about −$2,800 (1-NN) or −$3,600 (stratification). That is real bias reduction,
but it stops far short. Every demographics-only specification lands significantly *below
zero*, nowhere near +$1,794, and none of their intervals cover the benchmark. Demographic
similarity is not the selection mechanism. Adding the two pre-treatment earnings variables
(`re74`, `re75`) closes the remaining gap, because NSW participants had near-zero prior
earnings, an enrollment signal demographics cannot proxy. With earnings in the propensity
score, 1-NN matching returns **+$1,712 and +$1,759**, within $100 of the benchmark, with
intervals that cover it. This is the Dehejia–Wahba result, and it is genuine.

**Recovery is specification-dependent, not robust.** Hold the rich covariate set fixed and
change only the estimator, from 1-NN to simple six-strata stratification, and the estimate
collapses to **+$61**. Its interval [−$3,108, $3,229] nominally covers the benchmark only
because it is wide enough to cover almost anything, including zero. Trimming to common
support changes nothing; it drops no treated units on either score, so the two "trim" cells
merely relabel their untrimmed twins. Across the six specifications the point estimate ranges
from −$3,622 to +$1,759. Recovery appears in exactly the two cells that pair pre-treatment
earnings *with* nearest-neighbor matching, and vanishes elsewhere. This is the Smith–Todd
fragility, reproduced.

**Verdict: favorable-specification-only.** Matching recovers the benchmark under one
defensible-but-not-privileged combination of choices and fails under equally defensible
neighbors. It is neither "matching works" nor "matching fails."

**What a paper may claim:** that conditioning on pre-treatment earnings eliminates the bulk
of observational bias and can yield estimates statistically consistent with the experimental
effect, a strong and honest result about the value of good covariates. **What it may not
claim:** that PSM "recovers the experimental estimate" without qualification, that demographic
controls suffice, or that any single favorable estimate is *the* recovered effect. Absent the
experiment, an analyst could not know which of these six specifications to trust, which is
precisely why the benchmark, not the match, remains the standard.
