#!/usr/bin/env Rscript
#
# script.R -- Robustness of the AJR (2001) "Colonial Origins" IV estimate.
#
# Estimates OLS and 2SLS specifications of logpgp95 ~ avexpr (instrumented by
# logem4), across 5 specifications (bivariate, +latitude, +continent dummies,
# drop neo-Europes, Africa-only), and reports first-stage strength (F-stats)
# alongside a weak-instrument verdict for each. Writes robustness-table.md.
#
# Run with:  Rscript script.R
#
# Estimation path: AER::ivreg is available in this environment, so all 2SLS
# estimates below are exact 2SLS with correct standard errors (ivreg accounts
# for the generated first-stage regressor). The manual-two-lm fallback noted
# in the brief was not needed.

suppressPackageStartupMessages({
  library(ivdoctr)
  library(AER)
  library(car)
})

# Not load-bearing: this analysis is fully deterministic (OLS/2SLS have
# closed-form solutions), but we set a seed anyway to match house convention.
set.seed(46)

data(colonial, package = "ivdoctr")
d_full <- as.data.frame(colonial)

# ---------------------------------------------------------------------------
# Helper: run OLS + 2SLS + first-stage for a data subset and optional controls
# ---------------------------------------------------------------------------
run_spec <- function(dat, controls = character(0), label) {
  ctrl_str <- if (length(controls) > 0) paste(controls, collapse = " + ") else NULL

  ols_formula <- if (is.null(ctrl_str)) {
    as.formula("logpgp95 ~ avexpr")
  } else {
    as.formula(paste("logpgp95 ~ avexpr +", ctrl_str))
  }

  iv_formula <- if (is.null(ctrl_str)) {
    as.formula("logpgp95 ~ avexpr | logem4")
  } else {
    as.formula(paste("logpgp95 ~ avexpr +", ctrl_str, "| logem4 +", ctrl_str))
  }

  fs_formula <- if (is.null(ctrl_str)) {
    as.formula("avexpr ~ logem4")
  } else {
    as.formula(paste("avexpr ~ logem4 +", ctrl_str))
  }

  ols_fit <- lm(ols_formula, data = dat)
  iv_fit  <- ivreg(iv_formula, data = dat)
  fs_fit  <- lm(fs_formula, data = dat)

  ols_coef <- coef(summary(ols_fit))["avexpr", "Estimate"]
  ols_se   <- coef(summary(ols_fit))["avexpr", "Std. Error"]

  iv_coef <- coef(summary(iv_fit))["avexpr", "Estimate"]
  iv_se   <- coef(summary(iv_fit))["avexpr", "Std. Error"]

  fs_coef <- coef(summary(fs_fit))["logem4", "Estimate"]
  fs_se   <- coef(summary(fs_fit))["logem4", "Std. Error"]

  # Homoskedastic first-stage F on the excluded instrument
  lh_homo <- car::linearHypothesis(fs_fit, "logem4 = 0")
  f_homo  <- lh_homo$F[2]

  # HC1-robust first-stage F (secondary check)
  lh_hc1 <- car::linearHypothesis(fs_fit, "logem4 = 0", white.adjust = "hc1")
  f_hc1  <- lh_hc1$F[2]

  verdict <- if (f_homo >= 10) {
    "strong"
  } else if (f_homo >= 5) {
    "weak (F<10)"
  } else {
    "collapsed"
  }

  list(
    label = label,
    n = nrow(dat),
    ols_coef = ols_coef, ols_se = ols_se,
    iv_coef = iv_coef, iv_se = iv_se,
    fs_coef = fs_coef, fs_se = fs_se,
    f_homo = f_homo, f_hc1 = f_hc1,
    verdict = verdict,
    iv_fit = iv_fit
  )
}

# ---------------------------------------------------------------------------
# The 5 specifications
# ---------------------------------------------------------------------------
spec1 <- run_spec(d_full, character(0), "1. Baseline (bivariate)")
spec2 <- run_spec(d_full, "lat_abst", "2. + latitude")
spec3 <- run_spec(d_full, c("africa", "asia"), "3. + continent controls")

d_no_neo <- d_full[!(d_full$shortnam %in% c("AUS", "CAN", "NZL", "USA")), ]
spec4 <- run_spec(d_no_neo, character(0), "4. Drop neo-Europes")

d_africa <- d_full[d_full$africa == 1, ]
spec5 <- run_spec(d_africa, character(0), "5. Africa only")

specs <- list(spec1, spec2, spec3, spec4, spec5)

# ---------------------------------------------------------------------------
# Sanity check: cross-check spec 1's F-stat against AER's built-in
# weak-instrument diagnostic
# ---------------------------------------------------------------------------
diag_f <- summary(spec1$iv_fit, diagnostics = TRUE)$diagnostics["Weak instruments", "statistic"]
stopifnot(abs(diag_f - spec1$f_homo) < 1e-6)
cat(sprintf(
  "Sanity check passed: spec 1 F-stat matches AER diagnostics (%.6f vs %.6f)\n",
  spec1$f_homo, diag_f
))

# ---------------------------------------------------------------------------
# Build markdown table
# ---------------------------------------------------------------------------
fmt_coef_se <- function(coef, se, digits = 3) {
  sprintf("%.*f (%.*f)", digits, coef, digits, se)
}

rows <- lapply(specs, function(s) {
  c(
    label   = s$label,
    n       = as.character(s$n),
    ols     = fmt_coef_se(s$ols_coef, s$ols_se),
    iv      = fmt_coef_se(s$iv_coef, s$iv_se),
    fs      = fmt_coef_se(s$fs_coef, s$fs_se),
    f_homo  = sprintf("%.2f", s$f_homo),
    f_hc1   = sprintf("%.2f", s$f_hc1),
    verdict = s$verdict
  )
})

header <- c("Spec", "n", "OLS coef (SE)", "2SLS coef (SE)",
            "First-stage logem4 coef (SE)", "First-stage F (homosk.)",
            "First-stage F (HC1)", "Verdict")

md_lines <- c(
  paste0("| ", paste(header, collapse = " | "), " |"),
  paste0("| ", paste(rep("---", length(header)), collapse = " | "), " |")
)
for (r in rows) {
  md_lines <- c(md_lines, paste0("| ", paste(r, collapse = " | "), " |"))
}

flagged <- sapply(specs, function(s) s$verdict != "strong")
flagged_labels <- sapply(specs[flagged], function(s) s$label)
note <- sprintf(
  "\nNote: weak-instrument rule of thumb (Stock-Yogo/Staiger-Stock heuristic): first-stage F >= 10 is \"strong\", 5 <= F < 10 is \"weak (F<10)\", F < 5 is \"collapsed\". Flagged non-strong: %s.",
  if (length(flagged_labels) > 0) paste(flagged_labels, collapse = "; ") else "none"
)

out <- c(
  "# Robustness table: AJR (2001) colonial origins IV estimates",
  "",
  md_lines,
  note
)

writeLines(out, "robustness-table.md")
cat("Wrote robustness-table.md\n")
