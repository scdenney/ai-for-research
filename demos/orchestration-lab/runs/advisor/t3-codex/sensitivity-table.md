# Crime reference-category sensitivity

Estimates are measurement-error-corrected profile-level quantities from `projoint`; intervals are 95% confidence intervals. AMCEs are percentage-point differences in probability of selection.

| Quantity | 20% less crime as reference | 20% more crime as reference | Marginal mean (95% CI) |
|---|---:|---:|---:|
| 20% less crime than national average | Reference | 0.251 ([0.168, 0.334]) | 0.626 ([0.584, 0.667]) |
| 20% more crime than national average | -0.251 ([-0.334, -0.168]) | Reference | 0.374 ([0.333, 0.416]) |

The two AMCEs are exact sign reversals because crime has only two levels. For a multi-level contrast, Housing Cost changes displayed coefficients with the reference: 

| Housing Cost contrast | AMCE (95% CI) |
|---|---:|
| 30% of pre-tax income vs. 15% of pre-tax income | -0.137 ([-0.208, -0.066]) |
| 40% of pre-tax income vs. 15% of pre-tax income | -0.198 ([-0.274, -0.122]) |
| 15% of pre-tax income vs. 30% of pre-tax income | 0.137 ([0.066, 0.208]) |
| 40% of pre-tax income vs. 30% of pre-tax income | -0.061 ([-0.133, 0.011]) |
| 15% of pre-tax income vs. 40% of pre-tax income | 0.198 ([0.122, 0.274]) |
| 30% of pre-tax income vs. 40% of pre-tax income | 0.061 ([-0.011, 0.133]) |

All marginal means (and the baseline-invariant max–min MM spans) are computed in `script.R`; the figure reports the crime MMs.
