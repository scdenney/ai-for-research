## script.R
## Replicate and stress-test the AJR (2001) headline IV result:
## logpgp95 ~ avexpr, avexpr instrumented by logem4.
##
## Packages / palette declared up front per house convention.
suppressPackageStartupMessages({
  library(ivdoctr)   # ships the `colonial` AJR base sample
  library(AER)        # ivreg() for 2SLS
  library(car)         # linearHypothesis(), used for the first-stage F
})

## Okabe-Ito palette (kept for the optional figure below)
okabe_ito <- c(
  black   = "#000000",
  orange  = "#E69F00",
  skyblue = "#56B4E9",
  green   = "#009E73",
  yellow  = "#F0E442",
  blue    = "#0072B2",
  vermil  = "#D55E00",
  purple  = "#CC79A7"
)

set.seed(1)  # no stochastic steps here (OLS/2SLS are deterministic); set per house convention anyway

data(colonial, package = "ivdoctr")
d <- as.data.frame(colonial)

## ---------------------------------------------------------------------
## Helper: run OLS + 2SLS (via AER::ivreg) + first-stage F on a given
## subset/formula-set, and return a one-row summary.
## ---------------------------------------------------------------------
run_spec <- function(name, dat, controls = character(0)) {
  rhs_ols  <- paste(c("avexpr", controls), collapse = " + ")
  ols_fml  <- as.formula(paste("logpgp95 ~", rhs_ols))

  iv_fml   <- as.formula(
    paste0("logpgp95 ~ ", rhs_ols, " | ", paste(c("logem4", controls), collapse = " + "))
  )

  ## complete-case sample shared by OLS and IV for this spec
  vars_needed <- unique(c("logpgp95", "avexpr", "logem4", controls))
  cc <- complete.cases(dat[, vars_needed])
  dat_cc <- dat[cc, ]

  ols_fit <- lm(ols_fml, data = dat_cc)
  iv_fit  <- ivreg(iv_fml, data = dat_cc)

  ## First stage: avexpr ~ logem4 + controls
  fs_fml <- as.formula(paste("avexpr ~", paste(c("logem4", controls), collapse = " + ")))
  fs_fit <- lm(fs_fml, data = dat_cc)
  fs_coef <- coef(fs_fit)["logem4"]

  ## First-stage F on the excluded instrument (partial F, robust to
  ## presence of covariates): test logem4 = 0 in the first stage.
  fs_wald <- linearHypothesis(fs_fit, "logem4 = 0", test = "F")
  fs_F <- fs_wald[2, "F"]

  data.frame(
    spec        = name,
    n           = nrow(dat_cc),
    ols_est     = unname(coef(ols_fit)["avexpr"]),
    ols_se      = unname(summary(ols_fit)$coefficients["avexpr", "Std. Error"]),
    iv_est      = unname(coef(iv_fit)["avexpr"]),
    iv_se       = unname(summary(iv_fit)$coefficients["avexpr", "Std. Error"]),
    fs_coef     = unname(fs_coef),
    fs_F        = unname(fs_F),
    weak        = unname(fs_F) < 10
  )
}

## ---------------------------------------------------------------------
## 1. Headline bivariate replication
## ---------------------------------------------------------------------
spec_base <- run_spec("(1) Baseline: bivariate", d)

## ---------------------------------------------------------------------
## 2. Stress tests
## ---------------------------------------------------------------------
spec_lat    <- run_spec("(2) + latitude",           d, controls = "lat_abst")
spec_cont   <- run_spec("(3) + continent dummies",  d, controls = c("africa", "asia"))

d_noneo <- d[!(d$shortnam %in% c("AUS", "CAN", "NZL", "USA")), ]
spec_noneo  <- run_spec("(4) Drop neo-Europes",     d_noneo)

d_africa <- d[d$africa == 1, ]
spec_africa <- run_spec("(5) Africa only",          d_africa)

results <- rbind(spec_base, spec_lat, spec_cont, spec_noneo, spec_africa)
print(results, digits = 3)

## ---------------------------------------------------------------------
## Write robustness table (markdown)
## ---------------------------------------------------------------------
fmt <- function(x, d = 3) formatC(x, format = "f", digits = d)

tbl_lines <- c(
  "# Robustness table — AJR headline IV result",
  "",
  "Outcome: `logpgp95`. Endogenous regressor: `avexpr`. Excluded instrument: `logem4`.",
  "2SLS estimated with `AER::ivreg`. First-stage F is the partial F-statistic",
  "(via `car::linearHypothesis`) on `logem4` in the regression of `avexpr` on the",
  "instrument and any included controls, within each spec's complete-case sample.",
  "",
  "| Spec | N | OLS (avexpr) | 2SLS (avexpr) | First-stage coef. (logem4) | First-stage F | Weak instrument? |",
  "|---|---:|---:|---:|---:|---:|:---:|"
)

for (i in seq_len(nrow(results))) {
  r <- results[i, ]
  flag <- if (r$weak) "**YES (F < 10)**" else "No"
  tbl_lines <- c(tbl_lines, sprintf(
    "| %s | %d | %s (se %s) | %s (se %s) | %s | %s | %s |",
    r$spec, r$n,
    fmt(r$ols_est), fmt(r$ols_se),
    fmt(r$iv_est), fmt(r$iv_se),
    fmt(r$fs_coef), fmt(r$fs_F, 2),
    flag
  ))
}

tbl_lines <- c(tbl_lines, "",
  sprintf("Note: standard errors for spec (5) (Africa only, N = %d) and any spec flagged",
          spec_africa$n),
  "weak should be read with caution regardless of nominal significance. With a single",
  "just-identified instrument, a weak first stage leaves the sampling distribution of",
  "the 2SLS estimator badly behaved and invalidates conventional standard errors/CIs.")

writeLines(tbl_lines, "robustness-table.md")

## ---------------------------------------------------------------------
## Optional figure: OLS vs 2SLS point estimates with first-stage F noted
## ---------------------------------------------------------------------
png("estimates-by-spec.png", width = 2400, height = 1600, res = 300)
op <- par(mar = c(8, 4.5, 1, 1))
x <- seq_len(nrow(results))
ols_y <- results$ols_est
iv_y  <- results$iv_est
ylim  <- range(c(ols_y, iv_y, ols_y - 1.96 * results$ols_se, iv_y + 1.96 * results$iv_se,
                 ols_y + 1.96 * results$ols_se, iv_y - 1.96 * results$iv_se))
plot(x - 0.08, ols_y, pch = 16, col = okabe_ito["blue"], xlim = c(0.5, max(x) + 0.5),
     ylim = ylim, xaxt = "n", xlab = "", ylab = "Coefficient on avexpr")
arrows(x - 0.08, ols_y - 1.96 * results$ols_se, x - 0.08, ols_y + 1.96 * results$ols_se,
       angle = 90, code = 3, length = 0.03, col = okabe_ito["blue"])
points(x + 0.08, iv_y, pch = 17, col = okabe_ito["vermil"])
arrows(x + 0.08, iv_y - 1.96 * results$iv_se, x + 0.08, iv_y + 1.96 * results$iv_se,
       angle = 90, code = 3, length = 0.03, col = okabe_ito["vermil"])
axis(1, at = x, labels = results$spec, las = 2, cex.axis = 0.7)
legend("topleft", legend = c("OLS", "2SLS"), pch = c(16, 17),
       col = c(okabe_ito["blue"], okabe_ito["vermil"]), bty = "n")
par(op)
dev.off()

cat("\nWrote robustness-table.md and estimates-by-spec.png\n")
