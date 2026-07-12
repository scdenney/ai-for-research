#!/usr/bin/env Rscript
# =====================================================================
# Task H — Replicate and stress the AJR (2001) IV headline
#   logpgp95 ~ avexpr, with avexpr instrumented by logem4
#   Base sample: 64 countries (ivdoctr::colonial)
#
# 2SLS PATH: AER::ivreg (available in this environment), so second-stage
#   standard errors are the correct IV standard errors, NOT the naive
#   two-lm approximation.
# First-stage strength: partial F on the EXCLUDED instrument (logem4),
#   computed via car::linearHypothesis so it is correct with or without
#   controls. Rule of thumb: F < 10 => weak instrument.
# OLS/2SLS are deterministic; set.seed is declared for house convention.
# =====================================================================

suppressMessages({
  library(ivdoctr)
  library(AER)
  library(car)
})

set.seed(1)  # deterministic estimators; declared per house convention

## Okabe-Ito colour-blind-safe palette (house figure convention) ------
okabe_ito <- c(
  black = "#000000", orange = "#E69F00", skyblue = "#56B4E9",
  green = "#009E73", yellow = "#F0E442", blue = "#0072B2",
  vermillion = "#D55E00", purple = "#CC79A7", grey = "#999999"
)
col_strong <- okabe_ito[["blue"]]
col_weak   <- okabe_ito[["vermillion"]]

WEAK_F <- 10  # first-stage F rule-of-thumb threshold

## Data ---------------------------------------------------------------
data(colonial, package = "ivdoctr")
d <- colonial
stopifnot(nrow(d) == 64,
          all(c("logpgp95", "avexpr", "logem4", "lat_abst",
                "africa", "asia", "shortnam", "rich4") %in% names(d)))

neo_europes <- c("AUS", "CAN", "NZL", "USA")

## ---------------------------------------------------------------------
## Estimator for ONE specification.
##   controls: character vector of exogenous controls added to BOTH the
##             structural equation and the first stage (empty = bivariate).
## Returns one row of results.
## ---------------------------------------------------------------------
run_spec <- function(label, data, controls = character(0)) {
  rhs_ctrl <- if (length(controls))
    paste("+", paste(controls, collapse = " + ")) else ""

  f_ols <- as.formula(paste0("logpgp95 ~ avexpr", rhs_ctrl))
  f_iv  <- as.formula(paste0("logpgp95 ~ avexpr", rhs_ctrl,
                             " | logem4", rhs_ctrl))
  f_fs  <- as.formula(paste0("avexpr ~ logem4", rhs_ctrl))

  m_ols <- lm(f_ols, data = data)
  m_iv  <- AER::ivreg(f_iv, data = data)
  m_fs  <- lm(f_fs, data = data)

  co_ols <- summary(m_ols)$coefficients["avexpr", ]
  co_iv  <- summary(m_iv)$coefficients["avexpr", ]
  co_fs  <- summary(m_fs)$coefficients["logem4", ]

  # Partial F on the EXCLUDED instrument (correct with/without controls).
  F_stat <- car::linearHypothesis(m_fs, "logem4 = 0")$F[2]

  ci_iv <- confint(m_iv)["avexpr", ]

  data.frame(
    spec        = label,
    n           = nrow(data),
    ols_b       = unname(co_ols["Estimate"]),
    ols_se      = unname(co_ols["Std. Error"]),
    iv_b        = unname(co_iv["Estimate"]),
    iv_se       = unname(co_iv["Std. Error"]),
    iv_lo       = unname(ci_iv[1]),
    iv_hi       = unname(ci_iv[2]),
    fs_b        = unname(co_fs["Estimate"]),
    fs_se       = unname(co_fs["Std. Error"]),
    fs_F        = unname(F_stat),
    weak        = unname(F_stat) < WEAK_F,
    stringsAsFactors = FALSE
  )
}

## Five specifications -------------------------------------------------
results <- rbind(
  run_spec("Base (bivariate)",        d),
  run_spec("+ latitude",              d, controls = "lat_abst"),
  run_spec("+ continents (afr,asia)", d, controls = c("africa", "asia")),
  run_spec("Drop neo-Europes",        d[!d$shortnam %in% neo_europes, ]),
  run_spec("Africa only",             d[d$africa == 1, ])
)
rownames(results) <- NULL

## Console report ------------------------------------------------------
fmt <- function(x, k = 2) formatC(x, format = "f", digits = k)
cat("\n==== AJR IV: replicate & stress =====================================\n")
cat("2SLS engine: AER::ivreg  |  First-stage F: partial F on logem4 (car)\n")
cat("Weak-instrument flag: first-stage F <", WEAK_F, "\n\n")
report <- with(results, data.frame(
  Specification = spec,
  N             = n,
  OLS           = paste0(fmt(ols_b), " (", fmt(ols_se), ")"),
  `2SLS`        = paste0(fmt(iv_b), " (", fmt(iv_se), ")"),
  `1st-stage b` = paste0(fmt(fs_b), " (", fmt(fs_se), ")"),
  `1st-stage F` = fmt(fs_F, 1),
  Weak          = ifelse(weak, "WEAK", ""),
  check.names   = FALSE
))
print(report, row.names = FALSE)
cat("\n")

## Machine-readable dump (for independent verification) ----------------
write.csv(results, "results.csv", row.names = FALSE)

## ---------------------------------------------------------------------
## Optional figure: 2SLS point + 95% CI per spec, OLS as reference.
## Base graphics (no extra deps), Okabe-Ito, 300 dpi, no in-plot title.
## ---------------------------------------------------------------------
png("robustness-figure.png", width = 2000, height = 1300, res = 300)
op <- par(mar = c(4.2, 11, 1, 1))
k  <- nrow(results)
ys <- rev(seq_len(k))                       # spec 1 at top
xr <- range(c(results$iv_lo, results$iv_hi, results$ols_b, 0))
xr <- xr + c(-0.05, 0.05) * diff(xr)
cols <- ifelse(results$weak, col_weak, col_strong)

plot(NA, xlim = xr, ylim = c(0.5, k + 0.5), yaxt = "n", xlab = "",
     ylab = "", bty = "n")
abline(v = 0, col = okabe_ito[["grey"]], lty = 3)
# 2SLS CI whiskers + points
segments(results$iv_lo, ys, results$iv_hi, ys, col = cols, lwd = 2)
points(results$iv_b, ys, pch = 19, col = cols, cex = 1.2)
# OLS reference (open squares)
points(results$ols_b, ys, pch = 0, col = okabe_ito[["black"]], cex = 1.0)
axis(2, at = ys, labels = results$spec, las = 1, tick = FALSE)
mtext("Coefficient on avexpr (log GDP p.c.)", side = 1, line = 2.6, cex = 0.95)
legend("bottomright", bty = "n", cex = 0.8,
       legend = c("2SLS (strong 1st stage)", "2SLS (WEAK 1st stage)",
                  "OLS", "2SLS 95% CI"),
       pch = c(19, 19, 0, NA), lty = c(NA, NA, NA, 1),
       col = c(col_strong, col_weak, okabe_ito[["black"]], okabe_ito[["grey"]]))
par(op); invisible(dev.off())

cat("Wrote: results.csv, robustness-figure.png\n")
