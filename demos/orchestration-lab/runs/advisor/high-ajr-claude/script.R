#!/usr/bin/env Rscript
## Task H: Replicate and stress-test the AJR (2001) IV result
##
## Packages declared up front per house convention.
suppressPackageStartupMessages({
  library(ivdoctr)
  library(AER)   # ivreg() available -> used for all 2SLS specs below
})

set.seed(1)  # OLS/2SLS here are deterministic; set per house convention anyway

data(colonial, package = "ivdoctr")
colonial <- as.data.frame(colonial)

neo_europes <- c("AUS", "CAN", "NZL", "USA")

## ---------------------------------------------------------------------
## Helper: fit OLS + 2SLS (AER::ivreg) for a given sample/control set,
## and pull coefficients, SEs, and the first-stage F on the excluded
## instrument.
## ---------------------------------------------------------------------
run_spec <- function(label, df, extra_controls = character(0)) {
  rhs <- paste(c("avexpr", extra_controls), collapse = " + ")
  fs_rhs <- paste(c("logem4", extra_controls), collapse = " + ")

  ols_formula <- as.formula(paste("logpgp95 ~", rhs))
  ols_fit <- lm(ols_formula, data = df)
  ols_smry <- summary(ols_fit)$coefficients
  ols_coef <- ols_smry["avexpr", "Estimate"]
  ols_se   <- ols_smry["avexpr", "Std. Error"]

  iv_formula <- as.formula(paste("logpgp95 ~", rhs, "|", fs_rhs))
  iv_fit <- ivreg(iv_formula, data = df)
  ## diagnostics = TRUE adds a "Weak instruments" row: the classical
  ## partial F-test on the excluded instrument in the first stage. This
  ## is numerically identical to car::linearHypothesis(fs_fit, "logem4 =
  ## 0", test = "F") but avoids a second model fit and the car dependency.
  iv_smry <- summary(iv_fit, diagnostics = TRUE)
  iv_coef <- iv_smry$coefficients["avexpr", "Estimate"]
  iv_se   <- iv_smry$coefficients["avexpr", "Std. Error"]
  fs_f    <- iv_smry$diagnostics["Weak instruments", "statistic"]

  ## nobs() on the fitted models, not nrow(df): catches any silent
  ## OLS/2SLS sample divergence from missingness that nrow() would miss.
  stopifnot(nobs(ols_fit) == nobs(iv_fit))
  n <- nobs(iv_fit)

  fs_formula <- as.formula(paste("avexpr ~", fs_rhs))
  fs_fit <- lm(fs_formula, data = df)
  fs_coef <- coef(fs_fit)["logem4"]

  list(
    label = label,
    n = n,
    ols_coef = unname(ols_coef),
    ols_se = unname(ols_se),
    iv_coef = unname(iv_coef),
    iv_se = unname(iv_se),
    fs_coef = unname(fs_coef),
    fs_f = unname(fs_f),
    weak = fs_f < 10
  )
}

## ---------------------------------------------------------------------
## Anderson-Rubin 95% confidence sets for the two weak-instrument specs,
## (c) and (d). Unlike the Wald CI implied by the 2SLS SE above, the AR
## set stays valid under a weak instrument -- it *demonstrates* whether a
## spec can identify the parameter rather than asserting it from F alone.
## Grid-search inversion: retain beta0 if the excluded instrument is not
## significant (F-test) in a regression of (y - beta0*x) on the
## instrument plus controls.
## ---------------------------------------------------------------------
ar_ci <- function(df, extra_controls = character(0), grid, alpha = 0.05) {
  fs_rhs <- paste(c("logem4", extra_controls), collapse = " + ")
  m0_rhs <- if (length(extra_controls)) paste(extra_controls, collapse = " + ") else "1"
  crit <- qf(1 - alpha, df1 = 1, df2 = nrow(df) - length(extra_controls) - 2)
  not_rejected <- vapply(grid, function(b0) {
    df$ytilde <- df$logpgp95 - b0 * df$avexpr
    m0 <- lm(as.formula(paste("ytilde ~", m0_rhs)), data = df)
    m1 <- lm(as.formula(paste("ytilde ~", fs_rhs)), data = df)
    anova(m0, m1)$F[2] <= crit
  }, logical(1))
  if (!any(not_rejected)) return(c(NA_real_, NA_real_))
  range(grid[not_rejected])
}

fmt_ar <- function(ci, grid) {
  if (all(is.na(ci))) return("empty at this grid resolution")
  if (ci[1] <= min(grid) || ci[2] >= max(grid)) {
    sprintf("essentially unbounded (95%% set still open at grid edge +/-%.0f)", max(grid))
  } else {
    sprintf("[%.2f, %.2f]", ci[1], ci[2])
  }
}

## ---------------------------------------------------------------------
## 1. Headline replication: bivariate 2SLS / OLS, full base sample
## ---------------------------------------------------------------------
spec_headline <- run_spec("Headline (bivariate)", colonial)

## ---------------------------------------------------------------------
## 2. Stress tests
## ---------------------------------------------------------------------
spec_lat   <- run_spec("(a) + latitude", colonial, extra_controls = "lat_abst")
spec_cont  <- run_spec("(b) + continent dummies", colonial, extra_controls = c("africa", "asia"))
spec_noeur <- run_spec("(c) drop neo-Europes", colonial[!colonial$shortnam %in% neo_europes, ])
spec_afr   <- run_spec("(d) Africa only", colonial[colonial$africa == 1, ])

specs <- list(spec_headline, spec_lat, spec_cont, spec_noeur, spec_afr)

## Anderson-Rubin 95% sets, computed only for the two flagged (weak-
## instrument) specs -- that is what they are diagnostic for.
ar_grid <- seq(-50, 50, by = 0.05)
ar_noeur <- ar_ci(colonial[!colonial$shortnam %in% neo_europes, ], grid = ar_grid)
ar_afr   <- ar_ci(colonial[colonial$africa == 1, ], grid = ar_grid)

## ---------------------------------------------------------------------
## Console report
## ---------------------------------------------------------------------
cat("2SLS path: AER::ivreg (available) — used for all specifications.\n\n")

for (s in specs) {
  cat(sprintf(
    "%-28s n=%2d  OLS=%.3f (se=%.3f)  2SLS=%.3f (se=%.3f)  1st-stage coef=%.3f  F=%.2f%s\n",
    s$label, s$n, s$ols_coef, s$ols_se, s$iv_coef, s$iv_se, s$fs_coef, s$fs_f,
    if (s$weak) "  [WEAK INSTRUMENT]" else ""
  ))
}
cat(sprintf("\nAR 95%% set, (c) drop neo-Europes: %s\n", fmt_ar(ar_noeur, ar_grid)))
cat(sprintf("AR 95%% set, (d) Africa only:      %s\n", fmt_ar(ar_afr, ar_grid)))

## ---------------------------------------------------------------------
## Write robustness-table.md
## ---------------------------------------------------------------------
tbl_lines <- c(
  "# Robustness table: AJR (2001) headline IV result",
  "",
  "2SLS path: `AER::ivreg` (available on this system) used for every specification;",
  "reported first-stage F is the classical (homoskedastic) partial F on the excluded",
  "instrument (`logem4`), read off `summary(ivreg_fit, diagnostics = TRUE)`. This is the",
  "correct pairing with the Staiger-Stock ~10 rule used below, but it is not a",
  "heteroskedasticity-robust or Montiel Olea-Pflueger effective F, which could differ",
  "under non-classical errors. SEs on the OLS/2SLS coefficients are likewise classical.",
  "N is `nobs()` on the fitted model, asserted equal across OLS and 2SLS per spec.",
  "",
  "| Spec | N | OLS (avexpr), SE | 2SLS (avexpr), SE | 1st-stage coef (logem4) | 1st-stage F | Weak instrument (F<10)? |",
  "|---|---|---|---|---|---|---|"
)

for (s in specs) {
  iv_cell <- if (s$weak) sprintf("[%.3f], %.3f", s$iv_coef, s$iv_se) else sprintf("%.3f, %.3f", s$iv_coef, s$iv_se)
  tbl_lines <- c(tbl_lines, sprintf(
    "| %s | %d | %.3f, %.3f | %s | %.3f | %.2f | %s |",
    s$label, s$n, s$ols_coef, s$ols_se, iv_cell, s$fs_coef, s$fs_f,
    if (s$weak) "**YES**" else "No"
  ))
}

tbl_lines <- c(tbl_lines, "",
  "Notes: Outcome is `logpgp95`; endogenous regressor is `avexpr`; excluded instrument is `logem4`.",
  "Spec (a) adds `lat_abst`; (b) adds `africa` and `asia`; (c) drops AUS/CAN/NZL/USA (`shortnam`);",
  "(d) restricts to `africa == 1`. Rule of thumb: first-stage F below ~10 flags a weak instrument;",
  "2SLS point estimates in flagged rows are bracketed `[...]` and should not be read as reliable",
  "point estimates of the causal effect -- the weak-instrument caveat travels with the number.",
  "",
  "**Anderson-Rubin 95% confidence sets (weak-instrument specs only).** The Wald CI implied by",
  "the 2SLS SE above assumes a strong instrument; AR inversion does not, so it is the right tool",
  "to characterize what these two specs can and cannot pin down:",
  "",
  sprintf("- (c) drop neo-Europes: %s", fmt_ar(ar_noeur, ar_grid)),
  sprintf("- (d) Africa only: %s", fmt_ar(ar_afr, ar_grid)),
  "",
  "The Africa-only set is essentially unbounded -- direct evidence, not an inference from a low F,",
  "that this subsample cannot identify the coefficient with this instrument."
)

writeLines(tbl_lines, "robustness-table.md")
cat("\nWrote robustness-table.md\n")
