## script.R
## Design summary + randomization balance check for projoint::exampleData1
## Run: Rscript script.R

suppressPackageStartupMessages({
  library(projoint)
  library(ggplot2)
  library(dplyr)
  library(tidyr)
})

## ---- Plotting theme and palette (declared before any data loading) --------

theme_lab <- theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold", size = 9, margin = margin(b = 4)),
    axis.text.y = element_text(size = 8),
    legend.position = "none",
    plot.title.position = "plot",
    panel.spacing.x = unit(1.4, "lines")
  )

okabe_ito <- c(
  "#E69F00", "#56B4E9", "#009E73", "#F0E442",
  "#0072B2", "#D55E00", "#CC79A7", "#999999"
)

## ---- Reproducibility --------------------------------------------------

set.seed(20260717)

## ---- Load and reshape data ---------------------------------------------

data(exampleData1)
out <- reshape_projoint(exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped"))

dat <- out$data
labels <- out$labels

## ---- Design summary computations ----------------------------------------

n_respondents <- length(unique(dat$id))
tasks_per_respondent <- dat |>
  dplyr::distinct(id, task) |>
  dplyr::count(id, name = "n_tasks") |>
  dplyr::pull(n_tasks) |>
  unique()
profiles_per_task <- dat |>
  dplyr::count(id, task, name = "n_profiles") |>
  dplyr::pull(n_profiles) |>
  unique()

att_ids <- paste0("att", 1:7)

att_names <- sapply(att_ids, function(a) {
  unique(labels$attribute[labels$attribute_id == a])
})

att_nlevels <- sapply(att_ids, function(a) {
  sum(labels$attribute_id == a)
})

attribute_overview <- data.frame(
  attribute_id = att_ids,
  attribute_name = unname(att_names),
  n_levels = unname(att_nlevels),
  stringsAsFactors = FALSE
)

## Level frequency (count + proportion) per attribute, using human-readable
## attribute/level names. Each row of `dat` is one profile-task-respondent
## observation, so the total observation count per attribute equals nrow(dat).
level_freq_list <- lapply(att_ids, function(a) {
  col <- dat[[a]]
  tab <- as.data.frame(table(col), stringsAsFactors = FALSE)
  names(tab) <- c("level_id", "count")
  tab$attribute_id <- a
  tab$proportion <- tab$count / sum(tab$count)
  tab
})
level_freq <- dplyr::bind_rows(level_freq_list)

## Join in human-readable attribute and level names via labels' level_id
level_freq <- level_freq |>
  dplyr::left_join(labels, by = c("level_id" = "level_id",
                                   "attribute_id" = "attribute_id")) |>
  dplyr::select(attribute_id, attribute, level, count, proportion) |>
  dplyr::arrange(attribute_id, level)

## ---- Write summary.md -----------------------------------------------

md <- character(0)
md <- c(md, "# Conjoint Design Summary", "")
md <- c(md, sprintf("- **Respondents:** %d", n_respondents))
md <- c(md, sprintf("- **Tasks per respondent:** %s", paste(tasks_per_respondent, collapse = ", ")))
md <- c(md, sprintf("- **Profiles per task:** %s", paste(profiles_per_task, collapse = ", ")))
md <- c(md, sprintf("- **Total rows in reshaped data:** %d", nrow(dat)))
md <- c(md, "")

md <- c(md, "## Attributes", "")
md <- c(md, "| Attribute ID | Attribute Name | # Levels |")
md <- c(md, "|---|---|---|")
for (i in seq_len(nrow(attribute_overview))) {
  md <- c(md, sprintf("| %s | %s | %d |",
                       attribute_overview$attribute_id[i],
                       attribute_overview$attribute_name[i],
                       attribute_overview$n_levels[i]))
}
md <- c(md, "")

md <- c(md, "## Randomization Balance Check", "")
md <- c(md, sprintf("Level frequencies within each attribute across all profile-task-respondent observations (n = %d). In a well-randomized conjoint, proportions within an attribute should be roughly equal across its levels.", nrow(dat)), "")

for (a in att_ids) {
  sub <- level_freq[level_freq$attribute_id == a, ]
  attr_name <- unique(sub$attribute)
  md <- c(md, sprintf("### %s (%s)", attr_name, a), "")
  md <- c(md, "| Level | Count | Proportion |")
  md <- c(md, "|---|---|---|")
  for (j in seq_len(nrow(sub))) {
    md <- c(md, sprintf("| %s | %d | %.3f |", sub$level[j], sub$count[j], sub$proportion[j]))
  }
  md <- c(md, "")
}

md <- c(md, "## Figure", "")
md <- c(md, "![Attribute level frequencies](figures/level-frequencies.png)", "")
md <- c(md, "**Figure.** Observed frequency of each level within each of the 7 conjoint attributes, faceted by attribute; roughly equal bar lengths within a facet indicate balanced randomization.")

writeLines(md, "summary.md")

## ---- Figure: level-frequencies.png ---------------------------------------

dir.create("figures", showWarnings = FALSE)

plot_df <- level_freq |>
  dplyr::mutate(
    attribute = factor(attribute, levels = unique(attribute_overview$attribute_name)),
    level = factor(level)
  )

p <- ggplot(plot_df, aes(x = level, y = proportion, fill = attribute)) +
  geom_col() +
  facet_wrap(~ attribute, scales = "free_y", ncol = 2,
             labeller = labeller(attribute = label_wrap_gen(22))) +
  coord_flip() +
  scale_fill_manual(values = rep(okabe_ito, length.out = length(unique(plot_df$attribute)))) +
  labs(x = NULL, y = "Proportion of observations") +
  theme_lab

ggsave(filename = "figures/level-frequencies.png", plot = p,
       width = 11, height = 9.5, dpi = 320)
