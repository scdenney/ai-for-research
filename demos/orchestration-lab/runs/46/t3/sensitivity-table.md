# Reference-category sensitivity and marginal means

All estimates are profile-level, IRR-corrected `projoint` estimates with respondent-clustered analytical 95% confidence intervals. The repeated-task correction estimated tau = 0.172. A zero is the fitted reference category, not an estimated null effect.

## Violent Crime Rate: AMCEs under each reference

Level | Reference: 20% Less Crime Than National Average | Reference: 20% More Crime Than National Average
--- | --- | ---
20% Less Crime Than National Average | 0.000 (reference) | 0.251 [0.168, 0.334]
20% More Crime Than National Average | -0.251 [-0.334, -0.168] | 0.000 (reference)

The crime attribute is binary. Changing the reference can only reverse the contrast: 20% more crime versus 20% less crime, or its negative.

## Housing Cost (multi-level check): AMCEs under each reference

Level | Reference: 15% of pre-tax income | Reference: 30% of pre-tax income | Reference: 40% of pre-tax income
--- | --- | --- | ---
15% of pre-tax income | 0.000 (reference) | 0.137 [0.066, 0.208] | 0.198 [0.122, 0.274]
30% of pre-tax income | -0.137 [-0.208, -0.066] | 0.000 (reference) | 0.061 [-0.011, 0.133]
40% of pre-tax income | -0.198 [-0.274, -0.122] | -0.061 [-0.133, 0.011] | 0.000 (reference)

For a multi-level attribute, the particular AMCE displayed changes with the reference; pairwise contrasts themselves remain the same when expressed in the corresponding direction.

## Marginal means for every experimental level

| Attribute | Level | Marginal mean [95% CI] |
| --- | --- | --- |
| Housing Cost | 15% of pre-tax income | 0.614 [0.571, 0.657] |
| Housing Cost | 30% of pre-tax income | 0.477 [0.436, 0.517] |
| Housing Cost | 40% of pre-tax income | 0.416 [0.372, 0.459] |
| Presidential Vote (2020) | 30% Democrat, 70% Republican | 0.483 [0.438, 0.528] |
| Presidential Vote (2020) | 50% Democrat, 50% Republican | 0.536 [0.496, 0.576] |
| Presidential Vote (2020) | 70% Democrat, 30% Republican | 0.480 [0.436, 0.524] |
| Racial Composition | 50% White, 50% Nonwhite | 0.500 [0.456, 0.544] |
| Racial Composition | 75% White, 25% Nonwhite | 0.537 [0.492, 0.581] |
| Racial Composition | 90% White, 10% Nonwhite | 0.477 [0.437, 0.518] |
| Racial Composition | 96% White, 4% Nonwhite | 0.488 [0.442, 0.534] |
| School Quality | 5 out of 10 | 0.442 [0.401, 0.484] |
| School Quality | 9 out of 10 | 0.558 [0.516, 0.599] |
| Total Daily Driving Time for Commuting and Errands | 10 min | 0.610 [0.567, 0.654] |
| Total Daily Driving Time for Commuting and Errands | 25 min | 0.541 [0.498, 0.584] |
| Total Daily Driving Time for Commuting and Errands | 45 min | 0.470 [0.425, 0.514] |
| Total Daily Driving Time for Commuting and Errands | 75 min | 0.373 [0.329, 0.417] |
| Type of Place | City – downtown, with a mix of offices, apartments, and shops | 0.394 [0.342, 0.446] |
| Type of Place | City, more residential area | 0.509 [0.454, 0.564] |
| Type of Place | Rural area | 0.529 [0.474, 0.583] |
| Type of Place | Small town | 0.552 [0.499, 0.605] |
| Type of Place | Suburban neighborhood with houses only | 0.473 [0.420, 0.526] |
| Type of Place | Suburban neighborhood with mix of shops, houses, businesses | 0.540 [0.489, 0.591] |
| Violent Crime Rate (Vs National Rate) | 20% Less Crime Than National Average | 0.626 [0.584, 0.667] |
| Violent Crime Rate (Vs National Rate) | 20% More Crime Than National Average | 0.374 [0.333, 0.416] |

Observed within-attribute MM ranges (descriptive): Violent Crime Rate (Vs National Rate) = 0.251; Total Daily Driving Time for Commuting and Errands = 0.237; Housing Cost = 0.198; Type of Place = 0.158; School Quality = 0.116; Racial Composition = 0.059; Presidential Vote (2020) = 0.056. Ranges are included as a descriptive summary, not a universal importance ranking: attributes have different numbers of levels and different possible contrast ranges.
