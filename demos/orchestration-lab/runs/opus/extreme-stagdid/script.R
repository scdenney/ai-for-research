# =============================================================================
# Task EXTREME — Reconciling modern staggered-adoption DiD estimators
# Callaway-Sant'Anna minimum-wage / teen-employment county panel (did::mpdta)
#
# Self-contained. Produces:
#   estimates-table.md, figures/event-study.png
# (memo.md is written separately.)
# =============================================================================

# ---- Okabe-Ito palette + plot theme (declared up top) -----------------------
okabe_ito <- c(
  black      = "#000000", orange   = "#E69F00", skyblue = "#56B4E9",
  green      = "#009E73", yellow   = "#F0E442", blue    = "#0072B2",
  vermillion = "#D55E00", purple   = "#CC79A7", grey    = "#999999"
)

suppressMessages({
  library(did)          # Callaway & Sant'Anna (2021)
  library(fixest)       # TWFE + Sun & Abraham (2021)
  library(staggered)    # Roth & Sant'Anna (2023)
  library(bacondecomp)  # Goodman-Bacon (2021)
  library(ggplot2)
})

theme_es <- theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    plot.title = element_blank(),
    axis.title = element_text(size = 12),
    legend.position = "top",
    legend.title = element_blank()
  )

set.seed(20260717)  # before any bootstrap / stochastic step (did & staggered)

data(mpdta)

# mpdta columns: year, countyreal, lpop, lemp, first.treat (0 = never), treat
# Sentinels DIFFER by package (see Method note):
#   did::att_gt   gname : 0   = never treated   <- mpdta$first.treat as-is
#   staggered     g     : Inf = never treated   <- must recode below
#   bacondecomp   needs an absorbing 0/1 treatment dummy
#   fixest::sunab needs never-treated cohort placed OUTSIDE the period range

# -----------------------------------------------------------------------------
# Naive treatment dummy: post x ever-treated (unit-specific onset, absorbing)
# -----------------------------------------------------------------------------
mpdta$post_treat <- as.integer(mpdta$first.treat > 0 &
                               mpdta$year >= mpdta$first.treat)

# =============================================================================
# STEP 1 — Estimate the ATT (at least) four ways
# =============================================================================

# (a) Naive static TWFE: county + year FE, clustered by county -----------------
m_twfe <- feols(lemp ~ post_treat | countyreal + year,
                data = mpdta, cluster = ~countyreal)
twfe_att <- coef(m_twfe)[["post_treat"]]
twfe_se  <- se(m_twfe)[["post_treat"]]

# (b) Callaway-Sant'Anna: att_gt + aggte(type="simple"), BOTH control groups ---
# att_gt clusters at the unit (county) level natively via the multiplier
# bootstrap; xformla=~1 keeps parallel trends unconditional (apples-to-apples
# with TWFE / SA / staggered, none of which carry covariates here).
cs_nyt <- att_gt(yname = "lemp", tname = "year", idname = "countyreal",
                 gname = "first.treat", xformla = ~1, data = mpdta,
                 control_group = "notyettreated", bstrap = TRUE, biters = 2000)
cs_never <- att_gt(yname = "lemp", tname = "year", idname = "countyreal",
                   gname = "first.treat", xformla = ~1, data = mpdta,
                   control_group = "nevertreated", bstrap = TRUE, biters = 2000)

cs_nyt_simple   <- aggte(cs_nyt,   type = "simple", bstrap = TRUE, biters = 2000)
cs_never_simple <- aggte(cs_never, type = "simple", bstrap = TRUE, biters = 2000)

# (c1) Sun-Abraham via fixest::sunab -------------------------------------------
# never-treated (first.treat==0) -> a cohort OUTSIDE 2003-2007 so those units
# stay in the control pool for every relative period.
m_sa <- mpdta
m_sa$cohort <- ifelse(m_sa$first.treat == 0, 10000L, as.integer(m_sa$first.treat))
sa_fit <- feols(lemp ~ sunab(cohort, year) | countyreal + year,
                data = m_sa, cluster = ~countyreal)
sa_att_tab <- summary(sa_fit, agg = "ATT")$coeftable          # post-period ATT
sa_att <- sa_att_tab["ATT", "Estimate"]
sa_se  <- sa_att_tab["ATT", "Std. Error"]

# (c2) Roth-Sant'Anna via staggered::staggered ---------------------------------
# g uses Inf for never treated (NOT 0). Native unit-level (Neyman) SE.
m_st <- mpdta
m_st$g <- ifelse(m_st$first.treat == 0, Inf, m_st$first.treat)
st_fit <- staggered(df = m_st, i = "countyreal", t = "year", g = "g",
                    y = "lemp", estimand = "simple")
st_att <- st_fit$estimate
st_se  <- st_fit$se

# =============================================================================
# STEP 2 — Goodman-Bacon decomposition: does negative weighting bite here?
# =============================================================================
bd <- bacon(lemp ~ post_treat, data = mpdta,
            id_var = "countyreal", time_var = "year")

w_by_type <- aggregate(weight ~ type, data = bd, FUN = sum)
w_by_type$avg_est <- sapply(w_by_type$type, function(tp)
  weighted.mean(bd$estimate[bd$type == tp], bd$weight[bd$type == tp]))
w_by_type <- w_by_type[order(-w_by_type$weight), ]

getw <- function(tp) {
  v <- w_by_type$weight[w_by_type$type == tp]
  if (length(v)) v else 0
}
w_clean          <- getw("Treated vs Untreated")      # treated vs never (clean)
w_earlier_later  <- getw("Earlier vs Later Treated")  # later group = clean control
w_later_earlier  <- getw("Later vs Earlier Treated")  # already-treated control (bad)

# TWFE reproduced as the weighted average of all 2x2s (sanity check)
twfe_recon <- weighted.mean(bd$estimate, bd$weight)

# =============================================================================
# STEP 3 — Pre-trends via the dynamic (event-study) aggregation
# =============================================================================
cs_dyn <- aggte(cs_nyt, type = "dynamic", bstrap = TRUE, biters = 2000, cband = FALSE)
# Uniform (simultaneous) band as well, so the pre-trend claim is not read off a
# single pointwise interval that ignores multiple comparisons.
cs_dyn_uni <- aggte(cs_nyt, type = "dynamic", bstrap = TRUE, biters = 2000, cband = TRUE)
uni_crit <- cs_dyn_uni$crit.val.egt

es <- data.frame(
  event_time = cs_dyn$egt,
  att        = cs_dyn$att.egt,
  se         = cs_dyn$se.egt
)
es$lo <- es$att - 1.96 * es$se          # pointwise 95%
es$hi <- es$att + 1.96 * es$se
es$period <- ifelse(es$event_time < 0, "Pre-treatment", "Post-treatment")

# Pre-trend read: pointwise vs uniform-band significance across pre-periods.
pre <- es[es$event_time < 0, ]
pre_max_abs_t   <- max(abs(pre$att / pre$se))       # largest pointwise |t|
pre_sig_uniform <- any(abs(pre$att / pre$se) > uni_crit)  # any pre-period sig under uniform band

# CS dynamic overall (avg of post-treatment event-time effects)
dyn_overall_att <- cs_dyn$overall.att
dyn_overall_se  <- cs_dyn$overall.se

# ---- Event-study figure ------------------------------------------------------
if (!dir.exists("figures")) dir.create("figures")

p <- ggplot(es, aes(event_time, att, color = period)) +
  annotate("rect", xmin = -0.5, xmax = Inf, ymin = -Inf, ymax = Inf,
           fill = okabe_ito[["skyblue"]], alpha = 0.08) +
  geom_hline(yintercept = 0, linetype = "solid", color = okabe_ito[["grey"]]) +
  geom_vline(xintercept = -0.5, linetype = "dashed", color = okabe_ito[["black"]]) +
  geom_errorbar(aes(ymin = lo, ymax = hi), width = 0.12, linewidth = 0.6) +
  geom_point(size = 2.6) +
  scale_color_manual(values = c("Pre-treatment"  = okabe_ito[["vermillion"]],
                                "Post-treatment" = okabe_ito[["blue"]])) +
  scale_x_continuous(breaks = sort(unique(es$event_time))) +
  labs(x = "Event time (years since minimum-wage increase)",
       y = "ATT on log teen employment") +
  theme_es

ggsave("figures/event-study.png", p, width = 8, height = 5, dpi = 320)

# =============================================================================
# Assemble estimates-table.md
# =============================================================================
fmt <- function(x) formatC(x, format = "f", digits = 4)
row <- function(est, att, sev, grp) sprintf("| %s | %s | %s | %s |",
                                            est, fmt(att), fmt(sev), grp)

tbl <- c(
  "# Estimates — ATT of a state minimum-wage increase on log county teen employment",
  "",
  "Outcome: `lemp` (log employment). Panel: 500 counties, 2003-2007 (`did::mpdta`).",
  "All estimators are unconditional (no covariates) for a clean cross-estimator comparison.",
  "",
  "| Estimator | ATT | Std. error | Control / comparison group |",
  "|---|---|---|---|",
  row("(a) Naive static TWFE (post x ever-treated, county+year FE)", twfe_att, twfe_se,
      "All units; FE-implied (Goodman-Bacon weighted); cluster = county"),
  row("(b) Callaway-Sant'Anna, aggte(simple)", cs_nyt_simple$overall.att, cs_nyt_simple$overall.se,
      "Not-yet-treated (incl. never-treated); native county bootstrap"),
  row("(b) Callaway-Sant'Anna, aggte(simple)", cs_never_simple$overall.att, cs_never_simple$overall.se,
      "Never-treated only; native county bootstrap"),
  row("(c) Sun-Abraham (fixest::sunab), agg=ATT", sa_att, sa_se,
      "Never-treated cohort as clean controls; cluster = county"),
  row("(c) Roth-Sant'Anna (staggered::staggered, simple)", st_att, st_se,
      "Never-treated (g = Inf); native unit-level (Neyman) SE"),
  "",
  "Reference (not a step-1 estimator):",
  row("Callaway-Sant'Anna, aggte(dynamic) overall", dyn_overall_att, dyn_overall_se,
      "Not-yet-treated; avg of post-treatment event-time ATTs"),
  "",
  "## Goodman-Bacon decomposition of the naive TWFE (step 2)",
  "",
  "| 2x2 comparison type | Weight | Avg. estimate | Can carry negative weight? |",
  "|---|---|---|---|",
  sprintf("| Treated vs Untreated (clean, vs never-treated) | %s | %s | No |",
          fmt(w_clean), fmt(w_by_type$avg_est[w_by_type$type=="Treated vs Untreated"])),
  sprintf("| Earlier vs Later Treated (later group = not-yet-treated control) | %s | %s | No |",
          fmt(w_earlier_later), fmt(w_by_type$avg_est[w_by_type$type=="Earlier vs Later Treated"])),
  sprintf("| Later vs Earlier Treated (already-treated used as control) | %s | %s | **Yes** |",
          fmt(w_later_earlier), fmt(w_by_type$avg_est[w_by_type$type=="Later vs Earlier Treated"])),
  "",
  sprintf("- Weighted average of all 2x2s reproduces TWFE: **%s** (feols TWFE: %s).",
          fmt(twfe_recon), fmt(twfe_att)),
  sprintf("- Share of identifying weight on the negative-weight-prone bucket: **%.1f%%**.",
          100 * w_later_earlier),
  sprintf("- Share on clean treated-vs-never comparisons: **%.1f%%**.",
          100 * w_clean),
  "",
  "## Pre-trends (step 3)",
  "",
  sprintf("- Pre-treatment event-time ATTs (e < 0): largest pointwise |t| = **%.2f**; uniform-band critical value = %.2f; any pre-period significant under the uniform band? **%s**.",
          pre_max_abs_t, uni_crit, ifelse(pre_sig_uniform, "yes", "no")),
  paste0("- Event-time estimates: ",
         paste(sprintf("e=%d: %s (se %s)", es$event_time, fmt(es$att), fmt(es$se)),
               collapse = "; ")),
  ""
)
writeLines(tbl, "estimates-table.md")

# ---- console echo for the memo ----------------------------------------------
cat("\n================ RESULTS SUMMARY ================\n")
cat(sprintf("TWFE (naive)              : %.4f  (se %.4f)\n", twfe_att, twfe_se))
cat(sprintf("CS simple  notyettreated  : %.4f  (se %.4f)\n", cs_nyt_simple$overall.att, cs_nyt_simple$overall.se))
cat(sprintf("CS simple  nevertreated   : %.4f  (se %.4f)\n", cs_never_simple$overall.att, cs_never_simple$overall.se))
cat(sprintf("Sun-Abraham (ATT)         : %.4f  (se %.4f)\n", sa_att, sa_se))
cat(sprintf("Roth-Sant'Anna (simple)   : %.4f  (se %.4f)\n", st_att, st_se))
cat(sprintf("CS dynamic overall        : %.4f  (se %.4f)\n", dyn_overall_att, dyn_overall_se))
cat("\n--- Bacon weights ---\n"); print(w_by_type, row.names = FALSE)
cat(sprintf("Negative-weight-prone share: %.1f%%\n", 100 * w_later_earlier))
cat(sprintf("Clean (treated vs never)   : %.1f%%\n", 100 * w_clean))
cat("\n--- Event study ---\n"); print(es[, c("event_time","att","se","lo","hi","period")], row.names = FALSE)
cat(sprintf("Pre-period max pointwise |t| = %.2f ; uniform crit = %.2f ; any pre sig (uniform)? %s\n",
            pre_max_abs_t, uni_crit, ifelse(pre_sig_uniform, "YES", "no")))
cat("================================================\n")
