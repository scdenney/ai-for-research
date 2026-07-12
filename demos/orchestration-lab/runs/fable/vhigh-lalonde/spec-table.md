# LaLonde specification curve: observational PSM vs experimental benchmark

Experimental benchmark (ATT on re78): **$1,794** [95% CI 551, 3,038].
Naive observational estimate: **$-8,498** [95% CI -9,893, -7,102].

All dollar figures are 1978 real earnings (re78). `gap` = estimate - benchmark.

| Spec | Covariate set | Estimator / SE method | Estimate | SE | 95% CI low | 95% CI high | Gap to benchmark |
|------|---------------|-----------------------|---------:|---:|-----------:|------------:|-----------------:|
| BENCH | experimental | diff-in-means (OLS SE) | 1,794 | 633 | 551 | 3,038 | 0 |
| NAIVE | none (composite) | diff-in-means (OLS SE) | -8,498 | 712 | -9,893 | -7,102 | -10,292 |
| S1 | demographics | 1-NN, no trimming (SE: cluster on control id) | -2,798 | 1,071 | -4,897 | -699 | -4,592 |
| S2 | demographics+re74+re75 | 1-NN, no trimming (SE: cluster on control id) | 1,712 | 803 | 137 | 3,287 | -82 |
| S3 | demographics | 1-NN, common-support caliper 0.1 (SE: cluster on control id) | -2,798 | 1,071 | -4,897 | -699 | -4,592 |
| S4 | demographics+re74+re75 | 1-NN, common-support caliper 0.1 (SE: cluster on control id) | 1,759 | 803 | 185 | 3,333 | -36 |
| S5 | demographics | PS subclassification, 6 strata (SE: cluster by stratum) | -3,622 | 916 | -5,417 | -1,826 | -5,416 |
| S6 | demographics+re74+re75 | PS subclassification, 6 strata (SE: cluster by stratum) | 61 | 1,617 | -3,108 | 3,229 | -1,734 |

SE note: 1-NN specifications avoid the ordinary nonparametric bootstrap,
which Abadie & Imbens (2008) show is invalid for nearest-neighbor matching;
they use cluster-robust SEs clustered on the reused control-unit id.
Subclassification specifications use cluster-robust SEs by stratum.

Trim note: on the demographics-only propensity score the common-support
restriction is non-binding -- all 185 treated units find a within-caliper
match and the discarded off-support controls were never nearest neighbors
under matching-with-replacement -- so S1 and S3 are identical by
construction. The restriction binds once re74/re75 enter (S2 vs S4).
