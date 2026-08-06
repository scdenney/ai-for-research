#!/usr/bin/env Rscript
# Reference solution — Task EXTREME (staggered-adoption DiD reconciliation)
# Built and run before any model saw the brief, per lab policy.

suppressMessages({
  library(did)
  library(fixest)
  library(staggered)
  library(bacondecomp)
  library(ggplot2)
})

set.seed(20260717)

okabe_ito <- c(
  black          = "#000000",
  orange         = "#E69F00",
  sky_blue       = "#56B4E9",
  bluish_green   = "#009E73",
  yellow         = "#F0E442",
  blue           = "#0072B2",
  vermillion     = "#D55E00",
  reddish_purple = "#CC79A7"
)

theme_okabe <- theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor   = element_blank(),
    panel.grid.major.x = element_blank(),
    axis.title         = element_text(face = "bold"),
    plot.margin        = margin(10, 14, 10, 10)
  )

data(mpdta)
mpdta$D <- as.integer(mpdta$first.treat != 0 & mpdta$year >= mpdta$first.treat)

## --- (1a) Naive TWFE ---------------------------------------------------
twfe <- feols(lemp ~ D | countyreal + year, data = mpdta, cluster = "countyreal")
twfe_att <- coef(twfe)["D"]; twfe_se <- se(twfe)["D"]

## --- (1b) Callaway-Sant'Anna, both control-group choices ----------------
cs_nyt <- att_gt(yname = "lemp", tname = "year", idname = "countyreal",
                  gname = "first.treat", data = mpdta,
                  control_group = "notyettreated", clustervars = "countyreal")
cs_nyt_simple <- aggte(cs_nyt, type = "simple")

cs_nt <- att_gt(yname = "lemp", tname = "year", idname = "countyreal",
                 gname = "first.treat", data = mpdta,
                 control_group = "nevertreated", clustervars = "countyreal")
cs_nt_simple <- aggte(cs_nt, type = "simple")

## --- (1c) Sun-Abraham (fixest::sunab) -----------------------------------
mpdta$first.treat2 <- ifelse(mpdta$first.treat == 0, 10000, mpdta$first.treat)
sa <- feols(lemp ~ sunab(first.treat2, year) | countyreal + year,
            data = mpdta, cluster = "countyreal")
sa_att <- summary(sa, agg = "att")$coeftable["ATT", "Estimate"]
sa_se  <- summary(sa, agg = "att")$coeftable["ATT", "Std. Error"]

## --- (1c, alt) staggered (Roth-Sant'Anna) — THE SENTINEL-VALUE TRAP ----
## WRONG: reusing mpdta's own convention (0 = never treated) in a package
## that requires Inf for never-treated. Kept here to document the failure
## mode; graded submissions should NOT reproduce this number as their answer.
st_wrong <- staggered(df = mpdta, i = "countyreal", t = "year",
                       g = "first.treat", y = "lemp", estimand = "simple")

## RIGHT: recode never-treated to Inf per staggered's own documentation.
mpdta$g_inf <- ifelse(mpdta$first.treat == 0, Inf, mpdta$first.treat)
st_right <- staggered(df = mpdta, i = "countyreal", t = "year",
                       g = "g_inf", y = "lemp", estimand = "simple")

## --- (2) Goodman-Bacon decomposition -------------------------------------
bd <- bacon(lemp ~ D, data = mpdta, id_var = "countyreal", time_var = "year")
weight_by_type <- aggregate(weight ~ type, data = bd, FUN = sum)
forbidden_weight <- weight_by_type$weight[weight_by_type$type == "Later vs Earlier Treated"]

## --- (3) Event-study / pre-trend check -----------------------------------
cs_dyn <- aggte(cs_nyt, type = "dynamic", min_e = -2, max_e = 1)

## --- Assemble the estimates table ----------------------------------------
estimates <- data.frame(
  estimator = c("Naive TWFE", "Callaway-Sant'Anna (not-yet-treated)",
                "Callaway-Sant'Anna (never-treated)", "Sun-Abraham (fixest::sunab)",
                "Roth-Sant'Anna (staggered, correct Inf coding)",
                "Roth-Sant'Anna (staggered, WRONG 0 coding — the trap)"),
  att = c(twfe_att, cs_nyt_simple$overall.att, cs_nt_simple$overall.att, sa_att,
          st_right$estimate, st_wrong$estimate),
  se  = c(twfe_se, cs_nyt_simple$overall.se, cs_nt_simple$overall.se, sa_se,
          st_right$se, st_wrong$se)
)
write.csv(estimates, "estimates-table-data.csv", row.names = FALSE)

cat("=== Estimates ===\n"); print(estimates, digits = 4)
cat("\n=== Bacon decomposition weight by type ===\n"); print(weight_by_type)
cat("\nForbidden (later-vs-earlier-treated) weight share:", forbidden_weight, "\n")
cat("\n=== Event-study dynamic effects ===\n"); print(summary(cs_dyn))

## --- Figure: event study --------------------------------------------------
ev <- data.frame(
  event_time = cs_dyn$egt,
  att        = cs_dyn$att.egt,
  se         = cs_dyn$se.egt
)
ev$lo <- ev$att - 1.96 * ev$se
ev$hi <- ev$att + 1.96 * ev$se

p <- ggplot(ev, aes(x = event_time, y = att)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
  geom_vline(xintercept = -0.5, linetype = "dotted", color = okabe_ito["vermillion"]) +
  geom_pointrange(aes(ymin = lo, ymax = hi), color = okabe_ito["blue"], size = 0.6) +
  scale_x_continuous(breaks = ev$event_time) +
  labs(x = "Event time (years relative to first minimum-wage increase)",
       y = "ATT on log teen employment") +
  theme_okabe
ggsave("figures/event-study.png", p, width = 7, height = 4.5, dpi = 320)

cat("\nDone. See estimates-table-data.csv, figures/event-study.png\n")
