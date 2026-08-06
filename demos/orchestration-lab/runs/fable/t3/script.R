library(projoint)
library(ggplot2)
library(dplyr)

okabe_ito <- c("#000000","#E69F00","#56B4E9","#009E73","#F0E442","#0072B2","#D55E00","#CC79A7")

theme_amce <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold"),
    legend.position = "none",
    plot.title = element_blank()
  )

set.seed(1234)

dir.create("figures", showWarnings = FALSE)

## ---- Data ----
data(exampleData1)
out <- reshape_projoint(exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped"))

## attribute/level label lookup straight from the reshaped data's own labels table
labels_tbl <- out$labels
att_labels <- setNames(labels_tbl$attribute[!duplicated(labels_tbl$attribute_id)],
                        labels_tbl$attribute_id[!duplicated(labels_tbl$attribute_id)])
lev_labels <- setNames(labels_tbl$level, labels_tbl$level_id)

get_row <- function(fit, estimand_name) {
  d <- fit$estimates
  d[d$estimand == estimand_name, ]
}

## ---- 1. Crime attribute (att7) AMCE under both baselines ----
## .lev_choose is the TARGET level being contrasted; .lev_choose_b is the BASELINE/reference level.

## Default baseline = level1 (Less Crime) as reference -> target level2 (More Crime) vs baseline level1
q_crime_default <- set_qoi(.structure = "profile_level", .estimand = "amce",
  .att_choose = "att7", .lev_choose = "level2",
  .att_choose_b = "att7", .lev_choose_b = "level1")
fit_crime_default <- projoint(out, .qoi = q_crime_default)

## Flipped baseline = level2 (More Crime) as reference -> target level1 (Less Crime) vs baseline level2
q_crime_flipped <- set_qoi(.structure = "profile_level", .estimand = "amce",
  .att_choose = "att7", .lev_choose = "level1",
  .att_choose_b = "att7", .lev_choose_b = "level2")
fit_crime_flipped <- projoint(out, .qoi = q_crime_flipped)

crime_default_corrected   <- get_row(fit_crime_default, "amce_corrected")
crime_default_uncorrected <- get_row(fit_crime_default, "amce_uncorrected")
crime_flipped_corrected   <- get_row(fit_crime_flipped, "amce_corrected")
crime_flipped_uncorrected <- get_row(fit_crime_flipped, "amce_uncorrected")

## ---- 2. Driving time attribute (att5) AMCE under both baselines ----

## Default baseline = level1 (10 min) as reference
q_drive_default_l2 <- set_qoi(.structure = "profile_level", .estimand = "amce",
  .att_choose = "att5", .lev_choose = "level2",
  .att_choose_b = "att5", .lev_choose_b = "level1")
fit_drive_default_l2 <- projoint(out, .qoi = q_drive_default_l2)

q_drive_default_l3 <- set_qoi(.structure = "profile_level", .estimand = "amce",
  .att_choose = "att5", .lev_choose = "level3",
  .att_choose_b = "att5", .lev_choose_b = "level1")
fit_drive_default_l3 <- projoint(out, .qoi = q_drive_default_l3)

q_drive_default_l4 <- set_qoi(.structure = "profile_level", .estimand = "amce",
  .att_choose = "att5", .lev_choose = "level4",
  .att_choose_b = "att5", .lev_choose_b = "level1")
fit_drive_default_l4 <- projoint(out, .qoi = q_drive_default_l4)

## Alt baseline = level4 (75 min) as reference
q_drive_alt_l1 <- set_qoi(.structure = "profile_level", .estimand = "amce",
  .att_choose = "att5", .lev_choose = "level1",
  .att_choose_b = "att5", .lev_choose_b = "level4")
fit_drive_alt_l1 <- projoint(out, .qoi = q_drive_alt_l1)

q_drive_alt_l2 <- set_qoi(.structure = "profile_level", .estimand = "amce",
  .att_choose = "att5", .lev_choose = "level2",
  .att_choose_b = "att5", .lev_choose_b = "level4")
fit_drive_alt_l2 <- projoint(out, .qoi = q_drive_alt_l2)

q_drive_alt_l3 <- set_qoi(.structure = "profile_level", .estimand = "amce",
  .att_choose = "att5", .lev_choose = "level3",
  .att_choose_b = "att5", .lev_choose_b = "level4")
fit_drive_alt_l3 <- projoint(out, .qoi = q_drive_alt_l3)

drive_default_l2 <- get_row(fit_drive_default_l2, "amce_corrected")
drive_default_l3 <- get_row(fit_drive_default_l3, "amce_corrected")
drive_default_l4 <- get_row(fit_drive_default_l4, "amce_corrected")
drive_alt_l1 <- get_row(fit_drive_alt_l1, "amce_corrected")
drive_alt_l2 <- get_row(fit_drive_alt_l2, "amce_corrected")
drive_alt_l3 <- get_row(fit_drive_alt_l3, "amce_corrected")

## ---- 3. Marginal means for ALL levels of ALL 7 attributes ----

fit_mm <- projoint(out, .estimand = "mm", .structure = "profile_level")
mm_all_corrected <- get_row(fit_mm, "mm_corrected")

mm_all_corrected$att <- sub(":.*$", "", mm_all_corrected$att_level_choose)
mm_all_corrected$lev <- mm_all_corrected$att_level_choose
mm_all_corrected$att_label <- att_labels[mm_all_corrected$att]
mm_all_corrected$lev_label <- lev_labels[mm_all_corrected$att_level_choose]
mm_all_corrected$lev_num <- as.integer(sub("^.*level", "", mm_all_corrected$att_level_choose))

## ---- 4. MM range per attribute, ranked ----

mm_range <- mm_all_corrected %>%
  group_by(att, att_label) %>%
  summarise(mm_min = min(estimate), mm_max = max(estimate),
            mm_range = mm_max - mm_min, .groups = "drop") %>%
  arrange(desc(mm_range))

## ---- Build sensitivity-table.md ----

lines <- character()

lines <- c(lines, "# Baseline sensitivity: AMCE vs marginal means")
lines <- c(lines, "")
lines <- c(lines, "## 1. Headline attribute (Violent Crime Rate) under each baseline")
lines <- c(lines, "")
lines <- c(lines, "| Reference set | Contrast estimated | AMCE (corrected) | 95% CI | AMCE (uncorrected) |")
lines <- c(lines, "|---|---|---|---|---|")
lines <- c(lines, sprintf(
  "| level1 = Less Crime (default) | level2 (More Crime) vs level1 (Less Crime) | %.1fpp | [%.1f, %.1f] | %.1fpp |",
  crime_default_corrected$estimate * 100, crime_default_corrected$conf.low * 100,
  crime_default_corrected$conf.high * 100, crime_default_uncorrected$estimate * 100))
lines <- c(lines, sprintf(
  "| level2 = More Crime (flipped) | level1 (Less Crime) vs level2 (More Crime) | %.1fpp | [%.1f, %.1f] | %.1fpp |",
  crime_flipped_corrected$estimate * 100, crime_flipped_corrected$conf.low * 100,
  crime_flipped_corrected$conf.high * 100, crime_flipped_uncorrected$estimate * 100))
lines <- c(lines, "")
lines <- c(lines, sprintf(
  "Note: |AMCE| is identical (%.1fpp) under both baselines for this binary attribute; only the sign flips.",
  abs(crime_default_corrected$estimate) * 100))
lines <- c(lines, "")

lines <- c(lines, "## 2. A multi-level attribute (Total Daily Driving Time) — where the reviewer is right")
lines <- c(lines, "")
lines <- c(lines, "| Level | AMCE vs *10 min* (default) | AMCE vs *75 min* (alt) |")
lines <- c(lines, "|---|---|---|")
lines <- c(lines, sprintf("| 10 min | 0.0 *(ref)* | %.1fpp |", drive_alt_l1$estimate * 100))
lines <- c(lines, sprintf("| 25 min | %.1fpp | %.1fpp |", drive_default_l2$estimate * 100, drive_alt_l2$estimate * 100))
lines <- c(lines, sprintf("| 45 min | %.1fpp | %.1fpp |", drive_default_l3$estimate * 100, drive_alt_l3$estimate * 100))
lines <- c(lines, sprintf("| 75 min | %.1fpp | 0.0 *(ref)* |", drive_default_l4$estimate * 100))
lines <- c(lines, "")
lines <- c(lines, "Note: every non-reference number changes when the baseline changes, but the overall spread (max - min across levels) is preserved regardless of which level is chosen as reference.")
lines <- c(lines, "")

lines <- c(lines, "## 3. Marginal means for ALL levels (the baseline-invariant quantity)")
lines <- c(lines, "")
lines <- c(lines, "| Attribute | Level | Marginal mean | 95% CI |")
lines <- c(lines, "|---|---|---|---|")

mm_ordered <- mm_all_corrected %>%
  mutate(att = factor(att, levels = mm_range$att)) %>%
  arrange(att, lev_num) %>%
  group_by(att) %>%
  mutate(row_in_group = row_number()) %>%
  ungroup()

for (i in seq_len(nrow(mm_ordered))) {
  r <- mm_ordered[i, ]
  att_cell <- if (r$row_in_group == 1) r$att_label else ""
  lines <- c(lines, sprintf("| %s | %s | %.1f%% | [%.1f, %.1f] |",
    att_cell, r$lev_label, r$estimate * 100, r$conf.low * 100, r$conf.high * 100))
}
lines <- c(lines, "")

lines <- c(lines, "## 4. Attribute importance by MM range (baseline-invariant ordering)")
lines <- c(lines, "")
lines <- c(lines, "| Rank | Attribute | MM range (max - min) |")
lines <- c(lines, "|---|---|---|")
for (i in seq_len(nrow(mm_range))) {
  lines <- c(lines, sprintf("| %d | %s | %.1fpp |", i, mm_range$att_label[i], mm_range$mm_range[i] * 100))
}
lines <- c(lines, "")
gap_1_2 <- (mm_range$mm_range[1] - mm_range$mm_range[2]) * 100
lines <- c(lines, sprintf("Gap between rank 1 and rank 2: %.1fpp.", gap_1_2))
lines <- c(lines, "")

writeLines(lines, "sensitivity-table.md")

## ---- Figure ----

plot_df <- mm_ordered %>%
  mutate(att_label = factor(att_label, levels = mm_range$att_label)) %>%
  group_by(att_label) %>%
  arrange(att_label, lev_num) %>%
  mutate(lev_label_ordered = factor(lev_label, levels = rev(lev_label))) %>%
  ungroup() %>%
  mutate(is_crime = ifelse(att == "att7", "crime", "other"))

p <- ggplot(plot_df, aes(x = estimate, y = lev_label_ordered, color = is_crime)) +
  geom_pointrange(aes(xmin = conf.low, xmax = conf.high)) +
  facet_grid(att_label ~ ., scales = "free_y", space = "free_y", switch = "y") +
  scale_color_manual(values = c(crime = okabe_ito[7], other = okabe_ito[1])) +
  labs(x = "Marginal mean (probability of profile selection)", y = NULL) +
  theme_amce +
  theme(strip.text.y.left = element_text(angle = 0, face = "bold"),
        strip.placement = "outside")

ggsave("figures/sensitivity.png", plot = p, width = 11, height = 8, dpi = 300, bg = "white")

## ---- Summary ----

cat(sprintf(
  "Crime AMCE default baseline (level2 vs level1): corrected=%.1fpp [%.1f, %.1f], uncorrected=%.1fpp\n",
  crime_default_corrected$estimate * 100, crime_default_corrected$conf.low * 100,
  crime_default_corrected$conf.high * 100, crime_default_uncorrected$estimate * 100))
cat(sprintf(
  "Crime AMCE flipped baseline (level1 vs level2): corrected=%.1fpp [%.1f, %.1f], uncorrected=%.1fpp\n",
  crime_flipped_corrected$estimate * 100, crime_flipped_corrected$conf.low * 100,
  crime_flipped_corrected$conf.high * 100, crime_flipped_uncorrected$estimate * 100))
cat(sprintf(
  "Driving time default baseline AMCEs: 25min=%.1fpp, 45min=%.1fpp, 75min=%.1fpp\n",
  drive_default_l2$estimate * 100, drive_default_l3$estimate * 100, drive_default_l4$estimate * 100))
cat(sprintf(
  "Driving time alt baseline AMCEs: 10min=%.1fpp, 25min=%.1fpp, 45min=%.1fpp\n",
  drive_alt_l1$estimate * 100, drive_alt_l2$estimate * 100, drive_alt_l3$estimate * 100))
cat("MM range ranking (attribute: range pp):\n")
for (i in seq_len(nrow(mm_range))) {
  cat(sprintf("  %d. %s: %.1fpp\n", i, mm_range$att_label[i], mm_range$mm_range[i] * 100))
}
cat(sprintf("Gap rank1-rank2: %.1fpp\n", gap_1_2))
