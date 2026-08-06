suppressPackageStartupMessages({
  library(did)
  library(fixest)
  library(staggered)
  library(bacondecomp)
  library(ggplot2)
})

# Okabe-Ito palette and a common plot theme are declared before analysis.
okabe_ito <- c(
  orange = "#E69F00", sky_blue = "#56B4E9", bluish_green = "#009E73",
  yellow = "#F0E442", blue = "#0072B2", vermillion = "#D55E00",
  reddish_purple = "#CC79A7", black = "#000000"
)
theme_paper <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    axis.title = element_text(colour = okabe_ito[["black"]]),
    axis.text = element_text(colour = okabe_ito[["black"]]),
    plot.margin = margin(8, 12, 8, 8)
  )

# The multiplier bootstrap used by did is the only stochastic operation.
set.seed(4601)

data(mpdta, package = "did")
d <- mpdta
d$ever_treated <- as.integer(d$first.treat > 0)
d$post <- as.integer(d$year >= ifelse(d$ever_treated == 1, d$first.treat, Inf))
d$post_x_ever <- d$post * d$ever_treated
d$g_staggered <- ifelse(d$first.treat == 0, Inf, d$first.treat)

stopifnot(
  nrow(d) == 2500L,
  length(unique(d$countyreal)) == 500L,
  all(table(d$countyreal) == 5L),
  all(sort(unique(d$first.treat)) == c(0, 2004, 2006, 2007)),
  all(d$ever_treated == d$treat),
  all(is.infinite(d$g_staggered[d$first.treat == 0]))
)

# All specifications are unadjusted, so estimator differences are not driven
# by different uses of lpop. This is also the exact specification decomposed
# by bacondecomp below.
twfe <- feols(
  lemp ~ post_x_ever | countyreal + year,
  data = d,
  cluster = ~countyreal
)
twfe_ct <- coeftable(twfe)

fit_cs <- function(control) {
  att_gt(
    yname = "lemp",
    tname = "year",
    idname = "countyreal",
    gname = "first.treat",
    xformla = ~1,
    data = d,
    panel = TRUE,
    control_group = control,
    clustervars = "countyreal",
    est_method = "dr",
    base_period = "varying",
    bstrap = TRUE,
    cband = TRUE,
    biters = 999,
    print_details = FALSE
  )
}

cs_nyt_gt <- fit_cs("notyettreated")
cs_never_gt <- fit_cs("nevertreated")
cs_nyt <- aggte(
  cs_nyt_gt, type = "simple", bstrap = TRUE, cband = TRUE, biters = 999
)
cs_never <- aggte(
  cs_never_gt, type = "simple", bstrap = TRUE, cband = TRUE, biters = 999
)

# The conventional Sun-Abraham overall ATT uses never-treated counties as the
# reference cohort. With calendar years 2003--2007, fixest correctly recognizes
# first.treat == 0 as a cohort outside the observed periods (never treated).
sa_fit <- feols(
  lemp ~ sunab(first.treat, year) | countyreal + year,
  data = d,
  cluster = ~countyreal
)
sa_att <- aggregate(sa_fit, agg = "ATT", vcov = ~countyreal)

# staggered has a different sentinel: Inf, not 0, denotes never treated.
rs_att <- staggered::staggered(
  df = d,
  i = "countyreal",
  t = "year",
  g = "g_staggered",
  y = "lemp",
  estimand = "simple"
)

# Goodman-Bacon decomposition of the same unadjusted TWFE regression.
bacon_fit <- bacondecomp::bacon(
  lemp ~ post_x_ever,
  data = d,
  id_var = "countyreal",
  time_var = "year",
  quietly = TRUE
)
bacon_weights <- aggregate(weight ~ type, data = bacon_fit, FUN = sum)
weight_for <- function(type) bacon_weights$weight[bacon_weights$type == type]
w_early_late <- weight_for("Earlier vs Later Treated")
w_late_early <- weight_for("Later vs Earlier Treated")
w_treated_never <- weight_for("Treated vs Untreated")
stopifnot(abs(sum(bacon_weights$weight) - 1) < 1e-10)
stopifnot(
  abs(
    sum(bacon_fit$estimate * bacon_fit$weight) -
      twfe_ct["post_x_ever", "Estimate"]
  ) < 1e-10
)

# Dynamic C&S estimates use not-yet-treated controls. The package's multiplier-
# bootstrap critical value yields simultaneous 95% confidence intervals.
dynamic <- aggte(
  cs_nyt_gt,
  type = "dynamic",
  min_e = -3,
  max_e = 3,
  bstrap = TRUE,
  cband = TRUE,
  biters = 999
)
event_df <- data.frame(
  event_time = dynamic$egt,
  estimate = dynamic$att.egt,
  se = dynamic$se.egt
)
event_df$conf_low <- event_df$estimate - dynamic$crit.val.egt * event_df$se
event_df$conf_high <- event_df$estimate + dynamic$crit.val.egt * event_df$se

dir.create("figures", showWarnings = FALSE, recursive = TRUE)
event_plot <- ggplot(event_df, aes(x = event_time, y = estimate)) +
  geom_hline(yintercept = 0, colour = "grey45", linewidth = 0.45) +
  geom_vline(
    xintercept = -0.5,
    colour = okabe_ito[["vermillion"]],
    linetype = "dashed",
    linewidth = 0.65
  ) +
  geom_errorbar(
    aes(ymin = conf_low, ymax = conf_high),
    width = 0.12,
    colour = okabe_ito[["blue"]],
    linewidth = 0.7
  ) +
  geom_point(
    colour = okabe_ito[["blue"]],
    fill = "white",
    shape = 21,
    size = 2.7,
    stroke = 0.8
  ) +
  scale_x_continuous(breaks = -3:3) +
  labs(
    x = "Years relative to first treatment",
    y = "ATT on log teen employment"
  ) +
  theme_paper

ggsave(
  filename = file.path("figures", "event-study.png"),
  plot = event_plot,
  width = 7,
  height = 4.5,
  units = "in",
  dpi = 320,
  bg = "white"
)

# Collate every estimator requested (plus the Roth-Sant'Anna cross-check).
estimates <- data.frame(
  estimator = c(
    "Naive TWFE",
    "Callaway-Sant'Anna",
    "Callaway-Sant'Anna",
    "Sun-Abraham",
    "Roth-Sant'Anna"
  ),
  att = c(
    twfe_ct["post_x_ever", "Estimate"],
    cs_nyt$overall.att,
    cs_never$overall.att,
    sa_att["ATT", "Estimate"],
    rs_att$estimate[1]
  ),
  se = c(
    twfe_ct["post_x_ever", "Std. Error"],
    cs_nyt$overall.se,
    cs_never$overall.se,
    sa_att["ATT", "Std. Error"],
    rs_att$se[1]
  ),
  comparison = c(
    "Implicit Bacon mix of never-, not-yet-, and already-treated comparisons",
    "Not-yet-treated (including never-treated)",
    "Never-treated only (`first.treat = 0`)",
    "Never-treated reference cohort (`first.treat = 0`)",
    "Eligible not-yet-treated cohorts; never-treated recoded to `Inf`"
  ),
  inference = c(
    "County-clustered",
    "County-level multiplier bootstrap",
    "County-level multiplier bootstrap",
    "County-clustered",
    "Native design-based SE"
  ),
  stringsAsFactors = FALSE
)

table_header <- c(
  "# ATT estimates",
  "",
  "| Estimator | ATT | Standard error | Control/comparison group | Inference |",
  "|:--|--:|--:|:--|:--|"
)
table_rows <- sprintf(
  "| %s | %.4f | %.4f | %s | %s |",
  estimates$estimator,
  estimates$att,
  estimates$se,
  estimates$comparison,
  estimates$inference
)
table_notes <- c(
  "",
  "All specifications use `lemp` as the outcome and are unadjusted for `lpop`, so differences are not due to different covariate sets. Callaway-Sant'Anna uses the doubly robust estimator with an intercept-only covariate formula and 999 multiplier-bootstrap iterations."
)
writeLines(c(table_header, table_rows, table_notes), "estimates-table.md")

bad_component <- subset(bacon_fit, type == "Later vs Earlier Treated")
bad_avg <- weighted.mean(bad_component$estimate, bad_component$weight)
att_report <- cs_nyt$overall.att
att_report_pct <- 100 * (exp(att_report) - 1)
twfe_gap <- abs(twfe_ct["post_x_ever", "Estimate"] - att_report)

memo <- sprintf(
  paste0(
    "# Adjudication memo\n\n",
    "The textbook two-way fixed-effects estimate is %.4f log points (SE %.4f), implying lower teen employment after a minimum-wage increase. The heterogeneity-robust estimates point the same way. Callaway-Sant'Anna's simple ATT is %.4f (SE %.4f) with not-yet-treated controls and %.4f (SE %.4f) with never-treated controls. Sun-Abraham gives %.4f (SE %.4f), while the Roth-Sant'Anna efficient estimator is %.4f (SE %.4f). Thus the central robust estimates cluster near minus 0.04 log points; Roth-Sant'Anna is somewhat larger in magnitude but does not reverse the result. All specifications are unadjusted for population, keeping their comparison focused on estimator construction rather than covariate choice.\n\n",
    "The Goodman-Bacon decomposition explains why TWFE happens to be close here. Treated-versus-never-treated comparisons receive %.2f%% of the identifying weight. The specifically suspect later-versus-earlier-treated comparisons, in which an already-treated cohort is the control, receive only %.2f%%; their weighted-average 2x2 estimate is %.4f. Another %.2f%% comes from earlier-versus-later-treated comparisons while the later cohort is not yet treated. The problematic component therefore slightly attenuates the negative estimate, but it is too small to dominate it. The gap between TWFE and the preferred Callaway-Sant'Anna estimate is only %.4f log points. This is evidence about this panel, not a general defense of TWFE.\n\n",
    "The dynamic Callaway-Sant'Anna estimates also offer qualified reassurance. The varying-base pre-treatment pseudo-ATTs at event times -3, -2, and -1 are %.4f, %.4f, and %.4f. None excludes zero using the plotted simultaneous 95%% bands, and the package's omnibus pre-trends test has p = %.3f. Parallel trends is therefore not rejected. Still, five annual observations provide limited power, so this should be read as support rather than proof. Post-treatment effects become more negative with exposure, reaching about %.3f at event time 2, which is exactly the kind of heterogeneity that makes the diagnostic worth running.\n\n",
    "For reporting, I would use the Callaway-Sant'Anna simple ATT with not-yet-treated controls: %.4f log points (SE %.4f), or roughly %.1f%% lower teen employment. It avoids already-treated controls while using all valid comparison units. The classic staggered-adoption critique changes the preferred estimator and motivates the decomposition, but it does not change this dataset's substantive conclusion: the estimated average effect is negative and in the ballpark of four percent."
  ),
  twfe_ct["post_x_ever", "Estimate"],
  twfe_ct["post_x_ever", "Std. Error"],
  cs_nyt$overall.att, cs_nyt$overall.se,
  cs_never$overall.att, cs_never$overall.se,
  sa_att["ATT", "Estimate"], sa_att["ATT", "Std. Error"],
  rs_att$estimate[1], rs_att$se[1],
  100 * w_treated_never, 100 * w_late_early, bad_avg,
  100 * w_early_late, twfe_gap,
  event_df$estimate[event_df$event_time == -3],
  event_df$estimate[event_df$event_time == -2],
  event_df$estimate[event_df$event_time == -1],
  cs_nyt_gt$Wpval,
  event_df$estimate[event_df$event_time == 2],
  att_report, cs_nyt$overall.se, abs(att_report_pct)
)
writeLines(memo, "memo.md")

cat("\nEstimator table:\n")
print(estimates, row.names = FALSE)
cat("\nBacon weights by comparison type:\n")
print(bacon_weights, row.names = FALSE)
cat(sprintf("\nPre-trends omnibus p-value: %.4f\n", cs_nyt_gt$Wpval))
cat("\nDynamic estimates and simultaneous 95% intervals:\n")
print(event_df, row.names = FALSE)
