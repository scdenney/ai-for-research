#!/usr/bin/env Rscript
# Orchestration Lab demo — efficiency charts (Anthropic arms only)
# Produces: eff-cost.png, eff-time.png, eff-quality.png
# Outputs copied to both analysis/figures/ and docs/assets/orchestration-lab/
#
# Sources: every number below is copied from the run-logs (cost, minutes,
# output tokens, from the claude -p JSON envelopes; advisor rows sum the
# solve + revise envelopes and their minutes include the unmetered consult)
# and from SCORING.md (items met of 6; bands are categorical, the fraction
# is their chart representation).

suppressPackageStartupMessages({
  library(ggplot2)
})

# ---- site palette ----
pal <- c(
  "Light lead (fable)" = "#1F4E9B",
  "Heavy lead (opus)"  = "#E0A526",
  "One consult (advisor)" = "#2C7A4B"
)

mode_levels <- c("Light lead (fable)", "Heavy lead (opus)", "One consult (advisor)")

brief_levels <- c("T1", "T2", "T3", "H", "VH")
brief_labels <- c(
  "T1" = "Describe\n(easy)",
  "T2" = "Estimate\n(standard)",
  "T3" = "Reviewer reply\n(hard)",
  "H"  = "IV replication\n(high)",
  "VH" = "Methods dispute\n(very high)"
)

# ---- shared theme ----
theme_demo <- theme_minimal(base_size = 15) +
  theme(
    legend.position = "top",
    legend.title = element_blank(),
    legend.text = element_text(size = 12),
    axis.title = element_text(size = 13),
    panel.grid.minor = element_blank(),
    plot.margin = margin(6, 10, 6, 6)
  )

# ---- data (captured-run numbers) ----
df <- rbind(
  data.frame(mode = "Light lead (fable)",    brief = "T1", cost_usd = 1.88, minutes = 3.4,  out_tokens = 5100,  items = 5),
  data.frame(mode = "Light lead (fable)",    brief = "T2", cost_usd = 2.27, minutes = 5.0,  out_tokens = 8000,  items = 5),
  data.frame(mode = "Light lead (fable)",    brief = "T3", cost_usd = 4.13, minutes = 13.2, out_tokens = 12700, items = 4),
  data.frame(mode = "Light lead (fable)",    brief = "H",  cost_usd = 1.00, minutes = 3.5,  out_tokens = 9256,  items = 6),
  data.frame(mode = "Light lead (fable)",    brief = "VH", cost_usd = 1.83, minutes = 8.1,  out_tokens = 9732,  items = 6),
  data.frame(mode = "Heavy lead (opus)",     brief = "T1", cost_usd = 2.26, minutes = 9.9,  out_tokens = 25800, items = 6),
  data.frame(mode = "Heavy lead (opus)",     brief = "T2", cost_usd = 2.14, minutes = 12.9, out_tokens = 35800, items = 6),
  data.frame(mode = "Heavy lead (opus)",     brief = "T3", cost_usd = 6.73, minutes = 24.5, out_tokens = 84800, items = 5),
  data.frame(mode = "Heavy lead (opus)",     brief = "H",  cost_usd = 1.60, minutes = 6.2,  out_tokens = 22940, items = 6),
  data.frame(mode = "Heavy lead (opus)",     brief = "VH", cost_usd = 5.01, minutes = 3.8,  out_tokens = 15723, items = 6),
  data.frame(mode = "One consult (advisor)", brief = "T1", cost_usd = 4.99, minutes = 20.8, out_tokens = 45832, items = 6),
  data.frame(mode = "One consult (advisor)", brief = "T2", cost_usd = 1.65, minutes = 13.4, out_tokens = 10262, items = 5),
  data.frame(mode = "One consult (advisor)", brief = "T3", cost_usd = 7.08, minutes = 15.9, out_tokens = 45500, items = 6),
  data.frame(mode = "One consult (advisor)", brief = "H",  cost_usd = 1.09, minutes = 8.4,  out_tokens = 15768, items = 6),
  data.frame(mode = "One consult (advisor)", brief = "VH", cost_usd = 3.36, minutes = 18.3, out_tokens = 56552, items = 6)
)

df$mode <- factor(df$mode, levels = mode_levels)
df$brief <- factor(df$brief, levels = brief_levels)
df$score <- df$items / 6

df <- df[!is.na(df$cost_usd), ]

out_dirs <- c(
  "/Users/scdenney/Documents/github/resources/ai-for-research/demos/orchestration-lab/analysis/figures",
  "/Users/scdenney/Documents/github/resources/ai-for-research/docs/assets/orchestration-lab"
)
for (d in out_dirs) dir.create(d, recursive = TRUE, showWarnings = FALSE)

save_png <- function(plot, filename, width_in = 8, height_in = 4.5, dpi = 300) {
  for (d in out_dirs) {
    ggsave(
      filename = file.path(d, filename),
      plot = plot,
      width = width_in,
      height = height_in,
      dpi = dpi,
      units = "in"
    )
  }
}

# ---- Chart 1: cost by brief, grouped bars ----
p_cost <- ggplot(df, aes(x = brief, y = cost_usd, fill = mode)) +
  geom_col(position = position_dodge2(width = 0.8, preserve = "single"), width = 0.7) +
  scale_fill_manual(values = pal, breaks = mode_levels) +
  scale_x_discrete(labels = brief_labels, drop = FALSE) +
  labs(x = NULL, y = "API-equivalent cost (USD)") +
  theme_demo

save_png(p_cost, "eff-cost.png")

# ---- Chart 2: wall-clock minutes by brief, grouped bars ----
p_time <- ggplot(df, aes(x = brief, y = minutes, fill = mode)) +
  geom_col(position = position_dodge2(width = 0.8, preserve = "single"), width = 0.7) +
  scale_fill_manual(values = pal, breaks = mode_levels) +
  scale_x_discrete(labels = brief_labels, drop = FALSE) +
  labs(x = NULL, y = "Wall-clock (minutes)") +
  theme_demo

save_png(p_time, "eff-time.png")

# ---- Chart 3: rubric score against the band thresholds ----
# Dotted lines mark the three bands (SCORING.md): every brief is graded on
# six binary items (4 core, 1 judgment, 1 completeness), so 4/6 = Pass,
# 5/6 = Pass+, 6/6 = Distinction, one shared axis for all briefs.
thresholds <- data.frame(
  score = c(4 / 6, 5 / 6, 1),
  band = c("Pass", "Pass+", "Distinction")
)

dodge <- position_dodge(width = 0.4)

p_quality <- ggplot(df, aes(x = brief, y = score, color = mode, group = mode)) +
  geom_hline(
    data = thresholds, aes(yintercept = score),
    linetype = "dotted", color = "grey45", linewidth = 0.55
  ) +
  geom_line(position = dodge, linewidth = 0.55, alpha = 0.45) +
  geom_point(position = dodge, size = 3.4) +
  scale_color_manual(values = pal, breaks = mode_levels) +
  scale_x_discrete(labels = brief_labels, drop = FALSE) +
  scale_y_continuous(
    limits = c(0.58, 1.04),
    breaks = thresholds$score,
    labels = c("4 of 6", "5 of 6", "6 of 6"),
    sec.axis = dup_axis(
      breaks = thresholds$score,
      labels = thresholds$band,
      name = NULL
    )
  ) +
  labs(x = NULL, y = "Rubric items met") +
  theme_demo +
  theme(axis.ticks.y.right = element_blank())

save_png(p_quality, "eff-quality.png")

cat("Done.\n")
