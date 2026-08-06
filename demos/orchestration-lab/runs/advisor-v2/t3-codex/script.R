#!/usr/bin/env Rscript

# Reference-category sensitivity analysis for exampleData1.
# Run from this directory with: Rscript script.R

suppressPackageStartupMessages({
  library(projoint)
  library(ggplot2)
})

out_dir <- "figures"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

# --- Data and estimands -----------------------------------------------------

data(exampleData1, package = "projoint")
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

d <- as.data.frame(out$data, stringsAsFactors = FALSE)
labels <- as.data.frame(out$labels, stringsAsFactors = FALSE)
stopifnot(nrow(d) == 6400L, length(unique(d$id)) == 400L)

# Use one uncertainty procedure for every reported quantity: a nonparametric
# respondent-cluster bootstrap.  Each resample contains complete respondent
# records, including the repeated flipped task used to estimate tau.
n_boot <- 5000L
bootstrap_seed <- 20260719L

respondent_ids <- unique(d$id)
n_respondents <- length(respondent_ids)
d$id_index <- match(d$id, respondent_ids)

# `projoint` estimates tau from one agreement indicator per respondent.  tau
# is the IRR-based response-error parameter used by its correction: an
# uncorrected MM p becomes (p - tau) / (1 - 2*tau), and an uncorrected AMCE
# becomes AMCE / (1 - 2*tau).
agreement <- d[!is.na(d$agree), c("id_index", "agree")]
agreement <- agreement[!duplicated(agreement$id_index), ]
agreement <- agreement$agree[match(seq_len(n_respondents), agreement$id_index)]
stopifnot(length(agreement) == n_respondents, all(!is.na(agreement)))

tau_from_irr <- function(irr) {
  if (any(!is.finite(irr) | irr <= 0.5 | irr >= 1)) {
    stop("Bootstrap IRR estimate fell outside (0.5, 1).")
  }
  (1 - sqrt(2 * irr - 1)) / 2
}

correct_mm <- function(raw_mm, tau) (raw_mm - tau) / (1 - 2 * tau)

# Construct respondent-level sufficient statistics for each MM.  The
# single-profile rule exactly mirrors `projoint`'s profile-level removal of
# tasks in which both profiles have the same level of the focal attribute.
level_selected <- level_n <- matrix(0, nrow = n_respondents, ncol = nrow(labels))
for (j in seq_len(nrow(labels))) {
  in_level <- as.character(d[[labels$attribute_id[j]]]) == labels$level_id[j]
  level_data <- d[in_level, c("id_index", "task", "selected")]
  task_key <- paste(level_data$id_index, level_data$task, sep = ":")
  keep <- !duplicated(task_key) & !duplicated(task_key, fromLast = TRUE)
  level_data <- level_data[keep, ]

  sums <- rowsum(level_data$selected, level_data$id_index, reorder = FALSE)
  counts <- rowsum(rep.int(1L, nrow(level_data)), level_data$id_index, reorder = FALSE)
  level_selected[as.integer(rownames(sums)), j] <- sums[, 1]
  level_n[as.integer(rownames(counts)), j] <- counts[, 1]
}

tau <- tau_from_irr(mean(agreement))
mm_raw <- colSums(level_selected) / colSums(level_n)
mm_point <- correct_mm(mm_raw, tau)

# The same bootstrap draws are retained for MMs, every AMCE releveling, and
# the crime-versus-commuting contrast so their uncertainty is joint and
# respondent clustered throughout.
set.seed(bootstrap_seed)
draws <- matrix(
  sample.int(n_respondents, n_respondents * n_boot, replace = TRUE),
  nrow = n_respondents
)
irr_boot <- colMeans(matrix(agreement[draws], nrow = n_respondents))
tau_boot <- tau_from_irr(irr_boot)
mm_boot <- matrix(NA_real_, nrow = n_boot, ncol = nrow(labels))

for (j in seq_len(nrow(labels))) {
  selected_boot <- colSums(matrix(level_selected[draws, j], nrow = n_respondents))
  n_boot_level <- colSums(matrix(level_n[draws, j], nrow = n_respondents))
  mm_boot[, j] <- correct_mm(selected_boot / n_boot_level, tau_boot)
}

bootstrap_ci <- function(x) {
  unname(stats::quantile(x, probs = c(0.025, 0.975), type = 6, names = FALSE))
}

mm_ci <- t(apply(mm_boot, 2, bootstrap_ci))
mm <- cbind(
  labels,
  estimate = mm_point,
  se = apply(mm_boot, 2, stats::sd),
  conf.low = mm_ci[, 1],
  conf.high = mm_ci[, 2]
)
row.names(mm) <- NULL

level_index <- function(attribute_id, level_id) {
  result <- match(paste(attribute_id, level_id, sep = ":"), labels$level_id)
  stopifnot(length(result) == 1L, !is.na(result))
  result
}

# AMCEs are pairwise MM contrasts.  Taking the difference within every common
# bootstrap resample preserves the covariance between reference-coded cells.
amce_contrast <- function(target_index, baseline_index) {
  if (identical(target_index, baseline_index)) {
    return(data.frame(
      estimate = 0, se = NA_real_, conf.low = NA_real_, conf.high = NA_real_,
      stringsAsFactors = FALSE
    ))
  }
  draws <- mm_boot[, target_index] - mm_boot[, baseline_index]
  ci <- bootstrap_ci(draws)
  data.frame(
    estimate = mm$estimate[target_index] - mm$estimate[baseline_index],
    se = stats::sd(draws), conf.low = ci[1], conf.high = ci[2],
    stringsAsFactors = FALSE
  )
}

fmt_ci <- function(x) {
  if (is.na(x$se[1])) return("0.000 (reference)")
  sprintf("%.3f [%.3f, %.3f]", x$estimate[1], x$conf.low[1], x$conf.high[1])
}

attribute_indices <- function(attribute_name) which(labels$attribute == attribute_name)

make_rebaseline_table <- function(attribute_name) {
  indices <- attribute_indices(attribute_name)
  out_table <- data.frame(
    Level = labels$level[indices], check.names = FALSE, stringsAsFactors = FALSE
  )
  for (baseline_index in indices) {
    baseline_label <- labels$level[baseline_index]
    out_table[[baseline_label]] <- vapply(indices, function(target_index) {
      fmt_ci(amce_contrast(target_index, baseline_index))
    }, character(1))
  }
  out_table
}

crime_attribute <- "Violent Crime Rate (Vs National Rate)"
housing_attribute <- "Housing Cost"
crime_rebaseline <- make_rebaseline_table(crime_attribute)
housing_rebaseline <- make_rebaseline_table(housing_attribute)

# --- Point-estimated ranges and their direct comparison --------------------

# A range is descriptive: max(MM) - min(MM) among the levels actually used in
# this experiment.  It is not a scale-free measure of attribute importance.
range_rows <- lapply(split(seq_len(nrow(mm)), mm$attribute), function(indices) {
  lo <- indices[which.min(mm$estimate[indices])]
  hi <- indices[which.max(mm$estimate[indices])]
  data.frame(
    attribute = mm$attribute[lo],
    min_level = mm$level[lo], max_level = mm$level[hi],
    range = mm$estimate[hi] - mm$estimate[lo],
    stringsAsFactors = FALSE
  )
})
range_data <- do.call(rbind, range_rows)
range_data <- range_data[order(range_data$range), ]

crime_low <- level_index("att7", "level1")
crime_high <- level_index("att7", "level2")
driving_10 <- level_index("att5", "level1")
driving_75 <- level_index("att5", "level4")

crime_range <- mm$estimate[crime_low] - mm$estimate[crime_high]
commuting_range <- mm$estimate[driving_10] - mm$estimate[driving_75]
range_difference <- crime_range - commuting_range
range_difference_boot <-
  (mm_boot[, crime_low] - mm_boot[, crime_high]) -
  (mm_boot[, driving_10] - mm_boot[, driving_75])
range_difference_ci <- bootstrap_ci(range_difference_boot)

# --- Figure -----------------------------------------------------------------

short_attribute <- c(
  "Housing Cost" = "Housing cost",
  "Presidential Vote (2020)" = "Presidential vote (2020)",
  "Racial Composition" = "Racial composition",
  "School Quality" = "School quality",
  "Total Daily Driving Time for Commuting and Errands" = "Daily driving time",
  "Type of Place" = "Type of place",
  "Violent Crime Rate (Vs National Rate)" = "Violent crime rate"
)
range_data$label <- unname(short_attribute[range_data$attribute])
range_data$label <- factor(range_data$label, levels = range_data$label)
range_data$is_crime <- range_data$attribute == crime_attribute

range_panel <- data.frame(
  panel = "Point-estimated range, included levels",
  label = range_data$label,
  estimate = 100 * range_data$range,
  low = NA_real_, high = NA_real_,
  is_crime = range_data$is_crime
)
contrast_panel <- data.frame(
  panel = "Crime − commuting (95% CI)",
  label = "Crime − commuting",
  estimate = 100 * range_difference,
  low = 100 * range_difference_ci[1],
  high = 100 * range_difference_ci[2],
  is_crime = TRUE
)
range_panel$panel <- factor(
  range_panel$panel,
  levels = c(
    "Point-estimated range, included levels",
    "Crime − commuting (95% CI)"
  )
)
contrast_panel$panel <- factor(
  contrast_panel$panel,
  levels = levels(range_panel$panel)
)

figure <- ggplot() +
  geom_vline(
    data = range_panel, aes(xintercept = 0),
    colour = "#8C8C8C", linewidth = 0.35
  ) +
  geom_segment(
    data = range_panel,
    aes(x = 0, xend = estimate, y = label, yend = label, colour = is_crime),
    linewidth = 1.2, show.legend = FALSE
  ) +
  geom_point(
    data = range_panel,
    aes(x = estimate, y = label, colour = is_crime, shape = is_crime),
    size = 3.1, show.legend = FALSE
  ) +
  geom_vline(
    data = contrast_panel, aes(xintercept = 0),
    linetype = "dashed", colour = "#8C8C8C", linewidth = 0.35
  ) +
  geom_errorbar(
    data = contrast_panel,
    aes(x = estimate, xmin = low, xmax = high, y = label),
    orientation = "y", width = 0.12, colour = "#0072B2", linewidth = 0.65
  ) +
  geom_point(
    data = contrast_panel,
    aes(x = estimate, y = label),
    shape = 24, fill = "#0072B2", colour = "#222222", size = 3.5
  ) +
  facet_wrap(vars(panel), nrow = 1, scales = "free", strip.position = "top") +
  scale_colour_manual(values = c(`FALSE` = "#666666", `TRUE` = "#0072B2")) +
  scale_shape_manual(values = c(`FALSE` = 21, `TRUE` = 24)) +
  labs(x = "Percentage points", y = NULL) +
  theme_minimal(base_size = 11) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold", colour = "#222222"),
    axis.text.y = element_text(colour = "#222222"),
    axis.title.x = element_text(margin = margin(t = 8)),
    plot.margin = margin(8, 18, 8, 8)
  )

ggsave(
  filename = file.path(out_dir, "sensitivity.png"),
  plot = figure, width = 9, height = 5, units = "in", dpi = 320, bg = "white"
)

# --- Markdown sensitivity table -------------------------------------------

markdown_table <- function(d) {
  header <- paste0("| ", paste(names(d), collapse = " | "), " |")
  rule <- paste0("|", paste(rep("---", ncol(d)), collapse = "|"), "|")
  body <- apply(d, 1, function(row) paste0("| ", paste(row, collapse = " | "), " |"))
  c(header, rule, body)
}

mm_display <- data.frame(
  Attribute = mm$attribute,
  Level = mm$level,
  `Marginal mean [95% CI]` = sprintf(
    "%.3f [%.3f, %.3f]", mm$estimate, mm$conf.low, mm$conf.high
  ),
  check.names = FALSE, stringsAsFactors = FALSE
)

direct_comparison <- sprintf(
  "%.3f [%.3f, %.3f]", range_difference,
  range_difference_ci[1], range_difference_ci[2]
)

table_text <- c(
  "# Reference-category sensitivity and marginal means",
  "",
  paste0(
    "All entries are IRR-corrected profile-level estimates from `projoint`; ",
    "95% confidence intervals are percentile intervals from ", n_boot,
    " respondent-cluster bootstrap resamples. Each resample retains all profiles ",
    "and the flipped repeat for sampled respondents, so the same uncertainty procedure ",
    "is used for MMs, AMCEs, and their direct comparison."
  ),
  "",
  paste0(
    "The flipped repeat gives tau = ", sprintf("%.3f", tau),
    ", `projoint`'s IRR-based response-error parameter. It maps an uncorrected ",
    "MM p to (p - tau)/(1 - 2*tau), and maps an uncorrected AMCE to ",
    "AMCE/(1 - 2*tau); tau is re-estimated in every bootstrap resample."
  ),
  "",
  "## Violent Crime Rate AMCEs under each baseline",
  "",
  "Each non-reference cell is the AMCE for the row level relative to the column's reference level.",
  "",
  markdown_table(crime_rebaseline),
  "",
  "The crime attribute is binary, so changing the reference merely reverses the orientation of its one pairwise contrast; its absolute magnitude is unchanged.",
  "",
  "## Multi-level check: Housing Cost AMCEs under each baseline",
  "",
  "With three levels, releveling changes which pairwise contrast a reference-coded coefficient displays; it does not change any given pairwise contrast.",
  "",
  markdown_table(housing_rebaseline),
  "",
  "## Marginal means for all levels",
  "",
  markdown_table(mm_display),
  "",
  "## Direct comparison of crime and commuting",
  "",
  paste0(
    "The directly estimated contrast (crime low − crime high) − (driving 10 min − driving 75 min) is ",
    direct_comparison,
    ". Thus the 1.4-point difference between these two contrasts is not distinguishable from zero under the respondent-cluster bootstrap."
  ),
  "",
  "Figure caption: The left panel shows point-estimated ranges among the levels included for each attribute; it deliberately has no range confidence intervals. These ranges depend on the experimental level ranges and are not scale-free measures of attribute importance. The right panel gives the 95% bootstrap interval for the pre-specified crime-versus-commuting contrast. Blue marks identify crime. The figure uses 400 respondents and 8 paired tasks per respondent (plus one flipped repeat); estimates are IRR-corrected profile-selection probabilities."
)

writeLines(table_text, "sensitivity-table.md", useBytes = TRUE)

message("Estimated IRR tau: ", sprintf("%.3f", tau))
message("Wrote figures/sensitivity.png and sensitivity-table.md")
