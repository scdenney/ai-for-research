set.seed(20260719)

# Packages and plot styling ---------------------------------------------------
library(did)
library(fixest)
library(bacondecomp)
library(ggplot2)

# Okabe-Ito palette and a single reusable plotting theme.
okabe_ito <- c(
  orange = "#E69F00", sky_blue = "#56B4E9", bluish_green = "#009E73",
  yellow = "#F0E442", blue = "#0072B2", vermillion = "#D55E00",
  purple = "#CC79A7", grey = "#666666"
)
event_theme <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    axis.title = element_text(color = "black"),
    axis.text = element_text(color = "black")
  )

# Data and common treatment indicator ----------------------------------------
data(mpdta, package = "did")
dat <- mpdta

# The requested textbook/TWFE regressor: post period times ever-treated.
dat$ever_treated <- as.integer(dat$first.treat > 0)
dat$post <- as.integer(dat$ever_treated == 1 & dat$year >= dat$first.treat)
dat$did_treat <- dat$ever_treated * dat$post

# (a) Naive two-way fixed effects, clustered by county.
twfe <- feols(
  lemp ~ did_treat | countyreal + year,
  data = dat,
  cluster = ~countyreal
)

# (b) Callaway-Sant'Anna. `first.treat == 0` is the documented did-package
# convention for never-treated counties. No covariates are included so that
# all estimates target the same unconditional outcome specification as TWFE.
boot_iterations <- 1999
cs_notyet <- att_gt(
  yname = "lemp", tname = "year", idname = "countyreal",
  gname = "first.treat", data = dat,
  control_group = "notyettreated", base_period = "universal",
  bstrap = TRUE, biters = boot_iterations, cband = FALSE,
  clustervars = "countyreal"
)
cs_never <- att_gt(
  yname = "lemp", tname = "year", idname = "countyreal",
  gname = "first.treat", data = dat,
  control_group = "nevertreated", base_period = "universal",
  bstrap = TRUE, biters = boot_iterations, cband = FALSE,
  clustervars = "countyreal"
)
cs_notyet_simple <- aggte(
  cs_notyet, type = "simple", bstrap = TRUE,
  biters = boot_iterations, cband = FALSE
)
cs_never_simple <- aggte(
  cs_never, type = "simple", bstrap = TRUE,
  biters = boot_iterations, cband = FALSE
)

# (c) Sun--Abraham interaction-weighted event-study estimator. Setting
# ref.c = 0 makes the never-treated cohort the reference group; the model
# includes county and calendar-year fixed effects and county-clustered SEs.
sunab_model <- feols(
  lemp ~ sunab(first.treat, year, ref.c = 0) | countyreal + year,
  data = dat,
  cluster = ~countyreal
)
sunab_att <- summary(sunab_model, agg = "ATT")

# Goodman-Bacon decomposition of the exact TWFE treatment indicator.
bacon_results <- bacon(
  lemp ~ did_treat, data = dat, id_var = "countyreal", time_var = "year",
  quietly = TRUE
)
bacon_weights <- aggregate(weight ~ type, data = bacon_results, FUN = sum)
later_earlier_weight <- bacon_weights$weight[
  bacon_weights$type == "Later vs Earlier Treated"
]
treated_untreated_weight <- bacon_weights$weight[
  bacon_weights$type == "Treated vs Untreated"
]

# Event study: universal base period makes event time -1 the reference period.
event_dynamic <- aggte(
  cs_notyet, type = "dynamic", min_e = -4, max_e = 3,
  bstrap = TRUE, biters = boot_iterations, cband = FALSE
)
event_df <- data.frame(
  event_time = event_dynamic$egt,
  estimate = event_dynamic$att.egt,
  se = event_dynamic$se.egt
)
event_df$lower <- event_df$estimate - qnorm(0.975) * event_df$se
event_df$upper <- event_df$estimate + qnorm(0.975) * event_df$se

dir.create("figures", showWarnings = FALSE, recursive = TRUE)
event_plot <- ggplot(event_df, aes(x = event_time, y = estimate)) +
  geom_hline(yintercept = 0, color = okabe_ito[["grey"]], linewidth = 0.35) +
  geom_vline(xintercept = 0, color = okabe_ito[["orange"]],
             linetype = "dashed", linewidth = 0.6) +
  geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.10,
                color = okabe_ito[["blue"]], na.rm = TRUE) +
  geom_line(color = okabe_ito[["blue"]], linewidth = 0.5, na.rm = TRUE) +
  geom_point(color = okabe_ito[["blue"]], size = 2.2, na.rm = TRUE) +
  scale_x_continuous(breaks = event_df$event_time) +
  labs(
    x = "Event time (years relative to first treatment)",
    y = "ATT on log employment"
  ) +
  event_theme
ggsave(
  filename = "figures/event-study.png", plot = event_plot,
  width = 7, height = 4.5, units = "in", dpi = 320
)

# Required estimator table ----------------------------------------------------
twfe_se <- sqrt(diag(vcov(twfe)))["did_treat"]
estimates <- data.frame(
  estimator = c(
    "Naive TWFE",
    "Callaway-Sant'Anna",
    "Callaway-Sant'Anna",
    "Sun-Abraham interaction-weighted"
  ),
  att = c(
    unname(coef(twfe)["did_treat"]),
    cs_notyet_simple$overall.att,
    cs_never_simple$overall.att,
    unname(coef(sunab_att)["ATT"])
  ),
  se = c(
    unname(twfe_se),
    cs_notyet_simple$overall.se,
    cs_never_simple$overall.se,
    unname(se(sunab_att)["ATT"])
  ),
  comparison = c(
    "Post x ever-treated; county and year FE; county-clustered SE",
    "Not-yet-treated (includes never-treated); county-clustered multiplier bootstrap",
    "Never-treated; county-clustered multiplier bootstrap",
    "Never-treated counties (first.treat = 0) as reference; county and year FE; county-clustered SE"
  ),
  check.names = FALSE
)

table_lines <- c(
  "| Estimator | ATT (log points) | Standard error | Control / comparison group |",
  "|---|---:|---:|---|",
  vapply(seq_len(nrow(estimates)), function(i) {
    sprintf(
      "| %s | %.4f | %.4f | %s |",
      estimates$estimator[i], estimates$att[i], estimates$se[i],
      estimates$comparison[i]
    )
  }, character(1)),
  "",
  "All estimates are unadjusted for covariates and use `lemp` as the outcome, matching the requested TWFE specification."
)
writeLines(table_lines, "estimates-table.md")

# Printed values support the accompanying memo and make the decomposition
# auditable without adding an unrequested output file.
print(estimates)
print(bacon_weights)
message(sprintf(
  "Bacon weight: later-vs-earlier = %.2f%%; treated-vs-untreated = %.2f%%.",
  100 * later_earlier_weight, 100 * treated_untreated_weight
))
message(sprintf(
  "C&S pre-trend Wald-test p-value (not-yet-treated controls): %.4f.",
  cs_notyet$Wpval
))
print(event_df)
