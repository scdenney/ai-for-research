# LaLonde NSW--CPS specification curve
# Reproduces spec-table.md, memo.md, and figures/spec-curve.png.

# Okabe--Ito palette and a shared, accessible plotting theme
okabe_ito <- c(
  orange = "#E69F00", sky_blue = "#56B4E9", bluish_green = "#009E73",
  yellow = "#F0E442", blue = "#0072B2", vermillion = "#D55E00",
  reddish_purple = "#CC79A7", black = "#000000"
)
theme_lab <- ggplot2::theme_minimal(base_size = 11) +
  ggplot2::theme(
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major.x = ggplot2::element_blank(),
    axis.title.x = ggplot2::element_blank(),
    axis.text.x = ggplot2::element_text(angle = 35, hjust = 1),
    plot.margin = ggplot2::margin(8, 18, 8, 8)
  )

# Set before any operation that could use randomized tie handling.
set.seed(20260719)

suppressPackageStartupMessages({
  library(causaldata)
  library(MatchIt)
  library(ggplot2)
})

dir.create("figures", showWarnings = FALSE, recursive = TRUE)

# Format values without making the numerical objects themselves character strings.
money <- function(x, digits = 0) {
  formatC(x, format = "f", digits = digits, big.mark = ",")
}

format_p <- function(x) {
  ifelse(x < 0.001, "<0.001", formatC(x, format = "f", digits = 3))
}

# Difference in means and the usual independent-samples standard error.
diff_in_means <- function(y, z) {
  y1 <- y[z == 1]
  y0 <- y[z == 0]
  est <- mean(y1) - mean(y0)
  se <- sqrt(stats::var(y1) / length(y1) + stats::var(y0) / length(y0))
  c(estimate = est, se = se)
}

# Abadie--Imbens local estimator of Var(Y_w | e(X)). For each unit, estimate
# its conditional outcome variance from J nearest units in its own treatment
# arm. This supports analytic matching inference and deliberately does not use
# the ordinary nonparametric bootstrap, which is invalid for fixed-M NN
# matching (Abadie and Imbens 2008).
ai_local_variance <- function(score, outcome, treatment, J = 3L) {
  out <- numeric(length(outcome))
  for (w in c(0L, 1L)) {
    index <- which(treatment == w)
    if (length(index) <= J) stop("Too few observations for local variance estimation.")
    for (i in index) {
      candidates <- index[index != i]
      nearest <- candidates[order(abs(score[candidates] - score[i]), candidates)][seq_len(J)]
      # J/(J + 1) corrects the variance of Y_i minus the mean of J neighbours.
      out[i] <- J / (J + 1) * (outcome[i] - mean(outcome[nearest]))^2
    }
  }
  out
}

# Quantities that need an outcome-based variance approximation are returned
# separately from the point estimate.  In particular, the control component
# can be combined with the independent NSW experimental-control mean for a
# direct recovery comparison in which the shared NSW-treated mean cancels.

# ATT 1-NN matching on a propensity score that has already been estimated on
# the full observational composite. MatchIt only uses the supplied distance;
# it does not refit a propensity model after trimming.
nn_att <- function(d) {
  d <- as.data.frame(d)
  rownames(d) <- d$unit_id
  matched <- MatchIt::matchit(
    treat ~ 1, data = d, method = "nearest", distance = d$score,
    estimand = "ATT", replace = TRUE, m.order = "data"
  )
  match_matrix <- matched$match.matrix
  treated_index <- match(rownames(match_matrix), rownames(d))
  control_index <- match(match_matrix[, 1], rownames(d))
  if (anyNA(treated_index) || anyNA(control_index)) stop("Could not recover MatchIt pairs.")

  n_treated <- length(treated_index)
  reuse_count <- tabulate(control_index, nbins = nrow(d))
  control_weights <- reuse_count / n_treated
  conditional_variance <- ai_local_variance(d$score, d$re78, d$treat, J = 3L)
  treated_variance <- sum(conditional_variance[treated_index]) / n_treated^2
  control_variance <- sum((control_weights^2) * conditional_variance)

  list(
    estimate = mean(d$re78[treated_index] - d$re78[control_index]),
    se = sqrt(treated_variance + control_variance),
    n_treated = n_treated,
    n_controls = sum(d$treat == 0),
    control_weights = control_weights,
    control_variance = control_variance
  )
}

# ATT score stratification on the same fixed full-composite score. As every
# treated unit is retained here, treated-score quintile cutpoints are identical
# in the trimmed and untrimmed samples; only the available CPS controls change.
stratified_att <- function(d, n_strata = 5L) {
  treated_scores <- d$score[d$treat == 1]
  cutpoints <- stats::quantile(
    treated_scores, probs = seq(0, 1, length.out = n_strata + 1),
    names = FALSE, type = 8
  )
  if (anyDuplicated(cutpoints[-c(1, length(cutpoints))])) {
    stop("Tied score quantiles prevent the requested fixed stratification.")
  }
  d$stratum <- cut(
    d$score, breaks = c(-Inf, cutpoints[2:n_strata], Inf),
    include.lowest = TRUE, ordered_result = TRUE
  )
  groups <- split(seq_len(nrow(d)), d$stratum, drop = TRUE)
  n_treated <- sum(d$treat == 1)
  control_weights <- numeric(nrow(d))
  treated_variance <- 0
  control_variance <- 0
  for (index in groups) {
    treated_index <- index[d$treat[index] == 1]
    control_index <- index[d$treat[index] == 0]
    if (length(treated_index) == 0 || length(control_index) == 0) {
      stop("A propensity-score stratum lacks one arm.")
    }
    stratum_weight <- length(treated_index) / n_treated
    control_weights[control_index] <- stratum_weight / length(control_index)
    treated_variance <- treated_variance + stratum_weight^2 *
      stats::var(d$re78[treated_index]) / length(treated_index)
    control_variance <- control_variance + stratum_weight^2 *
      stats::var(d$re78[control_index]) / length(control_index)
  }
  control_mean <- sum(control_weights[d$treat == 0] * d$re78[d$treat == 0])
  list(
    estimate = mean(d$re78[d$treat == 1]) - control_mean,
    se = sqrt(treated_variance + control_variance),
    n_treated = n_treated,
    n_controls = sum(d$treat == 0),
    control_weights = control_weights,
    control_variance = control_variance
  )
}

# The following helpers preserve a score fitted once on the full composite.
fit_full_score <- function(d, covariates) {
  fml <- stats::reformulate(covariates, response = "treat")
  stats::fitted(stats::glm(fml, data = d, family = stats::binomial()))
}

common_support <- function(d) {
  lower <- max(min(d$score[d$treat == 1]), min(d$score[d$treat == 0]))
  upper <- min(max(d$score[d$treat == 1]), max(d$score[d$treat == 0]))
  keep <- d$score >= lower & d$score <= upper
  list(keep = keep, lower = lower, upper = upper,
       n_treated = sum(d$treat == 1 & keep), n_controls = sum(d$treat == 0 & keep))
}

# Standardize each post-adjustment treated/control mean difference by the
# unadjusted full-composite pooled SD. Holding that denominator fixed makes the
# trimmed/untrimmed diagnostic directly comparable within a covariate set.
pooled_sds <- function(d, covariates) {
  vapply(covariates, function(x) {
    sqrt((stats::var(d[[x]][d$treat == 1]) + stats::var(d[[x]][d$treat == 0])) / 2)
  }, numeric(1))
}

balance_diagnostics <- function(d, covariates, control_weights, reference_sds) {
  control_index <- d$treat == 0
  smd <- vapply(covariates, function(x) {
    treated_mean <- mean(d[[x]][d$treat == 1])
    control_mean <- stats::weighted.mean(d[[x]][control_index], control_weights[control_index])
    (treated_mean - control_mean) / reference_sds[[x]]
  }, numeric(1))
  used_weights <- control_weights[control_index]
  c(
    max_abs_smd = max(abs(smd)),
    n_smd_gt_010 = sum(abs(smd) > 0.10),
    n_controls_used = sum(used_weights > 0),
    control_ess = sum(used_weights)^2 / sum(used_weights^2)
  )
}

recovery_comparison <- function(fit, d, experimental_control_mean, experimental_control_variance) {
  control_index <- d$treat == 0
  cps_control_mean <- sum(fit$control_weights[control_index] * d$re78[control_index])
  gap <- experimental_control_mean - cps_control_mean
  gap_se <- sqrt(experimental_control_variance + fit$control_variance)
  c(
    cps_control_mean = cps_control_mean,
    recovery_gap = gap,
    recovery_gap_se = gap_se,
    recovery_gap_low = gap - 1.96 * gap_se,
    recovery_gap_high = gap + 1.96 * gap_se,
    recovery_p = 2 * stats::pnorm(-abs(gap / gap_se))
  )
}

# Data: randomized NSW comparison and observational NSW-treated/CPS-control composite.
nsw <- causaldata::nsw_mixtape
cps <- causaldata::cps_mixtape
experimental <- nsw
observational <- rbind(nsw[nsw$treat == 1, , drop = FALSE], cps)
observational$unit_id <- sprintf("unit_%05d", seq_len(nrow(observational)))

benchmark <- diff_in_means(experimental$re78, experimental$treat)
naive <- diff_in_means(observational$re78, observational$treat)
experimental_controls <- experimental[experimental$treat == 0, , drop = FALSE]
experimental_control_mean <- mean(experimental_controls$re78)
experimental_control_variance <- stats::var(experimental_controls$re78) / nrow(experimental_controls)

covariate_sets <- list(
  "Demographics" = c("age", "educ", "black", "hisp", "marr", "nodegree"),
  "Demographics + prior earnings" = c("age", "educ", "black", "hisp", "marr", "nodegree", "re74", "re75")
)

# 2 covariate sets x 2 estimators x 2 support choices = 8 specifications.
results <- list()
for (covariate_label in names(covariate_sets)) {
  covariates <- covariate_sets[[covariate_label]]
  # Fit this score once, on the entire NSW-treated/CPS-control composite.
  # Both rows below retain its values; trimming never triggers score refitting.
  scored_observational <- observational
  scored_observational$score <- fit_full_score(scored_observational, covariates)
  support <- common_support(scored_observational)
  reference_sds <- pooled_sds(scored_observational, covariates)
  analysis_samples <- list(
    "No" = scored_observational,
    "Yes" = scored_observational[support$keep, , drop = FALSE]
  )
  for (support_label in names(analysis_samples)) {
    d <- analysis_samples[[support_label]]
    for (estimator in c("1-NN matching", "Score stratification")) {
      fit <- if (estimator == "1-NN matching") nn_att(d) else stratified_att(d)
      balance <- balance_diagnostics(d, covariates, fit$control_weights, reference_sds)
      recovery <- recovery_comparison(
        fit, d, experimental_control_mean, experimental_control_variance
      )
      results[[length(results) + 1L]] <- data.frame(
        covariates = covariate_label,
        estimator = estimator,
        common_support = support_label,
        n_treated = fit$n_treated,
        n_controls = fit$n_controls,
        estimate = fit$estimate,
        se = fit$se,
        max_abs_smd = unname(balance["max_abs_smd"]),
        n_smd_gt_010 = unname(balance["n_smd_gt_010"]),
        n_controls_used = unname(balance["n_controls_used"]),
        control_ess = unname(balance["control_ess"]),
        cps_control_mean = unname(recovery["cps_control_mean"]),
        recovery_gap = unname(recovery["recovery_gap"]),
        recovery_gap_se = unname(recovery["recovery_gap_se"]),
        recovery_gap_low = unname(recovery["recovery_gap_low"]),
        recovery_gap_high = unname(recovery["recovery_gap_high"]),
        recovery_p = unname(recovery["recovery_p"]),
        support_lower = if (support_label == "Yes") support$lower else NA_real_,
        support_upper = if (support_label == "Yes") support$upper else NA_real_,
        stringsAsFactors = FALSE
      )
    }
  }
}
specifications <- do.call(rbind, results)
specifications$ci_low <- specifications$estimate - 1.96 * specifications$se
specifications$ci_high <- specifications$estimate + 1.96 * specifications$se
specifications$gap_from_benchmark <- specifications$estimate - benchmark["estimate"]

# Add the raw observational contrast as a displayed comparison, but retain
# the eight estimators above as the actual specification grid.
naive_row <- data.frame(
  covariates = "None", estimator = "Raw observational difference", common_support = "No",
  n_treated = sum(observational$treat == 1), n_controls = sum(observational$treat == 0),
  estimate = unname(naive["estimate"]), se = unname(naive["se"]),
  max_abs_smd = NA_real_, n_smd_gt_010 = NA_real_,
  n_controls_used = NA_real_, control_ess = NA_real_,
  cps_control_mean = mean(observational$re78[observational$treat == 0]),
  recovery_gap = experimental_control_mean - mean(observational$re78[observational$treat == 0]),
  recovery_gap_se = sqrt(experimental_control_variance +
    stats::var(observational$re78[observational$treat == 0]) / sum(observational$treat == 0)),
  support_lower = NA_real_, support_upper = NA_real_, stringsAsFactors = FALSE
)
naive_row$ci_low <- naive_row$estimate - 1.96 * naive_row$se
naive_row$ci_high <- naive_row$estimate + 1.96 * naive_row$se
naive_row$gap_from_benchmark <- naive_row$estimate - benchmark["estimate"]
naive_row$recovery_gap_low <- naive_row$recovery_gap - 1.96 * naive_row$recovery_gap_se
naive_row$recovery_gap_high <- naive_row$recovery_gap + 1.96 * naive_row$recovery_gap_se
naive_row$recovery_p <- 2 * stats::pnorm(-abs(naive_row$recovery_gap / naive_row$recovery_gap_se))
display_results <- rbind(naive_row, specifications)

# Markdown specification table.
table_lines <- c(
  "# NSW--CPS specification table",
  "",
  sprintf("Experimental benchmark (randomized NSW treated minus NSW control): **$%s** (SE $%s; 95%% CI [$%s, $%s]).", money(benchmark["estimate"]), money(benchmark["se"]), money(benchmark["estimate"] - 1.96 * benchmark["se"]), money(benchmark["estimate"] + 1.96 * benchmark["se"])),
  "",
  "| Covariate set | Estimator | Common support | Treated N | CPS-control candidates N | Estimate (USD) | SE | Estimate 95% CI | Gap from benchmark | Recovery-gap 95% CI | p (gap = 0) |",
  "|---|---|:---:|---:|---:|---:|---:|---:|---:|---:|---:|"
)
for (i in seq_len(nrow(display_results))) {
  x <- display_results[i, ]
  table_lines <- c(table_lines, sprintf(
    "| %s | %s | %s | %d | %d | $%s | $%s | [$%s, $%s] | $%s | [$%s, $%s] | %s |",
    x$covariates, x$estimator, x$common_support, x$n_treated, x$n_controls,
    money(x$estimate), money(x$se), money(x$ci_low), money(x$ci_high),
    money(x$gap_from_benchmark), money(x$recovery_gap_low), money(x$recovery_gap_high),
    format_p(x$recovery_p)
  ))
}
table_lines <- c(
  table_lines,
  "",
  "## Post-adjustment balance and CPS-control use",
  "",
  "| Covariate set | Estimator | Common support | Max \\|SMD\\| | Covariates \\|SMD\\| > 0.10 | CPS controls with positive weight | Effective CPS-control N |",
  "|---|---|:---:|---:|---:|---:|---:|"
)
for (i in seq_len(nrow(specifications))) {
  x <- specifications[i, ]
  table_lines <- c(table_lines, sprintf(
    "| %s | %s | %s | %.2f | %d | %d | %.1f |",
    x$covariates, x$estimator, x$common_support, x$max_abs_smd,
    x$n_smd_gt_010, x$n_controls_used, x$control_ess
  ))
}
table_lines <- c(
  table_lines, "",
  "For each covariate set, the propensity score is estimated once on the full NSW-treated/CPS-control composite and then held fixed for both the untrimmed and common-support-trimmed estimators. Common support is the intersection of its NSW-treated and CPS-control ranges. All 185 treated observations are retained in both models, so trimming removes only CPS candidates. The displayed candidate N is the pre-estimation CPS pool.",
  "",
  "Balance diagnostics compare the NSW treated mean with the estimator-weighted CPS mean. Each absolute SMD uses the unadjusted full-composite pooled SD for that covariate, so values are comparable across the trimmed and untrimmed rows; the count is among the covariates listed for that specification. The CPS-control count is the number with positive analysis weight. Its effective N is `(sum w)^2 / sum(w^2)`; for 1-NN matching it is based on control reuse weights and therefore reports both distinct matched controls and their reuse concentration.",
  "",
  "The recovery gap equals the observational estimate minus the experimental benchmark, which algebraically is the randomized NSW control mean minus the adjusted CPS control mean. Its interval and two-sided p-value use only those two control-side variance components: the shared NSW-treated outcome mean cancels. Thus they are direct recovery comparisons, unlike visual overlap of the estimator and benchmark intervals.",
  "",
  "For 1-NN rows, MatchIt forms ATT matches with replacement. Estimate intervals use a conditional Abadie--Imbens-style approximation with three same-arm nearest neighbours for local outcome variances and control reuse counts; no ordinary bootstrap is used. Stratification uses five score strata defined by treated-score quintiles and a fixed-strata sampling variance. Neither the estimator nor recovery-gap intervals propagate propensity-score estimation uncertainty."
)
writeLines(table_lines, "spec-table.md")

# One specification-curve/coefficient figure, with no in-plot title.
plot_data <- display_results
plot_data$label <- ifelse(
  plot_data$estimator == "Raw observational difference", "Naive observational",
  paste0(ifelse(plot_data$covariates == "Demographics", "Demog", "Demog + earnings"), " / ",
         ifelse(plot_data$estimator == "1-NN matching", "1-NN", "Stratified"), " / ",
         ifelse(plot_data$common_support == "Yes", "Trimmed", "Untrimmed"))
)
plot_data$method_family <- ifelse(plot_data$estimator == "Raw observational difference", "Naive",
                                  ifelse(plot_data$estimator == "1-NN matching", "1-NN matching", "Score stratification"))
plot_data$label <- factor(plot_data$label, levels = unique(plot_data$label))
plot_data$method_family <- factor(plot_data$method_family, levels = c("Naive", "1-NN matching", "Score stratification"))
benchmark_label <- data.frame(
  label = factor("Naive observational", levels = levels(plot_data$label)),
  estimate = unname(benchmark["estimate"])
)

p <- ggplot(plot_data, aes(x = label, y = estimate, colour = method_family, shape = method_family)) +
  geom_hline(yintercept = unname(benchmark["estimate"]), colour = okabe_ito["black"], linewidth = 0.7) +
  geom_text(data = benchmark_label, aes(x = label, y = estimate), inherit.aes = FALSE,
            label = "Experimental benchmark", hjust = 0, vjust = -0.65,
            size = 3.1, colour = okabe_ito["black"]) +
  geom_errorbar(aes(ymin = ci_low, ymax = ci_high), width = 0, linewidth = 0.55) +
  geom_point(size = 2.7) +
  scale_colour_manual(values = c("Naive" = unname(okabe_ito["vermillion"]), "1-NN matching" = unname(okabe_ito["blue"]), "Score stratification" = unname(okabe_ito["bluish_green"]))) +
  scale_shape_manual(values = c("Naive" = 15, "1-NN matching" = 16, "Score stratification" = 17)) +
  scale_y_continuous(labels = function(x) paste0("$", formatC(x, format = "f", digits = 0, big.mark = ",")), expand = expansion(mult = c(0.08, 0.13))) +
  labs(y = "Estimated ATT on 1978 earnings (USD)", colour = NULL, shape = NULL) +
  coord_cartesian(clip = "off") +
  theme_lab +
  theme(legend.position = "top", legend.justification = "left")
ggsave("figures/spec-curve.png", p, width = 11, height = 6.5, units = "in", dpi = 320, bg = "white")

# A data-driven, deliberately qualified interpretation.
closest <- specifications[which.min(abs(specifications$gap_from_benchmark)), ]
range_low <- min(specifications$estimate)
range_high <- max(specifications$estimate)
min_max_smd <- min(specifications$max_abs_smd)
max_max_smd <- max(specifications$max_abs_smd)
min_imbalanced_covariates <- min(specifications$n_smd_gt_010)
max_imbalanced_covariates <- max(specifications$n_smd_gt_010)

memo_paragraphs <- c(
  "**Bottom line: recovery is only under favorable specifications, not robustly.** The randomized NSW contrast provides the experimental benchmark for the NSW treated sample: $", money(benchmark["estimate"]), ". Replacing randomized controls with CPS controls produces a raw contrast of $", money(naive["estimate"]), ", a gap of $", money(naive_row$gap_from_benchmark), ". CPS members and NSW trainees begin with sharply different observed profiles and may differ in unmeasured earnings prospects; the raw CPS comparison is not a credible counterfactual.",
  "",
  "Conditioning changes the comparison to CPS units similar on *measured* age, schooling, race/ethnicity, marital status, degree status, and—under the richer model—prior earnings. It does not randomize CPS membership, repair measurement error, or remove selection on unobserved employability, motivation, local labor markets, or program referral. The identifying claim remains conditional exchangeability plus overlap; a logit score does not create either. The new balance table makes this limitation empirical as well as conceptual: across adjusted rows, maximum absolute SMD ranges from ", formatC(min_max_smd, format = "f", digits = 2), " to ", formatC(max_max_smd, format = "f", digits = 2), ", with ", min_imbalanced_covariates, " to ", max_imbalanced_covariates, " covariates over 0.10. Replacement matching also relies on a limited, sometimes heavily reused set of CPS controls, as the distinct-control and effective-N columns show.",
  "",
  "The eight fixed-score adjusted estimates span $", money(range_low), " to $", money(range_high), ". The closest is the ", tolower(closest$estimator), " specification with ", tolower(closest$covariates), " and common-support trimming = ", closest$common_support, ": $", money(closest$estimate), " (gap $", money(closest$gap_from_benchmark), "). Its direct recovery-gap interval is [$", money(closest$recovery_gap_low), ", $", money(closest$recovery_gap_high), "] (p = ", format_p(closest$recovery_p), "). This is the relevant comparison: the observational estimate minus the benchmark reduces to the randomized NSW control mean minus the adjusted CPS control mean, so the shared NSW-treated outcome mean cancels. The figure's intervals are visual summaries only; their overlap with the benchmark is not recovery-test evidence. All treated units lie in the fixed support range, so trimming changes only the CPS candidate pool—not the propensity model—and still cannot make CPS an experiment.",
  "",
  "For fixed-one-nearest-neighbour matching with replacement, the displayed variance is a conditional Abadie--Imbens-style approximation using local same-arm outcome variances and control-reuse counts; it omits propensity-score estimation uncertainty. The stratified rows use fixed-strata sampling variances, and the direct recovery gaps likewise omit score-model uncertainty. Thus a small or statistically indistinguishable gap is useful diagnostic evidence, not proof of ignorability or a license to select one specification after looking at results.",
  "",
  "A paper may claim that some specified propensity-score adjustments move the CPS comparison markedly toward the randomized NSW benchmark, and may report the particular specifications that do so. It may not claim, without qualification, that propensity-score matching recovers the experimental effect, that balancing observables establishes ignorability, or that one favorable estimate validates the procedure for another comparison sample. The appropriate conclusion is specification-dependent corroboration: the Dehejia--Wahba-style success is possible, while the Smith--Todd warning about sensitivity to covariates and analysis choices is the better description of the full curve."
)
block_id <- cumsum(c(1L, as.integer(head(memo_paragraphs, -1L) == "")))
keep_text <- memo_paragraphs != ""
memo_blocks <- vapply(
  split(memo_paragraphs[keep_text], block_id[keep_text]),
  paste0, collapse = "", FUN.VALUE = character(1)
)
memo_output <- as.vector(rbind(memo_blocks, ""))
writeLines(c("# Adjudication: matching the NSW treated to CPS controls", "", memo_output), "memo.md")

message(sprintf("Benchmark: %.3f; naive observational contrast: %.3f", benchmark["estimate"], naive["estimate"]))
