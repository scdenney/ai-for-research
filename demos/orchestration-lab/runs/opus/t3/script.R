# =====================================================================
# T3 — Answering the reviewer: are the crime results a baseline artifact?
#
# The reviewer notes that AMCEs are defined against an arbitrary reference
# category. This script separates what is mechanically true (AMCEs move
# when you move the baseline) from what is substantively robust (marginal
# means, and the importance ordering they imply, do not move at all).
#
# It (1) re-estimates the Violent Crime Rate AMCE under BOTH of its two
# possible baselines, (2) re-estimates a multi-level attribute (Total
# Daily Driving Time) under two baselines to exhibit the reviewer's
# mechanism, (3) computes marginal means (MMs) for every level — the
# baseline-invariant quantity — and the within-attribute MM range as a
# baseline-free importance measure.
#
# Self-contained. Writes figures/sensitivity.png and prints every number
# used in sensitivity-table.md and memo.md.
#
# NOTE on projoint baselines: reshape_projoint() stores each attribute as
# a factor whose levels are coded "attK:levelJ", and projoint() always
# takes level1 (lexically first) as the AMCE reference — relevel() is
# ignored. To move the baseline we therefore RE-CODE the level ids so the
# chosen level becomes level1, then re-estimate. This yields a genuine
# re-estimation with correct clustered SEs (not a hand-differenced MM).
# =====================================================================

suppressPackageStartupMessages({
  library(projoint)
  library(ggplot2)
  library(dplyr)
  library(tidyr)
  library(patchwork)
})

# ---- Okabe-Ito palette (color-blind-safe) & theme (as in T1/T2) -----
okabe_ito <- c(
  black = "#000000", orange = "#E69F00", skyblue = "#56B4E9",
  green = "#009E73", yellow = "#F0E442", blue = "#0072B2",
  vermillion = "#D55E00", purple = "#CC79A7", grey = "#999999"
)

theme_sens <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor   = element_blank(),
    panel.grid.major.x = element_line(color = "grey92", linewidth = 0.3),
    strip.text.y.left  = element_text(angle = 0, hjust = 1, face = "bold", size = 8.5),
    strip.placement    = "outside",
    panel.spacing.y    = unit(3, "pt"),
    axis.title.x       = element_text(margin = margin(t = 8), size = 10),
    plot.tag           = element_text(face = "bold", size = 12),
    legend.position    = "bottom",
    legend.title       = element_text(size = 9),
    legend.margin      = margin(t = 2, b = 0),
    plot.margin        = margin(6, 12, 6, 6)
  )

# ---- Data & reshape (identical call to T1/T2) -----------------------
set.seed(2026)                       # before any estimation
data(exampleData1)
mk <- function() reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)
out <- mk()
lab <- out$labels                    # attribute / level / attribute_id / level_id

# =====================================================================
# Helper: set the AMCE baseline of one attribute to a chosen level.
# Re-codes level ids so `base_code` becomes attK:level1, keeping the data
# factor and the labels table mutually consistent, then callers re-estimate.
# =====================================================================
set_baseline <- function(obj, att, base_code) {
  codes    <- obj$labels$level_id[obj$labels$attribute_id == att]
  neworder <- c(base_code, setdiff(codes, base_code))          # baseline first
  newcodes <- paste0(att, ":level", seq_along(neworder))       # level1..K
  map      <- setNames(newcodes, neworder)                     # old id -> new id
  v <- as.character(obj$data[[att]])
  obj$data[[att]] <- factor(unname(map[v]), levels = newcodes)
  idx <- obj$labels$attribute_id == att
  obj$labels$level_id[idx] <- unname(map[obj$labels$level_id[idx]])
  obj$labels <- obj$labels %>% arrange(attribute_id, level_id)
  obj
}

# Genuine re-estimation of one attribute's AMCEs under a chosen baseline.
# Returns human-labelled levels incl. the (pinned-at-0) baseline row.
amce_under_baseline <- function(att, base_code, which = "amce_uncorrected") {
  obj <- set_baseline(mk(), att, base_code)
  est <- suppressWarnings(
    projoint(obj, .structure = "profile_level", .estimand = "amce", .seed = 2026)
  )$estimates
  lb  <- obj$labels
  base_lab <- lb$level[lb$level_id == paste0(att, ":level1")]  # new level1 = baseline
  body <- est %>%
    filter(estimand == which, grepl(paste0("^", att, ":"), att_level_choose)) %>%
    left_join(lb, by = c("att_level_choose" = "level_id")) %>%
    transmute(attribute, level, estimate, se, conf.low, conf.high)
  bind_rows(
    tibble(attribute = body$attribute[1], level = base_lab,
           estimate = 0, se = NA_real_, conf.low = NA_real_, conf.high = NA_real_),
    body
  ) %>% mutate(baseline = base_lab)
}

# =====================================================================
# (0) Measurement-error correction factor (reported alongside numbers)
# =====================================================================
amce0 <- suppressWarnings(
  projoint(out, .structure = "profile_level", .estimand = "amce", .seed = 2026)
)
tau  <- amce0$tau
corr <- 1 / (1 - 2 * tau)
cat(sprintf("Swap-error tau = %.4f | AMCE/MM correction 1/(1-2*tau) = %.4f\n\n", tau, corr))

# =====================================================================
# (1) Violent Crime Rate (att7) — BINARY. AMCE under both baselines.
#     Magnitude is invariant; only the sign flips.
# =====================================================================
crime_lessbase <- amce_under_baseline("att7", "att7:level1")  # baseline = 20% Less Crime
crime_morebase <- amce_under_baseline("att7", "att7:level2")  # baseline = 20% More Crime
crime_lessbase_c <- amce_under_baseline("att7", "att7:level1", "amce_corrected")
crime_morebase_c <- amce_under_baseline("att7", "att7:level2", "amce_corrected")

cat("== (1) CRIME (binary) AMCE under each baseline — uncorrected ==\n")
print(as.data.frame(bind_rows(crime_lessbase, crime_morebase) %>%
        mutate(across(where(is.numeric), ~round(., 4)))), row.names = FALSE)
cat("\n== (1) CRIME AMCE under each baseline — IRR-corrected ==\n")
print(as.data.frame(bind_rows(crime_lessbase_c, crime_morebase_c) %>%
        mutate(across(where(is.numeric), ~round(., 4)))), row.names = FALSE)

# =====================================================================
# (2) Multi-level demo: Total Daily Driving Time (att5, 4 levels).
#     AMCEs shift wholesale between the best- and worst-commute baselines.
# =====================================================================
drive_10 <- amce_under_baseline("att5", "att5:level1")  # baseline = 10 min (best)
drive_75 <- amce_under_baseline("att5", "att5:level4")  # baseline = 75 min (worst)
cat("\n== (2) DRIVING TIME (multi-level) AMCE under two baselines — uncorrected ==\n")
print(as.data.frame(bind_rows(drive_10, drive_75) %>%
        mutate(across(where(is.numeric), ~round(., 4)))), row.names = FALSE)

# =====================================================================
# (3) Marginal means for ALL levels — baseline-invariant.
# =====================================================================
mm <- projoint(out, .structure = "profile_level", .estimand = "mm", .seed = 2026)
mm_all <- mm$estimates %>%
  left_join(lab, by = c("att_level_choose" = "level_id")) %>%
  mutate(estimand = recode(estimand,
                           mm_uncorrected = "uncorrected",
                           mm_corrected   = "IRR-corrected"))

mm_unc <- mm_all %>% filter(estimand == "uncorrected")

# Baseline-free importance: within-attribute MM range (max - min).
importance <- mm_unc %>%
  group_by(attribute) %>%
  summarise(mm_min = min(estimate), mm_max = max(estimate),
            mm_range = mm_max - mm_min, n_levels = n(), .groups = "drop") %>%
  arrange(desc(mm_range)) %>%
  mutate(rank = row_number())
cat("\n== (3) Baseline-invariant importance: within-attribute MM range ==\n")
print(as.data.frame(importance %>%
        mutate(across(c(mm_min, mm_max, mm_range), ~round(., 3)))), row.names = FALSE)

cat("\n== (3) Marginal means, all levels (uncorrected) ==\n")
print(as.data.frame(mm_unc %>%
        arrange(match(attribute, importance$attribute), desc(estimate)) %>%
        transmute(attribute, level,
                  mm = round(estimate, 3),
                  lo = round(conf.low, 3), hi = round(conf.high, 3))),
      row.names = FALSE)

# Confirm the ranking is unchanged under IRR correction.
imp_corr <- mm_all %>% filter(estimand == "IRR-corrected") %>%
  group_by(attribute) %>% summarise(mm_range = max(estimate) - min(estimate), .groups = "drop") %>%
  arrange(desc(mm_range))
cat("\nRanking by MM range identical after IRR correction: ",
    identical(importance$attribute, imp_corr$attribute), "\n")

# =====================================================================
# FIGURE — one PNG, two panels (no in-plot title).
#   A: AMCEs are baseline-relative (driving time slides with the baseline).
#   B: Marginal means are baseline-free (crime has the widest spread).
# =====================================================================

# -- Panel A: driving-time AMCEs under two baselines ------------------
lev_order_drive <- c("10 min", "25 min", "45 min", "75 min")
drive_plot <- bind_rows(drive_10, drive_75) %>%
  mutate(
    baseline = paste0("baseline: ", baseline),
    level    = factor(level, levels = rev(lev_order_drive))
  )
ref_drive <- drive_plot %>% filter(is.na(se))

pA <- ggplot(drive_plot, aes(estimate, level, color = baseline)) +
  geom_vline(xintercept = 0, linetype = "dashed",
             color = okabe_ito[["grey"]], linewidth = 0.4) +
  geom_errorbar(aes(xmin = conf.low, xmax = conf.high),
                orientation = "y", width = 0, linewidth = 0.6,
                position = position_dodge(width = 0.5)) +
  geom_point(size = 2.3, position = position_dodge(width = 0.5)) +
  geom_point(data = ref_drive, shape = 21, fill = "white", stroke = 0.8,
             size = 2.4, position = position_dodge(width = 0.5)) +
  scale_color_manual(values = c(okabe_ito[["blue"]], okabe_ito[["orange"]]),
                     name = NULL) +
  labs(x = "AMCE — change in Pr(chosen)  [baseline-relative]",
       y = NULL, tag = "A") +
  theme_sens +
  theme(legend.position = "bottom") +
  guides(color = guide_legend(nrow = 2))

# -- Panel B: marginal means, all levels, crime highlighted ----------
attr_levels <- importance$attribute                       # order by MM range desc
lev_by_attr <- mm_unc %>%
  arrange(match(attribute, attr_levels), estimate) %>%
  distinct(attribute, level)
mm_plot <- mm_unc %>%
  mutate(
    attribute = factor(attribute, levels = attr_levels),
    level     = factor(level, levels = lev_by_attr$level),
    crime     = ifelse(grepl("Violent Crime", attribute), "Violent Crime Rate", "Other attributes")
  )

pB <- ggplot(mm_plot, aes(estimate, level, color = crime)) +
  geom_vline(xintercept = 0.5, linetype = "dashed",
             color = okabe_ito[["grey"]], linewidth = 0.4) +
  geom_errorbar(aes(xmin = conf.low, xmax = conf.high),
                orientation = "y", width = 0, linewidth = 0.55) +
  geom_point(size = 2.1) +
  facet_grid(rows = vars(attribute), scales = "free_y", space = "free_y",
             switch = "y", labeller = label_wrap_gen(width = 16)) +
  scale_color_manual(values = c("Violent Crime Rate" = okabe_ito[["vermillion"]],
                                "Other attributes"   = okabe_ito[["black"]]),
                     name = NULL) +
  labs(x = "Marginal mean — Pr(profile chosen)  [baseline-invariant]",
       y = NULL, tag = "B") +
  theme_sens

fig <- pA + pB +
  plot_layout(widths = c(1, 1.35))

dir.create("figures", showWarnings = FALSE)
ggsave("figures/sensitivity.png", fig,
       width = 11, height = 6.6, dpi = 320, bg = "white")
cat("\nWrote figures/sensitivity.png\n")
