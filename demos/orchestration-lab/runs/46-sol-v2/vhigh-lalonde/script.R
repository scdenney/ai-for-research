suppressPackageStartupMessages({
  library(causaldata)
  library(ggplot2)
  library(MatchIt)
  library(sandwich)
})

set.seed(20260719)

# Okabe-Ito palette and shared publication theme.
okabe_ito <- c(
  orange = "#E69F00", sky_blue = "#56B4E9", bluish_green = "#009E73",
  yellow = "#F0E442", blue = "#0072B2", vermillion = "#D55E00",
  reddish_purple = "#CC79A7", black = "#000000"
)

theme_set(
  theme_minimal(base_size = 11) +
    theme(
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank(),
      axis.title = element_text(color = okabe_ito[["black"]]),
      axis.text = element_text(color = okabe_ito[["black"]]),
      legend.position = "top",
      plot.caption = element_text(hjust = 0, color = "grey35", size = 8.5),
      plot.margin = margin(8, 12, 8, 8)
    )
)

required_columns <- c(
  "data_id", "treat", "age", "educ", "black", "hisp", "marr",
  "nodegree", "re74", "re75", "re78"
)

nsw <- causaldata::nsw_mixtape
cps <- causaldata::cps_mixtape

stopifnot(
  identical(names(nsw), required_columns),
  identical(names(cps), required_columns),
  nrow(nsw) == 445L,
  sum(nsw$treat == 1) == 185L,
  sum(nsw$treat == 0) == 260L,
  nrow(cps) == 15992L,
  all(cps$treat == 0),
  !anyNA(nsw),
  !anyNA(cps)
)

nsw_treated <- nsw[nsw$treat == 1, , drop = FALSE]
observational <- rbind(nsw_treated, cps)
observational$source_id <- sprintf("unit_%05d", seq_len(nrow(observational)))

welch_contrast <- function(y_treated, y_control) {
  n_t <- length(y_treated)
  n_c <- length(y_control)
  var_t <- var(y_treated)
  var_c <- var(y_control)
  estimate <- mean(y_treated) - mean(y_control)
  se <- sqrt(var_t / n_t + var_c / n_c)
  df <- se^4 / (
    (var_t / n_t)^2 / (n_t - 1) +
      (var_c / n_c)^2 / (n_c - 1)
  )
  critical <- qt(0.975, df = df)
  c(
    estimate = estimate,
    std_error = se,
    conf_low = estimate - critical * se,
    conf_high = estimate + critical * se,
    df = df
  )
}

benchmark <- welch_contrast(
  nsw$re78[nsw$treat == 1],
  nsw$re78[nsw$treat == 0]
)

naive <- welch_contrast(nsw_treated$re78, cps$re78)

covariate_specs <- list(
  "Demographics" = treat ~ age + educ + black + hisp + marr + nodegree,
  "Demographics + earnings" =
    treat ~ age + educ + black + hisp + marr + nodegree + re74 + re75
)

prepare_score_sample <- function(formula, trim) {
  score_model <- glm(formula, data = observational, family = binomial())
  propensity <- predict(score_model, type = "response")
  treated <- observational$treat == 1

  lower <- max(min(propensity[treated]), min(propensity[!treated]))
  upper <- min(max(propensity[treated]), max(propensity[!treated]))
  keep <- if (trim) propensity >= lower & propensity <= upper else rep(TRUE, nrow(observational))

  analysis_data <- observational[keep, , drop = FALSE]
  analysis_data$propensity <- propensity[keep]

  # For these data the initial-score intersection drops controls only. Retaining
  # the initial score avoids changing the support rule after trimming.
  stopifnot(sum(analysis_data$treat == 1) == 185L)

  list(
    data = analysis_data,
    lower = lower,
    upper = upper,
    eligible_controls = sum(analysis_data$treat == 0)
  )
}

estimate_adjusted <- function(covariate_label, formula, trim, estimator) {
  prepared <- prepare_score_sample(formula, trim)
  analysis_data <- prepared$data

  match_args <- list(
    formula = formula,
    data = analysis_data,
    distance = analysis_data$propensity,
    estimand = "ATT"
  )

  if (estimator == "1-NN") {
    match_args$method <- "nearest"
    match_args$replace <- TRUE
    match_args$ratio <- 1
    match_args$m.order <- "largest"
  } else {
    match_args$method <- "subclass"
    match_args$subclass <- 5
  }

  matched <- do.call(MatchIt::matchit, match_args)
  matched_data <- MatchIt::match_data(matched, data = analysis_data)

  if (estimator != "1-NN") {
    subclass_counts <- table(matched_data$subclass, matched_data$treat)
    stopifnot(nrow(subclass_counts) == 5L, ncol(subclass_counts) == 2L, all(subclass_counts > 0L))
  }

  outcome_fit <- lm(re78 ~ treat, data = matched_data, weights = weights)
  estimate <- unname(coef(outcome_fit)[["treat"]])
  robust_vcov <- sandwich::vcovHC(outcome_fit, type = "HC3")
  se <- sqrt(unname(robust_vcov["treat", "treat"]))
  critical <- qt(0.975, df = df.residual(outcome_fit))

  balance <- summary(matched, standardize = TRUE)
  balance_table <- if (estimator == "1-NN") balance$sum.matched else balance$sum.across
  included_covariates <- all.vars(formula)[-1]
  max_abs_smd <- max(abs(balance_table[included_covariates, "Std. Mean Diff."]))

  data.frame(
    covariates = covariate_label,
    support = if (trim) "Common-support trim" else "No trim",
    estimator = if (estimator == "1-NN") "1-NN with replacement" else "5 score strata",
    treated_used = sum(matched_data$treat == 1),
    controls_eligible = prepared$eligible_controls,
    controls_used = sum(matched_data$treat == 0),
    max_abs_smd = max_abs_smd,
    estimate = estimate,
    std_error = se,
    conf_low = estimate - critical * se,
    conf_high = estimate + critical * se,
    support_lower = prepared$lower,
    support_upper = prepared$upper,
    stringsAsFactors = FALSE
  )
}

specifications <- expand.grid(
  covariates = names(covariate_specs),
  trim = c(FALSE, TRUE),
  estimator = c("1-NN", "Stratification"),
  stringsAsFactors = FALSE
)

adjusted_rows <- lapply(seq_len(nrow(specifications)), function(i) {
  spec <- specifications[i, ]
  estimate_adjusted(
    covariate_label = spec$covariates,
    formula = covariate_specs[[spec$covariates]],
    trim = spec$trim,
    estimator = spec$estimator
  )
})

adjusted <- do.call(rbind, adjusted_rows)
adjusted$covariate_order <- match(
  adjusted$covariates,
  c("Demographics", "Demographics + earnings")
)
adjusted$estimator_order <- match(
  adjusted$estimator,
  c("1-NN with replacement", "5 score strata")
)
adjusted$support_order <- match(adjusted$support, c("No trim", "Common-support trim"))
adjusted <- adjusted[
  order(adjusted$covariate_order, adjusted$estimator_order, adjusted$support_order),
]
adjusted[c("covariate_order", "estimator_order", "support_order")] <- NULL
row.names(adjusted) <- NULL
adjusted$gap_from_benchmark <- adjusted$estimate - benchmark[["estimate"]]

stopifnot(
  nrow(adjusted) == 8L,
  all(is.finite(unlist(adjusted[c("estimate", "std_error", "conf_low", "conf_high")]))),
  all(adjusted$treated_used == 185L),
  all(adjusted$controls_used > 0L)
)

fmt_money <- function(x) {
  sign <- ifelse(x < 0, "-", "")
  paste0(sign, "$", formatC(abs(x), format = "f", digits = 0, big.mark = ","))
}

fmt_interval <- function(low, high) {
  paste0("[", fmt_money(low), ", ", fmt_money(high), "]")
}

benchmark_row <- data.frame(
  specification = "Experimental benchmark",
  covariates = "Random assignment",
  support = "NSW experiment",
  treated_used = 185L,
  controls_eligible = 260L,
  controls_used = 260L,
  max_abs_smd = NA_real_,
  estimate = benchmark[["estimate"]],
  conf_low = benchmark[["conf_low"]],
  conf_high = benchmark[["conf_high"]],
  gap_from_benchmark = 0,
  stringsAsFactors = FALSE
)

naive_row <- data.frame(
  specification = "Naive observational difference",
  covariates = "None",
  support = "No trim",
  treated_used = 185L,
  controls_eligible = 15992L,
  controls_used = 15992L,
  max_abs_smd = NA_real_,
  estimate = naive[["estimate"]],
  conf_low = naive[["conf_low"]],
  conf_high = naive[["conf_high"]],
  gap_from_benchmark = naive[["estimate"]] - benchmark[["estimate"]],
  stringsAsFactors = FALSE
)

adjusted_table <- transform(
  adjusted,
  specification = paste(covariates, estimator, support, sep = " / ")
)[, names(benchmark_row)]

table_rows <- rbind(benchmark_row, naive_row, adjusted_table)

markdown_header <- c(
  "# ATT specification curve for 1978 earnings",
  "",
  paste0(
    "The randomized NSW benchmark is **", fmt_money(benchmark[["estimate"]]),
    "** (Welch 95% CI ", fmt_interval(benchmark[["conf_low"]], benchmark[["conf_high"]]), ")."
  ),
  "",
  paste(
    "| Specification | Covariates | Support | Treated used | Controls eligible |",
    "Controls used | Max abs. SMD | Estimate | 95% CI | Benchmark | Gap |"
  ),
  "|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|"
)

markdown_rows <- vapply(seq_len(nrow(table_rows)), function(i) {
  row <- table_rows[i, ]
  smd <- if (is.na(row$max_abs_smd)) "—" else sprintf("%.3f", row$max_abs_smd)
  paste0(
    "| ", row$specification,
    " | ", row$covariates,
    " | ", row$support,
    " | ", format(row$treated_used, big.mark = ",", scientific = FALSE),
    " | ", format(row$controls_eligible, big.mark = ",", scientific = FALSE),
    " | ", format(row$controls_used, big.mark = ",", scientific = FALSE),
    " | ", smd,
    " | ", fmt_money(row$estimate),
    " | ", fmt_interval(row$conf_low, row$conf_high),
    " | ", fmt_money(benchmark[["estimate"]]),
    " | ", fmt_money(row$gap_from_benchmark), " |"
  )
}, character(1))

markdown_notes <- c(
  "",
  "Notes:",
  "",
  "- The outcome is 1978 earnings in US dollars; treatment is NSW program participation. Adjusted rows target the ATT for the 185 NSW treated units.",
  "- The observational composite contains all 185 NSW treated units and the 15,992 CPS controls.",
  paste0(
    "- Common support is the intersection of treated and control ranges from the initial logit score. ",
    "It retains all 185 treated units and ",
    format(min(adjusted$controls_eligible[adjusted$covariates == "Demographics" & adjusted$support == "Common-support trim"]), big.mark = ","),
    " demographic-score controls or ",
    format(min(adjusted$controls_eligible[adjusted$covariates == "Demographics + earnings" & adjusted$support == "Common-support trim"]), big.mark = ","),
    " earnings-score controls. The initial score is retained after trimming."
  ),
  "- 1-NN uses MatchIt with `estimand = \"ATT\"`, `replace = TRUE`, and one control per treated unit. `Controls used` is the number of distinct matched controls.",
  "- Score stratification uses five subclasses and ATT weights. `Max abs. SMD` is the largest post-design standardized mean difference among the covariates included in that score model.",
  "- Benchmark and naive intervals use Welch standard errors. Adjusted intervals use HC3 sandwich standard errors from the ATT-weighted outcome contrast and are conditional on the estimated design. The ordinary nonparametric bootstrap is not used for 1-NN matching."
)

writeLines(c(markdown_header, markdown_rows, markdown_notes), "spec-table.md")

plot_order <- c(
  "Naive CPS",
  "Demo\n1-NN\nNo trim",
  "Demo\n1-NN\nTrim",
  "Demo\n5 strata\nNo trim",
  "Demo\n5 strata\nTrim",
  "Demo + earnings\n1-NN\nNo trim",
  "Demo + earnings\n1-NN\nTrim",
  "Demo + earnings\n5 strata\nNo trim",
  "Demo + earnings\n5 strata\nTrim"
)

adjusted$plot_label <- with(
  adjusted,
  paste0(
    ifelse(covariates == "Demographics", "Demo", "Demo + earnings"), "\n",
    ifelse(estimator == "1-NN with replacement", "1-NN", "5 strata"), "\n",
    ifelse(support == "No trim", "No trim", "Trim")
  )
)

plot_data <- rbind(
  data.frame(
    plot_label = "Naive CPS",
    color_group = "Naive",
    estimate = naive[["estimate"]],
    conf_low = naive[["conf_low"]],
    conf_high = naive[["conf_high"]]
  ),
  data.frame(
    plot_label = adjusted$plot_label,
    color_group = adjusted$covariates,
    estimate = adjusted$estimate,
    conf_low = adjusted$conf_low,
    conf_high = adjusted$conf_high
  )
)

plot_data$plot_label <- factor(plot_data$plot_label, levels = plot_order)

spec_plot <- ggplot(plot_data, aes(x = plot_label, y = estimate, color = color_group)) +
  geom_hline(
    yintercept = benchmark[["estimate"]],
    color = okabe_ito[["bluish_green"]],
    linewidth = 0.7,
    linetype = "22"
  ) +
  geom_errorbar(aes(ymin = conf_low, ymax = conf_high), width = 0.16, linewidth = 0.65) +
  geom_point(aes(shape = color_group), size = 2.8) +
  scale_color_manual(
    values = c(
      "Naive" = "grey35",
      "Demographics" = okabe_ito[["orange"]],
      "Demographics + earnings" = okabe_ito[["blue"]]
    ),
    breaks = c("Naive", "Demographics", "Demographics + earnings")
  ) +
  scale_shape_manual(
    values = c(
      "Naive" = 16,
      "Demographics" = 17,
      "Demographics + earnings" = 15
    ),
    breaks = c("Naive", "Demographics", "Demographics + earnings")
  ) +
  scale_y_continuous(labels = scales::label_dollar(big.mark = ",", accuracy = 1)) +
  labs(
    x = NULL,
    y = "Estimated effect on 1978 earnings (US$)",
    color = "Covariate set",
    shape = "Covariate set",
    caption = paste0(
      "NSW treated units (n = 185) compared with CPS controls; adjusted rows target the ATT. ",
      "Bars are 95% Welch intervals for the naive row and HC3 post-design intervals for adjusted rows.\n",
      "Dashed green line: randomized NSW benchmark (", fmt_money(benchmark[["estimate"]]), ")."
    )
  ) +
  theme(
    axis.text.x = element_text(size = 8.3, lineheight = 0.95),
    legend.box.spacing = unit(1, "pt")
  )

dir.create("figures", showWarnings = FALSE, recursive = TRUE)
ggsave(
  filename = "figures/spec-curve.png",
  plot = spec_plot,
  width = 10.5,
  height = 5.8,
  units = "in",
  dpi = 320,
  bg = "white"
)

cat(sprintf("Experimental benchmark: %.2f\n", benchmark[["estimate"]]))
cat(sprintf("Naive observational difference: %.2f\n", naive[["estimate"]]))
print(adjusted[, c(
  "covariates", "support", "estimator", "treated_used", "controls_eligible",
  "controls_used", "max_abs_smd", "estimate", "conf_low", "conf_high",
  "gap_from_benchmark"
)], row.names = FALSE)
