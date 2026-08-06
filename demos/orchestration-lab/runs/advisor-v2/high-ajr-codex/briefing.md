=== ORIGINAL BRIEF ===
# Task H — Replicate and stress a famous IV result (high-complexity tier)

You are working in a project directory. Use R (`Rscript`); the `ivdoctr`, `AER`, and `car` packages are installed.

**Data.** Acemoglu, Johnson & Robinson (2001), *The Colonial Origins of Comparative Development*. The base sample ships with `ivdoctr`:

```r
library(ivdoctr)
data(colonial, package = "ivdoctr")   # 64 countries, AJR base sample
```

Key columns: `logpgp95` (log PPP GDP per capita, 1995 — the outcome); `avexpr` (average protection against expropriation risk — the institutions measure, endogenous); `logem4` (log settler mortality — the excluded instrument); `lat_abst` (absolute latitude / 90); `africa`, `asia` (continent dummies); `shortnam` (three-letter country code); `rich4` (= 1 for the four "neo-Europes").

**Background.** A manuscript uses these data to replicate AJR's headline: settler mortality instruments expropriation-risk institutions, which in turn predict long-run income. Structurally, `logpgp95 ~ avexpr`, with `avexpr` instrumented by `logem4`. The paper reports a 2SLS coefficient far above its OLS counterpart and treats the finding as established. Your job is to reproduce that headline and then find out how much weight it will bear.

**Task.**

1. **Replicate the headline.** Estimate the bivariate 2SLS coefficient of `logpgp95` on `avexpr` instrumented by `logem4`, and its OLS counterpart on the same sample. Report the first stage (the coefficient of `avexpr` on `logem4`).
2. **Stress the result** with four perturbations, each re-estimating OLS and 2SLS on the same sample/controls: (a) add latitude (`lat_abst`); (b) add continent controls (`africa`, `asia`); (c) drop the neo-Europes (`AUS`, `CAN`, `NZL`, `USA`, by `shortnam`); (d) restrict to Africa only (`africa == 1`).
3. **Report first-stage strength per specification** — the first-stage F on the excluded instrument — and **flag any specification where the instrument is weak** (rule of thumb: F below ~10). Do not report a 2SLS point estimate as if it were reliable when its first stage is weak.
4. **Deliverables** (see below): a script, a robustness table, and a short memo stating what survives the stress tests and what the paper is entitled to claim.

**Produce, in the current working directory:**

1. `script.R` — one self-contained script; conventions as in the other briefs (packages and any palette/theme declared at the top; `set.seed()` before anything stochastic — note that OLS/2SLS here are deterministic). If you produce a figure it is optional; follow house figure conventions if you do (Okabe-Ito palette, 300+ dpi, no in-plot title).
2. `robustness-table.md` — **one** table reporting, for every specification, the OLS estimate, the 2SLS estimate, and the first-stage F (with the first-stage coefficient), so all specs are comparable at a glance. Note which specs are weakly identified.
3. `memo.md` — roughly 400 words: state what survives the stress tests and what does not, and say precisely what the manuscript may and may not claim on this evidence. Do not overclaim in either direction — a specification whose instrument has collapsed does not confirm the result, and it does not overturn it either.

**Constraints.** At most one revision cycle. If your mode delegates, use at most 3 delegations. No web access. Do not install packages. For 2SLS use `AER::ivreg` if it is available; otherwise estimate explicit two-stage least squares via two `lm` stages and note that the second-stage standard errors are approximate (uncorrected for the generated regressor). Say which path you took.

=== PRODUCED DELIVERABLES ===
--- robustness-table.md ---
# Robustness of the AJR institutions–income IV estimate

| Specification | N | OLS: avexpr | 2SLS: avexpr | First-stage: logem4 | First-stage F | Identification |
|:--|--:|--:|--:|--:|--:|:--|
| Bivariate | 64 | 0.522 | 0.944 | -0.607 | 22.95 | Not weak by F >= 10 rule |
| Add latitude | 64 | 0.468 | 0.996 | -0.510 | 13.09 | Not weak by F >= 10 rule |
| Add continent controls | 64 | 0.434 | 0.839 | -0.533 | 11.01 | Not weak by F >= 10 rule |
| Drop neo-Europes | 60 | 0.487 | 1.281 | -0.391 | 8.65 | Weak (F < 10) |
| Africa only | 27 | 0.302 | 2.400 | -0.108 | 0.30 | Weak (F < 10) |

Notes: The outcome is log PPP GDP per capita in 1995 (`logpgp95`). OLS and 2SLS use the same complete-case analytic sample within each row. The structural regressor is institutions (`avexpr`); the excluded instrument is log settler mortality (`logem4`). The first-stage F is the one-degree-of-freedom partial F test of the excluded instrument conditional on the listed controls. `F < 10` is flagged as weak identification; 2SLS point estimates in those rows should not be interpreted as reliable. `Add latitude` controls for `lat_abst`; `Add continent controls` controls for `africa` and `asia`; the neo-Europe restriction removes AUS, CAN, NZL, and USA. 2SLS is estimated with `AER::ivreg`.

--- script.R ---
# Replication and robustness checks for Acemoglu, Johnson, and Robinson (2001)
# Data: ivdoctr::colonial (AJR base sample, 64 countries)

# Packages ---------------------------------------------------------------
library(ivdoctr)
library(car)

# This analysis is deterministic; the seed is declared for reproducibility.
set.seed(20260719)

# No figure is produced, so no palette or graphical theme is required.

# Data -------------------------------------------------------------------
data(colonial, package = "ivdoctr")
colonial <- as.data.frame(colonial)

neo_europes <- c("AUS", "CAN", "NZL", "USA")

# Estimate OLS, 2SLS, and the first stage on one common analytic sample.
# The reported F statistic is the partial first-stage F test of logem4 = 0,
# conditional on the controls in that specification.
estimate_specification <- function(name, controls = character(), keep) {
  variables <- c("logpgp95", "avexpr", "logem4", controls)
  dat <- colonial[keep(colonial), variables, drop = FALSE]
  dat <- dat[stats::complete.cases(dat), , drop = FALSE]

  ols_formula <- stats::reformulate(c("avexpr", controls), response = "logpgp95")
  first_stage_formula <- stats::reformulate(c("logem4", controls), response = "avexpr")
  ols <- stats::lm(ols_formula, data = dat)
  first_stage <- stats::lm(first_stage_formula, data = dat)

  if (requireNamespace("AER", quietly = TRUE)) {
    structural_rhs <- paste(c("avexpr", controls), collapse = " + ")
    instrument_rhs <- paste(c("logem4", controls), collapse = " + ")
    iv_formula <- stats::as.formula(
      paste("logpgp95 ~", structural_rhs, "|", instrument_rhs)
    )
    iv <- AER::ivreg(iv_formula, data = dat)
    iv_estimate <- stats::coef(iv)["avexpr"]
    iv_method <- "AER::ivreg"
  } else {
    # Exact 2SLS point estimates; second-stage SEs would be uncorrected for
    # the generated regressor, so this fallback does not report them.
    stage2_dat <- dat
    stage2_dat$fitted_avexpr <- stats::fitted(first_stage)
    stage2_formula <- stats::reformulate(
      c("fitted_avexpr", controls), response = "logpgp95"
    )
    iv <- stats::lm(stage2_formula, data = stage2_dat)
    iv_estimate <- stats::coef(iv)["fitted_avexpr"]
    iv_method <- "explicit two-stage least squares (SEs would be approximate)"
  }

  first_stage_test <- car::linearHypothesis(
    first_stage, "logem4 = 0", test = "F"
  )
  first_stage_f <- first_stage_test[2, "F"]

  data.frame(
    specification = name,
    n = nrow(dat),
    ols = unname(stats::coef(ols)["avexpr"]),
    iv = unname(iv_estimate),
    first_stage_coefficient = unname(stats::coef(first_stage)["logem4"]),
    first_stage_f = unname(first_stage_f),
    identification = ifelse(first_stage_f < 10, "Weak (F < 10)", "Not weak by F >= 10 rule"),
    iv_method = iv_method,
    stringsAsFactors = FALSE
  )
}

results <- do.call(
  rbind,
  list(
    estimate_specification(
      "Bivariate", keep = function(dat) rep(TRUE, nrow(dat))
    ),
    estimate_specification(
      "Add latitude", controls = "lat_abst",
      keep = function(dat) rep(TRUE, nrow(dat))
    ),
    estimate_specification(
      "Add continent controls", controls = c("africa", "asia"),
      keep = function(dat) rep(TRUE, nrow(dat))
    ),
    estimate_specification(
      "Drop neo-Europes", keep = function(dat) !dat$shortnam %in% neo_europes
    ),
    estimate_specification(
      "Africa only", keep = function(dat) dat$africa == 1
    )
  )
)

# Robustness table -------------------------------------------------------
table_rows <- vapply(seq_len(nrow(results)), function(i) {
  row <- results[i, ]
  sprintf(
    "| %s | %d | %.3f | %.3f | %.3f | %.2f | %s |",
    row$specification, row$n, row$ols, row$iv,
    row$first_stage_coefficient, row$first_stage_f, row$identification
  )
}, character(1))

table_note <- if (identical(results$iv_method[1], "AER::ivreg")) {
  "2SLS is estimated with `AER::ivreg`."
} else {
  "2SLS uses explicit first and second stages; its second-stage standard errors would be approximate."
}

table_lines <- c(
  "# Robustness of the AJR institutions–income IV estimate",
  "",
  "| Specification | N | OLS: avexpr | 2SLS: avexpr | First-stage: logem4 | First-stage F | Identification |",
  "|:--|--:|--:|--:|--:|--:|:--|",
  table_rows,
  "",
  paste0(
    "Notes: The outcome is log PPP GDP per capita in 1995 (`logpgp95`). ",
    "OLS and 2SLS use the same complete-case analytic sample within each row. ",
    "The structural regressor is institutions (`avexpr`); the excluded instrument is ",
    "log settler mortality (`logem4`). The first-stage F is the one-degree-of-freedom ",
    "partial F test of the excluded instrument conditional on the listed controls. ",
    "`F < 10` is flagged as weak identification; 2SLS point estimates in those rows ",
    "should not be interpreted as reliable. `Add latitude` controls for `lat_abst`; ",
    "`Add continent controls` controls for `africa` and `asia`; the neo-Europe restriction ",
    "removes AUS, CAN, NZL, and USA. ", table_note
  )
)

writeLines(table_lines, "robustness-table.md")

print(results[, c(
  "specification", "n", "ols", "iv", "first_stage_coefficient",
  "first_stage_f", "identification"
)])
message("Wrote robustness-table.md")

=== QUESTION ===
This is a completed submission against the brief above. What would you change?
