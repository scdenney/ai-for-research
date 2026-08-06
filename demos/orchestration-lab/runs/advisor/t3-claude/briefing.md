=== ORIGINAL BRIEF ===
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

=== PRODUCED: script.R ===
#!/usr/bin/env Rscript
# T3 — Is the "Violent Crime Rate drives community choice" headline an
# artifact of AMCE reference-category choice? Re-estimate crime AMCEs under
# every available baseline, do the same for one multi-level attribute, and
# compute marginal means (MMs), which have no reference category at all.
# Produces: sensitivity-table.md, figures/sensitivity.png, memo.md.

set.seed(20260717)

suppressPackageStartupMessages({
  library(projoint)
  library(ggplot2)
})

dir.create("figures", showWarnings = FALSE, recursive = TRUE)

## Okabe-Ito palette + shared theme -------------------------------------
okabe_ito <- c(
  black = "#000000", orange = "#E69F00", sky = "#56B4E9", green = "#009E73",
  yellow = "#F0E442", blue = "#0072B2", vermillion = "#D55E00", purple = "#CC79A7"
)
theme_t3 <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold"),
    axis.title = element_text(size = 10)
  )

## Data -------------------------------------------------------------------
data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

## Marginal means: the baseline-invariant quantity -------------------------
mm_fit <- projoint(out, .structure = "profile_level", .estimand = "mm")
invisible(capture.output(mm <- as.data.frame(summary(mm_fit))))
mm <- mm[mm$estimand == "mm_corrected", ]
names(mm)[names(mm) == "att_level_choose"] <- "level_id"
mm <- merge(out$labels, mm, by = "level_id", sort = FALSE)
mm <- mm[order(mm$attribute_id, mm$level_id), ]

## AMCEs under every available reference for a given attribute -------------
fit_amce <- function(attribute_id, focal_level, reference_level) {
  qoi <- set_qoi(
    .structure = "profile_level", .estimand = "amce",
    .att_choose = attribute_id, .lev_choose = focal_level,
    .att_choose_b = attribute_id, .lev_choose_b = reference_level
  )
  fit <- suppressWarnings(projoint(out, .qoi = qoi))
  invisible(capture.output(s <- as.data.frame(summary(fit))))
  s[s$estimand == "amce_corrected", c("estimate", "conf.low", "conf.high")]
}

baseline_grid <- function(attribute_id) {
  levs <- out$labels[out$labels$attribute_id == attribute_id, ]
  short <- sub(".*:", "", levs$level_id)
  n <- nrow(levs)
  est <- lo <- hi <- matrix(NA_real_, n, n, dimnames = list(levs$level_id, levs$level_id))
  for (ref in seq_len(n)) {
    for (foc in seq_len(n)) {
      if (foc == ref) { est[foc, ref] <- 0; next }
      s <- fit_amce(attribute_id, short[foc], short[ref])
      est[foc, ref] <- s$estimate; lo[foc, ref] <- s$conf.low; hi[foc, ref] <- s$conf.high
    }
  }
  list(levels = levs, estimate = est, low = lo, high = hi)
}

crime <- baseline_grid("att7")     # binary: only a sign reversal is possible
housing <- baseline_grid("att1")   # multi-level check: 3 levels, 3 possible baselines

## sensitivity-table.md -----------------------------------------------------
fmt_cell <- function(est, lo, hi) {
  if (is.na(lo)) "0.000 (ref.)" else sprintf("%.3f [%.3f, %.3f]", est, lo, hi)
}
grid_table <- function(grid, heading, note) {
  lab <- grid$levels$level
  header <- paste(c("Focal level", paste0("Reference: ", lab)), collapse = " | ")
  divider <- paste(rep("---", length(lab) + 1), collapse = " | ")
  rows <- vapply(seq_along(lab), function(i) {
    cells <- vapply(seq_along(lab), function(j) {
      fmt_cell(grid$estimate[i, j], grid$low[i, j], grid$high[i, j])
    }, character(1))
    paste(c(lab[i], cells), collapse = " | ")
  }, character(1))
  c(paste0("## ", heading), "", header, divider, rows, "", note, "")
}

mm_rows <- vapply(seq_len(nrow(mm)), function(i) {
  sprintf("| %s | %s | %.3f [%.3f, %.3f] |",
          mm$attribute[i], mm$level[i], mm$estimate[i], mm$conf.low[i], mm$conf.high[i])
}, character(1))

mm_range <- aggregate(estimate ~ attribute, data = mm, FUN = function(x) diff(range(x)))
mm_range <- mm_range[order(-mm_range$estimate), ]
range_text <- paste(sprintf("%s: %.3f", mm_range$attribute, mm_range$estimate), collapse = "; ")

lines <- c(
  "# Reference-category sensitivity: AMCEs vs. marginal means",
  "",
  sprintf("All figures are profile-level, IRR-corrected `projoint` estimates with respondent-clustered analytical 95%% CIs (estimated tau = %.3f). A `0.000 (ref.)` cell is the fitted reference level, not a null result.", mm_fit$tau),
  "",
  grid_table(crime, "Violent Crime Rate (att7, binary) — AMCE under each reference",
             "Crime has only two levels, so re-baselining can only flip the sign of the same contrast; no third comparison exists to reveal."),
  grid_table(housing, "Housing Cost (att1, 3 levels) — AMCE under each reference",
             "With three levels, the single AMCE reported depends on which level is fixed as zero, even though every directed pairwise contrast is identical across the two triangles (just relabeled)."),
  "## Marginal means — every experimental level (baseline-invariant)",
  "",
  "| Attribute | Level | Marginal mean [95% CI] |",
  "| --- | --- | --- |",
  mm_rows,
  "",
  sprintf("Within-attribute MM range (descriptive only, not a formal importance test): %s.", range_text)
)
writeLines(lines, "sensitivity-table.md")

## figures/sensitivity.png ---------------------------------------------------
crime_mm <- mm[mm$attribute_id == "att7", ]
housing_mm <- mm[mm$attribute_id == "att1", ]
crime_mm$short <- c("20% less\ncrime", "20% more\ncrime")
housing_mm$short <- c("15%", "30%", "40%")
crime_mm$short <- factor(crime_mm$short, levels = crime_mm$short)
housing_mm$short <- factor(housing_mm$short, levels = housing_mm$short)

plot_dat <- rbind(
  transform(crime_mm, panel = "Violent crime rate (vs. national average)"),
  transform(housing_mm, panel = "Housing cost (share of pre-tax income)")
)
plot_dat$panel <- factor(plot_dat$panel, levels = unique(plot_dat$panel))

fig <- ggplot(plot_dat, aes(x = short, y = estimate, color = panel)) +
  geom_hline(yintercept = 0.5, linetype = 2, color = "grey55") +
  geom_pointrange(aes(ymin = conf.low, ymax = conf.high), size = 0.6, linewidth = 0.8) +
  facet_wrap(~panel, scales = "free_x") +
  scale_color_manual(values = unname(okabe_ito[c("blue", "vermillion")]), guide = "none") +
  coord_cartesian(ylim = c(0.25, 0.72)) +
  labs(x = NULL, y = "Marginal mean (probability a profile is chosen)") +
  theme_t3 +
  theme(axis.text.x = element_text(size = 9))

ggsave("figures/sensitivity.png", fig, width = 7.2, height = 4.2, dpi = 320)

## memo.md --------------------------------------------------------------------
more_vs_less <- fit_amce("att7", "level2", "level1")
less_vs_more <- fit_amce("att7", "level1", "level2")
crime_less_mm <- crime_mm[crime_mm$level_id == "att7:level1", ]
crime_more_mm <- crime_mm[crime_mm$level_id == "att7:level2", ]

short_name <- c(att1 = "housing cost", att2 = "presidential vote", att3 = "racial composition",
                 att4 = "school quality", att5 = "commuting time", att6 = "type of place",
                 att7 = "violent crime rate")
attribute_of <- setNames(out$labels$attribute_id, out$labels$attribute)[mm_range$attribute]
crime_range <- mm_range$estimate[mm_range$attribute == "Violent Crime Rate (Vs National Rate)"]
next_range <- mm_range[mm_range$attribute != "Violent Crime Rate (Vs National Rate)", ][1, ]
next_range$short_name <- short_name[[attribute_of[[next_range$attribute]]]]

memo <- c(
"# Reply to Reviewer",
"",
sprintf("The reviewer is right on the mechanics. An AMCE is a contrast against a named reference level, so re-baselining relabels which comparison earns a sign and a number. We reran the crime AMCE at both available references (`sensitivity-table.md`): 20%% more crime vs. 20%% less crime is %.3f (95%% CI [%.3f, %.3f]), and the reverse contrast is %.3f (95%% CI [%.3f, %.3f]). Because crime is binary in this design, only a sign flip is possible; there is no third reference that could tell a different story. For a genuinely multi-level attribute (housing cost, 3 levels) the reviewer's concern has more bite: whichever level is fixed at zero changes which single AMCE gets reported, even though the three directed pairwise contrasts are unchanged in substance.", more_vs_less$estimate, more_vs_less$conf.low, more_vs_less$conf.high, less_vs_more$estimate, less_vs_more$conf.low, less_vs_more$conf.high),
"",
sprintf("That is a real constraint on how AMCEs should be read, but it does not make the headline finding an artifact. Marginal means carry no reference category at all — each is the modeled probability that a profile with a given level is chosen, averaged over the randomized distribution of every other attribute. The IRR-corrected MM for a community with 20%% less crime than the national average is %.3f (95%% CI [%.3f, %.3f]); for 20%% more crime it is %.3f (95%% CI [%.3f, %.3f]). That roughly %.0f-point separation is visible with no baseline to choose, and it is the largest within-attribute MM spread of the seven attributes in the design (%.3f, versus %.3f for the next-largest, %s). The AMCE and the MM evidence point the same direction for the same reason: respondents strongly prefer lower crime, and that preference does not depend on which level a model happens to treat as zero.", crime_less_mm$estimate, crime_less_mm$conf.low, crime_less_mm$conf.high, crime_more_mm$estimate, crime_more_mm$conf.low, crime_more_mm$conf.high, 100 * (crime_less_mm$estimate - crime_more_mm$estimate), crime_range, next_range$estimate, next_range$short_name),
"",
"What the paper is not entitled to claim is a general cross-attribute importance ranking read off AMCE magnitudes, since attributes here differ in level count and spacing and a coefficient's size partly reflects reference choice rather than only the strength of preference. The revised manuscript will state the headline as: among the experimentally varied levels, respondents strongly and robustly prefer communities with lower violent crime, a conclusion supported by the MMs and unaffected by reference recoding; it will report AMCEs only alongside their named reference, and it will drop any language implying crime is definitively the largest or most important attribute in an absolute, baseline-free sense. The MM table and figure become the primary exhibit for the headline claim; the AMCE table is retained as a secondary, explicitly-labeled robustness check."
)
writeLines(memo, "memo.md")

message("Wrote sensitivity-table.md, figures/sensitivity.png, memo.md")

=== PRODUCED: sensitivity-table.md ===
# Reference-category sensitivity: AMCEs vs. marginal means

All figures are profile-level, IRR-corrected `projoint` estimates with respondent-clustered analytical 95% CIs (estimated tau = 0.172). A `0.000 (ref.)` cell is the fitted reference level, not a null result.

## Violent Crime Rate (att7, binary) — AMCE under each reference

Focal level | Reference: 20% Less Crime Than National Average | Reference: 20% More Crime Than National Average
--- | --- | ---
20% Less Crime Than National Average | 0.000 (ref.) | 0.251 [0.168, 0.334]
20% More Crime Than National Average | -0.251 [-0.334, -0.168] | 0.000 (ref.)

Crime has only two levels, so re-baselining can only flip the sign of the same contrast; no third comparison exists to reveal.

## Housing Cost (att1, 3 levels) — AMCE under each reference

Focal level | Reference: 15% of pre-tax income | Reference: 30% of pre-tax income | Reference: 40% of pre-tax income
--- | --- | --- | ---
15% of pre-tax income | 0.000 (ref.) | 0.137 [0.066, 0.208] | 0.198 [0.122, 0.274]
30% of pre-tax income | -0.137 [-0.208, -0.066] | 0.000 (ref.) | 0.061 [-0.011, 0.133]
40% of pre-tax income | -0.198 [-0.274, -0.122] | -0.061 [-0.133, 0.011] | 0.000 (ref.)

With three levels, the single AMCE reported depends on which level is fixed as zero, even though every directed pairwise contrast is identical across the two triangles (just relabeled).

## Marginal means — every experimental level (baseline-invariant)

| Attribute | Level | Marginal mean [95% CI] |
| --- | --- | --- |
| Housing Cost | 15% of pre-tax income | 0.614 [0.571, 0.657] |
| Housing Cost | 30% of pre-tax income | 0.477 [0.436, 0.517] |
| Housing Cost | 40% of pre-tax income | 0.416 [0.372, 0.459] |
| Presidential Vote (2020) | 30% Democrat, 70% Republican | 0.483 [0.438, 0.528] |
| Presidential Vote (2020) | 50% Democrat, 50% Republican | 0.536 [0.496, 0.576] |
| Presidential Vote (2020) | 70% Democrat, 30% Republican | 0.480 [0.436, 0.524] |
| Racial Composition | 50% White, 50% Nonwhite | 0.500 [0.456, 0.544] |
| Racial Composition | 75% White, 25% Nonwhite | 0.537 [0.492, 0.581] |
| Racial Composition | 90% White, 10% Nonwhite | 0.477 [0.437, 0.518] |
| Racial Composition | 96% White, 4% Nonwhite | 0.488 [0.442, 0.534] |
| School Quality | 5 out of 10 | 0.442 [0.401, 0.484] |
| School Quality | 9 out of 10 | 0.558 [0.516, 0.599] |
| Total Daily Driving Time for Commuting and Errands | 10 min | 0.610 [0.567, 0.654] |
| Total Daily Driving Time for Commuting and Errands | 25 min | 0.541 [0.498, 0.584] |
| Total Daily Driving Time for Commuting and Errands | 45 min | 0.470 [0.425, 0.514] |
| Total Daily Driving Time for Commuting and Errands | 75 min | 0.373 [0.329, 0.417] |
| Type of Place | City – downtown, with a mix of offices, apartments, and shops | 0.394 [0.342, 0.446] |
| Type of Place | City, more residential area | 0.509 [0.454, 0.564] |
| Type of Place | Rural area | 0.529 [0.474, 0.583] |
| Type of Place | Small town | 0.552 [0.499, 0.605] |
| Type of Place | Suburban neighborhood with houses only | 0.473 [0.420, 0.526] |
| Type of Place | Suburban neighborhood with mix of shops, houses, businesses | 0.540 [0.489, 0.591] |
| Violent Crime Rate (Vs National Rate) | 20% Less Crime Than National Average | 0.626 [0.584, 0.667] |
| Violent Crime Rate (Vs National Rate) | 20% More Crime Than National Average | 0.374 [0.333, 0.416] |

Within-attribute MM range (descriptive only, not a formal importance test): Violent Crime Rate (Vs National Rate): 0.251; Total Daily Driving Time for Commuting and Errands: 0.237; Housing Cost: 0.198; Type of Place: 0.158; School Quality: 0.116; Racial Composition: 0.059; Presidential Vote (2020): 0.056.

=== PRODUCED: memo.md ===
# Reply to Reviewer

The reviewer is right on the mechanics. An AMCE is a contrast against a named reference level, so re-baselining relabels which comparison earns a sign and a number. We reran the crime AMCE at both available references (`sensitivity-table.md`): 20% more crime vs. 20% less crime is -0.251 (95% CI [-0.334, -0.168]), and the reverse contrast is 0.251 (95% CI [0.168, 0.334]). Because crime is binary in this design, only a sign flip is possible; there is no third reference that could tell a different story. For a genuinely multi-level attribute (housing cost, 3 levels) the reviewer's concern has more bite: whichever level is fixed at zero changes which single AMCE gets reported, even though the three directed pairwise contrasts are unchanged in substance.

That is a real constraint on how AMCEs should be read, but it does not make the headline finding an artifact. Marginal means carry no reference category at all — each is the modeled probability that a profile with a given level is chosen, averaged over the randomized distribution of every other attribute. The IRR-corrected MM for a community with 20% less crime than the national average is 0.626 (95% CI [0.584, 0.667]); for 20% more crime it is 0.374 (95% CI [0.333, 0.416]). That roughly 25-point separation is visible with no baseline to choose, and it is the largest within-attribute MM spread of the seven attributes in the design (0.251, versus 0.237 for the next-largest, commuting time). The AMCE and the MM evidence point the same direction for the same reason: respondents strongly prefer lower crime, and that preference does not depend on which level a model happens to treat as zero.

What the paper is not entitled to claim is a general cross-attribute importance ranking read off AMCE magnitudes, since attributes here differ in level count and spacing and a coefficient's size partly reflects reference choice rather than only the strength of preference. The revised manuscript will state the headline as: among the experimentally varied levels, respondents strongly and robustly prefer communities with lower violent crime, a conclusion supported by the MMs and unaffected by reference recoding; it will report AMCEs only alongside their named reference, and it will drop any language implying crime is definitively the largest or most important attribute in an absolute, baseline-free sense. The MM table and figure become the primary exhibit for the headline claim; the AMCE table is retained as a secondary, explicitly-labeled robustness check.

=== NOTE ON figures/sensitivity.png ===
One PNG, 2304x1344px at 320 dpi (7.2in x 4.2in), two side-by-side point-range panels (Okabe-Ito blue/vermillion) showing baseline-invariant marginal means with 95% CIs for the two crime levels and the three housing-cost levels, a dashed reference line at 0.5, no in-plot title. I cannot attach the image itself to this text briefing; describe here is accurate to what the script generates and what I visually inspected.

=== QUESTION FOR YOU ===
This is a first-draft solve, not yet reviewed. I am about to consult you once (one advisor
call, unmetered) and then run exactly one revision pass on memo.md and its supporting
artifacts based on your advice — per the task's "at most one revision cycle" constraint, so
this is my only chance to catch problems before finalizing.

Please review as an independent, stronger second reviewer:

1. Is the reviewer's mechanical claim (AMCE sign/ordering depends on reference category)
   correctly and completely conceded? Is the binary-vs-multi-level distinction handled
   correctly (I claim: for a binary attribute, re-baselining can only flip the sign of the
   same single contrast, not create a new comparison; for a 3+ level attribute, the
   *particular* AMCE reported changes with the reference, though the underlying pairwise
   contrasts are invariant up to sign/relabeling)?
2. Does the MM evidence actually support the "headline finding is robust" conclusion, or am
   I overclaiming/underclaiming anywhere? In particular: is it fair to call the MM range a
   meaningful "largest within-attribute spread," given attributes have different numbers of
   levels and different level spacing (I flagged this as descriptive-only, not a formal
   importance test) — should that caveat be stronger, or is it already adequate?
3. Is there anything mechanically wrong in the numbers themselves (e.g., an inconsistency
   between the AMCE table and the MM table that should sum/relate a particular way and
   doesn't), or anything I should verify by hand that I haven't?
4. Is the final "what the revised manuscript will claim" paragraph precisely scoped, or does
   it still leave room for the paper to overclaim?

Tell me plainly what to fix. I have R and the `projoint` package available if you want me to
report the output of a specific check, but you cannot run code yourself in this consult.
