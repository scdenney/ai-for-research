# Does propensity-score matching recover the LaLonde benchmark?

**The benchmark and the problem.** The NSW experiment puts the effect of the
program on 1978 earnings at **+$1,794** (95% CI [479, 3,109]) — a clean
treated-minus-control contrast that randomization makes unbiased. Discard the
experimental controls, splice the 185 treated units onto 15,992 CPS
respondents, and the raw contrast collapses to **-$8,498**: the CPS men are
older, better educated, and far higher-earning, so selection swamps the effect
more than fivefold and reverses its sign. The question Dehejia-Wahba and
Smith-Todd fight over is whether conditioning on observed covariates repairs
this.

**What conditioning does, and does not, do.** It does a great deal — but
unevenly. Adding the six demographics alone moves the estimate from -$8,498 to
roughly -$2,800 (1-NN) or -$4,200 (stratification): most of the raw gap closes,
yet every demographics-only estimate is still wrong-signed and its interval
excludes the benchmark. The lever that matters is the pair of pre-program
earnings, re74 and re75. With them in the score, 1-NN matching returns **+$1,712**
and **+$1,759** (with common-support trimming), both statistically
indistinguishable from +$1,794. What conditioning is doing is not magic; it is
balancing the one dimension — earnings history — on which the CPS pool differs
from the trainees in a way that predicts re78. What it is not doing is
certifying that all confounding is observed; it cannot, and demographics-only
balance is not enough.

**Verdict: recovery only under favorable specifications.** Two independent
reviews (Opus and a different-vendor GPT-5.6 peer), run blind, reached the same
reading, and the specification curve makes it plain. Holding the covariate set
at its best case, the estimator still decides the answer: 1-NN lands on the
benchmark, but simple five-stratum subclassification on the *same* rich score
gives **-$144** [-1,406, 1,119] — a null. So a benchmark-consistent number
exists, but it requires jointly choosing the earnings covariates *and*
nearest-neighbor matching. That joint dependence is precisely Smith-Todd's
fragility, not Dehejia-Wahba's robust replication.

**What a paper may and may not claim.** It may claim that lagged earnings are
*necessary* to approach the experimental target — demographics-only matching
fails decisively — and that under a rich score a nearest-neighbor PS estimate is
statistically indistinguishable from the experimental +$1,794, a qualified,
conditional replication. It may **not** claim that PS methods robustly recover
the benchmark, that the CPS is a validated control pool, or that matching
delivers experimental credibility independent of specification: the same
favorable covariates, run through a coarser estimator, return zero. "Matching
works" and "matching fails" are both wrong. Matching recovers the benchmark
under one defensible specification and misses it under others equally
defensible; the honest claim is conditional, and the conditions must be stated.

*Standard errors are HC2 (naive/benchmark), a cluster-robust approximation to
the Abadie-Imbens (2006) matching variance for 1-NN — the nonparametric
bootstrap being invalid here (Abadie-Imbens 2008) and the exact estimator
unavailable without `Matching` — and analytic within-stratum variances for
stratification.*
