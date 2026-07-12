You are reviewing a completed analysis before it ships. The brief was:

# Task VHIGH — Adjudicate a methods dispute (very-high tier)

You are working in a project directory. Use R (`Rscript`); the `causaldata` package is installed.

**Data.** The LaLonde National Supported Work (NSW) experiment plus the CPS comparison sample:

```r
library(causaldata)
nsw <- causaldata::nsw_mixtape   # 445 obs = 185 treated + 260 control (experimental)
cps <- causaldata::cps_mixtape   # 15,992 CPS controls (observational comparison pool)
# columns (both): data_id treat age educ black hisp marr nodegree re74 re75 re78
```

**Situation.** The NSW experiment gives an unbiased estimate of the program's effect on 1978 earnings (`re78`): the treated−control difference in `nsw_mixtape` (about **+$1,794** — compute it, do not trust the figure). Dehejia and Wahba (1999, 2002) claim propensity-score methods **recover** this experimental benchmark when the experimental controls are discarded and replaced by CPS observational controls (`cps_mixtape`). Smith and Todd (2005) reply that the recovered estimate is **fragile** to the covariate set and the analysis sample. Your job is to run the specification curve and decide which claim the evidence supports.

**Task.**

1. Compute the **experimental benchmark** (treated − control difference in `re78`, within `nsw_mixtape`).
2. Construct the **observational composite** — NSW **treated** units plus CPS **controls** — and estimate the treatment effect on `re78` (a) **naively** (raw treated−control difference) and (b) by **propensity-score matching** under **at least four** specifications. Vary two axes: the **covariate set** (demographics only vs demographics **+ `re74`/`re75`** pre-treatment earnings) and an **estimator detail** (with/without trimming to common support; 1-NN matching vs simple score stratification).
3. Lay the estimates **against the benchmark** in a specification table.
4. **Adjudicate** in `memo.md` (~450 words): does matching recover the benchmark **robustly**, **only under favorable specifications**, or **not at all** — and what may a paper legitimately claim?

**Produce, in the current working directory:**

1. `script.R` — one self-contained script; conventions as in T1/T2 (Okabe-Ito palette and theme at the top; `set.seed()` before anything stochastic).
2. `figures/spec-curve.png` — exactly ONE figure: the estimates with 95% intervals across specifications, the experimental benchmark drawn as a horizontal reference line. 300+ dpi, no in-plot title.
3. `spec-table.md` — every specification's estimate laid against the benchmark (a gap column, or the benchmark side-by-side), plus the naive observational estimate.
4. `memo.md` — the ~450-word adjudication: concede what conditioning on the covariates is and is not doing, state whether recovery is robust / favorable-specification-only / absent, and say precisely what a paper may and may not claim.

**Method note.** `MatchIt` is installed; `Matching` is not. If you use `MatchIt`, target the ATT with replacement (`estimand = "ATT"`, `replace = TRUE`) so it matches the estimand here; if neither package were installed you would hand-roll it (a logit propensity model, 1-NN on the score, with replacement). Choose a **defensible standard error** for each estimator — note that the ordinary nonparametric bootstrap is **not** valid for nearest-neighbor matching variances (Abadie-Imbens 2008).

**Constraints.** At most one revision cycle. If your mode delegates, use at most 3 delegations. No web access. Do not install packages. The memo must not overclaim: if recovery is specification-dependent, say so plainly — neither "matching works" nor "matching fails" unqualified.

---

The produced memo.md:

# Memo: Does matching recover the LaLonde benchmark?

The experimental benchmark (NSW treated − control, `re78`) is **$1,794** (SE $671, 95% CI [$479, $3,109]). The naive observational comparison — NSW treated vs. raw CPS controls — gives **−$8,498**, off by over $10,000 and 17.6 SEs. CPS respondents are not a valid comparison group on their face: NSW enrolled people with a specific pattern of labor-market disadvantage, and unconditional CPS earnings reflect a far more typically-employed population.

Conditioning on demographics alone (age, education, race, marital status, no-degree) does not fix this. Across three estimator variants, demographics-only matching gives **−$2,798 to −$4,137** — still 5.1 to 5.6 SEs from the benchmark. Demographics describe *who* a person is, not the labor-market trajectory that predicted NSW enrollment. What that conditioning is doing is balancing static covariates; what it is *not* doing is capturing the pre-treatment earnings dip (the "Ashenfelter dip") that drove both selection into NSW and low 1978 earnings for CPS look-alikes regardless of treatment. Leave that channel unblocked and most of the naive bias survives.

Adding `re74`/`re75` changes the picture, but only for one of the two estimators tested at that covariate set. 1-NN matching with demographics + pre-treatment earnings gives **$1,712** (untrimmed) and **$1,759** (trimmed to common support) — gaps of −$82 and −$36, under a fifth of an SE. Trimming is a non-issue for 1-NN here: it discards thousands of extreme-propensity CPS units, but none were ever going to be selected as a nearest match, so the point estimate is unchanged to the dollar. But stratification with the *identical* covariate set gives **−$144** — a gap of −$1,938 (−1.1 SE), with a 95% CI ([−$3,505, $3,218]) wide enough to span zero. Holding the covariate set fixed at Dehejia-Wahba's favored choice, switching only the estimator detail moves the result from near-exact recovery to a statistically null, badly-off estimate.

**Verdict: recovery is real but favorable-specification-only, not robust.** It is not absent — the best specification lands almost exactly on the benchmark — and it is not universal — demographics-only and coarse stratification both miss badly, some by more SEs than the naive estimate misses by dollars. This is Smith and Todd's point: credibility hinges on including pre-treatment earnings as a confounder proxy *and* on a matching estimator flexible enough to exploit local overlap, and neither is guaranteed by "do propensity-score matching."

A paper may legitimately claim that a well-specified propensity model with pre-treatment earnings and 1-NN matching produced an estimate indistinguishable from the experimental benchmark here. It may not claim that matching robustly recovers experimental benchmarks in general, nor that matching is unable to — both overclaim relative to a curve that spans both outcomes under choices a researcher could defensibly make either way.

---

The full artifact set (script.R, spec-table.md, figures/, memo.md) is in the current directory. What would you change before this ships? Verify the numbers if you can.
