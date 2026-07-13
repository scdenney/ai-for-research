#!/usr/bin/env Rscript

library(projoint)
library(ggplot2)

# Reproducible descriptive design check for projoint::exampleData1.
# Okabe-Ito palette and a compact, legible plotting theme.
okabe_ito <- c(
  orange = "#E69F00", sky_blue = "#56B4E9", bluish_green = "#009E73",
  yellow = "#F0E442", blue = "#0072B2", vermillion = "#D55E00",
  reddish_purple = "#CC79A7", black = "#000000"
)
plot_theme <- theme_minimal(base_size = 11) +
  theme(
    strip.text = element_text(face = "bold"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "none",
    axis.text.y = element_text(size = 8)
  )
set.seed(20260713)

data(exampleData1)
out <- reshape_projoint(exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped"))

dir.create("figures", showWarnings = FALSE, recursive = TRUE)

attribute_ids <- paste0("att", seq_len(7))
if (!identical(attribute_ids, intersect(attribute_ids, names(out$data)))) {
  stop("The reshaped data do not contain exactly att1 through att7.")
}

# Build the full attribute-level frame from labels and factor levels so that
# explicitly defined levels with zero observed presentations are retained.
label_lookup <- out$labels[, c("attribute_id", "attribute", "level_id", "level")]
level_rows <- lapply(attribute_ids, function(attribute_id) {
  factor_levels <- levels(out$data[[attribute_id]])
  labels_for_attribute <- label_lookup[label_lookup$attribute_id == attribute_id, ]
  matched <- match(factor_levels, labels_for_attribute$level_id)
  if (anyNA(matched)) {
    stop(sprintf("Missing label(s) for %s.", attribute_id))
  }
  data.frame(
    attribute_id = attribute_id,
    attribute = labels_for_attribute$attribute[matched],
    level_id = factor_levels,
    level = labels_for_attribute$level[matched],
    level_order = seq_along(factor_levels),
    stringsAsFactors = FALSE
  )
})
levels_frame <- do.call(rbind, level_rows)

frequency_rows <- lapply(attribute_ids, function(attribute_id) {
  observed <- table(factor(out$data[[attribute_id]], levels = levels(out$data[[attribute_id]])))
  attribute_levels <- levels_frame[levels_frame$attribute_id == attribute_id, ]
  attribute_levels$count <- as.integer(observed[attribute_levels$level_id])
  attribute_levels$total_presentations <- sum(attribute_levels$count)
  attribute_levels$percent <- 100 * attribute_levels$count / attribute_levels$total_presentations
  attribute_levels$expected_percent <- 100 / nrow(attribute_levels)
  attribute_levels$deviation_pp <- attribute_levels$percent - attribute_levels$expected_percent
  attribute_levels
})
balance <- do.call(rbind, frequency_rows)

n_profiles <- nrow(out$data)
n_respondents <- length(unique(out$data$id))
tasks_by_respondent <- tapply(out$data$task, out$data$id, function(x) length(unique(x)))
profiles_by_respondent_task <- table(interaction(out$data$id, out$data$task, drop = TRUE))
if (length(unique(tasks_by_respondent)) != 1L ||
    length(unique(profiles_by_respondent_task)) != 1L) {
  stop("Tasks or profiles per task are not constant across respondents.")
}
n_tasks <- unname(unique(tasks_by_respondent))
n_profiles_per_task <- unname(unique(as.integer(profiles_by_respondent_task)))

if (n_profiles != 6400L || length(unique(balance$attribute_id)) != 7L) {
  stop("Unexpected design dimensions: expected 6,400 profiles and seven attributes.")
}
if (any(tapply(balance$count, balance$attribute_id, sum) != n_profiles)) {
  stop("At least one attribute frequency total does not equal nrow(out$data).")
}

attribute_summary <- unique(levels_frame[c("attribute_id", "attribute")])
attribute_summary$level_count <- as.integer(table(levels_frame$attribute_id)[attribute_summary$attribute_id])

figure_data <- balance
figure_data$level_display <- factor(
  figure_data$level,
  levels = rev(unique(figure_data$level[order(figure_data$attribute_id, figure_data$level_order)]))
)

wrap_facet_label <- function(x) {
  vapply(x, function(label) paste(strwrap(label, width = 34), collapse = "\n"), character(1))
}

p <- ggplot(figure_data, aes(x = percent, y = level_display, fill = attribute)) +
  geom_vline(aes(xintercept = expected_percent), colour = okabe_ito[["vermillion"]],
             linetype = "dashed", linewidth = 0.45, inherit.aes = FALSE) +
  geom_col(width = 0.72, fill = okabe_ito[["blue"]]) +
  facet_wrap(~ attribute, scales = "free_y", ncol = 2,
             labeller = labeller(attribute = wrap_facet_label)) +
  scale_x_continuous(labels = function(x) paste0(x, "%"), expand = expansion(mult = c(0, 0.06))) +
  labs(x = "Profile presentations within attribute", y = NULL) +
  plot_theme

ggsave("figures/level-frequencies.png", p, width = 12, height = 11,
       units = "in", dpi = 320, bg = "white")

md <- c(
  "# Descriptive design summary",
  "",
  sprintf("The reshaped experimental data contain **%d unique respondents**, **%d experimental tasks per respondent**, and **%g profiles per task** (%d profile presentations total).", n_respondents, n_tasks, n_profiles_per_task, n_profiles),
  "",
  "The `choice1_repeated_flipped` outcome is represented by the reliability fields (`selected_repeated` and `agree`); it is not a ninth randomized profile task.",
  "",
  "## Attributes and levels",
  "",
  "| Attribute ID | Attribute | Levels |",
  "|---|---|---:|"
)
md <- c(md, vapply(seq_len(nrow(attribute_summary)), function(i) {
  sprintf("| %s | %s | %d |", attribute_summary$attribute_id[i], attribute_summary$attribute[i], attribute_summary$level_count[i])
}, character(1)))
md <- c(md,
  "",
  "## Randomization balance",
  "",
  "Each attribute is tabulated over all 6,400 profile presentations. Expected percentages assume equal allocation across that attribute's labeled levels.",
  "",
  "| Attribute | Level | Count | Percent within attribute | Expected percent | Deviation (pp) |",
  "|---|---|---:|---:|---:|---:|"
)
md <- c(md, vapply(seq_len(nrow(balance)), function(i) {
  sprintf("| %s | %s | %d | %.2f%% | %.2f%% | %+.2f |",
          balance$attribute[i], balance$level[i], balance$count[i], balance$percent[i],
          balance$expected_percent[i], balance$deviation_pp[i])
}, character(1)))
md <- c(md,
  "",
  "## Level-frequency figure",
  "",
  "![Within-attribute level frequencies](figures/level-frequencies.png)",
  "",
  "Within each attribute, blue bars show the percentage of 6,400 profile presentations assigned to each level, and the dashed vermillion line marks equal allocation.",
  ""
)
writeLines(md, "summary.md")
