# Adjudicating Dehejia–Wahba vs Smith–Todd on the NSW/CPS benchmark

The randomized NSW experiment puts the effect of the program on 1978 earnings at
**+$1,794** (95% CI 479 to 3,109). The question is whether propensity-score
methods recover that number once the experimental controls are discarded and
15,992 CPS respondents stand in for them. The raw observational contrast says
**−$8,498**: the CPS pool earns far more than the disadvantaged NSW enrollees, so
the naive comparison is off by more than ten thousand dollars and wrong-signed.

**What conditioning does.** The covariate set, not the estimator, carries the
result. With demographics alone (age, education, race, marital status, degree)
every estimator stays badly negative: −$2,798 for 1-NN, −$3,622 for
subclassification. Balancing age and schooling to max|SMD| below 0.16 does almost
nothing, because the confounding that matters here is the earnings trajectory
that selected men into NSW, not their demographics. Adding the two pre-treatment
earnings histories (re74, re75) is the whole story: 1-NN then returns +$1,712 and
+$1,759, within about $80 of the benchmark and with intervals that cover it.

**What conditioning is not doing.** It is not achieving balance on the variables
that produce the recovery. The two NN specifications still carry max|SMD| near
0.40 on the earnings histories. Recovery comes from adjusting the outcome through
the propensity score, not from constructing genuinely comparable groups, and it
does not survive a change of estimator. Coarse subclassification with the same
rich covariate set gives +$61 (95% CI −1,209 to 1,330). Its interval, once the
standard error is computed honestly (HC3 on the weighted fit rather than
clustering on six strata), excludes the benchmark. The same information, matched
one to one, hits the target; blocked into strata, it misses.

**The verdict is favorable-specification-only.** Recovery is real but conditional
on two choices made together: including lagged earnings and matching one-to-one.
Drop either and it goes away. This is Smith and Todd's fragility, not Dehejia and
Wahba's robustness, though it confirms Dehejia and Wahba's mechanism, that the
earnings histories are the load-bearing covariates.

**What a paper may claim.** That in this case, propensity-score matching on
demographics plus two years of pre-treatment earnings reproduces the experimental
estimate closely under 1-NN. **What it may not claim.** That matching "recovers
the experimental benchmark" without naming the covariate set and the estimator;
that the observational and experimental numbers are statistically equal (the gaps
are read from overlapping intervals, not a paired test, and every spec shares the
same 185 treated outcomes with the benchmark); or that good demographic balance
licenses the design. The honest sentence is narrow: recovery here is a property of
a specification, not of the method.
