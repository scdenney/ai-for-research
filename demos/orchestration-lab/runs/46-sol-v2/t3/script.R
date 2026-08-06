#!/usr/bin/env Rscript

# T3 reference-category sensitivity analysis. All reported quantities are
# reliability-corrected profile-level estimates with respondent-clustered SEs.
suppressPackageStartupMessages({
  library(projoint)
  library(ggplot2)
})

set.seed(4603)
data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)
labels <- as.data.frame(out$labels, stringsAsFactors = FALSE)

stopifnot(
  nrow(out$data) == 6400L,
  length(unique(out$data$id)) == 400L,
  nrow(labels) == 24L,
  setequal(unique(labels$attribute_id), paste0("att", 1:7))
)

# Estimate one profile-level quantity at a time. This makes the baseline in
# every AMCE explicit and verifies the covariance method for each interval.
estimate_qoi <- function(attribute_id, level_name, estimand = "mm",
                         baseline_attribute = NULL, baseline_level = NULL) {
  qoi <- set_qoi(
    .structure = "profile_level",
    .estimand = estimand,
    .att_choose = attribute_id,
    .lev_choose = level_name,
    .att_choose_b = baseline_attribute,
    .lev_choose_b = baseline_level
  )
  fit <- projoint(
    out,
    .qoi = qoi,
    .se_method = "analytical",
    .clusters_1 = id,
    .se_type_1 = "stata",
    .clusters_2 = id,
    .se_type_2 = "stata"
  )
  stopifnot(
    identical(fit$cluster_by, "id"),
    identical(fit$se_type_used, "stata")
  )
  target <- paste0(estimand, "_corrected")
  z <- fit$estimates[fit$estimates$estimand == target, , drop = FALSE]
  stopifnot(nrow(z) == 1L)
  data.frame(
    estimate = z$estimate,
    se = z$se,
    conf.low = z$conf.low,
    conf.high = z$conf.high,
    stringsAsFactors = FALSE
  )
}

level_name <- function(level_id) sub(".*:", "", level_id)

# Baseline-invariant marginal means for every level of every attribute.
mm_parts <- lapply(seq_len(nrow(labels)), function(i) {
  cbind(
    labels[i, , drop = FALSE],
    estimate_qoi(labels$attribute_id[i], level_name(labels$level_id[i]))
  )
})
mms <- do.call(rbind, mm_parts)
rownames(mms) <- NULL
stopifnot(nrow(mms) == 24L, !anyNA(mms$estimate))

range_parts <- lapply(split(mms, mms$attribute_id), function(x) {
  data.frame(
    attribute_id = x$attribute_id[1],
    attribute = x$attribute[1],
    minimum = min(x$estimate),
    maximum = max(x$estimate),
    spread = max(x$estimate) - min(x$estimate),
    stringsAsFactors = FALSE
  )
})
mm_ranges <- do.call(rbind, range_parts)
mm_ranges <- mm_ranges[order(-mm_ranges$spread), ]
rownames(mm_ranges) <- NULL

# Re-estimate crime under each of its two possible reference levels.
crime <- labels[labels$attribute_id == "att7", , drop = FALSE]
stopifnot(nrow(crime) == 2L)
crime_amces <- list()
for (baseline_id in crime$level_id) {
  baseline_name <- level_name(baseline_id)
  for (chosen_id in crime$level_id[crime$level_id != baseline_id]) {
    key <- paste(chosen_id, baseline_id, sep = "__vs__")
    crime_amces[[key]] <- estimate_qoi(
      "att7", level_name(chosen_id), "amce", "att7", baseline_name
    )
  }
}
stopifnot(length(crime_amces) == 2L)

# Multi-level diagnostic: commuting time under the 10- and 75-minute baselines.
driving <- labels[labels$attribute_id == "att5", , drop = FALSE]
driving_baselines <- driving$level_id[c(1L, nrow(driving))]
driving_amces <- list()
for (baseline_id in driving_baselines) {
  baseline_name <- level_name(baseline_id)
  for (chosen_id in driving$level_id[driving$level_id != baseline_id]) {
    key <- paste(chosen_id, baseline_id, sep = "__vs__")
    driving_amces[[key]] <- estimate_qoi(
      "att5", level_name(chosen_id), "amce", "att5", baseline_name
    )
  }
}
stopifnot(length(driving_amces) == 6L)

# Exact invariance checks: reversing a binary contrast changes only its sign;
# reversing the extreme commuting-time contrast does the same.
crime_forward <- crime_amces[[paste(crime$level_id[2], crime$level_id[1],
                                    sep = "__vs__")]]$estimate
crime_reverse <- crime_amces[[paste(crime$level_id[1], crime$level_id[2],
                                    sep = "__vs__")]]$estimate
drive_forward <- driving_amces[[paste(driving$level_id[4], driving$level_id[1],
                                      sep = "__vs__")]]$estimate
drive_reverse <- driving_amces[[paste(driving$level_id[1], driving$level_id[4],
                                      sep = "__vs__")]]$estimate
stopifnot(
  abs(crime_forward + crime_reverse) < 1e-10,
  abs(drive_forward + drive_reverse) < 1e-10,
  abs(diff(mms$estimate[mms$attribute_id == "att7"]) - crime_forward) < 1e-10
)

# Figure: all-level MMs, with facets ordered by the observed within-attribute
# spread. Crime is highlighted; the plot intentionally has no in-plot title.
wrap_one <- function(x, width) paste(strwrap(x, width = width), collapse = "\n")
mm_ranges$facet_label <- sprintf(
  "%s\nMM spread: %.1f pp",
  vapply(mm_ranges$attribute, wrap_one, character(1), width = 38),
  mm_ranges$spread * 100
)
mms$facet_label <- mm_ranges$facet_label[
  match(mms$attribute_id, mm_ranges$attribute_id)
]
mms$facet_label <- factor(mms$facet_label, levels = mm_ranges$facet_label)
mms$level_plot <- vapply(mms$level, wrap_one, character(1), width = 50)
mms$level_plot <- factor(mms$level_plot, levels = rev(mms$level_plot))
mms$highlight <- ifelse(mms$attribute_id == "att7", "Crime-rate levels", "Other levels")

okabe_ito <- c("Other levels" = "#0072B2", "Crime-rate levels" = "#D55E00")
figure <- ggplot(
  mms,
  aes(x = estimate, y = level_plot, colour = highlight)
) +
  geom_vline(xintercept = 0.5, colour = "grey50", linewidth = 0.45) +
  geom_errorbar(
    aes(xmin = conf.low, xmax = conf.high),
    orientation = "y", width = 0, linewidth = 0.55
  ) +
  geom_point(size = 2.1) +
  facet_grid(facet_label ~ ., scales = "free_y", space = "free_y", switch = "y") +
  scale_colour_manual(values = okabe_ito, guide = "none") +
  scale_x_continuous(
    breaks = seq(0.3, 0.7, by = 0.1),
    labels = function(x) paste0(round(x * 100), "%"),
    name = "Reliability-corrected marginal mean (choice probability)"
  ) +
  coord_cartesian(xlim = c(0.30, 0.70)) +
  labs(y = NULL) +
  theme_minimal(base_size = 10.5) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    strip.placement = "outside",
    strip.text.y.left = element_text(angle = 0, hjust = 1, face = "bold", size = 8.5),
    strip.background = element_rect(fill = "grey94", colour = NA),
    axis.text.y = element_text(size = 8.2),
    plot.margin = margin(8, 12, 8, 8)
  )

dir.create("figures", showWarnings = FALSE, recursive = TRUE)
ggsave(
  "figures/sensitivity.png", figure,
  width = 10.5, height = 11.5, units = "in", dpi = 320, bg = "white"
)

# Markdown helpers and sensitivity table.
format_interval <- function(x, effect = TRUE) {
  if (effect) {
    format_signed <- function(value) {
      value <- round(value * 100, 1)
      ifelse(abs(value) < 0.05, "0.0", sprintf("%+.1f", value))
    }
    sprintf("%s [%s, %s]", format_signed(x$estimate),
            format_signed(x$conf.low), format_signed(x$conf.high))
  } else {
    sprintf("%.1f [%.1f, %.1f]", x$estimate * 100,
            x$conf.low * 100, x$conf.high * 100)
  }
}

format_markdown_table <- function(rows, headers) {
  body <- apply(rows, 1, function(row) paste0("| ", paste(row, collapse = " | "), " |"))
  c(
    paste0("| ", paste(headers, collapse = " | "), " |"),
    paste0("|", paste(rep("---", length(headers)), collapse = "|"), "|"),
    body
  )
}

crime_mm <- mms[mms$attribute_id == "att7", ]
crime_table_rows <- lapply(seq_len(nrow(crime)), function(i) {
  chosen_id <- crime$level_id[i]
  other_id <- crime$level_id[3L - i]
  # In the column where this row's level is the baseline, display reference;
  # in the other column, display its contrast against that column's baseline.
  against_less <- if (chosen_id == crime$level_id[1]) {
    "Reference (0.0)"
  } else {
    format_interval(crime_amces[[paste(chosen_id, crime$level_id[1],
                                       sep = "__vs__")]])
  }
  against_more <- if (chosen_id == crime$level_id[2]) {
    "Reference (0.0)"
  } else {
    format_interval(crime_amces[[paste(chosen_id, crime$level_id[2],
                                       sep = "__vs__")]])
  }
  c(
    crime$level[i], against_less, against_more,
    format_interval(crime_mm[i, ], effect = FALSE)
  )
})
crime_table <- format_markdown_table(
  do.call(rbind, crime_table_rows),
  c("Crime-rate level", "AMCE (less = reference)",
    "AMCE (more = reference)", "Marginal mean")
)

driving_mm <- mms[mms$attribute_id == "att5", ]
driving_table_rows <- lapply(seq_len(nrow(driving)), function(i) {
  chosen_id <- driving$level_id[i]
  values <- lapply(driving_baselines, function(baseline_id) {
    if (chosen_id == baseline_id) return("Reference (0.0)")
    format_interval(driving_amces[[paste(chosen_id, baseline_id,
                                         sep = "__vs__")]])
  })
  c(driving$level[i], unlist(values),
    format_interval(driving_mm[i, ], effect = FALSE))
})
driving_table <- format_markdown_table(
  do.call(rbind, driving_table_rows),
  c("Driving-time level", "AMCE (10 min = reference)",
    "AMCE (75 min = reference)", "Marginal mean")
)

table_lines <- c(
  "# Reference-category sensitivity", "",
  "## Violent Crime Rate", "",
  crime_table, "",
  "*Entries are percentage points with respondent-clustered 95% confidence intervals in brackets. AMCEs and marginal means are reliability-corrected; a reference is the zero contrast by definition.*",
  "", "Because crime is binary, changing its baseline only reverses the same contrast: its magnitude, uncertainty, and substantive level comparison are unchanged.",
  "", "## Multi-level diagnostic: daily driving time", "",
  driving_table, "",
  "*Changing the baseline from 10 to 75 minutes changes which three AMCE contrasts are displayed. It does not change the four marginal means or any fitted pairwise difference; for example, the 75-versus-10-minute contrast is the negative of the 10-versus-75-minute contrast.*",
  ""
)
writeLines(table_lines, "sensitivity-table.md", useBytes = TRUE)

# Reviewer memo. The quoted claim is deliberately narrower than an assertion of
# unique cross-attribute dominance.
crime_less <- crime_mm$estimate[crime_mm$level_id == "att7:level1"]
crime_more <- crime_mm$estimate[crime_mm$level_id == "att7:level2"]
crime_less_ci <- crime_mm[crime_mm$level_id == "att7:level1", c("conf.low", "conf.high")]
crime_more_ci <- crime_mm[crime_mm$level_id == "att7:level2", c("conf.low", "conf.high")]
range_lookup <- setNames(mm_ranges$spread, mm_ranges$attribute_id)

memo_body <- sprintf(paste0(
  "# Reply to the reviewer\n\n",
  "The reviewer is correct about one mechanical point, but the stronger artifact claim does not survive re-estimation. An AMCE is a contrast with a named reference level, so changing that reference changes the reported coefficient. For the binary crime attribute, however, there is only one pairwise comparison. With 20%% less crime as the reference, 20%% more crime has an AMCE of %.1f percentage points (95%% CI %.1f to %.1f). Reversing the reference produces +%.1f points (%.1f to %.1f): the same gap and uncertainty with the sign reversed. There is therefore no alternative crime baseline that can change the magnitude or ordering of its two levels.\n\n",
  "The multi-level check shows why the reviewer’s general warning still matters. For daily driving time, using 10 minutes as the reference yields three negative AMCEs and makes 75 minutes the largest absolute coefficient; using 75 minutes yields three positive AMCEs and makes 10 minutes the largest. Yet all fitted pairwise contrasts are preserved: 75 versus 10 minutes is %.1f points, while 10 versus 75 minutes is +%.1f. Reference coding changes the questions attached to coefficients, not the underlying fitted comparisons or level ordering.\n\n",
  "Marginal means provide the clean baseline-free summary. The estimated choice probability is %.1f%% (%.1f%% to %.1f%%) for communities with 20%% less crime and %.1f%% (%.1f%% to %.1f%%) for those with 20%% more crime, a %.1f-point spread. This is the largest point-estimated within-attribute MM spread in these data, but only narrowly: daily driving time spans %.1f points and housing cost %.1f points. A 1.4-point descriptive lead over driving time does not warrant describing crime as uniquely more important. Cross-attribute rankings also depend on the level ranges and number of levels the design presents.\n\n",
  "We will replace “crime drives community choice” with: **“We find a large crime-rate contrast in this design: profiles with 20%% less crime than the national average had a %.1f-percentage-point higher reliability-corrected choice probability than profiles with 20%% more crime, one of the largest level contrasts among the attributes presented.”** We will report MMs as the primary comparison and retain re-referenced AMCEs as a sensitivity check. This supports a strong low-versus-high-crime preference, not a claim of unique dominance.\n\n",
  "![Reliability-corrected marginal means for all attribute levels](figures/sensitivity.png)\n",
  "*Figure 1. Reliability-corrected profile-level marginal means with respondent-clustered 95%% confidence intervals. Facets are ordered by their observed MM spread; this ordering is descriptive, not a test that spreads differ.*\n"
),
  crime_forward * 100,
  crime_amces[[paste(crime$level_id[2], crime$level_id[1], sep = "__vs__")]]$conf.low * 100,
  crime_amces[[paste(crime$level_id[2], crime$level_id[1], sep = "__vs__")]]$conf.high * 100,
  crime_reverse * 100,
  crime_amces[[paste(crime$level_id[1], crime$level_id[2], sep = "__vs__")]]$conf.low * 100,
  crime_amces[[paste(crime$level_id[1], crime$level_id[2], sep = "__vs__")]]$conf.high * 100,
  drive_forward * 100, drive_reverse * 100,
  crime_less * 100, crime_less_ci$conf.low * 100, crime_less_ci$conf.high * 100,
  crime_more * 100, crime_more_ci$conf.low * 100, crime_more_ci$conf.high * 100,
  range_lookup[["att7"]] * 100, range_lookup[["att5"]] * 100,
  range_lookup[["att1"]] * 100, range_lookup[["att7"]] * 100
)
writeLines(memo_body, "memo.md", useBytes = TRUE)

message("Wrote figures/sensitivity.png, sensitivity-table.md, and memo.md")
