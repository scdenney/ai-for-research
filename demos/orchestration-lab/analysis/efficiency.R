#!/usr/bin/env Rscript
# Orchestration Lab demo — efficiency charts (Anthropic arms only)
# Produces: eff-cost.png, eff-time.png, eff-quality.png
# Outputs copied to both analysis/figures/ and docs/assets/orchestration-lab/

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

tier_labels <- c(
  "T1" = "Describe\n(easy)",
  "T2" = "Estimate\n(standard)",
  "T3" = "Reviewer reply\n(hard)"
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
df <- data.frame(
  mode = c(
    "Light lead (fable)", "Light lead (fable)", "Light lead (fable)",
    "Heavy lead (opus)", "Heavy lead (opus)", "Heavy lead (opus)",
    "One consult (advisor)"
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

# ---- Chart 1: cost by tier, grouped bars ----
p_cost <- ggplot(df, aes(x = tier, y = cost_usd, fill = mode)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.7) +
  scale_fill_manual(values = pal, breaks = mode_levels) +
  scale_x_discrete(labels = tier_labels) +
  labs(x = NULL, y = "API-equivalent cost (USD)") +
  theme_demo

save_png(p_cost, "eff-cost.png")

# ---- Chart 2: wall-clock minutes by tier, grouped bars ----
p_time <- ggplot(df, aes(x = tier, y = minutes, fill = mode)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.7) +
  scale_fill_manual(values = pal, breaks = mode_levels) +
  scale_x_discrete(labels = tier_labels) +
  labs(x = NULL, y = "Wall-clock (minutes)") +
  theme_demo

save_png(p_time, "eff-time.png")

# ---- Chart 3: hard tier only, horizontal bars, cost with verdict labels ----
df_t3 <- subset(df, tier == "T3")
mode_order_t3 <- c("One consult (advisor)", "Heavy lead (opus)", "Light lead (fable)")
df_t3$mode <- factor(df_t3$mode, levels = mode_order_t3)

p_quality <- ggplot(df_t3, aes(x = mode, y = cost_usd, fill = mode)) +
  geom_col(width = 0.6) +
  geom_text(aes(label = verdict), hjust = -0.08, fontface = "bold", size = 4.5, show.legend = FALSE) +
  scale_fill_manual(values = pal, breaks = mode_levels) +
  scale_y_continuous(limits = c(0, 8)) +
  coord_flip(clip = "off") +
  labs(x = NULL, y = "API-equivalent cost (USD)") +
  theme_demo +
  theme(legend.position = "none")

save_png(p_quality, "eff-quality.png")

cat("Done.\n")
