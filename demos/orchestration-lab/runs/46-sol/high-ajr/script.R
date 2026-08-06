#!/usr/bin/env Rscript

# Deterministic robustness analysis of the AJR colonial-origins IV result.
library(ivdoctr)
library(AER)

set.seed(2001)

OUTCOME <- "logpgp95"
ENDOGENOUS <- "avexpr"
INSTRUMENT <- "logem4"
NEO_EUROPES <- c("AUS", "CAN", "NZL", "USA")
OUTPUT_FILE <- "robustness-table.md"
ROUND_DIGITS <- 3L

data(colonial, package = "ivdoctr")
colonial <- as.data.frame(colonial)

specifications <- list(
  list(name = "Bivariate full sample", controls = character(), filter = function(d) rep(TRUE, nrow(d))),
  list(name = "Full sample + latitude", controls = "lat_abst", filter = function(d) rep(TRUE, nrow(d))),
  list(name = "Full sample + Africa and Asia", controls = c("africa", "asia"), filter = function(d) rep(TRUE, nrow(d))),
  list(name = "Bivariate, excluding neo-Europes", controls = character(), filter = function(d) !(d$shortnam %in% NEO_EUROPES)),
  list(name = "Bivariate, Africa only", controls = character(), filter = function(d) d$africa == 1)
)

make_formula <- function(lhs, rhs) {
  stats::as.formula(paste(lhs, "~", paste(rhs, collapse = " + ")))
}

format_number <- function(x) {
  formatC(x, format = "f", digits = ROUND_DIGITS)
}

estimate_specification <- function(spec, data) {
  required <- c(OUTCOME, ENDOGENOUS, INSTRUMENT, spec$controls)
  filtered <- data[spec$filter(data), , drop = FALSE]
  sample <- filtered[stats::complete.cases(filtered[, required, drop = FALSE]), required, drop = FALSE]

  structural_rhs <- c(ENDOGENOUS, spec$controls)
  first_stage_rhs <- c(INSTRUMENT, spec$controls)
  ols <- stats::lm(make_formula(OUTCOME, structural_rhs), data = sample)
  first_stage <- stats::lm(make_formula(ENDOGENOUS, first_stage_rhs), data = sample)
  restricted_first_stage <- stats::lm(
    make_formula(ENDOGENOUS, if (length(spec$controls)) spec$controls else "1"),
    data = sample
  )
  iv <- AER::ivreg(
    stats::as.formula(paste(
      OUTCOME, "~", paste(structural_rhs, collapse = " + "),
      "|", paste(c(INSTRUMENT, spec$controls), collapse = " + ")
    )),
    data = sample
  )

  # This nested-model test is the excluded-instrument partial F, not the overall F.
  partial_f <- stats::anova(restricted_first_stage, first_stage)$F[2]
  first_stage_t <- summary(first_stage)$coefficients[INSTRUMENT, "t value"]
  stopifnot(isTRUE(all.equal(partial_f, unname(first_stage_t^2), tolerance = 1e-8)))

  data.frame(
    specification = spec$name,
    n = stats::nobs(ols),
    ols = unname(stats::coef(ols)[ENDOGENOUS]),
    iv = unname(stats::coef(iv)[ENDOGENOUS]),
    first_stage = unname(stats::coef(first_stage)[INSTRUMENT]),
    partial_f = unname(partial_f),
    weak = partial_f < 10,
    stringsAsFactors = FALSE
  )
}

results <- do.call(rbind, lapply(specifications, estimate_specification, data = colonial))

table_rows <- vapply(seq_len(nrow(results)), function(i) {
  row <- results[i, ]
  status <- if (row$weak) "Weak (F < 10; 2SLS not reliable)" else "Not weak"
  paste(
    "|", row$specification,
    "|", row$n,
    "|", format_number(row$ols),
    "|", format_number(row$iv),
    "|", format_number(row$first_stage),
    "|", format_number(row$partial_f),
    "|", status, "|"
  )
}, character(1))

markdown <- c(
  "# AJR IV robustness analysis",
  "",
  "All estimates use `AER::ivreg` for 2SLS. Within each row, one complete-case sample (for `logpgp95`, `avexpr`, `logem4`, and that row's controls) is used consistently for OLS, IV, and both first-stage regressions.",
  "",
  "The reported first-stage F is the excluded-instrument partial F: the nested-model F comparison of a first stage without `logem4` against the otherwise identical first stage including `logem4`. With one excluded instrument, it equals the squared `logem4` t statistic (verified in `script.R`). Values below 10 are flagged; their 2SLS point estimates should not be treated as reliable.",
  "",
  "| Specification | N | OLS: avexpr | 2SLS: avexpr | First stage: logem4 | Partial F (logem4) | Identification status |",
  "|---|---:|---:|---:|---:|---:|---|",
  table_rows
)

writeLines(markdown, OUTPUT_FILE)
