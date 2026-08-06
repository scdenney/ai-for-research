You are a read-only statistical methods reviewer. Do not edit files.

Task: advise a Sol lead implementing the LaLonde NSW/CPS specification-curve brief in BRIEF.md. The target is the ATT for NSW treated units, benchmarked against the randomized NSW treated-minus-control mean difference. The observational composite is NSW treated plus CPS controls. We must compare demographics-only versus demographics plus re74/re75, with/without common-support trimming, and 1-nearest-neighbor score matching with replacement versus five-stratum propensity-score subclassification. At least four specifications are required; the lead is considering the full 2 x 2 x 2 factorial.

Current proposed implementation:

1. Fit a logit propensity model for each covariate set on the composite.
2. For trimmed specifications, retain observations inside the intersection of treated/control score ranges, then refit the score model on the retained sample.
3. For 1-NN, match each retained treated unit to the closest control score with replacement. Estimate the ATT as the mean matched-pair outcome difference. Do not bootstrap. For uncertainty, compute an intercept-only cluster-robust variance of pair differences clustered by original matched control ID (CR1, t critical value with G-1 clusters) to account for control reuse.
4. For stratification, create five strata from treated-score quintiles, assign all controls to those bins, and estimate the treated-share-weighted within-stratum outcome differences. Use the standard independent-sample stratified plug-in variance, with each stratum weighted by its treated share.
5. Report estimates, 95% intervals, gaps from the experimental benchmark, and retained treated/control counts. Show the benchmark as a horizontal line; its own sampling interval will be in the table but not as a band.

Question: Is this a technically defensible and transparent implementation for the brief? Identify any material flaw in the estimand, support rule, point estimators, or interval estimators, and give a concrete correction. Also state what evidence pattern would justify “robust recovery,” “favorable-specification-only recovery,” or “no recovery.” Keep the response concise and decision-focused.
