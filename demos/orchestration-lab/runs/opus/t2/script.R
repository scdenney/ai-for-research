# =====================================================================
# T2 — AMCEs for a 7-attribute conjoint, estimated with {projoint}
# Uncertainty clustered at the respondent level.
# Self-contained: reshapes the data, estimates AMCEs, writes
# figures/amce-dotwhisker.png, and prints the numbers used in report.md.
# =====================================================================

suppressPackageStartupMessages({
  library(projoint)
  library(ggplot2)
  library(dplyr)
})

# ---- Okabe-Ito palette (color-blind-safe) & theme -------------------
okabe_ito <- c(
  black      = "#000000",
  orange     = "#E69F00",
  skyblue    = "#56B4E9",
  green      = "#009E73",
  yellow     = "#F0E442",
  blue       = "#0072B2",
  vermillion = "#D55E00",
  purple     = "#CC79A7",
  grey       = "#999999"
)

theme_amce <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor   = element_blank(),
    panel.grid.major.x = element_line(color = "grey92", linewidth = 0.3),
    strip.text.y.left  = element_text(angle = 0, hjust = 1, face = "bold", size = 9),
    strip.placement    = "outside",
    panel.spacing.y    = unit(4, "pt"),
    axis.title.x       = element_text(margin = margin(t = 8)),
    legend.position    = "bottom",
    legend.box         = "vertical",
    legend.margin      = margin(t = 2, b = 0),
    plot.margin        = margin(6, 12, 6, 6)
  )

# ---- Data & reshape (same call as T1) -------------------------------
set.seed(2026)                       # before any estimation
data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

# ---- Estimate AMCEs for all seven attributes ------------------------
# "profile_level" structure returns an AMCE for every attribute/level in
# a single call (the "choice_level" structure requires a specific .qoi).
# projoint clusters the analytical variance at the respondent id
# (.auto_cluster = TRUE) and returns BOTH the conventional (uncorrected)
# AMCE and its measurement-error-corrected counterpart. The correction
# divides each AMCE by (1 - 2*tau), where tau is the estimated swapping-
# error probability recovered from the repeated task (NOT the IRR itself;
# the implied IRR here is ~0.72).
amce <- projoint(out, .structure = "profile_level", .estimand = "amce")

corr_factor <- 1 / (1 - 2 * amce$tau)
cat(sprintf(paste0("SE method: %s | clustered by: %s | se_type: %s | ",
                   "swapping-error prob tau: %.3f | AMCE correction 1/(1-2*tau): %.3f\n"),
            amce$se_method, amce$cluster_by, amce$se_type_used, amce$tau, corr_factor))

est    <- amce$estimates
labels <- amce$labels

# ---- Build a tidy plotting frame ------------------------------------
estimand_lab <- c(
  amce_uncorrected = "AMCE (uncorrected)",
  amce_corrected   = "AMCE (measurement-error corrected)"
)

plot_pts <- est %>%
  left_join(labels, by = c("att_level_choose" = "level_id")) %>%
  mutate(
    estimand = unname(estimand_lab[estimand]),
    lvl_num  = as.integer(sub(".*level", "", att_level_choose))
  )

# Reference levels (level1 of each attribute) pinned at exactly 0.
ref_pts <- labels %>%
  filter(grepl(":level1$", level_id)) %>%
  transmute(
    attribute, level, attribute_id,
    att_level_choose = level_id,
    lvl_num  = 1L,
    estimate = 0, se = NA_real_, conf.low = NA_real_, conf.high = NA_real_,
    estimand = "Reference level (baseline, fixed at 0)"
  )

# Order: attributes att1..att7 top -> bottom; within each attribute the
# reference sits on top, remaining levels in their natural order below.
attr_order  <- labels %>% distinct(attribute_id, attribute) %>% arrange(attribute_id)
level_order <- bind_rows(plot_pts, ref_pts) %>%
  distinct(att_level_choose, level, attribute_id, lvl_num) %>%
  arrange(attribute_id, desc(lvl_num)) %>%   # desc => level1 last => top of band
  pull(level)

as_ordered <- function(df) {
  df %>% mutate(
    attribute = factor(attribute, levels = attr_order$attribute),
    level     = factor(level,     levels = level_order)
  )
}
plot_pts <- as_ordered(plot_pts)
ref_pts  <- as_ordered(ref_pts)

# ---- Dot-and-whisker plot -------------------------------------------
dodge <- position_dodge(width = 0.55)

p <- ggplot(plot_pts, aes(x = estimate, y = level)) +
  geom_vline(xintercept = 0, linetype = "dashed",
             color = okabe_ito[["grey"]], linewidth = 0.4) +
  geom_errorbar(aes(xmin = conf.low, xmax = conf.high, color = estimand),
                orientation = "y", width = 0, linewidth = 0.6, position = dodge) +
  geom_point(aes(color = estimand), size = 2.1, position = dodge) +
  geom_point(data = ref_pts, aes(shape = estimand),
             color = okabe_ito[["black"]], fill = "white",
             size = 2.4, stroke = 0.7) +
  facet_grid(rows = vars(attribute), scales = "free_y", space = "free_y",
             switch = "y", labeller = label_wrap_gen(width = 18)) +
  scale_color_manual(
    values = c(
      "AMCE (uncorrected)"                 = okabe_ito[["blue"]],
      "AMCE (measurement-error corrected)" = okabe_ito[["vermillion"]]
    ),
    name = NULL) +
  scale_shape_manual(
    values = c("Reference level (baseline, fixed at 0)" = 21),
    name = NULL) +
  guides(color = guide_legend(order = 1, override.aes = list(linewidth = 0.6)),
         shape = guide_legend(order = 2)) +
  labs(x = "AMCE — change in Pr(profile chosen)", y = NULL) +
  theme_amce

dir.create("figures", showWarnings = FALSE)
ggsave("figures/amce-dotwhisker.png", p,
       width = 8.5, height = 10, dpi = 320, bg = "white")

# ---- Numbers for report.md ------------------------------------------
report_tbl <- plot_pts %>%
  filter(estimand == "AMCE (uncorrected)") %>%
  transmute(
    attribute, level,
    pp  = round(100 * estimate, 1),
    lo  = round(100 * conf.low, 1),
    hi  = round(100 * conf.high, 1),
    sig = ifelse(conf.low > 0 | conf.high < 0, "*", "")
  ) %>%
  arrange(desc(abs(pp)))

cat("\n== Uncorrected AMCEs in percentage points, largest first ==\n")
print(as.data.frame(report_tbl), row.names = FALSE)
