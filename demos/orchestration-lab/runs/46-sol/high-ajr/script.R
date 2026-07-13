#!/usr/bin/env Rscript

# Deterministic replication and robustness checks for the AJR colonial sample.
library(ivdoctr)
library(AER)

set.seed(2001)

data(colonial, package = "ivdoctr")
colonial <- as.data.frame(colonial)

# The raw AJR base sample contains 27 African countries before missing-data removal.
stopifnot(sum(colonial$africa == 1, na.rm = TRUE) == 27L)

specifications <- list(
  list(name = "Base", controls = character(), keep = function(d) rep(TRUE, nrow(d))),
  list(name = "Latitude", controls = "lat_abst", keep = function(d) rep(TRUE, nrow(d))),
  list(name = "Continent controls", controls = c("africa", "asia"), keep = function(d) rep(TRUE, nrow(d))),
  list(name = "Drop neo-Europes", controls = character(), keep = function(d) !d$shortnam %in% c("AUS", "CAN", "NZL", "USA")),
  list(name = "Africa only", controls = character(), keep = function(d) d$africa == 1)
)

make_formula <- function(lhs, rhs_terms) {
  rhs <- if (length(rhs_terms) == 0L) "1" else paste(rhs_terms, collapse = " + ")
  stats::as.formula(paste(lhs, "~", rhs))
}

estimate_specification <- function(spec, data) {
  # Apply this specification's restriction, then complete cases for all model variables.
  restricted <- data[spec$keep(data), , drop = FALSE]
  required <- c("logpgp95", "avexpr", "logem4", spec$controls)
  estimation_data <- restricted[stats::complete.cases(restricted[, required, drop = FALSE]), , drop = FALSE]

  ols_formula <- make_formula("logpgp95", c("avexpr", spec$controls))
  first_stage_formula <- make_formula("avexpr", c("logem4", spec$controls))
  restricted_first_stage_formula <- make_formula("avexpr", spec$controls)
  iv_formula <- stats::as.formula(paste(
    "logpgp95 ~", paste(c("avexpr", spec$controls), collapse = " + "),
    "|", paste(c("logem4", spec$controls), collapse = " + ")
  ))

  ols <- stats::lm(ols_formula, data = estimation_data)
  # Use the required AER::ivreg path for two-stage least squares.
  iv <- AER::ivreg(iv_formula, data = estimation_data)
  unrestricted_first_stage <- stats::lm(first_stage_formula, data = estimation_data)
  restricted_first_stage <- stats::lm(restricted_first_stage_formula, data = estimation_data)
  first_stage_comparison <- stats::anova(restricted_first_stage, unrestricted_first_stage)
  partial_f <- first_stage_comparison$F[2L]

  data.frame(
    specification = spec$name,
    n = nrow(estimation_data),
    ols = unname(stats::coef(ols)["avexpr"]),
    iv = unname(stats::coef(iv)["avexpr"]),
    first_stage_logem4 = unname(stats::coef(unrestricted_first_stage)["logem4"]),
    first_stage_f = partial_f,
    identification = if (partial_f < 10) "Weak (F < 10)" else "Not weak (F >= 10)",
    stringsAsFactors = FALSE
  )
}

results <- do.call(rbind, lapply(specifications, estimate_specification, data = colonial))
stopifnot(nrow(results) == 5L)

table_lines <- c(
  "| Specification | N | OLS: avexpr | 2SLS: avexpr | First stage: logem4 | First-stage partial F | Identification status |",
  "|---|---:|---:|---:|---:|---:|---|",
  vapply(seq_len(nrow(results)), function(i) {
    row <- results[i, ]
    paste0(
      "| ", row$specification,
      " | ", row$n,
      " | ", sprintf("%.3f", row$ols),
      " | ", sprintf("%.3f", row$iv),
      " | ", sprintf("%.3f", row$first_stage_logem4),
      " | ", sprintf("%.2f", row$first_stage_f),
      " | ", row$identification, " |"
    )
  }, character(1)),
  "",
  "Notes: OLS and 2SLS use the identical complete-case sample within each specification. The first-stage partial F is the conventional excluded-instrument F from comparing first stages without and with `logem4`. Specifications with F < 10 are marked weak; their displayed IV point estimates are retained for transparency but are not reliable causal estimates. 2SLS is estimated with `AER::ivreg`."
)

writeLines(table_lines, "robustness-table.md", useBytes = TRUE)
