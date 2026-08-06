# Adjudication: does staggered-adoption bias change the conclusion here?

**Short answer: no.** The five estimators — naive TWFE, Callaway-Sant'Anna under
both control-group choices, Sun-Abraham, and Roth-Sant'Anna — cluster within
-0.0365 to -0.0471, a spread of about 0.010 log points against standard errors
of 0.012-0.013. The heterogeneity-robust estimators are somewhat more negative
than TWFE, but all five point to the same substantive story: teen employment
fell roughly 4% (range ~3.6-4.7%) in counties exposed to the minimum-wage
increase.

**Why the classic critique doesn't overturn it.** The Goodman-Bacon
decomposition shows why: comparisons that use an already-treated county as the
"control" for a later-treated one ("Later vs Earlier Treated") carry only
5.4% of the pooled TWFE weight. Their estimate is genuinely counter-signed —
+0.0046, opposite the pooled TWFE estimate of -0.0365 — confirming the
Goodman-Bacon mechanism is *present*, not merely theoretical. But at 5.4%
weight it cannot move the pooled estimate far: 86.3% of the weight sits on
clean treated-vs-never-treated comparisons averaging -0.0407, close to what
the modern estimators recover directly. TWFE is mildly attenuated, not
qualitatively wrong. (Caveat: the Bacon *weight* itself is positive-valued —
it's the attached *estimate* that's counter-signed; the underlying worry about
implicit negative weighting on heterogeneous effects can't be fully separated
from ordinary variation across estimators built on different weighting
schemes.)

**Pre-trends.** The event study shows a pointwise-significant pre-period blip
at e=-3 (95% CI [0.0001, 0.0594]), which could look like a violation in
isolation. But three pre-periods demand a joint band, not three pointwise
tests: under `did`'s default simultaneous band, e=-3 widens to [-0.0075,
0.0670] and covers zero, as do e=-2 and e=-1. Parallel trends holds up under
the correct multiple-testing correction. Post-treatment effects grow
monotonically and turn clearly significant from e=1 on (-0.054, -0.136,
-0.101), consistent with a genuine, strengthening effect — though some growth
may also reflect cohort composition shifting across later event-time bins.

**Bottom line.** Report the Callaway-Sant'Anna simple ATT with not-yet-treated
controls: **-0.0398 (SE 0.0127)**, essentially identical to the never-treated
and Sun-Abraham estimates. Cite the ~4% decline as the headline magnitude, note
Roth-Sant'Anna's somewhat larger -0.047 as the upper end of a reasonable range,
and note TWFE (-0.037) as directionally and quantitatively consistent — not
as a result to distrust.
