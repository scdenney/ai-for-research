# Answer key — the reference solutions the three tiers are graded against

This directory holds the **gold-standard** solutions to the three orchestration
briefs (`../prompts/t1-descriptive.md`, `t2-amce.md`, `t3-reviewer-memo.md`).
Every model run, under every orchestration mode, is scored against the numbers
and judgments below. The data is `projoint::exampleData1` (community-choice
conjoint); all figures and tables here were produced by the `t1/`, `t2/`, `t3/`
scripts, each run from its own directory.

- **Environment:** R 4.5.1, `projoint` 1.1.1, `ggplot2` 4.0.2.
- **Reproduce:** `cd reference/t1 && Rscript script.R` (likewise `t2`, `t3`).
- **Total analysis runtime:** ~5 s wall-clock for all three scripts combined
  (4.9 s measured; T1 ~1.3 s, T2 ~2.0 s, T3 ~1.9 s).
- **Determinism:** projoint's default estimator path (`.se_method="analytical"`)
  is **exactly reproducible** — identical estimates, SEs, and IRR across seeds.
  `set.seed(46)` is set as a convention; it is load-bearing only if a run
  switches to a bootstrap/simulation SE method.

> **Read this first — three facts that shape grading.** (1) The **headline
> attribute is Violent Crime Rate, which is binary**; that makes the T3
> baseline critique unusually easy to rebut (see the deviations note at the
> bottom — the T3 brief may need a wording amendment). (2) projoint reports
> **both IRR-corrected and uncorrected AMCEs**; the corrected values are its
> default headline, but the *headline attribute and the attribute ranking are
> the same under either*, so accept either as long as it is labeled. (3) The
> "seed matters / bootstrap SEs" note in the briefs is **not true of projoint's
> defaults** — the default path is analytical and deterministic.

---

## T1 — Describe the design (expected numbers)

| Quantity | Expected value |
|---|---|
| Respondents | **400** |
| Choice tasks per respondent | **8** |
| Profiles per task | **2** |
| Total profile rows (long format) | **6,400** |
| Total choice tasks | **3,200** (one profile selected in each) |
| Attributes | **7** |
| Repeated task | **1** (task 1, flipped, for reliability) |
| Raw intra-respondent reliability | **71.5%** repeated-task agreement (572 / 800) |

**Per-attribute level counts (human-readable names required):**

| Attribute | # levels |
|---|---|
| Housing Cost | 3 |
| Presidential Vote (2020) | 3 |
| Racial Composition | 4 |
| School Quality | 2 |
| Total Daily Driving Time for Commuting and Errands | 4 |
| Type of Place | 6 |
| Violent Crime Rate (Vs National Rate) | 2 |

**Balance verdict: sound, with one minor, honest flag.** Six of seven
attributes are statistically indistinguishable from uniform (max within-attribute
deviation < 1 pp). **Total Daily Driving Time is mildly imbalanced** — χ² = 14.6
(df = 3), p = 0.002, largest deviation **1.94 pp** (the 25-min level is
over-represented at 26.9% vs a 25% target). With 6,400 rows the χ² test detects
even trivial departures, so the correct call is: *randomization looks sound; one
attribute shows a statistically detectable but substantively negligible
(< 2 pp) imbalance that should be disclosed, not papered over as "perfect
balance."* A run that claims flawless balance without noticing the driving-time
departure is **less** correct than one that flags it.

*Figure:* one faceted bar chart of within-attribute level frequencies with a
uniform-expectation reference line (`t1/figures/level-frequencies.png`).

---

## T2 — AMCEs (expected estimates)

**Headline attribute = Violent Crime Rate (Vs National Rate)** — the largest
absolute AMCE, and it holds that rank under *both* the corrected and the
uncorrected estimand (robust pick). The single contrast (20% More vs 20% Less
crime) is **−25.1 pp** corrected / **−16.5 pp** uncorrected.

**projoint default choices (must be recorded in a correct T2 answer):**

- Profile-level AMCE (`.structure="profile_level"`, `.estimand="amce"`).
- **IRR correction ON** — projoint estimates intra-respondent reliability from
  the repeated task (**tau = 0.172**) and reports IRR-**corrected** AMCEs as its
  default; uncorrected AMCEs are ~1.52× smaller (constant factor 1.525).
- **SE method = "analytical"**, auto-clustered on respondent `id`. *projoint
  surprise:* CR2 produced non-positive-definite variances, so it fell back to
  `se_type = "stata"` (Stata clustered SEs). Internal fallback, not a choice.
- Ties removed (`.remove_ties=TRUE`); profile position ignored
  (`.ignore_position=TRUE`).

**AMCE point estimates (percentage points; corrected = projoint default):**

| Attribute | Level (vs reference) | AMCE corrected | AMCE uncorrected |
|---|---|---:|---:|
| Housing Cost | 30% of pre-tax income | −13.7 | −9.0 |
| Housing Cost | 40% of pre-tax income | −19.8 | −13.0 |
| Presidential Vote | 50% Dem, 50% Rep | +5.3 | +3.5 |
| Presidential Vote | 70% Dem, 30% Rep | −0.3 | −0.2 |
| Racial Composition | 75% White, 25% Nonwhite | +3.7 | +2.4 |
| Racial Composition | 90% White, 10% Nonwhite | −2.3 | −1.5 |
| Racial Composition | 96% White, 4% Nonwhite | −1.2 | −0.8 |
| School Quality | 9 out of 10 | +11.6 | +7.6 |
| Driving Time | 25 min | −7.0 | −4.6 |
| Driving Time | 45 min | −14.1 | −9.2 |
| Driving Time | 75 min | −23.7 | −15.6 |
| Type of Place | City, more residential | +11.5 | +7.5 |
| Type of Place | Rural area | +13.5 | +8.8 |
| Type of Place | Small town | +15.8 | +10.3 |
| Type of Place | Suburban, houses only | +7.9 | +5.2 |
| Type of Place | Suburban, mixed use | +14.6 | +9.6 |
| **Violent Crime Rate** | **20% More Crime** | **−25.1** | **−16.5** |

Reference levels (each attribute's level 1) are fixed at 0. Full CIs are in
`t2/report.md`.

**Tolerance for grading.** With projoint defaults the estimates are **exact and
seed-independent** (reproduce to the digit). Apply a **±1.0 pp** tolerance only
to accommodate runs that legitimately deviate:

- A run that switches to `.se_method="bootstrap"`/`"simulation"` gets point
  estimates that shift ~1–2% across seeds (projoint re-estimates tau per
  resample) — a few tenths of a pp — and SEs that move up to ~0.6 pp.
- A run that reports **uncorrected** AMCEs (or uses a non-projoint tool such as
  `cregg`) lands near the uncorrected column — accept it **if labeled as
  uncorrected**. Do not accept an uncorrected number presented as corrected.
- **Non-negotiable regardless of tolerance:** the headline attribute (Violent
  Crime Rate), the sign/direction of every large effect, and the attribute
  ordering must match.

*Figure:* one Hainmueller-style dot-and-whisker of the (corrected) AMCEs with
95% CIs, grouped by attribute, references at zero
(`t2/figures/amce-dotwhisker.png`).

---

## T3 — Answer the reviewer (rubric summary + key numbers)

Full grading checklist: **`t3/RUBRIC.md`**. Full numbers and figure:
**`t3/sensitivity-table.md`**, `t3/figures/sensitivity.png`.

**The one-paragraph answer.** The reviewer is *mechanically* right that AMCEs are
baseline-relative — and for multi-level attributes the level-vs-baseline numbers
really do move (Driving Time's 25-min level is −7.0 pp against a 10-min baseline
but +16.8 pp against a 75-min baseline). **But the headline attribute is binary**,
so it has exactly one alternative baseline and flipping it only flips the sign:
**|AMCE| = 25.1 pp corrected / 16.5 pp uncorrected, invariant.** The
baseline-free **marginal means** confirm it — crime has the **widest MM spread of
any attribute** — and the **importance ordering by MM range is baseline-invariant.**
So the finding is **not** a baseline artifact.

**Key sensitivity numbers:**

- Headline att7 AMCE: **−25.1 pp** (default baseline) / **+25.1 pp** (flipped) —
  magnitude identical; uncorrected **±16.5 pp**.
- Driving Time AMCE spread **23.7 pp** — preserved across baselines even as
  every level number changes.
- Violent Crime Rate marginal means: **62.6%** (less crime) vs **37.4%** (more
  crime).
- **Attribute importance by MM range (baseline-invariant):** Violent Crime Rate
  **25.1** > Driving Time **23.7** > Housing Cost **19.8** > Type of Place
  **15.8** > School Quality **11.6** > Racial Composition **5.9** > Presidential
  Vote **5.6** (pp).

**The verdict and the claim ceiling.** Crime's effect is robust in existence,
magnitude, and direction. The *only* real caveat: crime's #1 rank sits just
**~1.4 pp** ahead of commute time, with overlapping CIs — not statistically
resolved. So the revised manuscript **may** say crime is *the largest single /
one of the strongest* drivers, **comparable to commute time**; it **may not** say
crime *dominates* or is *the* decisive factor. A memo that treats the sign flip
as a reversal, over-concedes the finding as fragile, or claims a clean
dominance ranking is wrong — see `t3/RUBRIC.md` §F.

---

## What a human still has to decide

The scripts and this key settle what is *computable*. They do **not** settle the
judgment calls a methodologist still owns:

1. **Corrected or uncorrected as the number of record.** projoint's IRR
   correction (×1.525 here) is a real modeling stance, not a default to accept
   blindly. Reporting a 25-pp effect vs a 16-pp effect is a choice about how much
   to trust the repeated-task reliability model — the human decides which to lead
   with, and must disclose it either way.
2. **How to treat the driving-time imbalance.** 1.94 pp is statistically
   detectable but substantively tiny. Disclose and move on, or re-weight / robust-
   check? A defensible call either way — but "perfect balance" is not defensible.
3. **The crime-vs-commute ranking.** The data cannot resolve a ~1.4-pp,
   CI-overlapping gap. Whether the paper's story rests on crime being *the* top
   factor, or simply *among* the top, is a substantive framing decision the
   numbers will not make for you.
4. **What "drives community choice" means substantively.** A 25-pp AMCE is large
   for a survey experiment, but external validity — does a forced-choice conjoint
   over hypothetical communities predict real moving behavior? — is a claim no
   estimator adjudicates.
5. **Whether the binary headline is the right headline at all.** Violent Crime
   Rate wins the "largest |AMCE|" test partly *because* it is a wide, two-level
   contrast. A human might argue the more interesting story is a multi-level
   attribute (commute time, housing cost) with a dose-response gradient. The
   metric picks crime; the scientist decides whether that is the point.

---

### Note for demo maintainers — deviations from the briefs

- **T3 wording, `{HEADLINE_ATTR}` is binary.** The headline attribute (largest
  |AMCE|) is Violent Crime Rate, a 2-level attribute. The T3 brief says
  "re-estimate under **at least two alternative reference-category sets**
  (different baselines for `{HEADLINE_ATTR}` …)." A binary attribute has only
  **one** alternative baseline, so "two alternative baselines *for the headline*"
  is not literally satisfiable. The reference solution handles this by (a)
  showing the headline's single baseline flip (magnitude-invariant) and (b)
  varying a **multi-level** attribute's baseline to demonstrate the general
  point. **Suggested amendment:** reword T3 to "different baselines for
  `{HEADLINE_ATTR}` where possible, and for at least one multi-level attribute,"
  or accept that the binary headline is itself the punchline. This is arguably a
  *feature* — it makes T3 a genuine judgment test (over-concession is the trap).
- **"projoint uses bootstrap SEs — seed matters."** Not true of the defaults
  (`.se_method="analytical"`). Consider softening the parenthetical in the T1/T2/
  T3 briefs to "set a seed as a convention; it matters only under bootstrap/
  simulation SEs."
