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
