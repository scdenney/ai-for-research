# Task T1: descriptive design summary for projoint::exampleData1
# This script writes summary.md and figures/level-frequencies.png.

set.seed(20260717)

library(projoint)
library(ggplot2)

# Plot settings: a restrained theme and the color-blind-safe Okabe-Ito palette.
theme_design <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.major.y = element_line(colour = "grey85", linewidth = 0.3),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold"),
    axis.title.y = element_text(margin = margin(r = 8)),
    plot.margin = margin(8, 12, 8, 8)
  )
okabe_ito <- c(
  orange = "#E69F00", sky_blue = "#56B4E9", bluish_green = "#009E73",
  yellow = "#F0E442", blue = "#0072B2", vermilion = "#D55E00",
  reddish_purple = "#CC79A7", black = "#000000"
)

data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

dat <- out$data
labels <- out$labels
attribute_ids <- paste0("att", 1:7)

# Recover display labels and count each randomized level in the long data.
level_lookup <- labels[, c("attribute_id", "attribute", "level_id", "level")]
names(level_lookup) <- c("attribute_id", "attribute", "level_id", "level")

frequency_rows <- lapply(attribute_ids, function(attribute_id) {
  lookup <- level_lookup[level_lookup$attribute_id == attribute_id, ]
  observed <- table(factor(as.character(dat[[attribute_id]]), levels = lookup$level_id))
  data.frame(
    attribute_id = attribute_id,
    attribute = lookup$attribute,
    level_id = lookup$level_id,
    level = lookup$level,
    n = as.integer(observed),
    stringsAsFactors = FALSE
  )
})
frequencies <- do.call(rbind, frequency_rows)
frequencies$percent <- 100 * frequencies$n / ave(frequencies$n, frequencies$attribute_id, FUN = sum)
frequencies$benchmark_percent <- 100 / ave(frequencies$n, frequencies$attribute_id, FUN = length)
frequencies$deviation_pp <- frequencies$percent - frequencies$benchmark_percent
frequencies$level <- factor(frequencies$level, levels = rev(unique(frequencies$level)))
frequencies$attribute <- factor(
  frequencies$attribute,
  levels = unique(level_lookup$attribute[match(attribute_ids, level_lookup$attribute_id)])
)

# One descriptive plot: observed frequencies of each randomized attribute level.
dir.create("figures", showWarnings = FALSE, recursive = TRUE)
frequency_plot <- ggplot(frequencies, aes(x = percent, y = level, fill = attribute)) +
  geom_col(width = 0.72, show.legend = FALSE) +
  geom_text(aes(label = sprintf("%.1f%%", percent)), hjust = -0.12, size = 3) +
  facet_wrap(~ attribute, scales = "free_y", ncol = 1) +
  scale_fill_manual(values = unname(rep(okabe_ito[c("blue", "bluish_green", "orange", "vermilion")], length.out = 7))) +
  scale_x_continuous("Profile-level frequency", limits = c(0, max(frequencies$percent) + 8),
                     breaks = seq(0, 50, 10), labels = function(x) paste0(x, "%")) +
  scale_y_discrete(NULL) +
  theme_design +
  theme(axis.text.y = element_text(size = 8))
ggsave("figures/level-frequencies.png", frequency_plot,
       width = 12, height = 16, units = "in", dpi = 320, bg = "white")

# Design counts and Markdown tables.  These are calculated within respondent,
# rather than from globally reused task/profile identifiers.
n_respondents <- length(unique(dat$id))
tasks_by_respondent <- table(dat$id, dat$task) > 0
primary_tasks_per_respondent <- rowSums(tasks_by_respondent)
profiles_per_respondent_task <- as.vector(table(interaction(dat$id, dat$task, drop = TRUE)))
stopifnot(length(unique(primary_tasks_per_respondent)) == 1L)
stopifnot(length(unique(profiles_per_respondent_task)) == 1L)
n_primary_tasks <- unname(primary_tasks_per_respondent[1])
n_reliability_tasks <- 1L
n_administered_tasks <- n_primary_tasks + n_reliability_tasks
n_profiles_per_task <- unique(profiles_per_respondent_task)
attribute_summary <- unique(level_lookup[, c("attribute_id", "attribute")])
attribute_summary$n_levels <- vapply(attribute_summary$attribute_id, function(id) {
  sum(level_lookup$attribute_id == id)
}, integer(1))
attribute_summary <- attribute_summary[match(attribute_ids, attribute_summary$attribute_id), ]

attribute_lines <- paste0("| `", attribute_summary$attribute_id, "` | ",
                          attribute_summary$attribute, " | ", attribute_summary$n_levels, " |")
balance_lines <- paste0("| ", frequencies$attribute, " | ", frequencies$level,
                        " | ", frequencies$n, " | ", sprintf("%.1f%%", frequencies$percent),
                        " | ", sprintf("%.1f%%", frequencies$benchmark_percent),
                        " | ", sprintf("%+.1f pp", frequencies$deviation_pp), " |")

summary_lines <- c(
  "# Community-choice conjoint: design summary", "",
  "## Design", "",
  "| Component | Value |", "|---|---:|",
  paste0("| Respondents | ", n_respondents, " |"),
  paste0("| Primary randomized choice tasks per respondent | ", n_primary_tasks, " |"),
  paste0("| Repeated reliability task per respondent | ", n_reliability_tasks, " |"),
  paste0("| Administered choice tasks per respondent | ", n_administered_tasks, " |"),
  paste0("| Profiles per respondent-task | ", n_profiles_per_task, " |"),
  paste0("| Profile rows used for balance checks | ", nrow(dat), " |"), "",
  "Each respondent receives 8 primary randomized tasks plus 1 repeated reliability task, for 9 administered choice tasks. The repeated task reuses task-1 profiles, so it adds no new randomized profiles and is excluded from the 6,400-profile balance checks.", "",
  "## Attributes and levels", "",
  "| ID | Attribute | Levels |", "|---|---|---:|", attribute_lines, "",
  "## Randomization balance check", "",
  "Each row below is a profile-level count (6,400 profiles total); within an attribute, percentages sum to 100%. The observed frequencies are close to the equal-allocation expectation for their respective numbers of levels.", "",
  "| Attribute | Level | Profiles | Observed | Equal-allocation benchmark | Deviation |", "|---|---|---:|---:|---:|---:|", balance_lines, "",
  "![Attribute-level frequencies](figures/level-frequencies.png)", "",
  "*Figure 1. Observed shares of the 6,400 randomized profiles assigned to each attribute level; percentages sum to 100 within each facet.*", ""
)
writeLines(summary_lines, "summary.md")
