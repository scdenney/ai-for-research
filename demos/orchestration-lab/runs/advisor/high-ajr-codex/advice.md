Make one revision; the estimates and weak-instrument classifications appear internally coherent.

- Add conventional standard errors or confidence intervals for every OLS and 2SLS coefficient. A positive point estimate plus \(F>10\) is not, by itself, enough to say the result “survives.” Mark inference for the two weak specifications as unreliable; either omit their conventional IV intervals or add weak-IV-robust Anderson–Rubin inference.
- Remove the emphasis on the Africa conventional SE of 3.987. Conventional 2SLS inference is not trustworthy when \(F=0.30\); the collapsed first stage is the decisive fact.
- Replace “conditional on the IV exclusion restriction” with “conditional on the full IV identifying assumptions, especially instrument exogeneity and exclusion.” First-stage strength establishes only relevance.
- Call the evidence “limited sample robustness,” not “external robustness.” Subsets of the same 64-country dataset do not establish external validity, and the failed subset first stages leave regional generalizability unresolved.
- Have `script.R` generate `robustness-table.md` directly, or at least assert the reported sample sizes and estimates, so the hand-written table cannot drift from the analysis.

The final claim should be: the positive base-sample IV estimate is reproducible and remains informative with latitude or broad continent controls, but the instrument does not support conclusions about the non-neo-European or Africa-only samples.