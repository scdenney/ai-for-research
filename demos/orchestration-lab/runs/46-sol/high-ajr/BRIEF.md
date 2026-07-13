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
