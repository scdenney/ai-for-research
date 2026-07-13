| Specification | N | OLS: avexpr | 2SLS: avexpr | First stage: logem4 | First-stage partial F | Identification status |
|---|---:|---:|---:|---:|---:|---|
| Base | 64 | 0.522 | 0.944 | -0.607 | 22.95 | Not weak (F >= 10) |
| Latitude | 64 | 0.468 | 0.996 | -0.510 | 13.09 | Not weak (F >= 10) |
| Continent controls | 64 | 0.434 | 0.839 | -0.533 | 11.01 | Not weak (F >= 10) |
| Drop neo-Europes | 60 | 0.487 | 1.281 | -0.391 | 8.65 | Weak (F < 10) |
| Africa only | 27 | 0.302 | 2.400 | -0.108 | 0.30 | Weak (F < 10) |

Notes: OLS and 2SLS use the identical complete-case sample within each specification. The first-stage partial F is the conventional excluded-instrument F from comparing first stages without and with `logem4`. Specifications with F < 10 are marked weak; their displayed IV point estimates are retained for transparency but are not reliable causal estimates. 2SLS is estimated with `AER::ivreg`.
