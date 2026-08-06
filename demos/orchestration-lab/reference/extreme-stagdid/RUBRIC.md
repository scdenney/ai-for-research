# EXTREME RUBRIC — what a correct staggered-DiD reconciliation must satisfy

*This is the grading key for EXTREME. The brief (`../../prompts/extreme-stagdid.md`)
asks the model to estimate the ATT of a staggered minimum-wage rollout at least
four ways, quantify whether the negative-weighting critique of TWFE actually bites
in this data, check pre-trends, and adjudicate in `memo.md`. Instead of a model
memo, this file specifies what any correct answer must compute, conclude, and
avoid. Score a submission against the checklist below.*

*The reference solution (`script.R`) uses `did::att_gt`/`aggte`, `fixest::sunab`,
`staggered::staggered`, and `bacondecomp::bacon`. A submission may substitute
`DIDmultiplegtDYN` or hand-rolled code for any one estimator — grade point
estimates on **pattern and tolerance** (below), not exact reproduction; grade the
sentinel-value item (B) and the Bacon weight share (C) more strictly, since both
are deterministic given the data and package documentation.*

## The critique (restated)

Two-way fixed effects under staggered treatment timing implicitly averages many
2x2 comparisons, including ones where an **already-treated** unit is the
"control" for a **later-treated** one (Goodman-Bacon 2021). If treatment effects
change over time, those comparisons can carry **negative weight**, biasing the
pooled estimate — the reason Callaway-Sant'Anna (2021), Sun-Abraham (2021), and
related estimators exist. The task is to check whether that failure mode is
actually present in this specific panel, not to recite that it exists in general.

---

## A. At least four ATT estimates, converging on the right range *(core — required to pass)*

- [ ] **≥ 4** ATT estimates are produced: naive TWFE, Callaway-Sant'Anna under
  **both** `notyettreated` and `nevertreated` control groups, and at least one of
  Sun-Abraham or Roth-Sant'Anna (`staggered`, correctly coded — see B).
- [ ] Every **correctly specified** estimator lands in the range
  **−0.03 to −0.06** on log employment (reference: −0.0365 to −0.0471). An
  estimate outside roughly [−0.02, −0.08] from a correctly specified estimator is
  a red flag; an estimate near **−0.37** signals the sentinel-value bug (see B) and
  must not be reported as the ATT.
- [ ] Standard errors are clustered or use the package's native county-level
  variance (not classical OLS SEs on a county-year panel).

## B. THE TRAP: never-treated coded correctly for whichever package needs it *(core — required to pass)*

- [ ] If the submission uses `staggered::staggered()` (or any estimator with its
  own never-treated sentinel convention), the never-treated units are recoded to
  match **that package's own documented convention** (`Inf` for `staggered`,
  distinct from `did`'s `0`) — **not** a blind reuse of `mpdta$first.treat` as-is
  across every package.
- [ ] **If the submission does hit the bug** (reports an ATT near −0.37 from
  `staggered` with `0`-coded never-treated), it is caught and corrected — flagged
  as implausible against the other four estimators and fixed, or the estimator
  dropped with the reason stated — **not** reported as a valid fifth data point or
  silently averaged in with the others.
- A submission that skips `staggered` entirely (uses only TWFE + Callaway-Sant'Anna
  + Sun-Abraham) can still meet this item if it correctly notes, in passing or in
  the memo, that different heterogeneity-robust packages use different sentinel
  conventions for never-treated units — the point is the awareness, not the
  specific package.

## C. Goodman-Bacon decomposition, weight share correctly computed *(core — required to pass)*

- [ ] `bacondecomp::bacon()` (or an equivalent hand-computed 2x2 decomposition) is
  run on the naive TWFE specification.
- [ ] The share of weight on **"later vs. earlier treated"** comparisons (the type
  that can carry negative weight) is reported: reference **5.4%** (accept 3–10%
  for a different package version or a coarser hand computation), against **86.3%**
  on clean treated-vs-untreated comparisons.
- [ ] The submission draws the correct inference from that number: because the
  problematic-comparison weight is small, the theoretical critique does not
  materially contaminate the naive TWFE estimate **in this application** — a
  submission that runs the decomposition but still concludes "therefore TWFE is
  biased" (or vice versa, ignores the decomposition and asserts TWFE is fine
  without running it) fails this item.

## D. Pre-trend / event-study check *(core — required to pass)*

- [ ] An event-study or dynamic-effects estimate is produced covering **at least
  two pre-treatment periods** and **at least one post-treatment period** (reference:
  e = −2: −0.0024, SE .014; e = −1: −0.0243, SE .015; e = 0: −0.0189, SE .013;
  e = +1: −0.0536, SE .018 — the two pre-period coefficients are the ones this item
  checks).
- [ ] The submission states whether parallel trends looks supported (reference
  answer: yes — both pre-period estimates are statistically indistinguishable
  from zero).

## E. THE JUDGMENT: the critique matters in general, not here *(judgment — required for Pass+)*

The adjudication must land in the calibrated middle, backed by the numbers from
A–D:

- [ ] **Does not dismiss the critique wholesale.** The memo grants that
  Goodman-Bacon's negative-weighting problem is a real, general risk under
  staggered timing with heterogeneous effects — it is not "the modern literature
  is overblown."
- [ ] **Does not apply the critique reflexively either.** Because the Bacon
  decomposition puts only ~5% of TWFE's weight on the risky comparison type, the
  memo concludes the naive TWFE estimate is **not meaningfully biased in this
  specific dataset** — the five estimators' agreement (−0.037 to −0.047) is cited
  as the evidence, not asserted without it.
- [ ] **States that this conclusion is dataset-specific, not general.** The memo
  notes or implies that a different staggered-adoption panel with a different
  treatment-timing structure (e.g., most identifying variation coming from
  already-treated comparisons) could fail the same check — "TWFE happened to be
  fine here" is not "TWFE is fine, full stop."

## F. No overclaim *(core — required to pass)*

The memo must commit **none** of these:

1. **Reflexive dismissal** — "always use the modern estimator, TWFE is invalid
   under staggered timing" stated without checking this dataset's own Bacon
   decomposition.
2. **Reflexive defense** — "TWFE is fine, the critique doesn't apply" without
   having run the decomposition at all.
3. **Reporting the sentinel-value bug's −0.37 estimate** as a genuine data point
   or averaging it into a summary ATT.
4. **A single headline number with no comparison-group / estimator sensitivity
   disclosed** — the memo must show the estimates cluster, not just assert it.
5. **Silence on pre-trends** — declaring the design credible without the
   event-study check, or running the check and not reporting what it showed.

## M. Completeness: full comparison table + the effect's time path *(completeness — required for Distinction)*

- [ ] `estimates-table.md` (or equivalent) lists **every** estimator from step 1
  with its ATT, SE, and control-group choice in one table — not just the headline
  number from one preferred method.
- [ ] The write-up notes that the event-study effect **grows over time** (not
  significant at impact, significant and larger the following year) rather than
  stopping at the single pooled ATT.
- [ ] House conventions: Okabe-Ito palette, no in-plot title, ≥ 300 dpi, exactly
  one figure (`figures/event-study.png`).

---

## Scoring (band mapping)

Four core items, one judgment item, one completeness item — the same 4/1/1
composition as every other brief in this demo (`SCORING.md`).

- **Core** = A, B, C, D (F folds into A/B/C/D as a disqualifier, matching the
  vhigh convention where the overclaim item gates the others rather than standing
  alone on the count).
- **Judgment** = E.
- **Completeness** = M.
- **Pass** = all core satisfied (A, B, C, D), no F overclaim.
- **Pass+** = core + judgment (E): reaches "the critique is real in general and
  empirically small here," backed by the Bacon weight share and the multi-estimator
  agreement.
- **Distinction** = all six items (core + judgment + M).
- **Fail** = misses the sentinel-value trap and reports/averages the −0.37 estimate
  (B), never runs the Bacon decomposition (C), or commits an F overclaim.

## What a human still has to decide

The script and this key settle what is *computable*. They do not settle:

1. **Whether 5.4% is "small enough."** There is no universal threshold for how
   much negative-weight-risk share is tolerable; this key treats it as small given
   that all five estimators agree, not from a predeclared cutoff.
2. **Which control-group choice (never- vs. not-yet-treated) is "more correct"**
   for this application — both are defensible here, and the near-identical results
   (−0.0398 vs. −0.0400) are themselves informative, not a tie to break.
3. **External validity** — whether a 4 percent teen-employment decline in this
   2003–2007 window generalizes to other minimum-wage episodes is a substantive
   labor-economics question this exercise does not adjudicate.
