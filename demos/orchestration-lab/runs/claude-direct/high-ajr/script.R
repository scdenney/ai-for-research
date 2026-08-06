#!/usr/bin/env Rscript
# =============================================================================
# Task H — Replicate and stress the AJR (2001) IV result (high-complexity tier)
# Run from this directory: cd runs/claude-direct/high-ajr && Rscript script.R
#
# Structural model: logpgp95 ~ avexpr, avexpr instrumented by logem4.
# Base sample: ivdoctr::colonial, 64 countries (Acemoglu, Johnson & Robinson
# 2001, "The Colonial Origins of Comparative Development," AER 91(5)).
#
# 2SLS path: AER::ivreg is available in this environment, so all 2SLS standard
# errors below are the exact 2SLS SEs (ivreg accounts for the generated
# first-stage regressor) -- the manual two-lm fallback described in the brief
# is not needed here.
#
# First-stage strength: the partial F on the excluded instrument (logem4),
# via car::linearHypothesis on the first-stage lm, so it is correct with or
# without exogenous controls. Homoskedastic F is the number of record
# (Staiger-Stock rule of thumb, threshold ~10); robust (HC1) F is reported as
# a secondary check.
#
# OLS and 2SLS here are deterministic (closed-form); set.seed() is declared
# only to honor the house convention shared with the other briefs.
# =============================================================================

suppressPackageStartupMessages({
  library(ivdoctr)  # ships `colonial`: the AJR base sample, 64 countries
  library(AER)      # ivreg(): exact 2SLS with correct SEs
  library(car)      # linearHypothesis(): first-stage F on excluded instrument
})

set.seed(46)

# Okabe-Ito colour-blind-safe palette (house figure convention) --------------
okabe_ito <- c(
  black = "#000000", orange = "#E69F00", skyblue = "#56B4E9",
  green = "#009E73", yellow = "#F0E442", blue = "#0072B2",
  vermillion = "#D55E00", purple = "#CC79A7", grey = "#999999"
)
COL_STRONG <- okabe_ito[["blue"]]
COL_WEAK   <- okabe_ito[["vermillion"]]

WEAK_F <- 10  # first-stage F rule-of-thumb threshold

# --- Data --------------------------------------------------------------------
data(colonial, package = "ivdoctr")
d <- as.data.frame(colonial)
stopifnot(nrow(d) == 64)
NEO <- c("AUS", "CAN", "NZL", "USA")  # the four "neo-Europes"

# --- Per-specification estimator --------------------------------------------
# Exogenous controls, when present, are added to BOTH the structural equation
# and the first stage/instrument set (they are their own instruments) -- not
# to the second stage alone, which would give the wrong 2SLS coefficient.
run_spec <- function(label, dat, controls = character(0)) {
  vars <- c("logpgp95", "avexpr", "logem4", controls)
  dat  <- dat[stats::complete.cases(dat[, vars, drop = FALSE]), ]

  ctrl_rhs <- if (length(controls)) paste("+", paste(controls, collapse = " + ")) else ""
  f_ols <- as.formula(paste0("logpgp95 ~ avexpr", ctrl_rhs))
  f_iv  <- as.formula(paste0("logpgp95 ~ avexpr", ctrl_rhs, " | logem4", ctrl_rhs))
  f_fs  <- as.formula(paste0("avexpr ~ logem4", ctrl_rhs))

  m_ols <- lm(f_ols, data = dat)
  m_iv  <- AER::ivreg(f_iv, data = dat)
  m_fs  <- lm(f_fs, data = dat)

  b_ols <- coef(m_ols)["avexpr"];  se_ols <- sqrt(diag(vcov(m_ols)))["avexpr"]
  b_iv  <- coef(m_iv)["avexpr"];   se_iv  <- sqrt(diag(vcov(m_iv)))["avexpr"]
  b_fs  <- coef(m_fs)["logem4"];   se_fs  <- sqrt(diag(vcov(m_fs)))["logem4"]
  ci_iv <- confint(m_iv)["avexpr", ]

  F_hom <- car::linearHypothesis(m_fs, "logem4 = 0")$F[2]
  F_rob <- car::linearHypothesis(m_fs, "logem4 = 0", white.adjust = "hc1")$F[2]

  data.frame(
    spec = label, n = nrow(dat),
    b_ols = unname(b_ols), se_ols = unname(se_ols),
    b_iv = unname(b_iv), se_iv = unname(se_iv),
    iv_lo = unname(ci_iv[1]), iv_hi = unname(ci_iv[2]),
    b_fs = unname(b_fs), se_fs = unname(se_fs),
    F_hom = F_hom, F_rob = F_rob,
    weak = F_hom < WEAK_F,
    stringsAsFactors = FALSE
  )
}

res <- rbind(
  run_spec("1. Baseline (bivariate)",     d),
  run_spec("2. + Latitude",               d, "lat_abst"),
  run_spec("3. + Continent (africa,asia)", d, c("africa", "asia")),
  run_spec("4. Drop neo-Europes",         d[!d$shortnam %in% NEO, ]),
  run_spec("5. Africa only",              d[d$africa == 1, ])
)
rownames(res) <- NULL
res$verdict <- ifelse(res$F_hom >= WEAK_F, "strong",
                ifelse(res$F_hom >= 1, "weak (F<10)", "collapsed"))

# Cross-check against AER's own weak-instrument diagnostic for the baseline.
chk <- summary(ivreg(logpgp95 ~ avexpr | logem4, data = d),
               diagnostics = TRUE)$diagnostics["Weak instruments", "statistic"]
stopifnot(abs(chk - res$F_hom[1]) < 1e-6)

# --- Console report ----------------------------------------------------------
fmt <- function(x, k = 2) formatC(x, format = "f", digits = k)
cat("\n==== Task H: AJR IV replication and stress =================================\n")
cat("2SLS engine: AER::ivreg (exact SEs). First-stage F: partial F on logem4 (car).\n")
cat("Weak-instrument rule of thumb: F <", WEAK_F, "\n\n")
print(with(res, data.frame(
  Specification = spec, N = n,
  OLS = paste0(fmt(b_ols), " (", fmt(se_ols), ")"),
  `2SLS` = paste0(fmt(b_iv), " (", fmt(se_iv), ")"),
  `1st-stage b` = paste0(fmt(b_fs, 3), " (", fmt(se_fs, 3), ")"),
  `F (hom)` = fmt(F_hom), `F (robust)` = fmt(F_rob), Verdict = verdict,
  check.names = FALSE
)), row.names = FALSE)
cat("\n")

# --- Write robustness-table.md -----------------------------------------------
f2 <- function(x) sprintf("%.2f", x)
f3 <- function(x) sprintf("%.3f", x)
row_md <- function(r) sprintf(
  "| %s | %d | %s (%s) | %s (%s) | %s (%s) | %s | %s | %s |",
  r$spec, r$n,
  f2(r$b_ols), f2(r$se_ols), f2(r$b_iv), f2(r$se_iv),
  f3(r$b_fs), f3(r$se_fs), f2(r$F_hom), f2(r$F_rob), r$verdict)

md <- c(
  "# Task H — Robustness table: replicate and stress the AJR (2001) IV result",
  "",
  "*Data: `ivdoctr::colonial` (64-country AJR base sample). Outcome `logpgp95`",
  "(log PPP GDP p.c., 1995); endogenous regressor `avexpr` (avg. protection",
  "against expropriation risk); excluded instrument `logem4` (log settler",
  "mortality). 2SLS via `AER::ivreg` (exact SEs, not the naive two-`lm`",
  "approximation). Coefficients are on `avexpr`; SEs in parentheses. First-stage",
  "F is the partial F on `logem4` (`car::linearHypothesis`), homoskedastic",
  "unless noted -- the Staiger-Stock rule of thumb (threshold ~10) is the",
  "primary weak-instrument statistic; robust (HC1) F is a secondary check.*",
  "",
  paste0("| Specification | n | OLS β (SE) | 2SLS β (SE) | First-stage β on ",
         "logem4 (SE) | F (hom.) | F (robust) | Instrument |"),
  "|---|---:|---|---|---|---:|---:|---|",
  row_md(res[1, ]), row_md(res[2, ]), row_md(res[3, ]),
  row_md(res[4, ]), row_md(res[5, ]),
  "",
  "**Verdict.** The headline (2SLS ~0.94 vs. OLS ~0.52, first stage F~23) is",
  "**robust to observable controls**: adding latitude or continent dummies",
  "leaves 2SLS in the 0.84-1.00 band with the instrument still strong (F>10).",
  "It is **fragile to sample restriction**: dropping the four neo-Europes",
  "pushes the first-stage F just below the rule-of-thumb (8.65), and",
  "restricting to Africa collapses the first stage entirely (F=0.30, first-",
  "stage coefficient near zero). The resulting Africa-only 2SLS of 2.40 is a",
  "noise-dominated ratio from a dead first stage, not evidence of a larger",
  "effect within Africa -- and the drop-neo-Europes estimate of 1.28 rests on",
  "an instrument already below threshold. Neither restricted-sample number",
  "should be read as confirming, overturning, or resizing the AJR headline."
)
writeLines(md, "robustness-table.md")
cat("Wrote robustness-table.md\n")

# --- Optional figure: 2SLS point + 95% CI per spec, OLS as reference marker -
png("robustness-figure.png", width = 2000, height = 1300, res = 300)
op <- par(mar = c(4.2, 12, 1, 1))
k  <- nrow(res)
ys <- rev(seq_len(k))
xr <- range(c(res$iv_lo, res$iv_hi, res$b_ols, 0))
xr <- xr + c(-0.05, 0.05) * diff(xr)
col <- ifelse(res$weak, COL_WEAK, COL_STRONG)

plot(NA, xlim = xr, ylim = c(0.5, k + 0.5), yaxt = "n", xlab = "", ylab = "", bty = "n")
abline(v = 0, col = okabe_ito[["grey"]], lty = 3)
segments(res$iv_lo, ys, res$iv_hi, ys, col = col, lwd = 2)
points(res$b_iv, ys, pch = 19, col = col, cex = 1.2)
points(res$b_ols, ys, pch = 0, col = okabe_ito[["black"]], cex = 1.0)
axis(2, at = ys, labels = res$spec, las = 1, tick = FALSE, cex.axis = 0.85)
mtext("Coefficient on avexpr (log GDP p.c.)", side = 1, line = 2.6, cex = 0.95)
legend("bottomright", bty = "n", cex = 0.75,
       legend = c("2SLS (F >= 10)", "2SLS (F < 10)", "OLS", "2SLS 95% CI"),
       pch = c(19, 19, 0, NA), lty = c(NA, NA, NA, 1),
       col = c(COL_STRONG, COL_WEAK, okabe_ito[["black"]], okabe_ito[["grey"]]))
par(op); invisible(dev.off())
cat("Wrote robustness-figure.png\n")

write.csv(res, "results.csv", row.names = FALSE)
cat("Wrote results.csv\n")
