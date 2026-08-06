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
--- memo.md ---
# Memo: what the AJR base-sample stress tests support

The packaged 64-country AJR base sample reproduces the headline contrast. In the bivariate model, the OLS association between protection against expropriation and log GDP per capita is 0.522. Instrumenting protection with log settler mortality raises the 2SLS estimate to 0.944. The first stage has the expected negative sign: a one-unit increase in log settler mortality predicts a 0.607-unit reduction in the protection measure, with a partial excluded-instrument F statistic of 22.95. Thus, within this particular bivariate cross-country specification, the famous result is reproducible and the instrument clears the conventional F-about-10 screening rule.

The main finding also survives two modest changes in covariate adjustment. With absolute latitude included, the 2SLS coefficient is 0.996 and the first-stage F is 13.09. With Africa and Asia indicators included, the 2SLS coefficient is 0.839 and the first-stage F is 11.01. The estimates remain positive, appreciably larger than their corresponding OLS estimates (0.468 and 0.434), and the first stage remains above the stated threshold. Still, the continent-adjusted first stage is close enough to 10 to warrant more caution than the bivariate model.

The sample perturbations are more revealing. Removing Australia, Canada, New Zealand, and the United States produces a 2SLS point estimate of 1.281, but the first-stage F falls to 8.65. On the requested rule of thumb this is weak identification, so the larger coefficient cannot be presented as a reliable confirmation that the effect strengthens without the neo-Europes. It also does not refute the original result: weak identification makes the IV estimate uninformative for that comparison. In the Africa-only sample, the first stage essentially disappears (coefficient -0.108; F=0.30). Its 2SLS estimate, 2.400, has a conventional standard error of 3.987 and is not credible evidence for a large African effect. The positive OLS association in Africa (0.302) is a different, non-causal estimand and does not repair the failed instrument.

The manuscript may claim a reproducible, positive IV association in the AJR base sample that is retained after adding latitude or broad continent controls, conditional on the IV exclusion restriction. It may report that the IV estimate exceeds OLS in those identified specifications. It may not describe the relationship as established across regional or non-neo-European samples, infer a precise Africa-specific causal effect, or use the weakly identified estimates as corroboration. More fundamentally, first-stage strength addresses relevance, not the exclusion restriction: these regressions alone do not establish that settler mortality affects 1995 income only through institutions. The appropriate conclusion is therefore limited external robustness for the base-sample IV pattern, alongside meaningful fragility in where the instrument has usable variation.

--- robustness-table.md ---
# AJR base-sample robustness checks

All models use `ivdoctr::colonial` and `AER::ivreg` for 2SLS. The first-stage F is the partial nested-model F test for the excluded instrument, `logem4`, conditional on the controls shown. “Weak” uses the stated rule of thumb, F < 10. Coefficients are in log-income units per one-unit change in expropriation protection.

| Specification | N | OLS: `avexpr` | 2SLS: `avexpr` | First-stage `logem4` coefficient | First-stage F | Identification flag |
|---|---:|---:|---:|---:|---:|---|
| Headline: no controls | 64 | 0.522 | 0.944 | -0.607 | 22.947 | Not weak |
| Add latitude | 64 | 0.468 | 0.996 | -0.510 | 13.093 | Not weak |
| Add continent controls | 64 | 0.434 | 0.839 | -0.533 | 11.006 | Not weak (borderline) |
| Drop neo-Europes | 60 | 0.487 | 1.281 | -0.391 | 8.646 | **Weak** |
| Africa only | 27 | 0.302 | 2.400 | -0.108 | 0.298 | **Weak** |

The Africa-only 2SLS estimate is extremely imprecise (conventional SE 3.987) and should not be interpreted as evidence of a large effect. The drop-neo-Europe estimate is also weakly identified under the requested threshold.

--- script.R ---
# Replication and robustness checks for AJR (2001), using ivdoctr's base sample.
# 2SLS is estimated with AER::ivreg, which reports conventional IV standard errors.

set.seed(20260717) # No stochastic steps are used; set for project convention.

suppressPackageStartupMessages({
  library(ivdoctr)
  library(AER)
})

data(colonial, package = "ivdoctr")
colonial <- as.data.frame(colonial) # The packaged object may be a data.table.

# Each specification uses complete cases on its outcome, endogenous regressor,
# excluded instrument, and included controls.  These are 64 observations except
# where the indicated sample restriction applies.
specifications <- list(
  "Headline" = list(
    keep = rep(TRUE, nrow(colonial)), controls = character(0)
  ),
  "Latitude" = list(
    keep = rep(TRUE, nrow(colonial)), controls = "lat_abst"
  ),
  "Continents" = list(
    keep = rep(TRUE, nrow(colonial)), controls = c("africa", "asia")
  ),
  "Drop neo-Europes" = list(
    keep = !(colonial$shortnam %in% c("AUS", "CAN", "NZL", "USA")),
    controls = character(0)
  ),
  "Africa only" = list(
    keep = colonial$africa == 1, controls = character(0)
  )
)

fit_specification <- function(specification) {
  controls <- specification$controls
  vars_needed <- c("logpgp95", "avexpr", "logem4", controls)
  dat <- colonial[specification$keep, vars_needed, drop = FALSE]
  dat <- dat[complete.cases(dat), , drop = FALSE]

  outcome_rhs <- paste(c("avexpr", controls), collapse = " + ")
  first_stage_rhs <- paste(c("logem4", controls), collapse = " + ")
  instrument_rhs <- paste(c("logem4", controls), collapse = " + ")

  ols <- lm(as.formula(paste("logpgp95 ~", outcome_rhs)), data = dat)
  # Included exogenous controls appear after |, instrumenting themselves.
  iv <- AER::ivreg(
    Formula::as.Formula(paste("logpgp95 ~", outcome_rhs, "|", instrument_rhs)),
    data = dat
  )
  first_stage <- lm(as.formula(paste("avexpr ~", first_stage_rhs)), data = dat)
  restricted_rhs <- if (length(controls)) paste(controls, collapse = " + ") else "1"
  first_stage_restricted <- lm(
    as.formula(paste("avexpr ~", restricted_rhs)), data = dat
  )

  # This nested-model F is the partial first-stage F for the excluded logem4.
  excluded_f <- anova(first_stage_restricted, first_stage)$F[2]

  data.frame(
    n = nrow(dat),
    ols = unname(coef(ols)["avexpr"]),
    iv_2sls = unname(coef(iv)["avexpr"]),
    first_stage_coefficient = unname(coef(first_stage)["logem4"]),
    first_stage_f = excluded_f,
    weak_identification = excluded_f < 10,
    row.names = NULL
  )
}

results <- do.call(rbind, lapply(specifications, fit_specification))
results <- cbind(specification = names(specifications), results)
results[, c("ols", "iv_2sls", "first_stage_coefficient", "first_stage_f")] <-
  lapply(results[, c("ols", "iv_2sls", "first_stage_coefficient", "first_stage_f")], round, 3)

print(results, row.names = FALSE)
cat("\nWeak identification is flagged where the partial first-stage F is below 10.\n")

=== QUESTION ===
This is a completed submission against the brief above. What would you change?
