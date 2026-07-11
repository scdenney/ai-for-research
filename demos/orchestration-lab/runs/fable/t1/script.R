## script.R
## Design summary and randomization balance check for projoint::exampleData1
## Loads the built-in Qualtrics conjoint export, reshapes to long format,
## computes design summary quantities, checks level-frequency balance,
## and saves a figure of level frequencies by attribute.

set.seed(42)

suppressPackageStartupMessages({
  library(projoint)
  library(dplyr)
  library(ggplot2)
})

## ---- Theme and palette (declared up top) ----------------------------------
okabe_ito <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442",
                "#0072B2", "#D55E00", "#CC79A7", "#999999")

theme_report <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold"),
    legend.position = "none",
    plot.margin = margin(10, 15, 10, 10)
  )

## ---- Load and reshape data --------------------------------------------------
data(exampleData1)
out <- reshape_projoint(exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped"))

dat <- out$data
labels <- out$labels

## ---- Design summary quantities ---------------------------------------------
n_respondents <- length(unique(dat$id))
n_tasks_per_resp <- length(unique(dat$task))
n_profiles_per_task <- length(unique(dat$profile))

attribute_cols <- grep("^att[0-9]+$", names(dat), value = TRUE)
n_attributes <- length(attribute_cols)

cat("=== Design Summary ===\n")
cat("Respondents:", n_respondents, "\n")
cat("Tasks per respondent (main):", n_tasks_per_resp,
    "(plus 1 repeated task for reliability)\n")
cat("Profiles per task:", n_profiles_per_task, "\n")
cat("Number of attributes:", n_attributes, "\n\n")

attr_summary <- labels %>%
  group_by(attribute_id, attribute) %>%
  summarise(n_levels = n(),
            levels = paste(level, collapse = "; "),
            .groups = "drop") %>%
  arrange(attribute_id)

cat("=== Attributes and Levels ===\n")
print(attr_summary, width = Inf)
cat("\n")

## ---- Randomization balance check --------------------------------------------
## Stack all attribute columns into long id/level form for frequency counts.
long_levels <- lapply(attribute_cols, function(a) {
  data.frame(attribute_id = a, level_id = as.character(dat[[a]]),
             stringsAsFactors = FALSE)
}) %>% bind_rows()

balance <- long_levels %>%
  count(attribute_id, level_id, name = "n") %>%
  group_by(attribute_id) %>%
  mutate(pct = 100 * n / sum(n)) %>%
  ungroup() %>%
  left_join(labels, by = c("attribute_id", "level_id")) %>%
  select(attribute, level, n, pct) %>%
  arrange(attribute, level)

cat("=== Balance Check: Level Frequencies ===\n")
print(as.data.frame(balance), digits = 4)
cat("\n")

## Quick uniformity read: range of pct within each attribute
balance_range <- balance %>%
  group_by(attribute) %>%
  summarise(min_pct = min(pct), max_pct = max(pct), spread = max(pct) - min(pct),
            .groups = "drop")
cat("=== Balance Range by Attribute (max pct - min pct) ===\n")
print(as.data.frame(balance_range), digits = 4)
cat("\n")

## ---- Figure: level frequencies by attribute ---------------------------------
dir.create("figures", showWarnings = FALSE)

plot_dat <- balance %>%
  left_join(attr_summary %>% select(attribute), by = "attribute") %>%
  distinct()

fig <- ggplot(plot_dat, aes(x = reorder(level, pct), y = pct, fill = attribute)) +
  geom_col() +
  coord_flip() +
  facet_wrap(~ attribute, scales = "free_y", ncol = 2,
             labeller = label_wrap_gen(width = 32)) +
  scale_fill_manual(values = rep(okabe_ito, length.out = n_attributes)) +
  labs(x = NULL, y = "Share of profile-attribute assignments (%)") +
  theme_report

ggsave(filename = "figures/level-frequencies.png", plot = fig,
       width = 10, height = 9, dpi = 300)

cat("Figure saved to figures/level-frequencies.png\n")
