# Specification table

Experimental benchmark (NSW treated − NSW control): **$1,794**.

| Analysis / specification | Covariates | Overlap rule | Estimator | ATT estimate | 95% interval | Gap from benchmark | Treated n | Control n |
|---|---|---|---|---:|---:|---:|---:|---:|
| Experimental NSW benchmark | Randomized NSW controls | Not applicable | Experimental difference in means | $1,794 | [$479, $3,109] | $0 | 185 | 260 |
| Naive NSW treated − CPS controls | None | No trimming | Raw difference in means | $-8,498 | [$-9,641, $-7,354] | $-10,292 | 185 | 15992 |
| Demographics | untrimmed | 1-NN score matching | Demographics | No trimming | 1-NN score matching | $-2,798 | [$-4,925, $-670] | $-4,592 | 185 | 120 |
| Demographics | untrimmed | Five score strata | Demographics | No trimming | Five score strata | $-4,137 | [$-5,492, $-2,782] | $-5,931 | 185 | 15992 |
| Demographics | trimmed to overlap | 1-NN score matching | Demographics | Trimmed to common support | 1-NN score matching | $-2,972 | [$-4,937, $-1,007] | $-4,766 | 185 | 118 |
| Demographics | trimmed to overlap | Five score strata | Demographics | Trimmed to common support | Five score strata | $-3,793 | [$-5,167, $-2,420] | $-5,588 | 185 | 12706 |
| Demographics + prior earnings | untrimmed | 1-NN score matching | Demographics + prior earnings | No trimming | 1-NN score matching | $1,712 | [$128, $3,296] | $-82 | 185 | 127 |
| Demographics + prior earnings | untrimmed | Five score strata | Demographics + prior earnings | No trimming | Five score strata | $-144 | [$-1,439, $1,152] | $-1,938 | 185 | 15992 |
| Demographics + prior earnings | trimmed to overlap | 1-NN score matching | Demographics + prior earnings | Trimmed to common support | 1-NN score matching | $2,088 | [$529, $3,647] | $294 | 185 | 129 |
| Demographics + prior earnings | trimmed to overlap | Five score strata | Demographics + prior earnings | Trimmed to common support | Five score strata | $1,266 | [$-14, $2,545] | $-529 | 185 | 5776 |

Intervals: Welch intervals for the two raw differences and experimental benchmark; HC3 sandwich intervals for matching and five-score subclassification. The 1-NN intervals are not ordinary bootstrap intervals; HC3 is a model-assisted approximation conditional on the estimated design.
