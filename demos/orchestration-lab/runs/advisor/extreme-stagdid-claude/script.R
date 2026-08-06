## script.R
## Reconciling naive TWFE against heterogeneity-robust staggered-adoption
## estimators on the Callaway-Sant'Anna mpdta (minimum wage / teen employment)
## county panel shipped with the `did` package.

set.seed(20260717)

suppressPackageStartupMessages({
  library(did)
  library(fixest)
  library(staggered)
  library(bacondecomp)
  library(ggplot2)
  library(dplyr)
})

## ---- Okabe-Ito palette + shared theme (declared up top, used by the one plot we produce) ----
okabe_ito <- c(
  black      = "#000000",
  orange     = "#E69F00",
  sky_blue   = "#56B4E9",
  bluish_grn = "#009E73",
  yellow     = "#F0E442",
  blue       = "#0072B2",
  vermillion = "#D55E00",
  purple     = "#CC79A7"
)

theme_okabe <- theme_minimal(base_size = 13) +
  theme(
    panel.grid.minor = element_blank(),
    axis.title = element_text(face = "bold"),
    plot.title = element_blank() # no in-plot titles per spec
  )

dir.create("figures", showWarnings = FALSE)

## ---- Data ----
data(mpdta)
# columns: year countyreal lpop lemp first.treat treat
# first.treat == 0 means never-treated in did::att_gt's convention.

mpdta <- mpdta %>%
  mutate(
    ever_treated = as.integer(first.treat != 0),
    post         = as.integer(ever_treated == 1 & year >= first.treat)
  )

cat("\n=== Treatment timing structure ===\n")
print(table(mpdta$first.treat))

## =========================================================================
## 1(a) Naive TWFE: post x ever-treated dummy, county + year FE, clustered SE
## =========================================================================
twfe_fit <- feols(lemp ~ post | countyreal + year, data = mpdta,
                   cluster = ~countyreal)
cat("\n=== (1a) Naive TWFE ===\n")
print(summary(twfe_fit))

twfe_att <- coef(twfe_fit)["post"]
twfe_se  <- se(twfe_fit)["post"]

## =========================================================================
## 1(b) Callaway & Sant'Anna, both control-group choices
##      did::att_gt uses gname = 0 for never-treated -- mpdta$first.treat
##      already encodes it that way, so it is used directly.
## =========================================================================
cs_notyet <- att_gt(
  yname = "lemp", tname = "year", idname = "countyreal",
  gname = "first.treat", data = mpdta,
  control_group = "notyettreated", clustervars = "countyreal",
  panel = TRUE, allow_unbalanced_panel = TRUE
)
cs_notyet_simple <- aggte(cs_notyet, type = "simple")

cs_never <- att_gt(
  yname = "lemp", tname = "year", idname = "countyreal",
  gname = "first.treat", data = mpdta,
  control_group = "nevertreated", clustervars = "countyreal",
  panel = TRUE, allow_unbalanced_panel = TRUE
)
cs_never_simple <- aggte(cs_never, type = "simple")

cat("\n=== (1b) Callaway-Sant'Anna: not-yet-treated controls, simple ATT ===\n")
print(summary(cs_notyet_simple))
cat("\n=== (1b) Callaway-Sant'Anna: never-treated controls, simple ATT ===\n")
print(summary(cs_never_simple))

## =========================================================================
## 1(c) Heterogeneity-robust alternatives: Sun-Abraham AND Roth-Sant'Anna
##      (task requires at least one; both are cheap here so both are reported)
## =========================================================================

## Sun & Abraham (2021) via fixest::sunab -- last pre-treatment period is the
## reference automatically; never-treated (first.treat==0) is recoded so
## sunab treats it as the (infinite) reference cohort.
mpdta_sa <- mpdta %>% mutate(first_treat_sa = ifelse(first.treat == 0, Inf, first.treat))
sunab_fit <- feols(lemp ~ sunab(first_treat_sa, year) | countyreal + year,
                    data = mpdta_sa, cluster = ~countyreal)
sunab_agg <- summary(sunab_fit, agg = "att")
cat("\n=== (1c) Sun-Abraham (fixest::sunab), aggregated ATT ===\n")
print(sunab_agg)

sunab_att <- sunab_agg$coeftable["ATT", "Estimate"]
sunab_se  <- sunab_agg$coeftable["ATT", "Std. Error"]

## Roth & Sant'Anna (2021) efficient estimator via staggered::staggered.
## NB: staggered's `g` column uses Inf for never-treated -- a different
## sentinel than did::att_gt's gname==0 -- so it must be recoded here.
mpdta_stg <- mpdta %>%
  transmute(
    i = countyreal, t = year, y = lemp,
    g = ifelse(first.treat == 0, Inf, first.treat)
  )
stag_simple <- staggered(df = mpdta_stg, i = "i", t = "t", g = "g", y = "y",
                          estimand = "simple")
cat("\n=== (1c) Roth-Sant'Anna (staggered::staggered), simple estimand ===\n")
print(stag_simple)
# staggered() returns two SEs: `se` (the estimator's own asymptotic SE) and
# `se_neyman` (a conservative Neyman-type SE). The table reports `se`; the two
# happen to be nearly identical here (0.011614 vs 0.011614) but need not be.

## =========================================================================
## 2. Goodman-Bacon decomposition of the naive TWFE
## =========================================================================
bacon_out <- bacon(lemp ~ post, data = mpdta, id_var = "countyreal", time_var = "year")

cat("\n=== (2) Goodman-Bacon decomposition: weight by comparison type ===\n")
bacon_summary <- bacon_out %>%
  group_by(type) %>%
  summarise(total_weight = sum(weight), avg_estimate = weighted.mean(estimate, weight), .groups = "drop") %>%
  arrange(desc(total_weight))
print(bacon_summary)

## Only "Later vs Earlier Treated" puts an already-treated unit in the CONTROL
## role -- that is the forbidden comparison Goodman-Bacon warns can carry
## negative weight. "Earlier vs Later Treated" compares an earlier-treated
## cohort against a later cohort during the later cohort's *untreated*
## periods -- the control there is not-yet-treated, which is clean under
## parallel trends (the same comparison CS's control_group = "notyettreated"
## uses on purpose). Do not pool the two.
contaminated_weight <- bacon_summary %>%
  filter(type == "Later vs Earlier Treated") %>%
  summarise(w = sum(total_weight)) %>% pull(w)
contaminated_est <- bacon_summary %>%
  filter(type == "Later vs Earlier Treated") %>%
  pull(avg_estimate)
clean_weight <- bacon_summary %>%
  filter(type != "Later vs Earlier Treated") %>%
  summarise(w = sum(total_weight)) %>% pull(w)
clean_est <- bacon_out %>%
  filter(type != "Later vs Earlier Treated") %>%
  summarise(w = weighted.mean(estimate, weight)) %>% pull(w)

cat(sprintf("\nShare of weight on later-vs-earlier-treated (contaminated) comparisons: %.1f%%\n",
            100 * contaminated_weight))
cat(sprintf("Share of weight on clean (treated-vs-never-treated + earlier-vs-later-treated) comparisons: %.1f%%\n",
            100 * clean_weight))
cat(sprintf("Contaminated-cell avg. estimate: %.4f  |  clean-cell avg. estimate: %.4f\n",
            contaminated_est, clean_est))
cat(sprintf("Reallocating the contaminated weight to the clean average would move TWFE by about %.4f\n",
            clean_est - as.numeric(twfe_att)))

## =========================================================================
## 3. Event study / dynamic effects (parallel-trends check)
##    Built off the never-treated CS aggregation (largest, cleanest control pool).
## =========================================================================
cat(sprintf("\nPre-test (Wald) p-value for parallel trends, att_gt object: %.4f\n", cs_never$Wpval))

cs_dynamic <- aggte(cs_never, type = "dynamic", min_e = -2, max_e = 2, na.rm = TRUE)
cat("\n=== (3) Event-study (dynamic) estimates, never-treated controls ===\n")
print(summary(cs_dynamic))
## Composition note: with data ending in 2007, e=+1 is identified from the
## 2004 and 2006 cohorts, and e=+2 from the 2004 cohort alone (20 counties) --
## the later cohorts have no post-2007 data to contribute. The apparent
## growth in |ATT| across event time therefore mixes within-cohort dynamics
## with a shrinking, changing set of contributing cohorts.

## aggte()'s native output is a simultaneous confidence band (crit.val.egt is
## the single critical value calibrated across all event times jointly), not
## pointwise +/-1.96*SE -- use it as-is so the plotted band matches what the
## package actually reports.
event_df <- data.frame(
  event_time = cs_dynamic$egt,
  estimate   = cs_dynamic$att.egt,
  se         = cs_dynamic$se.egt
) %>%
  mutate(
    ci_lo = estimate - cs_dynamic$crit.val.egt * se,
    ci_hi = estimate + cs_dynamic$crit.val.egt * se,
    period = ifelse(event_time < 0, "Pre-treatment", "Post-treatment")
  )

## ---- Figure: figures/event-study.png ----
p <- ggplot(event_df, aes(x = event_time, y = estimate, color = period)) +
  geom_vline(xintercept = -0.5, linetype = "dashed", color = okabe_ito["black"], linewidth = 0.6) +
  geom_hline(yintercept = 0, color = "grey50", linewidth = 0.4) +
  geom_pointrange(aes(ymin = ci_lo, ymax = ci_hi), linewidth = 0.8, size = 0.7) +
  scale_color_manual(values = c("Pre-treatment" = unname(okabe_ito["sky_blue"]),
                                 "Post-treatment" = unname(okabe_ito["vermillion"]))) +
  scale_x_continuous(breaks = event_df$event_time) +
  labs(x = "Event time (years relative to first minimum-wage increase)",
       y = "ATT on log teen employment (95% simultaneous CB)",
       color = NULL) +
  theme_okabe +
  theme(legend.position = "top")

ggsave("figures/event-study.png", p, width = 7.5, height = 5, dpi = 320)

cat("\n=== Script complete. Outputs written to figures/event-study.png ===\n")

## ---- Console dump used to hand-assemble estimates-table.md and memo.md ----
cat("\n=== SUMMARY FOR TABLE ===\n")
cat(sprintf("TWFE:                 ATT=%.4f  SE=%.4f\n", twfe_att, twfe_se))
cat(sprintf("CS not-yet-treated:   ATT=%.4f  SE=%.4f\n", cs_notyet_simple$overall.att, cs_notyet_simple$overall.se))
cat(sprintf("CS never-treated:     ATT=%.4f  SE=%.4f\n", cs_never_simple$overall.att, cs_never_simple$overall.se))
cat(sprintf("Sun-Abraham:          ATT=%.4f  SE=%.4f\n", sunab_att, sunab_se))
cat(sprintf("Roth-Sant'Anna:       ATT=%.4f  SE=%.4f\n", stag_simple$estimate, stag_simple$se))
