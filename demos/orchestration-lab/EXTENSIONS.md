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

## Backups (not run)

- High (political science): Fearon and Laitin (2003) civil war onset. Harvard Dataverse hdl:1902.1/15494. Robustness across logit vs rare-events logit, covariate sets, and clustering; the null results on fractionalization are part of the key.
- Very high (competing claims with a known data error): Albouy (2012) vs AJR on the mortality series. Strongest dispute of all, but the corrected data sit behind an openICPSR account wall; if that holds, Card-Krueger (1994) vs Neumark-Wascher (2000) on minimum wage is the substitute.

## Cost, estimated vs actual

The pre-run estimate was $8 to $20 per run at high and $20 to $50 at very high. Actuals came in far under: $1.00 to $1.60 (high) and $1.83 to $5.01 (very high). The estimate extrapolated from the moderate rung's judgment brief, where cost tracked ambiguity; the ladder tasks are canonical, so every arm converged quickly. The lesson is recorded in `RESULTS.md`: compute tracks how unsettled the answer is, not how advanced the methods are.
