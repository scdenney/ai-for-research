# Terra delegation contract

Objective: Independently replicate and stress the AJR IV result in `BRIEF.md`, producing an evidence-only analysis for the lead to verify and integrate.

Inputs and authoritative paths: `./BRIEF.md`; the installed R packages and `ivdoctr::colonial` data named there.

In scope: Use `Rscript` and `AER::ivreg` to compute the bivariate baseline and the four requested perturbations. For every specification report the actual complete-case `n`, OLS coefficient on `avexpr`, 2SLS coefficient on `avexpr`, first-stage coefficient on `logem4`, the ordinary homoskedastic partial F test for adding the single excluded instrument conditional on included exogenous controls, and whether F < 10. Audit sample alignment and note any discrepancy between `rich4` and the requested code-based neo-Europe exclusion. Give concise claim-calibrated interpretation.

Out of scope: Do not edit or create project deliverables; do not use the web; do not install packages; do not invoke other agents or skills.

Constraints and invariants: OLS, IV, unrestricted first stage, and restricted first stage must use exactly the same rows within each specification. The five specifications are baseline; latitude; continent controls (`africa`, `asia`); drop `AUS`, `CAN`, `NZL`, `USA` by `shortnam`; Africa only. The structural regressor is `avexpr`, instrumented by `logem4`; all controls enter both structural and instrument sets. Treat F < 10 as weak and do not interpret a weak-IV point estimate as reliable. Be explicit about the F definition and the `AER::ivreg` path.

Write ownership: Read-only. The lead owns all files.

Expected artifact: A compact final response captured in `terra-peer.md` by the caller.

Acceptance checks: All five specs present; coefficients and F statistics reproducible to at least three decimals; exact samples verified; interpretation distinguishes weak identification from contradictory evidence.

Return format: conclusion; numeric evidence; checks performed; residual risk; standard tokens-used line.
