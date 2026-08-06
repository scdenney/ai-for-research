# Reproducible mechanical description of projoint::exampleData1.
# Full Okabe-Ito palette and reusable plot theme.
okabe_ito <- c(black = "#000000", orange = "#E69F00",
  sky_blue = "#56B4E9", bluish_green = "#009E73", yellow = "#F0E442",
  blue = "#0072B2", vermillion = "#D55E00", reddish_purple = "#CC79A7")
plot_theme <- ggplot2::theme_minimal(base_size = 11) +
  ggplot2::theme(panel.grid.major.y = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    strip.text = ggplot2::element_text(face = "bold"),
    axis.text.y = ggplot2::element_text(size = 8), legend.position = "none")

set.seed(20260717)
suppressPackageStartupMessages(library(projoint))
data(exampleData1)
out <- reshape_projoint(exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped"))

# All reported values are derived from out$data and out$labels.
attribute_ids <- paste0("att", 1:7)
stopifnot(all(attribute_ids %in% names(out$data)), nrow(out$data) == 6400L)
labels <- do.call(rbind, lapply(attribute_ids, function(id)
  out$labels[out$labels$attribute_id == id, , drop = FALSE]))
labels <- as.data.frame(labels, stringsAsFactors = FALSE)

attribute_summary <- do.call(rbind, lapply(attribute_ids, function(id) {
  x <- labels[labels$attribute_id == id, , drop = FALSE]
  data.frame(attribute_id = id, attribute = x$attribute[1],
    levels = nrow(x), stringsAsFactors = FALSE)
}))
balance <- do.call(rbind, lapply(attribute_ids, function(id) {
  x <- labels[labels$attribute_id == id, , drop = FALSE]
  counts <- table(factor(as.character(out$data[[id]]), levels = x$level_id))
  data.frame(attribute_id = id, attribute = x$attribute, level = x$level,
    count = as.integer(counts), percent = as.integer(counts) / nrow(out$data) * 100,
    stringsAsFactors = FALSE)
}))
stopifnot(nrow(labels) == 24L, nrow(balance) == 24L)
totals <- aggregate(cbind(count, percent) ~ attribute_id, balance, sum)
stopifnot(all(totals$count == nrow(out$data)), all(abs(totals$percent - 100) < 1e-8))

dir.create("figures", showWarnings = FALSE, recursive = TRUE)
wrap_label <- function(x) paste(strwrap(x, width = 35), collapse = "\n")
balance$level_display <- vapply(balance$level, wrap_label, character(1))
balance$attribute <- factor(balance$attribute, levels = attribute_summary$attribute)
balance$level_display <- factor(balance$level_display, levels = rev(unique(balance$level_display)))
figure <- ggplot2::ggplot(balance,
  ggplot2::aes(x = percent, y = level_display, fill = attribute)) +
  ggplot2::geom_col(width = 0.72) +
  ggplot2::facet_wrap(~attribute, scales = "free_y", ncol = 2) +
  ggplot2::scale_fill_manual(values = setNames(
    unname(okabe_ito[c("blue", "orange", "bluish_green", "vermillion",
      "sky_blue", "reddish_purple", "yellow")]), attribute_summary$attribute)) +
  ggplot2::scale_x_continuous(labels = function(x) paste0(format(x, trim = TRUE), "%"),
    expand = ggplot2::expansion(mult = c(0, 0.05))) +
  ggplot2::labs(x = "Profile rows within attribute", y = NULL) + plot_theme
ggplot2::ggsave(file.path("figures", "level-frequencies.png"), figure,
  width = 11, height = 10, units = "in", dpi = 320, bg = "white")

format_table <- function(x, headers) {
  rows <- apply(x, 1, function(row) paste0("| ", paste(row, collapse = " | "), " |"))
  c(paste0("| ", paste(headers, collapse = " | "), " |"),
    paste0("|", paste(rep("---", length(headers)), collapse = "|"), "|"), rows)
}
attribute_table <- format_table(data.frame(
  "Attribute ID" = attribute_summary$attribute_id, Attribute = attribute_summary$attribute,
  "Level count" = attribute_summary$levels, check.names = FALSE),
  c("Attribute ID", "Attribute", "Level count"))
balance_table <- format_table(data.frame(
  "Attribute ID" = balance$attribute_id, Attribute = as.character(balance$attribute),
  Level = balance$level, Count = format(balance$count, big.mark = ",", trim = TRUE),
  "Within-attribute percent" = sprintf("%.1f%%", balance$percent), check.names = FALSE),
  c("Attribute ID", "Attribute", "Level", "Count", "Within-attribute percent"))

n_respondents <- length(unique(out$data$id))
n_primary_tasks <- length(unique(out$data$task))
n_profiles <- length(unique(out$data$profile))
summary_lines <- c(
  "# Design summary", "",
  sprintf("The reshaped analysis design contains **%s respondents**, **%s primary randomized tasks per respondent**, **%s profiles per task**, and **%s primary-task profile rows**.",
    format(n_respondents, big.mark = ","), n_primary_tasks, n_profiles, format(nrow(out$data), big.mark = ",")), "",
  "The repeated reliability outcome is attached to task 1 in selected_repeated and agree. It is a reliability check, not a ninth randomized profile task.", "",
  "## Attributes and levels", "", attribute_table, "",
  sprintf("The seven attributes, in att1 through att7 order, contain **%s levels** in total.", nrow(labels)), "",
  "## Randomization balance", "",
  "For every attribute, the counts below cover all 6,400 primary-task profile rows; within-attribute percentages therefore sum to 100.0% (apart from displayed rounding). The level frequencies are close to evenly distributed within each attribute, consistent with the intended randomization.", "",
  balance_table, "", "## Level frequencies", "",
  "![Within-attribute level frequencies](figures/level-frequencies.png)",
  "", "*Figure 1. Each bar shows a human-readable attribute level's share of the 6,400 primary-task profile rows, faceted by attribute.*", "")
writeLines(summary_lines, "summary.md", useBytes = TRUE)
