# Staggered-adoption DiD adjudication

For these counties, the staggered-TWFE warning is relevant but does not
materially change the conclusion. The naive county- and year-fixed-effects
estimate is -0.0365 (SE 0.0133) log points. Robust alternatives are close: the
Callaway--Sant'Anna (C&S) ATT is -0.0398 (SE 0.0129) with not-yet-treated
controls and -0.0400 (SE 0.0122) with never-treated controls; the
county-clustered Sun--Abraham interaction-weighted ATT, with never-treated
counties as the reference group, is -0.0400 (SE 0.0118). These estimators do
not generally weight cohort-time effects identically. Their similarity supports
the sign and approximate magnitude, not the claim that the small TWFE--C&S
difference precisely measures negative-weight bias.

The Goodman--Bacon decomposition is instructive: 86.28% of the naive TWFE
identifying weight is on clean treated-versus-never-treated 2x2 comparisons.
Only 5.39% is on later-versus-earlier-treated comparisons, in which an earlier
cohort is already treated when used as a control; 8.33% is
earlier-versus-later-treated. The reported Bacon component weights are
non-negative. Thus, 5.39% is exposure to the comparison type that can produce
problematic implicit weights when effects are dynamic, not a literal share of
negative weights. Its low exposure, alongside the robust estimates, leaves the
pooled conclusion little changed.

The dynamic C&S study uses not-yet-treated controls and event time -1 as the
reference. The figure displays every available lead: 0.003 (95% CI -0.045 to
0.052) at -4, 0.027 (95% CI -0.009 to 0.063) at -3, and 0.024 (95% CI -0.003
to 0.052) at -2. The group-time pretrend Wald test has p = 0.168. This is no
statistically detectable pretrend, not positive support for parallel trends:
the leads are imprecise and cohort support changes across event times.
Post-treatment effects are clearly negative from event time +1 onward.

I would report the C&S simple ATT with not-yet-treated controls: -0.0398 log
points (SE 0.0129), or exp(-0.0398) - 1 = -0.0390, approximately a 3.9%
reduction in teen employment. It uses counties not yet treated at each date and
agrees closely with the never-treated version. This is not a claim that plain
TWFE is generally safe under staggered adoption. In this short panel, the
problematic comparison has little exposure, and robust re-estimation leaves the
substantive inference intact. The causal reading still rests on parallel trends
and no anticipation, which these data support only indirectly. Finally,
treatment is assigned at the state level. The required county clustering may
understate within-state dependence, so the reported uncertainty is limited.
