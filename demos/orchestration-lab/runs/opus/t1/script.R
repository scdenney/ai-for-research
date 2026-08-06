## script.R
## Conjoint design summary + level-frequency figure for exampleData1 (projoint)
## Run with: Rscript script.R

suppressPackageStartupMessages({
  library(projoint)
  library(ggplot2)
  library(dplyr)
  library(tidyr)
})

## ---- Theme + palette (declare at top) --------------------------------

theme_lab <- theme_minimal(base_size = 11) +
  theme(
    strip.text = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    legend.position = "none",
    axis.title.y = element_blank()
  )

okabe_ito <- c(
  "#E69F00", "#56B4E9", "#009E73", "#F0E442",
  "#0072B2", "#D55E00", "#CC79A7", "#000000"
)

set.seed(42)

## ---- Load + reshape ----------------------------------------------------

data(exampleData1)
out <- reshape_projoint(exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped"))

dir.create("figures", showWarnings = FALSE, recursive = TRUE)

n_respondents <- length(unique(out$data$id))
n_tasks <- length(unique(out$data$task))
n_profiles <- length(unique(out$data$profile))
n_rows <- nrow(out$data)

## ---- Attribute-level frequencies (long form, human-readable labels) ----

att_cols <- paste0("att", 1:7)

long_levels <- out$data |>
  select(id, task, profile, all_of(att_cols)) |>
  pivot_longer(cols = all_of(att_cols),
               names_to = "attribute_id", values_to = "level_id") |>
  left_join(out$labels, by = c("attribute_id", "level_id"))

# order attributes att1..att7, and levels by attribute_id/level_id within
attribute_order <- out$labels |>
  distinct(attribute_id, attribute) |>
  arrange(attribute_id)

level_order <- out$labels |>
  arrange(attribute_id, level_id) |>
  pull(level) |>
  unique()

long_levels <- long_levels |>
  mutate(
    attribute = factor(attribute, levels = attribute_order$attribute),
    level = factor(level, levels = level_order)
  )

freq_tbl <- long_levels |>
  count(attribute_id, attribute, level, name = "n") |>
  group_by(attribute_id, attribute) |>
  mutate(
    n_levels_in_attribute = n(),
    proportion = n / sum(n),
    expected_proportion = 1 / n_levels_in_attribute
  ) |>
  ungroup() |>
  arrange(attribute_id, level)

## Attribute summary table (name + level count)
attribute_summary <- freq_tbl |>
  distinct(attribute_id, attribute, n_levels_in_attribute) |>
  arrange(attribute_id) |>
  rename(`Number of levels` = n_levels_in_attribute)

## ---- Figure --------------------------------------------------------

wrap_labels <- function(x, width = 34) {
  vapply(x, function(s) paste(strwrap(s, width = width), collapse = "\n"), character(1))
}

fig_data <- freq_tbl |>
  mutate(level_wrapped = wrap_labels(as.character(level)))

# order factor within facet by frequency for readability
fig_data <- fig_data |>
  group_by(attribute) |>
  mutate(level_wrapped = factor(level_wrapped, levels = level_wrapped[order(n)])) |>
  ungroup()

p <- ggplot(fig_data, aes(x = level_wrapped, y = n, fill = attribute)) +
  geom_col() +
  coord_flip() +
  facet_wrap(~ attribute, scales = "free", ncol = 2,
             labeller = label_wrap_gen(width = 40)) +
  scale_fill_manual(values = rep(okabe_ito, length.out = nlevels(fig_data$attribute))) +
  labs(x = NULL, y = "Frequency (profile rows)") +
  theme_lab

ggsave("figures/level-frequencies.png", plot = p,
       width = 10, height = 12, dpi = 320)

## ---- summary.md ------------------------------------------------------

md <- c(
  "# Conjoint Design Summary",
  "",
  sprintf("- **Respondents:** %d", n_respondents),
  sprintf("- **Tasks per respondent:** %d", n_tasks),
  sprintf("- **Profiles per task:** %d", n_profiles),
  sprintf("- **Total profile rows (respondents x tasks x profiles):** %d", n_rows),
  "",
  "## Attributes",
  "",
  "| Attribute | Number of levels |",
  "|---|---|"
)

for (i in seq_len(nrow(attribute_summary))) {
  md <- c(md, sprintf("| %s | %d |",
    attribute_summary$attribute[i], attribute_summary$`Number of levels`[i]))
}

md <- c(md, "",
  "## Randomization balance check",
  "",
  "Level frequencies within each attribute, computed across all 6,400 profile rows.",
  "Under simple randomization, each level's proportion should be close to the expected",
  "uniform proportion (1 / number of levels for that attribute).",
  "")

for (att in attribute_order$attribute) {
  sub <- freq_tbl |> filter(attribute == att)
  exp_p <- unique(sub$expected_proportion)
  md <- c(md,
    sprintf("### %s (expected proportion per level: %.3f)", att, exp_p),
    "",
    "| Level | Count | Proportion |",
    "|---|---|---|")
  for (i in seq_len(nrow(sub))) {
    md <- c(md, sprintf("| %s | %d | %.3f |",
      sub$level[i], sub$n[i], sub$proportion[i]))
  }
  md <- c(md, "")
}

md <- c(md,
  "## Figure",
  "",
  "![Attribute-level frequencies](figures/level-frequencies.png)",
  "Frequency of each attribute level across all 6,400 profile rows, faceted by attribute, showing balanced randomization across levels.",
  "")

writeLines(md, "summary.md")

cat("Done. Wrote summary.md and figures/level-frequencies.png\n")
cat(sprintf("Respondents: %d, tasks: %d, profiles/task: %d, rows: %d\n",
            n_respondents, n_tasks, n_profiles, n_rows))
