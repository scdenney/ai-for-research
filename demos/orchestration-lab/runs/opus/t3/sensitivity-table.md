# T3 — Reference-category sensitivity: crime AMCEs and marginal means

All estimates are `projoint` measurement-error-**corrected**, profile-level,
SEs clustered by respondent (95% CIs in brackets). AMCEs are percentage
points on P(profile chosen); MMs are probabilities.

## Table 1. Crime AMCE under each possible baseline (attribute is BINARY)

| Level | Baseline: 20% Less Crime Than National Average | Baseline: 20% More Crime Than National Average |
|---|---|---|
| 20% More Crime Than National Average | -25.1 [-33.4, -16.8] | 0 (ref) |
| 20% Less Crime Than National Average | 0 (ref) | +25.1 [+16.8, +33.4] |

A binary attribute admits ONE contrast, so switching the reference only flips the sign: |AMCE| = 25.1 pp under either baseline. No baseline exists under which the crime effect shrinks or vanishes.

## Table 2. Commute AMCE under two baselines (a MULTI-LEVEL attribute)

| Level | Baseline: 10 min | Baseline: 75 min |
|---|---|---|
| 25 min | -7.0 [-13.9, +0.0] | +16.8 [+9.5, +24.0] |
| 45 min | -14.1 [-21.2, -6.9] | +9.7 [+2.8, +16.6] |
| 75 min | -23.7 [-31.0, -16.5] | 0 (ref) |
| 10 min | 0 (ref) | +23.7 [+16.5, +31.0] |

Individual coefficients DO move with the reference, but every pairwise
difference — and the min-to-max span — is preserved. The baseline relabels;
it does not create or destroy effect.

## Table 3. Marginal means for all levels (baseline-INVARIANT)

| Attribute | Level | MM | 95% CI | Attr. MM range (pp) |
|---|---|---|---|---|
| Violent Crime Rate (Vs National Rate) | 20% Less Crime Than National Average | 0.626 | [0.584, 0.667] | 25.1 |
| Violent Crime Rate (Vs National Rate) | 20% More Crime Than National Average | 0.374 | [0.333, 0.416] | 25.1 |
| Total Daily Driving Time for Commuting and Errands | 10 min | 0.610 | [0.567, 0.654] | 23.7 |
| Total Daily Driving Time for Commuting and Errands | 25 min | 0.541 | [0.498, 0.584] | 23.7 |
| Total Daily Driving Time for Commuting and Errands | 45 min | 0.470 | [0.425, 0.514] | 23.7 |
| Total Daily Driving Time for Commuting and Errands | 75 min | 0.373 | [0.329, 0.417] | 23.7 |
| Housing Cost | 15% of pre-tax income | 0.614 | [0.571, 0.657] | 19.8 |
| Housing Cost | 30% of pre-tax income | 0.477 | [0.436, 0.517] | 19.8 |
| Housing Cost | 40% of pre-tax income | 0.416 | [0.372, 0.459] | 19.8 |
| Type of Place | Small town | 0.552 | [0.499, 0.605] | 15.8 |
| Type of Place | Suburban neighborhood with mix of shops, houses, businesses | 0.540 | [0.489, 0.591] | 15.8 |
| Type of Place | Rural area | 0.529 | [0.474, 0.583] | 15.8 |
| Type of Place | City, more residential area | 0.509 | [0.454, 0.564] | 15.8 |
| Type of Place | Suburban neighborhood with houses only | 0.473 | [0.420, 0.526] | 15.8 |
| Type of Place | City – downtown, with a mix of offices, apartments, and shops | 0.394 | [0.342, 0.446] | 15.8 |
| School Quality | 9 out of 10 | 0.558 | [0.516, 0.599] | 11.6 |
| School Quality | 5 out of 10 | 0.442 | [0.401, 0.484] | 11.6 |
| Racial Composition | 75% White, 25% Nonwhite | 0.537 | [0.492, 0.581] | 5.9 |
| Racial Composition | 50% White, 50% Nonwhite | 0.500 | [0.456, 0.544] | 5.9 |
| Racial Composition | 96% White, 4% Nonwhite | 0.488 | [0.442, 0.534] | 5.9 |
| Racial Composition | 90% White, 10% Nonwhite | 0.477 | [0.437, 0.518] | 5.9 |
| Presidential Vote (2020) | 50% Democrat, 50% Republican | 0.536 | [0.496, 0.576] | 5.6 |
| Presidential Vote (2020) | 30% Democrat, 70% Republican | 0.483 | [0.438, 0.528] | 5.6 |
| Presidential Vote (2020) | 70% Democrat, 30% Republican | 0.480 | [0.436, 0.524] | 5.6 |

## Baseline-invariant importance ranking (within-attribute MM range)

AMCE-based importance is baseline-fragile: Table 2 shows the largest commute
coefficient switching levels with the reference. We therefore rank attributes
by their marginal-mean range — a quantity that invokes no reference category.

| Rank | Attribute | MM range (pp) |
|---|---|---|
| 1 | Violent Crime Rate (Vs National Rate) | 25.1 |
| 2 | Total Daily Driving Time for Commuting and Errands | 23.7 |
| 3 | Housing Cost | 19.8 |
| 4 | Type of Place | 15.8 |
| 5 | School Quality | 11.6 |
| 6 | Racial Composition | 5.9 |
| 7 | Presidential Vote (2020) | 5.6 |

## Is crime's lead real? Difference in MM ranges vs each other attribute (respondent-cluster bootstrap, B = 500)

Fixed a-priori contrasts (each attribute's max-MM vs min-MM level); two-sided
p from the bootstrap SE. Note the range metric mechanically favours attributes
with MORE levels, so it is stacked against binary crime — which still leads.

| Crime range - ... | Diff (pp) | 95% CI | p |
|---|---|---|---|
| Total Daily Driving Time for Commuting and Errands | +1.4 | [-10.7, +12.4] | 0.815 |
| Housing Cost | +5.3 | [-7.4, +17.1] | 0.374 |
| Type of Place | +9.3 | [-4.0, +20.2] | 0.133 |
| School Quality | +13.5 | [+1.4, +26.0] | 0.029 |
| Racial Composition | +19.2 | [+5.8, +30.2] | 0.001 |
| Presidential Vote (2020) | +19.5 | [+8.0, +29.3] | 0.000 |

Crime has the largest point estimate, but under these pre-specified contrasts its lead is not statistically distinguishable from commute (diff +1.4 pp) or housing (diff +5.3 pp): no detected superiority, which is weaker than proven equality. Crime separates clearly only from the bottom tier (school, race, presidential vote).

Two caveats, both running AGAINST crime: the MM range is design-dependent (it
reflects each attribute's chosen level set), and for multi-level attributes it is a
selected max-min extremum that is mechanically inflated relative to binary crime's
single clean contrast. Crime leads despite both. The difference SEs come from a
joint respondent-cluster bootstrap that re-estimates every MM (and the IRR
correction) within each resample, so cross-attribute covariance is carried through;
the near-zero bootstrap correlation is a diagnostic, not an assumption.
