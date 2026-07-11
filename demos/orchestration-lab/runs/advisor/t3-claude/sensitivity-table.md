# Baseline sensitivity: Violent Crime Rate

All estimates: profile-level, respondent-clustered analytical SEs;
IRR-corrected estimates use projoint's tau = 0.172 (correction rescales profile-level estimates by 1/(1 - 2*tau) = 1.525).

## Crime AMCE under each possible baseline (attribute is binary)

| Reference category | Estimated level | Estimand | AMCE | SE | 95% CI |
|---|---|---|---|---|---|
| 20% Less Crime Than National Average | 20% More Crime Than National Average | corrected | -0.251 | 0.042 | [-0.334, -0.168] |
| 20% Less Crime Than National Average | 20% More Crime Than National Average | uncorrected | -0.165 | 0.028 | [-0.220, -0.109] |
| 20% More Crime Than National Average | 20% Less Crime Than National Average | corrected | 0.251 | 0.042 | [0.168, 0.334] |
| 20% More Crime Than National Average | 20% Less Crime Than National Average | uncorrected | 0.165 | 0.028 | [0.109, 0.220] |

Swapping the reference flips the sign only; magnitude, SE, and CI width are identical.

## Driving Time AMCEs under two baselines (multi-level attribute)

| Reference category | Estimated level | Estimand | AMCE | SE | 95% CI |
|---|---|---|---|---|---|
| 10 min | 25 min | corrected | -0.070 | 0.035 | [-0.139, -0.000] |
| 10 min | 25 min | uncorrected | -0.046 | 0.023 | [-0.091, -0.000] |
| 10 min | 45 min | corrected | -0.141 | 0.037 | [-0.212, -0.069] |
| 10 min | 45 min | uncorrected | -0.092 | 0.025 | [-0.141, -0.043] |
| 10 min | 75 min | corrected | -0.237 | 0.037 | [-0.310, -0.165] |
| 10 min | 75 min | uncorrected | -0.156 | 0.025 | [-0.205, -0.106] |
| 45 min | 10 min | corrected | 0.141 | 0.037 | [0.069, 0.212] |
| 45 min | 10 min | uncorrected | 0.092 | 0.025 | [0.043, 0.141] |
| 45 min | 25 min | corrected | 0.071 | 0.037 | [-0.002, 0.144] |
| 45 min | 25 min | uncorrected | 0.047 | 0.025 | [-0.002, 0.095] |
| 45 min | 75 min | corrected | -0.097 | 0.035 | [-0.166, -0.028] |
| 45 min | 75 min | uncorrected | -0.063 | 0.023 | [-0.108, -0.018] |

Here individual AMCEs do change with the reference category (reparameterization of the same information).

## Marginal means (baseline-invariant), all levels

| Attribute | Level | Estimand | MM | SE | 95% CI |
|---|---|---|---|---|---|
| Housing Cost | 15% of pre-tax income | corrected | 0.614 | 0.022 | [0.571, 0.657] |
| Housing Cost | 15% of pre-tax income | uncorrected | 0.574 | 0.014 | [0.546, 0.602] |
| Housing Cost | 30% of pre-tax income | corrected | 0.477 | 0.021 | [0.436, 0.517] |
| Housing Cost | 30% of pre-tax income | uncorrected | 0.485 | 0.014 | [0.458, 0.511] |
| Housing Cost | 40% of pre-tax income | corrected | 0.416 | 0.022 | [0.372, 0.459] |
| Housing Cost | 40% of pre-tax income | uncorrected | 0.445 | 0.014 | [0.417, 0.472] |
| Presidential Vote (2020) | 30% Democrat, 70% Republican | corrected | 0.483 | 0.023 | [0.438, 0.528] |
| Presidential Vote (2020) | 30% Democrat, 70% Republican | uncorrected | 0.489 | 0.015 | [0.459, 0.518] |
| Presidential Vote (2020) | 50% Democrat, 50% Republican | corrected | 0.536 | 0.020 | [0.496, 0.576] |
| Presidential Vote (2020) | 50% Democrat, 50% Republican | uncorrected | 0.524 | 0.013 | [0.497, 0.550] |
| Presidential Vote (2020) | 70% Democrat, 30% Republican | corrected | 0.480 | 0.022 | [0.436, 0.524] |
| Presidential Vote (2020) | 70% Democrat, 30% Republican | uncorrected | 0.487 | 0.015 | [0.458, 0.516] |
| Racial Composition | 50% White, 50% Nonwhite | corrected | 0.500 | 0.023 | [0.456, 0.544] |
| Racial Composition | 50% White, 50% Nonwhite | uncorrected | 0.500 | 0.015 | [0.471, 0.529] |
| Racial Composition | 75% White, 25% Nonwhite | corrected | 0.537 | 0.023 | [0.492, 0.581] |
| Racial Composition | 75% White, 25% Nonwhite | uncorrected | 0.524 | 0.015 | [0.495, 0.553] |
| Racial Composition | 90% White, 10% Nonwhite | corrected | 0.477 | 0.020 | [0.437, 0.518] |
| Racial Composition | 90% White, 10% Nonwhite | uncorrected | 0.485 | 0.014 | [0.458, 0.512] |
| Racial Composition | 96% White, 4% Nonwhite | corrected | 0.488 | 0.023 | [0.442, 0.534] |
| Racial Composition | 96% White, 4% Nonwhite | uncorrected | 0.492 | 0.015 | [0.462, 0.522] |
| School Quality | 5 out of 10 | corrected | 0.442 | 0.021 | [0.401, 0.484] |
| School Quality | 5 out of 10 | uncorrected | 0.462 | 0.014 | [0.435, 0.489] |
| School Quality | 9 out of 10 | corrected | 0.558 | 0.021 | [0.516, 0.599] |
| School Quality | 9 out of 10 | uncorrected | 0.538 | 0.014 | [0.511, 0.565] |
| Total Daily Driving Time for Commuting and Errands | 10 min | corrected | 0.610 | 0.022 | [0.567, 0.654] |
| Total Daily Driving Time for Commuting and Errands | 10 min | uncorrected | 0.572 | 0.015 | [0.543, 0.602] |
| Total Daily Driving Time for Commuting and Errands | 25 min | corrected | 0.541 | 0.022 | [0.498, 0.584] |
| Total Daily Driving Time for Commuting and Errands | 25 min | uncorrected | 0.527 | 0.014 | [0.498, 0.555] |
| Total Daily Driving Time for Commuting and Errands | 45 min | corrected | 0.470 | 0.023 | [0.425, 0.514] |
| Total Daily Driving Time for Commuting and Errands | 45 min | uncorrected | 0.480 | 0.015 | [0.451, 0.510] |
| Total Daily Driving Time for Commuting and Errands | 75 min | corrected | 0.373 | 0.022 | [0.329, 0.417] |
| Total Daily Driving Time for Commuting and Errands | 75 min | uncorrected | 0.417 | 0.015 | [0.387, 0.447] |
| Type of Place | City – downtown, with a mix of offices, apartments, and shops | corrected | 0.394 | 0.027 | [0.342, 0.446] |
| Type of Place | City – downtown, with a mix of offices, apartments, and shops | uncorrected | 0.431 | 0.018 | [0.396, 0.465] |
| Type of Place | City, more residential area | corrected | 0.509 | 0.028 | [0.454, 0.564] |
| Type of Place | City, more residential area | uncorrected | 0.506 | 0.018 | [0.470, 0.542] |
| Type of Place | Rural area | corrected | 0.529 | 0.028 | [0.474, 0.583] |
| Type of Place | Rural area | uncorrected | 0.519 | 0.018 | [0.483, 0.554] |
| Type of Place | Small town | corrected | 0.552 | 0.027 | [0.499, 0.605] |
| Type of Place | Small town | uncorrected | 0.534 | 0.018 | [0.499, 0.569] |
| Type of Place | Suburban neighborhood with houses only | corrected | 0.473 | 0.027 | [0.420, 0.526] |
| Type of Place | Suburban neighborhood with houses only | uncorrected | 0.482 | 0.017 | [0.448, 0.517] |
| Type of Place | Suburban neighborhood with mix of shops, houses, businesses | corrected | 0.540 | 0.026 | [0.489, 0.591] |
| Type of Place | Suburban neighborhood with mix of shops, houses, businesses | uncorrected | 0.526 | 0.017 | [0.493, 0.560] |
| Violent Crime Rate (Vs National Rate) | 20% Less Crime Than National Average | corrected | 0.626 | 0.021 | [0.584, 0.667] |
| Violent Crime Rate (Vs National Rate) | 20% Less Crime Than National Average | uncorrected | 0.582 | 0.014 | [0.555, 0.610] |
| Violent Crime Rate (Vs National Rate) | 20% More Crime Than National Average | corrected | 0.374 | 0.021 | [0.333, 0.416] |
| Violent Crime Rate (Vs National Rate) | 20% More Crime Than National Average | uncorrected | 0.418 | 0.014 | [0.390, 0.445] |

## Attribute importance as corrected-MM range (max minus min)

| Attribute | MM range |
|---|---|
| Violent Crime Rate (Vs National Rate) | 0.251 |
| Total Daily Driving Time for Commuting and Errands | 0.237 |
| Housing Cost | 0.198 |
| Type of Place | 0.158 |
| School Quality | 0.116 |
| Racial Composition | 0.059 |
| Presidential Vote (2020) | 0.056 |

Formal tests of range differences (respondent-cluster bootstrap, 2,000 draws; fixed contrasts, levels chosen from full-sample point estimates, not re-maximized per draw; two unadjusted pairwise tests):

- Crime minus driving time: 0.009 (SE 0.036) uncorrected, 0.014 (SE 0.056) corrected; z = 0.25, p = 0.802.
- Crime minus housing cost: 0.035 (SE 0.036) uncorrected, 0.053 (SE 0.055) corrected; z = 0.97, p = 0.333.

The IRR correction rescales all ranges by the same factor, so z and p are identical on either scale; corrected-scale SEs condition on the estimated tau.
