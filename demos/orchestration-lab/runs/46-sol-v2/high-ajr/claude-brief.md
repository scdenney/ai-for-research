# Claude cross-vendor review contract

Objective: Independently audit the empirical and inferential answer to `BRIEF.md`, with special attention to what the robustness pattern does and does not authorize the manuscript to claim.

Inputs and authoritative paths: `./BRIEF.md`; the installed R packages and `ivdoctr::colonial` data named there.

In scope: Independently run the five requested OLS/2SLS specifications in R using `AER::ivreg`; verify the matching-sample first stage and the ordinary homoskedastic partial F test for the excluded `logem4`; report enough numeric results to expose disagreement; then draft a concise interpretation checklist for the final memo. Specifically challenge any tendency to treat F < 10 as confirming or overturning the structural claim, and assess heterogeneity versus loss of identification in the Africa-only restriction.

Out of scope: Do not edit or create project deliverables; do not use the web; do not install packages; do not invoke other agents or skills.

Constraints and invariants: OLS, IV, unrestricted first stage, and restricted first stage must use exactly the same rows within each specification. The five specifications are baseline; latitude; continent controls (`africa`, `asia`); drop `AUS`, `CAN`, `NZL`, `USA` by `shortnam`; Africa only. All included controls enter both structural and instrument sets. The structural regressor is `avexpr`, instrumented by `logem4`. Treat F < 10 as weak; do not present weak-IV point estimates as reliable. State which IV path and F definition you used.

Write ownership: Read-only. The lead owns all files.

Expected artifact: A compact final response captured in `claude-peer.md` by the caller.

Acceptance checks: All five specs checked; inferential claims trace to reported F values and exact sample restrictions; proposed language is neither causal overclaim nor blanket dismissal.

Return format: conclusion; numeric cross-check; interpretation guidance; checks performed; residual risk.
