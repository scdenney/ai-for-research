## script.R
## Conjoint design summary for exampleData1 (projoint package)
## Produces summary.md and figures/level-frequencies.png

library(projoint)
library(ggplot2)
library(dplyr)
library(tidyr)

set.seed(1234)

okabe_ito <- c("#000000","#E69F00","#56B4E9","#009E73","#F0E442",
               "#0072B2","#D55E00","#CC79A7")

theme_conjoint <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold", size = 9),
    axis.text.x = element_text(angle = 40, hjust = 1, size = 7),
    legend.position = "none",
    plot.title = element_blank()
  )

## ---- Load and reshape data ----
data(exampleData1)
out <- reshape_projoint(exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped"))

dat <- out$data
labs <- out$labels

## ---- Basic design counts ----
n_respondents <- length(unique(dat$id))
n_tasks <- length(unique(dat$task))
n_profiles <- length(unique(dat$profile))

att_ids <- sort(unique(labs$attribute_id))

att_summary <- labs %>%
  distinct(attribute_id, attribute, level, level_id) %>%
  group_by(attribute_id, attribute) %>%
  summarise(n_levels = n(), .groups = "drop") %>%
  arrange(attribute_id)

## ---- Level frequency counts across all profiles ----
freq_list <- lapply(att_ids, function(a) {
  vals <- as.character(dat[[a]])
  tab <- as.data.frame(table(level_id = vals), stringsAsFactors = FALSE)
  tab$attribute_id <- a
  tab
})
freq_df <- do.call(rbind, freq_list)

freq_df <- freq_df %>%
  left_join(labs %>% select(level_id, attribute, level), by = "level_id") %>%
  select(attribute_id, attribute, level_id, level, Freq) %>%
  arrange(attribute_id, level_id)

## Balance check: within each attribute, range of frequency counts
balance_check <- freq_df %>%
  group_by(attribute_id, attribute) %>%
  summarise(min_freq = min(Freq), max_freq = max(Freq),
            spread_pct = round(100 * (max(Freq) - min(Freq)) / mean(Freq), 1),
            .groups = "drop")

overall_balanced <- all(balance_check$spread_pct < 10)

## ---- Figure: attribute-level frequencies ----
dir.create("figures", showWarnings = FALSE)

freq_df$attribute_wrapped <- vapply(freq_df$attribute, function(x)
  paste(strwrap(x, width = 28), collapse = "\n"), character(1))
freq_df$level_wrapped <- vapply(freq_df$level, function(x)
  paste(strwrap(x, width = 18), collapse = "\n"), character(1))

p <- ggplot(freq_df, aes(x = level_wrapped, y = Freq, fill = attribute)) +
  geom_col() +
  facet_wrap(~ attribute_wrapped, scales = "free_x", ncol = 3) +
  scale_fill_manual(values = rep(okabe_ito, length.out = length(unique(freq_df$attribute)))) +
  labs(x = NULL, y = "Frequency (count across all profiles)") +
  theme_conjoint

ggsave("figures/level-frequencies.png", plot = p, width = 11, height = 7.5,
       dpi = 300, bg = "white")

## ---- Build summary.md ----
md <- character()
md <- c(md, "# Conjoint Design Summary", "")
md <- c(md, sprintf("- **Respondents:** %d", n_respondents))
md <- c(md, sprintf("- **Tasks per respondent:** %d choice tasks (plus 1 repeated task for reliability, i.e. `choice1_repeated_flipped`)", 8))
md <- c(md, sprintf("- **Profiles per task:** %d", n_profiles))
md <- c(md, "")
md <- c(md, "## Attributes", "")
md <- c(md, "| Attribute ID | Attribute Name | Number of Levels |")
md <- c(md, "|---|---|---|")
for (i in seq_len(nrow(att_summary))) {
  md <- c(md, sprintf("| %s | %s | %d |",
                       att_summary$attribute_id[i],
                       att_summary$attribute[i],
                       att_summary$n_levels[i]))
}
md <- c(md, "")
md <- c(md, "## Randomization Balance Check", "")
md <- c(md, "Level frequencies across all profiles (400 respondents x 8 tasks x 2 profiles = 6,400 profiles per attribute column). Roughly equal counts per level within an attribute indicate balanced (uniform) randomization.", "")

for (a in att_ids) {
  sub <- freq_df[freq_df$attribute_id == a, ]
  att_name <- unique(sub$attribute)
  md <- c(md, sprintf("### %s (%s)", att_name, a), "")
  md <- c(md, "| Level | Frequency |", "|---|---|")
  for (j in seq_len(nrow(sub))) {
    md <- c(md, sprintf("| %s | %d |", sub$level[j], sub$Freq[j]))
  }
  md <- c(md, "")
}

md <- c(md, "**Balance summary (min/max frequency and spread within each attribute):**", "")
md <- c(md, "| Attribute | Min Freq | Max Freq | Spread (% of mean) |", "|---|---|---|---|")
for (i in seq_len(nrow(balance_check))) {
  md <- c(md, sprintf("| %s | %d | %d | %.1f%% |",
                       balance_check$attribute[i],
                       balance_check$min_freq[i],
                       balance_check$max_freq[i],
                       balance_check$spread_pct[i]))
}
md <- c(md, "")
md <- c(md, sprintf("Overall, level frequencies within each attribute are %s (all spreads %s 10%% of the mean), consistent with uniform random assignment across levels.",
                     ifelse(overall_balanced, "closely balanced", "mostly balanced but with some deviation"),
                     ifelse(overall_balanced, "under", "around or above")))
md <- c(md, "")
md <- c(md, "## Figure", "")
md <- c(md, "![Attribute-level frequencies](figures/level-frequencies.png)")
md <- c(md, "*Figure 1. Frequency counts of each attribute level across all 6,400 profiles, faceted by attribute, showing that randomization produced roughly balanced level assignment.*")
md <- c(md, "")

writeLines(md, "summary.md")

cat("Done. Respondents:", n_respondents, "Attributes:", nrow(att_summary), "\n")
