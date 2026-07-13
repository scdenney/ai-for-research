# Fixed LaLonde specification curve

Outcome: 1978 earnings (USD). The experimental NSW treated-minus-control benchmark is recomputed from the NSW sample. The naive interval is Welch; matching intervals are approximate CR1 intervals conditional on fitted scores; subclassification intervals are Neyman fixed-strata intervals.

| Specification | Estimate | SE | 95% CI | Benchmark | Gap | Covariates | Support | Estimator | Retained treated N | Eligible control N |
|---|---:|---:|---:|---:|---:|---|---|---|---:|---:|
| Naive composite difference | $-8,498 | $583 | [$-9,648, $-7,347] | $1,794 | $-10,292 | None | Untrimmed | Welch difference | 185 | 15992 |
| Demographics; untrimmed; 1-NN matching | $-2,798 | $1,015 | [$-4,808, $-788] | $1,794 | $-4,592 | Demographics | Untrimmed | 1-NN PS match (replacement; CR1 approximate) | 185 | 15992 |
| Demographics; untrimmed; five-stratum subclassification | $-4,162 | $678 | [$-5,491, $-2,833] | $1,794 | $-5,956 | Demographics | Untrimmed | Five-stratum PS subclassification (Neyman fixed-strata) | 185 | 15992 |
| Demographics; trimmed; 1-NN matching | $-2,798 | $1,015 | [$-4,808, $-788] | $1,794 | $-4,592 | Demographics | Trimmed to full-score intersection | 1-NN PS match (replacement; CR1 approximate) | 185 | 12706 |
| Demographics; trimmed; five-stratum subclassification | $-4,028 | $682 | [$-5,364, $-2,693] | $1,794 | $-5,823 | Demographics | Trimmed to full-score intersection | Five-stratum PS subclassification (Neyman fixed-strata) | 185 | 12706 |
| Demographics + earnings; untrimmed; 1-NN matching | $1,712 | $799 | [$131, $3,293] | $1,794 | $-82 | Demographics + earnings | Untrimmed | 1-NN PS match (replacement; CR1 approximate) | 185 | 15992 |
| Demographics + earnings; untrimmed; five-stratum subclassification | $-144 | $644 | [$-1,406, $1,119] | $1,794 | $-1,938 | Demographics + earnings | Untrimmed | Five-stratum PS subclassification (Neyman fixed-strata) | 185 | 15992 |
| Demographics + earnings; trimmed; 1-NN matching | $1,759 | $801 | [$174, $3,343] | $1,794 | $-36 | Demographics + earnings | Trimmed to full-score intersection | 1-NN PS match (replacement; CR1 approximate) | 185 | 5776 |
| Demographics + earnings; trimmed; five-stratum subclassification | $1,290 | $645 | [$25, $2,555] | $1,794 | $-505 | Demographics + earnings | Trimmed to full-score intersection | Five-stratum PS subclassification (Neyman fixed-strata) | 185 | 5776 |
