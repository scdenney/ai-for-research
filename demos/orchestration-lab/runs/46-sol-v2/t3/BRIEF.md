# Task T3 — Answer the reviewer (judgment tier)

You are working in a project directory. Use R (`Rscript`); the `projoint` package is installed.

**Data.** Same as T1/T2:

```r
library(projoint)
data(exampleData1)
out <- reshape_projoint(exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped"))
```

**Situation.** A manuscript using these data claims as its headline finding that the Violent Crime Rate attribute drives community choice. A reviewer writes:

> "The paper's headline claim rests on AMCEs, but AMCEs are defined relative to arbitrary reference categories. Under different baselines the estimated 'effect of crime' could look quite different, and the ordering of attribute importance could change. The claimed result may be an artifact of the authors' baseline choices."

**Task.** Assess whether the reviewer's claim survives contact with the data:

1. Re-estimate the AMCEs under alternative reference categories — for the Violent Crime Rate attribute where possible, and for at least one multi-level attribute (note that some attributes are binary, which itself matters for the answer).
2. Compute marginal means (MMs) for all levels — the baseline-invariant quantity — and compare what they say about the headline finding.
3. Decide what the paper is entitled to claim.

**Produce, in the current working directory:**

1. `script.R` — one self-contained script; conventions as in T1/T2.
2. `figures/sensitivity.png` — exactly ONE figure supporting the memo. 300+ dpi, no in-plot title.
3. `sensitivity-table.md` — the crime-attribute AMCEs under each baseline choice, side by side, plus the MMs.
4. `memo.md` — a reply to the reviewer of roughly 400 words: concede what is mechanically true about reference-category dependence, state what is substantively robust (with the MM evidence), and say precisely what the revised manuscript will claim.

**Constraints.** At most one revision cycle. If your mode delegates, use at most 3 delegations. No web access. Do not install packages. The memo must not overclaim: if the headline finding is baseline-sensitive, say so plainly.
