#!/usr/bin/env Rscript

set.seed(4602)

okabe_ito <- c(
  orange = "#E69F00", sky_blue = "#56B4E9", bluish_green = "#009E73",
  yellow = "#F0E442", blue = "#0072B2", vermillion = "#D55E00",
  reddish_purple = "#CC79A7", black = "#000000"
)
plot_theme <- ggplot2::theme_minimal(base_size = 11) +
  ggplot2::theme(
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major.x = ggplot2::element_blank(),
    axis.title = ggplot2::element_text(colour = okabe_ito[["black"]])
  )

suppressPackageStartupMessages({
  library(did)
  library(fixest)
  library(staggered)
  library(bacondecomp)
  library(ggplot2)
})

data("mpdta", package = "did")
stopifnot(
  nrow(mpdta) == 2500L,
  length(unique(mpdta$countyreal)) == 500L,
  all(mpdta$first.treat %in% c(0, 2004, 2006, 2007))
)

# Treatment starts in the first-treatment year. The source variable uses 0 for
# never treated, which is the convention did::att_gt expects.
mpdta$post_treated <- as.integer(
  mpdta$first.treat > 0 & mpdta$year >= mpdta$first.treat
)

twfe <- feols(
  lemp ~ post_treated | countyreal + year,
  data = mpdta,
  cluster = ~countyreal
)
twfe_att <- unname(coef(twfe)["post_treated"])
twfe_se <- unname(se(twfe)["post_treated"])

did_args <- list(
  yname = "lemp", tname = "year", idname = "countyreal",
  gname = "first.treat", xformla = ~1, data = mpdta,
  panel = TRUE, clustervars = "countyreal", base_period = "universal",
  bstrap = TRUE, biters = 999, alp = 0.05, cband = FALSE, cores = 1
)
cs_notyet <- do.call(
  att_gt, c(did_args, list(control_group = "notyettreated"))
)
cs_never <- do.call(
  att_gt, c(did_args, list(control_group = "nevertreated"))
)
cs_notyet_simple <- aggte(
  cs_notyet, type = "simple", bstrap = TRUE, biters = 999,
  cband = FALSE, alp = 0.05
)
cs_never_simple <- aggte(
  cs_never, type = "simple", bstrap = TRUE, biters = 999,
  cband = FALSE, alp = 0.05
)

# fixest::sunab treats a cohort absent from the observed period support as
# never treated; 9999 is outside 2003--2007.
mpdta$sunab_cohort <- ifelse(mpdta$first.treat == 0, 9999, mpdta$first.treat)
sunab_fit <- feols(
  lemp ~ sunab(sunab_cohort, year) | countyreal + year,
  data = mpdta,
  cluster = ~countyreal
)
sunab_att_summary <- summary(sunab_fit, agg = "ATT")
sunab_att <- unname(coef(sunab_att_summary)[1])
sunab_se <- unname(se(sunab_att_summary)[1])

# staggered::staggered instead requires Inf for never-treated cohorts. Never
# pass mpdta$first.treat unchanged here: its zeros are not the package sentinel.
staggered_data <- data.frame(
  i = mpdta$countyreal,
  t = mpdta$year,
  g = ifelse(mpdta$first.treat == 0, Inf, mpdta$first.treat),
  y = mpdta$lemp
)
rs_simple <- staggered(
  staggered_data, i = "i", t = "t", g = "g", y = "y",
  estimand = "simple"
)
rs_att <- rs_simple$estimate[1]
rs_se <- rs_simple$se[1]

# Decompose the exact binary regressor used by TWFE and verify reconstruction.
bacon_out <- bacon(
  lemp ~ post_treated, data = mpdta,
  id_var = "countyreal", time_var = "year", quietly = TRUE
)
bacon_weight_sum <- sum(bacon_out$weight)
bacon_reconstructed <- sum(bacon_out$estimate * bacon_out$weight)
stopifnot(
  isTRUE(all.equal(bacon_weight_sum, 1, tolerance = 1e-8)),
  isTRUE(all.equal(bacon_reconstructed, twfe_att, tolerance = 1e-8))
)
bacon_by_type <- aggregate(
  cbind(weight, contribution = estimate * weight) ~ type,
  data = bacon_out,
  FUN = sum
)

dynamic_never <- aggte(
  cs_never, type = "dynamic", min_e = -3, max_e = 3,
  bstrap = TRUE, biters = 999, cband = FALSE, alp = 0.05
)
dynamic <- data.frame(
  event_time = dynamic_never$egt,
  att = dynamic_never$att.egt,
  se = dynamic_never$se.egt
)
dynamic <- dynamic[dynamic$event_time >= -3 & dynamic$event_time <= 3, ]
if (!any(dynamic$event_time == -1)) {
  dynamic <- rbind(dynamic, data.frame(event_time = -1, att = 0, se = 0))
} else {
  dynamic[dynamic$event_time == -1, c("att", "se")] <- c(0, 0)
}
dynamic <- dynamic[order(dynamic$event_time), ]
dynamic$lower <- dynamic$att - dynamic_never$crit.val.egt * dynamic$se
dynamic$upper <- dynamic$att + dynamic_never$crit.val.egt * dynamic$se
pretrend_p <- cs_never$Wpval[1, 1]

dir.create("figures", showWarnings = FALSE, recursive = TRUE)
event_plot <- ggplot(dynamic, aes(x = event_time, y = att)) +
  geom_hline(yintercept = 0, colour = "grey55", linewidth = 0.35) +
  geom_vline(
    xintercept = 0, colour = okabe_ito[["vermillion"]],
    linetype = "dashed", linewidth = 0.45
  ) +
  geom_errorbar(
    aes(ymin = lower, ymax = upper), width = 0.09,
    colour = okabe_ito[["blue"]]
  ) +
  geom_point(size = 2.1, colour = okabe_ito[["blue"]]) +
  scale_x_continuous(breaks = -3:3) +
  labs(x = "Event time", y = "ATT on log employment") +
  plot_theme
ggsave(
  "figures/event-study.png", event_plot,
  width = 7, height = 4.5, units = "in", dpi = 320
)

estimates <- data.frame(
  estimator = c(
    "Naive TWFE",
    "Callaway-Sant'Anna (not-yet-treated)",
    "Callaway-Sant'Anna (never-treated)",
    "Sun-Abraham",
    "Roth-Sant'Anna staggered"
  ),
  att = c(
    twfe_att, cs_notyet_simple$overall.att, cs_never_simple$overall.att,
    sunab_att, rs_att
  ),
  se = c(
    twfe_se, cs_notyet_simple$overall.se, cs_never_simple$overall.se,
    sunab_se, rs_se
  ),
  comparison_group = c(
    "Post × ever-treated; county and year fixed effects",
    "Not-yet-treated counties (including never-treated)",
    "Never-treated counties; did sentinel first.treat = 0",
    "Never-treated cohort; out-of-window sunab sentinel = 9999",
    "Native staggered comparison set; never-treated g = Inf"
  )
)

table_lines <- c(
  "| Estimator | ATT | SE | Control/comparison group |",
  "|---|---:|---:|---|",
  vapply(seq_len(nrow(estimates)), function(k) sprintf(
    "| %s | %.6f | %.6f | %s |",
    estimates$estimator[k], estimates$att[k], estimates$se[k],
    estimates$comparison_group[k]
  ), character(1))
)
writeLines(table_lines, "estimates-table.md")

cat("ATT estimates (ATT, SE):\n")
for (k in seq_len(nrow(estimates))) {
  cat(sprintf(
    "%s: %.8f, %.8f\n",
    estimates$estimator[k], estimates$att[k], estimates$se[k]
  ))
}
cat("\nBacon type shares and weighted contributions:\n")
print(bacon_by_type, row.names = FALSE)
cat(sprintf("Bacon weights sum: %.12f\n", bacon_weight_sum))
cat(sprintf(
  "Bacon weighted sum: %.12f; TWFE: %.12f\n",
  bacon_reconstructed, twfe_att
))
cat("\nNever-treated C&S dynamic estimates (pointwise 95% intervals):\n")
print(dynamic, row.names = FALSE)
cat(sprintf("Joint pretrend p-value: %.8f\n", pretrend_p))
