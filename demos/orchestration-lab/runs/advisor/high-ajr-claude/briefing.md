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

=== PRODUCED: robustness-table.md ===
# Robustness table: AJR (2001) headline IV result

2SLS path: `AER::ivreg` (available on this system) used for every specification;
reported first-stage F is on the excluded instrument (`logem4`) from a `car::linearHypothesis` F-test.

| Spec | N | OLS (avexpr) | 2SLS (avexpr) | 1st-stage coef (logem4) | 1st-stage F | Weak instrument (F<10)? |
|---|---|---|---|---|---|---|
| Headline (bivariate) | 64 | 0.522 | 0.944 | -0.607 | 22.95 | No |
| (a) + latitude | 64 | 0.468 | 0.996 | -0.510 | 13.09 | No |
| (b) + continent dummies | 64 | 0.434 | 0.839 | -0.533 | 11.01 | No |
| (c) drop neo-Europes | 60 | 0.487 | 1.281 | -0.391 | 8.65 | **YES** |
| (d) Africa only | 27 | 0.302 | 2.400 | -0.108 | 0.30 | **YES** |

Notes: Outcome is `logpgp95`; endogenous regressor is `avexpr`; excluded instrument is `logem4`.
Spec (a) adds `lat_abst`; (b) adds `africa` and `asia`; (c) drops AUS/CAN/NZL/USA (`shortnam`);
(d) restricts to `africa == 1`. Rule of thumb: first-stage F below ~10 flags a weak instrument;
2SLS point estimates in flagged rows should not be read as reliable.

=== PRODUCED: memo.md ===
# Memo: What the AJR replication is entitled to claim

**The headline replicates.** On the 64-country base sample, OLS of `logpgp95` on
`avexpr` gives 0.522; instrumenting `avexpr` with `logem4` gives a 2SLS coefficient
of 0.944 — nearly double OLS, matching AJR's original qualitative pattern of a
2SLS estimate well above its OLS counterpart. The first stage is strong: `avexpr`
falls 0.607 points per log-point of settler mortality, with F = 22.95, comfortably
above the weak-instrument threshold of 10. On this evidence, the manuscript can
claim that settler mortality is a relevant instrument for institutions in the base
sample, and that the 2SLS coefficient on institutions substantially exceeds OLS.

**Adding controls holds up, barely.** Adding latitude (spec a) leaves both the
first stage (F = 13.09) and the 2SLS estimate (0.996) intact — if anything the IV
coefficient grows. Adding continent dummies (spec b) pushes the first-stage F down
to 11.01, just above the conventional threshold, while the 2SLS estimate (0.839)
stays in the same range as the headline. Both are still usable, but continent
dummies are already eating into instrument strength — this is a specification to
flag as border, not to lean on for a stronger causal claim than the headline
itself.

**Two stress tests break the instrument.** Dropping the four neo-Europes (AUS,
CAN, NZL, USA) cuts the first-stage F to 8.65 — below 10 — and the 2SLS estimate
jumps to 1.281. Restricting to Africa collapses the first stage almost entirely
(F = 0.30): settler mortality has essentially no power to predict institutions
within that subsample, and the resulting 2SLS estimate of 2.400 is not a credible
causal estimate of anything — it is what a weak instrument produces when the
denominator of the IV ratio is close to zero. Neither of these two large 2SLS
coefficients is evidence that the true effect is bigger than the headline
suggests. A collapsed first stage cannot confirm a stronger effect, and by the
same logic it cannot be used to overturn the headline either — the specification
simply cannot identify the causal parameter in that subsample.

**What the manuscript may claim:** that AJR's headline pattern (2SLS > OLS, with a
first-stage F well above 10) reproduces in the base sample and survives adding
latitude, and survives — marginally — adding continent controls. **What it may
not claim:** that the effect is even larger among non-neo-Europe countries or
within Africa specifically. Those two specifications should be reported as
diagnostic (instrument strength has failed), not as robustness checks that
strengthen the headline number. The paper's causal claim rests on the full,
latitude-controlled sample; it does not extend to African-only identification
with this instrument.

=== PRODUCED: script.R ===
#!/usr/bin/env Rscript
## Task H: Replicate and stress-test the AJR (2001) IV result
##
## Packages and palette declared up front per house convention.
suppressPackageStartupMessages({
  library(ivdoctr)
  library(AER)   # ivreg() available -> used for all 2SLS specs below
  library(car)   # linearHypothesis() for first-stage F where needed
})

## Okabe-Ito palette (used only if a figure is produced)
okabe_ito <- c(
  orange    = "#E69F00",
  skyblue   = "#56B4E9",
  bluegreen = "#009E73",
  yellow    = "#F0E442",
  blue      = "#0072B2",
  vermilion = "#D55E00",
  purple    = "#CC79A7",
  black     = "#000000"
)

set.seed(1)  # OLS/2SLS here are deterministic; set per house convention anyway

data(colonial, package = "ivdoctr")
colonial <- as.data.frame(colonial)

neo_europes <- c("AUS", "CAN", "NZL", "USA")

## ---------------------------------------------------------------------
## Helper: fit OLS + 2SLS (AER::ivreg) for a given sample/control set,
## and pull the first-stage coefficient + F-stat on the excluded instrument.
## ---------------------------------------------------------------------
run_spec <- function(label, df, extra_controls = character(0)) {
  rhs <- paste(c("avexpr", extra_controls), collapse = " + ")
  fs_rhs <- paste(c("logem4", extra_controls), collapse = " + ")

  ols_formula <- as.formula(paste("logpgp95 ~", rhs))
  ols_fit <- lm(ols_formula, data = df)
  ols_coef <- coef(ols_fit)["avexpr"]

  iv_formula <- as.formula(paste("logpgp95 ~", rhs, "|", fs_rhs))
  iv_fit <- ivreg(iv_formula, data = df)
  iv_coef <- coef(iv_fit)["avexpr"]

  fs_formula <- as.formula(paste("avexpr ~", fs_rhs))
  fs_fit <- lm(fs_formula, data = df)
  fs_coef <- coef(fs_fit)["logem4"]

  fs_test <- linearHypothesis(fs_fit, "logem4 = 0", test = "F")
  fs_f <- fs_test$F[2]

  list(
    label = label,
    n = nrow(df),
    ols_coef = unname(ols_coef),
    iv_coef = unname(iv_coef),
    fs_coef = unname(fs_coef),
    fs_f = unname(fs_f),
    weak = fs_f < 10
  )
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

## ---------------------------------------------------------------------
## Console report
## ---------------------------------------------------------------------
cat("2SLS path: AER::ivreg (available) — used for all specifications.\n\n")

for (s in specs) {
  cat(sprintf(
    "%-28s n=%2d  OLS=%.3f  2SLS=%.3f  1st-stage coef=%.3f  F=%.2f%s\n",
    s$label, s$n, s$ols_coef, s$iv_coef, s$fs_coef, s$fs_f,
    if (s$weak) "  [WEAK INSTRUMENT]" else ""
  ))
}

## ---------------------------------------------------------------------
## Write robustness-table.md
## ---------------------------------------------------------------------
tbl_lines <- c(
  "# Robustness table: AJR (2001) headline IV result",
  "",
  "2SLS path: `AER::ivreg` (available on this system) used for every specification;",
  "reported first-stage F is on the excluded instrument (`logem4`) from a `car::linearHypothesis` F-test.",
  "",
  "| Spec | N | OLS (avexpr) | 2SLS (avexpr) | 1st-stage coef (logem4) | 1st-stage F | Weak instrument (F<10)? |",
  "|---|---|---|---|---|---|---|"
)

for (s in specs) {
  tbl_lines <- c(tbl_lines, sprintf(
    "| %s | %d | %.3f | %.3f | %.3f | %.2f | %s |",
    s$label, s$n, s$ols_coef, s$iv_coef, s$fs_coef, s$fs_f,
    if (s$weak) "**YES**" else "No"
  ))
}

tbl_lines <- c(tbl_lines, "",
  "Notes: Outcome is `logpgp95`; endogenous regressor is `avexpr`; excluded instrument is `logem4`.",
  "Spec (a) adds `lat_abst`; (b) adds `africa` and `asia`; (c) drops AUS/CAN/NZL/USA (`shortnam`);",
  "(d) restricts to `africa == 1`. Rule of thumb: first-stage F below ~10 flags a weak instrument;",
  "2SLS point estimates in flagged rows should not be read as reliable."
)

writeLines(tbl_lines, "robustness-table.md")
cat("\nWrote robustness-table.md\n")

=== QUESTION ===
This is a completed submission against the brief above. What would you change?
