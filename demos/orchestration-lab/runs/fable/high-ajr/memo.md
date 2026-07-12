## Memo: Robustness of the AJR (2001) settler-mortality IV

**Subject:** Stress-test of the headline 2SLS result (settler mortality → expropriation-risk institutions → 1995 log GDP per capita), n=64 base sample.

### What survives

The core pattern the manuscript reports is stable across the covariate perturbations we tested. In the baseline, with a latitude control, and with continent controls (africa, asia), 2SLS sits well above OLS (0.944, 0.996, 0.839 vs. 0.522, 0.468, 0.434) and the first stage stays strong: the settler-mortality coefficient holds its sign and stays in the −0.51 to −0.61 band, with F statistics of 22.95, 13.09, and 11.01 — all above the Staiger-Stock rule-of-thumb F=10. Dropping the four neo-Europe outliers (AUS/CAN/NZL/USA) leaves the pattern qualitatively intact: 2SLS remains above OLS and the instrument keeps the expected sign (−0.391). On these specifications the headline story is not fragile to the standard covariate and outlier objections.

### What does not survive — and one caveat

The Africa-only subsample (n=27) breaks identification outright. The first stage collapses to F=0.30 with a −0.108 coefficient, and the 2SLS estimate of 2.40 carries an SE of 3.99. That number is not a within-Africa causal effect; it is what an essentially dead first stage produces. Read it as non-informative: it neither confirms nor overturns the headline, because the design cannot identify the effect in that subsample at all.

Treat the neo-Europe drop (Spec 4) as a genuine caveat, not a clean pass. Removing four countries pushes F to 8.65 — below 10, so borderline-weak, not comfortably identified — while the 2SLS point estimate roughly doubles (1.281) and the SE widens to 0.358. The sign and direction survive; the precision does not. The manuscript should report this openly rather than fold it into the "robust" column.

### What the manuscript may and may not claim

**May claim:** the 2SLS-above-OLS pattern and an adequately strong first stage are robust to adding latitude, adding continent controls, and (with the borderline-F caveat) to excluding the neo-Europes.

**May not claim:** that the Africa-only estimate says anything about the magnitude of the effect within Africa; that the neo-Europe-excluded estimate is as precisely pinned as the full sample; or that the result is "established" or immune to identification concerns generally — the 27- and 60-country subsamples are underpowered for a weak-instrument-robust conclusion.

Finally, calibrate both directions. The weak-instrument specs do not refute AJR, and the surviving specs do not prove the causal story. Every 2SLS estimate here still rests on the exclusion restriction — settler mortality affecting income only through institutions — which this exercise does not test.
