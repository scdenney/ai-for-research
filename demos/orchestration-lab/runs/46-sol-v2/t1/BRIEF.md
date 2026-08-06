# Task T1 — Describe the design (mechanical tier)

You are working in a project directory. Use R (`Rscript`) for all analysis; the `projoint` package is installed.

**Data.** The `projoint` R package's built-in `exampleData1`: a wide-format Qualtrics export from a community-choice conjoint — 400 respondents, 8 choice tasks, 2 profiles per task, 7 attributes, plus one repeated task for reliability checks. Load and reshape:

```r
library(projoint)
data(exampleData1)
out <- reshape_projoint(exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped"))
```

`out$data` is the analysis-ready long format; `out$labels` maps attribute ids (`att1`…`att7`) to their human-readable names and levels.

**Produce, in the current working directory:**

1. `script.R` — one self-contained script that does everything below. Declare the plotting theme and an Okabe-Ito palette at the top. `set.seed()` before anything stochastic.
2. `summary.md` — a tidy design summary: respondents, tasks per respondent, profiles per task, the seven attributes with their level counts (human-readable names from `out$labels`), and a randomization balance check (level frequencies within each attribute).
3. `figures/level-frequencies.png` — ONE descriptive figure of attribute-level frequencies, 300+ dpi. No in-plot title: the figure's one-sentence caption goes under the figure reference in `summary.md`.

**Constraints.** At most one revision cycle. If your mode delegates, use at most 3 delegations. Do not fetch anything from the web. Do not install packages.
