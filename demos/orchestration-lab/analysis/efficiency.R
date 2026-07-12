#!/usr/bin/env Rscript
# Orchestration Lab demo — efficiency charts (Anthropic arms only)
# Produces: eff-cost.png, eff-time.png, eff-quality.png
# Outputs copied to both analysis/figures/ and docs/assets/orchestration-lab/

suppressPackageStartupMessages({
  library(ggplot2)
})

# ---- Okabe-Ito palette (consistent across all charts) ----
pal <- c(
  "fable-orchestrate" = "#E69F00",
  "opus-orchestrate"  = "#56B4E9",
  "advisor (Fable consult)" = "#009E73"
)

mode_levels <- c("fable-orchestrate", "opus-orchestrate", "advisor (Fable consult)")

# ---- shared theme ----
theme_demo <- theme_minimal(base_size = 22) +
  theme(
    legend.position = "top",
    legend.title = element_blank(),
    panel.grid.minor = element_blank(),
    plot.margin = margin(10, 16, 10, 10)
  )

# ---- data (captured-run numbers) ----
df <- data.frame(
  mode = c(
    "fable-orchestrate", "fable-orchestrate", "fable-orchestrate",
    "opus-orchestrate", "opus-orchestrate", "opus-orchestrate",
    "advisor (Fable consult)"
  ),
  tier = c("T1", "T2", "T3", "T1", "T2", "T3", "T3"),
  cost_usd = c(1.88, 2.27, 4.13, 2.26, 2.14, 6.73, 7.08),
  minutes = c(3.4, 5.0, 13.2, 9.9, 12.9, 24.5, 15.9),
  out_tokens = c(5100, 8000, 12700, 25800, 35800, 84800, 45500),
  verdict = c("Pass", "Pass", "Pass", "Pass", "Pass", "Pass+", "Distinction"),
  stringsAsFactors = FALSE
)

df$mode <- factor(df$mode, levels = mode_levels)
df$tier <- factor(df$tier, levels = c("T1", "T2", "T3"))

out_dirs <- c(
  "/Users/scdenney/Documents/github/resources/ai-for-research/demos/orchestration-lab/analysis/figures",
  "/Users/scdenney/Documents/github/resources/ai-for-research/docs/assets/orchestration-lab"
)
for (d in out_dirs) dir.create(d, recursive = TRUE, showWarnings = FALSE)

save_png <- function(plot, filename, width_px = 2400, height_px = 1500, dpi = 300) {
  for (d in out_dirs) {
    ggsave(
      filename = file.path(d, filename),
      plot = plot,
      width = width_px / dpi,
      height = height_px / dpi,
      dpi = dpi,
      units = "in"
    )
  }
}

# ---- Chart 1: cost by tier, grouped bars ----
p_cost <- ggplot(df, aes(x = tier, y = cost_usd, fill = mode)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.7) +
  scale_fill_manual(values = pal, breaks = mode_levels) +
  labs(x = "Tier", y = "API-equivalent cost (USD)") +
  theme_demo

save_png(p_cost, "eff-cost.png")

# ---- Chart 2: wall-clock minutes by tier, grouped bars ----
p_time <- ggplot(df, aes(x = tier, y = minutes, fill = mode)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.7) +
  scale_fill_manual(values = pal, breaks = mode_levels) +
  labs(x = "Tier", y = "Wall-clock (minutes)") +
  theme_demo

save_png(p_time, "eff-time.png")

# ---- Chart 3: T3 only, cost vs. verdict, ordered factor ----
df_t3 <- subset(df, tier == "T3")
df_t3$verdict <- factor(df_t3$verdict, levels = c("Pass", "Pass+", "Distinction"), ordered = TRUE)

p_quality <- ggplot(df_t3, aes(x = cost_usd, y = verdict, color = mode)) +
  geom_point(size = 6) +
  geom_text(aes(label = mode), nudge_y = 0.15, size = 6, show.legend = FALSE) +
  scale_color_manual(values = pal, breaks = mode_levels) +
  scale_x_continuous(limits = c(0, 8)) +
  labs(x = "API-equivalent cost (USD)", y = "Judgment verdict (T3)") +
  theme_demo

save_png(p_quality, "eff-quality.png")

cat("Done.\n")
