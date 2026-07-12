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
  "Fable lead" = "#1F4E9B",
  "Opus lead"  = "#E0A526",
  "Advisor"    = "#2C7A4B",
  "Codex lead" = "#A85632"
)

mode_levels <- c("Fable lead", "Opus lead", "Advisor", "Codex lead")

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
  data.frame(mode = "Fable lead",    brief = "T1", cost_usd = 1.88, minutes = 3.4,  out_tokens = 5100,  items = 5),
  data.frame(mode = "Fable lead",    brief = "T2", cost_usd = 2.27, minutes = 5.0,  out_tokens = 8000,  items = 5),
  data.frame(mode = "Fable lead",    brief = "T3", cost_usd = 4.13, minutes = 13.2, out_tokens = 12700, items = 4),
  data.frame(mode = "Fable lead",    brief = "H",  cost_usd = 1.00, minutes = 3.5,  out_tokens = 9256,  items = 6),
  data.frame(mode = "Fable lead",    brief = "VH", cost_usd = 1.83, minutes = 8.1,  out_tokens = 9732,  items = 6),
  data.frame(mode = "Opus lead",     brief = "T1", cost_usd = 2.26, minutes = 9.9,  out_tokens = 25800, items = 6),
  data.frame(mode = "Opus lead",     brief = "T2", cost_usd = 2.14, minutes = 12.9, out_tokens = 35800, items = 6),
  data.frame(mode = "Opus lead",     brief = "T3", cost_usd = 6.73, minutes = 24.5, out_tokens = 84800, items = 5),
  data.frame(mode = "Opus lead",     brief = "H",  cost_usd = 1.60, minutes = 6.2,  out_tokens = 22940, items = 6),
  data.frame(mode = "Opus lead",     brief = "VH", cost_usd = 5.01, minutes = 3.8,  out_tokens = 15723, items = 6),
  data.frame(mode = "Advisor", brief = "T1", cost_usd = 4.99, minutes = 20.8, out_tokens = 45832, items = 6),
  data.frame(mode = "Advisor", brief = "T2", cost_usd = 1.65, minutes = 13.4, out_tokens = 10262, items = 5),
  data.frame(mode = "Advisor", brief = "T3", cost_usd = 7.08, minutes = 15.9, out_tokens = 45500, items = 6),
  data.frame(mode = "Advisor", brief = "H",  cost_usd = 1.09, minutes = 8.4,  out_tokens = 15768, items = 6),
  data.frame(mode = "Advisor", brief = "VH", cost_usd = 3.36, minutes = 18.3, out_tokens = 56552, items = 6),
  # Codex arm (2026-07-12 re-run): the CLI reports tokens, not USD, so cost_usd
  # is NA and these rows drop out of the cost chart only. out_tokens here is the
  # CLI's total tokens-used figure, not comparable to the Claude columns.
  data.frame(mode = "Codex lead",       brief = "T1", cost_usd = NA,   minutes = 3.3,  out_tokens = 64057, items = 4),
  data.frame(mode = "Codex lead",       brief = "T2", cost_usd = NA,   minutes = 4.1,  out_tokens = 63539, items = 5),
  data.frame(mode = "Codex lead",       brief = "T3", cost_usd = NA,   minutes = 3.9,  out_tokens = 92446, items = 4),
  data.frame(mode = "Codex lead",       brief = "H",  cost_usd = NA,   minutes = 4.8,  out_tokens = 46016, items = 5),
  data.frame(mode = "Codex lead",       brief = "VH", cost_usd = NA,   minutes = 3.6,  out_tokens = 74658, items = 6)
)

df$mode <- factor(df$mode, levels = mode_levels)
df$brief <- factor(df$brief, levels = brief_levels)
df$score <- df$items / 6
# 46/high-ajr met core + completeness but missed the judgment item, so its
# fraction (5/6) sits at the Pass+ line while its band is Pass (SCORING.md).
# Drawn hollow to mark the one fraction-above-band case.
df$band_matches <- !(df$mode == "Codex lead" & df$brief == "H")

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

# ---- Chart 1: spend by brief, all four arms ----
# The Claude CLI prices its runs in USD; the Codex CLI reports a token count
# and no dollars, and cross-vendor token counts are not comparable. So one
# figure, two panels, each in its own honest unit.
df_usd <- df[!is.na(df$cost_usd), ]
df_usd$metric <- "Claude arms: API-equivalent cost (USD)"
df_usd$value <- df_usd$cost_usd
df_tok <- df[df$mode == "Codex lead", ]
df_tok$metric <- "Codex arm: tokens (thousands)"
df_tok$value <- df_tok$out_tokens / 1000
df_cost <- rbind(df_usd, df_tok)
df_cost$metric <- factor(df_cost$metric, levels = c(
  "Claude arms: API-equivalent cost (USD)",
  "Codex arm: tokens (thousands)"
))

p_cost <- ggplot(df_cost, aes(x = brief, y = value, fill = mode)) +
  geom_col(position = position_dodge2(width = 0.8, preserve = "single"), width = 0.7) +
  facet_wrap(~metric, scales = "free_y") +
  scale_fill_manual(values = pal, breaks = mode_levels) +
  scale_x_discrete(labels = brief_labels, drop = FALSE) +
  labs(x = NULL, y = NULL) +
  theme_demo +
  theme(
    axis.text.x = element_text(size = 8.5),
    strip.text = element_text(size = 11.5, face = "bold")
  )

save_png(p_cost, "eff-cost.png", width_in = 9.5, height_in = 4.5)

# ---- Chart 2: wall-clock minutes by brief, grouped bars ----
p_time <- ggplot(df, aes(x = brief, y = minutes, fill = mode)) +
  geom_col(position = position_dodge2(width = 0.8, preserve = "single"), width = 0.7) +
  scale_fill_manual(values = pal, breaks = mode_levels) +
  scale_x_discrete(labels = brief_labels, drop = FALSE) +
  labs(x = NULL, y = "Wall-clock (minutes)") +
  theme_demo

save_png(p_time, "eff-time.png")

# ---- Chart 3: rubric score against the band thresholds, one panel per arm ----
# Dotted lines mark the three bands (SCORING.md): every brief is graded on
# six binary items (4 core, 1 judgment, 1 completeness), so 4/6 = Pass,
# 5/6 = Pass+, 6/6 = Distinction, one shared axis for all briefs. Four arms on
# one axis overlap badly, so each arm gets its own panel; the dotted lines are
# repeated in every panel so a reader can place any point without cross-panel
# comparison.
thresholds <- data.frame(
  score = c(4 / 6, 5 / 6, 1),
  band = c("Pass", "Pass+", "Distinction")
)

df$mode <- factor(df$mode, levels = mode_levels)

p_quality <- ggplot(df, aes(x = brief, y = score, color = mode, group = mode)) +
  geom_hline(
    data = thresholds, aes(yintercept = score),
    linetype = "dotted", color = "grey55", linewidth = 0.5
  ) +
  geom_line(linewidth = 0.7) +
  geom_point(data = df[df$band_matches, ], size = 3.6) +
  geom_point(
    data = df[!df$band_matches, ],
    size = 3.6, shape = 21, fill = "white", stroke = 1.3
  ) +
  facet_wrap(~mode, nrow = 2) +
  scale_color_manual(values = pal, breaks = mode_levels, guide = "none") +
  scale_x_discrete(labels = brief_labels, drop = FALSE) +
  scale_y_continuous(
    limits = c(0.60, 1.02),
    breaks = thresholds$score,
    labels = c("Pass\n(4 of 6)", "Pass+\n(5 of 6)", "Distinction\n(6 of 6)")
  ) +
  labs(x = NULL, y = NULL) +
  theme_demo +
  theme(
    strip.text = element_text(size = 12, face = "bold"),
    axis.text.x = element_text(size = 8),
    axis.text.y = element_text(size = 9.5),
    panel.spacing.x = unit(1.1, "lines"),
    panel.spacing.y = unit(0.9, "lines")
  )

save_png(p_quality, "eff-quality.png", width_in = 9, height_in = 6)

cat("Done.\n")
