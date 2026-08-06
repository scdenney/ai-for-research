# Reference-category sensitivity and marginal means

All entries are IRR-corrected profile-level estimates from `projoint`; 95% confidence intervals are percentile intervals from 5000 respondent-cluster bootstrap resamples. Each resample retains all profiles and the flipped repeat for sampled respondents, so the same uncertainty procedure is used for MMs, AMCEs, and their direct comparison.

The flipped repeat gives tau = 0.172, `projoint`'s IRR-based response-error parameter. It maps an uncorrected MM p to (p - tau)/(1 - 2*tau), and maps an uncorrected AMCE to AMCE/(1 - 2*tau); tau is re-estimated in every bootstrap resample.

## Violent Crime Rate AMCEs under each baseline

Each non-reference cell is the AMCE for the row level relative to the column's reference level.

| Level | 20% Less Crime Than National Average | 20% More Crime Than National Average |
|---|---|---|
| 20% Less Crime Than National Average | 0.000 (reference) | 0.251 [0.170, 0.337] |
| 20% More Crime Than National Average | -0.251 [-0.337, -0.170] | 0.000 (reference) |

The crime attribute is binary, so changing the reference merely reverses the orientation of its one pairwise contrast; its absolute magnitude is unchanged.

## Multi-level check: Housing Cost AMCEs under each baseline

With three levels, releveling changes which pairwise contrast a reference-coded coefficient displays; it does not change any given pairwise contrast.

| Level | 15% of pre-tax income | 30% of pre-tax income | 40% of pre-tax income |
|---|---|---|---|
| 15% of pre-tax income | 0.000 (reference) | 0.137 [0.066, 0.211] | 0.198 [0.121, 0.275] |
| 30% of pre-tax income | -0.137 [-0.211, -0.066] | 0.000 (reference) | 0.061 [-0.013, 0.131] |
| 40% of pre-tax income | -0.198 [-0.275, -0.121] | -0.061 [-0.131, 0.013] | 0.000 (reference) |

## Marginal means for all levels

| Attribute | Level | Marginal mean [95% CI] |
|---|---|---|
| Housing Cost | 15% of pre-tax income | 0.614 [0.572, 0.658] |
| Housing Cost | 30% of pre-tax income | 0.477 [0.434, 0.517] |
| Housing Cost | 40% of pre-tax income | 0.416 [0.372, 0.459] |
| Presidential Vote (2020) | 30% Democrat, 70% Republican | 0.483 [0.438, 0.526] |
| Presidential Vote (2020) | 50% Democrat, 50% Republican | 0.536 [0.497, 0.577] |
| Presidential Vote (2020) | 70% Democrat, 30% Republican | 0.480 [0.436, 0.526] |
| Racial Composition | 50% White, 50% Nonwhite | 0.500 [0.456, 0.546] |
| Racial Composition | 75% White, 25% Nonwhite | 0.537 [0.493, 0.581] |
| Racial Composition | 90% White, 10% Nonwhite | 0.477 [0.437, 0.518] |
| Racial Composition | 96% White, 4% Nonwhite | 0.488 [0.442, 0.532] |
| School Quality | 5 out of 10 | 0.442 [0.401, 0.483] |
| School Quality | 9 out of 10 | 0.558 [0.517, 0.599] |
| Total Daily Driving Time for Commuting and Errands | 10 min | 0.610 [0.566, 0.658] |
| Total Daily Driving Time for Commuting and Errands | 25 min | 0.541 [0.498, 0.583] |
| Total Daily Driving Time for Commuting and Errands | 45 min | 0.470 [0.426, 0.515] |
| Total Daily Driving Time for Commuting and Errands | 75 min | 0.373 [0.327, 0.418] |
| Type of Place | City – downtown, with a mix of offices, apartments, and shops | 0.394 [0.340, 0.447] |
| Type of Place | City, more residential area | 0.509 [0.455, 0.566] |
| Type of Place | Rural area | 0.529 [0.475, 0.584] |
| Type of Place | Small town | 0.552 [0.499, 0.606] |
| Type of Place | Suburban neighborhood with houses only | 0.473 [0.419, 0.525] |
| Type of Place | Suburban neighborhood with mix of shops, houses, businesses | 0.540 [0.490, 0.592] |
| Violent Crime Rate (Vs National Rate) | 20% Less Crime Than National Average | 0.626 [0.585, 0.669] |
| Violent Crime Rate (Vs National Rate) | 20% More Crime Than National Average | 0.374 [0.331, 0.415] |

## Direct comparison of crime and commuting

The directly estimated contrast (crime low − crime high) − (driving 10 min − driving 75 min) is 0.014 [-0.099, 0.124]. Thus the 1.4-point difference between these two contrasts is not distinguishable from zero under the respondent-cluster bootstrap.

Figure caption: The left panel shows point-estimated ranges among the levels included for each attribute; it deliberately has no range confidence intervals. These ranges depend on the experimental level ranges and are not scale-free measures of attribute importance. The right panel gives the 95% bootstrap interval for the pre-specified crime-versus-commuting contrast. Blue marks identify crime. The figure uses 400 respondents and 8 paired tasks per respondent (plus one flipped repeat); estimates are IRR-corrected profile-selection probabilities.
