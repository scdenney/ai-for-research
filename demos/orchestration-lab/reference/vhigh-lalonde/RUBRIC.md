# VHIGH RUBRIC — what a correct methods-dispute adjudication must satisfy

*This is the grading key for VHIGH. The brief (`../../prompts/vhigh-lalonde.md`)
asks the model to compute the experimental benchmark, reconstruct the LaLonde
program effect from CPS observational controls under several propensity-score
specifications, and write a ~450-word `memo.md` adjudicating whether matching
recovers the benchmark. Instead of a model memo, this file specifies what any
correct answer must compute, conclude, and avoid. Score a submission against the
checklist below.*

*The reference solution is hand-rolled in base R + glm (`script.R`), for exact
reproducibility. **MatchIt is installed**, so a submission may use it instead —
its point estimates will differ from the reference in the pre-earnings cells
(different pscore terms, caliper, ratio). Grade the matching estimates on
**pattern and tolerance**, not dollar-equality; grade the two anchors exactly.*

## The dispute (restated)

The NSW experiment gives an unbiased program effect on 1978 earnings (`re78`).
Dehejia & Wahba (1999, 2002) claim propensity-score matching recovers that
benchmark after the experimental controls are replaced by CPS observational
controls. Smith & Todd (2005) show the recovered estimate is highly sensitive to
covariate set and analysis sample; Dehejia (2005) replies. The task is to run the
specification curve and decide which claim the evidence supports.

---

## The two anchors — computed, graded EXACTLY (±$5 for rounding)

These are plain group means, independent of any matching implementation. A
submission that misses either has a data-handling error, not a modeling choice.

| Quantity | Definition | Correct value |
|---|---|---:|
| **Experimental benchmark** | mean `re78`, NSW treated (185) − NSW control (260) | **+$1,794** ($1,794.34) |
| **Naive observational** | mean `re78`, NSW treated (185) − CPS controls (15,992) | **-$8,498** (−$8,497.52) |

The naive gap is **wrong in sign** and off by ~$10,292: CPS controls earn ~$14k
vs ~$2k pre-program. Recovering +$1,794 from a −$8,498 starting point is the
whole task.

---

## A. The two anchors on the correct composite  *(core — required to pass)*

One item, three checks — all plain group means on the right samples; missing any
is a data-handling error, not a modeling choice:

- [ ] The memo/table reports the experimental benchmark as the **NSW
  treated − NSW control** difference in `re78`, **= +$1,794** (accept
  $1,790–$1,800). Using the *original* LaLonde 722-obs sample (benchmark ≈
  +$886) instead of the `nsw_mixtape` 445-obs DW sample is **wrong** for these
  data — flag it.
- [ ] The observational sample is **NSW treated (185) + CPS controls (15,992) =
  16,177 obs**. Treated come from `nsw_mixtape`; controls come from
  `cps_mixtape`. The **260 NSW experimental controls are NOT in** the
  observational estimates (they define the benchmark only).
- [ ] The **naive** observational estimate (raw treated−control difference on the
  composite) is reported = **−$8,498** (accept −$8,450 to −$8,550). A submission
  that never shows the naive gap has skipped the baseline the whole exercise
  improves on.

## C. At least four matching specifications, including the pre-earnings one  *(core — required to pass)*

- [ ] **≥ 4** propensity-score specifications are estimated, varying **both**
  axes the brief names: the **covariate set** (demographics-only vs
  demographics + `re74`/`re75`) **and** an estimator/support detail (common-support
  trimming on/off, and/or 1-NN vs stratification).
- [ ] **At least one specification conditions on pre-treatment earnings
  (`re74`, `re75`).** This is the decisive covariate; a curve that never adds it
  cannot address the dispute.
- Reference specimens (hand-rolled; pattern-graded, see tolerances at the bottom):

  | # | Covariates | Estimator | Support | ATT | 95% CI | Gap | Max\|SMD\| |
  |---|---|---|---|---:|---:|---:|---:|
  | 1 | Demographics | 1-NN | Full | **−$3,601** | [−$5,704, −$1,497] | −$5,395 | 2.26 |
  | 2 | Demographics | Stratification\* | Full | **−$4,162** | [−$5,491, −$2,833] | −$5,956 | 2.14 |
  | 3 | Demographics | 1-NN | Trimmed | **−$3,601** | [−$5,704, −$1,497] | −$5,395 | 2.26 |
  | 4 | Demographics | Stratification | Trimmed | **−$4,028** | [−$5,364, −$2,693] | −$5,823 | 2.08 |
  | 5 | + Pre-earnings | 1-NN | Full | **+$1,443** | [−$125, +$3,010] | −$352 | 0.40 |
  | 6 | + Pre-earnings | Stratification\* | Full | **−$144** | [−$1,406, +$1,119] | −$1,938 | 0.61 |
  | 7 | + Pre-earnings | 1-NN | Trimmed | **+$1,566** | [−$1, +$3,134] | −$228 | 0.40 |
  | 8 | + Pre-earnings | Stratification | Trimmed | **+$1,290** | [+$25, +$2,555] | −$505 | 0.24 |

  \* *Unrestricted stratification*: outer strata absorb CPS controls below the
  treated pscore range, so −$144 is partly a mechanical artifact of ignoring
  overlap, not an equally defensible estimator.

## D. Spec table complete, with the benchmark comparison  *(core — required to pass)*

- [ ] A table lays every specification's estimate **against the +$1,794
  benchmark** (a gap column, or the benchmark shown side-by-side). The naive
  −$8,498 gap and the per-spec estimates are both present.

## E. THE JUDGMENT: "helps but does not settle"  *(judgment — required for Pass+)*

The adjudication must land in the calibrated middle, backed by the numbers:

- [ ] **Pre-treatment earnings are necessary.** Every demographics-only
  specification fails — it stays negative, ~$5,400–$6,000 short of the benchmark,
  no better in sign than the naive gap — because it leaves the earnings
  covariates badly imbalanced (post-match max\|SMD\| ≈ 2.1–2.3). Only after adding
  `re74`/`re75` does any estimate approach +$1,794.
- [ ] **Recovery is specification-dependent, so it is not robust.** With
  pre-earnings, the well-implemented specifications cluster at **+$1,290 to
  +$1,566** (each ~$228–$505 *below* the benchmark, CIs covering it), but the
  point estimate still moves with estimator and support — and an unrestricted
  stratification of the *same* score collapses to **−$144**.
- [ ] **Therefore neither slogan holds.** The memo asserts **matching helps but
  does not settle** LaLonde's critique: *not* an unqualified "matching works"
  (Dehejia-Wahba) — the win needs the right conditioning set and a favorable
  estimator/support; *and not* an unqualified "matching fails" (Smith-Todd) — the
  pre-earnings 1-NN estimates land near the benchmark and remove most of the
  −$8,498 bias.
- **(Distinction refinements — see M):** frames the pre-earnings result as
  *closer to* the benchmark, **not** as "recovering the true effect" or "removing
  bias" (proximity in one realized sample is not proof of ignorability); flags the
  −$144 cell as an overlap-handling artifact rather than evidence that
  stratification fails; and notes this is a **single CPS-based reconstruction**, a
  sensitivity demonstration, not a complete historical adjudication of the DW/ST
  dispute.

## F. No overclaim  *(core — required to pass)*

The memo must commit **none** of these:

1. **DW triumphalism** — "matching recovers the experimental benchmark" /
   "vindicates observational methods" stated without the pre-earnings-and-support
   qualification. The −$144 and the demographics-only −$4k cells forbid it.
2. **ST nihilism** — "matching fails" / "observational methods are useless." The
   pre-earnings 1-NN estimates (+$1,443/+$1,566, CIs covering +$1,794) forbid it.
3. **Cherry-picking a single number** as "the" answer — reporting only the
   favorable +$1,566, or only the −$144, without the spread.
4. **"Removes bias" / "recovers the true effect"** language that treats
   one-sample proximity as established ignorability (see E distinction).
5. **Ignoring that demographics-only fails** — presenting matching as generally
   working without noting pre-earnings is load-bearing.
6. **Reporting an ordinary bootstrap CI on the nearest-neighbor estimates** as
   valid (Abadie-Imbens 2008: the nonparametric bootstrap is inconsistent for
   NN-matching variance). A defensible SE (cluster-robust / matching-specific /
   analytic-stratum) or an explicit no-CI choice is correct; a naive matching
   bootstrap presented without caveat is an error.

## M. Completeness: the figure shows all specs against the benchmark  *(completeness — required for Distinction)*

- [ ] `figures/spec-curve.png` plots **every** specification's estimate (≥ 4)
  with its interval, and draws the **+$1,794 benchmark as a reference line**, so
  the demographics-vs-pre-earnings contrast and the residual gap are both visible.
- [ ] House conventions: Okabe-Ito palette, **no in-plot title**, ≥ 300 dpi,
  exactly one figure.

---

## Scoring (band mapping)

Four core items, one judgment item, one completeness item — the same 4/1/1
composition as every other brief in this demo, so all briefs share one
normalized axis (`SCORING.md`).

- **Core** = A, C, D, F. **Judgment** = E. **Completeness** = M.
- **Pass** = all **core** satisfied (A, C, D, F), no overclaim from F.
- **Pass+** = core **+ judgment** (**E**): reaches "helps but does not
  settle," backed by the pre-earnings-necessity and specification-dependence
  numbers.
- **Distinction** = **all** (core + judgment + **M**), plus the E distinction
  refinements: "closer-to" not "recovers" language, the −$144 overclaim flagged
  as an overlap artifact, the single-sample-demonstration caveat, and a complete
  benchmark-referenced figure.
- **Fail** = misses an anchor (A), never conditions on pre-earnings (C), or
  commits an F overclaim (collapses to "matching works" or "matching fails"
  unqualified).

## What a human still has to decide

The script and this key settle what is *computable*. They do not settle:

1. **Which covariate specification is "right."** DW's published models add
   higher-order and interaction terms (age², `re74`², `u74`/`u75` unemployment
   dummies) beyond the linear `re74`/`re75` used here; that choice moves the
   estimate and is a modeling stance, not a default.
2. **Whether the CIA is credible at all.** Matching assumes selection on
   observables. Getting close to the benchmark in *this* sample does not prove it;
   Smith-Todd's fragility is partly a claim about unobservables no estimator
   settles.
3. **Whether one comparison sample can adjudicate the dispute.** ST use PSID as
   well as CPS; a CPS-only curve is a demonstration, not the last word.
4. **What "the program works" means for policy** — external validity of a
   1970s training program recovered through a reweighting of a national survey is
   a claim no matching estimator adjudicates.

---

### Grading tolerances for the matching estimates (implementation-dependent)

Hand-rolled vs MatchIt vs different pscore terms will move the pre-earnings cells.
Grade the **pattern**, not the dollar:

- **Demographics-only must NOT recover:** estimate stays far below the benchmark
  (reference −$3,600 to −$4,200; accept anything ≳ $1,500 short of +$1,794, i.e.
  ≲ +$300, and typically negative). A demographics-only spec that lands *on* the
  benchmark is a red flag for an error.
- **Pre-earnings 1-NN must land near the benchmark:** reference +$1,443/+$1,566;
  accept roughly **+$800 to +$2,600** (DW's published matched estimate ≈ +$1,672).
  It must be **decisively closer** than the same submission's demographics-only
  spec — that gap-closing *is* the recoverable finding.
- **The non-negotiables:** the sign flip from naive (−$8,498) to a positive,
  benchmark-neighborhood estimate once pre-earnings enter; and the demonstrated
  sensitivity across specifications. A submission may reach the right judgment
  with 4 specs and different point values, so long as the pattern holds.
