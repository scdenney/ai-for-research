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
