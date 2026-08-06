# Data

This demo commits no data files. Every run loads real, public, package-shipped data at runtime — zero downloads, no redistribution questions.

## Moderate rung (T1 Describe, T2 Estimate, T3 Reviewer reply)

- **Source:** `exampleData1` from the [projoint](https://cran.r-project.org/package=projoint) R package — a wide-format Qualtrics export from a community-choice conjoint experiment (400 respondents, 8 choice tasks, 2 profiles per task, 7 attributes, one repeated task for reliability checks).
- **Install:** `install.packages("projoint")`
- **Load:** `library(projoint); data(exampleData1)`
- **Attributes:** Housing Cost, Presidential Vote (2020), Racial Composition, School Quality, Total Daily Driving Time, Type of Place, and Violent Crime Rate (vs national rate).
- **Cite:** the projoint package and its accompanying paper (see `citation("projoint")` for the current reference).

## High rung (IV replication)

- **Source:** the Acemoglu, Johnson, and Robinson (2001) base sample — 64 countries with log 1995 GDP per capita (`logpgp95`), average expropriation risk (`avexpr`), and log settler mortality (`logem4`) — as shipped in the [ivdoctr](https://cran.r-project.org/package=ivdoctr) R package.
- **Install:** `install.packages("ivdoctr")` (runs also use `AER` and `car`)
- **Load:** `library(ivdoctr); data(colonial, package = "ivdoctr")`
- **Cite:** Acemoglu, Johnson, and Robinson (2001), "The Colonial Origins of Comparative Development," *American Economic Review* 91(5), plus the ivdoctr package.

## Very high rung (methods dispute)

- **Source:** the LaLonde (1986) National Supported Work experimental sample (Dehejia-Wahba subsample, 445 observations) and the CPS observational comparison pool (15,992 observations), as shipped in the [causaldata](https://cran.r-project.org/package=causaldata) R package (`nsw_mixtape`, `cps_mixtape`).
- **Install:** `install.packages("causaldata")` (runs also use `MatchIt`, `sandwich`, `lmtest`)
- **Load:** `library(causaldata)` then `nsw_mixtape` / `cps_mixtape`
- **Cite:** LaLonde (1986); Dehejia and Wahba (1999, 2002); Smith and Todd (2005); plus the causaldata package.

## Extreme rung (modern staggered-DiD reconciliation)

- **Source:** the Callaway-Sant'Anna (2021) minimum-wage/teen-employment county panel — 500 US counties, 2003–2007, staggered adoption in 2004/2006/2007 — as shipped in the [did](https://cran.r-project.org/package=did) R package's own worked example (`mpdta`). Cross-checked with `fixest::sunab`, `staggered::staggered`, and `bacondecomp::bacon`, all CRAN.
- **Install:** `install.packages(c("did", "fixest", "staggered", "bacondecomp"))`
- **Load:** `library(did); data(mpdta)`
- **Cite:** Callaway and Sant'Anna (2021), "Difference-in-Differences with Multiple Time Periods," *Journal of Econometrics* 225(2); Goodman-Bacon (2021), "Difference-in-Differences with Variation in Treatment Timing," *Journal of Econometrics* 225(2); Sun and Abraham (2021), *Journal of Econometrics* 225(2); Roth and Sant'Anna, the `staggered` package.
