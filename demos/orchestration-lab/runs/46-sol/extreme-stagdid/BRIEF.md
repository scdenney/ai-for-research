# Task EXTREME — Reconcile modern staggered-adoption DiD estimators

You are working in a project directory. Use R (`Rscript`); the `did`, `fixest`, `staggered`, and `bacondecomp` packages are installed.

**Data.** The Callaway-Sant'Anna minimum-wage/teen-employment county panel, as shipped in the `did` package (their own worked example — 500 US counties, 2003–2007, employment and population in logs):

```r
library(did)
data(mpdta)
# columns: year countyreal lpop lemp first.treat treat
# first.treat: the year a county's state first raised its minimum wage above the
# federal floor (2004, 2006, or 2007); 0 = never treated in this window.
```

**Situation.** Two-way fixed-effects (TWFE) regression is the textbook difference-in-differences estimator, but under **staggered treatment timing with heterogeneous effects**, Goodman-Bacon (2021) shows TWFE implicitly averages many 2x2 comparisons — including ones where an **already-treated** unit serves as the "control" for a **later-treated** one. If effects change over time, those comparisons can carry **negative weight**, contaminating the pooled estimate. This is why Callaway & Sant'Anna (2021), Sun & Abraham (2021), and de Chaisemartin & D'Haultfœuille (2020) built heterogeneity-robust alternatives, and why "never use plain TWFE on staggered data" has become a reflexive rule of thumb in applied econometrics. Reflexive rules are not the same as checking whether the problem they guard against is actually present in a given dataset. Your job is to check, not recite.

**Task.**

1. **Estimate the ATT at least four ways**: (a) naive TWFE (a `post × ever-treated` dummy, county and year fixed effects, clustered by county), (b) Callaway-Sant'Anna (`did::att_gt` + `aggte(type="simple")`) under **both** `control_group = "notyettreated"` and `control_group = "nevertreated"`, and (c) **at least one** of Sun-Abraham (`fixest::sunab`) or the Roth-Sant'Anna estimator (`staggered::staggered`). Cluster or use the package's native county-level variance wherever an option exists.
2. **Quantify whether the negative-weighting critique actually bites here.** Run a Goodman-Bacon decomposition (`bacondecomp::bacon`) on the naive TWFE and report what share of its identifying weight sits on "later vs. earlier treated" comparisons (the type that can carry negative weight) versus clean treated-vs-never-treated comparisons.
3. **Check pre-trends.** Produce an event-study / dynamic-effects estimate (e.g. `aggte(type="dynamic")`) covering at least two pre-treatment periods and one post-treatment period, and state whether the parallel-trends assumption looks supported.
4. **Adjudicate in `memo.md`** (~350 words): given (1)-(3), does the classic "TWFE is biased under staggered adoption" critique change the substantive conclusion for *this* dataset, or not — and why? State the ATT you'd actually report and its ballpark magnitude.

**Produce, in the current working directory:**

1. `script.R` — one self-contained script; Okabe-Ito palette and theme declared at the top if it produces a plot; `set.seed()` before anything stochastic.
2. `estimates-table.md` — every estimator from step 1, its ATT, its standard error, and its control-group/comparison-group choice, in one table.
3. `figures/event-study.png` — the dynamic/event-study estimates from step 3 with 95% intervals, a vertical line or shading marking the treatment period. 300+ dpi, no in-plot title.
4. `memo.md` — the ~350-word adjudication from step 4.

**Method note.** The packages you'll use encode "never treated" differently: `did::att_gt`'s `gname` column uses **0** for never-treated (as `mpdta$first.treat` already does); `staggered::staggered`'s `g` column uses **`Inf`** for never-treated. Read each package's own documentation for its convention before reusing a column across packages — do not assume one sentinel value carries over.

**Constraints.** At most one revision cycle. If your mode delegates, use at most 3 delegations. No web access beyond what's needed to check a package's documentation/help pages already installed locally. Do not install packages (`did`, `fixest`, `staggered`, `bacondecomp` are already present). The memo must not overclaim: it is not "TWFE is always fine" or "always use the modern estimator" — the answer must be grounded in what steps 1–3 actually showed for *this* dataset.
