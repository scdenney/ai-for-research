#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(projoint)
  library(ggplot2)
  library(scales)
})

# Shared plotting declarations -------------------------------------------------
okabe_ito <- c(
  orange = "#E69F00",
  sky_blue = "#56B4E9",
  bluish_green = "#009E73",
  yellow = "#F0E442",
  blue = "#0072B2",
  vermillion = "#D55E00",
  reddish_purple = "#CC79A7",
  black = "#000000"
)

plot_theme <- theme_minimal(base_size = 11, base_family = "sans") +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold", hjust = 0),
    axis.text.y = element_text(size = 8.5),
    axis.title = element_text(size = 10),
    plot.margin = margin(8, 14, 8, 8),
    legend.position = "none"
  )

set.seed(4601)

# Load and reshape -------------------------------------------------------------
data(exampleData1, package = "projoint")
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

design_data <- as.data.frame(out$data)
design_labels <- as.data.frame(out$labels)
attribute_ids <- unique(design_labels$attribute_id)
attribute_names <- vapply(
  attribute_ids,
  function(id) unique(design_labels$attribute[design_labels$attribute_id == id]),
  character(1)
)

# Deterministic design checks --------------------------------------------------
n_respondents <- length(unique(design_data$id))
respondent_task_counts <- vapply(
  split(design_data$task, design_data$id),
  function(x) length(unique(x)),
  integer(1)
)
respondent_task_profile_counts <- vapply(
  split(design_data$profile, interaction(design_data$id, design_data$task, drop = TRUE)),
  function(x) length(unique(x)),
  integer(1)
)
respondent_has_full_task_grid <- vapply(
  split(design_data$task, design_data$id),
  function(x) identical(sort(unique(as.integer(x))), seq_len(8L)),
  logical(1)
)
task_has_full_profile_grid <- vapply(
  split(design_data$profile, interaction(design_data$id, design_data$task, drop = TRUE)),
  function(x) identical(sort(unique(as.integer(x))), seq_len(2L)),
  logical(1)
)
main_selection_sums <- vapply(
  split(design_data$selected, interaction(design_data$id, design_data$task, drop = TRUE)),
  sum,
  numeric(1)
)
task_one_rows <- design_data$task == 1
repeated_selection_sums <- vapply(
  split(
    design_data$selected_repeated[task_one_rows],
    design_data$id[task_one_rows]
  ),
  sum,
  numeric(1)
)
n_main_tasks <- unique(respondent_task_counts)
n_profiles <- unique(respondent_task_profile_counts)
n_repeated_tasks <- 1L
n_choice_screens <- n_main_tasks + n_repeated_tasks

stopifnot(
  n_respondents == 400L,
  length(n_main_tasks) == 1L,
  n_main_tasks == 8L,
  length(n_profiles) == 1L,
  n_profiles == 2L,
  nrow(design_data) == n_respondents * n_main_tasks * n_profiles,
  !anyDuplicated(design_data[c("id", "task", "profile")]),
  all(respondent_has_full_task_grid),
  all(task_has_full_profile_grid),
  all(design_data$selected %in% c(0, 1)),
  all(main_selection_sums == 1),
  length(attribute_ids) == 7L,
  nrow(design_labels) == 24L,
  !anyDuplicated(design_labels$level_id),
  all(attribute_ids %in% names(design_data)),
  all(!is.na(design_data$selected_repeated[design_data$task == 1])),
  all(is.na(design_data$selected_repeated[design_data$task != 1])),
  all(repeated_selection_sums == 1)
)

# Attribute and balance summaries --------------------------------------------
attribute_summary <- do.call(
  rbind,
  lapply(attribute_ids, function(id) {
    rows <- design_labels$attribute_id == id
    data.frame(
      attribute_id = id,
      attribute = unique(design_labels$attribute[rows]),
      level_count = sum(rows),
      stringsAsFactors = FALSE
    )
  })
)
row.names(attribute_summary) <- NULL

level_frequencies <- do.call(
  rbind,
  lapply(attribute_ids, function(id) {
    labels_for_attribute <- design_labels[
      design_labels$attribute_id == id,
      c("attribute", "level", "attribute_id", "level_id")
    ]
    observed_ids <- as.character(design_data[[id]])
    matched_ids <- match(observed_ids, labels_for_attribute$level_id)
    stopifnot(!anyNA(matched_ids))
    counts <- tabulate(matched_ids, nbins = nrow(labels_for_attribute))

    transform(
      labels_for_attribute,
      count = counts,
      share = counts / sum(counts),
      expected_share = 1 / nrow(labels_for_attribute)
    )
  })
)
row.names(level_frequencies) <- NULL
level_frequencies$deviation_pp <- 100 * (
  level_frequencies$share - level_frequencies$expected_share
)

frequency_totals <- vapply(
  split(level_frequencies$count, level_frequencies$attribute_id),
  sum,
  integer(1)
)
stopifnot(
  all(frequency_totals == nrow(design_data)),
  all(abs(
    vapply(
      split(level_frequencies$share, level_frequencies$attribute_id),
      sum,
      numeric(1)
    ) - 1
  ) < 1e-12)
)

largest_deviation_row <- level_frequencies[
  which.max(abs(level_frequencies$deviation_pp)),
]

# Figure ----------------------------------------------------------------------
dir.create("figures", showWarnings = FALSE, recursive = TRUE)

level_frequencies$attribute <- factor(
  level_frequencies$attribute,
  levels = attribute_names
)
level_frequencies$level_key <- paste(
  level_frequencies$attribute_id,
  level_frequencies$level,
  sep = "::"
)
level_frequencies$level_key <- factor(
  level_frequencies$level_key,
  levels = rev(level_frequencies$level_key)
)

attribute_colors <- setNames(
  unname(okabe_ito[seq_along(attribute_names)]),
  attribute_names
)
reference_lines <- unique(
  level_frequencies[c("attribute", "expected_share")]
)

frequency_plot <- ggplot(
  level_frequencies,
  aes(x = share, y = level_key, fill = attribute)
) +
  geom_col(width = 0.68, color = "#4D4D4D", linewidth = 0.2) +
  geom_vline(
    data = reference_lines,
    aes(xintercept = expected_share),
    inherit.aes = FALSE,
    color = "#333333",
    linewidth = 0.5,
    linetype = "dashed"
  ) +
  facet_wrap(
    vars(attribute),
    ncol = 1,
    scales = "free_y",
    space = "free_y",
    strip.position = "top"
  ) +
  scale_x_continuous(
    labels = label_percent(accuracy = 1),
    breaks = seq(0, 0.5, by = 0.1),
    limits = c(0, 0.56),
    expand = expansion(mult = c(0, 0.01))
  ) +
  scale_y_discrete(labels = function(x) {
    raw_labels <- sub("^[^:]+::", "", x)
    vapply(
      raw_labels,
      function(label) paste(strwrap(label, width = 58), collapse = "\n"),
      character(1)
    )
  }) +
  scale_fill_manual(values = attribute_colors, guide = "none") +
  labs(
    x = "Share of profile rows within attribute (%)",
    y = NULL
  ) +
  plot_theme

ggsave(
  filename = "figures/level-frequencies.png",
  plot = frequency_plot,
  width = 8,
  height = 12,
  units = "in",
  dpi = 320,
  bg = "white"
)
stopifnot(file.exists("figures/level-frequencies.png"))

# Markdown --------------------------------------------------------------------
markdown_table <- function(data) {
  data[] <- lapply(data, as.character)
  data[] <- lapply(data, function(x) gsub("|", "\\\\|", x, fixed = TRUE))
  c(
    paste0("| ", paste(names(data), collapse = " | "), " |"),
    paste0("| ", paste(rep("---", ncol(data)), collapse = " | "), " |"),
    apply(data, 1, function(row) {
      paste0("| ", paste(row, collapse = " | "), " |")
    })
  )
}

attribute_table <- data.frame(
  `Attribute ID` = attribute_summary$attribute_id,
  Attribute = attribute_summary$attribute,
  Levels = attribute_summary$level_count,
  check.names = FALSE
)

balance_table <- data.frame(
  Attribute = as.character(level_frequencies$attribute),
  Level = level_frequencies$level,
  Count = format(level_frequencies$count, big.mark = ",", scientific = FALSE),
  `Observed share` = sprintf("%.1f%%", 100 * level_frequencies$share),
  `Equal share` = sprintf("%.1f%%", 100 * level_frequencies$expected_share),
  `Difference (pp)` = sprintf(
    "%+.1f",
    ifelse(abs(level_frequencies$deviation_pp) < 0.05, 0, level_frequencies$deviation_pp)
  ),
  check.names = FALSE
)

caption <- paste0(
  "*Figure 1 — Observed attribute-level shares across 6,400 profile rows from ",
  "400 respondents (eight main tasks and two profiles per task); dashed lines ",
  "mark the equal-allocation benchmark within each attribute, and the repeated ",
  "reliability screen is excluded.*"
)

summary_lines <- c(
  "# Conjoint Design Summary",
  "",
  "## Design",
  "",
  "| Quantity | Value |",
  "| --- | ---: |",
  sprintf("| Respondents | %s |", format(n_respondents, big.mark = ",")),
  sprintf("| Main randomized tasks per respondent | %d |", n_main_tasks),
  sprintf("| Repeated reliability tasks per respondent | %d |", n_repeated_tasks),
  sprintf("| Total choice screens per respondent | %d |", n_choice_screens),
  sprintf("| Profiles displayed per task | %d |", n_profiles),
  sprintf("| Main-task profile rows | %s |", format(nrow(design_data), big.mark = ",")),
  "",
  paste0(
    "The repeat re-presents task 1 with the profile sides flipped; ",
    "`reshape_projoint()` stores its response in the reliability fields for task 1, ",
    "so it is not an additional set of profile rows in `out$data`."
  ),
  "",
  "## Attributes",
  "",
  markdown_table(attribute_table),
  "",
  "## Randomization balance",
  "",
  paste0(
    "Each attribute has ", format(nrow(design_data), big.mark = ","),
    " observed profile-level assignments. As a descriptive uniform-marginal balance check, ",
    "observed level shares are compared with the attribute-specific equal-allocation ",
    "benchmark of `1 / K`, where `K` is that attribute's level count. ",
    "The largest absolute difference is ",
    sprintf("%.1f", abs(largest_deviation_row$deviation_pp)),
    " percentage points for ", largest_deviation_row$attribute,
    " — ", largest_deviation_row$level, "."
  ),
  "",
  markdown_table(balance_table),
  "",
  "## Figure",
  "",
  "![Faceted horizontal bars showing each attribute level's observed share and its equal-allocation benchmark.](figures/level-frequencies.png)",
  "",
  caption,
  ""
)

writeLines(summary_lines, "summary.md", useBytes = TRUE)
stopifnot(file.exists("summary.md"))
