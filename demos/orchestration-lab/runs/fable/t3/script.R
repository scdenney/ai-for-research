## Conjoint reference-category sensitivity analysis
## Demonstrates that MMs are baseline-free while AMCEs shift with the
## chosen reference category, for two attributes:
##   att7 - Violent Crime Rate (binary)
##   att6 - Type of Place (6 levels)
##
## projoint set_qoi() gotcha: .lev_choose / .lev_choose_b must be the BARE
## level id ("level1"), NOT the full id ("att7:level1") -- set_qoi() does
## paste0(.att_choose, ":", .lev_choose) internally.

library(projoint)
library(ggplot2)
library(dplyr)
library(tidyr)

set.seed(1234)

okabe_ito <- c("#000000", "#E69F00", "#56B4E9", "#009E73",
               "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

data(exampleData1)
out <- reshape_projoint(exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped"))
labs <- out$labels   # attribute, level, attribute_id, level_id

dir.create("figures", showWarnings = FALSE)

## ---------------------------------------------------------------
## 1. All marginal means (baseline-free)
## ---------------------------------------------------------------
fit_mm <- projoint(out, .estimand = "mm", .structure = "profile_level")
mm_all <- fit_mm$estimates %>%
  filter(estimand == "mm_corrected") %>%
  left_join(labs, by = c("att_level_choose" = "level_id")) %>%
  select(attribute, level, attribute_id, att_level_choose,
         mm_estimate = estimate, mm_se = se,
         mm_conf.low = conf.low, mm_conf.high = conf.high)

## ---------------------------------------------------------------
## 2. Default AMCEs (baseline = level1 of each attribute)
## ---------------------------------------------------------------
fit_amce_default <- projoint(out, .estimand = "amce", .structure = "profile_level")
amce_default <- fit_amce_default$estimates %>%
  filter(estimand == "amce_corrected") %>%
  left_join(labs, by = c("att_level_choose" = "level_id")) %>%
  select(attribute, level, attribute_id, att_level_choose,
         estimate, se, conf.low, conf.high)

## ---------------------------------------------------------------
## 3. Crime AMCE under alternate baseline (baseline = level2, "more crime")
## ---------------------------------------------------------------
q_crime_alt <- set_qoi(.structure = "profile_level", .estimand = "amce",
  .att_choose = "att7", .lev_choose = "level1",
  .att_choose_b = "att7", .lev_choose_b = "level2")
fit_crime_alt <- projoint(out, .qoi = q_crime_alt,
  .estimand = "amce", .structure = "profile_level")
crime_alt <- fit_crime_alt$estimates %>%
  filter(estimand == "amce_corrected") %>%
  mutate(att_level_choose = "att7:level1", baseline_label = "More crime (level2)") %>%
  select(att_level_choose, baseline_label, estimate, se, conf.low, conf.high)

## Default crime AMCE (baseline = level1, "less crime") -> row for level2
crime_default <- amce_default %>%
  filter(attribute_id == "att7") %>%
  transmute(att_level_choose, baseline_label = "Less crime (level1)",
            estimate, se, conf.low, conf.high)

crime_amce <- bind_rows(crime_default, crime_alt)

## ---------------------------------------------------------------
## 4. Type of Place (att6) AMCEs under 3 baselines
##    baseline = level1 (default, from step 2)
##    baseline = level4 (Small town, highest MM)
##    baseline = level3 (Rural)
## ---------------------------------------------------------------
att6_levels <- labs %>% filter(attribute_id == "att6") %>% pull(level_id)
att6_bare   <- sub("^att6:", "", att6_levels)

get_att6_amce <- function(baseline_bare, baseline_label) {
  other_levels <- setdiff(att6_bare, baseline_bare)
  res <- lapply(other_levels, function(lev) {
    q <- set_qoi(.structure = "profile_level", .estimand = "amce",
      .att_choose = "att6", .lev_choose = lev,
      .att_choose_b = "att6", .lev_choose_b = baseline_bare)
    f <- projoint(out, .qoi = q, .estimand = "amce", .structure = "profile_level")
    f$estimates %>%
      filter(estimand == "amce_corrected") %>%
      mutate(att_level_choose = paste0("att6:", lev))
  })
  bind_rows(res) %>%
    mutate(baseline_label = baseline_label,
           baseline_id = paste0("att6:", baseline_bare)) %>%
    select(att_level_choose, baseline_label, baseline_id, estimate, se, conf.low, conf.high)
}

att6_base_level1 <- amce_default %>%
  filter(attribute_id == "att6") %>%
  transmute(att_level_choose, baseline_label = "City downtown (level1)",
            baseline_id = "att6:level1", estimate, se, conf.low, conf.high)

att6_base_level4 <- get_att6_amce("level4", "Small town (level4)")
att6_base_level3 <- get_att6_amce("level3", "Rural (level3)")

## reference rows (estimate = 0) for each baseline's own level
att6_ref_rows <- tibble(
  att_level_choose = c("att6:level1", "att6:level4", "att6:level3"),
  baseline_label = c("City downtown (level1)", "Small town (level4)", "Rural (level3)"),
  baseline_id = c("att6:level1", "att6:level4", "att6:level3"),
  estimate = 0, se = NA_real_, conf.low = 0, conf.high = 0
)

att6_amce <- bind_rows(att6_base_level1, att6_base_level4, att6_base_level3, att6_ref_rows)

## ---------------------------------------------------------------
## 5. Attribute-importance ranking (MM range = max - min per attribute)
## ---------------------------------------------------------------
mm_range <- mm_all %>%
  group_by(attribute_id, attribute) %>%
  summarise(n_levels = n(),
            mm_range = max(mm_estimate) - min(mm_estimate),
            .groups = "drop") %>%
  arrange(desc(mm_range)) %>%
  mutate(rank = row_number()) %>%
  select(rank, attribute, n_levels, mm_range)

## ---------------------------------------------------------------
## Acceptance checks (stop if they disagree materially)
## ---------------------------------------------------------------
stopifnot(
  abs(mm_all$mm_estimate[mm_all$att_level_choose == "att7:level1"] - 0.626) < 0.01,
  abs(mm_all$mm_estimate[mm_all$att_level_choose == "att7:level2"] - 0.374) < 0.01,
  abs(crime_amce$estimate[crime_amce$baseline_label == "Less crime (level1)"] - (-0.251)) < 0.01,
  abs(crime_amce$estimate[crime_amce$baseline_label == "More crime (level2)"] - 0.251) < 0.01
)
message("Acceptance checks passed.")

## =================================================================
## FIGURE: figures/sensitivity.png
## Two facet rows: (A) MMs baseline-free, (B) AMCEs depend on baseline
## =================================================================
wrap_lab <- function(x) sapply(x, function(s) paste(strwrap(s, width = 20), collapse = "\n"))

## --- Panel A data: MMs for Crime + Type of Place ---
mmA <- mm_all %>%
  filter(attribute_id %in% c("att6", "att7")) %>%
  transmute(attribute, level, att_level_choose,
            estimate = mm_estimate, conf.low = mm_conf.low, conf.high = mm_conf.high,
            baseline_label = "Marginal mean", panel = "A. Marginal means (baseline-free)")

## --- Panel B data: AMCEs for Crime (2 baselines) + Type of Place (3 baselines) ---
crimeB <- crime_amce %>%
  left_join(labs, by = c("att_level_choose" = "level_id")) %>%
  select(attribute, level, att_level_choose, baseline_label, estimate, conf.low, conf.high) %>%
  mutate(panel = "B. AMCEs (depend on baseline)")

att6B <- att6_amce %>%
  left_join(labs, by = c("att_level_choose" = "level_id")) %>%
  select(attribute, level, att_level_choose, baseline_label, estimate, conf.low, conf.high) %>%
  mutate(panel = "B. AMCEs (depend on baseline)")

panelB <- bind_rows(crimeB, att6B)

## human-readable level labels for y axis, wrapped
level_lookup <- labs %>% select(level_id, level) %>% distinct()

plot_df <- bind_rows(
  mmA %>% select(attribute, level, att_level_choose, baseline_label, estimate, conf.low, conf.high, panel),
  panelB %>% select(attribute, level, att_level_choose, baseline_label, estimate, conf.low, conf.high, panel)
) %>%
  mutate(
    level_wrapped = wrap_lab(level),
    attribute = factor(attribute, levels = c("Violent Crime Rate (Vs National Rate)", "Type of Place")),
    panel = factor(panel, levels = c("A. Marginal means (baseline-free)", "B. AMCEs (depend on baseline)"))
  )

## order levels within attribute for readability (att6 level order, att7 level order)
level_order <- labs %>%
  filter(attribute_id %in% c("att6", "att7")) %>%
  arrange(attribute_id, level_id) %>%
  mutate(level_wrapped = wrap_lab(level)) %>%
  pull(level_wrapped) %>%
  unique()

plot_df <- plot_df %>%
  mutate(level_wrapped = factor(level_wrapped, levels = rev(level_order)))

baseline_colors <- setNames(
  okabe_ito[1:5],
  c("Marginal mean", "Less crime (level1)", "More crime (level2)",
    "City downtown (level1)", "Small town (level4)")
)
baseline_colors["Rural (level3)"] <- okabe_ito[6]

p <- ggplot(plot_df, aes(x = estimate, xmin = conf.low, xmax = conf.high,
                          y = level_wrapped, color = baseline_label, shape = baseline_label)) +
  geom_vline(data = data.frame(panel = factor("A. Marginal means (baseline-free)",
                                                levels = levels(plot_df$panel)), xint = 0.5),
             aes(xintercept = xint), linetype = "dashed", color = "grey50", inherit.aes = FALSE) +
  geom_vline(data = data.frame(panel = factor("B. AMCEs (depend on baseline)",
                                                levels = levels(plot_df$panel)), xint = 0),
             aes(xintercept = xint), linetype = "dashed", color = "grey50", inherit.aes = FALSE) +
  geom_pointrange(position = position_dodge(width = 0.5)) +
  scale_color_manual(values = baseline_colors, name = "Series / baseline") +
  scale_shape_manual(values = c(16, 15, 17, 15, 17, 18), name = "Series / baseline") +
  facet_grid(attribute ~ panel, scales = "free", space = "free_y",
             labeller = labeller(attribute = label_wrap_gen(width = 14))) +
  labs(x = "Estimate", y = NULL) +
  theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold"),
    strip.text.y = element_text(angle = 0, size = 8.5),
    plot.title = element_blank(),
    legend.position = "bottom",
    plot.margin = margin(t = 5, r = 25, b = 5, l = 5)
  )

ggsave("figures/sensitivity.png", plot = p, width = 10, height = 8.5, dpi = 300, bg = "white")

## =================================================================
## TABLE: sensitivity-table.md
## =================================================================
r3 <- function(x) sprintf("%.3f", x)

## --- Table 1: Violent Crime Rate ---
crime_mm <- mm_all %>% filter(attribute_id == "att7")

t1_rows <- crime_mm %>%
  left_join(crime_amce %>% filter(baseline_label == "Less crime (level1)") %>%
              select(att_level_choose, amce_less = estimate,
                     lo_less = conf.low, hi_less = conf.high),
            by = "att_level_choose") %>%
  left_join(crime_amce %>% filter(baseline_label == "More crime (level2)") %>%
              select(att_level_choose, amce_more = estimate,
                     lo_more = conf.low, hi_more = conf.high),
            by = "att_level_choose") %>%
  mutate(
    amce_less_txt = ifelse(att_level_choose == "att7:level1", "0 (ref)",
      paste0(r3(amce_less), " [", r3(lo_less), ", ", r3(hi_less), "]")),
    amce_more_txt = ifelse(att_level_choose == "att7:level2", "0 (ref)",
      paste0(r3(amce_more), " [", r3(lo_more), ", ", r3(hi_more), "]")),
    mm_txt = paste0(r3(mm_estimate), " [", r3(mm_conf.low), ", ", r3(mm_conf.high), "]")
  ) %>%
  select(level, amce_less_txt, amce_more_txt, mm_txt)

table1_md <- c(
  "| Level | AMCE (baseline = Less crime) | AMCE (baseline = More crime) | Marginal mean [95% CI] |",
  "|---|---|---|---|",
  sprintf("| %s | %s | %s | %s |", t1_rows$level, t1_rows$amce_less_txt, t1_rows$amce_more_txt, t1_rows$mm_txt)
)

## --- Table 2: Type of Place ---
att6_mm <- mm_all %>% filter(attribute_id == "att6")

wide2 <- att6_amce %>%
  left_join(labs, by = c("att_level_choose" = "level_id")) %>%
  select(level, att_level_choose, baseline_id, estimate, conf.low, conf.high) %>%
  mutate(
    cell = ifelse(att_level_choose == baseline_id, "0 (ref)",
      paste0(r3(estimate), " [", r3(conf.low), ", ", r3(conf.high), "]"))
  ) %>%
  select(level, att_level_choose, baseline_id, cell) %>%
  pivot_wider(names_from = baseline_id, values_from = cell) %>%
  left_join(att6_mm %>% select(att_level_choose, mm_estimate, mm_conf.low, mm_conf.high),
            by = "att_level_choose") %>%
  mutate(mm_txt = paste0(r3(mm_estimate), " [", r3(mm_conf.low), ", ", r3(mm_conf.high), "]")) %>%
  arrange(att_level_choose)

table2_md <- c(
  "| Level | AMCE (base = City downtown / level1) | AMCE (base = Small town / level4) | AMCE (base = Rural / level3) | Marginal mean [95% CI] |",
  "|---|---|---|---|---|",
  sprintf("| %s | %s | %s | %s | %s |",
    wide2$level, wide2[["att6:level1"]], wide2[["att6:level4"]], wide2[["att6:level3"]], wide2$mm_txt)
)

## --- Table 3: attribute importance ---
table3_md <- c(
  "| Rank | Attribute | # levels | MM range (max−min) |",
  "|---|---|---|---|",
  sprintf("| %d | %s | %d | %s |", mm_range$rank, mm_range$attribute, mm_range$n_levels, r3(mm_range$mm_range))
)

md <- c(
  "# Conjoint reference-category sensitivity analysis",
  "",
  "Violent Crime Rate is a **binary** attribute (two levels); its AMCE under one baseline is",
  "an exact sign-flip of its AMCE under the other, while its marginal means are fixed",
  "regardless of baseline choice. Type of Place has six levels, so per-level AMCEs shift",
  "in magnitude (not just sign) depending on which level is used as the reference category.",
  "",
  "## Table 1 -- Violent Crime Rate: AMCE under each baseline vs. marginal means",
  "",
  table1_md,
  "",
  "## Table 2 -- Type of Place: AMCEs shift with baseline",
  "",
  table2_md,
  "",
  "## Table 3 -- Baseline-free attribute importance (MM range)",
  "",
  table3_md,
  ""
)

writeLines(md, "sensitivity-table.md")

message("Done: figures/sensitivity.png and sensitivity-table.md written.")
