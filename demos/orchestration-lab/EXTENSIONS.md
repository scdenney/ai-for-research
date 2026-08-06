# The complexity ladder

The original exercise (conjoint description, estimation, and a reviewer reply on `projoint::exampleData1`) sits at the **moderate** rung: real code plus real analysis on a clean dataset. Two harder rungs were planned here, then built and run on 2026-07-12 — reference solutions and rubrics first, as always. Results live in `RESULTS.md`; the briefs in `prompts/`; the answer keys in `reference/high-ajr/` and `reference/vhigh-lalonde/`.

## High complexity — replicate and stress a famous IV result (RUN)

- **Data.** Acemoglu, Johnson, and Robinson (2001), colonial origins of comparative development. Ships on CRAN: `install.packages("ivdoctr"); data(colonial)` (64 countries; `logpgp95`, `avexpr`, `logem4`).
- **The task.** Replicate the 2SLS headline (0.944 vs OLS 0.522, first-stage F 22.95), then stress it: latitude, continent controls, drop the neo-Europes, Africa only, first-stage strength per spec.
- **What happened.** All three arms reached Distinction; the pattern (robust to controls, identification lost under sample restriction) is canonical enough that every pipeline walks it. Costs: $1.00 to $1.60 per run — cheaper than the moderate rung's judgment brief.

## Very high complexity — adjudicate a genuine methods dispute (RUN)

- **Data.** The LaLonde NSW experiment plus the CPS comparison sample. Ships on CRAN: `install.packages("causaldata")`, objects `nsw_mixtape` (445 experimental observations) and `cps_mixtape` (15,992).
- **The task.** Compute the experimental benchmark (+$1,794), reproduce the Dehejia-Wahba recovery from NSW treated + CPS controls, run the specification curve, and adjudicate against Smith and Todd's fragility critique.
- **What happened.** All three arms reached Distinction and the same verdict (favorable-specification-only recovery). The separation moved into the standard-error machinery and the process record — see the ladder notes in `RESULTS.md`. Costs: $1.83 to $5.01 per run.

## Extreme complexity — reconcile modern staggered-adoption DiD estimators (RUN)

- **Why a fourth rung.** All three arms reached Distinction on both the high and
  very-high tiers, converging on the same verdict every time. Both are canonical,
  decades-old textbook disputes (AJR 2001 is now a standard IV example; LaLonde/
  Dehejia-Wahba/Smith-Todd is the standard matching-vs-experiment example) —
  every competent pipeline has seen a worked version of each. The ladder needed a
  rung built on a **less-rehearsed** methods debate, one recent enough (2020s
  econometrics, not 1980s–2000s) that model performance might actually separate,
  and one requiring **building a small comparative pipeline** rather than
  reciting a known result.
- **Data.** The Callaway-Sant'Anna (2021) minimum-wage/teen-employment county
  panel, `did::mpdta` — 500 counties, 2003–2007, staggered adoption in
  2004/2006/2007. Ships on CRAN with `did`, `fixest`, `staggered`, and
  `bacondecomp` as the supporting estimator packages.
- **The task.** Estimate the ATT at least four ways (naive TWFE, Callaway-
  Sant'Anna under both control-group choices, Sun-Abraham or Roth-Sant'Anna),
  run a Goodman-Bacon decomposition to check whether the "forbidden comparison"
  negative-weighting critique of TWFE actually bites in this data, check
  pre-trends, and adjudicate.
- **The trap, confirmed while building the reference solution.** `staggered::
  staggered()` requires never-treated units coded `Inf`; `mpdta`'s own column
  (and `did::att_gt`'s convention) codes them `0`. Reusing `0` unchanged produces
  an ATT of **−0.37** — ten times the correct **−0.04**-ish magnitude every
  correctly specified estimator agrees on — with no error thrown. This is a real,
  verifiable, non-manufactured trap: a package-documentation-reading test, not a
  puzzle designed after the fact.
- **The judgment call.** The Bacon decomposition puts only **5.4%** of the naive
  TWFE's identifying weight on the negative-weight-risk comparison type (86.3%
  is clean treated-vs-never-treated). The correct conclusion is neither "TWFE is
  always fine" nor "always use the modern estimator" — it is that the general
  critique is real but does not materially bite in *this* dataset, a conclusion
  that requires actually running the decomposition rather than reciting the
  literature's rule of thumb in either direction.
- **What happened.** See `RESULTS.md` for the per-arm bands and costs once
  captured.

## Backups (not run)

- High (political science): Fearon and Laitin (2003) civil war onset. Harvard Dataverse hdl:1902.1/15494. Robustness across logit vs rare-events logit, covariate sets, and clustering; the null results on fractionalization are part of the key.
- Very high (competing claims with a known data error): Albouy (2012) vs AJR on the mortality series. Strongest dispute of all, but the corrected data sit behind an openICPSR account wall; if that holds, Card-Krueger (1994) vs Neumark-Wascher (2000) on minimum wage is the substitute.

## Cost, estimated vs actual

The pre-run estimate was $8 to $20 per run at high and $20 to $50 at very high. Actuals came in far under: $1.00 to $1.60 (high) and $1.83 to $5.01 (very high). The estimate extrapolated from the moderate rung's judgment brief, where cost tracked ambiguity; the ladder tasks are canonical, so every arm converged quickly. The lesson is recorded in `RESULTS.md`: compute tracks how unsettled the answer is, not how advanced the methods are.
