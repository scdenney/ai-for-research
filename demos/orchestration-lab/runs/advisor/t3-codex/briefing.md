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
# Response to reviewer

Thank you for identifying an important distinction between a contrast’s parameterization and the evidence in the conjoint data. The reviewer is mechanically correct: an AMCE is a difference from a selected reference level. For a multi-level attribute, changing that level changes which coefficients are displayed and can change their signs and apparent magnitudes. Our re-estimation makes this visible. For racial composition, for example, setting the 75% White/25% Nonwhite level rather than the 50% White/50% Nonwhite level as the reference yields estimated contrasts of -0.037, -0.059, and -0.049 for the other three levels (all confidence intervals include zero). These are different parameterizations of the same underlying set of level means, not different experimental results.

The violent-crime attribute is importantly different. It has only two levels: 20% less and 20% more crime than the national average. Thus it has no alternative third reference category. With lower crime as the reference, the AMCE for higher crime is -0.251 (95% CI [-0.334, -0.168]); with higher crime as the reference, the AMCE for lower crime is +0.251 [0.168, 0.334]. Re-referencing reverses the direction used to state the identical pairwise contrast; it cannot change its absolute size or the ordering of these two levels. The side-by-side results are reported in `sensitivity-table.md`.

We agree that marginal means are the clearer primary presentation for this purpose because they are reference-invariant. The corrected marginal mean of choosing a profile with 20% less crime is 0.626 [0.584, 0.667], compared with 0.374 [0.333, 0.416] for a profile with 20% more crime. Figure `figures/sensitivity.png` shows these estimates alongside every other attribute level. The resulting 0.251 marginal-mean span is the largest observed span in this design, although it is close to the span for total daily driving time (0.237). It therefore supports a substantively large preference for lower-crime communities; it does not support treating an arbitrary AMCE coefficient as a reference-free measure of importance, nor does it establish a precisely ranked dominance over every other attribute.

We will revise the manuscript accordingly. The headline claim will be: *Within the levels randomized in this conjoint, respondents strongly preferred communities with crime rates 20% below rather than 20% above the national average; this was the largest observed marginal-mean contrast, albeit close to the contrast for commuting time.* We will present marginal means as the principal evidence, report the two coding-equivalent AMCEs in a sensitivity table, and describe AMCEs as reference-dependent contrasts rather than as a standalone ranking of attribute importance.

## Question
You are the second reviewer. What is wrong or missing in this memo, and what exactly would you change before it goes to the journal? Be specific and decisive.
