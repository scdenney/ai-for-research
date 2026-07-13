# LaLonde specification curve: observational PSM vs experimental benchmark

Experimental benchmark (ATT on re78): **$1,794** [95% CI 479, 3,109].
Naive observational estimate: **$-8,498** [95% CI -9,641, -7,354].

All dollar figures are 1978 real earnings (re78). `gap` = estimate - benchmark.
`N trt` = treated units retained (justifies the ATT label); `max|SMD|` = worst
post-adjustment standardized mean difference across covariates (balance; <0.1 good).

| Spec | Covariate set | Estimator / SE method | Estimate | SE | 95% CI low | 95% CI high | Gap to benchmark | N trt | max\|SMD\| |
|------|---------------|-----------------------|---------:|---:|-----------:|------------:|-----------------:|------:|--------:|
| BENCH | experimental | diff-in-means (HC2 robust SE) | 1,794 | 671 | 479 | 3,109 | 0 | 185 | -- |
| NAIVE | none (composite) | diff-in-means (HC2 robust SE) | -8,498 | 583 | -9,641 | -7,354 | -10,292 | 185 | -- |
| S1 | demographics | 1-NN w/ replacement, no trimming (SE: cluster on reused control id) | -2,798 | 1,071 | -4,897 | -699 | -4,592 | 185 | 0.08 |
| S2 | demographics+re74+re75 | 1-NN w/ replacement, no trimming (SE: cluster on reused control id) | 1,712 | 803 | 137 | 3,287 | -82 | 185 | 0.40 |
| S3 | demographics | 1-NN w/ replacement, common-support caliper 0.1 (SE: cluster on reused control id) | -2,798 | 1,071 | -4,897 | -699 | -4,592 | 185 | 0.08 |
| S4 | demographics+re74+re75 | 1-NN w/ replacement, common-support caliper 0.1 (SE: cluster on reused control id) | 1,759 | 803 | 185 | 3,333 | -36 | 185 | 0.40 |
| S5 | demographics | PS subclassification, 6 strata (SE: HC3 robust, subclass wts) | -3,622 | 665 | -4,924 | -2,319 | -5,416 | 185 | 0.16 |
| S6 | demographics+re74+re75 | PS subclassification, 6 strata (SE: HC3 robust, subclass wts) | 61 | 648 | -1,209 | 1,330 | -1,734 | 185 | 0.49 |

SE note: BENCH and NAIVE use HC2 (Neyman) robust SEs. The 1-NN specs avoid
the ordinary nonparametric bootstrap, which Abadie & Imbens (2008) prove is
invalid for nearest-neighbor matching; they use cluster-robust SEs clustered
on the reused control-unit id -- the handling MatchIt recommends for matching
WITH replacement. This is a pragmatic sandwich, not the Abadie-Imbens (2006)
score-adjusted matching variance (the `Matching` package is not installed),
so uncertainty from estimating the propensity score is not fully propagated;
the NN intervals are, if anything, mildly optimistic. Subclassification specs
use HC3 robust SEs on the subclass-weighted fit (not 6-cluster clustering,
which would be too few clusters for cluster asymptotics).

Gap note: each `Gap to benchmark` compares a spec's CI to the benchmark by
overlap; it is not a formal paired test. Because BENCH and every spec share
the same 185 NSW treated outcomes, a proper test of the gap would account for
that shared component -- so read the gaps as descriptive, not as a hypothesis
test that the recovered estimate equals the experimental truth.

Trim note: on the demographics-only propensity score the common-support
restriction is non-binding -- all 185 treated units are retained (see N trt)
and the discarded off-support controls were never nearest neighbors under
matching-with-replacement -- so S1 and S3 are identical by construction. The
restriction binds once re74/re75 enter (S2 vs S4); check N trt for S4 to see
whether any treated units fall off support (if so its estimand is the ATT on
the overlap sample, not the full-NSW ATT).
