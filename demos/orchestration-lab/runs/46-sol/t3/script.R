#!/usr/bin/env Rscript

# Task T3: profile-level conjoint sensitivity analysis.
set.seed(20260717)

suppressPackageStartupMessages({
  library(projoint)
  library(ggplot2)
})

fail <- function(...) stop(sprintf(...), call. = FALSE)
require_rows <- function(x, n, what) {
  if (nrow(x) != n) fail("Expected %d %s rows; found %d.", n, what, nrow(x))
}
fmt_ci <- function(estimate, low, high) {
  sprintf("%.1f [%.1f, %.1f]", 100 * estimate, 100 * low, 100 * high)
}
fmt_zero <- function(x) ifelse(is.na(x), "0.0 (baseline)", x)

data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

labels <- as.data.frame(out$labels, stringsAsFactors = FALSE)
if (nrow(labels) != 24L) fail("Expected 24 labelled levels; found %d.", nrow(labels))
labels$level_token <- sub("^[^:]+:", "", labels$level_id)

# One all-level model provides every conventional profile-level marginal mean.
mm_fit <- projoint(
  out, .structure = "profile_level", .estimand = "mm",
  .se_method = "analytical", .seed = 20260717
)
mm <- as.data.frame(mm_fit$estimates, stringsAsFactors = FALSE)
mm <- merge(mm, labels, by.x = "att_level_choose", by.y = "level_id", all.x = TRUE,
            sort = FALSE)
if (anyNA(mm$attribute) || anyNA(mm$level)) fail("Could not map MM ids to labels.")
mm_corrected <- mm[mm$estimand == "mm_corrected", ]
mm_uncorrected <- mm[mm$estimand == "mm_uncorrected", ]
require_rows(mm_corrected, 24L, "corrected MM")
require_rows(mm_uncorrected, 24L, "uncorrected MM")

crime_id <- "att7"
drive_id <- "att5"
crime_labels <- labels[labels$attribute_id == crime_id, ]
drive_labels <- labels[labels$attribute_id == drive_id, ]
require_rows(crime_labels, 2L, "crime label")
require_rows(drive_labels, 4L, "driving-time label")

# Refit each directed, profile-level AMCE with the requested reference level.
# This deliberately does not relabel coefficients from a single reference fit.
estimate_reference_set <- function(attribute_id, label_rows) {
  ans <- list()
  for (i in seq_len(nrow(label_rows))) {
    baseline <- label_rows$level_token[i]
    baseline_id <- label_rows$level_id[i]
    pieces <- list()
    for (j in seq_len(nrow(label_rows))) {
      if (j == i) next
      q <- set_qoi(
        .structure = "profile_level", .estimand = "amce",
        .att_choose = attribute_id, .lev_choose = label_rows$level_token[j],
        .att_choose_b = attribute_id, .lev_choose_b = baseline
      )
      fit <- projoint(out, .qoi = q, .structure = "profile_level", .estimand = "amce",
                      .se_method = "analytical", .seed = 20260717)
      z <- as.data.frame(fit$estimates, stringsAsFactors = FALSE)
      if (!all(c("amce_corrected", "amce_uncorrected") %in% z$estimand)) {
        fail("Missing corrected or uncorrected AMCE for %s baseline %s.", attribute_id, baseline_id)
      }
      z$baseline_id <- baseline_id
      pieces[[length(pieces) + 1L]] <- z
    }
    ans[[baseline_id]] <- do.call(rbind, pieces)
  }
  ans
}

crime_fits <- estimate_reference_set(crime_id, crime_labels)
drive_fits <- estimate_reference_set(drive_id, drive_labels)
if (!setequal(names(crime_fits), crime_labels$level_id) || !setequal(names(drive_fits), drive_labels$level_id)) {
  fail("Not all alternative baselines were estimated.")
}

make_explicit_rows <- function(fits, label_rows) {
  out_rows <- list()
  for (baseline_id in names(fits)) {
    z <- fits[[baseline_id]]
    for (type in c("amce_corrected", "amce_uncorrected")) {
      observed <- z[z$estimand == type, c("att_level_choose", "estimate", "se", "conf.low", "conf.high")]
      require_rows(observed, nrow(label_rows) - 1L, paste(type, "contrast"))
      zero <- data.frame(att_level_choose = baseline_id, estimate = 0, se = NA_real_,
                         conf.low = NA_real_, conf.high = NA_real_)
      zero$estimand <- type
      observed$estimand <- type
      observed$baseline_id <- baseline_id
      zero$baseline_id <- baseline_id
      out_rows[[length(out_rows) + 1L]] <- rbind(observed, zero)
    }
  }
  do.call(rbind, out_rows)
}

crime_amce <- make_explicit_rows(crime_fits, crime_labels)
drive_amce <- make_explicit_rows(drive_fits, drive_labels)
drive_max_by_baseline <- vapply(drive_labels$level_id, function(baseline_id) {
  z <- drive_amce[drive_amce$estimand == "amce_corrected" &
                    drive_amce$baseline_id == baseline_id & drive_amce$estimate != 0, ]
  max(abs(z$estimate))
}, numeric(1))
if (length(unique(round(drive_max_by_baseline, 10))) == 1L) {
  fail("Driving-time AMCE magnitudes did not vary across reference levels.")
}

# Invariants for binary crime reference reversal, separately by correction status.
for (type in c("amce_corrected", "amce_uncorrected")) {
  z <- crime_amce[crime_amce$estimand == type & crime_amce$estimate != 0, ]
  require_rows(z, 2L, paste(type, "nonbaseline crime"))
  if (abs(sum(z$estimate)) > 1e-10 || abs(abs(z$estimate[1]) - abs(z$estimate[2])) > 1e-10) {
    fail("Crime AMCE reference reversal failed for %s.", type)
  }
}

attribute_ranges <- function(x) {
  do.call(rbind, lapply(split(x, x$attribute), function(z) {
    data.frame(attribute = z$attribute[1], minimum = min(z$estimate),
               maximum = max(z$estimate), range = diff(range(z$estimate)))
  }))
}
ranges_corrected <- attribute_ranges(mm_corrected)
ranges_uncorrected <- attribute_ranges(mm_uncorrected)
if (nrow(ranges_corrected) != 7L) fail("Corrected MM ranges were not computed for every attribute.")

# Guardrails from the independent numerical probe (wide enough to avoid rounding noise).
crime_mm <- mm_corrected[mm_corrected$attribute_id == crime_id, ]
crime_contrast <- abs(crime_amce$estimate[crime_amce$estimand == "amce_corrected" & crime_amce$estimate != 0][1])
drive_range <- ranges_corrected$range[ranges_corrected$attribute == drive_labels$attribute[1]]
housing_range <- ranges_corrected$range[ranges_corrected$attribute == "Housing Cost"]
if (abs(max(crime_mm$estimate) - 0.626) > 0.015 || abs(min(crime_mm$estimate) - 0.374) > 0.015 ||
    abs(crime_contrast - 0.2515) > 0.015 || abs(drive_range - 0.237) > 0.02 ||
    abs(housing_range - 0.198) > 0.02) {
  fail("Estimates are materially outside the expected numerical neighborhood; diagnose before proceeding.")
}

crime_order <- crime_labels$level_id
crime_table <- labels[match(crime_order, labels$level_id), c("level_id", "level")]
make_crime_panel <- function(type) {
  panel <- crime_table
  for (baseline_id in crime_order) {
    z <- crime_amce[crime_amce$estimand == type & crime_amce$baseline_id == baseline_id, ]
    z <- z[match(panel$level_id, z$att_level_choose), ]
    panel[[baseline_id]] <- fmt_zero(ifelse(is.na(z$se), NA_character_, fmt_ci(z$estimate, z$conf.low, z$conf.high)))
  }
  zmm <- if (type == "amce_corrected") mm_corrected else mm_uncorrected
  zmm <- zmm[zmm$attribute_id == crime_id, ]
  zmm <- zmm[match(panel$level_id, zmm$att_level_choose), ]
  panel$mm <- fmt_ci(zmm$estimate, zmm$conf.low, zmm$conf.high)
  panel
}
write_panel <- function(panel, heading) {
  # Human-readable headers explicitly identify the baseline rather than raw ids.
  c(heading,
    "",
    "| Violent Crime Rate level | MM [95% CI], pp | AMCE: Less Crime baseline [95% CI], pp | AMCE: More Crime baseline [95% CI], pp |",
    "|---|---:|---:|---:|",
    sprintf("| %s | %s | %s | %s |", panel$level, panel$mm, panel[[crime_order[1]]], panel[[crime_order[2]]]),
    "")
}
md <- c(
  "# Violent-crime reference-level sensitivity",
  "",
  "All entries are percentage points. Marginal means (MMs) are profile-level estimates from one all-level model. Each AMCE contrast was re-estimated with `set_qoi()` under the stated reference level, using analytical SEs and the package default respondent clustering.",
  "",
  "Baseline rows are fixed at zero by definition and do not have sampling intervals. Corrected AMCE estimates may differ from differences of separately estimated corrected MMs by trivial numerical/model-fitting amounts.",
  ""
)
md <- c(md, write_panel(make_crime_panel("amce_corrected"), "## Measurement-error-corrected estimates (primary)"))
md <- c(md, write_panel(make_crime_panel("amce_uncorrected"), "## Uncorrected estimates (secondary)"))
writeLines(md, "sensitivity-table.md")

# Exactly one figure: all corrected MMs, grouped by attribute.
plot_data <- mm_corrected
attribute_display <- c(
  "Housing Cost" = "Housing Cost",
  "Presidential Vote (2020)" = "Presidential Vote (2020)",
  "Racial Composition" = "Racial Composition",
  "School Quality" = "School Quality",
  "Total Daily Driving Time for Commuting and Errands" = "Daily Driving Time",
  "Type of Place" = "Type of Place",
  "Violent Crime Rate (Vs National Rate)" = "Violent Crime Rate"
)
plot_data$attribute_display <- factor(unname(attribute_display[plot_data$attribute]),
                                      levels = unname(attribute_display[unique(labels$attribute)]))
plot_data$level <- factor(plot_data$level, levels = rev(unique(labels$level)))
plot_data$colour_group <- ifelse(plot_data$attribute_id == crime_id, "Crime",
                                 ifelse(plot_data$attribute_id == drive_id, "Driving time", "Other attributes"))
dir.create("figures", showWarnings = FALSE, recursive = TRUE)
p <- ggplot(plot_data, aes(x = estimate, y = level, colour = colour_group)) +
  geom_vline(xintercept = 0.50, colour = "#999999", linewidth = 0.45, linetype = "dashed") +
  geom_errorbar(aes(xmin = conf.low, xmax = conf.high), orientation = "y", width = 0.18, linewidth = 0.55) +
  geom_point(size = 2.0) +
  scale_colour_manual(values = c("Crime" = "#D55E00", "Driving time" = "#0072B2", "Other attributes" = "#333333")) +
  scale_x_continuous(limits = c(0.25, 0.75), breaks = seq(0.3, 0.7, 0.1), labels = function(x) sprintf("%.0f%%", 100 * x)) +
  facet_grid(attribute_display ~ ., scales = "free_y", space = "free_y", switch = "y") +
  labs(x = "Corrected marginal mean", y = NULL) +
  theme_minimal(base_size = 10) +
  theme(legend.position = "none", panel.grid.major.y = element_blank(), panel.grid.minor = element_blank(),
        strip.text.y.left = element_text(angle = 0, face = "bold", hjust = 0),
        strip.placement = "outside", plot.title = element_blank(), plot.caption = element_blank(),
        axis.text.y = element_text(size = 8), panel.spacing.y = grid::unit(0.25, "lines"))
ggsave("figures/sensitivity.png", p, width = 10, height = 13, units = "in", dpi = 320, bg = "white")

# Concise, reproducible diagnostics for the lead and stdout.
profile_n <- nrow(out$data)
respondent_n <- length(unique(out$data$id))
range_lines <- function(x, label) {
  x <- x[order(-x$range), ]
  c(sprintf("%s MM ranges (descending; percentage points):", label),
    sprintf("  %s: %.1f (min %.1f, max %.1f)", x$attribute, 100 * x$range, 100 * x$minimum, 100 * x$maximum))
}
crime_lines <- function(type, label) {
  z <- crime_amce[crime_amce$estimand == type & crime_amce$estimate != 0, ]
  z <- z[match(crime_order, z$baseline_id), ]
  c(sprintf("  %s:", label),
    sprintf("    %s baseline -> %s: %s pp", labels$level[match(z$baseline_id, labels$level_id)],
            labels$level[match(z$att_level_choose, labels$level_id)], fmt_ci(z$estimate, z$conf.low, z$conf.high)))
}
drive_max_lines <- sprintf("  %s baseline: %.1f pp",
                           labels$level[match(drive_labels$level_id, labels$level_id)],
                           100 * drive_max_by_baseline)
diagnostics <- c(
  "Task T3 conjoint sensitivity diagnostics",
  sprintf("projoint version: %s", as.character(packageVersion("projoint"))),
  sprintf("Respondents: %d; profile rows: %d", respondent_n, profile_n),
  sprintf("IRR: %s; tau: %s", as.character(mm_fit$irr), if (is.null(mm_fit$tau)) "not exposed" else sprintf("%.6f", mm_fit$tau)),
  "",
  range_lines(ranges_corrected, "Corrected"), "",
  range_lines(ranges_uncorrected, "Uncorrected"), "",
  "Crime AMCEs (percentage points; estimate [95% CI]):",
  crime_lines("amce_corrected", "Corrected"),
  crime_lines("amce_uncorrected", "Uncorrected"), "",
  "Driving-time sensitivity: largest absolute corrected AMCE by baseline:",
  drive_max_lines,
  sprintf("Checks: 24 corrected MMs; %d crime levels; %d crime and %d driving reference sets estimated.",
          nrow(crime_mm), length(crime_fits), length(drive_fits))
)
writeLines(diagnostics, "analysis-diagnostics.txt")
cat(paste(diagnostics, collapse = "\n"), "\n")

for (path in c("sensitivity-table.md", "figures/sensitivity.png", "analysis-diagnostics.txt")) {
  if (!file.exists(path) || file.info(path)$size <= 0) fail("Expected nonempty output is missing: %s", path)
}
