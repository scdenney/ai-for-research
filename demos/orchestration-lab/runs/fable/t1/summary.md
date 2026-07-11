# Conjoint Design Summary — `exampleData1`

## Design overview

- **Respondents:** 400
- **Tasks per respondent:** 8 main choice tasks, plus 1 repeated task (a re-shown, flipped version of task 1) used for a test-retest reliability check
- **Profiles per task:** 2

## Attributes and levels

| Attribute | Number of levels | Levels |
|---|---|---|
| Housing Cost | 3 | 15% of pre-tax income; 30% of pre-tax income; 40% of pre-tax income |
| Presidential Vote (2020) | 3 | 30% Democrat, 70% Republican; 50% Democrat, 50% Republican; 70% Democrat, 30% Republican |
| Racial Composition | 4 | 50% White, 50% Nonwhite; 75% White, 25% Nonwhite; 90% White, 10% Nonwhite; 96% White, 4% Nonwhite |
| School Quality | 2 | 5 out of 10; 9 out of 10 |
| Total Daily Driving Time for Commuting and Errands | 4 | 10 min; 25 min; 45 min; 75 min |
| Type of Place | 6 | City – downtown, with a mix of offices, apartments, and shops; City, more residential area; Rural area; Small town; Suburban neighborhood with houses only; Suburban neighborhood with mix of shops, houses, businesses |
| Violent Crime Rate (Vs National Rate) | 2 | 20% Less Crime Than National Average; 20% More Crime Than National Average |

## Randomization balance check

Level frequencies were computed across all 6,400 profile-attribute assignments (400 respondents x 8 tasks x 2 profiles). Within each attribute, level shares are close to the uniform expectation (1/number of levels):

- Housing Cost (3 levels, expected 33.3% each): 33.03%-33.67% (spread 0.64 pp)
- Presidential Vote (3 levels, expected 33.3% each): 32.95%-33.55% (spread 0.59 pp)
- Racial Composition (4 levels, expected 25.0% each): 24.64%-25.28% (spread 0.64 pp)
- School Quality (2 levels, expected 50.0% each): 49.66%-50.34% (spread 0.69 pp)
- Total Daily Driving Time (4 levels, expected 25.0% each): 23.86%-26.94% (spread 3.08 pp)
- Type of Place (6 levels, expected 16.7% each): 16.12%-17.45% (spread 1.33 pp)
- Violent Crime Rate (2 levels, expected 50.0% each): 49.61%-50.39% (spread 0.78 pp)

Randomization looks well balanced: every attribute's level shares fall within about 3 percentage points of the uniform target, with most attributes within 1 point. The largest deviation, in Total Daily Driving Time, is still modest and not indicative of a randomization problem.

## Figure

![Level frequencies by attribute](figures/level-frequencies.png)

Horizontal bar chart of each attribute level's share of profile-attribute assignments, faceted by attribute and colored with the Okabe-Ito palette, confirming near-uniform randomization across levels within each attribute.
