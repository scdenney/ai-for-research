# Scoring the runs

This file defines the three bands (Pass, Pass+, Distinction) and puts them on a shared
numeric axis so a chart can draw dotted threshold lines. Grading is by binary items
derived from `reference/ANSWER-KEY.md` (T1 Describe, T2 Estimate), `reference/t3/RUBRIC.md`
(T3 Reviewer-reply), `reference/high-ajr/RUBRIC.md` (IV replication), and
`reference/vhigh-lalonde/RUBRIC.md` (Methods dispute). Each item is classed core,
judgment, or completeness.

Core items are pass-blocking facts a competent run must get right. The judgment item is
the discretionary call the answer key hands to the analyst. The completeness item rewards
thoroughness past a correct answer. Every brief carries four core items, one judgment
item, and one completeness item, six in all, so the three briefs share one axis and the
same threshold lines.

## How scoring works

Stated plainly, because a reader deciding whether to trust a Fail band needs to know
exactly what "graded" means here. Each rubric item is checked against the run's actual
files on disk, quoting the specific passage or code line that satisfies (or fails to
satisfy) it — not a holistic read of the write-up. The reference numbers each core item
checks against come from a deterministic reference script (`reference/*/script.R`),
verified to reproduce to the digit; a run either matches that number (within the stated
tolerance) or it does not. That part is mechanical.

Two parts are not. First, one item per brief is explicitly built as a **judgment** item,
by rubric design, not by accident — the answer key hands the analyst a genuine discretionary
call (e.g., whether a gap counts as "within noise"), and grading it means assessing whether
the run's own reasoning is defensible, not matching it against a fixed string. Second, even
a **core** item's wording can itself need correction mid-project: the T1 "repeated task"
item originally conflated two different things (handling the task correctly in the code vs.
narrating it in prose), and fixing that required re-reading the underlying scripts, not
just re-running a check (see the 2026-07-17 correction below).

Grading is currently **single-pass**: one scorer, one submission at a time, evidence quoted
from disk. There is no second-scorer or inter-rater step anywhere in this project — a real
limitation worth stating rather than leaving implicit, especially for a Fail verdict, which
is why the one Fail in the current matrix (`advisor / extreme-stagdid-codex`) gets an
independent re-derivation from primary evidence below rather than a repetition of the
original note.

## Bands

| Band | Rule (categorical, primary) | Normalized score |
|---|---|---|
| Pass | every core item met | 4/6 = 0.67 |
| Pass+ | every core item met, plus the judgment item | 5/6 = 0.83 |
| Distinction | every item met, core and judgment and completeness | 6/6 = 1.00 |

A run that misses any core item is a Fail whatever its fraction. No number of judgment or
completeness items redeems a missed core item.

The categorical rule is primary. The normalized score is its chart representation, items
met divided by six, on a 0-to-1 axis shared by all five briefs. Dotted lines fall at 0.67
(Pass), 0.83 (Pass+), and 1.00 (Distinction). Because every brief is built four core, one
judgment, one completeness, the same three lines serve all of them.

## T1 (Describe the design)

| Item | Class | Met when |
|---|---|---|
| Design counts | core | states 400 respondents, 8 tasks each, 2 profiles per task, 6,400 profile rows |
| Attribute set | core | names all 7 attributes in human-readable form, not att1..att7 |
| Level counts | core | per-attribute level counts read 3, 3, 4, 2, 4, 6, 2 |
| Repeated task | core | handles the repeated flipped task correctly: reports 6,400 total rows (not 7,200), which is only reachable by excluding it from the primary 8-task count. An explicit sentence naming the repeated task is not required for this item; see the 2026-07-17 note below for why. |
| Honest balance flag | judgment | names Total Daily Driving Time as the lone imbalance and makes no "perfect balance" claim |
| Max-deviation precision | completeness | reports the exact max deviation from uniform (~1.94 pp), not only a min-max spread |

**2026-07-17 correction to the "Repeated task" item.** The original wording conflated two different things under one core item: (1) handling the repeated task correctly in the analysis itself (not inflating the row count to 7,200 by treating it as a 9th task), and (2) writing an explicit sentence in the report naming the repeated task and its reliability-check purpose. Direct inspection of `runs/fable/t1/script.R` and `runs/opus/t1/script.R` (2026-07-17 captures) shows both correctly reference `choice1_repeated_flipped` as the repeated-task outcome column, separate from the eight primary `choice1..choice8` columns, and both `summary.md` files report 6,400 rows, the value only reachable by getting this right. Neither summary contains an explicit sentence naming the repeated task, which is item (2), a write-up completeness gap, not a design-understanding failure. Scoring this compound item as "missed" because of (2) alone — while the actual data-generating-process understanding in (1) is intact and verified in the code — overstates the defect: it is a narrower miss than "does not understand the design," and a rubric that cannot tell those two apart is a rubric bug, not a model failure. The item is now scored on (1) only; an explicit mention of the repeated task's purpose is credit toward completeness (see the retro-scores below), not a pass/fail gate on its own.

## T2 (Estimate the AMCEs)

| Item | Class | Met when |
|---|---|---|
| Crime headline | core | Violent Crime Rate is the largest \|AMCE\|, magnitude right for its stated scale (~25.1 corrected / ~16.5 uncorrected, never uncorrected labeled corrected) |
| Direction and order | core | every large effect signs correctly and the attribute ordering matches the key |
| Clustered SEs | core | standard errors clustered on respondent id |
| AMCE zeroing | core | every attribute's reference level fixed at 0, estimates presented as AMCEs |
| Estimand disclosed | judgment | states corrected or uncorrected as a deliberate choice, either acceptable when labeled |
| projoint defaults in full | completeness | names the profile-level estimand and the IRR mechanism (tau ~0.17, x1.52), correction explained not asserted |

## T3 (Answer the reviewer)

| Item | Class | Met when |
|---|---|---|
| Baseline-relativity conceded (A) | core | grants that multi-level AMCEs move under relabeling, backed by a number from the data |
| Binary-invariance argument (B) | core | states crime is binary so a flip only flips the sign, \|AMCE\| = 25.1/16.5 invariant |
| Marginal means as evidence (C) | core | computes MMs (.626/.374) and uses the baseline-free MM range as the ranking currency |
| Claim ceiling (E) | core | may call crime the largest single, commute-comparable driver, must not say it dominates |
| Statistical-tie caveat (D) | judgment | flags the ~1.4 pp crime-vs-commute gap as within noise, CIs overlapping |
| Both magnitudes (F) | completeness | reports both the uncorrected 16.5 and corrected 25.1 pp |

## IV replication (high), Methods dispute (very high), and Staggered-DiD reconciliation (extreme)

The three ladder briefs carry their own item lists, already in the shared 4/1/1
composition, in `reference/high-ajr/RUBRIC.md` (core A replication, B stress specs,
C weak-instrument flagging, E no overclaim; judgment D, the claim ceiling; completeness
M, one unified table), `reference/vhigh-lalonde/RUBRIC.md` (core A anchors, C spec
curve with pre-earnings, D benchmark-referenced table, F no overclaim; judgment E, the
"helps but does not settle" adjudication; completeness M, the benchmark-referenced
figure), and `reference/extreme-stagdid/RUBRIC.md` (core A four-estimator convergence,
B the never-treated sentinel-value trap, C the Goodman-Bacon weight share, D the
pre-trend check; judgment E, "the critique is real in general and empirically small
here"; completeness M, the full comparison table plus the event-study time path). The
same three threshold lines apply unchanged.

## Retro-scores

**2026-07-17 full ladder rerun (current record).** All five historical briefs re-run in
one sitting under consistent current settings, plus the new Extreme tier; five arms per
tier (fable, opus, advisor-Claude, 46 headless, 46-sol interactive). Scored independently,
one submission at a time, quoting evidence from disk. Every entry below is a fresh draw,
not a re-scoring of an old capture — differences from the 2026-07-12/13 tables further
down are expected non-determinism (see `RESULTS.md`'s "full ladder rerun" section for the
T1 correction and the Extreme-tier finding), not corrections to them.

| Run | Items met | Points | Norm | Band |
|---|---|---|---|---|
| fable / t1 | design counts, attribute set, level counts, repeated task | 4/6 | 0.67 | Pass (see 2026-07-17 correction above; misses honest flag and max-deviation) |
| fable / t2 | crime headline, direction/order, clustered SEs, AMCE zeroing, estimand disclosed | 5/6 | 0.83 | Pass+ |
| fable / t3 | all six | 6/6 | 1.00 | Distinction |
| fable / high-ajr | all six | 6/6 | 1.00 | Distinction |
| fable / vhigh-lalonde | all six | 6/6 | 1.00 | Distinction |
| fable / extreme-stagdid | all six | 6/6 | 1.00 | Distinction |
| opus / t1 | design counts, attribute set, level counts, repeated task | 4/6 | 0.67 | Pass (see 2026-07-17 correction above; misses honest flag and max-deviation) |
| opus / t2 | all six | 6/6 | 1.00 | Distinction |
| opus / t3 | all six | 6/6 | 1.00 | Distinction |
| opus / high-ajr | all six | 6/6 | 1.00 | Distinction |
| opus / vhigh-lalonde | all six | 6/6 | 1.00 | Distinction |
| opus / extreme-stagdid | all six | 6/6 | 1.00 | Distinction |
| advisor / t1-claude | all six | 6/6 | 1.00 | Distinction |
| advisor / t2-claude | all six | 6/6 | 1.00 | Distinction |
| advisor / t3-claude | A, B, C, D, E | 5/6 | 0.83 | Pass+ (misses F, both magnitudes) |
| advisor / high-ajr-claude | all six | 6/6 | 1.00 | Distinction |
| advisor / vhigh-lalonde-claude | all six | 6/6 | 1.00 | Distinction |
| advisor / extreme-stagdid-claude | all six (after one revision) | 6/6 | 1.00 | Distinction |
| advisor / t1-codex | design counts, attribute set, level counts, repeated task, max-deviation | 5/6 | 0.83 | Pass (misses honest balance flag) |
| advisor / t2-codex | crime headline, direction/order, clustered SEs, AMCE zeroing, estimand disclosed | 5/6 | 0.83 | Pass+ |
| advisor / t3-codex | A, B, C, E | 4/6 | 0.67 | Pass (misses D statistical-tie caveat and F both magnitudes) |
| advisor / high-ajr-codex | all six | 6/6 | 1.00 | Distinction |
| advisor / vhigh-lalonde-codex | all six | 6/6 | 1.00 | Distinction |
| advisor / extreme-stagdid-codex | A, C, D, E | 4/6 | 0.67 | **Fail** (misses B, the sentinel-value trap — never touches `staggered` or its convention, and never states the required cross-package awareness the rubric's escape clause needs; see the 2026-07-17 Codex-advisor scoring note below for why this is a real miss, not a rubric artifact) |
| 46 / t1 | design counts, attribute set, level counts, repeated task | 4/6 | 0.67 | Pass |
| 46 / t2 | crime headline, direction/order, clustered SEs, AMCE zeroing, estimand disclosed | 5/6 | 0.83 | Pass+ |
| 46 / t3 | A, B, C, E | 4/6 | 0.67 | Pass |
| 46 / high-ajr | A, B, C, E, M | 5/6 | 0.83 | **Pass** (judgment item D missing, fraction-above-band case) |
| 46 / vhigh-lalonde | all six (thin prose, flagged) | 6/6 | 1.00 | Distinction |
| 46 / extreme-stagdid | all six | 6/6 | 1.00 | Distinction |
| 46-sol / t1 | design counts, attribute set, level counts, repeated task | 4/6 | 0.67 | Pass |
| 46-sol / t2 | crime headline, direction/order, clustered SEs, AMCE zeroing, estimand disclosed | 5/6 | 0.83 | Pass+ |
| 46-sol / t3 | all six | 6/6 | 1.00 | Distinction |
| 46-sol / high-ajr | all six | 6/6 | 1.00 | Distinction |
| 46-sol / vhigh-lalonde | all six | 6/6 | 1.00 | Distinction |
| 46-sol / extreme-stagdid | all six | 6/6 | 1.00 | Distinction |

**Why one Fail was a rubric artifact and the other is not.** This rerun surfaced two
candidate Fail bands, and they are not the same kind of miss — worth stating explicitly
so neither gets waved away nor kept out of caution.

fable/t1 and opus/t1 were *initially* banded Fail on 2026-07-17 because neither
`summary.md` contains an explicit sentence naming the repeated/flipped reliability task
(grepped case-insensitively for `repeat|flip|9th|ninth`, zero hits in either file). But
both arms' `script.R` correctly references `choice1_repeated_flipped` as a column
separate from the eight primary tasks, and both summaries report 6,400 rows, not the
7,200 a genuine miscount would produce. The design understanding was intact and provable
from the code; only one explanatory sentence was missing. Scoring that as a missed core
item conflated "handles it correctly" with "narrates it," so it was corrected to Pass
(see the 2026-07-17 note in the T1 section above and in `RESULTS.md`).

advisor/extreme-stagdid-codex is a different case, and it was independently re-derived
from primary evidence on 2026-07-18 (not just re-read) after the owner asked to be
extremely sure before trusting a Fail. Its `memo.md` and `estimates-table.md` never
invoke the `staggered` package, which is a defensible choice the rubric explicitly
allows, but the rubric's own escape clause requires the write-up to then state, in
passing or in the memo, that different heterogeneity-robust packages use different
never-treated sentinel conventions — the exact awareness the whole brief is built to
test. "In passing" is read here as within the three graded deliverables (`memo.md`,
`estimates-table.md`, `script.R`), the same standard the escape clause's "in the memo"
half makes explicit — that is the premise the whole verdict below rests on, so it is
stated outright rather than assumed. Grepping the three graded deliverables (`memo.md`, `estimates-table.md`,
`script.R`) for `sentinel|Inf|staggered::|first.treat` returns six lines, not one; five
are plain variable references to the `first.treat` column name, and the sixth is a bare
code comment in `script.R` describing only `did`'s own `0` convention, never contrasted
against any other package. None of the six is a cross-package statement.

A materially relevant fact the original note missed: the model *did* state the required
awareness once, verbatim, in its own tool-call transcript. `exec-step1.log` records it
reading the `staggered` package's help page and concluding "the local package
documentation confirms the key conventions: `did` uses `0` for never-treated cohorts,
while `staggered` uses `Inf`" — before choosing not to use `staggered` and never carrying
that sentence into the memo. That does not change the Fail: `RUBRIC.md`'s escape clause
requires the awareness to surface "in passing or in the memo," and a tool-call log is
neither of the task's specified deliverables. If anything it strengthens the case for
Fail rather than weakening it — this was not a blind spot the model never encountered,
it was demonstrated awareness that never reached any graded deliverable, the exact
failure mode the item is designed to catch. (The brief itself, `prompts/extreme-stagdid.md`,
hands the model both conventions in a Method note, so the awareness being available is
not in question either way — the item tests whether it carries through into the
deliverable, not whether the model could discover it.) There is no code and no sentence
in any graded deliverable demonstrating the required awareness — nothing analogous to
the T1 arms' correct row count to point to. That is a real, evidenced miss on the item
the rubric actually gates on, not a compound item punishing a narrower omission.

To close a gap a literal reading of the rubric could otherwise leave open: `RUBRIC.md`'s
own "Fail =" line defines Fail as reporting or averaging in the −0.37 sentinel-bug
estimate, never running the Bacon decomposition, or an overclaim on item E — this run did
none of those. It fails item B via the escape clause instead (skips `staggered` without
the required cross-package note), and reaches Fail only through the bands' non-
compensatory structure (Pass requires every core item met; B unmet means no band is
reached, which is Fail by definition, not a separate rule). That chain is sound but was
previously left implicit — stated here so a reader checking the rubric directly can
follow it. It stays a **Fail**.

## 2026-07-19 retro-scores — advisor (Codex), xhigh rerun (current record for this arm)

The Codex-side advisor arm reran under corrected settings. `gpt-5.6-terra` now runs at
XHIGH, up from medium, for the solve and revise steps, and `gpt-5.6-sol` stays at XHIGH
for the read-only consult. This supersedes the six `advisor / *-codex` rows in the
2026-07-17 table above for this arm specifically. Nothing is deleted, and both tables
stay on record. New captures live in `runs/advisor-v2/`.

| Run | Items met | Points | Norm | Band |
|---|---|---|---|---|
| advisor-v2 / t1-codex | all six | 6/6 | 1.00 | Distinction |
| advisor-v2 / t2-codex | crime headline, direction/order, clustered SEs, AMCE zeroing, estimand disclosed | 5/6 | 0.83 | Pass+ (misses completeness — τ = 0.172 and the ×1.52 correction factor go unstated) |
| advisor-v2 / t3-codex | A, B, C, D, E | 5/6 | 0.83 | Pass+ (misses completeness F, both magnitudes — reports the corrected 25.1pp only, never the uncorrected 16.5pp) |
| advisor-v2 / high-ajr-codex | all six | 6/6 | 1.00 | Distinction |
| advisor-v2 / vhigh-lalonde-codex | A, B, C, D, F, M | 5/6 | 0.83 | Pass (misses judgment E, so the band is capped despite the 5/6 fraction — see note below) |
| advisor-v2 / extreme-stagdid-codex | A, C, D, F | 4/6 | 0.67 | **Fail** (misses core B, the sentinel-value trap — see note below, a different mechanism than the 2026-07-18 Fail above) |

Four of six tiers moved up at least one band on real, quotable Sol-consult catches.
`advisor-v2/t1-codex`'s judgment item (honest balance flag) is met only after revision.
`advice.md` instructs "Add an interpretive sentence: 'The largest departure...'" The
revised `summary.md` carries that sentence, word for word, absent from the pre-revision
draft. `advisor-v2/t3-codex`'s judgment item (D, the statistical-tie caveat) is met the
same way. `advice.md` requests "estimate the direct contrast... with its confidence
interval," and `sensitivity-table.md` now reports "0.014 [-0.099, 0.124]," a CI crossing
zero, not present before revision. `advisor-v2/high-ajr-codex`'s catch is the largest of
the six. `advice.md` opens "The submission is incomplete: `memo.md` is missing. Add the
required roughly 400-word memo before anything else," confirmed by `briefing.md`'s
pre-revision deliverables list, which shows only `robustness-table.md` and `script.R`.
Without that catch this tier would likely have failed the judgment and no-overclaim
items outright for lack of any written adjudication.

advisor-v2/vhigh-lalonde-codex misses judgment item E despite the consult fixing three
real statistical issues. Two were a conflation of trimming with propensity
re-estimation and a missing balance-diagnostics check. The third treated
benchmark-interval overlap as invalid correlated inference. All three are corrected in
the final `memo.md`/`spec-table.md`. None of those fixes touch what E actually requires.
E requires that pre-treatment earnings conditioning is the *necessary*, decisive
ingredient across all eight specs, not just the one that happened to land closest to the
benchmark. Grepping `memo.md` for "necessary" and "demographics-only" turns up only
descriptive mentions of individual specs. A further search for "pre-earnings" finds the
same, never the general claim. The consult was thorough on mechanics and silent on the
one narrative thread the judgment item gates on.

advisor-v2/extreme-stagdid-codex is a Fail, and the mechanism is different from the
2026-07-18 Fail documented above, worth stating precisely rather than folding into the
same note. The 2026-07-18 Fail did state the sentinel-trap awareness once, in its own
tool-call log, but never carried it into any graded deliverable (memo, table, or
script) — the documented reading above. This run's pre-revision draft went further: the
awareness reached an actual graded deliverable, correctly, before any consult ran.
`briefing.md`'s deliverables snapshot shows `script.R` using
`staggered::staggered()` with the code comment "The installed staggered-package
documentation specifies Inf (not 0) for never-treated g" and the line
`dat$g_staggered <- ifelse(dat$first.treat == 0, Inf, dat$first.treat)`. The same
snapshot reports a Roth-Sant'Anna ATT of −0.0471, in the correct range. Item B is
satisfied in a graded deliverable, before any consult ran.

The Sol consult's `advice.md` then raised a substantively reasonable point. It reads,
"Replace the Roth-Sant'Anna `staggered()` estimate with Sun-Abraham. `staggered()` is
designed for randomized staggered rollouts, whereas minimum-wage adoption is
observational. Treating it as an ordinary parallel-trends robustness estimator is the
submission's main methodological weakness." The model complied. The final `script.R`
has no `staggered` import and no `Inf` coding (confirmed by grep, zero hits for either
in the final file). The final `memo.md` never states that heterogeneity-robust packages
use different never-treated sentinel conventions, in any form (confirmed by grep for
`sentinel|staggered|convention` — the only "staggered" hits are the generic "staggered
adoption"/"staggered-TWFE" phrasing, never the package name). The rubric's escape clause
for skipping `staggered` (stating the cross-package awareness in the memo instead) is
not satisfied either. Item B is unmet in the graded product. The same non-compensatory
rule applies as above. B unmet means no band is reached, which is Fail.

This is a different lesson than "the consult didn't catch the trap." Here the consult
caught something real, acted on defensible grounds outside this specific rubric's scope,
and that action happened to cost the run the one piece of evidence this rubric was built
to require. A single-pass, read-only review has no mechanism to weigh a legitimate
methodological improvement against a specific evaluation criterion it was never shown —
that tension is a structural property of the review step, rather than a quality failure
of this particular consult.

## 2026-07-12/13 retro-scores (superseded by the 2026-07-17 rerun above)

All captured runs, scored on their brief's six items. The 46-orchestrate rows are the
2026-07-12 re-runs (headless `codex exec`, gpt-5.6-terra · medium); the superseded
2026-07-11 captures are in git history.

**2026-07-13 re-run (v2.17.0 recalibrated skills):** fable and opus were re-run; the fresh
scores and the fable t1/t3 band moves are documented in `RESULTS.md` ("2026-07-13 re-run"
section). opus reproduced all five prior bands; fable moved t1 Pass+ → Pass and t3 Pass →
Pass+ (the misses moved between draws — the non-compensatory bands held, only which item
was missed changed). The table below is the original-capture scoring, retained.

| Run | Items met | Points | Norm | Band |
|---|---|---|---|---|
| fable / t1 | design counts, attribute set, level counts, repeated task, honest flag | 5/6 | 0.83 | Pass+ |
| fable / t2 | crime headline, direction and order, clustered SEs, AMCE zeroing, estimand disclosed | 5/6 | 0.83 | Pass+ |
| fable / t3 | A, B, C, E | 4/6 | 0.67 | Pass |
| fable / high-ajr | all six | 6/6 | 1.00 | Distinction |
| fable / vhigh-lalonde | all six | 6/6 | 1.00 | Distinction |
| opus / t1 | all six | 6/6 | 1.00 | Distinction |
| opus / t2 | all six | 6/6 | 1.00 | Distinction |
| opus / t3 | A, B, C, E, D | 5/6 | 0.83 | Pass+ |
| opus / high-ajr | all six | 6/6 | 1.00 | Distinction |
| opus / vhigh-lalonde | all six | 6/6 | 1.00 | Distinction |
| advisor / t1-claude | all six | 6/6 | 1.00 | Distinction |
| advisor / t2-claude | crime headline, direction and order, clustered SEs, AMCE zeroing, estimand disclosed | 5/6 | 0.83 | Pass+ |
| advisor / t3-claude | A, B, C, E, D, F | 6/6 | 1.00 | Distinction |
| advisor / high-ajr-claude | all six | 6/6 | 1.00 | Distinction |
| advisor / vhigh-lalonde-claude | all six | 6/6 | 1.00 | Distinction |
| 46 / t1 | design counts, attribute set, level counts, repeated task | 4/6 | 0.67 | Pass |
| 46 / t2 | crime headline, direction and order, clustered SEs, AMCE zeroing, estimand disclosed | 5/6 | 0.83 | Pass+ |
| 46 / t3 | A, B, C, E | 4/6 | 0.67 | Pass |
| 46 / high-ajr | A, B, C, E, M | 5/6 | 0.83 | **Pass** (see note) |
| 46 / vhigh-lalonde | all six | 6/6 | 1.00 | Distinction |

Failed-item evidence, quoted from disk.

- fable / t1 max-deviation. The summary reports Driving Time at "spread 3.08 pp" (the
  min-max range) and never the 1.94 pp deviation from the 25% uniform target. opus reports
  "max absolute deviation = 0.0194."
- fable / t2 projoint defaults. The report gives "measurement-error-corrected ... projoint
  estimator" with SEs "clustered at the respondent level" but no tau, no x1.52, and no
  profile-level estimand. opus gives "tau = 0.17 ... scales them by roughly 1.52" and names
  the "profile-level estimand."
- fable / t3 tie caveat (D) and both magnitudes (F). The memo states "crime's MM spread
  (0.251) is the largest of any attribute, ahead of driving time (0.237)" with no
  within-noise flag, and "All estimates below are measurement-error-corrected" (corrected
  only).
- opus / t3 both magnitudes (F). The memo reports the corrected 25.1 pp and MM 0.63 vs 0.37
  only, never the uncorrected 16.5 pp.
- advisor / t1-claude max-deviation. Met. The revised summary carries a per-attribute "Max
  relative deviation" column (Driving Time 7.8%, the same 1.94 pp quantity expressed
  against the 25% uniform target), which is the exact-deviation precision the item asks
  for, not a min-max spread.
- advisor / t2-claude projoint defaults. The revised report gives the IRR mechanism in full
  ("estimated intra-respondent reliability 0.83; the correction scales uncorrected AMCEs by
  roughly 1.5") but never names the profile-level estimand, the same conjunct opus meets.
  The consult knew it (its no-change list says "profile-level corrected AMCEs ... exactly
  what the task asked for") but did not order it into the report.

## Notes

Bands are non-compensatory, so the dotted lines mark where the categorical bands sit for
runs that clear all four core items rather than acting as independent numeric cutoffs.
Every captured Claude-arm run clears core and meets items in band order, so each of those
fractions lands in the band its line predicts. The one exception in the matrix is
46 / high-ajr, which meets core plus completeness but misses the judgment item: its
fraction (5/6) sits at the Pass+ line while its band is Pass, exactly the case this
paragraph exists for. Figure conventions (Okabe-Ito palette, caption-not-title, 300+ dpi)
are a separate quality axis tracked in `RESULTS.md` and are not folded into these items.

Two results worth flagging. The T3 item scores reproduce the bands already recorded in
`RESULTS.md` (fable Pass, opus Pass+, advisor Distinction), the check that the item list is
faithful rather than reverse-fit. T1 and T2 were never banded before. Both fable and opus
are correct at both tiers, so the earlier matrix marked each "Facts correct." The item list
now separates them, because opus reports the exact max deviation and the full projoint
defaults where fable reports a looser spread and a bare "corrected" label. That gap is
completeness, not correctness, which is why fable lands at Pass+ and opus at Distinction
rather than either dropping to Pass.

Two scoring decisions on the newer runs, recorded for auditability. advisor / t1-claude's
completeness item is scored met on a per-attribute "max relative deviation" column
(Driving Time 7.8% against the 25% uniform target, the same 1.94 pp quantity in relative
form); the item's bar is exact-deviation precision rather than a min-max spread, and a
relative form of the exact deviation clears it. The vhigh rubric's extra "distinction
refinement" clauses were downgraded to non-band-blocking quality signals before any run
was scored, so Distinction means the same thing (all six items) on every brief.
