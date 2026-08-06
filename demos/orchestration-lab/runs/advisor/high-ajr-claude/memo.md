# Memo: What the AJR replication is entitled to claim

**The headline replicates.** On the 64-country base sample, OLS of `logpgp95` on
`avexpr` gives 0.522; instrumenting `avexpr` with `logem4` gives a 2SLS coefficient
of 0.944 — nearly double OLS, matching AJR's qualitative pattern of 2SLS exceeding
OLS. The first stage is strong: `avexpr` falls 0.607 points per log-point of
settler mortality, with F = 22.95, comfortably
above the weak-instrument threshold of 10. On this evidence, the manuscript can
claim settler mortality is a relevant instrument for institutions in the base
sample, and that 2SLS substantially exceeds OLS.

**Adding controls holds up, barely.** Adding latitude (spec a) leaves both the
first stage (F = 13.09) and the 2SLS estimate (0.996, SE = 0.222) intact —
essentially unchanged from the headline (0.944, SE = 0.157; ~0.2 SE apart).
Adding continent dummies (spec b) pushes the first-stage F
down to 11.01, just above the conventional threshold, while the 2SLS estimate
(0.839) stays in the same range as the headline. Both are still usable, but
continent dummies are already eating into instrument strength — this is a
specification to flag as border, not to lean on for a stronger causal claim than
the headline itself.

**Two stress tests break the instrument.** Dropping the four neo-Europes (AUS,
CAN, NZL, USA) cuts the first-stage F to 8.65 — below 10 — and the 2SLS estimate
moves to 1.281 (SE = 0.358), within one standard error of the headline.
Restricting to Africa collapses the first stage almost entirely (F = 0.30):
settler mortality has essentially no power to predict institutions within that
subsample, and the resulting 2SLS estimate of 2.400 is not a credible causal
estimate of anything — it is what a weak instrument produces when the denominator
of the IV ratio is close to zero (its Anderson-Rubin confidence set is essentially
unbounded, confirming this directly). Neither large 2SLS coefficient is evidence
the true effect exceeds the headline: a collapsed first stage cannot confirm a
stronger effect, and by the same logic cannot overturn the headline either.

**What the manuscript may claim:** that AJR's headline pattern (2SLS > OLS, with a
first-stage F well above 10) reproduces in the base sample and survives adding
latitude, and survives — marginally — adding continent controls. **What it may
not claim:** that the effect is even larger among non-neo-Europe countries or
within Africa specifically. Those two specifications should be reported as
diagnostic (instrument strength has failed), not as robustness checks that
strengthen the headline number. All four checks above speak to instrument
*relevance* and sample composition, not to the *exclusion restriction* — untestable
here, in a just-identified model. The paper's causal claim thus rests on the full,
latitude-controlled sample *conditional on the maintained assumption that settler
mortality affects 1995 income only through institutions*, not directly via disease
environment or geography — and does not extend to African-only identification with
this instrument.
