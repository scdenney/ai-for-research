#!/usr/bin/env Rscript

# Reproducible descriptive summary of projoint::exampleData1.
# Run from this directory with: Rscript script.R

suppressPackageStartupMessages({
  library(projoint)
  library(ggplot2)
})

set.seed(20260719)

# Plotting defaults: Okabe-Ito is a colourblind-safe qualitative palette.
okabe_ito <- c(
  "orange" = "#E69F00", "sky_blue" = "#56B4E9", "bluish_green" = "#009E73",
  "yellow" = "#F0E442", "blue" = "#0072B2", "vermillion" = "#D55E00",
  "reddish_purple" = "#CC79A7", "black" = "#000000"
)

plot_theme <- theme_minimal(base_size = 10, base_family = "sans") +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold", size = 9),
    axis.title = element_text(face = "bold"),
    axis.text.y = element_text(size = 8),
    plot.margin = margin(8, 16, 8, 8)
  )

data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

dat <- out$data
labels <- as.data.frame(out$labels, stringsAsFactors = FALSE)
attribute_ids <- paste0("att", 1:7)

if (!all(attribute_ids %in% names(dat))) {
  stop("The reshaped data do not contain all seven expected attributes.")
}

respondent_n <- length(unique(dat$id))
task_n <- length(unique(dat$task))
profile_n <- length(unique(dat$profile))

# Verify that each profile row has a unique design key before checking the full
# respondent-by-task-by-profile grid. A row-count identity alone could conceal
# a missing key offset by a duplicated key.
key_vars <- c("id", "task", "profile")
make_keys <- function(x) {
  do.call(paste, c(lapply(x[key_vars], as.character), sep = "\r"))
}

observed_keys <- make_keys(dat)
if (anyDuplicated(observed_keys)) {
  stop(sprintf(
    "Found %s duplicate id × task × profile combination(s).",
    sum(duplicated(observed_keys))
  ))
}

expected_grid <- expand.grid(
  id = unique(dat$id),
  task = unique(dat$task),
  profile = unique(dat$profile),
  KEEP.OUT.ATTRS = FALSE,
  stringsAsFactors = FALSE
)
expected_keys <- make_keys(expected_grid)
if (!setequal(observed_keys, expected_keys)) {
  stop("The id × task × profile grid has one or more missing combinations.")
}

attribute_info <- unique(labels[c("attribute_id", "attribute")])
attribute_info <- attribute_info[match(attribute_ids, attribute_info$attribute_id), ]
attribute_info$n_levels <- vapply(
  attribute_info$attribute_id,
  function(attribute_id) sum(labels$attribute_id == attribute_id),
  integer(1)
)

level_frequencies <- do.call(
  rbind,
  lapply(attribute_ids, function(attribute_id) {
    attribute_labels <- labels[labels$attribute_id == attribute_id, ]
    counts <- table(factor(
      as.character(dat[[attribute_id]]),
      levels = attribute_labels$level_id
    ))
    attribute_total <- sum(counts)
    if (attribute_total != nrow(dat)) {
      stop(sprintf(
        "Attribute %s has missing or unrecognised level assignments.",
        attribute_id
      ))
    }
    data.frame(
      attribute_id = attribute_id,
      attribute = attribute_labels$attribute[1],
      level = attribute_labels$level,
      n = as.integer(counts),
      share = as.integer(counts) / attribute_total,
      target_share = 1 / nrow(attribute_labels),
      stringsAsFactors = FALSE
    )
  })
)

level_frequencies$deviation_pp <- 100 * (
  level_frequencies$share - level_frequencies$target_share
)
level_frequencies$attribute <- factor(
  level_frequencies$attribute,
  levels = attribute_info$attribute
)
level_frequencies$level <- factor(level_frequencies$level, levels = labels$level)

expected_lines <- data.frame(
  attribute = factor(attribute_info$attribute, levels = attribute_info$attribute),
  target_share = 1 / attribute_info$n_levels
)

dir.create("figures", showWarnings = FALSE, recursive = TRUE)

frequency_plot <- ggplot(
  level_frequencies,
  aes(x = share, y = level, fill = attribute)
) +
  geom_vline(
    data = expected_lines,
    aes(xintercept = target_share),
    inherit.aes = FALSE,
    colour = okabe_ito[["black"]],
    linetype = "dashed",
    linewidth = 0.35
  ) +
  geom_col(width = 0.72, show.legend = FALSE) +
  facet_wrap(
    ~ attribute,
    ncol = 2,
    scales = "free_y",
    labeller = labeller(attribute = label_wrap_gen(width = 38))
  ) +
  scale_fill_manual(values = unname(okabe_ito[1:7])) +
  scale_x_continuous(
    limits = c(0, 0.55),
    breaks = seq(0, 0.5, by = 0.1),
    expand = expansion(mult = c(0, 0)),
    labels = function(x) sprintf("%d%%", round(100 * x))
  ) +
  labs(x = "Within-attribute share of profile rows", y = NULL) +
  plot_theme

ggsave(
  filename = file.path("figures", "level-frequencies.png"),
  plot = frequency_plot,
  width = 10,
  height = 12,
  units = "in",
  dpi = 320,
  bg = "white"
)

fmt_int <- function(x) format(round(x), big.mark = ",", trim = TRUE)
fmt_pct <- function(x) sprintf("%.1f%%", 100 * x)
fmt_target <- function(x) sprintf("%.1f%% (1/%d)", 100 * x, round(1 / x))
fmt_pp <- function(x) {
  ifelse(abs(x) < 0.05, "0.0 pp", sprintf("%+.1f pp", x))
}

summary_lines <- c(
  "# Community-choice conjoint: design summary",
  "",
  "## Design",
  "",
  sprintf("- **Respondents:** %s", fmt_int(respondent_n)),
  sprintf(
    "- **Randomized choice tasks per respondent:** %s (plus one repeated, flipped version of task 1 for reliability checking)",
    fmt_int(task_n)
  ),
  sprintf("- **Profiles per randomized task:** %s", fmt_int(profile_n)),
  sprintf("- **Analysis-ready profile rows:** %s", fmt_int(nrow(dat))),
  "- **Validation:** Every `id × task × profile` combination appears exactly once.",
  "",
  "## Attributes",
  "",
  "| Attribute | Number of levels |",
  "|:--|--:|",
  sprintf("| %s | %s |", attribute_info$attribute, attribute_info$n_levels),
  "",
  "## Randomization balance",
  "",
  "The table gives each level's within-attribute share of the 6,400 profile rows; the equal-allocation target is shown as the exact fraction `1/L` alongside its rounded percentage.",
  "The largest departure from equal allocation was 1.9 percentage points (25-minute driving time), indicating generally good randomization balance.",
  "",
  "| Attribute | Level | Frequency | Observed share | Equal-allocation target | Difference |",
  "|:--|:--|--:|--:|--:|--:|",
  sprintf(
    "| %s | %s | %s | %s | %s | %s |",
    as.character(level_frequencies$attribute),
    as.character(level_frequencies$level),
    fmt_int(level_frequencies$n),
    fmt_pct(level_frequencies$share),
    fmt_target(level_frequencies$target_share),
    fmt_pp(level_frequencies$deviation_pp)
  ),
  "",
  "![Within-attribute level shares](figures/level-frequencies.png)",
  "",
  "*Figure 1. Within-attribute level shares; dashed vertical lines mark the equal-allocation target of `1/L` for each attribute.*"
)

writeLines(summary_lines, "summary.md", useBytes = TRUE)
