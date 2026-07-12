# Planned extensions: the complexity ladder

The current exercise (conjoint description, estimation, and a reviewer reply on `projoint::exampleData1`) sits at the **moderate** rung: real code plus real analysis on a clean dataset. Two harder rungs are planned so the pipelines get tested where they should separate. Both candidate tasks run in R in under a minute on public, package-shipped or sub-1MB data, and both attach to published findings so an answer key can be built before any model runs.

## High complexity — replicate and stress a famous IV result

- **Data.** Acemoglu, Johnson, and Robinson (2001), colonial origins of comparative development. Ships on CRAN: `install.packages("ivdoctr"); data(colonial)` (64 countries; `logpgp95`, `avexpr`, `logem4`). Public mirror at Acemoglu's MIT data archive.
- **The finding.** Settler mortality instruments expropriation-risk institutions, which predict log GDP per capita. Headline 2SLS coefficient roughly 0.94 against OLS roughly 0.52 (confirm against AJR Table 4 when building the key).
- **The task.** Replicate the 2SLS headline, then stress it. Add latitude and continent controls, drop the neo-Europes, restrict to Africa, compare OLS with IV, and report the first-stage strength. A weak pipeline reports 0.94 and stops. A strong one shows how the estimate moves and what drives it.
- **Answer key.** AJR Tables 4 to 6.

## Very high complexity — adjudicate a genuine methods dispute

- **Data.** The LaLonde National Supported Work experiment plus the CPS comparison sample. Ships on CRAN: `install.packages("causaldata")`, objects `nsw_mixtape` (445 experimental observations) and `cps_mixtape` (15,992).
- **The dispute.** The experimental benchmark is roughly +$1,794. Dehejia and Wahba (1999, 2002) claim propensity-score matching recovers it from observational data. Smith and Todd (2005) show the estimates are highly sensitive to covariate set and analysis sample. Dehejia (2005) replies.
- **The task.** Reproduce the Dehejia-Wahba recovery, then run the specification curve (covariate sets by samples by matching estimators by trimming rules) and adjudicate whether matching answers LaLonde's critique. One propensity-score model says it works. The full curve says it is fragile. The judgment is which claim the evidence supports.
- **Answer key.** The experimental benchmark plus the Dehejia-Wahba and Smith-Todd tables.

## Backups

- High (political science): Fearon and Laitin (2003) civil war onset. Harvard Dataverse hdl:1902.1/15494. Robustness across logit vs rare-events logit, covariate sets, and clustering; the null results on fractionalization are part of the key.
- Very high (competing claims with a known data error): Albouy (2012) vs AJR on the mortality series. Strongest dispute of all, but the corrected data sit behind an openICPSR account wall; if that holds, Card-Krueger (1994) vs Neumark-Wascher (2000) on minimum wage is the substitute.

## Cost estimate before running

R runtime is trivial at every rung. The spend is model tokens across the three-arm matrix: the current moderate rung ran $2 to $8 per run; expect roughly $8 to $20 per run at high and $20 to $50 per run at very high, with the heavy-lead arm at the top of each range. Reference solutions and rubrics come first at each rung, as before, so no model run happens before the answer key exists.
