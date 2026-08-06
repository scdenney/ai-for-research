# Memo — how much weight the AJR headline will bear

## Replication

On the full 64-country sample the bivariate result reproduces exactly. OLS of
`logpgp95` on `avexpr` is 0.52; 2SLS instrumenting `avexpr` with `logem4` is
0.94; the first stage is strong, with a coefficient of −0.61 and an
excluded-instrument F of 22.9. The 2SLS estimate sits well above OLS, as the
manuscript reports. All 2SLS was estimated with `AER::ivreg`, so the
second-stage standard errors are exact rather than the approximate
two-stage-`lm` version.

## What survives

The headline holds under both full-sample control perturbations. Adding
latitude leaves 2SLS at 1.00 with a first-stage F of 13.1; adding continent
dummies leaves it at 0.84 with an F of 11.0. Both clear the weak-instrument
threshold, and both keep 2SLS clearly above its OLS counterpart (0.47 and
0.43). Identification is adequate in each, though the continent specification
is marginal at F = 11.

## What does not

The two sample restrictions break identification. Dropping the four
neo-Europes lowers the first-stage F to 8.6, just under the rule-of-thumb 10,
while the 2SLS estimate rises to 1.28. That combination is a warning rather
than a strengthening: a point estimate that climbs as the first stage weakens
is the signature of weak-instrument bias, not evidence of a larger effect. The
estimate cannot be leaned on, and a weak first stage does not overturn the
result either. Restricting to Africa collapses the instrument outright (N = 27,
first-stage coefficient −0.11, F = 0.30). The resulting 2SLS estimate of 2.40
carries no information about the causal coefficient in either direction.

## What the manuscript may and may not claim

It may claim that the large positive 2SLS estimate is reproduced in the full
sample and stays numerically robust to latitude and continent controls, with
first-stage strength that is acceptable but increasingly marginal. It should
report that excluding the neo-Europes raises the point estimate while pushing
identification below the conventional threshold, and that the Africa-only
subsample yields no usable IV evidence.

It may not present robustness across all four stress tests, treat the larger
estimates from the weakly identified specifications as the strongest
confirmation, or read the Africa-only coefficient at face value. The honest
summary is that the finding is solid in the full sample and survives
reasonable controls, but its identification is not deep enough to survive
dropping the richest colonies or narrowing to Africa.
