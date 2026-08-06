Objective:
Independently diagnose the reference-category sensitivity in BRIEF.md using the installed R package and data, and advise the lead on the defensible substantive claim.

Inputs and authoritative paths:
- /Users/scdenney/Documents/github/resources/ai-for-research/demos/orchestration-lab/runs/46-sol-v2/t3/BRIEF.md
- The `projoint::exampleData1` dataset and `reshape_projoint` call specified there.

In scope:
- Inspect the reshaped data and installed `projoint` API.
- Re-estimate AMCEs under every possible Violent Crime Rate reference level and under alternatives for at least one genuinely multi-level attribute.
- Compute all-level marginal means.
- Identify exact numeric evidence relevant to whether crime "drives community choice."
- Recommend what a roughly 400-word reviewer reply should concede and claim.

Out of scope:
- Do not edit any project file.
- Do not use the web or install packages.
- Do not trust any existing analysis artifact other than BRIEF.md; calculate independently.

Constraints and invariants:
- Use R/Rscript and cluster uncertainty at respondent level if the package/API supports it.
- Distinguish coefficient relabeling from changes in fitted quantities.
- Note the interpretive consequence of crime being binary if confirmed by the data.
- Avoid causal or cross-attribute "importance" overclaims that the estimands cannot support.

Write ownership:
- Read-only. Your final response will be captured by the lead as terra-analysis.txt.

Expected artifact:
- A compact analysis memo in your final response with exact estimates (and SE/CI where useful), the method/API used, recommended figure/table contents, and a precise claim boundary.

Acceptance checks:
- Crime AMCE appears under each possible baseline.
- At least one multi-level attribute is explicitly re-leveled and its unchanged pairwise implications are explained.
- All crime MMs are reported, and crime evidence is compared with all other attribute-level MMs or within-attribute ranges.
- Numeric claims are reproducible from stated R operations.

Return format:
- Conclusion
- Numeric evidence
- Estimation notes
- Recommended claim
- Residual risk
