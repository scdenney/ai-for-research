# Briefing for an independent second reviewer

## The task we answered
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

## The memo we produced
# Reply to Reviewer: baseline dependence of the crime finding

We thank the reviewer for pressing on the reference-category issue. We re-estimated everything under alternative baselines and added baseline-invariant quantities. The short answer: the concern is mechanically correct for multi-level attributes, but it cannot produce the headline estimate, and the baseline-free evidence supports a more careful version of our claim, which we now adopt.

**What we concede.** AMCEs are contrasts against a reference level, and for multi-level attributes the displayed coefficients change with that choice. Re-estimating Driving Time against a 45-minute baseline instead of 10 minutes shrinks its largest displayed AMCE from 23.7 to 14.1 percentage points (Table, panel 2). Any heuristic that ranks attributes by their largest displayed AMCE is therefore baseline-dependent. We note, though, that changing the baseline is a reparameterization: the full set of pairwise contrasts is unchanged; what changes is which contrasts appear in the table.

**What is robust.** The Violent Crime Rate attribute is binary (20% less vs. 20% more crime than the national average), so only two baselines exist, and swapping them flips the sign while leaving magnitude, standard error, and interval width identical: ±25.1 pp (95% CI 16.8–33.4, measurement-error corrected). The headline estimate cannot be an artifact of baseline choice. Marginal means, which involve no reference category, tell the same story (Figure, panel B): 0.626 for low-crime profiles vs. 0.374 for high-crime ones, the largest range of any attribute (25.1 pp).

**What we can no longer claim.** Crime's range does not stand alone. Driving Time's marginal-means range is 23.7 pp and Housing Cost's is 19.8 pp. Respondent-cluster bootstrap tests of the range differences (fixed contrasts, two unadjusted pairwise tests) give crime minus driving time = 1.4 pp (SE 5.6, p = 0.80) and crime minus housing cost = 5.3 pp (SE 5.5, p = 0.33). The data do not place crime strictly at the top of the importance ordering.

**Revised claim.** The manuscript will state: violent crime rate has the largest estimated baseline-invariant marginal-means range (25 pp between its two levels) and is among the most influential attributes, but its range is statistically indistinguishable from daily driving time (24 pp) and housing cost (20 pp), so the data cannot rank it strictly first; and these ranges are relative to the level spans this design used (±20% crime, 10–75 minutes of driving, 15–40% of income), not design-free quantities. We will report marginal means alongside AMCEs, flag the binary structure of the crime attribute, and drop the phrase "drives community choice."

![Sensitivity of the crime finding to baseline choice](figures/sensitivity.png)

*Panel A: AMCEs for the crime and driving-time attributes under alternative reference categories (color); the binary crime AMCE only changes sign, while multi-level driving-time AMCEs genuinely change. Panel B: baseline-invariant marginal means for all 24 levels, attributes ordered by range; corrected estimates, 95% CIs, respondent-clustered.*

## Question
You are the second reviewer. What is wrong or missing in this memo, and what exactly would you change before it goes to the journal? Be specific and decisive.
