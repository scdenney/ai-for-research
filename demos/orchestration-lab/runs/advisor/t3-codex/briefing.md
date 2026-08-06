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

=== PRODUCED DELIVERABLES ===
--- memo.md ---
# Reply to reviewer

Thank you. The reviewer is right about the mechanical point: an AMCE is a contrast against a reference category, so the reported coefficient vector changes when the reference changes. We have revised the analysis to make this explicit rather than treating the original coding as innocuous. For the three-level Housing Cost attribute, for example, the AMCE for 40% rather than 15% of pre-tax income is -0.198, whereas the AMCE for 40% rather than 30% is -0.061. These are different displayed contrasts, and a ranking based on selected coefficients or on their absolute values is therefore not a reference-invariant measure of attribute importance.

For violent crime, however, the implication is more limited because the attribute is binary. With “20% less crime than the national average” as the reference, “20% more crime” has an AMCE of -0.251 (95% CI [-0.334, -0.168]). Changing the reference yields +0.251 ([0.168, 0.334]) for less rather than more crime. Thus the sign changes, as it must, but the magnitude and the underlying pairwise comparison do not. There is no third crime level whose placement can change the ordering within that attribute.

We also now report marginal means, which do not depend on a selected reference category. The corrected probability of selection is 0.626 (95% CI [0.584, 0.667]) for a profile with 20% less violent crime and 0.374 ([0.333, 0.416]) for one with 20% more violent crime. The 0.251 marginal-mean gap is the same substantive pattern represented by either coding of the binary AMCE. Across the attributes in this experimental design, crime has the largest observed max–min MM spread (0.251); commuting is close (0.237), followed by housing cost (0.198). We treat these as descriptive comparisons of the ranges presented in the design, not as a formal or general measure of importance.

Accordingly, we will withdraw any wording that says crime “drives” community choice based merely on the original AMCE coding or that implies a baseline-free universal ranking. The revised headline will state: within the attribute levels randomized in this conjoint, profiles with 20% less violent crime than the national average were selected substantially more often than profiles with 20% more crime (an estimated 25.1-percentage-point marginal-mean difference). We will present the two crime AMCE codings, the marginal means for every level, and label the cross-attribute MM ranges as design-specific descriptive evidence.

--- sensitivity-table.md ---
# Crime reference-category sensitivity

Estimates are measurement-error-corrected profile-level quantities from `projoint`; intervals are 95% confidence intervals. AMCEs are percentage-point differences in probability of selection.

| Quantity | 20% less crime as reference | 20% more crime as reference | Marginal mean (95% CI) |
|---|---:|---:|---:|
| 20% less crime than national average | Reference | 0.251 ([0.168, 0.334]) | 0.626 ([0.584, 0.667]) |
| 20% more crime than national average | -0.251 ([-0.334, -0.168]) | Reference | 0.374 ([0.333, 0.416]) |

The two AMCEs are exact sign reversals because crime has only two levels. For a multi-level contrast, Housing Cost changes displayed coefficients with the reference: 

| Housing Cost contrast | AMCE (95% CI) |
|---|---:|
| 30% of pre-tax income vs. 15% of pre-tax income | -0.137 ([-0.208, -0.066]) |
| 40% of pre-tax income vs. 15% of pre-tax income | -0.198 ([-0.274, -0.122]) |
| 15% of pre-tax income vs. 30% of pre-tax income | 0.137 ([0.066, 0.208]) |
| 40% of pre-tax income vs. 30% of pre-tax income | -0.061 ([-0.133, 0.011]) |
| 15% of pre-tax income vs. 40% of pre-tax income | 0.198 ([0.122, 0.274]) |
| 30% of pre-tax income vs. 40% of pre-tax income | 0.061 ([-0.011, 0.133]) |

All marginal means (and the baseline-invariant max–min MM spans) are computed in `script.R`; the figure reports the crime MMs.

--- script.R ---
# Task T3: reference-category sensitivity for AMCEs and marginal means
# Requires the installed projoint package (and its installed ggplot2 dependency).

library(projoint)
library(ggplot2)

dir.create("figures", showWarnings = FALSE, recursive = TRUE)

# Recreate the supplied example and retain the profile-level outcome.
data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)
labels <- as.data.frame(out$labels, stringsAsFactors = FALSE)

# Use the package's profile-level estimands.  We report the package's
# measurement-error-corrected estimates; `uncorrected` estimates remain in the
# objects below for reproducibility.
mm_fit <- projoint(out, .structure = "profile_level", .estimand = "mm")
mms <- merge(
  subset(as.data.frame(mm_fit$estimates), estimand == "mm_corrected"),
  labels, by.x = "att_level_choose", by.y = "level_id", all.x = TRUE,
  sort = FALSE
)

# Estimate one explicitly chosen level relative to one explicitly chosen
# reference level.  This makes re-referencing transparent rather than relying
# on factor-order defaults.
one_amce <- function(attribute, chosen_level, baseline_level) {
  qoi <- set_qoi(
    .structure = "profile_level", .estimand = "amce",
    .att_choose = attribute, .lev_choose = chosen_level,
    .att_choose_b = attribute, .lev_choose_b = baseline_level
  )
  ans <- projoint(out, .qoi = qoi)$estimates
  ans <- subset(as.data.frame(ans), estimand == "amce_corrected")
  ans$attribute_id <- attribute
  ans$chosen_level_id <- paste0(attribute, ":", chosen_level)
  ans$baseline_level_id <- paste0(attribute, ":", baseline_level)
  ans
}

# Crime is binary: both possible reference choices are shown.
crime_specs <- data.frame(
  chosen = c("level2", "level1"), baseline = c("level1", "level2"),
  stringsAsFactors = FALSE
)
crime_amces <- do.call(rbind, lapply(seq_len(nrow(crime_specs)), function(i) {
  one_amce("att7", crime_specs$chosen[i], crime_specs$baseline[i])
}))
crime_amces <- merge(crime_amces, labels[, c("level_id", "level")],
                     by.x = "chosen_level_id", by.y = "level_id", all.x = TRUE)
names(crime_amces)[names(crime_amces) == "level"] <- "chosen"
crime_amces <- merge(crime_amces, labels[, c("level_id", "level")],
                     by.x = "baseline_level_id", by.y = "level_id", all.x = TRUE)
names(crime_amces)[names(crime_amces) == "level"] <- "baseline"

# A three-level illustration: all reference categories for Housing Cost.
housing_levels <- paste0("level", 1:3)
housing_amces <- do.call(rbind, lapply(housing_levels, function(ref) {
  do.call(rbind, lapply(setdiff(housing_levels, ref), function(chosen) {
    one_amce("att1", chosen, ref)
  }))
}))
housing_amces <- merge(housing_amces, labels[, c("level_id", "level")],
                       by.x = "chosen_level_id", by.y = "level_id", all.x = TRUE)
names(housing_amces)[names(housing_amces) == "level"] <- "chosen"
housing_amces <- merge(housing_amces, labels[, c("level_id", "level")],
                       by.x = "baseline_level_id", by.y = "level_id", all.x = TRUE)
names(housing_amces)[names(housing_amces) == "level"] <- "baseline"

# Attribute span is a baseline-invariant descriptive comparison of the MM
# profile (not a substitute for a prespecified importance estimand).
mm_spans <- do.call(rbind, lapply(split(mms, mms$attribute), function(x) {
  data.frame(attribute = x$attribute[1],
             mm_min = min(x$estimate), mm_max = max(x$estimate),
             mm_span = max(x$estimate) - min(x$estimate))
}))
mm_spans <- mm_spans[order(-mm_spans$mm_span), ]

fmt <- function(x) sprintf("%.3f", x)
ci <- function(x) sprintf("[%.3f, %.3f]", x$conf.low, x$conf.high)

# Required side-by-side crime table, with the two reference choices and MMs.
crime_mm <- mms[mms$attribute_id == "att7", ]
crime_mm <- crime_mm[match(c("att7:level1", "att7:level2"), crime_mm$att_level_choose), ]
tab_lines <- c(
  "# Crime reference-category sensitivity",
  "",
  "Estimates are measurement-error-corrected profile-level quantities from `projoint`; intervals are 95% confidence intervals. AMCEs are percentage-point differences in probability of selection.",
  "",
  "| Quantity | 20% less crime as reference | 20% more crime as reference | Marginal mean (95% CI) |",
  "|---|---:|---:|---:|",
  sprintf("| 20%% less crime than national average | Reference | %s (%s) | %s (%s) |",
          fmt(crime_amces$estimate[crime_amces$chosen_level_id == "att7:level1"]),
          ci(crime_amces[crime_amces$chosen_level_id == "att7:level1", ]),
          fmt(crime_mm$estimate[1]), ci(crime_mm[1, ])),
  sprintf("| 20%% more crime than national average | %s (%s) | Reference | %s (%s) |",
          fmt(crime_amces$estimate[crime_amces$chosen_level_id == "att7:level2"]),
          ci(crime_amces[crime_amces$chosen_level_id == "att7:level2", ]),
          fmt(crime_mm$estimate[2]), ci(crime_mm[2, ])),
  "",
  "The two AMCEs are exact sign reversals because crime has only two levels. For a multi-level contrast, Housing Cost changes displayed coefficients with the reference: ",
  "",
  "| Housing Cost contrast | AMCE (95% CI) |",
  "|---|---:|",
  vapply(seq_len(nrow(housing_amces)), function(i) sprintf(
    "| %s vs. %s | %s (%s) |", housing_amces$chosen[i], housing_amces$baseline[i],
    fmt(housing_amces$estimate[i]), ci(housing_amces[i, ])), character(1)),
  "",
  "All marginal means (and the baseline-invariant max–min MM spans) are computed in `script.R`; the figure reports the crime MMs."
)
writeLines(tab_lines, "sensitivity-table.md")

# One figure only: the identical binary contrast under either reference, plus
# the baseline-invariant marginal means that identify the substantive pattern.
crime_plot <- data.frame(
  panel = c("AMCE under displayed reference", "AMCE under displayed reference",
            "Marginal means", "Marginal means"),
  label = c("More vs less", "Less vs more", "20% less crime", "20% more crime"),
  estimate = c(crime_amces$estimate[match(c("att7:level2", "att7:level1"), crime_amces$chosen_level_id)],
               crime_mm$estimate),
  low = c(crime_amces$conf.low[match(c("att7:level2", "att7:level1"), crime_amces$chosen_level_id)],
          crime_mm$conf.low),
  high = c(crime_amces$conf.high[match(c("att7:level2", "att7:level1"), crime_amces$chosen_level_id)],
           crime_mm$conf.high)
)
crime_plot$label <- factor(crime_plot$label, levels = rev(crime_plot$label))
p <- ggplot(crime_plot, aes(x = estimate, y = label)) +
  geom_vline(xintercept = 0, colour = "grey70", linewidth = 0.4) +
  geom_errorbar(aes(xmin = low, xmax = high), width = 0.18,
                orientation = "y", colour = "#236192") +
  geom_point(size = 2.7, colour = "#236192") +
  facet_wrap(~panel, scales = "free", nrow = 1) +
  labs(x = "Corrected estimate (95% CI)", y = NULL) +
  theme_minimal(base_size = 10) +
  theme(panel.grid.major.y = element_blank(), strip.text = element_text(face = "bold"))
ggsave("figures/sensitivity.png", p, width = 8.2, height = 3.4, units = "in", dpi = 320)

=== QUESTION ===
This is a completed submission against the brief above. What would you change?
