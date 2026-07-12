# Task H — Robustness table: replicate and stress the AJR (2001) IV result

*Reference solution (answer key). Data: `ivdoctr::colonial` (64 countries, the
AJR base sample). Outcome `logpgp95` (log PPP GDP p.c. 1995); endogenous
regressor `avexpr` (avg. protection against expropriation risk); excluded
instrument `logem4` (log settler mortality). 2SLS via `AER::ivreg` (exact SEs).
R 4.5.1, AER, car. Coefficients on `avexpr` unless noted; SEs in parentheses.*

## The unified table (both point estimates and first-stage F for every spec)

| Specification | n | OLS β (SE) | 2SLS β (SE) | First-stage β on logem4 (SE) | First-stage F (hom.) | First-stage F (robust) | Instrument |
|---|---:|---|---|---|---:|---:|---|
| 1. Baseline (bivariate) | 64 | 0.52 (0.06) | 0.94 (0.16) | -0.607 (0.127) | 22.95 | 16.32 | strong |
| 2. + Latitude | 64 | 0.47 (0.06) | 1.00 (0.22) | -0.510 (0.141) | 13.09 | 9.52 | strong |
| 3. + Continent dummies | 64 | 0.43 (0.05) | 0.84 (0.19) | -0.533 (0.161) | 11.01 | 9.27 | strong |
| 4. Drop neo-Europes | 60 | 0.49 (0.08) | 1.28 (0.36) | -0.391 (0.133) | 8.65 | 6.85 | weak (F<10) |
| 5. Africa only | 27 | 0.30 (0.11) | 2.40 (3.99) | -0.108 (0.198) | 0.30 | 0.31 | collapsed (F<<10) |

First-stage F is the test that the excluded instrument (`logem4`) has no effect on `avexpr` (one restriction, so F = t²). The homoskedastic F is the Staiger-Stock rule-of-thumb number (threshold ≈ 10) and is the primary weak-instrument statistic here; the robust (HC1) F is a secondary check. AER's built-in weak-instrument diagnostic equals the homoskedastic F to machine precision.

## 1. The headline replicates AJR exactly

Baseline bivariate: OLS = **0.52**, 2SLS = **0.94**, first-stage coefficient on log settler mortality = **-0.607** (SE 0.127), first-stage F = **22.95**. These match AJR (2001) Table 4, col. 1 (2SLS 0.94) and Table 2 (OLS 0.52). The 2SLS estimate is ~81% larger than OLS, the direction AJR emphasize: OLS *understates* the institutions effect (classical measurement error / reverse-causation attenuation the instrument corrects).

## 2. Adding controls: the headline survives

Adding **latitude** (`lat_abst`) leaves 2SLS at **1.00** and the instrument strong (F = 13.09 > 10). Adding **continent dummies** (`africa`, `asia`) leaves 2SLS at **0.84** (F = 11.01 > 10). Across both, the coefficient stays in the 0.84-1.00 band, comfortably positive, and OLS stays near 0.43-0.47 -- the OLS/2SLS gap persists. The result is robust to these controls. (Under robust SEs the controlled first stages sit right at the 10 threshold, F ≈ 9.5 / 9.3 -- worth noting, not disqualifying.)

## 3. Restricting the sample: the instrument weakens, then collapses

**Dropping the four neo-Europes** (AUS, CAN, NZL, USA) removes the low-mortality / high-GDP anchor points that carry much of the identifying variation. The first stage falls **below the rule-of-thumb** (F = 8.65 < 10); 2SLS drifts up to 1.28 (SE 0.36) and loses precision. The point estimate does not *overturn* the result -- it is simply less reliably pinned down.

**Restricting to Africa** (n = 27) collapses the instrument entirely: the first-stage coefficient is a near-zero -0.108 (SE 0.198) and F = **0.30** -- there is essentially no settler-mortality variation left to identify institutions. The resulting 2SLS of 2.40 carries a standard error of 3.99 (95% CI [-5.41, 10.21]): a range so wide it is **uninformative**. This number is *not* evidence that the institutions effect is larger (or smaller) within Africa; a dead first stage yields a 2SLS ratio dominated by noise. It can neither confirm nor overturn the headline.

## 4. Verdict and claim ceiling

**Robust to controls, fragile to sample restriction.** The headline survives latitude and continent controls essentially intact (2SLS 0.84-1.00, F > 10). It does *not* survive as an *identified* estimate once the sample is restricted: dropping the neo-Europes pushes the first stage below F = 10, and the Africa-only sample destroys it (F = 0.30). The honest ceiling for a manuscript is therefore neither "confirmed / robust across the board" nor "overturned in restricted samples" -- both overclaim. The correct statement: the AJR estimate is **robust to observable controls but rests on cross-continental settler-mortality variation; within a single continent the instrument is too weak to identify anything**, so restricted-sample 2SLS estimates are uninformative rather than contradictory.

