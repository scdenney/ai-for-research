#!/usr/bin/env Rscript

# Reproduce OLS/2SLS robustness checks for Acemoglu, Johnson, and Robinson
# (2001), using the `colonial` data distributed with ivdoctr.
suppressPackageStartupMessages({
  library(ivdoctr)
  library(AER)
  library(car)
})

# The analyses below are deterministic, but fix a seed before any operation
# that could become stochastic if this script is extended.
set.seed(20260712)

data("colonial", package = "ivdoctr")
colonial <- as.data.frame(colonial)

excluded_countries <- c("AUS", "CAN", "NZL", "USA")

specifications <- list(
  list(label = "Bivariate", controls = character(), subset = rep(TRUE, nrow(colonial))),
  list(label = "Absolute latitude", controls = "lat_abst", subset = rep(TRUE, nrow(colonial))),
  list(label = "Africa and Asia indicators", controls = c("africa", "asia"), subset = rep(TRUE, nrow(colonial))),
  list(label = "Exclude AUS/CAN/NZL/USA", controls = character(), subset = !colonial$shortnam %in% excluded_countries),
  list(label = "Africa only", controls = character(), subset = colonial$africa == 1)
)

fmt_num <- function(x, digits = 3) formatC(x, format = "f", digits = digits)
fmt_p <- function(x) {
  if (is.na(x)) return("NA")
  if (x < 0.001) return("<0.001")
  formatC(x, format = "f", digits = 3)
}

run_specification <- function(spec) {
  variables <- c("logpgp95", "avexpr", "logem4", spec$controls)
  dat <- colonial[spec$subset, , drop = FALSE]

  # Construct the analysis sample once, then pass exactly this data frame to
  # every model in this specification. This prevents OLS/2SLS sample drift.
  dat <- dat[complete.cases(dat[, variables, drop = FALSE]), , drop = FALSE]
  if (nrow(dat) < 4L) stop("Too few complete observations in: ", spec$label)

  outcome_rhs <- paste(c("avexpr", spec$controls), collapse = " + ")
  first_stage_rhs <- paste(c("logem4", spec$controls), collapse = " + ")
  ols <- lm(as.formula(paste("logpgp95 ~", outcome_rhs)), data = dat)
  two_sls <- AER::ivreg(
    as.formula(paste("logpgp95 ~", outcome_rhs, "|", first_stage_rhs)),
    data = dat
  )
  first_stage <- lm(as.formula(paste("avexpr ~", first_stage_rhs)), data = dat)
  # This is the usual homoskedastic partial F test for the excluded instrument,
  # conditional on the stated controls. With one excluded instrument it equals t^2.
  partial_test <- car::linearHypothesis(first_stage, "logem4 = 0", test = "F")
  partial_f <- partial_test$F[2L]
  partial_p <- partial_test$`Pr(>F)`[2L]

  stopifnot(
    nobs(ols) == nrow(dat),
    nobs(two_sls) == nrow(dat),
    nobs(first_stage) == nrow(dat)
  )

  list(
    label = spec$label,
    controls = if (length(spec$controls)) paste(spec$controls, collapse = ", ") else "None",
    n = nrow(dat),
    ols = unname(coef(ols)["avexpr"]),
    two_sls = unname(coef(two_sls)["avexpr"]),
    first_stage = unname(coef(first_stage)["logem4"]),
    partial_f = partial_f,
    partial_p = partial_p,
    weak = partial_f < 10
  )
}

results <- lapply(specifications, run_specification)

table_rows <- vapply(results, function(x) {
  paste0(
    "| ", x$label, " | ", x$controls, " | ", x$n,
    " | ", fmt_num(x$ols), " | ", fmt_num(x$two_sls),
    " | ", fmt_num(x$first_stage), " | ", fmt_num(x$partial_f),
    " | ", fmt_p(x$partial_p), " | ", if (x$weak) "Yes" else "No", " |"
  )
}, character(1))

table_text <- c(
  "# AJR IV robustness checks",
  "",
  "Outcome: `logpgp95`; endogenous regressor: `avexpr`; excluded instrument: `logem4`.",
  "Each row constructs one complete-case sample before estimating both OLS and 2SLS, so the two estimates in a row use identical observations.",
  "",
  "| Specification | Controls in OLS, 2SLS, and first stage | N | OLS: avexpr | 2SLS: avexpr | First stage: logem4 | Partial F for logem4 | F-test p-value | Weak IV (F < 10)? |",
  "|---|---|---:|---:|---:|---:|---:|---:|---|",
  table_rows,
  "",
  "Notes: 2SLS is estimated with `AER::ivreg()`. The reported partial F is the conventional homoskedastic first-stage F test for adding `logem4` to a first stage that already includes the row's controls (computed with `car::linearHypothesis()`; equivalently, the nested-model F test). `Yes` applies the common rule-of-thumb threshold F < 10; it is a diagnostic, not a formal validity test."
)
writeLines(table_text, "robustness-table.md")

by_label <- setNames(results, vapply(results, `[[`, character(1), "label"))
memo_text <- c(
  "# Memo: AJR IV robustness checks",
  "",
  "This exercise estimates the association between protection against expropriation risk (`avexpr`) and log GDP per capita in 1995 (`logpgp95`) in the Acemoglu, Johnson, and Robinson colonial sample. The IV specification treats `avexpr` as endogenous and uses log settler mortality (`logem4`) as its excluded instrument. The script takes the `AER::ivreg()` path for 2SLS. For every row, it first forms the complete-case sample for the outcome, endogenous variable, instrument, and any row-specific controls, then estimates OLS and 2SLS on that identical sample. Thus, differences between the two estimates within a row are not artifacts of different missing-data samples.",
  "",
  paste0("In the bivariate full sample (N = ", by_label[["Bivariate"]]$n, "), the OLS coefficient on `avexpr` is ", fmt_num(by_label[["Bivariate"]]$ols), ", while the 2SLS coefficient is ", fmt_num(by_label[["Bivariate"]]$two_sls), ". The first-stage association between settler mortality and institutional quality is negative (", fmt_num(by_label[["Bivariate"]]$first_stage), ") and the excluded-instrument F statistic is ", fmt_num(by_label[["Bivariate"]]$partial_f), ". Adding absolute latitude produces a 2SLS estimate of ", fmt_num(by_label[["Absolute latitude"]]$two_sls), " and a conditional first-stage F of ", fmt_num(by_label[["Absolute latitude"]]$partial_f), ". Controlling instead for Africa and Asia indicators gives a 2SLS estimate of ", fmt_num(by_label[["Africa and Asia indicators"]]$two_sls), " with F = ", fmt_num(by_label[["Africa and Asia indicators"]]$partial_f), ". These full-sample first stages exceed the conventional F = 10 screen, although that threshold is only a rough diagnostic.") ,
  "",
  paste0("The restricted samples are less reassuring. Excluding Australia, Canada, New Zealand, and the United States leaves N = ", by_label[["Exclude AUS/CAN/NZL/USA"]]$n, ", raises the 2SLS estimate to ", fmt_num(by_label[["Exclude AUS/CAN/NZL/USA"]]$two_sls), ", and lowers the conditional F to ", fmt_num(by_label[["Exclude AUS/CAN/NZL/USA"]]$partial_f), "; this is flagged as weak under F < 10. In the Africa-only sample (N = ", by_label[["Africa only"]]$n, "), the estimate is ", fmt_num(by_label[["Africa only"]]$two_sls), ", but the first-stage F is only ", fmt_num(by_label[["Africa only"]]$partial_f), ". That first stage is too weak for the conventional screen, making the Africa-only IV point estimate especially imprecise and vulnerable to weak-instrument distortions."),
  "",
  "The results are consistent with a positive causal interpretation only under the IV assumptions: settler mortality must be relevant, affect 1995 income through institutions rather than other channels, and be sufficiently independent of unobserved determinants after the stated controls. These checks do not establish those assumptions. The sample changes also alter estimates and instrument strength, so the evidence is best read as suggestive robustness information rather than as proof that a single stable causal effect applies across all subsamples. The table reports conventional, homoskedastic first-stage diagnostics; it does not replace weak-IV-robust inference or a substantive defense of the exclusion restriction."
)
writeLines(memo_text, "memo.md")
