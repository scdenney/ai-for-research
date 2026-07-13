#!/usr/bin/env Rscript
# Orchestration Lab demo — efficiency charts (Anthropic arms only)
# Produces: eff-cost.png, eff-time.png, eff-quality.png
# Outputs copied to both analysis/figures/ and docs/assets/orchestration-lab/
#
# Sources: cost (USD), minutes, and tokens from the claude -p JSON envelopes
# (fable + opus RE-RUN 2026-07-13 on the recalibrated v2.17.0 skill; advisor
# and Codex unchanged from 2026-07-12; advisor rows sum the solve + revise
# envelopes and their minutes include the unmetered consult) and from
# SCORING.md (items met of 6; bands are categorical, the fraction is their
# chart representation). The token column is "tokens processed, excluding
# cached reads" = input + cache_creation + output for the Claude arms (cache
# reads are cheap reused context and would otherwise dwarf the comparison);
# for the Codex arm it is the CLI's single total-tokens figure, its only
# number. This is the one unit shared by all four arms.

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
  data.frame(mode = "Fable lead",    brief = "T1", cost_usd = 0.91, minutes = 3.7,  out_tokens = 37000,  items = 4),
  data.frame(mode = "Fable lead",    brief = "T2", cost_usd = 0.50, minutes = 1.6,  out_tokens = 34700,  items = 5),
  data.frame(mode = "Fable lead",    brief = "T3", cost_usd = 1.18, minutes = 3.8,  out_tokens = 64700,  items = 5),
  data.frame(mode = "Fable lead",    brief = "H",  cost_usd = 1.93, minutes = 6.4,  out_tokens = 73300,  items = 6),
  data.frame(mode = "Fable lead",    brief = "VH", cost_usd = 3.46, minutes = 19.0, out_tokens = 126000, items = 6),
  data.frame(mode = "Opus lead",     brief = "T1", cost_usd = 1.08, minutes = 4.8,  out_tokens = 55100,  items = 6),
  data.frame(mode = "Opus lead",     brief = "T2", cost_usd = 1.23, minutes = 5.0,  out_tokens = 71200,  items = 6),
  data.frame(mode = "Opus lead",     brief = "T3", cost_usd = 5.19, minutes = 33.7, out_tokens = 224700, items = 5),
  data.frame(mode = "Opus lead",     brief = "H",  cost_usd = 2.12, minutes = 8.2,  out_tokens = 99100,  items = 6),
  data.frame(mode = "Opus lead",     brief = "VH", cost_usd = 3.36, minutes = 2.3,  out_tokens = 18500,  items = 6),
  data.frame(mode = "Advisor", brief = "T1", cost_usd = 4.99, minutes = 20.8, out_tokens = 196800, items = 6),
  data.frame(mode = "Advisor", brief = "T2", cost_usd = 1.65, minutes = 13.4, out_tokens = 73100,  items = 5),
  data.frame(mode = "Advisor", brief = "T3", cost_usd = 7.08, minutes = 15.9, out_tokens = 160600, items = 6),
  data.frame(mode = "Advisor", brief = "H",  cost_usd = 1.09, minutes = 8.4,  out_tokens = 89700,  items = 6),
  data.frame(mode = "Advisor", brief = "VH", cost_usd = 3.36, minutes = 18.3, out_tokens = 212300, items = 6),
  # Codex arm (2026-07-12; unaffected by the recalibration — headless = the
  # Terra-lead fallback either way, so not re-run). out_tokens is the CLI's
  # single total-tokens figure (no input/output breakdown; no USD reported).
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

# ---- Chart 1: tokens by brief, all four arms on one unit ----
# One unit so the Codex arm sits with the rest. For the Claude arms this is
# output (generated) tokens from the run envelope; the Codex CLI reports only a
# single total-tokens figure, shown as-is. Neither counts Claude Code's
# cached-context reads (billed at a fraction, and millions per run), which would
# otherwise dwarf the comparison. USD is labeled on the Claude bars where the
# CLI reports it; the Codex CLI reports no dollars.
tok_dodge <- position_dodge2(width = 0.85, preserve = "single")
df$tok_k <- df$out_tokens / 1000
df$usd_lab <- ifelse(is.na(df$cost_usd), "",
                     paste0("$", formatC(df$cost_usd, format = "f", digits = 2)))

p_cost <- ggplot(df, aes(x = brief, y = tok_k, fill = mode)) +
  geom_col(position = tok_dodge, width = 0.78) +
  geom_text(aes(label = usd_lab), position = tok_dodge,
            vjust = -0.45, size = 2.5, colour = "grey25") +
  scale_fill_manual(values = pal, breaks = mode_levels) +
  scale_x_discrete(labels = brief_labels, drop = FALSE) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.10))) +
  labs(x = NULL, y = "Tokens per run (thousands)") +
  theme_demo +
  theme(axis.text.x = element_text(size = 9))

save_png(p_cost, "eff-cost.png", width_in = 9, height_in = 5)

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
