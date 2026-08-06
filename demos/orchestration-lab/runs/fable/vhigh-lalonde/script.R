#!/usr/bin/env Rscript
## script.R
## VHIGH -- LaLonde NSW experiment vs. Dehejia-Wahba / Smith-Todd dispute.
## Does propensity-score matching on an observational composite (NSW treated +
## CPS controls) recover the experimental benchmark? We run a specification
## curve over two axes -- covariate set (demographics vs. + re74/re75) and
## estimator detail (1-NN matching, 1-NN with common-support trimming, PS
## stratification) -- and lay every estimate against the benchmark.
##
## Produces: spec-table.md and figures/spec-curve.png
## Self-contained: Rscript script.R

suppressPackageStartupMessages({
  library(causaldata)
  library(MatchIt)
  library(sandwich)
  library(lmtest)
  library(ggplot2)
})

## ---- Okabe-Ito colorblind-safe palette and theme (declared up top) -------

okabe_ito <- c(
  "#E69F00", "#56B4E9", "#009E73", "#F0E442",
  "#0072B2", "#D55E00", "#CC79A7", "#000000"
)

theme_report <- theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor    = element_blank(),
    plot.title           = element_blank(),
    plot.title.position  = "plot",
    axis.title           = element_text(size = 10),
    axis.text            = element_text(size = 9),
    legend.position      = "top",
    legend.title         = element_text(size = 9),
    legend.text          = element_text(size = 9)
  )
theme_set(theme_report)

## ---- Fixed seed (before anything stochastic) ------------------------------

set.seed(20260717)

dir.create("figures", showWarnings = FALSE)
fail <- function(...) stop(sprintf(...), call. = FALSE)

## ---- Data (exact loading spec) --------------------------------------------

nsw <- causaldata::nsw_mixtape   # 445 = 185 treated + 260 control (experimental)
cps <- causaldata::cps_mixtape   # 15,992 CPS observational controls
z    <- 1.959964                 # 95% normal critical value

if (nrow(nsw) != 445L) fail("Expected 445 NSW rows; found %d.", nrow(nsw))
if (sum(nsw$treat == 1) != 185L || sum(nsw$treat == 0) != 260L) {
  fail("NSW treat/control split does not match 185/260.")
}
if (nrow(cps) != 15992L) fail("Expected 15,992 CPS rows; found %d.", nrow(cps))
if (any(cps$treat != 0)) fail("CPS comparison file should be all-control.")

## ============================================================================
## 1. EXPERIMENTAL BENCHMARK  (treated - control within the NSW experiment)
## ============================================================================

bench_fit <- lm(re78 ~ treat, data = nsw)
bench_est <- unname(coef(bench_fit)["treat"])
bench_se  <- sqrt(vcovHC(bench_fit, type = "HC2")["treat", "treat"])
bench_lo  <- bench_est - z * bench_se
bench_hi  <- bench_est + z * bench_se

## ============================================================================
## 2. OBSERVATIONAL COMPOSITE  (NSW treated + CPS controls)
## ============================================================================

comp <- rbind(subset(nsw, treat == 1), cps)   # treat: NSW-treated=1, CPS=0

## ---- 2a. Naive raw difference (no adjustment) -----------------------------

naive_fit <- lm(re78 ~ treat, data = comp)
naive_est <- unname(coef(naive_fit)["treat"])
naive_se  <- sqrt(vcovHC(naive_fit, type = "HC2")["treat", "treat"])
naive_lo  <- naive_est - z * naive_se
naive_hi  <- naive_est + z * naive_se

## ---- Covariate sets (axis 1) -----------------------------------------------

f_demog <- treat ~ age + educ + black + hisp + marr + nodegree
f_earn  <- treat ~ age + educ + black + hisp + marr + nodegree + re74 + re75

## ---- 2b(i). 1-NN PS matching, ATT, with replacement (axis 2: estimator) ---
## SE: Abadie-Imbens (2008) show the ordinary nonparametric bootstrap is
## invalid for NN-matching variances, and the exact Abadie-Imbens (2006)
## analytic matching variance lives in the `Matching` package, which is not
## installed. As the defensible MatchIt-only substitute, we fit the outcome on
## the pair-expanded matched data and take a cluster-robust SE, clustering on
## the matched pair (subclass) AND the original unit id -- the latter accounts
## for control units reused across matches under replacement (Greifer,
## MatchIt vignette "Estimating Effects After Matching"). This is a
## design-based APPROXIMATION to the AI variance, not the AI estimator itself.

est_nn <- function(formula, data, trim) {
  m <- matchit(formula, data = data, method = "nearest", distance = "glm",
               link = "logit", estimand = "ATT", replace = TRUE,
               discard = if (trim) "both" else "none")
  gm  <- get_matches(m, id = "matched_unit")
  fit <- lm(re78 ~ treat, data = gm, weights = weights)
  V   <- vcovCL(fit, cluster = ~ subclass + matched_unit)
  est <- unname(coef(fit)["treat"])
  se  <- sqrt(V["treat", "treat"])
  n_t <- sum(m$treat == 1 & m$weights > 0)
  list(est = est, se = se, lo = est - z * se, hi = est + z * se, n_treat = n_t)
}

## ---- 2b(ii). Simple PS stratification, ATT --------------------------------
## Subclassify on quintiles of the estimated propensity score (5 strata, the
## conventional Rosenbaum-Rubin / Dehejia-Wahba default). Standard errors are
## ordinary heteroskedasticity-robust (HC1) on the post-stratification OLS
## with strata fixed effects: unlike 1-NN-with-replacement, subclassification
## assigns each unit to exactly one stratum, so no unit is reused as a
## repeated match and no matched-pair clustering correction is needed.

est_strat <- function(formula, data, nstrata = 5) {
  m  <- matchit(formula, data = data, method = "subclass",
                estimand = "ATT", subclass = nstrata)
  md <- match.data(m)
  fit <- lm(re78 ~ treat + factor(subclass), data = md, weights = weights)
  se  <- sqrt(vcovHC(fit, type = "HC1")["treat", "treat"])
  est <- unname(coef(fit)["treat"])
  list(est = est, se = se, lo = est - z * se, hi = est + z * se)
}

r1 <- est_nn(f_demog, comp, trim = FALSE)
r2 <- est_nn(f_demog, comp, trim = TRUE)
r3 <- est_nn(f_earn,  comp, trim = FALSE)
r4 <- est_nn(f_earn,  comp, trim = TRUE)
r5 <- est_strat(f_demog, comp)
r6 <- est_strat(f_earn,  comp)

specs <- data.frame(
  covariates = c("Demographics", "Demographics", "Demographics",
                 "+ re74/re75", "+ re74/re75", "+ re74/re75"),
  estimator  = c("1-NN", "1-NN + trim", "Stratify (5)",
                 "1-NN", "1-NN + trim", "Stratify (5)"),
  estimate   = c(r1$est, r2$est, r5$est, r3$est, r4$est, r6$est),
  se         = c(r1$se,  r2$se,  r5$se,  r3$se,  r4$se,  r6$se),
  lo         = c(r1$lo,  r2$lo,  r5$lo,  r3$lo,  r4$lo,  r6$lo),
  hi         = c(r1$hi,  r2$hi,  r5$hi,  r3$hi,  r4$hi,  r6$hi)
)
specs$gap    <- specs$estimate - bench_est
specs$covers <- specs$lo <= bench_est & specs$hi >= bench_est
specs$spec_label <- paste(specs$covariates, "|", specs$estimator)
specs$spec_label <- factor(specs$spec_label, levels = rev(specs$spec_label))

## ============================================================================
## 3. FIGURE -- spec curve: estimates + 95% CI vs. benchmark reference line
## ============================================================================

p <- ggplot(specs, aes(x = estimate, y = spec_label, color = covariates)) +
  geom_vline(xintercept = bench_est, linetype = "dashed",
             color = okabe_ito[8], linewidth = 0.6) +
  geom_vline(xintercept = 0, color = "grey80", linewidth = 0.4) +
  geom_pointrange(aes(xmin = lo, xmax = hi), linewidth = 0.7, size = 0.55,
                  position = position_dodge(width = 0)) +
  scale_color_manual(values = c("Demographics" = okabe_ito[6],
                                 "+ re74/re75"  = okabe_ito[5])) +
  scale_x_continuous(expand = expansion(mult = c(0.05, 0.32))) +
  labs(x = "Estimated effect on 1978 earnings ($)", y = NULL,
       color = "Covariate set") +
  annotate("text", x = bench_est, y = 6.45,
           label = sprintf("Experimental benchmark: $%s", format(round(bench_est), big.mark = ",")),
           hjust = 0, vjust = 0, size = 3.2, color = okabe_ito[8])

ggsave("figures/spec-curve.png", p, width = 8, height = 4.5, dpi = 320)

## ============================================================================
## 4. SPEC TABLE
## ============================================================================

fmt <- function(x) format(round(x), big.mark = ",")

tbl_lines <- c(
  "# Specification table -- does PS matching recover the LaLonde benchmark?",
  "",
  sprintf("**Experimental benchmark** (NSW treated - control on `re78`): **%s** (95%% CI [%s, %s]).",
          fmt(bench_est), fmt(bench_lo), fmt(bench_hi)),
  "",
  sprintf("**Naive observational** (NSW treated - CPS controls, no adjustment): **%s** (95%% CI [%s, %s]).",
          fmt(naive_est), fmt(naive_lo), fmt(naive_hi)),
  "",
  "Composite = 185 NSW treated + 15,992 CPS controls. ATT estimand throughout.",
  "Gap = estimate - benchmark; \"recovers\" means the 95% CI covers the benchmark point.",
  "",
  "| Covariate set | Estimator | Estimate | 95% CI | Gap vs. benchmark | Benchmark | Covers? |",
  "|---|---|---:|---|---:|---:|:---:|"
)
for (i in seq_len(nrow(specs))) {
  s <- specs[i, ]
  tbl_lines <- c(tbl_lines, sprintf(
    "| %s | %s | %s | [%s, %s] | %s | %s | %s |",
    s$covariates, s$estimator, fmt(s$estimate), fmt(s$lo), fmt(s$hi),
    fmt(s$gap), fmt(bench_est), if (s$covers) "yes" else "no"
  ))
}
tbl_lines <- c(tbl_lines, "",
  "**Standard errors.** Benchmark and naive: HC2 heteroskedasticity-robust.",
  "1-NN matching (with replacement): cluster-robust on matched pair and reused",
  "unit id -- a design-based *approximation* to the Abadie-Imbens (2006) analytic",
  "matching variance (the exact estimator lives in `Matching`, not installed);",
  "the nonparametric bootstrap is ruled out, being invalid for nearest-neighbour",
  "matching variances (Abadie & Imbens 2008). Stratification: HC1-robust SE on",
  "post-stratification OLS with strata fixed effects (no repeated-match reuse,",
  "so ordinary robust SEs are appropriate)."
)
writeLines(tbl_lines, "spec-table.md")

## ---- Console summary for verification -------------------------------------

cat(sprintf("Benchmark: %.1f [%.1f, %.1f]\n", bench_est, bench_lo, bench_hi))
cat(sprintf("Naive observational: %.1f [%.1f, %.1f] (gap %.1f)\n",
            naive_est, naive_lo, naive_hi, naive_est - bench_est))
cat("Specifications:\n")
print(specs[, c("covariates", "estimator", "estimate", "lo", "hi", "gap", "covers")],
      row.names = FALSE)
