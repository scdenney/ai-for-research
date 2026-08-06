set.seed(4601)

suppressPackageStartupMessages({
  library(did)
  library(fixest)
  library(staggered)
  library(bacondecomp)
  library(ggplot2)
})

# Okabe-Ito colorblind-safe palette and a reusable publication theme.
okabe_ito <- c(
  black = "#000000",
  orange = "#E69F00",
  sky_blue = "#56B4E9",
  bluish_green = "#009E73",
  yellow = "#F0E442",
  blue = "#0072B2",
  vermillion = "#D55E00",
  reddish_purple = "#CC79A7"
)

theme_event_study <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    axis.title = element_text(color = okabe_ito[["black"]]),
    axis.text = element_text(color = okabe_ito[["black"]]),
    plot.margin = margin(8, 12, 8, 8)
  )

data("mpdta", package = "did")
mpdta$treated <- as.integer(
  mpdta$first.treat > 0 & mpdta$year >= mpdta$first.treat
)

# 1a. Naive pooled post x ever-treated TWFE.
twfe_fit <- feols(
  lemp ~ treated | countyreal + year,
  data = mpdta,
  cluster = ~countyreal
)
twfe_table <- coeftable(twfe_fit)

# 1b. Callaway-Sant'Anna under each requested comparison group.
# With no covariates, the package's built-in DR, IPW, and regression 2x2
# estimators reduce to the same estimator. Analytical inference is clustered
# at the panel-id (county) level.
fit_cs <- function(control_group) {
  mp <- att_gt(
    yname = "lemp",
    tname = "year",
    idname = "countyreal",
    gname = "first.treat",
    xformla = ~1,
    data = mpdta,
    panel = TRUE,
    control_group = control_group,
    anticipation = 0,
    bstrap = FALSE,
    cband = FALSE,
    clustervars = "countyreal",
    est_method = "dr",
    base_period = "universal",
    print_details = FALSE
  )
  simple <- aggte(
    mp,
    type = "simple",
    na.rm = TRUE,
    bstrap = FALSE,
    cband = FALSE,
    clustervars = "countyreal"
  )
  list(mp = mp, simple = simple)
}

cs_notyet <- fit_cs("notyettreated")
cs_never <- fit_cs("nevertreated")

# 1c. Sun-Abraham interaction-weighted ATT. In fixest::sunab, a cohort value
# outside the observed period range is treated as never treated. Thus 0 is a
# valid never-treated code here because observed years run from 2003 to 2007.
sunab_fit <- feols(
  lemp ~ sunab(first.treat, year) | countyreal + year,
  data = mpdta,
  cluster = ~countyreal
)
sunab_att <- summary(sunab_fit, agg = "ATT")
sunab_table <- coeftable(sunab_att)

# Extra modern estimator: Roth-Sant'Anna's efficient staggered estimator.
# This package, unlike did, requires Inf rather than 0 for never-treated units.
staggered_data <- data.frame(
  i = mpdta$countyreal,
  t = mpdta$year,
  g = ifelse(mpdta$first.treat == 0, Inf, mpdta$first.treat),
  y = mpdta$lemp
)
staggered_att <- staggered(
  df = staggered_data,
  i = "i",
  t = "t",
  g = "g",
  y = "y",
  estimand = "simple",
  compute_fisher = FALSE
)

# 2. Goodman-Bacon decomposition of the exact treatment indicator in TWFE.
bacon_result <- bacon(
  lemp ~ treated,
  data = mpdta,
  id_var = "countyreal",
  time_var = "year",
  quietly = TRUE
)
bacon_by_type <- aggregate(
  cbind(weight, contribution = weight * estimate) ~ type,
  data = bacon_result,
  FUN = sum
)

get_bacon_value <- function(type_label, column) {
  bacon_by_type[bacon_by_type$type == type_label, column, drop = TRUE]
}

dangerous_share <- get_bacon_value("Later vs Earlier Treated", "weight")
clean_never_share <- get_bacon_value("Treated vs Untreated", "weight")
clean_notyet_share <- get_bacon_value("Earlier vs Later Treated", "weight")
dangerous_contribution <- get_bacon_value(
  "Later vs Earlier Treated", "contribution"
)
clean_never_contribution <- get_bacon_value(
  "Treated vs Untreated", "contribution"
)

stopifnot(
  abs(sum(bacon_result$weight) - 1) < 1e-10,
  abs(sum(bacon_result$weight * bacon_result$estimate) -
        coef(twfe_fit)[["treated"]]) < 1e-10
)

# 3. Event-study from the never-treated Callaway-Sant'Anna specification.
dynamic_att <- aggte(
  cs_never$mp,
  type = "dynamic",
  min_e = -3,
  max_e = 3,
  na.rm = TRUE,
  bstrap = FALSE,
  cband = FALSE,
  clustervars = "countyreal"
)

event_study <- data.frame(
  event_time = dynamic_att$egt,
  estimate = dynamic_att$att.egt,
  std_error = dynamic_att$se.egt
)
event_study$conf_low <- event_study$estimate -
  qnorm(0.975) * event_study$std_error
event_study$conf_high <- event_study$estimate +
  qnorm(0.975) * event_study$std_error

event_plot <- ggplot(event_study, aes(x = event_time, y = estimate)) +
  geom_hline(
    yintercept = 0,
    color = okabe_ito[["black"]],
    linewidth = 0.4
  ) +
  geom_vline(
    xintercept = 0,
    color = okabe_ito[["orange"]],
    linewidth = 0.7,
    linetype = "dashed"
  ) +
  geom_line(color = okabe_ito[["blue"]], linewidth = 0.6) +
  geom_errorbar(
    data = subset(event_study, !is.na(std_error)),
    aes(ymin = conf_low, ymax = conf_high),
    color = okabe_ito[["blue"]],
    width = 0.12,
    linewidth = 0.6
  ) +
  geom_point(
    color = okabe_ito[["blue"]],
    fill = "white",
    shape = 21,
    size = 2.6,
    stroke = 0.8
  ) +
  scale_x_continuous(breaks = -3:3) +
  labs(
    x = "Event time (years relative to treatment)",
    y = "ATT on log teen employment (log points)"
  ) +
  theme_event_study

dir.create("figures", showWarnings = FALSE, recursive = TRUE)
ggsave(
  filename = "figures/event-study.png",
  plot = event_plot,
  width = 7,
  height = 4.5,
  units = "in",
  dpi = 320,
  bg = "white"
)

# Reproducible Markdown estimator table.
estimates <- data.frame(
  estimator = c(
    "Naive TWFE (post x ever-treated)",
    "Callaway-Sant'Anna",
    "Callaway-Sant'Anna",
    "Sun-Abraham",
    "Roth-Sant'Anna (staggered)"
  ),
  att = c(
    twfe_table["treated", "Estimate"],
    cs_notyet$simple$overall.att,
    cs_never$simple$overall.att,
    sunab_table["ATT", "Estimate"],
    staggered_att$estimate[[1]]
  ),
  std_error = c(
    twfe_table["treated", "Std. Error"],
    cs_notyet$simple$overall.se,
    cs_never$simple$overall.se,
    sunab_table["ATT", "Std. Error"],
    staggered_att$se[[1]]
  ),
  comparison_group = c(
    "Pooled TWFE; already-treated counties may act as controls",
    "Never-treated and not-yet-treated counties",
    "Never-treated counties only",
    "Never-treated reference cohort; cohort x event-time interactions",
    "Not-yet-/never-treated cohorts; native efficient adjustment"
  ),
  stringsAsFactors = FALSE
)

table_lines <- c(
  "# ATT estimates",
  "",
  "All effects are in log points of teen employment.",
  "",
  "| Estimator | ATT | Standard error | Control/comparison group |",
  "|---|---:|---:|---|",
  sprintf(
    "| %s | %.4f | %.4f | %s |",
    estimates$estimator,
    estimates$att,
    estimates$std_error,
    estimates$comparison_group
  ),
  "",
  paste0(
    "*Notes:* TWFE and Sun-Abraham standard errors are clustered by county. ",
    "Callaway-Sant'Anna uses analytical county-level clustered inference. ",
    "Roth-Sant'Anna reports `staggered`'s native unit-level standard error. ",
    "All estimators are unweighted and include no covariates."
  )
)
writeLines(table_lines, "estimates-table.md")

# Console diagnostics make the key reconciliation directly auditable.
cat("\nATT estimates (log points):\n")
print(estimates, row.names = FALSE, digits = 6)
cat("\nGoodman-Bacon weight shares and weighted contributions:\n")
print(bacon_by_type, row.names = FALSE, digits = 7)
cat(sprintf(
  paste0(
    "\nPotentially contaminated Later-vs-Earlier share: %.4f%% ",
    "(contribution %.6f)\n"
  ),
  100 * dangerous_share,
  dangerous_contribution
))
cat(sprintf(
  paste0(
    "Clean Treated-vs-Never share: %.4f%% (contribution %.6f)\n",
    "Clean Earlier-vs-Later/not-yet share: %.4f%%\n"
  ),
  100 * clean_never_share,
  clean_never_contribution,
  100 * clean_notyet_share
))
cat(sprintf(
  "Bacon reconstruction: %.8f; TWFE coefficient: %.8f\n",
  sum(bacon_result$weight * bacon_result$estimate),
  coef(twfe_fit)[["treated"]]
))
cat("\nDynamic Callaway-Sant'Anna estimates:\n")
print(event_study, row.names = FALSE, digits = 6)
cat(sprintf(
  "Omnibus pre-treatment Wald-test p-value: %.6f\n",
  as.numeric(cs_never$mp$Wpval)
))
