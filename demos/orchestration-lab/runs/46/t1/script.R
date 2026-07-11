#!/usr/bin/env Rscript

# Reproducible descriptive summary of projoint's exampleData1 design.
# Plot styling is declared here so that the figure is reproducible.
plot_theme <- ggplot2::theme_minimal(base_size = 10) +
  ggplot2::theme(
    plot.title = ggplot2::element_blank(),
    axis.title.y = ggplot2::element_blank(),
    panel.grid.major.y = ggplot2::element_blank(),
    strip.text = ggplot2::element_text(face = "bold"),
    legend.position = "none"
  )
okabe_ito <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442",
               "#0072B2", "#D55E00", "#CC79A7", "#000000")

set.seed(4601)

if (!requireNamespace("projoint", quietly = TRUE)) {
  stop("The installed projoint package is required.")
}
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  stop("The installed ggplot2 package is required to create the requested figure.")
}

library(projoint)
data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

# `task` indexes only the eight primary choices. The repeated outcome is stored
# in selected_repeated, so it is not an additional task or set of profiles here.
primary_data <- out$data
attribute_ids <- intersect(out$labels$attribute_id, names(primary_data))
attribute_ids <- unique(attribute_ids)

respondents <- length(unique(primary_data$id))
tasks_per_respondent <- nrow(unique(primary_data[c("id", "task")])) / respondents
profiles_per_task <- nrow(primary_data) / nrow(unique(primary_data[c("id", "task")]))

# Join each observed factor level to the package-supplied human-readable label.
frequency_rows <- lapply(attribute_ids, function(attribute_id) {
  observed <- as.character(primary_data[[attribute_id]])
  counts <- table(observed)
  label_rows <- out$labels[out$labels$attribute_id == attribute_id, , drop = FALSE]
  matched <- match(names(counts), label_rows$level_id)
  data.frame(
    attribute_id = attribute_id,
    attribute = label_rows$attribute[matched],
    level_id = names(counts),
    level = label_rows$level[matched],
    count = as.integer(counts),
    percent = as.numeric(counts) / nrow(primary_data) * 100,
    stringsAsFactors = FALSE
  )
})
level_frequencies <- do.call(rbind, frequency_rows)
level_frequencies$attribute <- factor(
  level_frequencies$attribute,
  levels = unique(out$labels$attribute[match(attribute_ids, out$labels$attribute_id)])
)
level_frequencies$level <- factor(level_frequencies$level, levels = rev(unique(level_frequencies$level)))

attribute_summary <- do.call(rbind, lapply(attribute_ids, function(attribute_id) {
  rows <- level_frequencies[level_frequencies$attribute_id == attribute_id, , drop = FALSE]
  data.frame(
    attribute = as.character(rows$attribute[1]),
    levels = nrow(rows),
    stringsAsFactors = FALSE
  )
}))

dir.create("figures", showWarnings = FALSE, recursive = TRUE)
figure_path <- file.path("figures", "level-frequencies.png")

p <- ggplot2::ggplot(
  level_frequencies,
  ggplot2::aes(x = level, y = count, fill = attribute)
) +
  ggplot2::geom_col(width = 0.72, show.legend = FALSE) +
  ggplot2::coord_flip() +
  ggplot2::facet_wrap(~ attribute, scales = "free_y", ncol = 2) +
  ggplot2::scale_fill_manual(values = rep(okabe_ito, length.out = length(attribute_ids))) +
  ggplot2::labs(x = NULL, y = "Profile appearances") +
  plot_theme
ggplot2::ggsave(figure_path, p, width = 11, height = 10, units = "in", dpi = 320)

format_percent <- function(x) sprintf("%.1f%%", x)
summary_lines <- c(
  "# Conjoint design summary",
  "",
  "## Level-frequency figure",
  "![Level frequencies by attribute](figures/level-frequencies.png)",
  "*Caption: Each bar is the number of primary-design profile appearances assigned to a level; panels use their own count scales to keep level labels legible.*",
  "",
  "## Primary design",
  "",
  sprintf("The primary design contains %d respondents, %.0f tasks per respondent, and %.0f profiles per task (%d profile appearances).", respondents, tasks_per_respondent, profiles_per_task, nrow(primary_data)),
  "The eight primary tasks (choice1–choice8) define all summaries. The `choice1_repeated_flipped` outcome is retained by `reshape_projoint()` as `selected_repeated` and is excluded so it does not add a task or duplicate profiles.",
  "",
  "## Attributes and level counts",
  "",
  "| Attribute | Levels |",
  "|---|---:|"
)
summary_lines <- c(summary_lines, sprintf("| %s | %d |", attribute_summary$attribute, attribute_summary$levels))
summary_lines <- c(summary_lines,
  "",
  "## Level frequencies",
  "",
  "Counts are profile appearances, not respondent counts: each attribute is observed once for every primary-design profile (denominator = 6,400 within attribute). Percentages are therefore within-attribute profile shares.",
  "",
  "| Attribute | Level | Profile appearances | Share within attribute |",
  "|---|---|---:|---:|"
)
for (i in seq_len(nrow(level_frequencies))) {
  row <- level_frequencies[i, ]
  summary_lines <- c(summary_lines, sprintf(
    "| %s | %s | %d | %s |",
    as.character(row$attribute), as.character(row$level), row$count, format_percent(row$percent)
  ))
}
writeLines(summary_lines, "summary.md", useBytes = TRUE)

message(sprintf(
  "Created %s and summary.md: %d respondents, %.0f tasks/respondent, %.0f profiles/task, %d profile appearances.",
  figure_path, respondents, tasks_per_respondent, profiles_per_task, nrow(primary_data)
))
