Conclusion: The headline replicates (baseline 2SLS = 0.944 vs. OLS = 0.522) with a non-weak first stage. It remains directionally similar with latitude and continent controls. Dropping the four neo-Europes yields F < 10; Africa-only is severely weak (F = 0.298), so those IV point estimates are not reliable evidence either for or against the headline.

Numeric evidence (`AER::ivreg`; homoskedastic partial F from nested unrestricted vs. restricted first-stage `lm` models, testing the single excluded `logem4` conditional on controls):

| Specification | n | OLS `avexpr` | 2SLS `avexpr` | First-stage `logem4` | Partial F | Weak? |
|---|---:|---:|---:|---:|---:|---|
| Baseline | 64 | 0.522 | 0.944 | -0.607 | 22.947 | No |
| + latitude | 64 | 0.468 | 0.996 | -0.510 | 13.093 | No |
| + Africa, Asia | 64 | 0.434 | 0.839 | -0.533 | 11.006 | No |
| Drop AUS/CAN/NZL/USA | 60 | 0.487 | 1.281 | -0.391 | 8.646 | Yes |
| Africa only | 27 | 0.302 | 2.400 | -0.108 | 0.298 | Yes |

Checks performed: all relevant variables have no missing values; each specification used one explicit complete-case data frame for OLS, IV, restricted FS, and unrestricted FS. `rich4 == 1` exactly corresponds to `AUS`, `CAN`, `NZL`, and `USA`; there is no discrepancy with the requested code-based exclusion.

Residual risk: the strongest identified specifications support a positive institutional-income relationship under these controls, but this exercise alone does not establish broader causal robustness. The neo-Europe-drop and Africa-only estimates should not be substantively interpreted because of weak identification.

Tokens used: ~1,050