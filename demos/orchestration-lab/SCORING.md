# Scoring the runs

This file defines the three bands (Pass, Pass+, Distinction) and puts them on a shared
numeric axis so a chart can draw dotted threshold lines. Grading is by binary items
derived from `reference/ANSWER-KEY.md` (T1 Describe, T2 Estimate) and
`reference/t3/RUBRIC.md` (T3 Reviewer-reply). Each item is classed core, judgment, or
completeness.

Core items are pass-blocking facts a competent run must get right. The judgment item is
the discretionary call the answer key hands to the analyst. The completeness item rewards
thoroughness past a correct answer. Every brief carries four core items, one judgment
item, and one completeness item, six in all, so the three briefs share one axis and the
same threshold lines.

## Bands

| Band | Rule (categorical, primary) | Normalized score |
|---|---|---|
| Pass | every core item met | 4/6 = 0.67 |
| Pass+ | every core item met, plus the judgment item | 5/6 = 0.83 |
| Distinction | every item met, core and judgment and completeness | 6/6 = 1.00 |

A run that misses any core item is a Fail whatever its fraction. No number of judgment or
completeness items redeems a missed core item.

The categorical rule is primary. The normalized score is its chart representation, items
met divided by six, on a 0-to-1 axis shared by all three briefs. Dotted lines fall at 0.67
(Pass), 0.83 (Pass+), and 1.00 (Distinction). Because every brief is built four core, one
judgment, one completeness, the same three lines serve all of them.

## T1 (Describe the design)

| Item | Class | Met when |
|---|---|---|
| Design counts | core | states 400 respondents, 8 tasks each, 2 profiles per task, 6,400 profile rows |
| Attribute set | core | names all 7 attributes in human-readable form, not att1..att7 |
| Level counts | core | per-attribute level counts read 3, 3, 4, 2, 4, 6, 2 |
| Repeated task | core | identifies the repeated flipped task 1 and does not miscount it as a 9th task |
| Honest balance flag | judgment | names Total Daily Driving Time as the lone imbalance and makes no "perfect balance" claim |
| Max-deviation precision | completeness | reports the exact max deviation from uniform (~1.94 pp), not only a min-max spread |

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

## Retro-scores

| Run | Items met | Points | Norm | Band |
|---|---|---|---|---|
| fable / t1 | design counts, attribute set, level counts, repeated task, honest flag | 5/6 | 0.83 | Pass+ |
| fable / t2 | crime headline, direction and order, clustered SEs, AMCE zeroing, estimand disclosed | 5/6 | 0.83 | Pass+ |
| fable / t3 | A, B, C, E | 4/6 | 0.67 | Pass |
| opus / t1 | all six | 6/6 | 1.00 | Distinction |
| opus / t2 | all six | 6/6 | 1.00 | Distinction |
| opus / t3 | A, B, C, E, D | 5/6 | 0.83 | Pass+ |
| advisor / t1-claude | all six | 6/6 | 1.00 | Distinction |
| advisor / t2-claude | crime headline, direction and order, clustered SEs, AMCE zeroing, estimand disclosed | 5/6 | 0.83 | Pass+ |
| advisor / t3-claude | A, B, C, E, D, F | 6/6 | 1.00 | Distinction |

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
Every captured run clears core, so on this chart each run's fraction lands in the band its
line predicts. Figure conventions (Okabe-Ito palette, caption-not-title, 300+ dpi) are a
separate quality axis tracked in `RESULTS.md` and are not folded into these items.

Two results worth flagging. The T3 item scores reproduce the bands already recorded in
`RESULTS.md` (fable Pass, opus Pass+, advisor Distinction), the check that the item list is
faithful rather than reverse-fit. T1 and T2 were never banded before. Both fable and opus
are correct at both tiers, so the earlier matrix marked each "Facts correct." The item list
now separates them, because opus reports the exact max deviation and the full projoint
defaults where fable reports a looser spread and a bare "corrected" label. That gap is
completeness, not correctness, which is why fable lands at Pass+ and opus at Distinction
rather than either dropping to Pass.
