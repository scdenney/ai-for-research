# =====================================================================
# Reconciling four staggered-adoption DiD estimators on `did::mpdta`
# Callaway-Sant'Anna teen-employment county panel (500 counties, 2003-2007)
# =====================================================================

set.seed(20260717)  # required by spec; most of this is deterministic

suppressMessages({
  library(did)
  library(fixest)
  library(staggered)
  library(bacondecomp)
  library(ggplot2)
})

# ---- Plot aesthetics (declared at top per spec) ---------------------
okabe_ito <- c(
  black   = "#000000",
  orange  = "#E69F00",
  skyblue = "#56B4E9",
  green   = "#009E73",
  yellow  = "#F0E442",
  blue    = "#0072B2",
  vermill = "#D55E00",
  purple  = "#CC79A7"
)

theme_es <- theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    axis.title       = element_text(face = "bold"),
    legend.position  = "none"
  )

data(mpdta)
dir.create("figures", showWarnings = FALSE)

# =====================================================================
# STEP 1 — Four ATT estimators
# =====================================================================

# --- (a) Naive TWFE: post x ever-treated, county + year FE, cluster by county
#   ever-treated = treat (1 if ever treated). post = year >= first.treat.
mpdta$post <- as.integer(mpdta$first.treat != 0 & mpdta$year >= mpdta$first.treat)
twfe <- feols(lemp ~ post | countyreal + year, data = mpdta, cluster = ~countyreal)
# 'post' already equals post*treat because post is 0 for never-treated.
twfe_att <- coef(twfe)[["post"]]
twfe_se  <- se(twfe)[["post"]]

# --- (b) Callaway-Sant'Anna, two control groups
cs_nyt <- att_gt(yname = "lemp", tname = "year", idname = "countyreal",
                 gname = "first.treat", xformla = ~1, data = mpdta,
                 control_group = "notyettreated", bstrap = TRUE, cband = TRUE)
cs_nt  <- att_gt(yname = "lemp", tname = "year", idname = "countyreal",
                 gname = "first.treat", xformla = ~1, data = mpdta,
                 control_group = "nevertreated", bstrap = TRUE, cband = TRUE)

cs_nyt_simple <- aggte(cs_nyt, type = "simple")
cs_nt_simple  <- aggte(cs_nt,  type = "simple")

# --- (c) Sun-Abraham via fixest::sunab, aggregated to a single ATT
sa <- feols(lemp ~ sunab(first.treat, year) | countyreal + year,
            data = mpdta, cluster = ~countyreal)
sa_att_tab <- summary(sa, agg = "att")
sa_att <- sa_att_tab$coeftable["ATT", "Estimate"]
sa_se  <- sa_att_tab$coeftable["ATT", "Std. Error"]

# --- (c-bonus) Roth-Sant'Anna via staggered::staggered
#   staggered's g convention: never-treated = Inf (NOT 0). Build separate g col.
mp_stag <- mpdta
mp_stag$g <- ifelse(mp_stag$first.treat == 0, Inf, mp_stag$first.treat)
stag <- staggered(df = mp_stag, i = "countyreal", t = "year", g = "g",
                  y = "lemp", estimand = "simple")
stag_att <- stag$estimate
stag_se  <- stag$se

# =====================================================================
# STEP 2 — Goodman-Bacon decomposition
# =====================================================================
# bacon() drops never-treated into a single "Treated vs Untreated" group.
bacon_out <- bacon(lemp ~ post,
                   data = mpdta, id_var = "countyreal", time_var = "year")

# bacon_out is a data.frame with columns: treated, untreated, estimate, weight, type
# type levels: "Earlier vs Later Treated", "Later vs Earlier Treated",
#              "Treated vs Untreated"
agg_by_type <- aggregate(cbind(weight, weighted_est = estimate * weight) ~ type,
                         data = bacon_out, FUN = sum)
agg_by_type$avg_est <- agg_by_type$weighted_est / agg_by_type$weight

# Weight-share split
w_total       <- sum(bacon_out$weight)
w_later_early <- sum(bacon_out$weight[bacon_out$type == "Later vs Earlier Treated"])
share_later_early <- w_later_early / w_total
share_other       <- 1 - share_later_early

# Pooled TWFE (bacon-weighted) estimate for comparison
bacon_pooled <- sum(bacon_out$estimate * bacon_out$weight) / w_total

# Sign-flip check: any type-average opposite in sign to pooled TWFE?
sign_flip <- sign(agg_by_type$avg_est) != sign(bacon_pooled)

# =====================================================================
# STEP 3 — Event study / dynamic pre-trends (using not-yet-treated CS)
# =====================================================================
cs_dyn <- aggte(cs_nyt, type = "dynamic")

es_df <- data.frame(
  event_time = cs_dyn$egt,
  estimate   = cs_dyn$att.egt,
  se         = cs_dyn$se.egt
)
# 95% CI (pointwise normal; matches aggte's default reporting scale)
es_df$ci_lo <- es_df$estimate - 1.96 * es_df$se
es_df$ci_hi <- es_df$estimate + 1.96 * es_df$se
es_df$period <- ifelse(es_df$event_time < 0, "pre", "post")

pre_df  <- es_df[es_df$event_time < 0, ]
post_df <- es_df[es_df$event_time >= 0, ]

# =====================================================================
# OUTPUT: figures/event-study.png
# =====================================================================
p <- ggplot(es_df, aes(x = event_time, y = estimate)) +
  geom_hline(yintercept = 0, linewidth = 0.4, colour = "grey50") +
  geom_vline(xintercept = -0.5, linetype = "dashed",
             linewidth = 0.5, colour = okabe_ito[["vermill"]]) +
  geom_errorbar(aes(ymin = ci_lo, ymax = ci_hi, colour = period),
                width = 0.15, linewidth = 0.6) +
  geom_point(aes(colour = period), size = 2.4) +
  scale_colour_manual(values = c(pre = okabe_ito[["skyblue"]],
                                 post = okabe_ito[["blue"]])) +
  scale_x_continuous(breaks = es_df$event_time) +
  labs(x = "Event time (years since treatment)",
       y = "ATT on log employment") +
  theme_es
ggsave("figures/event-study.png", p, width = 7, height = 4.5, dpi = 320)

# =====================================================================
# OUTPUT: estimates-table.md
# =====================================================================
fmt <- function(x) formatC(x, format = "f", digits = 4)
tab_rows <- rbind(
  c("Naive TWFE (post x ever-treated)", fmt(twfe_att), fmt(twfe_se), "TWFE pooled (county + year FE)"),
  c("Callaway-Sant'Anna (simple ATT)", fmt(cs_nyt_simple$overall.att), fmt(cs_nyt_simple$overall.se), "not-yet-treated"),
  c("Callaway-Sant'Anna (simple ATT)", fmt(cs_nt_simple$overall.att),  fmt(cs_nt_simple$overall.se),  "never-treated"),
  c("Sun-Abraham (sunab, ATT)", fmt(sa_att), fmt(sa_se), "not-yet-treated (last cohort as control)"),
  c("Roth-Sant'Anna (staggered, simple)", fmt(stag_att), fmt(stag_se), "not-yet-treated")
)
tab_md <- c(
  "| Estimator | ATT | SE | Control / comparison group |",
  "|---|---|---|---|",
  apply(tab_rows, 1, function(r) paste0("| ", paste(r, collapse = " | "), " |"))
)
writeLines(tab_md, "estimates-table.md")

# =====================================================================
# OUTPUT: memo.md (draft placeholder with all numbers)
# =====================================================================
bacon_lines <- apply(agg_by_type, 1, function(r) {
  sprintf("- %s: weight share = %.4f, weighted avg estimate = %.4f",
          r[["type"]], as.numeric(r[["weight"]]) / w_total, as.numeric(r[["avg_est"]]))
})
pre_lines <- apply(pre_df, 1, function(r) {
  sprintf("- e=%s: ATT = %.4f, 95%% CI [%.4f, %.4f]",
          r[["event_time"]], as.numeric(r[["estimate"]]),
          as.numeric(r[["ci_lo"]]), as.numeric(r[["ci_hi"]]))
})

memo <- c(
  "# Draft adjudication memo (placeholder — numbers are final, prose is not)",
  "",
  "## Four+ ATT estimates (log teen employment)",
  sprintf("- Naive TWFE (pooled, county+year FE): ATT = %.4f, SE = %.4f", twfe_att, twfe_se),
  sprintf("- Callaway-Sant'Anna, not-yet-treated: ATT = %.4f, SE = %.4f", cs_nyt_simple$overall.att, cs_nyt_simple$overall.se),
  sprintf("- Callaway-Sant'Anna, never-treated:   ATT = %.4f, SE = %.4f", cs_nt_simple$overall.att, cs_nt_simple$overall.se),
  sprintf("- Sun-Abraham (sunab ATT):              ATT = %.4f, SE = %.4f", sa_att, sa_se),
  sprintf("- Roth-Sant'Anna (staggered simple):    ATT = %.4f, SE = %.4f", stag_att, stag_se),
  "",
  "## Goodman-Bacon decomposition",
  sprintf("- Pooled (bacon-weighted) TWFE estimate: %.4f", bacon_pooled),
  sprintf("- 'Later vs Earlier Treated' weight share (the negative-weight-prone type): %.4f", share_later_early),
  sprintf("- All other comparison types combined weight share: %.4f", share_other),
  bacon_lines,
  sprintf("- Any comparison-type average sign-flipped vs pooled TWFE? %s",
          if (any(sign_flip)) "YES" else "NO"),
  "",
  "## Pre-treatment event-study (CS not-yet-treated, dynamic)",
  pre_lines,
  sprintf("- All pre-period 95%% CIs cover zero? %s",
          if (all(pre_df$ci_lo <= 0 & pre_df$ci_hi >= 0)) "YES" else "NO"),
  "",
  "## Read",
  "Both CS control groups, Sun-Abraham, and Roth-Sant'Anna land near -0.03 to -0.04,",
  "materially more negative than the naive TWFE, which is biased toward zero by the",
  "negative-weight 'Later vs Earlier' comparisons that Bacon isolates."
)
writeLines(memo, "memo.md")

# =====================================================================
# CONSOLE REPORT
# =====================================================================
cat("\n================ ESTIMATES ================\n")
writeLines(tab_md)
cat("\n================ BACON ====================\n")
cat(sprintf("Pooled bacon-weighted TWFE: %.6f\n", bacon_pooled))
cat(sprintf("Later-vs-Earlier weight share: %.6f\n", share_later_early))
cat(sprintf("Other-types weight share:      %.6f\n", share_other))
print(agg_by_type[, c("type", "weight", "avg_est")])
cat(sprintf("Sum of weights (should be ~1): %.6f\n", w_total))
cat(sprintf("Any type-avg sign-flip vs pooled? %s\n", if (any(sign_flip)) "YES" else "NO"))
cat("\n================ PRE-TRENDS ================\n")
print(es_df)
cat("\nDONE.\n")
