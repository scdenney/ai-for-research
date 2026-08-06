Keep the “recovery only under favorable specifications” conclusion, but do not accept the submission unchanged.

1. Fix the stratification implementation and rerun everything. The “No trim” estimator is implicitly trimmed because the `cut()` boundaries are the treated-score minimum and maximum. CPS controls outside that range become `NA` and are discarded. This explains why only 12,706 or 5,776 of 15,992 controls enter and why trimmed and untrimmed results coincide. For untrimmed stratification, use the four internal treated-score quintiles with boundaries `-Inf` and `Inf`. Apply common-support restrictions separately only in the trimming specification.

2. Replace or relabel the nearest-neighbor standard errors. `nn_se()` is not heteroskedastic: it multiplies the reuse count by one global control-outcome variance. Prefer an Abadie–Imbens-style analytic variance using local conditional-variance estimates. A more modest alternative is a unique-unit, fixed-weight HC variance based on squared residual contributions and aggregated control weights \(K_j\). If using that alternative, describe the intervals explicitly as conditional on the estimated score and realized matches—not as full matching-estimator inference.

3. Do not use “the interval includes the benchmark” as evidence of recovery. The experimental benchmark is itself noisy, and both estimates contain the same NSW treated outcomes. With all 185 treated retained, the treated mean cancels exactly in the gap:
\[
\widehat\tau_{\text{obs}}-\widehat\tau_{\text{exp}}
=\bar Y_{\text{NSW control}}-\bar Y_{\text{weighted CPS control}}.
\]
Report an interval for this gap that respects that dependence. Inclusion of the benchmark in an ordinary estimate-level interval is neither a test of equality nor evidence of equivalence. A formal recovery claim would require a prespecified equivalence tolerance.

4. Add balance and overlap diagnostics to the table: at minimum the maximum post-adjustment standardized mean difference, treated units retained, and effective control sample size. Five strata may leave meaningful residual imbalance; if so, its estimate demonstrates inadequate coarse subclassification rather than fragility among equally successful balancing procedures. Likewise, sample-extrema “common support” in a 15,992-person CPS pool is a weak overlap diagnostic.

5. Correct the trimming discussion. Every reported row retains all 185 treated units, so trimming did not change the ATT target in this implementation; it only changed which CPS controls were eligible. Say that trimming can change the estimand generally, but did not do so here. If a revised specification removes treated units, comparison with the full-sample experimental benchmark is no longer directly like-for-like.

After those corrections, the defensible claim remains: the raw CPS comparison is severely biased; demographics-only adjustment fails badly; and estimates close to the randomized benchmark arise specifically under richer lagged-earnings nearest-neighbor specifications. A paper may report that specification-level replication, but may not infer that propensity-score matching generally eliminates selection bias or robustly recovers the experimental effect.