# ATT estimates: mpdta minimum-wage / teen employment panel

Outcome: `lemp` (log county teen employment). All standard errors are
county-clustered (or the package's native panel-bootstrap/analytic
county-level variance, where clustering isn't a separate argument). The
Roth-Sant'Anna row reports `staggered::staggered`'s `se` column (its own
asymptotic SE), not the more conservative `se_neyman`; the two are
numerically indistinguishable here (0.011614 vs. 0.011614) but need not be
in general.

| Estimator | ATT | SE | Control / comparison group |
|---|---|---|---|
| Naive TWFE (`post × ever-treated`, county + year FE) | -0.0365 | 0.0133 | All treated/control county-years pooled implicitly (2×2 comparisons are 86.3% treated-vs-never-treated, 8.3% treated-vs-not-yet-treated, and 5.4% already-treated-as-control — see decomposition below) |
| Callaway & Sant'Anna, simple aggregation | -0.0398 | 0.0117 | Not-yet-treated |
| Callaway & Sant'Anna, simple aggregation | -0.0400 | 0.0129 | Never-treated |
| Sun & Abraham (`fixest::sunab`), aggregated ATT | -0.0400 | 0.0118 | Not-yet-/never-treated (interacted-cohort estimator, last pre-period reference) |
| Roth & Sant'Anna (`staggered::staggered`), simple estimand | -0.0471 | 0.0116 | Not-yet-treated (efficient weighting under random treatment timing) |

## Goodman-Bacon decomposition of the naive TWFE

| Comparison type | Share of identifying weight | Weighted avg. 2×2 estimate |
|---|---|---|
| Treated vs. never-treated | 86.3% | -0.0407 |
| Earlier-treated vs. later-treated (as control) | 8.3% | -0.0198 |
| Later-treated vs. earlier-treated (as control) | 5.4% | +0.0046 |

Only **"Later-treated vs. earlier-treated (as control)"** puts an
already-treated unit in the control role — the comparison Goodman-Bacon
shows can carry negative weight if effects change over time. It holds
**5.4%** of total TWFE weight. "Earlier-treated vs. later-treated (as
control)" (8.3%) is *not* contaminated in that sense: it compares an
earlier-treated cohort against a later cohort during the later cohort's
still-untreated periods, so the control units there are not-yet-treated —
clean under parallel trends, and the same comparison
`did::att_gt(control_group = "notyettreated")` uses on purpose. Correct
accounting: **94.6%** of TWFE's weight (86.3% treated-vs-never-treated +
8.3% earlier-vs-later-treated) is clean, and **5.4%** is the forbidden
already-treated-as-control cell.

That 5.4% cell is also where the bias actually shows up: it averages
**+0.0046**, against **-0.0389** for every other cell — attenuation in
exactly the direction Goodman-Bacon predicts when effects grow over time.
Reallocating its weight to the clean average would move TWFE from -0.0365
to about -0.0389, a shift of roughly **-0.002**, which is about two-thirds
of the entire gap between TWFE (-0.0365) and Callaway-Sant'Anna (-0.0400).
