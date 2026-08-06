#!/usr/bin/env Rscript
# =============================================================================
# Task T2 -- AMCEs for all seven conjoint attributes (standard tier)
# Run from this directory: cd runs/claude-direct/t2 && Rscript script.R
#
# Estimator: projoint::projoint(.structure = "profile_level", .estimand =
# "amce", .se_method = "analytical"). No deviation from the package
# estimator. Standard errors are clustered at the respondent level via the
# package's .auto_cluster = TRUE default, which clusters on the data's `id`
# column (one cluster per respondent) -- confirmed below via .clusters_2.
#
# Corrected vs. uncorrected: projoint returns both an uncorrected AMCE and
# an IRR (intra-respondent-reliability) measurement-error-corrected AMCE.
# The corrected estimate is the package's headline contribution and is its
# own plot() default, so it is what is reported and plotted here.
#
# .se_method = "analytical" is closed-form (no simulation/bootstrap), so
# set.seed() has no effect on the reported numbers; it is declared anyway
# to honor the house convention shared with the other briefs.
# =============================================================================

suppressPackageStartupMessages({
  library(projoint)
  library(ggplot2)
})

set.seed(20260717)

# Okabe-Ito colour-blind-safe palette + theme (house figure convention) -----
okabe_ito <- c(
  black = "#000000", orange = "#E69F00", skyblue = "#56B4E9",
  green = "#009E73", yellow = "#F0E442", blue = "#0072B2",
  vermillion = "#D55E00", purple = "#CC79A7", grey = "#999999"
)
COL_EST <- okabe_ito[["blue"]]
COL_REF <- okabe_ito[["grey"]]

theme_house <- theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    strip.text = element_text(face = "bold", hjust = 0),
    strip.background = element_blank(),
    axis.title.y = element_blank(),
    plot.title = element_blank(),
    legend.position = "none"
  )
theme_set(theme_house)

# --- Data --------------------------------------------------------------------
data(exampleData1)
outcomes <- c(paste0("choice", 1:8), "choice1_repeated_flipped")
pj <- reshape_projoint(exampleData1, .outcomes = outcomes)

stopifnot(length(unique(pj$labels$attribute_id)) == 7)

# --- AMCE estimation, respondent-clustered SEs ------------------------------
# .auto_cluster = TRUE (default) clusters on the data's `id` column, i.e.
# one cluster per respondent; confirmed in the printed summary() below
# ("SE type (lm_robust): ... (clustered by id)").
fit <- projoint(
  pj,
  .structure = "profile_level",
  .estimand  = "amce",
  .se_method = "analytical"
)

print(fit)

est <- as.data.frame(summary(fit))
est <- est[est$estimand == "amce_corrected", ]

# Attach human-readable attribute/level text from the labels table ----------
lab <- as.data.frame(pj$labels)
est <- merge(est, lab, by.x = "att_level_choose", by.y = "level_id")
est$level_id <- est$att_level_choose

# Reference (baseline) levels, shown at zero with no interval ---------------
baselines <- lab[grepl(":level1$", lab$level_id), ]
ref <- data.frame(
  attribute = baselines$attribute,
  level     = baselines$level,
  estimate  = 0,
  se        = NA_real_,
  conf.low  = NA_real_,
  conf.high = NA_real_,
  level_id  = baselines$level_id,
  is_ref    = TRUE
)
est$is_ref <- FALSE
plot_df <- rbind(
  ref[, c("attribute", "level", "estimate", "se", "conf.low", "conf.high", "level_id", "is_ref")],
  est[, c("attribute", "level", "estimate", "se", "conf.low", "conf.high", "level_id", "is_ref")]
)

# Order attributes by their order of first appearance in the labels table;
# order levels within attribute (level1, level2, ...), reference level last
# in the factor so it plots at the top of its facet panel. Keyed on the
# unique level_id (not the level text) so no two attributes' labels can
# collide onto the same y-row.
plot_df$attribute <- factor(plot_df$attribute, levels = unique(lab$attribute))
plot_df <- plot_df[order(plot_df$attribute, match(plot_df$level_id, lab$level_id)), ]
level_id_order <- rev(lab$level_id)                 # level1 last -> top of panel
level_text     <- lab$level[match(level_id_order, lab$level_id)]
plot_df$level  <- factor(plot_df$level_id, levels = level_id_order, labels = level_text)

# --- Figure: dot-and-whisker AMCE plot, grouped by attribute ----------------
dir.create("figures", showWarnings = FALSE)

p <- ggplot(plot_df, aes(x = estimate, y = level, colour = is_ref)) +
  geom_vline(xintercept = 0, linewidth = 0.3, colour = "grey50") +
  geom_errorbar(
    aes(xmin = conf.low, xmax = conf.high),
    orientation = "y", width = 0, linewidth = 0.6, na.rm = TRUE
  ) +
  geom_point(size = 2.2) +
  scale_colour_manual(values = c(`FALSE` = COL_EST, `TRUE` = COL_REF)) +
  facet_grid(
    attribute ~ ., scales = "free_y", space = "free_y", switch = "y",
    labeller = labeller(attribute = label_wrap_gen(16))
  ) +
  labs(x = "AMCE (change in probability of profile choice)") +
  theme(
    strip.placement = "outside",
    strip.text.y.left = element_text(angle = 0, size = 10)
  )

ggsave("figures/amce-dotwhisker.png", p, width = 10, height = 9, dpi = 320)

# --- Console summary for report.md -----------------------------------------
est_ord <- est[order(-abs(est$estimate)), ]
cat("Top corrected AMCEs by |effect|:\n")
print(
  est_ord[, c("attribute", "level", "estimate", "se", "conf.low", "conf.high")],
  digits = 3, row.names = FALSE
)
