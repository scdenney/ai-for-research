# ATT specification curve for 1978 earnings

The randomized NSW benchmark is **$1,794** (Welch 95% CI [$474, $3,115]).

| Specification | Covariates | Support | Treated used | Controls eligible | Controls used | Max abs. SMD | Estimate | 95% CI | Benchmark | Gap |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| Experimental benchmark | Random assignment | NSW experiment | 185 | 260 | 260 | — | $1,794 | [$474, $3,115] | $1,794 | $0 |
| Naive observational difference | None | No trim | 185 | 15,992 | 15,992 | — | -$8,498 | [-$9,648, -$7,347] | $1,794 | -$10,292 |
| Demographics / 1-NN with replacement / No trim | Demographics | No trim | 185 | 15,992 | 120 | 0.075 | -$2,798 | [-$4,934, -$662] | $1,794 | -$4,592 |
| Demographics / 1-NN with replacement / Common-support trim | Demographics | Common-support trim | 185 | 12,706 | 120 | 0.075 | -$2,798 | [-$4,934, -$662] | $1,794 | -$4,592 |
| Demographics / 5 score strata / No trim | Demographics | No trim | 185 | 15,992 | 15,992 | 0.211 | -$4,137 | [-$5,492, -$2,782] | $1,794 | -$5,931 |
| Demographics / 5 score strata / Common-support trim | Demographics | Common-support trim | 185 | 12,706 | 12,706 | 0.205 | -$4,003 | [-$5,367, -$2,639] | $1,794 | -$5,798 |
| Demographics + earnings / 1-NN with replacement / No trim | Demographics + earnings | No trim | 185 | 15,992 | 127 | 0.398 | $1,712 | [$122, $3,303] | $1,794 | -$82 |
| Demographics + earnings / 1-NN with replacement / Common-support trim | Demographics + earnings | Common-support trim | 185 | 5,776 | 127 | 0.396 | $1,759 | [$169, $3,348] | $1,794 | -$36 |
| Demographics + earnings / 5 score strata / No trim | Demographics + earnings | No trim | 185 | 15,992 | 15,992 | 0.612 | -$144 | [-$1,440, $1,152] | $1,794 | -$1,938 |
| Demographics + earnings / 5 score strata / Common-support trim | Demographics + earnings | Common-support trim | 185 | 5,776 | 5,776 | 0.241 | $1,290 | [$10, $2,569] | $1,794 | -$505 |

Notes:

- The outcome is 1978 earnings in US dollars; treatment is NSW program participation. Adjusted rows target the ATT for the 185 NSW treated units.
- The observational composite contains all 185 NSW treated units and the 15,992 CPS controls.
- Common support is the intersection of treated and control ranges from the initial logit score. It retains all 185 treated units and 12,706 demographic-score controls or 5,776 earnings-score controls. The initial score is retained after trimming.
- 1-NN uses MatchIt with `estimand = "ATT"`, `replace = TRUE`, and one control per treated unit. `Controls used` is the number of distinct matched controls.
- Score stratification uses five subclasses and ATT weights. `Max abs. SMD` is the largest post-design standardized mean difference among the covariates included in that score model.
- Benchmark and naive intervals use Welch standard errors. Adjusted intervals use HC3 sandwich standard errors from the ATT-weighted outcome contrast and are conditional on the estimated design. The ordinary nonparametric bootstrap is not used for 1-NN matching.
