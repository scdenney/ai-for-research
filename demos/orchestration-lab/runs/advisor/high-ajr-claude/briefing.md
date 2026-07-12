You are reviewing a completed analysis before it ships. The brief was:

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

---

The produced memo.md:

# Memo: what the AJR replication can and cannot support

The headline replicates. On the 64-country base sample, OLS of `logpgp95` on
`avexpr` gives 0.52 (se 0.06); instrumenting `avexpr` with `logem4` gives a
2SLS coefficient of 0.94 (se 0.16) — close to AJR's published estimate and,
as advertised, well above OLS. The first stage is strong here: `avexpr` falls
0.61 points for every log-point of settler mortality, with F = 23, comfortably
above the weak-instrument threshold. Adding latitude (spec 2, F = 13) or
continent dummies (spec 3, F = 11) leaves the story qualitatively intact — the
2SLS coefficient stays in the 0.8–1.0 range and the instrument remains
(barely, for spec 3) above the conventional F = 10 cutoff. So the core claim —
that institutions instrumented by settler mortality predict long-run income,
with 2SLS exceeding OLS — survives the two "add plausible controls" stress
tests.

It does not survive the two sample-restriction stress tests, for a diagnostic
reason rather than a substantive one: the instrument itself weakens. Dropping
the four neo-Europes (AUS, CAN, NZL, USA) drops the first-stage F to 8.65 —
already below the rule-of-thumb threshold — and the 2SLS point estimate jumps
to 1.28 with a much wider SE (0.36 vs. 0.16). Restricting to Africa is worse:
the first-stage coefficient on `logem4` shrinks to -0.11 and F collapses to
0.30, essentially no instrument power. The resulting 2SLS "estimate" of 2.40
(se 3.99) is not a more localized version of the headline effect — it is the
output of a regression with no working instrument, and the huge SE is the
honest signal that nothing can be learned from it. Under weak identification,
2SLS is biased toward OLS and its SEs/CIs are invalid, so this number should
not be quoted, compared to the baseline, or read as evidence the effect is
larger or smaller in Africa specifically.

**What the manuscript may claim:** the settler-mortality instrument for
institutions produces a 2SLS estimate that exceeds OLS and is robust to
adding latitude and continent controls, on the AJR base sample of 64
countries. That is a genuine, reproducible finding.

**What it may not claim:** that this result is confirmed, or overturned,
within Africa, or that it is robust to excluding the neo-Europes. Both of
those specifications are weakly identified — the instrument loses power
precisely in the subsamples with the least variation in settler mortality —
so neither a large nor a small 2SLS coefficient there is informative. The
correct statement is that the four neo-Europe countries and the mortality
gradient across continents are doing much of the identifying work in the
full sample, and the paper cannot speak to whether the effect holds within
more homogeneous subpopulations without a stronger or different instrument.

---

The full artifact set (script.R, robustness-table.md, memo.md) is in the current directory. What would you change before this ships? Verify the numbers if you can.
