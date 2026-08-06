Conclusion: Baseline AJR IV result replicates in the recorded analysis and remains positive with latitude/continent controls. It is not robustly identified after excluding neo-Europes or within Africa.

| Spec | n | OLS | 2SLS | First stage (`logem4`) | Partial F | Weak? |
|---|---:|---:|---:|---:|---:|---|
| Baseline | 64 | 0.522 | 0.944 | -0.607 | 22.95 | No |
| + Latitude | 64 | 0.468 | 0.996 | -0.510 | 13.09 | No |
| + Continents | 64 | 0.434 | 0.839 | -0.533 | 11.01 | No |
| Drop AUS/CAN/NZL/USA | 60 | 0.487 | 1.281 | -0.391 | 8.65 | Yes |
| Africa only | 27 | 0.302 | 2.400 | -0.108 | 0.30 | Yes |

Checks performed: inspected the supplied `AER::ivreg` script. It creates one complete-case dataset per specification and uses it for OLS, IV, unrestricted first stage, and restricted first stage. F is the ordinary homoskedastic nested-model partial F for adding `logem4`, conditional on listed controls; the code checks equality with `ivreg`’s weak-instrument diagnostic. The code also asserts that `rich4 == 1` exactly corresponds to `AUS`, `CAN`, `NZL`, and `USA`.

Residual risk: independent execution was blocked because this read-only environment prevents `Rscript` from creating `R_TempDir` (“cannot create `R_TempDir`”). Thus the numeric values above are audited from the existing script/table, not freshly recomputed in this session. Weak-IV rows neither confirm nor contradict the headline; their 2SLS estimates are unreliable.

Tokens used: ~1,100