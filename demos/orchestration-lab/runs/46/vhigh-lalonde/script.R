# LaLonde NSW--CPS specification curve
# Palette and theme (Okabe--Ito) --------------------------------------------
okabe_ito <- c(
  orange = "#E69F00", sky_blue = "#56B4E9", bluish_green = "#009E73",
  yellow = "#F0E442", blue = "#0072B2", vermillion = "#D55E00",
  reddish_purple = "#CC79A7", black = "#000000"
)

library(causaldata)
library(MatchIt)
library(ggplot2)
library(sandwich)

theme_set(theme_minimal(base_size = 11) + theme(
  panel.grid.minor = element_blank(),
  plot.title = element_blank(),
  legend.position = "none"
))
set.seed(20260712)

dir.create("figures", showWarnings = FALSE, recursive = TRUE)

nsw <- causaldata::nsw_mixtape
cps <- causaldata::cps_mixtape

# The causal estimand throughout is the ATT: NSW participants' mean outcome
# relative to the earnings those participants would have had without NSW.
benchmark <- with(nsw, mean(re78[treat == 1]) - mean(re78[treat == 0]))
benchmark_se <- with(nsw, sqrt(var(re78[treat == 1]) / sum(treat == 1) +
                              var(re78[treat == 0]) / sum(treat == 0)))

obs <- rbind(nsw[nsw$treat == 1, ], cps)
obs$source <- ifelse(obs$treat == 1, "NSW treated", "CPS control")
obs$unit_id <- seq_len(nrow(obs))

mean_diff <- function(y, z) {
  est <- mean(y[z == 1]) - mean(y[z == 0])
  se <- sqrt(var(y[z == 1]) / sum(z == 1) + var(y[z == 0]) / sum(z == 0))
  c(estimate = est, se = se)
}

naive <- mean_diff(obs$re78, obs$treat)

trim_to_overlap <- function(dat, covariates, trim) {
  ps_fit <- glm(reformulate(covariates, response = "treat"), family = binomial(), data = dat)
  dat$ps <- fitted(ps_fit)
  if (trim) {
    treated_ps <- dat$ps[dat$treat == 1]
    control_ps <- dat$ps[dat$treat == 0]
    lower <- max(min(treated_ps), min(control_ps))
    upper <- min(max(treated_ps), max(control_ps))
    dat <- dat[dat$ps >= lower & dat$ps <= upper, , drop = FALSE]
  }
  dat
}

nn_att <- function(dat, covariates) {
  m <- matchit(
    reformulate(covariates, response = "treat"), data = dat,
    method = "nearest", distance = "glm", estimand = "ATT",
    replace = TRUE, ratio = 1
  )
  md <- match_data(m)
  fit <- lm(re78 ~ treat, data = md, weights = weights)
  # HC3 accommodates the non-uniform control weights induced by replacement.
  # This is sandwich inference conditional on matching, not a nonparametric
  # bootstrap (which is invalid for fixed-M nearest-neighbor matching variances).
  vc <- sandwich::vcovHC(fit, type = "HC3")
  c(estimate = unname(coef(fit)["treat"]), se = sqrt(unname(vc["treat", "treat"])),
    n_treated = sum(md$treat == 1), n_control_rows = sum(md$treat == 0),
    n_unique_controls = sum(md$treat == 0))
}

strat_att <- function(dat, covariates, k = 5) {
  s <- matchit(
    reformulate(covariates, response = "treat"), data = dat,
    method = "subclass", distance = "glm", estimand = "ATT", subclass = k
  )
  md <- match_data(s)
  fit <- lm(re78 ~ treat, data = md, weights = weights)
  vc <- sandwich::vcovHC(fit, type = "HC3")
  c(estimate = unname(coef(fit)["treat"]), se = sqrt(unname(vc["treat", "treat"])),
    n_treated = sum(md$treat == 1), n_control_rows = sum(md$treat == 0),
    n_unique_controls = sum(md$treat == 0))
}

covariate_sets <- list(
  "Demographics" = c("age", "educ", "black", "hisp", "marr", "nodegree"),
  "Demographics + prior earnings" = c("age", "educ", "black", "hisp", "marr", "nodegree", "re74", "re75")
)

specifications <- list()
for (cov_name in names(covariate_sets)) {
  covs <- covariate_sets[[cov_name]]
  for (trim in c(FALSE, TRUE)) {
    dat <- trim_to_overlap(obs, covs, trim)
    for (estimator in c("1-NN score matching", "Five score strata")) {
      ans <- if (estimator == "1-NN score matching") nn_att(dat, covs) else strat_att(dat, covs)
      specifications[[length(specifications) + 1]] <- data.frame(
        specification = paste(cov_name, if (trim) "trimmed to overlap" else "untrimmed", estimator, sep = " | "),
        covariates = cov_name,
        overlap = if (trim) "Trimmed to common support" else "No trimming",
        estimator = estimator,
        estimate = ans["estimate"], se = ans["se"],
        n_treated = ans["n_treated"], n_control = ans["n_control_rows"],
        stringsAsFactors = FALSE
      )
    }
  }
}
specifications <- do.call(rbind, specifications)
specifications$ci_low <- specifications$estimate - qnorm(.975) * specifications$se
specifications$ci_high <- specifications$estimate + qnorm(.975) * specifications$se
specifications$gap_from_benchmark <- specifications$estimate - benchmark

all_results <- rbind(
  data.frame(specification = "Experimental NSW benchmark", covariates = "Randomized NSW controls",
             overlap = "Not applicable", estimator = "Experimental difference in means",
             estimate = benchmark, se = benchmark_se, n_treated = sum(nsw$treat == 1),
             n_control = sum(nsw$treat == 0), ci_low = NA_real_, ci_high = NA_real_,
             gap_from_benchmark = NA_real_, stringsAsFactors = FALSE),
  data.frame(specification = "Naive NSW treated − CPS controls", covariates = "None",
             overlap = "No trimming", estimator = "Raw difference in means",
             estimate = naive["estimate"], se = naive["se"], n_treated = sum(obs$treat == 1),
             n_control = sum(obs$treat == 0), ci_low = NA_real_, ci_high = NA_real_,
             gap_from_benchmark = NA_real_, stringsAsFactors = FALSE),
  specifications
)
all_results$ci_low <- ifelse(is.na(all_results$ci_low), all_results$estimate - qnorm(.975) * all_results$se, all_results$ci_low)
all_results$ci_high <- ifelse(is.na(all_results$ci_high), all_results$estimate + qnorm(.975) * all_results$se, all_results$ci_high)
all_results$gap_from_benchmark <- all_results$estimate - benchmark

# The experimental and naive rows are reported in the table, but the figure is
# deliberately a curve of observational specifications only.
plot_data <- specifications
plot_data$specification <- factor(plot_data$specification, levels = rev(plot_data$specification))
p <- ggplot(plot_data, aes(x = estimate, y = specification, colour = estimator)) +
  geom_vline(xintercept = benchmark, colour = okabe_ito["black"], linewidth = 0.6) +
  geom_errorbar(aes(xmin = ci_low, xmax = ci_high), orientation = "y", width = 0.18, linewidth = 0.55) +
  geom_point(size = 2.1) +
  scale_colour_manual(values = c("1-NN score matching" = unname(okabe_ito["blue"]),
                                 "Five score strata" = unname(okabe_ito["vermillion"]))) +
  labs(x = "Estimated ATT on 1978 earnings (USD)", y = NULL,
       caption = "Black line: experimental NSW treated − control benchmark. Intervals are 95% intervals.") +
  theme(axis.text.y = element_text(size = 7), plot.caption = element_text(hjust = 0))
ggsave("figures/spec-curve.png", p, width = 10, height = 6.2, dpi = 320)

money <- function(x) formatC(x, format = "f", digits = 0, big.mark = ",")
table_lines <- c(
  "# Specification table", "",
  sprintf("Experimental benchmark (NSW treated − NSW control): **$%s**.", money(benchmark)), "",
  "| Analysis / specification | Covariates | Overlap rule | Estimator | ATT estimate | 95% interval | Gap from benchmark | Treated n | Control n |",
  "|---|---|---|---|---:|---:|---:|---:|---:|"
)
for (i in seq_len(nrow(all_results))) {
  x <- all_results[i, ]
  table_lines <- c(table_lines, sprintf(
    "| %s | %s | %s | %s | $%s | [$%s, $%s] | $%s | %d | %d |",
    x$specification, x$covariates, x$overlap, x$estimator, money(x$estimate),
    money(x$ci_low), money(x$ci_high), money(x$gap_from_benchmark), x$n_treated, x$n_control
  ))
}
table_lines <- c(table_lines, "", "Intervals: Welch intervals for the two raw differences and experimental benchmark; HC3 sandwich intervals for matching and five-score subclassification. The 1-NN intervals are not ordinary bootstrap intervals; HC3 is a model-assisted approximation conditional on the estimated design.")
writeLines(table_lines, "spec-table.md")

memo_lines <- c(
  "# Adjudication", "",
  sprintf("The experimental NSW comparison estimates an earnings effect of $%s (treated minus randomized control). That is the appropriate benchmark here: random assignment makes the NSW control mean a credible estimate of the treated group’s untreated mean. Replacing those 260 controls with CPS respondents changes the design, not merely the sample size. The naive NSW-treated–CPS-control contrast is reported in the table and is far below the experimental result, which is direct evidence that the two groups differ before any outcome modeling.", money(benchmark)), "",
  "The specification curve gives conditional, rather than blanket, support to the recovery claim. Its estimates move as the analyst changes both the information used to construct the propensity score and the implementation of the score adjustment. Adding 1974 and 1975 earnings changes the adjustment materially relative to demographics alone; trimming changes the population being compared; and matching and five-stratum subclassification need not give the same answer even with the same fitted score. Thus an estimate close to the experiment in an individual row is a useful diagnostic result, but it is not evidence that the observational design has recreated random assignment.", "",
  "Conditioning on these measured covariates aims to make the CPS controls resemble NSW participants in observed age, education, race/ethnicity, marital status, degree status, and, when included, prior earnings. This can reduce selection bias caused by those observed variables and restrict inference to regions of score overlap. It does not balance unmeasured determinants of employment, earnings, program selection, or differences in how the two samples were assembled. Nor does trimming solve non-overlap; it discards people and changes the ATT target to the retained treated participants. Score stratification is still coarser than pair matching, while nearest-neighbor matching necessarily makes its own local-comparison and reuse choices.", "",
  "The appropriate conclusion is therefore that recovery occurs only under favorable specifications, not robustly across the defensible alternatives shown. A paper may say that, for this NSW–CPS comparison, particular propensity-score specifications—especially those that exploit credible pre-treatment earnings information and adequate support—can produce estimates near the experimental benchmark. It may present this as a sensitivity or design diagnostic. It may not say unqualifiedly that matching “works,” that it validates propensity scores generally, or that a close point estimate proves ignorability. Likewise, it should not claim matching fails categorically: several conditional analyses can be informative. The table’s intervals describe sampling uncertainty for each estimator; overlap of one interval with the benchmark is not a test that the full observational identification assumptions hold, and the specification spread is itself substantive uncertainty that the row-wise intervals do not absorb.", "",
  "In short, the experiment adjudicates the causal effect; the CPS exercise shows how much observational recovery depends on consequential modeling and sample-definition choices. Claims should foreground that dependence and report the full curve rather than selecting its most successful row."
)
writeLines(memo_lines, "memo.md")

print(all_results[, c("specification", "estimate", "se", "ci_low", "ci_high", "gap_from_benchmark")], row.names = FALSE)
