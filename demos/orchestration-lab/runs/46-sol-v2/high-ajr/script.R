#!/usr/bin/env Rscript

# Packages -------------------------------------------------------------------
suppressPackageStartupMessages({
  library(ivdoctr)
  library(AER)
})

# The analysis is deterministic; the seed makes that convention explicit.
set.seed(20260719)

# Data -----------------------------------------------------------------------
data(colonial, package = "ivdoctr")
colonial <- as.data.frame(colonial)

outcome <- "logpgp95"
endogenous <- "avexpr"
instrument <- "logem4"
neo_europes <- c("AUS", "CAN", "NZL", "USA")
weak_f_cutoff <- 10

stopifnot(
  nrow(colonial) == 64L,
  all(c(outcome, endogenous, instrument, "lat_abst", "africa", "asia",
        "shortnam", "rich4") %in% names(colonial)),
  setequal(colonial$shortnam[colonial$rich4 == 1], neo_europes)
)

specifications <- list(
  list(
    name = "Baseline",
    display = "Baseline",
    controls = character(0),
    keep = function(d) rep(TRUE, nrow(d))
  ),
  list(
    name = "Latitude",
    display = "+ Latitude",
    controls = "lat_abst",
    keep = function(d) rep(TRUE, nrow(d))
  ),
  list(
    name = "Continents",
    display = "+ Continent controls",
    controls = c("africa", "asia"),
    keep = function(d) rep(TRUE, nrow(d))
  ),
  list(
    name = "Drop neo-Europes",
    display = "Drop neo-Europes",
    controls = character(0),
    keep = function(d) !d$shortnam %in% neo_europes
  ),
  list(
    name = "Africa only",
    display = "Africa only",
    controls = character(0),
    keep = function(d) d$africa == 1
  )
)

# Estimation -----------------------------------------------------------------
estimate_specification <- function(spec, data) {
  d <- data[spec$keep(data), , drop = FALSE]
  model_variables <- c(outcome, endogenous, instrument, spec$controls)
  d <- d[complete.cases(d[, model_variables, drop = FALSE]), , drop = FALSE]

  structural_rhs <- c(endogenous, spec$controls)
  instrument_rhs <- c(instrument, spec$controls)
  structural_formula <- reformulate(structural_rhs, response = outcome)
  first_stage_formula <- reformulate(instrument_rhs, response = endogenous)
  restricted_formula <- reformulate(spec$controls, response = endogenous)
  iv_formula <- as.formula(sprintf(
    "%s ~ %s | %s",
    outcome,
    paste(structural_rhs, collapse = " + "),
    paste(instrument_rhs, collapse = " + ")
  ))

  # All four models receive the same already-complete data frame.
  ols_model <- lm(structural_formula, data = d, na.action = na.fail)
  iv_model <- AER::ivreg(iv_formula, data = d, na.action = na.fail)
  first_stage <- lm(first_stage_formula, data = d, na.action = na.fail)
  first_stage_restricted <- lm(restricted_formula, data = d,
                               na.action = na.fail)

  first_stage_test <- anova(first_stage_restricted, first_stage)
  first_stage_f <- unname(first_stage_test$F[2L])
  first_stage_p <- unname(first_stage_test$`Pr(>F)`[2L])
  aer_f <- unname(
    summary(iv_model, diagnostics = TRUE)$diagnostics[
      "Weak instruments", "statistic"
    ]
  )

  stopifnot(
    nobs(ols_model) == nrow(d),
    nobs(iv_model) == nrow(d),
    nobs(first_stage) == nrow(d),
    nobs(first_stage_restricted) == nrow(d),
    isTRUE(all.equal(first_stage_f, aer_f, tolerance = 1e-10))
  )

  data.frame(
    specification = spec$name,
    display = spec$display,
    controls = if (length(spec$controls)) {
      paste(spec$controls, collapse = ", ")
    } else {
      "None"
    },
    n = nrow(d),
    ols = unname(coef(ols_model)[endogenous]),
    iv = unname(coef(iv_model)[endogenous]),
    first_stage_coefficient = unname(coef(first_stage)[instrument]),
    first_stage_f = first_stage_f,
    first_stage_p = first_stage_p,
    weak = first_stage_f < weak_f_cutoff,
    stringsAsFactors = FALSE
  )
}

results <- do.call(
  rbind,
  lapply(specifications, estimate_specification, data = colonial)
)
rownames(results) <- NULL

# Markdown robustness table ---------------------------------------------------
table_rows <- vapply(seq_len(nrow(results)), function(i) {
  marker <- if (results$weak[i]) "†" else ""
  sprintf(
    "| %s | %s | %d | %.3f | %.3f%s | %.3f | %.2f | %s |",
    results$display[i], results$controls[i], results$n[i], results$ols[i],
    results$iv[i], marker, results$first_stage_coefficient[i],
    results$first_stage_f[i], if (results$weak[i]) "**Yes**" else "No"
  )
}, character(1))

table_lines <- c(
  "# AJR replication and robustness",
  "",
  "| Specification | Included controls | N | OLS: `avexpr` | 2SLS: `avexpr` | First stage: `logem4` | Excluded-instrument F | Weak (F < 10)? |",
  "|:--|:--|--:|--:|--:|--:|--:|:--|",
  table_rows,
  "",
  "Notes: The outcome is log PPP GDP per capita in 1995 (`logpgp95`). In every row, `avexpr` is instrumented by `logem4`; included controls enter both the structural equation and the instrument set. OLS and 2SLS use the same complete-case rows. The excluded-instrument statistic is the ordinary homoskedastic partial F test from nested first-stage `lm` models, conditional on the listed controls; it matches the weak-instrument diagnostic returned by `summary(AER::ivreg(...), diagnostics = TRUE)`. The four code-based neo-Europe exclusions exactly match observations with `rich4 == 1` in these data.",
  "",
  "† F is below the rule-of-thumb threshold of 10. The 2SLS coefficient is shown for transparency but should not be treated as a reliable structural estimate. Estimation uses `AER::ivreg`; no generated-regressor standard-error approximation is used."
)
writeLines(table_lines, "robustness-table.md", useBytes = TRUE)

# Claim-calibrated memo -------------------------------------------------------
row_for <- function(name) results[results$specification == name, , drop = FALSE]
base <- row_for("Baseline")
latitude <- row_for("Latitude")
continents <- row_for("Continents")
drop_neo <- row_for("Drop neo-Europes")
africa <- row_for("Africa only")

memo_lines <- c(
  "# Memo",
  "",
  sprintf(
    paste0(
      "The headline replicates in the 64-country base sample. OLS associates a ",
      "one-point increase in protection against expropriation (`avexpr`) with ",
      "%.3f log points higher 1995 income; bivariate 2SLS raises the coefficient ",
      "to %.3f. The first stage has the expected sign: a one-unit increase in log ",
      "settler mortality predicts %.3f points lower institutional protection. Its ",
      "excluded-instrument F is %.2f, comfortably above the conventional 10-point ",
      "screen. Thus the base-sample point estimate is not being generated by an ",
      "obviously weak first stage, although that screen does not establish the ",
      "instrument's validity."
    ),
    base$ols, base$iv, base$first_stage_coefficient, base$first_stage_f
  ),
  "",
  sprintf(
    paste0(
      "The positive relationship also survives the two control perturbations. ",
      "With latitude, OLS is %.3f and 2SLS is %.3f; with Africa and Asia indicators, ",
      "they are %.3f and %.3f. The corresponding first-stage F statistics fall to ",
      "%.2f and %.2f. Both remain just above the rule-of-thumb threshold, so these ",
      "results support a narrower robustness statement: the positive IV estimate ",
      "is not eliminated by these particular geographic controls. The decline in ",
      "first-stage strength, especially with continent indicators, nevertheless ",
      "argues against describing the estimates as uniformly precise or impervious ",
      "to specification."
    ),
    latitude$ols, latitude$iv, continents$ols, continents$iv,
    latitude$first_stage_f, continents$first_stage_f
  ),
  "",
  sprintf(
    paste0(
      "The sample restrictions do not provide additional reliable IV confirmation. ",
      "After removing Australia, Canada, New Zealand, and the United States, the ",
      "first-stage coefficient attenuates to %.3f and F falls to %.2f. In the ",
      "27-country Africa-only sample it is %.3f with F = %.2f: the instrument has ",
      "effectively collapsed. The associated 2SLS coefficients (%.3f and %.3f) are ",
      "reported for transparency, not interpreted. Weak identification can produce ",
      "unstable point estimates, so these rows neither confirm the headline nor ",
      "overturn it; in particular, they cannot establish an Africa-specific effect ",
      "or cross-region heterogeneity."
    ),
    drop_neo$first_stage_coefficient, drop_neo$first_stage_f,
    africa$first_stage_coefficient, africa$first_stage_f,
    drop_neo$iv, africa$iv
  ),
  "",
  paste0(
    "The manuscript may therefore claim that it reproduces AJR's positive, larger-",
    "than-OLS 2SLS association in the base sample and that the positive estimates ",
    "remain broadly similar after adding latitude or the specified continent controls, ",
    "conditional on the usual IV assumptions. It may not claim robustness to ",
    "excluding the neo-Europes or to an Africa-only analysis, because those designs ",
    "lack a sufficiently strong first stage. Nor do these regressions by themselves ",
    "verify exclusion, independence, monotonicity, external validity, or a universal ",
    "causal effect of institutions. With one excluded instrument for one endogenous ",
    "regressor, the models are exactly identified, so this exercise supplies no ",
    "overidentification test of the exclusion restriction."
  )
)
writeLines(memo_lines, "memo.md", useBytes = TRUE)

# Console record -------------------------------------------------------------
print(results, row.names = FALSE, digits = 6)
cat("\nWrote robustness-table.md and memo.md using AER::ivreg.\n")
