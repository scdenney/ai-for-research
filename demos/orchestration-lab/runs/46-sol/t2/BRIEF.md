# Task T2 — Estimate and report (standard tier)

You are working in a project directory. Use R (`Rscript`); the `projoint` package is installed.

**Data.** Same as T1:

```r
library(projoint)
data(exampleData1)
out <- reshape_projoint(exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped"))
```

**Task.** Estimate Average Marginal Component Effects (AMCEs) for all seven attributes on profile choice, with uncertainty clustered at the respondent level. Use projoint's estimator, or an explicit alternative with a one-line justification if you deviate.

**Produce, in the current working directory:**

1. `script.R` — one self-contained script; Okabe-Ito palette and theme declared at the top; `set.seed()` before anything stochastic.
2. `figures/amce-dotwhisker.png` — a dot-and-whisker plot of the AMCE estimates with 95% intervals, grouped by attribute, levels ordered within attribute, reference levels shown at zero. 300+ dpi. No in-plot title.
3. `report.md` — a results paragraph of roughly 200 words that a paper could use: the largest effects, their direction and magnitude in percentage points, and one sentence on uncertainty. Place the figure's caption under the figure reference.

**Constraints.** At most one revision cycle. If your mode delegates, use at most 3 delegations. No web access. Do not install packages.
