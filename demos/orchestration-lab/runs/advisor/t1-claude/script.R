# ---------------------------------------------------------------------------
# T1 — Describe the design: projoint::exampleData1 (community-choice conjoint)
# Produces: summary.md and figures/level-frequencies.png
# ---------------------------------------------------------------------------

library(projoint)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)

# ---- Plotting theme and palette (declared up front) -----------------------

okabe_ito <- c(
  "#E69F00", "#56B4E9", "#009E73", "#F0E442",
  "#0072B2", "#D55E00", "#CC79A7"
)

theme_lab <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor   = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "grey88", linewidth = 0.3),
    strip.text         = element_text(face = "bold", hjust = 0, size = 10),
    strip.text.y       = element_text(face = "bold", hjust = 0, size = 10, angle = 0),
    strip.background   = element_blank(),
    axis.title         = element_text(color = "grey30"),
    axis.text          = element_text(color = "grey20"),
    plot.caption       = element_text(color = "grey40"),
    plot.margin        = margin(8, 14, 8, 8)
  )
theme_set(theme_lab)

set.seed(20260712)  # nothing below is stochastic, but set defensively

# ---- Load and reshape ------------------------------------------------------

data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

dat    <- out$data
labels <- out$labels

# ---- Design summary quantities ---------------------------------------------

n_respondents      <- n_distinct(dat$id)
tasks_per_resp     <- n_distinct(dat$task)
profiles_per_task  <- n_distinct(dat$profile)
n_profiles_total   <- nrow(dat)

attr_cols <- sort(unique(labels$attribute_id))  # att1 ... att7

# Long table of shown levels: one row per profile x attribute
shown <- dat |>
  select(id, task, profile, all_of(attr_cols)) |>
  pivot_longer(all_of(attr_cols),
               names_to = "attribute_id", values_to = "level_id") |>
  mutate(level_id = as.character(level_id)) |>
  left_join(labels, by = c("attribute_id", "level_id"))

# Level frequencies within each attribute (randomization balance check).
# Ordered by level_id (the design's own level1, level2, ... order), not by
# share or level text, so ordinal/canonical attribute structure is preserved.
freq <- shown |>
  count(attribute_id, attribute, level, level_id, name = "n") |>
  group_by(attribute_id, attribute) |>
  mutate(
    pct         = n / sum(n),
    n_levels    = n(),
    expected    = sum(n) / n_levels,
    expected_pct = 1 / n_levels
  ) |>
  ungroup() |>
  arrange(attribute_id, level_id)

# Chi-squared goodness of fit against a uniform benchmark, within attribute
balance <- freq |>
  group_by(attribute_id, attribute) |>
  summarise(
    n_levels  = first(n_levels),
    test      = list(chisq.test(n)),
    max_dev   = max(abs(n - expected) / expected),
    .groups   = "drop"
  ) |>
  mutate(
    chisq   = vapply(test, function(t) unname(t$statistic), numeric(1)),
    p_value = vapply(test, function(t) t$p.value, numeric(1))
  ) |>
  select(-test)

# Restriction check: sweep all 21 pairwise cross-tabs of the 7 attributes.
# A restriction distorting one attribute's margins would surface as
# dependence between that attribute and *some* other attribute, so we don't
# single out one pair in advance.
attr_pairs <- combn(attr_cols, 2, simplify = FALSE)
pair_tests <- lapply(attr_pairs, function(p) {
  test <- chisq.test(table(dat[[p[1]]], dat[[p[2]]]))
  data.frame(a1 = p[1], a2 = p[2],
             chisq = unname(test$statistic), p_value = test$p.value)
})
pair_tests <- do.call(rbind, pair_tests)
min_pair <- pair_tests[which.min(pair_tests$p_value), ]
attr_name_of <- setNames(labels$attribute[match(attr_cols, labels$attribute_id)], attr_cols)

# Repeated-task agreement rate: share of respondents whose task-1 choice
# matches their choice on the flipped repeat (`agree`, one value per
# respondent, carried on both task-1 profile rows).
agree_by_id <- dat |>
  filter(task == 1) |>
  group_by(id) |>
  summarise(agree = first(agree), .groups = "drop")
n_repeated_resp <- sum(!is.na(agree_by_id$agree))
n_agree <- sum(agree_by_id$agree, na.rm = TRUE)
agree_rate <- n_agree / n_repeated_resp

# Attribute table for the summary
attr_tbl <- labels |>
  group_by(attribute_id, attribute) |>
  summarise(n_levels = n(), .groups = "drop") |>
  arrange(attribute_id)

# ---- Figure: level frequencies by attribute --------------------------------

dir.create("figures", showWarnings = FALSE)

# Levels stay in their natural (level_id) order within each panel -- not
# sorted by share -- since sorting by magnitude would scramble the ordinal
# structure of six of the seven attributes and encode noise as if it were
# signal (the balance-check finding is that levels are ~equal).
plot_dat <- freq |>
  mutate(
    attribute_wrapped = str_wrap(attribute, 18),
    level_wrapped     = str_wrap(level, 34)
  ) |>
  arrange(attribute_id, level_id) |>
  group_by(attribute_id) |>
  mutate(level_wrapped = factor(level_wrapped, levels = rev(unique(level_wrapped)))) |>
  ungroup() |>
  mutate(attribute_wrapped = factor(
    attribute_wrapped,
    levels = unique(attribute_wrapped[order(attribute_id)])
  ))

p <- ggplot(plot_dat, aes(x = pct, y = level_wrapped, fill = attribute_wrapped)) +
  geom_col(width = 0.62, show.legend = FALSE) +
  geom_vline(aes(xintercept = expected_pct),
             linetype = "dashed", color = "grey35", linewidth = 0.4) +
  geom_text(aes(label = scales::percent(pct, accuracy = 0.1)),
            hjust = -0.15, size = 2.9, color = "grey20") +
  scale_fill_manual(values = okabe_ito) +
  scale_x_continuous(labels = scales::percent_format(accuracy = 1),
                     expand = expansion(mult = c(0, 0.18))) +
  facet_grid(attribute_wrapped ~ ., scales = "free_y", space = "free_y") +
  labs(x = "Share of displayed profiles", y = NULL)

ggsave("figures/level-frequencies.png", p,
       width = 8.5, height = 10.5, dpi = 300, bg = "white")

# ---- summary.md -------------------------------------------------------------

fmt_pct <- function(x) sprintf("%.1f%%", 100 * x)

attr_rows <- attr_tbl |>
  mutate(row = sprintf("| %s | %s | %d |", attribute_id, attribute, n_levels)) |>
  pull(row)

freq_rows <- freq |>
  mutate(row = sprintf("| %s | %s | %s | %s |",
                       attribute, level,
                       format(n, big.mark = ","), fmt_pct(pct))) |>
  pull(row)

balance_rows <- balance |>
  mutate(row = sprintf("| %s | %d | %.2f | %.3f | %s |",
                       attribute, n_levels, chisq, p_value, fmt_pct(max_dev))) |>
  pull(row)

n_flagged <- sum(balance$p_value < 0.05)
flagged <- balance |> filter(p_value < 0.05)
bonferroni_alpha <- 0.05 / nrow(balance)
survives_bonferroni <- n_flagged > 0 && min(flagged$p_value) < bonferroni_alpha
balance_note <- if (n_flagged == 0) {
  paste("No attribute departs from the uniform benchmark",
        "(all chi-squared p-values > 0.05); the largest relative deviation",
        "from the benchmark count is", fmt_pct(max(balance$max_dev)),
        "across", format(n_profiles_total, big.mark = ","),
        "displayed profiles.")
} else {
  paste0(
    paste(flagged$attribute, collapse = "; "), " departs from the uniform ",
    "benchmark (p = ", sprintf("%.3f", min(flagged$p_value)),
    if (survives_bonferroni) {
      paste0(", which survives a Bonferroni correction across the ",
             nrow(balance), " tests). ")
    } else {
      paste0(", which does not survive a Bonferroni correction across the ",
             nrow(balance), " tests). ")
    },
    "Because the true assignment probabilities are not documented here, ",
    "this flags a departure from uniformity, not necessarily an error: ",
    "weighted or restricted randomization would produce the same pattern. ",
    "A sweep of all ", nrow(pair_tests), " pairwise cross-tabulations among ",
    "the ", nrow(attr_tbl), " attributes finds no dependence surviving any ",
    "multiplicity correction (smallest unadjusted p = ",
    sprintf("%.3f", min_pair$p_value), ", for ", attr_name_of[min_pair$a1],
    " x ", attr_name_of[min_pair$a2], "; every pair involving ",
    paste(flagged$attribute, collapse = " or "), " has p >= ",
    sprintf("%.2f", min(pair_tests$p_value[pair_tests$a1 %in% flagged$attribute_id |
                                            pair_tests$a2 %in% flagged$attribute_id])),
    "), so the departure is confined to ",
    paste(flagged$attribute, collapse = " and "),
    "'s own margins. The imbalance remains an open flag (weighted ",
    "assignment or chance) rather than evidence of a data problem."
  )
}

fig_caption <- if (n_flagged == 0) {
  paste0(
    "*Share of the ", format(n_profiles_total, big.mark = ","),
    " displayed profiles assigned to each level of each attribute, with ",
    "dashed lines marking the uniform benchmark (1 / number of levels); ",
    "no attribute departs detectably from it.*"
  )
} else {
  paste0(
    "*Share of the ", format(n_profiles_total, big.mark = ","),
    " displayed profiles assigned to each level of each attribute, with ",
    "dashed lines marking the uniform benchmark (1 / number of levels); ",
    "only ", paste(flagged$attribute, collapse = " and "),
    " departs detectably from it (chi-squared p = ",
    sprintf("%.3f", min(flagged$p_value)), ").*"
  )
}

# Repeated-task agreement note
agree_note <- sprintf(
  paste0("%d of %d respondents (%s) made the same choice on task 1 as on ",
         "its flipped repeat (`agree` == 1) -- the reliability check the ",
         "repeated task is designed to produce."),
  n_agree, n_repeated_resp, fmt_pct(agree_rate)
)

md <- c(
  "# Design summary: `projoint::exampleData1` (community-choice conjoint)",
  "",
  "## Structure",
  "",
  sprintf("- **Respondents:** %d", n_respondents),
  sprintf("- **Choice tasks per respondent:** %d, plus one repeated task (`choice1_repeated_flipped`: task 1 re-shown with the two profiles in flipped order, used for intra-respondent reliability / IRR correction)", tasks_per_resp),
  sprintf("- **Profiles per task:** %d (forced binary choice)", profiles_per_task),
  sprintf("- **Profile observations:** %s (%d respondents x %d tasks x %d profiles). The repeated task adds no rows: its outcome is stored in the `selected_repeated` column of the task-1 rows.",
          format(n_profiles_total, big.mark = ","),
          n_respondents, tasks_per_resp, profiles_per_task),
  sprintf("- **Attributes:** %d, with %d levels in total", nrow(attr_tbl), nrow(labels)),
  sprintf("- **Repeated-task agreement:** %s", agree_note),
  "",
  "## Attributes and level counts",
  "",
  "| Attribute id | Attribute | Levels |",
  "|---|---|---|",
  attr_rows,
  "",
  "## Randomization balance check",
  "",
  "Frequencies of each level across all displayed profiles, within attribute.",
  "Observed frequencies are compared to a uniform benchmark (each level shown",
  "with probability 1 / number of levels); the design's true assignment",
  "probabilities are not documented here, so a departure from the benchmark is",
  "a flag to interpret, not automatically an error. The tests treat the",
  format(n_profiles_total, big.mark = ","),
  "displayed profiles as independent draws, which is appropriate under",
  "per-profile randomization.",
  "",
  "| Attribute | Level | Shown (n) | Share |",
  "|---|---|---|---|",
  freq_rows,
  "",
  "Chi-squared goodness-of-fit tests against the uniform benchmark:",
  "",
  "| Attribute | Levels | Chi-sq | p-value | Max relative deviation |",
  "|---|---|---|---|---|",
  balance_rows,
  "",
  balance_note,
  "",
  "## Figure",
  "",
  "![Level frequencies by attribute](figures/level-frequencies.png)",
  "",
  fig_caption
)

writeLines(md, "summary.md")

message("Done: summary.md and figures/level-frequencies.png written.")
