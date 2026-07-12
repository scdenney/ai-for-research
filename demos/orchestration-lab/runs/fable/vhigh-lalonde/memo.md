# Does propensity-score matching recover the LaLonde experimental benchmark?

The randomized NSW experiment gives an unbiased benchmark: treated workers earned
$1,794 more in 1978 than experimental controls (95% CI $551 to $3,038). Replacing
those controls with 15,992 CPS survey respondents and taking a raw difference
produces -$8,498 (CI -$9,893 to -$7,102), wrong in sign and off the benchmark by
$10,292. This is LaLonde's original point: CPS controls are older, better paid, and
more attached to work than the NSW enrollees, so the raw contrast measures
selection into the comparison group rather than the effect of training.

Propensity-score matching balances the observed covariates that drive that
selection, and what it balances is decisive. Conditioning only on demographics
(age, education, race, marital status, degree) leaves every specification badly
biased. Nearest-neighbor matching returns -$2,798 (gap -$4,592) with or without
common-support trimming, and six-stratum subclassification returns -$3,622 (gap
-$5,416). All three confidence intervals exclude the benchmark. Demographic balance
alone does not fix the problem, because the CPS and NSW groups differ most in their
earnings histories, which demographics do not capture.

Adding the pre-treatment earnings re74 and re75 changes the picture. Nearest-neighbor
matching on the fuller score recovers the benchmark almost exactly: $1,712 without
trimming (gap -$82) and $1,759 with a common-support caliper (gap -$36), both with
intervals that cover the experimental estimate. Matching on earnings history removes
the trajectory difference that demographics missed.

The recovery is not robust across implementation. Holding covariates fixed at the
full set and switching from nearest-neighbor matching to subclassification collapses
the estimate to $61 (gap -$1,734), essentially zero, though its wide interval
(-$3,108 to $3,229) still overlaps the benchmark. Covariate choice moves the estimate
by roughly $4,500, and estimator detail by roughly $1,700 even after the right
covariates are included.

This is favorable-specification-only recovery, not universal recovery. Matching
approximates the experimental answer here only when the propensity score conditions
on pre-treatment earnings, and even then the point estimate depends on whether one
matches or stratifies. That is Smith and Todd's fragility critique, reproduced on
these data.

Two limits bound any claim. Matching balances observables; it cannot correct
selection on unobservables. The full-covariate specifications land near the benchmark
because re74 and re75 proxy the relevant heterogeneity, not because the design
guarantees that the matched CPS controls resemble the treated group on characteristics
we never measured. A paper may legitimately claim that propensity-score matching
conditioning on pre-treatment earnings can approximate the experimental benchmark in
this setting, while stating that the result is sensitive to covariate choice and
matching method. It may not claim that matching validates observational designs in
general, or that it universally recovers experimental benchmarks.
