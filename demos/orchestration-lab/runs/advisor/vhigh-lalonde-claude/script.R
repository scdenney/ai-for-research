# ---------------------------------------------------------------------------
# VHIGH -- Adjudicate a methods dispute: does propensity-score matching on
# NSW-treated + CPS-control recover the experimental LaLonde benchmark?
# Produces: spec-table.md, memo.md, figures/spec-curve.png
# ---------------------------------------------------------------------------

library(causaldata)
library(dplyr)
library(tidyr)
library(ggplot2)
library(MatchIt)
library(sandwich)
library(lmtest)

# ---- Plotting theme and palette (declared up front) ------------------------

okabe_ito <- c(
  "#E69F00", "#56B4E9", "#009E73", "#F0E442",
  "#0072B2", "#D55E00", "#CC79A7"
)

theme_lab <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor   = element_blank(),
    panel.grid.major.y = element_line(color = "grey90", linewidth = 0.3),
    panel.grid.major.x = element_blank(),
    strip.text         = element_text(face = "bold", hjust = 0, size = 10),
    strip.background   = element_blank(),
    axis.title         = element_text(color = "grey30"),
    axis.text          = element_text(color = "grey20"),
    plot.caption       = element_text(color = "grey40"),
    legend.position    = "top",
    plot.margin        = margin(8, 14, 8, 8)
  )
theme_set(theme_lab)

set.seed(20260712)

dir.create("figures", showWarnings = FALSE)

# ---- Load data ---------------------------------------------------------------

nsw <- causaldata::nsw_mixtape
cps <- causaldata::cps_mixtape

demo_covs <- c("age", "educ", "black", "hisp", "marr", "nodegree")
earn_covs <- c("re74", "re75")

# ---- 1. Experimental benchmark: treat - control diff in re78 within NSW ----

fit_bench <- lm(re78 ~ treat, data = nsw)
se_bench  <- coeftest(fit_bench, vcov = vcovHC(fit_bench, type = "HC2"))
bench_est <- unname(coef(fit_bench)["treat"])
bench_se  <- unname(se_bench["treat", "Std. Error"])
bench_lo  <- bench_est - 1.96 * bench_se
bench_hi  <- bench_est + 1.96 * bench_se

n_treat_nsw <- sum(nsw$treat == 1)
n_ctrl_nsw  <- sum(nsw$treat == 0)

message(sprintf(
  "Experimental benchmark: %.0f (SE %.0f, 95%% CI [%.0f, %.0f]), n_t=%d n_c=%d",
  bench_est, bench_se, bench_lo, bench_hi, n_treat_nsw, n_ctrl_nsw
))

# ---- 2. Observational composite: NSW treated + CPS controls ----------------

nsw_treated <- nsw |> filter(treat == 1) |> mutate(source = "nsw_treated")
cps_control <- cps |> filter(treat == 0) |> mutate(source = "cps_control")

# `data_id` is a dataset-source label ("Dehejia-Wahba Sample", "CPS1", ...),
# not a unique row identifier -- it repeats across every row of a source, so
# a fresh row id is needed to count unique matched units below.
composite <- bind_rows(nsw_treated, cps_control) |>
  mutate(unit_id = row_number()) |>
  select(unit_id, source, treat, all_of(demo_covs), all_of(earn_covs), re78)

n_treat_comp <- sum(composite$treat == 1)
n_ctrl_comp  <- sum(composite$treat == 0)

# ---- 2a. Naive: raw treat - control diff in re78, observational composite --

fit_naive <- lm(re78 ~ treat, data = composite)
se_naive  <- coeftest(fit_naive, vcov = vcovHC(fit_naive, type = "HC2"))
naive_est <- unname(coef(fit_naive)["treat"])
naive_se  <- unname(se_naive["treat", "Std. Error"])

# ---- 2b. Propensity-score matching specifications ---------------------------
# Two axes crossed: covariate set (demo vs demo + re74/re75) x estimator
# detail (1-NN w/ replacement, no trim; 1-NN w/ replacement + common-support
# trim; propensity-score stratification/subclassification), for 6 PSM specs.
#
# Standard errors: the ordinary nonparametric bootstrap is not valid for
# nearest-neighbor matching variances (Abadie & Imbens 2008), and the
# `Matching` package (which implements their closed-form estimator) is not
# installed here. The MatchIt vignette's practical alternative for
# `replace = TRUE` with a continuous outcome is match_data() -- one row per
# matched unit, weighted by how many times it was reused -- plus HC3 robust
# SEs (Hill & Reiter) on a weighted lm(); HC3's leverage adjustment is what
# accounts for reused, higher-weight controls, and this is used uniformly
# for both 1-NN and stratification below. Two clustering alternatives are
# deliberately NOT used: (1) clustering on the matched-set (subclass) id
# from get_matches() ignores that the same control can anchor *multiple*
# subclasses under replacement, which understates the SE -- the "known to be
# conservative" result in Abadie & Spiess (2022) is proved for matching
# *without* replacement and does not transfer here; (2) cluster-robust SEs
# by subclass for the stratification estimator are explicitly discouraged by
# the same MatchIt vignette (too few clusters -- 5-20 strata here), which is
# why stratification also gets plain HC3, not a clustered variant.

fit_matched <- function(covs, data, method = c("nearest", "subclass"),
                         discard = "none", subclass_n = 5) {
  method <- match.arg(method)
  form <- as.formula(paste("treat ~", paste(covs, collapse = " + ")))

  if (method == "nearest") {
    m <- matchit(
      form, data = data, method = "nearest", distance = "glm",
      link = "logit", estimand = "ATT", replace = TRUE, discard = discard
    )
  } else {
    m <- matchit(
      form, data = data, method = "subclass", distance = "glm",
      link = "logit", estimand = "ATT", subclass = subclass_n
    )
  }

  # match_data() (not get_matches()) collapses matches to one row per
  # matched unit, up-weighting controls reused across multiple treated
  # matches via the `weights` column -- the representation the HC3 SE
  # above assumes.
  md <- match_data(m)

  fit <- lm(re78 ~ treat, data = md, weights = weights)
  ct  <- coeftest(fit, vcov = vcovHC(fit, type = "HC3"))

  list(
    est        = unname(coef(fit)["treat"]),
    se         = unname(ct["treat", "Std. Error"]),
    n_treat        = n_distinct(md$unit_id[md$treat == 1]),
    n_control_used = n_distinct(md$unit_id[md$treat == 0]),
    n_matched_rows = nrow(md),
    n_discarded    = if (method == "nearest") sum(m$discarded, na.rm = TRUE) else NA_integer_
  )
}

specs <- list(
  list(key = "psm_demo_nn",           covs = demo_covs, method = "nearest",  discard = "none", label = "PSM: demo, 1-NN"),
  list(key = "psm_demo_nn_trim",      covs = demo_covs, method = "nearest",  discard = "both", label = "PSM: demo, 1-NN, trimmed"),
  list(key = "psm_demo_strat",        covs = demo_covs, method = "subclass", discard = "none", label = "PSM: demo, stratified"),
  list(key = "psm_earn_nn",           covs = c(demo_covs, earn_covs), method = "nearest",  discard = "none", label = "PSM: demo+earn, 1-NN"),
  list(key = "psm_earn_nn_trim",      covs = c(demo_covs, earn_covs), method = "nearest",  discard = "both", label = "PSM: demo+earn, 1-NN, trimmed"),
  list(key = "psm_earn_strat",        covs = c(demo_covs, earn_covs), method = "subclass", discard = "none", label = "PSM: demo+earn, stratified")
)

spec_results <- lapply(specs, function(s) {
  r <- fit_matched(s$covs, composite, method = s$method, discard = s$discard)
  data.frame(
    key       = s$key,
    label     = s$label,
    covariate_set = if (length(s$covs) == length(demo_covs)) "Demographics only" else "Demographics + re74/re75",
    estimator = if (s$method == "subclass") "Stratification" else if (s$discard == "both") "1-NN, trimmed" else "1-NN, full support",
    estimate  = r$est,
    se        = r$se,
    n_treat   = r$n_treat,
    n_control_used = r$n_control_used,
    n_discarded = r$n_discarded
  )
})
spec_df <- bind_rows(spec_results)

naive_row <- data.frame(
  key = "naive", label = "Naive (no adjustment)",
  covariate_set = "None", estimator = "Raw difference",
  estimate = naive_est, se = naive_se,
  n_treat = n_treat_comp, n_control_used = n_ctrl_comp, n_discarded = NA_integer_
)

all_specs <- bind_rows(naive_row, spec_df) |>
  mutate(
    ci_lo = estimate - 1.96 * se,
    ci_hi = estimate + 1.96 * se,
    gap   = estimate - bench_est,
    gap_in_se = gap / se
  )

# ---- 2c. Diagnostics cited in memo.md: trim discard counts and the ---------
#          stratification-granularity sensitivity check -----------------------

trim_move_demo <- with(
  list(u = spec_df$estimate[spec_df$key == "psm_demo_nn"],
       t = spec_df$estimate[spec_df$key == "psm_demo_nn_trim"]),
  t - u
)
trim_move_earn <- with(
  list(u = spec_df$estimate[spec_df$key == "psm_earn_nn"],
       t = spec_df$estimate[spec_df$key == "psm_earn_nn_trim"]),
  t - u
)
n_discard_demo <- spec_df$n_discarded[spec_df$key == "psm_demo_nn_trim"]
n_discard_earn <- spec_df$n_discarded[spec_df$key == "psm_earn_nn_trim"]

message(sprintf(
  "Trim effect on point estimate: demo-only $%.2f (%d discarded), demo+earn $%.2f (%d discarded)",
  trim_move_demo, n_discard_demo, trim_move_earn, n_discard_earn
))

# Does the demo+earn stratification "miss" depend on strata count? MatchIt's
# subclass default (5) is coarse relative to a 16k-unit CPS pool; re-run at
# 10 and 20 strata to check whether the miss is a granularity artifact.
earn_form <- as.formula(paste("treat ~", paste(c(demo_covs, earn_covs), collapse = " + ")))
strat_sensitivity <- bind_rows(lapply(c(5, 10, 20), function(k) {
  r <- fit_matched(c(demo_covs, earn_covs), composite, method = "subclass", subclass_n = k)
  data.frame(subclass_n = k, estimate = r$est, se = r$se)
}))
message("Stratification sensitivity (demo+earn covariate set):")
message(paste(capture.output(print(strat_sensitivity, row.names = FALSE)), collapse = "\n"))

# Share of CPS controls landing in the bottom (lowest-propensity) stratum
# under the 5-strata default, cited in memo.md.
m_strat5_diag <- matchit(
  earn_form, data = composite, method = "subclass", distance = "glm",
  link = "logit", estimand = "ATT", subclass = 5
)
control_subclass <- m_strat5_diag$subclass[composite$treat == 0]
bottom_stratum_n <- max(table(control_subclass, useNA = "no"))
n_ctrl_total     <- sum(!is.na(control_subclass))
message(sprintf(
  "5-strata bottom stratum: %d of %d CPS controls (%.1f%%)",
  bottom_stratum_n, n_ctrl_total, 100 * bottom_stratum_n / n_ctrl_total
))

# ---- 3. Specification table -------------------------------------------------

fmt_dollar <- function(x) {
  sign <- ifelse(x < 0, "-", "")
  sprintf("%s$%s", sign, format(round(abs(x)), big.mark = ",", trim = TRUE))
}

tbl_rows <- all_specs |>
  mutate(row = sprintf(
    "| %s | %s | %s | %d / %d | %s [%s, %s] | %s | %.2f |",
    label, covariate_set, estimator, n_treat, n_control_used,
    fmt_dollar(estimate), fmt_dollar(ci_lo), fmt_dollar(ci_hi),
    fmt_dollar(gap), gap_in_se
  )) |>
  pull(row)

spec_table_md <- c(
  "# Specification table: NSW-treated + CPS-control composite vs. experimental benchmark",
  "",
  sprintf(
    "**Experimental benchmark** (NSW treated - control, n = %d / %d): %s (SE %s, 95%% CI [%s, %s]).",
    n_treat_nsw, n_ctrl_nsw, fmt_dollar(bench_est), fmt_dollar(bench_se),
    fmt_dollar(bench_lo), fmt_dollar(bench_hi)
  ),
  "",
  sprintf(
    "**Observational composite**: %s NSW-treated units + %s CPS controls (n = %s).",
    format(n_treat_comp, big.mark = ","), format(n_ctrl_comp, big.mark = ","),
    format(n_treat_comp + n_ctrl_comp, big.mark = ",")
  ),
  "",
  "| Specification | Covariate set | Estimator | n (treated/controls used) | Estimate [95% CI] | Gap vs. benchmark | Gap (SE units) |",
  "|---|---|---|---|---|---|---|",
  tbl_rows,
  "",
  "Gap = estimate - experimental benchmark ($1,794 rounded; exact value computed in `script.R`).",
  "\"Gap (SE units)\" divides by each row's own SE, not the benchmark's --",
  "dividing by the benchmark's $671 instead will not reproduce these numbers.",
  "Standard errors for matching estimators are HC3-robust on a weighted",
  "linear model fit to `match_data()` output (one row per matched unit,",
  "weighted by reuse count), per the note in `script.R`: the ordinary",
  "bootstrap is invalid for nearest-neighbor matching variances (Abadie &",
  "Imbens 2008), the closed-form `Matching` package is not installed, and",
  "cluster-robust alternatives are either invalid here (too few clusters for",
  "stratification) or understate the SE (subclass clustering under",
  "replacement)."
)
writeLines(spec_table_md, "spec-table.md")

# ---- 4. Figure: spec curve ---------------------------------------------------

plot_df <- all_specs |>
  mutate(
    label = factor(label, levels = rev(c(
      "Naive (no adjustment)",
      "PSM: demo, 1-NN", "PSM: demo, 1-NN, trimmed", "PSM: demo, stratified",
      "PSM: demo+earn, 1-NN", "PSM: demo+earn, 1-NN, trimmed", "PSM: demo+earn, stratified"
    ))),
    group = ifelse(key == "naive", "Naive", covariate_set)
  )

p <- ggplot(plot_df, aes(x = estimate, y = label, color = group, shape = estimator)) +
  geom_vline(xintercept = bench_est, linetype = "dashed", color = "grey20", linewidth = 0.6) +
  annotate("rect", xmin = bench_lo, xmax = bench_hi, ymin = -Inf, ymax = Inf,
           fill = "grey20", alpha = 0.08) +
  geom_pointrange(aes(xmin = ci_lo, xmax = ci_hi), linewidth = 0.6, size = 0.55) +
  scale_color_manual(values = c(
    "Naive" = "grey40",
    "Demographics only" = okabe_ito[5],
    "Demographics + re74/re75" = okabe_ito[6]
  ), name = NULL) +
  scale_shape_manual(values = c(
    "Raw difference" = 15, "1-NN, full support" = 16,
    "1-NN, trimmed" = 17, "Stratification" = 18
  ), name = NULL) +
  scale_x_continuous(labels = scales::dollar_format(scale = 1e-3, suffix = "k")) +
  labs(
    x = "Estimated effect on 1978 earnings (95% CI)",
    y = NULL,
    caption = "Dashed line and shaded band: experimental benchmark (treated - control, within NSW) and its 95% CI."
  ) +
  guides(color = guide_legend(nrow = 1), shape = guide_legend(nrow = 2))

ggsave("figures/spec-curve.png", p, width = 8.5, height = 5.2, dpi = 320, bg = "white")

message("Done: spec-table.md and figures/spec-curve.png written.")
