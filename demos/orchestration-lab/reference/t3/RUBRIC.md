# T3 RUBRIC — what a correct reviewer reply must satisfy

*This is the grading key for T3. The brief asks the model to write a ~400-word
`memo.md` replying to a reviewer. Instead of a model memo, this file specifies
what any correct memo must contain, concede, and avoid. Score a submitted memo
against the checklist below. Headline attribute (from T2) = **Violent Crime
Rate**, a **binary** attribute — that fact is the whole game.*

## The reviewer's claim (restated)

AMCEs are defined relative to arbitrary reference categories; under different
baselines the "effect of Violent Crime Rate" could look different and the
ordering of attribute importance could change; the headline may be a baseline
artifact.

---

## A. The mechanical point that MUST be conceded  *(required to pass)*

- [ ] The memo concedes that AMCEs are baseline-relative, and that **for a
  multi-level attribute the reported level-vs-baseline AMCEs genuinely change
  when the baseline is relabeled.** It should back this with a number from the
  data, e.g. Total Daily Driving Time: the 25-min level is **−7.0 pp** against a
  10-min baseline but **+16.8 pp** against a 75-min baseline.
- A memo that denies this, or hand-waves it, **fails on candor.** The reviewer
  is mechanically correct about this part.

## B. The decisive fact about THIS headline  *(required to pass)*

- [ ] The memo states that the headline attribute is **binary**, so it has
  exactly **one** possible alternative baseline, and flipping it **only flips
  the sign** — the magnitude is invariant: **|AMCE| = 25.1 pp (IRR-corrected)
  / 16.5 pp (uncorrected)** either way.
- [ ] Therefore the "effect of Violent Crime Rate" **cannot** be a
  reference-category artifact. This is the crux; a memo that misses it has not
  answered the reviewer.
- Acceptable equivalent framing: for a binary attribute the AMCE **equals** the
  marginal-mean gap, MM(less crime) 62.6% − MM(more crime) 37.4% = 25.1 pp.

## C. What the marginal means actually show  *(required to pass)*

- [ ] The memo computes **marginal means** (the baseline-free quantity the brief
  demands) and uses them as the primary evidence.
- [ ] It reports that crime's MM spread (**25.1 pp**) is the **largest** of any
  attribute — but only **~1.4 pp** ahead of Driving Time (**23.7 pp**), with
  Housing Cost third (**19.8 pp**).
- [ ] It states that the **attribute-importance ordering by MM range is
  baseline-invariant** (crime > commute > housing > place > school > race >
  vote), so the reviewer's "the ordering could change" is **false** for MMs.

## D. The verdict: is the headline baseline-sensitive?

- **No**, for the existence, magnitude, and direction of the crime effect —
  invariant by construction (binary attribute; MMs are baseline-free).
- **One legitimate caveat:** crime's #1 rank over commute time is a ~1.4 pp gap
  with heavily overlapping CIs — **not statistically resolved.** A correct memo
  acknowledges this rather than asserting a clean ranking.

## E. What the revised manuscript MAY claim  *(required to pass)*

- [ ] **May claim:** violent crime rate is **one of the strongest / the largest
  single** driver of community choice; moving from 20% below to 20% above the
  national rate lowers the choice probability by **~25 pp** (IRR-corrected;
  ~17 pp uncorrected), **robust to reference-category choice.**
- [ ] **May claim:** its importance is **comparable to commute time** and ahead
  of housing cost.
- [ ] **Must NOT claim:** that crime **dominates** the other attributes; that it
  is **the** decisive factor; any claim resting on the AMCE **sign/label** as if
  substantive; any precise ranking that treats the crime-vs-commute gap as real.

---

## F. Common overclaims / errors to FLAG (deduct)

1. **Sign-flip confusion** — treating the flipped-baseline AMCE (+25.1 pp) as a
   substantive *reversal* of the finding. It is a relabeling, not a new result.
2. **Over-concession** — agreeing the headline is fragile / a likely artifact.
   The binary structure makes it robust; conceding it away is wrong.
3. **Under-concession** — dismissing the reviewer outright. The mechanical
   baseline-dependence is real for multi-level attributes and must be granted.
4. **Dominance overclaim** — calling crime the single dominant factor while
   Driving Time sits within ~1.4 pp with overlapping CIs.
5. **MM/AMCE confusion** — claiming marginal means are themselves
   baseline-sensitive. They are invariant by construction.
6. **Skipping the MMs** — only re-running AMCEs under new baselines and never
   computing the baseline-free quantity the brief requires.
7. **IRR silence** — quoting one magnitude (25.1 *or* 16.5 pp) without noting it
   is the IRR-corrected vs uncorrected choice (they differ by ~1.52×).
8. *(minor)* Discussing SEs in detail without noting projoint's CR2→"stata"
   clustered-SE fallback.

## G. Scoring

- **Pass** = A + B + C + E satisfied, with no error from #1–#6.
- **Strong/Distinction** = also nails D (flags the crime-vs-commute gap as within
  noise and calibrates the ranking claim) and reports both corrected and
  uncorrected magnitudes.
- **Fail** = misses the binary-invariance argument (B), or over-/under-concedes
  (F#2 / F#3), or treats the sign flip as a reversal (F#1).
