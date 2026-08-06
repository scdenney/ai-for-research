# Memo: Does the TWFE critique change the conclusion for mpdta?

**Short answer: no, not substantively — though it does matter for precision and point-estimate size.**

The Goodman-Bacon decomposition shows the negative-weighting mechanism is
present but small — smaller than the raw category labels suggest. Of TWFE's
identifying weight, 86.3% is clean treated-vs-never-treated variation, and
another 8.3% ("earlier-treated vs. later-treated") is also clean: the later
cohort acts as a not-yet-treated control during its own untreated periods,
the same comparison Callaway-Sant'Anna's `notyettreated` option deliberately
uses. Only "later-treated vs. earlier-treated" — 5.4% — puts an
already-treated unit in the control role, the forbidden comparison. So the
honest split is 94.6% clean, 5.4% contaminated, not 86.3/13.7. That 5.4% cell
also shows the predicted bias: it averages +0.0046 against -0.0389 for every
clean cell, the attenuation Goodman-Bacon predicts when effects grow.
Reallocating it would move TWFE from -0.0365 to about -0.0389 — a -0.002
shift, roughly two-thirds of the entire TWFE-vs-CS gap (69% of ever-treated
counties share one treatment year, 2007, capping how much contamination is
even possible).

All five estimators land in a narrow, overlapping band: TWFE (-0.037, SE
0.013), CS not-yet-treated (-0.040, SE 0.012), CS never-treated (-0.040, SE
0.013), Sun-Abraham (-0.040, SE 0.012), and Roth-Sant'Anna (-0.047, SE
0.012). The RS gap isn't contamination — it's the efficient estimator under
random treatment timing, a stronger assumption with different weighting,
which is why it alone sits off-center. Every estimator agrees on sign and
significance. The event study shows small, insignificant pre-treatment
coefficients at t=-2 and t=-1 (-0.001, -0.025, CIs covering zero) and an
overall pre-trends Wald p=0.17, so parallel trends looks supported, though
t=-1 is worth flagging. Post-treatment effects grow more negative (-0.02, -0.05,
-0.14 at e=0-2), but e=+1 draws on the 2004 and 2006 cohorts while e=+2 comes
from the 2004 cohort alone (20 counties), so growth partly reflects changing
cohort composition, not pure dynamics — the kind of heterogeneity
Goodman-Bacon warns about, though the Bacon weights show it isn't
concentrated in the contaminated cell.

**Bottom line:** TWFE understates the effect by about 0.3-1.0 log points
relative to the heterogeneity-robust estimators — not nothing, but not the
qualitative reversal the reflexive rule implies. I'd report Callaway-Sant'Anna
as the headline: **ATT ≈ -0.04 log points (≈ -4% teen employment)** — it's
immune to already-treated-as-control contamination by construction (each
ATT(g,t) block uses only never- or not-yet-treated controls), and it sits at
the center of the modern estimates. TWFE would have told the same qualitative
story.
