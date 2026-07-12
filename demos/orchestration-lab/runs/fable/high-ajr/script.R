library(ivdoctr)
library(AER)
library(car)

# No set.seed() needed: every estimator here (OLS via lm, 2SLS via AER::ivreg)
# is deterministic given the data.
# 2SLS is estimated with AER::ivreg (installed and available), not a manual
# two-stage lm() approach.

data(colonial, package = "ivdoctr")

run_spec <- function(name, dat, controls) {
  rhs <- if (length(controls) > 0) paste(controls, collapse = " + ") else NULL
  ols_formula <- if (is.null(rhs)) {
    logpgp95 ~ avexpr
  } else {
    as.formula(paste("logpgp95 ~ avexpr +", rhs))
  }
  iv_formula <- if (is.null(rhs)) {
    logpgp95 ~ avexpr | logem4
  } else {
    as.formula(paste("logpgp95 ~ avexpr +", rhs, "| logem4 +", rhs))
  }
  fs_formula <- if (is.null(rhs)) {
    avexpr ~ logem4
  } else {
    as.formula(paste("avexpr ~ logem4 +", rhs))
  }

  ols <- lm(ols_formula, data = dat)
  iv <- ivreg(iv_formula, data = dat)
  fs <- lm(fs_formula, data = dat)

  ols_coef <- coef(summary(ols))["avexpr", "Estimate"]
  ols_se <- coef(summary(ols))["avexpr", "Std. Error"]
  iv_coef <- coef(summary(iv))["avexpr", "Estimate"]
  iv_se <- coef(summary(iv))["avexpr", "Std. Error"]
  fs_coef <- coef(summary(fs))["logem4", "Estimate"]
  fs_f <- car::linearHypothesis(fs, "logem4 = 0")$F[2]

  data.frame(
    spec = name,
    n = nrow(dat),
    ols_coef = ols_coef,
    ols_se = ols_se,
    iv_coef = iv_coef,
    iv_se = iv_se,
    fs_logem4_coef = fs_coef,
    fs_F = fs_f,
    weak_instrument = fs_f < 10
  )
}

drop_neo_europe <- subset(colonial, !(shortnam %in% c("AUS", "CAN", "NZL", "USA")))
africa_only <- subset(colonial, africa == 1)

results <- rbind(
  run_spec("1. Baseline", colonial, character(0)),
  run_spec("2. + latitude", colonial, "lat_abst"),
  run_spec("3. + continent", colonial, c("africa", "asia")),
  run_spec("4. Drop neo-Europes", drop_neo_europe, character(0)),
  run_spec("5. Africa only", africa_only, character(0))
)

cat("\n=== Results across 5 specifications ===\n")
print(round(results[, sapply(results, is.numeric)], 3) |>
        cbind(spec = results$spec, weak_instrument = results$weak_instrument) |>
        (\(df) df[, c("spec", setdiff(names(df), c("spec", "weak_instrument")), "weak_instrument")])(),
      row.names = FALSE)

cat("\n=== Baseline spec (deliverable #1) ===\n")
baseline <- results[results$spec == "1. Baseline", ]
cat(sprintf("OLS avexpr coefficient: %.3f (SE %.3f)\n", baseline$ols_coef, baseline$ols_se))
cat(sprintf("2SLS avexpr coefficient: %.3f (SE %.3f)\n", baseline$iv_coef, baseline$iv_se))
cat(sprintf("First-stage logem4 coefficient: %.3f, F-stat: %.3f\n", baseline$fs_logem4_coef, baseline$fs_F))
