# Task H RUBRIC — what a correct AJR replication-and-stress answer must satisfy

*This is the grading key for Task H. The brief asks the model to replicate the
Acemoglu-Johnson-Robinson (2001) IV result on `ivdoctr::colonial` (64 countries),
stress it under four perturbations, and write a `robustness-table.md` plus a
~400-word `memo.md`. Instead of a model memo, this file specifies what any correct
submission must compute, report, and avoid claiming. Score against the checklist
below. **The whole game:** the headline survives observable controls but the
instrument weakens under sample restriction, so the honest verdict is a calibrated
ceiling, not "confirmed" and not "overturned."*

All reference numbers below were computed by `script.R` in this directory (R 4.5.1,
`AER::ivreg`, exact 2SLS SEs) and are deterministic — a correct run reproduces them
to the digit. Coefficients are on `avexpr` (the institutions measure); the
first-stage coefficient is on `logem4` (log settler mortality); first-stage F is the
homoskedastic Staiger-Stock number on the excluded instrument (threshold ≈ 10).

**Reference values (the answer key):**

| Spec | n | OLS | 2SLS | 1st-stage coef | F (hom.) | F (robust) | instrument |
|---|---:|---:|---:|---:|---:|---:|---|
| 1. Baseline (bivariate) | 64 | 0.522 | 0.944 | −0.607 | 22.95 | 16.32 | strong |
| 2. + Latitude | 64 | 0.468 | 0.996 | −0.510 | 13.09 | 9.52 | strong |
| 3. + Continent (africa, asia) | 64 | 0.434 | 0.839 | −0.533 | 11.01 | 9.27 | strong |
| 4. Drop neo-Europes (AUS/CAN/NZL/USA) | 60 | 0.487 | 1.281 | −0.391 | 8.65 | 6.85 | weak (F<10) |
| 5. Africa only | 27 | 0.302 | 2.400 (SE 3.99) | −0.108 | 0.30 | 0.31 | collapsed |

---

## A. Replication within tolerance  *(CORE — pass-blocking)*

- [ ] Baseline **2SLS ≈ 0.94** (accept [0.92, 0.97]) and **OLS ≈ 0.52** (accept
  [0.50, 0.55]), on the full 64-country sample.
- [ ] **First stage reported:** coefficient of `avexpr` on `logem4` ≈ **−0.61**
  (accept [−0.63, −0.58]).
- [ ] **First-stage F reported** for the baseline (≈ **23**; any value > 20 is fine).
- Note the *direction*: 2SLS (0.94) is ~80% **larger** than OLS (0.52). A run that
  reports the numbers but calls the OLS<2SLS gap an error or a puzzle has missed
  that this is the expected attenuation-correction AJR emphasize (flag F#7).

## B. At least four stress specifications, run correctly  *(CORE — pass-blocking)*

- [ ] All four perturbations implemented on the **correct samples**: +latitude
  (n=64), +continent (n=64), drop-neo-Europes (**n=60**), Africa-only (**n=27**).
- [ ] For the controlled specs, exogenous controls appear on **both sides** of the
  IV (they are their own instruments): `ivreg(logpgp95 ~ avexpr + lat_abst | logem4
  + lat_abst)`, not controls in the second stage only. 2SLS checkpoints: +latitude
  ≈ **1.00**, +continent ≈ **0.84**, drop-neo-Europes ≈ **1.28**, Africa-only ≈
  **2.40**. A run that puts controls only in the structural equation gets wrong
  2SLS numbers (flag F#1).
- [ ] OLS **and** 2SLS reported for each spec (not 2SLS alone).

## C. Weak-instrument flagging where the first stage drops  *(CORE — pass-blocking)*

- [ ] First-stage F reported for **every** spec, not just the baseline.
- [ ] **The decisive flag:** the Africa-only first stage has **collapsed** — F ≈
  **0.30** (coef −0.108, essentially zero). The submission must say the Africa-only
  2SLS is **not reliable / uninformative**, not report 2.40 as if it were a real
  estimate.
- [ ] Credit for also flagging **drop-neo-Europes** (F ≈ 8.65, **below the ~10 rule
  of thumb**) as weakly identified. (Homoskedastic F is primary; a run that reports
  robust F instead — 6.85 / 0.31 — reaches the same weak/collapsed verdict and is
  equally acceptable.)

## D. The judgment call: the claim ceiling  *(JUDGMENT — separates Pass from Pass+)*

- [ ] Recognizes the **asymmetry**: the headline **survives the controls** (2SLS
  stays in the 0.84-1.00 band, F stays > 10 when latitude or continent dummies are
  added) but the **instrument weakens under sample restriction** (F falls below 10
  when the neo-Europes are dropped, and collapses to 0.30 within Africa).
- [ ] States the ceiling as **"robust to controls, fragile to sample restriction"**
  (or equivalent) — explicitly **not** "confirmed/robust across the board" and
  **not** "overturned in restricted samples."
- [ ] Names *why* the restricted samples fail: the identifying settler-mortality
  variation is **cross-continental**; within one continent there is too little of it
  left, so 2SLS is **uninformative (a noise-dominated ratio), not a refutation.**

## E. No overclaim in either direction  *(CORE — pass-blocking)*

- [ ] Does **not** claim the result is fully confirmed / robust to everything
  (it fails to *identify* once the sample is restricted).
- [ ] Does **not** claim a restricted sample **overturns, shrinks, or enlarges** the
  effect. In particular, the Africa-only 2SLS of 2.40 must **not** be read as "the
  institutions effect is even larger in Africa," and the drop-neo-Europes 1.28 must
  **not** be read as a strengthening — both rest on weak/dead first stages.
- A memo that lands on *either* pole (uncritical confirmation, or "the result breaks
  down") fails on candor about what a weak instrument can and cannot show.

## M. Completeness: one unified table  *(COMPLETENESS — required for Distinction)*

- [ ] **A single table** reports, for all five specs, **both** point estimates (OLS
  and 2SLS) **and** the first-stage F — so every spec is comparable at a glance.
  Not two disconnected tables; not F omitted for some specs; not OLS dropped. The
  first-stage coefficient and n per spec should be present too.

---

## What a human still has to decide

The script and this key settle what is *computable*. They do not settle: (1) whether
the classical (homoskedastic) first-stage F or a robust / effective F is the number
of record — under robust SEs even the *controlled* specs sit right at the 10 threshold
(9.52, 9.27), which a cautious reader may treat as already borderline; (2) whether
"fragile to sample restriction" is a fatal problem or an honest scope condition (AJR's
identifying variation is genuinely cross-continental — that can be a feature, not a
bug); (3) whether the OLS-vs-2SLS gap is best read as measurement-error correction,
LATE-vs-ATE, or residual omitted-variable bias in the instrument. The numbers do not
adjudicate these; a methodologist does.

## Common overclaims / errors to FLAG (deduct)

1. **Controls in the second stage only** — `ivreg(y ~ x + z | w)` instead of
   `ivreg(y ~ x + z | w + z)`. Yields wrong 2SLS numbers for specs 2-3.
2. **Africa-as-finding** — treating the Africa-only 2SLS (2.40) as substantive
   evidence of a larger effect. It is a noise-dominated ratio (F = 0.30).
3. **Naive manual-2SLS SEs presented as correct** — a two-`lm` implementation gives
   the right point estimate but its second-stage OLS SEs are wrong; must be labeled
   approximate (the brief says so, and `AER::ivreg` is available here anyway).
4. **One-sided reporting** — OLS without 2SLS, or 2SLS without OLS, per spec.
5. **F only for the baseline** — not reporting first-stage strength for every spec,
   which is exactly where the story lives.
6. **"Overturned"** — reading the restricted-sample failures as refutations rather
   than as loss of identification.
7. **Attenuation confusion** — calling the OLS < 2SLS gap an anomaly instead of the
   expected direction (instrument corrects downward bias in OLS).
8. *(minor)* Collapsing "adding controls" and "restricting the sample" into one
   undifferentiated "robustness" verdict, losing the asymmetry that is the point.

## Scoring

- **Pass** = A + B + C + E all satisfied (correct replication, four correct stress
  specs, weak-instrument flagged, no overclaim), with no error from #1-#6.
- **Pass+** = Pass **and** D (states the calibrated "robust to controls, fragile to
  restriction" ceiling and explains the weak-IV-is-uninformative logic).
- **Distinction** = all items, i.e. Pass+ **and** M (the single unified table with
  both estimates and the first-stage F for every spec).
- **Fail** = misses the baseline replication (A), never flags the collapsed
  Africa-only instrument (C), or overclaims in either direction (E / F#2 / F#6).
