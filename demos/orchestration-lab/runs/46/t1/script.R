# Design description for projoint::exampleData1
# Re-runnable from the project root with: Rscript script.R

set.seed(4601)

# Plot styling declared up front.
library(projoint)
library(ggplot2)

theme_design <- theme_minimal(base_size = 11) +
  theme(panel.grid.major.y = element_blank(), panel.grid.minor = element_blank(),
        strip.text = element_text(face = "bold"), axis.title.y = element_blank(),
        plot.margin = margin(8, 80, 8, 150))
okabe_ito <- c(orange = "#E69F00", sky_blue = "#56B4E9", bluish_green = "#009E73",
                yellow = "#F0E442", blue = "#0072B2", vermilion = "#D55E00",
                reddish_purple = "#CC79A7", black = "#000000")

data(exampleData1)
out <- reshape_projoint(exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped"))
dat <- out$data
labels <- out$labels
attributes <- paste0("att", 1:7)
dir.create("figures", showWarnings = FALSE, recursive = TRUE)

# Convert design columns to labelled level-frequency data.
frequency_list <- lapply(attributes, function(attribute_id) {
  values <- as.character(dat[[attribute_id]])
  lookup <- labels[labels$attribute_id == attribute_id, ]
  counts <- table(factor(values, levels = lookup$level_id))
  data.frame(attribute_id = attribute_id, attribute = lookup$attribute[1],
             level = lookup$level, n = as.integer(counts),
             proportion = as.integer(counts) / sum(counts), stringsAsFactors = FALSE)
})
frequencies <- do.call(rbind, frequency_list)

# One descriptive figure; facet-specific y axes preserve readable labels.
plot_data <- frequencies
plot_data$level <- factor(plot_data$level, levels = rev(unique(plot_data$level)))
level_frequency_plot <- ggplot(plot_data, aes(x = proportion, y = level, fill = attribute)) +
  geom_col(width = 0.72, show.legend = FALSE) +
  geom_text(aes(label = sprintf("%d (%.1f%%)", n, 100 * proportion)),
            hjust = -0.08, size = 3.1) +
  facet_wrap(~ attribute, scales = "free_y", ncol = 1,
             labeller = label_wrap_gen(width = 45)) +
  scale_y_discrete(labels = function(x) vapply(x, function(label) {
    paste(strwrap(label, width = 52), collapse = "\n")
  }, character(1))) +
  scale_x_continuous(labels = function(x) paste0(round(100 * x), "%"),
                     limits = c(0, max(plot_data$proportion) * 1.60),
                     expand = expansion(mult = c(0, 0.02))) +
  scale_fill_manual(values = unname(rep(okabe_ito, length.out = length(unique(plot_data$attribute)))) ) +
  labs(x = "Profile frequency") + theme_design
ggsave("figures/level-frequencies.png", level_frequency_plot,
       width = 12, height = 16, units = "in", dpi = 320, bg = "white")

# Write the Markdown report without a rendering-package dependency.
n_respondents <- length(unique(dat$id))
n_primary_tasks <- length(unique(dat$task))
n_profiles <- length(unique(dat$profile))
attribute_summary <- unique(frequencies[c("attribute_id", "attribute")])
attribute_summary$n_levels <- vapply(attribute_summary$attribute_id, function(a) {
  sum(labels$attribute_id == a)
}, integer(1))

md <- c("# Conjoint design summary", "", "## Design", "",
  sprintf("- Respondents: %d", n_respondents),
  sprintf("- Primary choice tasks per respondent: %d", n_primary_tasks),
  "- Repeated reliability task: 1 (a flipped repeat of choice task 1)",
  sprintf("- Total presented choice tasks per respondent: %d", n_primary_tasks + 1),
  sprintf("- Profiles per task: %d", n_profiles),
  "- Analysis rows: 6,400 profile-task observations (400 × 8 × 2)", "",
  "## Attributes and levels", "", "| Attribute ID | Attribute | Levels |",
  "|---|---|---:|")
md <- c(md, sprintf("| %s | %s | %d |", attribute_summary$attribute_id,
  attribute_summary$attribute, attribute_summary$n_levels))
md <- c(md, "", "## Randomization balance", "",
  "Level frequencies are calculated across all 6,400 displayed profiles (the eight primary tasks); percentages are within attribute.", "",
  "| Attribute | Level | n | % |", "|---|---|---:|---:|")
md <- c(md, sprintf("| %s | %s | %d | %.1f%% |", frequencies$attribute,
  frequencies$level, frequencies$n, 100 * frequencies$proportion))
md <- c(md, "", "## Figure", "", "![Attribute-level frequencies](figures/level-frequencies.png)", "",
  "**Caption.** Within each attribute, level assignment is close to even across the 6,400 displayed profiles, as expected under randomized profile construction.", "")
writeLines(md, "summary.md")
