# NSW--CPS specification table

Experimental benchmark (NSW treated minus NSW control): **1,794.3**.

| Specification | Estimator | Covariates | Support rule | Estimate | Conditional 95% interval | Gap vs benchmark (conditional 95% interval) | Max \|SMD\| | Treated retained | CPS controls | Effective CPS controls |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|
| Naive observational difference | Naive | None | None | -8,497.5 | [-9,638.0, -7,357.1] | -10,291.9 [-10,973.7, -9,610.0] | 2.428 | 185 | 15992 | 15992.0 |
| 1-NN: Demographics / No trim | 1-NN matching | Demographics | No trim | -2,797.9 | [-4,890.9, -705.0] | -4,592.3 [-6,475.0, -2,709.6] | 0.069 | 185 | 120 | 79.8 |
| Stratification: Demographics / No trim | Five score strata | Demographics | No trim | -4,046.1 | [-5,372.2, -2,719.9] | -5,840.4 [-6,801.1, -4,879.7] | 0.216 | 185 | 15992 | 469.9 |
| 1-NN: Demographics / Common-support trim | 1-NN matching | Demographics | Common-support trim | -2,797.9 | [-4,890.9, -705.0] | -4,592.3 [-6,475.0, -2,709.6] | 0.069 | 185 | 120 | 79.8 |
| Stratification: Demographics / Common-support trim | Five score strata | Demographics | Common-support trim | -3,911.7 | [-5,247.3, -2,576.2] | -5,706.1 [-6,679.7, -4,732.4] | 0.212 | 185 | 12706 | 451.1 |
| 1-NN: Demographics + earnings / No trim | 1-NN matching | Demographics + earnings | No trim | 1,712.2 | [142.1, 3,282.2] | -82.2 [-1,358.6, 1,194.2] | 0.368 | 185 | 127 | 95.3 |
| Stratification: Demographics + earnings / No trim | Five score strata | Demographics + earnings | No trim | -180.7 | [-1,469.3, 1,107.9] | -1,975.0 [-2,883.2, -1,066.8] | 0.372 | 185 | 15992 | 352.8 |
| 1-NN: Demographics + earnings / Common-support trim | 1-NN matching | Demographics + earnings | Common-support trim | 1,758.6 | [189.2, 3,328.0] | -35.8 [-1,311.4, 1,239.9] | 0.365 | 185 | 127 | 95.3 |
| Stratification: Demographics + earnings / Common-support trim | Five score strata | Demographics + earnings | Common-support trim | 1,252.5 | [-20.5, 2,525.5] | -541.8 [-1,427.7, 344.1] | 0.209 | 185 | 5776 | 346.6 |

`No trim` strata use the four internal treated-score quintiles with `-Inf` and `Inf` boundaries, so every CPS control is eligible. Common-support trimming is applied only in trim rows.
Intervals are fixed-weight HC intervals, conditional on the estimated score and realized matches/strata; they are not full matching-estimator inference. The gap interval respects the shared NSW treated mean: with all 185 treated retained, the gap is the NSW randomized-control mean minus the weighted CPS-control mean. Benchmark inclusion in an estimate-level interval is not a recovery test or equivalence result.
