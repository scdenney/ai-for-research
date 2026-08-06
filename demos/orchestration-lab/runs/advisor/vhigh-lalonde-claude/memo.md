# Adjudication: does propensity-score matching recover the LaLonde benchmark?

The experimental benchmark — the treated–control difference in `re78` within
the randomized NSW sample — is **+$1,794** (95% CI: $480, $3,109). Replacing
the experimental controls with the full CPS comparison pool and taking a raw
difference gives **–$8,498**: selection into the CPS sample is severe enough
to flip the sign. That is the problem matching is supposed to solve.

Across eight specifications crossing covariate set (demographics only vs.
demographics **plus** pre-treatment earnings `re74`/`re75`) with estimator
detail (1-NN with/without trim; stratification coarse, trimmed, and finer),
recovery is sharply **specification-dependent** — not robust, not absent.

**Demographics-only never recovers, under any estimator.** All three land
between –$2,798 and –$4,137, CIs excluding the benchmark entirely. Age,
education, race, marital status, and degree status describe *who* is
unemployed, not *why*, and miss the transitory earnings shock that predicts
NSW selection. (The two demographics 1-NN rows are identical by
construction: with replacement under ATT, discarding controls that were
never anyone's nearest neighbor changes nothing.)

**With `re74`/`re75`, 1-NN matching recovers.** Estimates of $1,712 (no trim)
and $1,759 (trimmed) sit inside the benchmark's interval. Their SEs need
two-way clustering — match pair *and* physical unit, since 1-NN with
replacement reuses CPS controls across pairs — which widens the CIs to
$178–$3,247 and $221–$3,296. Against SEs near $780, a $36–$82 point gap
from the benchmark is sampling noise, not special accuracy.

**Stratification's apparent failure was an artifact of its weakest
implementation, not the estimator.** The original spec pooled the full
16,177-unit CPS sample into five untrimmed strata. Cluster-robust inference
on five clusters is not defensible, so its SE also needs correcting to
HC-robust, which sharpens the CI to $-1,433 to $1,146 — this now
**excludes** the benchmark, a real failure. But adding common-support
trimming alone, holding strata count at five, recovers it: $1,290, CI
$17–$2,563. Finer stratification alone (10 untrimmed strata) helps less —
$660, CI $-620–$1,940, technically spanning the benchmark but centered well
below it. Trimming, not strata count, is the load-bearing fix: the original
spec failed because it pooled thousands of near-zero-propensity CPS
controls against low-propensity treated units, not because five strata is
inherently too coarse.

**Verdict:** the evidence supports Smith and Todd over an unqualified
Dehejia-Wahba, but the mechanism is narrower than "1-NN succeeds,
stratification fails." Recovery requires the richer covariate set and
either a close estimator (1-NN) or a common-support-restricted one (trimmed
stratification); coarse, untrimmed stratification over the mismatched full
pool fails. A paper may legitimately claim matching *can* recover
experimental benchmarks given favorable covariates and defensible
common-support handling — not that it recovers generally, and not that
stratification is intrinsically less reliable than nearest-neighbor
matching once both get comparable care. One caveat left untested: Smith and
Todd's second fragility axis, the analysis sample — `nsw_mixtape` is
already the Dehejia-Wahba subsample most favorable to their result.
