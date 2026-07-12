#!/usr/bin/env Rscript
# =============================================================================
# Task H — Replicate and stress the AJR (2001) IV result (high-complexity tier)
# Run from this directory:  cd reference/high-ajr && Rscript script.R
#
# Finding replicated: settler mortality (logem4) instruments expropriation-risk
#   institutions (avexpr), which predict log GDP per capita (logpgp95).
#   Acemoglu, Johnson & Robinson (2001), "The Colonial Origins of Comparative
#   Development," AER 91(5). Base sample = 64 countries = ivdoctr::colonial.
#
# Deliverables written here: robustness-table.md
#   (The human-authored grading rubric lives in RUBRIC.md, written separately.)
#
# Estimation note: AER::ivreg is available in this environment, so all 2SLS
#   standard errors below are the CORRECT 2SLS SEs (ivreg accounts for the
#   generated first-stage regressor). If AER were absent, a manual two-stage
#   least squares (lm of avexpr~logem4, then lm of logpgp95 on fitted avexpr)
#   would recover the SAME point estimate but its second-stage OLS SEs would be
#   WRONG (they ignore first-stage estimation) and would have to be flagged as
#   approximate. We do not need that fallback here.
# =============================================================================

suppressPackageStartupMessages({
  library(ivdoctr)   # ships the `colonial` data (AJR base sample, 64 countries)
  library(AER)       # ivreg(): exact 2SLS with correct SEs
  library(car)       # linearHypothesis(): first-stage F on excluded instrument
})

stopifnot(requireNamespace("AER", quietly = TRUE))  # exact 2SLS SEs required

# This analysis is fully deterministic (OLS and analytical 2SLS have closed-form
# solutions; nothing is simulated or bootstrapped). set.seed() is set only to
# honor the house convention shared with the other briefs; it is not load-bearing.
set.seed(46)

# --- Data --------------------------------------------------------------------
data(colonial, package = "ivdoctr")
d <- as.data.frame(colonial)
NEO <- c("AUS", "CAN", "NZL", "USA")   # the four "neo-Europes" (rich4 == 1)

# --- Per-specification estimator ---------------------------------------------
# For each spec we report, on the SAME sample and control set:
#   * OLS  coefficient on avexpr           lm(logpgp95 ~ avexpr + controls)
#   * 2SLS coefficient on avexpr           ivreg(logpgp95 ~ avexpr + ctrl | logem4 + ctrl)
#   * first-stage coefficient on logem4    lm(avexpr ~ logem4 + controls)
#   * first-stage F on the EXCLUDED instrument logem4 (1 df, so F = t^2):
#         homoskedastic  -> Staiger-Stock rule-of-thumb number (threshold ~10)
#         robust (HC1)   -> reported alongside as a secondary check
run_spec <- function(label, dat, controls = character(0)) {
  rhs  <- paste(c("avexpr", controls), collapse = " + ")
  inst <- paste(c("logem4", controls), collapse = " + ")

  ols <- lm(as.formula(paste("logpgp95 ~", rhs)), data = dat)
  iv  <- ivreg(as.formula(paste("logpgp95 ~", rhs, "|", inst)), data = dat)
  fs  <- lm(as.formula(paste("avexpr ~", inst)), data = dat)

  b_ols <- coef(ols)["avexpr"]; se_ols <- sqrt(diag(vcov(ols)))["avexpr"]
  b_iv  <- coef(iv)["avexpr"];  se_iv  <- sqrt(diag(vcov(iv)))["avexpr"]
  b_fs  <- coef(fs)["logem4"];  se_fs  <- sqrt(diag(vcov(fs)))["logem4"]

  F_hom <- car::linearHypothesis(fs, "logem4 = 0")$F[2]
  F_rob <- car::linearHypothesis(fs, "logem4 = 0", white.adjust = "hc1")$F[2]

  data.frame(
    label = label, n = nrow(dat),
    b_ols = b_ols, se_ols = se_ols,
    b_iv  = b_iv,  se_iv  = se_iv,
    iv_lo = b_iv - 1.96 * se_iv, iv_hi = b_iv + 1.96 * se_iv,
    b_fs  = b_fs,  se_fs  = se_fs,
    F_hom = F_hom, F_rob = F_rob,
    row.names = NULL, stringsAsFactors = FALSE
  )
}

res <- rbind(
  run_spec("1. Baseline (bivariate)",        d),
  run_spec("2. + Latitude",                  d, "lat_abst"),
  run_spec("3. + Continent dummies",         d, c("africa", "asia")),
  run_spec("4. Drop neo-Europes",            d[!d$shortnam %in% NEO, ]),
  run_spec("5. Africa only",                 d[d$africa == 1, ])
)

# Weak-instrument verdict on the homoskedastic first-stage F (threshold ~10).
res$verdict <- ifelse(res$F_hom >= 10, "strong",
                ifelse(res$F_hom >= 5, "weak (F<10)", "collapsed (F<<10)"))

# Cross-check: AER's built-in weak-instrument diagnostic must equal our F_hom.
chk <- summary(ivreg(logpgp95 ~ avexpr | logem4, data = d),
               diagnostics = TRUE)$diagnostics["Weak instruments", "statistic"]
stopifnot(abs(chk - res$F_hom[1]) < 1e-6)

# --- Write robustness-table.md -----------------------------------------------
f2 <- function(x) sprintf("%.2f", x)
f3 <- function(x) sprintf("%.3f", x)
row_md <- function(r) sprintf(
  "| %s | %d | %s (%s) | %s (%s) | %s (%s) | %s | %s | %s |",
  r$label, r$n,
  f2(r$b_ols), f2(r$se_ols), f2(r$b_iv), f2(r$se_iv),
  f3(r$b_fs), f3(r$se_fs), f2(r$F_hom), f2(r$F_rob), r$verdict)

md <- c(
  "# Task H — Robustness table: replicate and stress the AJR (2001) IV result",
  "",
  "*Reference solution (answer key). Data: `ivdoctr::colonial` (64 countries, the",
  "AJR base sample). Outcome `logpgp95` (log PPP GDP p.c. 1995); endogenous",
  "regressor `avexpr` (avg. protection against expropriation risk); excluded",
  "instrument `logem4` (log settler mortality). 2SLS via `AER::ivreg` (exact SEs).",
  "R 4.5.1, AER, car. Coefficients on `avexpr` unless noted; SEs in parentheses.*",
  "",
  "## The unified table (both point estimates and first-stage F for every spec)",
  "",
  paste0("| Specification | n | OLS β (SE) | 2SLS β (SE) | First-stage ",
         "β on logem4 (SE) | First-stage F (hom.) | First-stage F (robust) | Instrument |"),
  "|---|---:|---|---|---|---:|---:|---|",
  row_md(res[1, ]), row_md(res[2, ]), row_md(res[3, ]),
  row_md(res[4, ]), row_md(res[5, ]),
  "",
  paste0("First-stage F is the test that the excluded instrument (`logem4`) has ",
         "no effect on `avexpr` (one restriction, so F = t²). The homoskedastic ",
         "F is the Staiger-Stock rule-of-thumb number (threshold ≈ 10) and is ",
         "the primary weak-instrument statistic here; the robust (HC1) F is a ",
         "secondary check. AER's built-in weak-instrument diagnostic equals the ",
         "homoskedastic F to machine precision."),
  "",
  "## 1. The headline replicates AJR exactly",
  "",
  sprintf(paste0("Baseline bivariate: OLS = **%s**, 2SLS = **%s**, first-stage ",
                 "coefficient on log settler mortality = **%s** (SE %s), ",
                 "first-stage F = **%s**. These match AJR (2001) Table 4, col. 1 ",
                 "(2SLS 0.94) and Table 2 (OLS 0.52). The 2SLS estimate is ~%.0f%% ",
                 "larger than OLS, the direction AJR emphasize: OLS *understates* ",
                 "the institutions effect (classical measurement error / ",
                 "reverse-causation attenuation the instrument corrects)."),
          f2(res$b_ols[1]), f2(res$b_iv[1]), f3(res$b_fs[1]), f3(res$se_fs[1]),
          f2(res$F_hom[1]), 100 * (res$b_iv[1] / res$b_ols[1] - 1)),
  "",
  "## 2. Adding controls: the headline survives",
  "",
  sprintf(paste0("Adding **latitude** (`lat_abst`) leaves 2SLS at **%s** and the ",
                 "instrument strong (F = %s > 10). Adding **continent dummies** ",
                 "(`africa`, `asia`) leaves 2SLS at **%s** (F = %s > 10). Across ",
                 "both, the coefficient stays in the 0.84-1.00 band, comfortably ",
                 "positive, and OLS stays near 0.43-0.47 -- the OLS/2SLS gap ",
                 "persists. The result is robust to these controls. (Under robust ",
                 "SEs the controlled first stages sit right at the 10 threshold, ",
                 "F ≈ 9.5 / 9.3 -- worth noting, not disqualifying.)"),
          f2(res$b_iv[2]), f2(res$F_hom[2]), f2(res$b_iv[3]), f2(res$F_hom[3])),
  "",
  "## 3. Restricting the sample: the instrument weakens, then collapses",
  "",
  sprintf(paste0("**Dropping the four neo-Europes** (AUS, CAN, NZL, USA) removes ",
                 "the low-mortality / high-GDP anchor points that carry much of ",
                 "the identifying variation. The first stage falls **below the ",
                 "rule-of-thumb** (F = %s < 10); 2SLS drifts up to %s (SE %s) and ",
                 "loses precision. The point estimate does not *overturn* the ",
                 "result -- it is simply less reliably pinned down."),
          f2(res$F_hom[4]), f2(res$b_iv[4]), f2(res$se_iv[4])),
  "",
  sprintf(paste0("**Restricting to Africa** (n = %d) collapses the instrument ",
                 "entirely: the first-stage coefficient is a near-zero %s (SE %s) ",
                 "and F = **%s** -- there is essentially no settler-mortality ",
                 "variation left to identify institutions. The resulting 2SLS of ",
                 "%s carries a standard error of %s (95%% CI [%s, %s]): a range so ",
                 "wide it is **uninformative**. This number is *not* evidence that ",
                 "the institutions effect is larger (or smaller) within Africa; a ",
                 "dead first stage yields a 2SLS ratio dominated by noise. It can ",
                 "neither confirm nor overturn the headline."),
          res$n[5], f3(res$b_fs[5]), f3(res$se_fs[5]), f2(res$F_hom[5]),
          f2(res$b_iv[5]), f2(res$se_iv[5]), f2(res$iv_lo[5]), f2(res$iv_hi[5])),
  "",
  "## 4. Verdict and claim ceiling",
  "",
  paste0("**Robust to controls, fragile to sample restriction.** The headline ",
         "survives latitude and continent controls essentially intact (2SLS ",
         "0.84-1.00, F > 10). It does *not* survive as an *identified* estimate ",
         "once the sample is restricted: dropping the neo-Europes pushes the ",
         "first stage below F = 10, and the Africa-only sample destroys it ",
         "(F = 0.30). The honest ceiling for a manuscript is therefore neither ",
         "\"confirmed / robust across the board\" nor \"overturned in restricted ",
         "samples\" -- both overclaim. The correct statement: the AJR estimate is ",
         "**robust to observable controls but rests on cross-continental ",
         "settler-mortality variation; within a single continent the instrument ",
         "is too weak to identify anything**, so restricted-sample 2SLS estimates ",
         "are uninformative rather than contradictory."),
  ""
)
writeLines(md, "robustness-table.md")

# --- Console echo ------------------------------------------------------------
cat("Task H complete. Wrote robustness-table.md\n\n")
cat(sprintf("%-26s %4s %8s %9s %11s %8s %8s  %s\n",
            "spec", "n", "OLS", "2SLS", "1st-stg", "F(hom)", "F(rob)", "instr"))
for (i in seq_len(nrow(res))) cat(sprintf(
  "%-26s %4d %8.3f %9.3f %11.3f %8.2f %8.2f  %s\n",
  res$label[i], res$n[i], res$b_ols[i], res$b_iv[i], res$b_fs[i],
  res$F_hom[i], res$F_rob[i], res$verdict[i]))
