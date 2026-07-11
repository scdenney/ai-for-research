# T3 — Baseline sensitivity of the crime-attribute finding
# Re-estimates AMCEs under alternative reference categories, computes
# baseline-invariant marginal means (MMs), formally tests whether the
# crime MM range exceeds the driving-time MM range, and writes
# figures/sensitivity.png and sensitivity-table.md.
#
# Run: Rscript script.R

suppressMessages({
  library(projoint)
  library(dplyr)
  library(tidyr)
  library(purrr)
  library(stringr)
  library(ggplot2)
  library(patchwork)
})

# ---- theme and palette (Okabe-Ito) ------------------------------------------
okabe_ito <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442",
               "#0072B2", "#D55E00", "#CC79A7", "#000000")
theme_set(
  theme_minimal(base_size = 11) +
    theme(panel.grid.minor = element_blank(),
          strip.text = element_text(face = "bold"),
          legend.position = "bottom",
          plot.margin = margin(6, 10, 6, 6))
)
set.seed(2026)  # governs the 2,000-draw respondent-cluster bootstrap below

dir.create("figures", showWarnings = FALSE)

# ---- data --------------------------------------------------------------------
data(exampleData1)
out <- reshape_projoint(exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped"))

labels <- out$labels %>%
  mutate(level = str_trim(level), attribute = str_trim(attribute))
lab_lookup <- setNames(labels$level, labels$level_id)
att_lookup <- setNames(labels$attribute, labels$attribute_id)

# All estimation below: profile-level estimands, analytical SEs clustered by
# respondent, with projoint's IRR (measurement-error) correction from the
# repeated task. Corrected estimates are the primary quantities; uncorrected
# are kept for the table.

# ---- 1. AMCEs under the default baselines (level1 of each attribute) ---------
fit_amce <- suppressWarnings(
  projoint(out, .structure = "profile_level", .estimand = "amce"))
tau <- fit_amce$tau

# ---- 2. Crime AMCE under each of its two possible baselines ------------------
# att7 (Violent Crime Rate) is binary: level1 = 20% less crime than national
# average, level2 = 20% more. Default baseline is level1; re-estimate with
# level2 as the reference via set_qoi.
qoi_crime_flip <- set_qoi(.structure = "profile_level", .estimand = "amce",
  .att_choose = "att7", .lev_choose = "level1",
  .att_choose_b = "att7", .lev_choose_b = "level2")
fit_crime_flip <- suppressWarnings(
  projoint(out, .qoi = qoi_crime_flip, .structure = "profile_level",
           .estimand = "amce"))

crime_tab <- bind_rows(
  fit_amce$estimates %>%
    filter(att_level_choose == "att7:level2") %>%
    mutate(baseline = lab_lookup["att7:level1"],
           estimated_level = lab_lookup["att7:level2"]),
  fit_crime_flip$estimates %>%
    mutate(baseline = lab_lookup["att7:level2"],
           estimated_level = lab_lookup["att7:level1"])
) %>%
  select(baseline, estimated_level, estimand, estimate, se, conf.low, conf.high)

# ---- 3. A multi-level attribute under an alternative baseline ----------------
# att5 (Driving Time, 4 levels) — default baseline level1 (10 min);
# alternative baseline level3 (45 min).
drive_alt <- map_dfr(c("level1", "level2", "level4"), function(lv) {
  q <- set_qoi(.structure = "profile_level", .estimand = "amce",
    .att_choose = "att5", .lev_choose = lv,
    .att_choose_b = "att5", .lev_choose_b = "level3")
  suppressWarnings(
    projoint(out, .qoi = q, .structure = "profile_level", .estimand = "amce")
  )$estimates %>%
    mutate(level_id = paste0("att5:", lv))
})

drive_tab <- bind_rows(
  fit_amce$estimates %>%
    filter(str_starts(att_level_choose, "att5")) %>%
    mutate(baseline = "10 min", level_id = att_level_choose),
  drive_alt %>% mutate(baseline = "45 min")
) %>%
  mutate(estimated_level = lab_lookup[level_id]) %>%
  select(baseline, estimated_level, estimand, estimate, se, conf.low, conf.high)

# ---- 4. Marginal means for all levels (baseline-invariant) -------------------
fit_mm <- suppressWarnings(
  projoint(out, .structure = "profile_level", .estimand = "mm"))

mm_all <- fit_mm$estimates %>%
  mutate(attribute_id = str_extract(att_level_choose, "^att\\d"),
         attribute = att_lookup[attribute_id],
         level = lab_lookup[att_level_choose])

mm_ranges <- mm_all %>%
  filter(estimand == "mm_corrected") %>%
  group_by(attribute) %>%
  summarise(mm_range = max(estimate) - min(estimate), .groups = "drop") %>%
  arrange(desc(mm_range))
print(mm_ranges)

# ---- 5. Formal test: crime MM range vs driving-time MM range -----------------
# The crime MM range equals its |AMCE|; the driving-time range is the
# 10-min-minus-75-min MM contrast. projoint's profile-level MMs drop
# attribute-tied tasks (both profiles share the level), so a plain OLS on all
# rows targets a different (attenuated) estimand. Instead, reproduce the
# tie-removed estimator exactly (verified to match projoint's uncorrected MMs
# to 4+ decimals) and bootstrap the range difference clustering on
# respondents. projoint's IRR correction rescales deviations from 0.5 by
# 1/(1 - 2*tau) for all profile-level estimates alike, so the z-statistic and
# p-value are identical on the corrected scale.
# Fixed contrasts (levels chosen from full-sample point estimates, not
# re-maximized within bootstrap draws): crime = att7 l1 - l2; driving time =
# att5 l1 - l4; housing = att1 l1 - l3.
cells <- tibble::tribble(
  ~att,   ~lv,
  "att7", "level1",
  "att7", "level2",
  "att5", "level1",
  "att5", "level4",
  "att1", "level1",
  "att1", "level3")

# per-respondent sums and counts of tie-removed qualifying profiles per cell
per_resp <- purrr::pmap(cells, function(att, lv) {
  out$data %>%
    group_by(id, task) %>%
    mutate(other = rev(.data[[att]])) %>%
    ungroup() %>%
    filter(.data[[att]] == paste0(att, ":", lv),
           other != paste0(att, ":", lv)) %>%
    group_by(id) %>%
    summarise(s = sum(selected), n = n(), .groups = "drop")
}) %>%
  purrr::reduce(full_join, by = "id") %>%
  replace(is.na(.), 0)
S <- as.matrix(per_resp[, -1])  # s/n pairs: crime-l1, crime-l2, drive-l1, drive-l4, house-l1, house-l3

ranges_fn <- function(rows) {
  cs <- colSums(S[rows, , drop = FALSE])
  c(crime = cs[[1]] / cs[[2]] - cs[[3]] / cs[[4]],
    drive = cs[[5]] / cs[[6]] - cs[[7]] / cs[[8]],
    house = cs[[9]] / cs[[10]] - cs[[11]] / cs[[12]])
}
n_resp <- nrow(S)
pt <- ranges_fn(seq_len(n_resp))
boot <- t(replicate(2000, ranges_fn(sample.int(n_resp, replace = TRUE))))
scale_corr <- 1 / (1 - 2 * tau)

tests <- purrr::map_dfr(c("drive", "house"), function(rival) {
  d_est <- pt["crime"] - pt[rival]
  d_se  <- sd(boot[, "crime"] - boot[, rival])
  tibble(rival = rival,
         diff_unc = d_est, se_unc = d_se,
         diff_cor = d_est * scale_corr, se_cor = d_se * scale_corr,
         z = d_est / d_se, p = 2 * pnorm(-abs(d_est / d_se)))
})
print(as.data.frame(tests), digits = 3)
# kept for the table text below
diff_est <- tests$diff_unc[1]; diff_se <- tests$se_unc[1]
z <- tests$z[1]; p <- tests$p[1]

# ---- 6. Figure: one two-panel PNG --------------------------------------------
# Panel A: AMCEs for crime and driving time under each baseline choice.
panelA_dat <- bind_rows(
  crime_tab %>% mutate(attribute = "Violent Crime Rate",
                       baseline = paste("ref:", baseline)),
  drive_tab %>% mutate(attribute = "Driving Time",
                       baseline = paste("ref:", baseline))
) %>%
  filter(estimand == "amce_corrected") %>%
  mutate(estimated_level = str_wrap(estimated_level, 22),
         attribute = factor(attribute,
                            levels = c("Violent Crime Rate", "Driving Time")))

pA <- ggplot(panelA_dat,
             aes(x = estimate, y = estimated_level, color = baseline)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "grey55") +
  geom_pointrange(aes(xmin = conf.low, xmax = conf.high),
                  position = position_dodge(width = 0.55), size = 0.35) +
  facet_grid(attribute ~ ., scales = "free_y", space = "free_y") +
  scale_color_manual(values = okabe_ito[c(5, 6, 3, 1)], name = NULL) +
  guides(color = guide_legend(nrow = 2)) +
  labs(x = "AMCE (corrected), pr. profile chosen", y = NULL)

# Panel B: baseline-invariant MMs for all levels, attributes ordered by range.
panelB_dat <- mm_all %>%
  filter(estimand == "mm_corrected") %>%
  mutate(attribute = factor(attribute, levels = mm_ranges$attribute),
         level = str_wrap(level, 30)) %>%
  group_by(attribute) %>%
  mutate(level = reorder(level, estimate)) %>%
  ungroup()

pB <- ggplot(panelB_dat, aes(x = estimate, y = level)) +
  geom_vline(xintercept = 0.5, linetype = "dashed", color = "grey55") +
  geom_pointrange(aes(xmin = conf.low, xmax = conf.high),
                  color = okabe_ito[5], size = 0.3) +
  facet_grid(attribute ~ ., scales = "free_y", space = "free_y",
             labeller = labeller(attribute = label_wrap_gen(24))) +
  theme(strip.text.y = element_text(angle = 0, hjust = 0)) +
  labs(x = "Marginal mean (corrected), pr. profile chosen", y = NULL)

fig <- pA + pB + plot_layout(widths = c(1, 1.15)) +
  plot_annotation(tag_levels = "A")
ggsave("figures/sensitivity.png", fig, width = 11.5, height = 9, dpi = 300,
       bg = "white")

# ---- 7. sensitivity-table.md --------------------------------------------------
fmt <- function(x) sprintf("%.3f", x)
row_md <- function(df) {
  paste0("| ", df$baseline, " | ", df$estimated_level, " | ",
         ifelse(df$estimand == "amce_corrected", "corrected", "uncorrected"),
         " | ", fmt(df$estimate), " | ", fmt(df$se), " | [",
         fmt(df$conf.low), ", ", fmt(df$conf.high), "] |")
}

mm_md <- mm_all %>%
  arrange(att_level_choose, estimand) %>%
  mutate(row = paste0("| ", attribute, " | ", level, " | ",
                      ifelse(estimand == "mm_corrected", "corrected", "uncorrected"),
                      " | ", fmt(estimate), " | ", fmt(se), " | [",
                      fmt(conf.low), ", ", fmt(conf.high), "] |"))

tbl <- c(
  "# Baseline sensitivity: Violent Crime Rate",
  "",
  "All estimates: profile-level, respondent-clustered analytical SEs;",
  sprintf("IRR-corrected estimates use projoint's tau = %.3f (correction rescales profile-level estimates by 1/(1 - 2*tau) = %.3f).", tau, 1 / (1 - 2 * tau)),
  "",
  "## Crime AMCE under each possible baseline (attribute is binary)",
  "",
  "| Reference category | Estimated level | Estimand | AMCE | SE | 95% CI |",
  "|---|---|---|---|---|---|",
  row_md(crime_tab %>% arrange(baseline, estimand)),
  "",
  "Swapping the reference flips the sign only; magnitude, SE, and CI width are identical.",
  "",
  "## Driving Time AMCEs under two baselines (multi-level attribute)",
  "",
  "| Reference category | Estimated level | Estimand | AMCE | SE | 95% CI |",
  "|---|---|---|---|---|---|",
  row_md(drive_tab %>% arrange(baseline, estimated_level, estimand)),
  "",
  "Here individual AMCEs do change with the reference category (reparameterization of the same information).",
  "",
  "## Marginal means (baseline-invariant), all levels",
  "",
  "| Attribute | Level | Estimand | MM | SE | 95% CI |",
  "|---|---|---|---|---|---|",
  mm_md$row,
  "",
  "## Attribute importance as corrected-MM range (max minus min)",
  "",
  "| Attribute | MM range |",
  "|---|---|",
  paste0("| ", mm_ranges$attribute, " | ", fmt(mm_ranges$mm_range), " |"),
  "",
  "Formal tests of range differences (respondent-cluster bootstrap, 2,000 draws; fixed contrasts, levels chosen from full-sample point estimates, not re-maximized per draw; two unadjusted pairwise tests):",
  "",
  sprintf("- Crime minus driving time: %.3f (SE %.3f) uncorrected, %.3f (SE %.3f) corrected; z = %.2f, p = %.3f.",
          tests$diff_unc[1], tests$se_unc[1], tests$diff_cor[1], tests$se_cor[1], tests$z[1], tests$p[1]),
  sprintf("- Crime minus housing cost: %.3f (SE %.3f) uncorrected, %.3f (SE %.3f) corrected; z = %.2f, p = %.3f.",
          tests$diff_unc[2], tests$se_unc[2], tests$diff_cor[2], tests$se_cor[2], tests$z[2], tests$p[2]),
  "",
  "The IRR correction rescales all ranges by the same factor, so z and p are identical on either scale; corrected-scale SEs condition on the estimated tau."
)
writeLines(tbl, "sensitivity-table.md")

cat("Done: figures/sensitivity.png, sensitivity-table.md\n")
