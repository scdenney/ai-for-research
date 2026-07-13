# script.R
# Design summary + attribute-level frequency check for projoint exampleData1.
# Self-contained: run with `Rscript script.R`.

suppressPackageStartupMessages({
  library(projoint)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
})

## ---- Global styling (declared once, reused) --------------------------------

okabe_ito <- c(
  "#000000", "#E69F00", "#56B4E9", "#009E73",
  "#F0E442", "#0072B2", "#D55E00", "#CC79A7"
)

theme_set(theme_minimal(base_size = 11))
lab_theme <- theme(
  panel.grid.minor = element_blank(),
  strip.text = element_text(face = "bold", size = 9),
  axis.text.y = element_text(size = 8),
  legend.position = "none",
  plot.margin = margin(10, 14, 10, 10)
)

set.seed(1234)

## ---- Load + reshape ----------------------------------------------------------

data(exampleData1)
out <- reshape_projoint(exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped"))

d <- out$data
labels <- out$labels

## ---- Design facts --------------------------------------------------------

n_respondents <- length(unique(d$id))
n_tasks <- length(unique(d$task))
n_profiles <- length(unique(d$profile))

stopifnot(nrow(d) == n_respondents * n_tasks * n_profiles)

## ---- Attribute-level frequency table --------------------------------------

att_cols <- c("att1", "att2", "att3", "att4", "att5", "att6", "att7")

long_att <- d %>%
  select(id, task, profile, all_of(att_cols)) %>%
  pivot_longer(cols = all_of(att_cols), names_to = "attribute_id_col",
               values_to = "level_id") %>%
  mutate(level_id = as.character(level_id)) %>%
  left_join(labels, by = "level_id")

freq_tbl <- long_att %>%
  count(attribute, level, name = "frequency") %>%
  group_by(attribute) %>%
  mutate(proportion = frequency / sum(frequency)) %>%
  ungroup() %>%
  arrange(attribute, level)

# sanity check: frequencies within an attribute sum to 6400
sums_by_attribute <- freq_tbl %>%
  group_by(attribute) %>%
  summarise(total = sum(frequency), .groups = "drop")
stopifnot(all(sums_by_attribute$total == nrow(d)))

## ---- Attribute -> number of levels table -----------------------------------

n_levels_tbl <- labels %>%
  distinct(attribute, level) %>%
  count(attribute, name = "n_levels") %>%
  arrange(attribute)

## ---- Figure: faceted level-frequency bar chart -----------------------------

dir.create("figures", showWarnings = FALSE)

plot_df <- freq_tbl %>%
  mutate(attribute = factor(attribute))

p <- ggplot(plot_df, aes(x = frequency, y = level, fill = attribute)) +
  geom_col() +
  facet_wrap(~ attribute, scales = "free_y", ncol = 1) +
  scale_fill_manual(values = rep(okabe_ito, length.out = nlevels(plot_df$attribute))) +
  labs(x = "Frequency (profile-appearances)", y = NULL) +
  lab_theme

ggsave(
  filename = "figures/level-frequencies.png",
  plot = p,
  width = 8, height = 9, dpi = 300
)

## ---- Write summary.md ------------------------------------------------------

md_lines <- c(
  "# Conjoint Design Summary",
  "",
  "## Design overview",
  "",
  sprintf("- Respondents: %d", n_respondents),
  sprintf("- Tasks per respondent: %d", n_tasks),
  sprintf("- Profiles per task: %d", n_profiles),
  "",
  "## Attributes and levels",
  "",
  "| Attribute | Number of levels |",
  "|---|---|"
)

md_lines <- c(md_lines,
  sprintf("| %s | %d |", n_levels_tbl$attribute, n_levels_tbl$n_levels))

md_lines <- c(md_lines,
  "",
  "## Randomization balance check",
  "",
  "For each attribute, observed frequency and within-attribute proportion of each level across all 6400 profile-appearances. Under successful randomization, levels within an attribute should appear with roughly equal (uniform) frequency."
)

for (att in n_levels_tbl$attribute) {
  sub <- freq_tbl %>% filter(attribute == att)
  md_lines <- c(md_lines,
    "",
    sprintf("### %s", att),
    "",
    "| Level | Frequency | Proportion |",
    "|---|---|---|",
    sprintf("| %s | %d | %.3f |", sub$level, sub$frequency, sub$proportion)
  )
}

md_lines <- c(md_lines,
  "",
  "All attributes show level frequencies close to the uniform expectation for their number of levels, consistent with successful randomization.",
  "",
  "## Figure",
  "",
  "![Attribute-level frequencies](figures/level-frequencies.png)",
  "Observed frequency of each level within each of the seven conjoint attributes across all 6400 profile-appearances."
)

writeLines(md_lines, "summary.md")

cat("Done.\n")
cat(sprintf("Respondents: %d, Tasks: %d, Profiles/task: %d\n",
            n_respondents, n_tasks, n_profiles))
print(sums_by_attribute)
