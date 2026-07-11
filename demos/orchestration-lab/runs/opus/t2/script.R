# =====================================================================
# T2 — Average Marginal Component Effects (AMCEs) with projoint
# ---------------------------------------------------------------------
# Estimates AMCEs for all seven attributes on profile choice, with
# uncertainty clustered at the respondent level, and draws a grouped
# dot-and-whisker plot. Self-contained: run with `Rscript script.R`.
# =====================================================================

suppressPackageStartupMessages({
  library(projoint)   # v1.1.1 — reshape + measurement-error-corrected AMCEs
  library(dplyr)
  library(ggplot2)
  library(stringr)
})

set.seed(1234)  # set before any stochastic step (IRR estimation is deterministic here)

# ---- Okabe-Ito palette (colour-blind-safe), one colour per attribute ----
okabe_ito <- c(
  "#E69F00", "#56B4E9", "#009E73", "#F0E442",
  "#0072B2", "#D55E00", "#CC79A7", "#000000"
)

# ---- Shared plot theme ----
theme_amce <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor   = element_blank(),
    panel.grid.major.x = element_line(colour = "grey90"),
    axis.title.y       = element_blank(),
    axis.title.x       = element_text(margin = margin(t = 8)),
    strip.placement    = "outside",
    strip.text.y.left  = element_text(angle = 0, hjust = 0, face = "bold", size = 8.5),
    panel.spacing.y    = unit(4, "pt"),
    legend.position    = "bottom",
    plot.margin        = margin(10, 16, 10, 10)
  )

# ---- Data & reshape (identical to T1) ----
data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)
# choice1..choice8 are the analysed tasks; choice1_repeated_flipped is the
# repeated, profile-flipped task used ONLY to estimate intra-respondent
# reliability (IRR) — it is not itself an analysed choice.

# ---- Estimate AMCEs ---------------------------------------------------
# .structure = "profile_level" gives the classic AMCE: the marginal effect
#   of a level on Pr(a profile is chosen), reference = each attribute's first
#   level. (projoint's default "choice_level" is a different, paired quantity.)
# projoint auto-clusters standard errors on the respondent id (ResponseId).
# It returns BOTH an uncorrected AMCE and projoint's measurement-error-
# corrected AMCE; the corrected estimand is projoint's estimator and is what
# we report. NOTE: projoint may warn that the CR2 cluster-robust variance is
# non-PSD and fall back to se_type = "stata" (then HC1) — this is projoint's
# own documented, expected behaviour, not an error.
fit <- projoint(out, .structure = "profile_level", .estimand = "amce")

tau    <- as.numeric(fit$tau)          # estimated swap-error rate
factor <- 1 / (1 - 2 * tau)            # attenuation-correction factor

# ---- Assemble plotting frame -----------------------------------------
# Label map: level_id ("att1:level2") -> attribute + level text.
labs <- fit$labels %>%
  mutate(attribute_lab = str_wrap(attribute, 20))

# Corrected AMCE for every non-reference level.
est <- fit$estimates %>%
  filter(estimand == "amce_corrected") %>%
  transmute(
    level_id    = att_level_choose,
    baseline_id = att_level_choose_baseline,
    estimate, conf.low, conf.high,
    is_ref = FALSE
  ) %>%
  left_join(labs, by = "level_id")

# One reference row per attribute, pinned at exactly 0 (no interval).
ref <- est %>%
  distinct(attribute_id, baseline_id) %>%
  transmute(level_id = baseline_id, estimate = 0,
            conf.low = NA_real_, conf.high = NA_real_, is_ref = TRUE) %>%
  left_join(labs, by = "level_id")

plot_df <- bind_rows(select(est, -baseline_id), ref) %>%
  mutate(
    est_pp    = 100 * estimate,        # probability -> percentage points
    lo_pp     = 100 * conf.low,
    hi_pp     = 100 * conf.high,
    level_num = as.integer(str_extract(level_id, "(?<=level)\\d+"))
  )

# Order attributes att1..att7 (facets, top->bottom) and levels within each
# attribute so the reference level sits at the top of its block.
attr_levels <- labs %>% distinct(attribute_id, attribute_lab) %>%
  arrange(attribute_id) %>% pull(attribute_lab)
lev_levels  <- plot_df %>% arrange(attribute_id, desc(level_num)) %>%
  pull(level) %>% unique()

plot_df <- plot_df %>%
  mutate(
    attribute_lab = factor(attribute_lab, levels = attr_levels),
    level         = factor(level, levels = lev_levels)
  )

pal <- setNames(okabe_ito[seq_along(attr_levels)], attr_levels)

# ---- Dot-and-whisker plot --------------------------------------------
p <- ggplot(plot_df, aes(x = est_pp, y = level, colour = attribute_lab)) +
  geom_vline(xintercept = 0, linetype = "dashed", colour = "grey55") +
  geom_errorbarh(aes(xmin = lo_pp, xmax = hi_pp),
                 height = 0, linewidth = 0.5, na.rm = TRUE) +
  geom_point(aes(shape = is_ref), size = 2.4, stroke = 0.7, na.rm = TRUE) +
  facet_grid(attribute_lab ~ ., scales = "free_y", space = "free_y", switch = "y") +
  scale_colour_manual(values = pal, guide = "none") +
  scale_shape_manual(
    values = c(`FALSE` = 16, `TRUE` = 1),
    labels = c(`FALSE` = "AMCE (95% CI)", `TRUE` = "Reference (fixed at 0)"),
    name = NULL
  ) +
  labs(x = "AMCE on P(profile chosen), percentage points") +
  theme_amce

dir.create("figures", showWarnings = FALSE)
ggsave("figures/amce-dotwhisker.png", p,
       width = 8, height = 9, dpi = 320, bg = "white")

# ---- Console summary (used to write report.md) -----------------------
summary_tbl <- plot_df %>%
  filter(!is_ref) %>%
  transmute(
    attribute, level,
    est_pp = round(est_pp, 1),
    ci = sprintf("[%.1f, %.1f]", lo_pp, hi_pp),
    sig = ifelse(lo_pp > 0 | hi_pp < 0, "*", "")
  ) %>%
  arrange(desc(abs(est_pp)))

cat(sprintf("\nIRR swap-error rate tau = %.3f  |  correction factor = %.3f\n",
            tau, factor))
cat("Corrected AMCEs (percentage points), largest first:\n")
print(as.data.frame(summary_tbl), row.names = FALSE)
