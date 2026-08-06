#!/usr/bin/env Rscript
# Orchestration Lab demo — efficiency charts (Anthropic arms, plus both Codex arms)
# Produces: eff-tokens.png, eff-time.png, eff-quality.png
# Outputs copied to both analysis/figures/ and docs/assets/orchestration-lab/
#
# 2026-07-19 token-methodology correction. `tok_full` is full cumulative
# usage, computed identically on both platforms: Claude = input_tokens +
# cache_creation_input_tokens + cache_read_input_tokens + output_tokens, from
# each run's own claude-envelope.json (Advisor (Claude) sums solve + revise
# envelopes). Codex = input_tokens + cached_input_tokens + output_tokens,
# from each run's own JSONL turn.completed usage event (Advisor (Codex) sums
# the solve + revise steps; Codex lead is one continuous session).
#
# This replaces two earlier, wrong versions of this column, both caught this
# session: (1) the original Claude figures used output_tokens only, excluding
# all input and cache activity; (2) a same-session "fix" to that bug computed
# Codex's total as input + output only, silently missing cached_input_tokens
# — so the two sides were still not measured the same way, just differently
# wrong. A further attempt to exclude cache reads entirely ("fresh tokens
# only," to avoid rewarding whichever platform's prompt cache happens to hit
# more often) was tried and rejected: it does not remove a distortion, it
# introduces a different one, since cache-hit rate is an implementation
# detail of each CLI's context management, not a measure of how much
# reasoning happened. Cache reads are also not free — both vendors bill a
# steep-discount rate for them, not zero — so excluding them entirely
# understates real resource use on both sides. Full cumulative, computed
# identically, is the number that actually reconciles with reported dollar
# cost on the Claude side and is the most defensible single "tokens used to
# do the work" figure available from either platform's own primary output.
#
# The corrected result overturns the mid-session "1.7-2x" framing, which was
# itself downstream of bug (2) above (undercounting Codex). Properly
# symmetric, the token gap runs roughly 3-4x in aggregate, and the biggest
# consumer is not the arm most readers would guess: Advisor (Claude)'s total
# (28.6M full-cumulative tokens across six briefs) exceeds Codex lead's
# (24.2M), driven by cache-read growth across its two-call solve+revise
# protocol on long agentic sessions. See RESULTS.md's token-accounting
# section for the full per-tier table and discussion.
#
# Items-met (of 6) are current as of the 2026-07-19 xhigh reruns for Codex
# lead and Advisor (Codex) (see RESULTS.md/SCORING.md's 2026-07-19 sections);
# Fable, Opus, and Advisor (Claude) are unchanged from the 2026-07-17 full
# ladder rerun. `band_matches` is FALSE for the two points whose raw item
# count does not predict their actual categorical band (a missed judgment or
# core item can cap a band below what the fraction alone implies) — those
# points render as hollow markers in the quality chart. One point,
# `Advisor (Codex) / extreme-stagdid`, is a real Fail, off this chart's
# Pass-to-Distinction scale entirely; it gets a direct text annotation rather
# than an axis redesign.
#
# No dollar figure is computed or shown for either Codex arm: neither ran
# under per-token billing, both were interactive/headless CLI sessions under
# a subscription, so an estimated dollar total would describe money that was
# never actually spent. Tokens are the only real, reported, comparable
# quantity for those two arms.

suppressPackageStartupMessages({
  library(ggplot2)
})

# ---- site palette ----
# Claude-side arms in blue/gold/green; Codex-side arms in two rust shades.
pal <- c(
  "Fable lead"       = "#1F4E9B",
  "Opus lead"        = "#E0A526",
  "Advisor (Claude)" = "#2C7A4B",
  "Advisor (Codex)"  = "#C97B4A",
  "Codex lead"       = "#A85632"
)

mode_levels <- c("Fable lead", "Opus lead", "Advisor (Claude)", "Advisor (Codex)", "Codex lead")

brief_levels <- c("T1", "T2", "T3", "H", "VH", "EX")
brief_labels <- c(
  "T1" = "Describe\n(easy)",
  "T2" = "Estimate\n(standard)",
  "T3" = "Reviewer reply\n(moderate)",
  "H"  = "IV replication\n(hard)",
  "VH" = "Methods dispute\n(very hard)",
  "EX" = "Staggered-DiD\n(extreme)"
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

# ---- data (2026-07-19 correction: tok_full computed identically on both
# platforms for every arm; Codex lead and Advisor (Codex) items/bands are the
# xhigh-rerun scores; band_matches flags the two points whose raw item count
# does not predict their actual band) ----
df <- rbind(
  data.frame(mode = "Fable lead",    brief = "T1", cost_usd = 1.17, minutes = 2.1,  tok_full = 1007020, items = 6),
  data.frame(mode = "Fable lead",    brief = "T2", cost_usd = 0.98, minutes = 1.1,  tok_full = 487678,  items = 5),
  data.frame(mode = "Fable lead",    brief = "T3", cost_usd = 2.60, minutes = 0.6,  tok_full = 350922,  items = 6),
  data.frame(mode = "Fable lead",    brief = "H",  cost_usd = 1.17, minutes = 5.0,  tok_full = 1079493, items = 6),
  data.frame(mode = "Fable lead",    brief = "VH", cost_usd = 1.98, minutes = 7.6,  tok_full = 3021233, items = 6),
  data.frame(mode = "Fable lead",    brief = "EX", cost_usd = 1.07, minutes = 5.8,  tok_full = 554858,  items = 6),
  data.frame(mode = "Opus lead",     brief = "T1", cost_usd = 1.59, minutes = 6.2,  tok_full = 848895,  items = 4),
  data.frame(mode = "Opus lead",     brief = "T2", cost_usd = 2.81, minutes = 15.8, tok_full = 1193409, items = 6),
  data.frame(mode = "Opus lead",     brief = "T3", cost_usd = 3.26, minutes = 14.5, tok_full = 1775225, items = 6),
  data.frame(mode = "Opus lead",     brief = "H",  cost_usd = 2.00, minutes = 7.4,  tok_full = 853224,  items = 6),
  data.frame(mode = "Opus lead",     brief = "VH", cost_usd = 2.14, minutes = 11.1, tok_full = 1185025, items = 6),
  data.frame(mode = "Opus lead",     brief = "EX", cost_usd = 2.79, minutes = 11.1, tok_full = 1709463, items = 6),
  data.frame(mode = "Advisor (Claude)", brief = "T1", cost_usd = 4.99, minutes = 17.9, tok_full = 4974856, items = 6),
  data.frame(mode = "Advisor (Claude)", brief = "T2", cost_usd = 2.59, minutes = 10.4, tok_full = 4113544, items = 6),
  data.frame(mode = "Advisor (Claude)", brief = "T3", cost_usd = 3.97, minutes = 6.6,  tok_full = 8316681, items = 5),
  data.frame(mode = "Advisor (Claude)", brief = "H",  cost_usd = 1.90, minutes = 7.1,  tok_full = 2896039, items = 6),
  data.frame(mode = "Advisor (Claude)", brief = "VH", cost_usd = 2.93, minutes = 12.6, tok_full = 4739756, items = 6),
  data.frame(mode = "Advisor (Claude)", brief = "EX", cost_usd = 2.28, minutes = 17.9, tok_full = 3539709, items = 6),
  # Advisor (Codex) = runs/advisor-v2/*-codex/ (xhigh rerun). tok_full sums
  # the solve + revise steps' turn.completed usage (input + cached + output).
  # No USD reported by the Codex CLI. Items/bands from SCORING.md's
  # 2026-07-19 retro-scores. VH's band (Pass) is capped below what its 5/6
  # raw fraction implies (misses the judgment item, not a core item) — flagged
  # below. EX is a real Fail, not a Pass — flagged and annotated below.
  data.frame(mode = "Advisor (Codex)", brief = "T1", cost_usd = NA, minutes = NA, tok_full = 1357349, items = 6),
  data.frame(mode = "Advisor (Codex)", brief = "T2", cost_usd = NA, minutes = NA, tok_full = 2538453, items = 5),
  data.frame(mode = "Advisor (Codex)", brief = "T3", cost_usd = NA, minutes = NA, tok_full = 5719734, items = 5),
  data.frame(mode = "Advisor (Codex)", brief = "H",  cost_usd = NA, minutes = NA, tok_full = 1040712, items = 6),
  data.frame(mode = "Advisor (Codex)", brief = "VH", cost_usd = NA, minutes = NA, tok_full = 5179597, items = 5),
  data.frame(mode = "Advisor (Codex)", brief = "EX", cost_usd = NA, minutes = NA, tok_full = 2966792, items = 4),
  # Codex lead = the Sol-lead capture, xhigh + genuine Fable cross-vendor peer
  # (2026-07-19 rerun; see RESULTS.md). tok_full is each tier's own JSONL
  # turn.completed usage (input + cached + output), one continuous session.
  # Wall-clock was not consistently recorded for these interactive sessions,
  # so minutes is NA and this arm is absent from the time chart.
  data.frame(mode = "Codex lead",       brief = "T1", cost_usd = NA, minutes = NA,  tok_full = 2087494, items = 6),
  data.frame(mode = "Codex lead",       brief = "T2", cost_usd = NA, minutes = NA,  tok_full = 2365500, items = 5),
  data.frame(mode = "Codex lead",       brief = "T3", cost_usd = NA, minutes = NA,  tok_full = 4401222, items = 6),
  data.frame(mode = "Codex lead",       brief = "H",  cost_usd = NA, minutes = NA,  tok_full = 2656984, items = 6),
  data.frame(mode = "Codex lead",       brief = "VH", cost_usd = NA, minutes = NA,  tok_full = 6976372, items = 6),
  data.frame(mode = "Codex lead",       brief = "EX", cost_usd = NA, minutes = NA,  tok_full = 5740216, items = 6)
)

df$mode <- factor(df$mode, levels = mode_levels)
df$brief <- factor(df$brief, levels = brief_levels)
df$score <- df$items / 6
# Two points whose raw item fraction does not predict their actual band:
# Advisor (Codex)/VH (5 items met, but the missed one is the judgment item,
# capping the band at Pass = 4/6 rather than Pass+); Advisor (Codex)/EX is a
# real Fail (4 items met, but a missed core item means no band is reached at
# all, not Pass). Both render as hollow markers; EX also gets a "FAIL" label
# since a hollow marker alone would still read as a plausible Pass.
df$band_matches <- TRUE
df$band_matches[df$mode == "Advisor (Codex)" & df$brief == "VH"] <- FALSE
df$band_matches[df$mode == "Advisor (Codex)" & df$brief == "EX"] <- FALSE
df$is_fail <- df$mode == "Advisor (Codex)" & df$brief == "EX"

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

# ---- Chart 1: tokens by brief, all five arms — the primary efficiency figure ----
# Bar height is real, reported token volume for every arm — nothing modeled,
# nothing estimated. No dollar figure appears on this chart at all: the two
# Codex arms were not billed per token (subscription CLI sessions), so a
# dollar figure for them would describe a cost that was never actually
# incurred, not a real number. Where a real dollar figure does exist (the
# three Claude arms, CLI-reported), it is in RESULTS.md's cost table and the
# item-per-dollar comparison there, not overlaid on this chart.
tok_dodge <- position_dodge2(width = 0.85, preserve = "single")
df$tok_k <- df$tok_full / 1000
df$is_codex_family <- df$mode %in% c("Advisor (Codex)", "Codex lead")

p_tokens <- ggplot(df, aes(x = brief, y = tok_k, fill = mode)) +
  geom_col(position = tok_dodge, width = 0.78) +
  scale_fill_manual(values = pal, breaks = mode_levels) +
  scale_x_discrete(labels = brief_labels, drop = FALSE) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.10))) +
  labs(x = NULL, y = "Tokens per run (thousands)") +
  theme_demo +
  theme(axis.text.x = element_text(size = 8, angle = 20, hjust = 1))

save_png(p_tokens, "eff-tokens.png", width_in = 10, height_in = 5)

# ---- Chart 2: wall-clock minutes by brief, grouped bars ----
p_time <- ggplot(df, aes(x = brief, y = minutes, fill = mode)) +
  geom_col(position = position_dodge2(width = 0.8, preserve = "single"), width = 0.7) +
  scale_fill_manual(values = pal, breaks = mode_levels) +
  scale_x_discrete(labels = brief_labels, drop = FALSE) +
  labs(x = NULL, y = "Wall-clock (minutes)") +
  theme_demo +
  theme(axis.text.x = element_text(size = 8, angle = 20, hjust = 1))

save_png(p_time, "eff-time.png", width_in = 9, height_in = 5)

# ---- Chart 3: rubric score against the band thresholds, one panel per arm ----
# Dotted lines mark the three bands (SCORING.md): every brief is graded on
# six binary items (4 core, 1 judgment, 1 completeness), so 4/6 = Pass,
# 5/6 = Pass+, 6/6 = Distinction, one shared axis for all briefs. Five arms on
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
  geom_text(
    data = df[df$is_fail, ],
    aes(label = "FAIL"), color = "#B33A3A", fontface = "bold",
    size = 3, vjust = -1.4, show.legend = FALSE
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
    axis.text.x = element_text(size = 7.5, angle = 30, hjust = 1),
    axis.text.y = element_text(size = 9.5),
    panel.spacing.x = unit(1.3, "lines"),
    panel.spacing.y = unit(1.0, "lines")
  )

save_png(p_quality, "eff-quality.png", width_in = 11, height_in = 7.5)

cat("Done.\n")
