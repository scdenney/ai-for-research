# Baseline sensitivity of the crime result

Conjoint: `projoint::exampleData1`, forced-choice, respondent-clustered SEs,
IRR-corrected for response instability via the repeated flipped task
(swap-error probability τ = 0.172; AMCE/MM correction factor 1/(1−2τ) = 1.525).
All quantities in probability points; 95% CIs in brackets. Reproduced by
`script.R`; figure in `figures/sensitivity.png`.

---

## A. Violent Crime Rate — AMCE under *each* possible baseline

The attribute is **binary**, so it has exactly two reference categories and one
contrast. Moving the baseline only relabels which level is the "effect" and
flips the sign; **the magnitude is identical.** There is no baseline under which
the effect of crime is smaller.

| Baseline (reference) | Level scored | AMCE (uncorrected) | AMCE (IRR-corrected) |
|---|---|---|---|
| 20% **Less** Crime | 20% More Crime | **−0.165** [−0.220, −0.110] | **−0.251** [−0.334, −0.168] |
| 20% **More** Crime | 20% Less Crime | **+0.165** [+0.110, +0.220] | **+0.251** [+0.168, +0.334] |

SE = 0.028 (uncorrected), 0.042 (corrected) in both rows. School Quality — the
other binary attribute — behaves identically (|AMCE| = 0.076 uncorrected either
way). *For a binary attribute the reviewer's mechanism cannot operate.*

## B. A multi-level attribute *does* move — Total Daily Driving Time (4 levels)

Here the reviewer is mechanically correct: every per-level AMCE changes when the
reference changes. Choosing the best commute (10 min) as baseline makes every
effect negative; choosing the worst (75 min) makes every effect positive. But
notice the two columns are the *same profile shifted by a constant* — the
10-min-vs-75-min gap is 0.156 under **either** baseline.

| Level | AMCE, baseline = 10 min | AMCE, baseline = 75 min |
|---|---|---|
| 10 min | 0 (ref) | **+0.156** [+0.106, +0.206] |
| 25 min | −0.046 [−0.091, 0.000] | +0.110 [+0.061, +0.159] |
| 45 min | −0.092 [−0.141, −0.043] | +0.063 [+0.019, +0.108] |
| 75 min | −0.156 [−0.206, −0.106] | 0 (ref) |

## C. Marginal means — the baseline-invariant quantity

MMs condition on a level being present and average over everything else; they
carry **no reference category**. The within-attribute **range** (max − min MM)
is a baseline-free measure of how much an attribute moves choice. Ranking is
unchanged by the IRR correction (which scales every range by 1.525).

| Rank | Attribute | MM range | Top / bottom level (MM) |
|---|---|---|---|
| **1** | **Violent Crime Rate** | **0.165** | Less crime 0.582 / More crime 0.418 |
| 2 | Total Daily Driving Time | 0.156 | 10 min 0.572 / 75 min 0.417 |
| 3 | Housing Cost | 0.130 | 15% income 0.574 / 40% income 0.445 |
| 4 | Type of Place | 0.103 | Small town 0.534 / Downtown 0.431 |
| 5 | School Quality | 0.076 | 9/10 0.538 / 5/10 0.462 |
| 6 | Racial Composition | 0.039 | 75/25 White 0.524 / 90/10 White 0.485 |
| 7 | Presidential Vote (2020) | 0.037 | 50/50 0.524 / 70/30 Dem 0.487 |

### Full marginal means (uncorrected, 95% CI)

| Attribute | Level | MM | 95% CI |
|---|---|---|---|
| Violent Crime Rate | 20% Less Crime | 0.582 | [0.555, 0.610] |
| Violent Crime Rate | 20% More Crime | 0.418 | [0.390, 0.445] |
| Driving Time | 10 min | 0.572 | [0.543, 0.602] |
| Driving Time | 25 min | 0.527 | [0.498, 0.555] |
| Driving Time | 45 min | 0.480 | [0.451, 0.510] |
| Driving Time | 75 min | 0.417 | [0.387, 0.447] |
| Housing Cost | 15% of pre-tax income | 0.574 | [0.546, 0.602] |
| Housing Cost | 30% of pre-tax income | 0.485 | [0.458, 0.511] |
| Housing Cost | 40% of pre-tax income | 0.445 | [0.417, 0.472] |
| Type of Place | Small town | 0.534 | [0.499, 0.569] |
| Type of Place | Suburban (mixed use) | 0.526 | [0.493, 0.560] |
| Type of Place | Rural area | 0.519 | [0.483, 0.554] |
| Type of Place | City, more residential | 0.506 | [0.470, 0.542] |
| Type of Place | Suburban (houses only) | 0.482 | [0.448, 0.517] |
| Type of Place | City – downtown | 0.431 | [0.396, 0.465] |
| School Quality | 9 out of 10 | 0.538 | [0.511, 0.565] |
| School Quality | 5 out of 10 | 0.462 | [0.435, 0.489] |
| Racial Composition | 75% White, 25% Nonwhite | 0.524 | [0.495, 0.553] |
| Racial Composition | 50% White, 50% Nonwhite | 0.500 | [0.471, 0.529] |
| Racial Composition | 96% White, 4% Nonwhite | 0.492 | [0.462, 0.522] |
| Racial Composition | 90% White, 10% Nonwhite | 0.485 | [0.458, 0.512] |
| Presidential Vote | 50% Dem, 50% Rep | 0.524 | [0.497, 0.550] |
| Presidential Vote | 30% Dem, 70% Rep | 0.489 | [0.459, 0.518] |
| Presidential Vote | 70% Dem, 30% Rep | 0.487 | [0.458, 0.516] |

**Read-off.** The crime attribute has the single widest MM range, but only by a
hair over commuting time (0.165 vs 0.156 — a 0.009 gap, far inside sampling
error). The two crime levels are also the pair furthest from the 0.5
indifference line. Both facts are independent of any reference category.
