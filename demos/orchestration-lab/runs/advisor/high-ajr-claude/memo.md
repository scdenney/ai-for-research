# Memo: what the AJR replication can and cannot support

The headline replicates. On the 64-country base sample, OLS of `logpgp95` on
`avexpr` gives 0.52 (se 0.06); instrumenting `avexpr` with `logem4` gives a
2SLS coefficient of 0.94 (se 0.16) — matching AJR's published estimate and,
as advertised, well above OLS. The first stage is strong here: `avexpr` falls
0.61 points for every log-point of settler mortality, with F = 23, comfortably
above the weak-instrument threshold. Adding latitude (spec 2, F = 13) or
continent dummies (spec 3, F = 11) leaves the story qualitatively intact — the
2SLS coefficient stays in the 0.8–1.0 range and the instrument remains
(barely, for spec 3) above the conventional F = 10 cutoff. So the core claim —
that institutions instrumented by settler mortality predict long-run income,
with 2SLS exceeding OLS — survives the two "add plausible controls" stress
tests.

The two sample-restriction stress tests fare differently, and the difference
matters. Dropping the four neo-Europes (AUS, CAN, NZL, USA) drops the
first-stage F to 8.65 — below the rule-of-thumb cutoff of 10, and squarely
between the Stock-Yogo 15% and 25% size-distortion thresholds — while the
2SLS point estimate rises to 1.28 with a much wider SE (0.36 vs. 0.16). That
specification is directionally consistent with the headline but weakly
identified, and its point estimate needs a weak-instrument caveat rather than
being taken at face value. Restricting to Africa is a different case
entirely: the first-stage coefficient on `logem4` shrinks to -0.11 and F
collapses to 0.30, essentially no instrument power. The resulting 2SLS
"estimate" of 2.40 (se 3.99) is not a more localized version of the headline
effect — it is the output of a regression with no working instrument. With a
single just-identified instrument, a weak first stage leaves the sampling
distribution of the 2SLS estimator badly behaved and invalidates conventional
SEs/CIs, so the Africa number should not be quoted, compared to the baseline,
or read as evidence the effect is larger or smaller in Africa specifically.

**What the manuscript may claim:** the settler-mortality instrument for
institutions produces a 2SLS estimate that exceeds OLS and is robust to
adding latitude and continent controls, on the AJR base sample of 64
countries. That is a genuine, reproducible finding.

**What it may not claim:** that this result is confirmed, or overturned,
within Africa. The instrument does not lose power there for lack of
variation — the standard deviation of `logem4` within Africa is 1.22, almost
identical to the full-sample 1.26, and mortality still ranges over 2.7–8.0
log points within the continent. It loses power because the
mortality-institutions slope goes flat (-0.11 versus -0.61 in the full
sample): identification rides on the cross-continent gradient and the
neo-Europe anchor points, and that relationship largely disappears within
Africa despite ample variation in the instrument, so neither a large nor a
small 2SLS coefficient there is informative. Excluding the neo-Europes is a
milder case — F = 8.65 is marginal rather than dead, so that specification's
1.28 estimate is directionally consistent with the headline but weakly
identified, and should carry a weak-instrument caveat rather than being read
as a confirmed, precisely estimated effect. The paper cannot speak to
whether the effect holds within more homogeneous subpopulations, or survives
excluding its most influential observations, without a stronger or different
instrument.
