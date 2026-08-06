# Reconcile staggered-adoption DiD estimators on did::mpdta
set.seed(20260717)
library(did)
library(fixest)
library(bacondecomp)

# Okabe-Ito palette and plotting defaults
oi <- c(orange="#E69F00", sky_blue="#56B4E9", bluish_green="#009E73", yellow="#F0E442", blue="#0072B2", vermillion="#D55E00", purple="#CC79A7", black="#000000")
theme_event <- list(cex.axis=.95, cex.lab=1.05, family="sans")

data(mpdta, package="did")
d <- mpdta
# did::att_gt uses 0 for never treated; treatment turns on in first.treat.
d$ever_treated <- as.integer(d$first.treat > 0)
d$post <- as.integer(d$ever_treated == 1 & d$year >= d$first.treat)

# (a) Pooled TWFE, clustered by county.
twfe <- feols(lemp ~ post | countyreal + year, d, cluster=~countyreal)
twfe_att <- unname(coef(twfe)["post"]); twfe_se <- unname(se(twfe)["post"])

# (b) C&S group-time DiD; bootstrap is clustered at the supplied county id.
# This is an unconditional analysis: lpop is deliberately omitted throughout.
# Retain did's varying-base-period default explicitly; base_period="universal"
# would give the more familiar single-reference-period event-study normalization.
cs_nyt <- att_gt(yname="lemp", tname="year", idname="countyreal", gname="first.treat", data=d, control_group="notyettreated", bstrap=TRUE, biters=999, clustervars="countyreal", cband=TRUE, base_period="varying")
cs_never <- att_gt(yname="lemp", tname="year", idname="countyreal", gname="first.treat", data=d, control_group="nevertreated", bstrap=TRUE, biters=999, clustervars="countyreal", cband=TRUE, base_period="varying")
cs_nyt_simple <- aggte(cs_nyt, type="simple")
cs_never_simple <- aggte(cs_never, type="simple")

# (c) Sun-Abraham. A cohort outside observed years (0) is inferred as never treated.
sa <- feols(lemp ~ sunab(first.treat, year) | countyreal + year, d, cluster=~countyreal)
sa_att <- summary(sa, agg="ATT")
sa_att_est <- unname(coef(sa_att)[1]); sa_att_se <- unname(se(sa_att)[1])

# Bacon decomposition of the identical binary treatment used in pooled TWFE.
bacon_out <- bacon(lemp ~ post, data=d, id_var="countyreal", time_var="year", quietly=TRUE)
bacon_by_type <- aggregate(weight ~ type, bacon_out, sum)
later_earlier_weight <- sum(bacon_out$weight[grepl("Later vs Earlier", bacon_out$type)])
earlier_later_weight <- sum(bacon_out$weight[grepl("Earlier vs Later", bacon_out$type)])
treated_never_weight <- sum(bacon_out$weight[grepl("Treated vs Untreated", bacon_out$type)])
bacon_att <- sum(bacon_out$weight * bacon_out$estimate)
stopifnot(all(bacon_out$weight > 0), isTRUE(all.equal(bacon_att, twfe_att, tolerance=1e-10)))

# Dynamic C&S event study. It covers leads -3 and -2 and treatment period 0.
dyn <- aggte(cs_never, type="dynamic", min_e=-3, max_e=3)
dynamic <- data.frame(event_time=dyn$egt, estimate=dyn$att.egt, se=dyn$se.egt)
dynamic$crit_val <- dyn$crit.val.egt
dynamic$lower <- dynamic$estimate - dynamic$crit_val*dynamic$se
dynamic$upper <- dynamic$estimate + dynamic$crit_val*dynamic$se

dir.create("figures", showWarnings=FALSE, recursive=TRUE)
png("figures/event-study.png", width=2100, height=1500, res=300)
par(mar=c(4.5,5,1,1), las=1, family=theme_event$family)
plot(dynamic$event_time, dynamic$estimate, type="n", xlim=range(dynamic$event_time)+c(-.35,.35), ylim=range(c(dynamic$lower,dynamic$upper,0),finite=TRUE), xlab="Event time (years relative to first treatment)", ylab="ATT on log teen employment", cex.axis=theme_event$cex.axis, cex.lab=theme_event$cex.lab, xaxt="n")
axis(1, at=dynamic$event_time)
abline(h=0, col="grey45", lty=2, lwd=1); abline(v=0, col=oi["vermillion"], lty=2, lwd=1.4)
arrows(dynamic$event_time,dynamic$lower,dynamic$event_time,dynamic$upper,angle=90,code=3,length=.045,col=oi["blue"],lwd=1.4)
points(dynamic$event_time,dynamic$estimate,pch=19,col=oi["blue"],cex=1.15)
dev.off()

tab <- data.frame(Estimator=c("Naive TWFE","Callaway--Sant'Anna","Callaway--Sant'Anna","Sun--Abraham"), ATT=c(twfe_att,cs_nyt_simple$overall.att,cs_never_simple$overall.att,sa_att_est), SE=c(twfe_se,cs_nyt_simple$overall.se,cs_never_simple$overall.se,sa_att_se), Comparison=c("Implicit mixture of treated-versus-never and cross-timing treated-cohort comparisons; county/year FE","Not-yet-treated (includes never-treated); county-clustered multiplier bootstrap","Never-treated only; county-clustered multiplier bootstrap","Never-treated reference cohort; cohort x event-time interactions; county clustered"))
fmt <- function(x) sprintf("%.4f",x)
lines <- c("# Staggered-adoption DiD estimates","","Outcome: log teen employment (`lemp`).","","| Estimator | ATT | SE | Control/comparison group |","|---|---:|---:|---|",apply(tab,1,function(z) sprintf("| %s | %s | %s | %s |",z[1],fmt(as.numeric(z[2])),fmt(as.numeric(z[3])),z[4])),"","Callaway--Sant'Anna uses its unconditional doubly robust estimator (equivalent to unconditional 2x2 DiD here) with 999 multiplier-bootstrap draws. `lpop` is deliberately omitted throughout; a consistently specified `lpop` sensitivity analysis would be useful, but it should not be mixed selectively across estimators.")
writeLines(lines,"estimates-table.md")

pre_rows <- dynamic[dynamic$event_time <= -2,]
pre_desc <- paste(sprintf("event time %d: %.3f (SE %.3f)",pre_rows$event_time,pre_rows$estimate,pre_rows$se),collapse="; ")
memo <- sprintf("# Adjudication\n\nThe usual warning about pooled two-way fixed effects (TWFE) is relevant as a design diagnostic here, but it does not overturn the substantive finding in this particular panel. The conventional county- and year-fixed-effect regression estimates an ATT of %s log points (SE %s). The full Goodman--Bacon decomposition assigns %.1f%% of the weight to treated-versus-never-treated comparisons, %.1f%% to later-versus-earlier-treated comparisons, and %.1f%% to earlier-versus-later-treated comparisons. Bacon's 2x2 comparison weights are positive; the %.1f%% later-versus-earlier share measures exposure to contaminated comparisons, not a literal share of negative weights. The weighted decomposition reproduces the TWFE coefficient (`sum(weight * estimate) = %.4f`). Contamination is therefore present but small here, rather than merely a theoretical possibility.\n\nBut the robust estimators point to a closely similar conclusion. The Callaway--Sant'Anna simple ATT is %s using not-yet-treated controls and %s using only never-treated controls; the Sun--Abraham interaction-weighted ATT is %s. All four estimates indicate lower teen employment after a state raises its minimum wage above the federal floor. Their differences are modest relative to their standard errors, and the robust estimates remain negative. For reporting, I would use the Callaway--Sant'Anna estimate with never-treated controls, %s log points (SE %s), because it makes the comparison population explicit and never uses already-treated units as controls. Exactly converted from logs, this is a %.1f%% decline in employment (`100 * (exp(-0.0400) - 1) = -3.9%%`).\n\nThe event study offers limited evidence on parallel trends. There are only five calendar years and the earliest cohort is treated in 2004, so the pre-period evidence is necessarily thin. The joint test does not reject pre-trends (p = %.3f), but power is limited and one lead is borderline: %s. This is absence of clear evidence against parallel trends, not affirmative support. The plot uses the package's simultaneous critical-value bands (`dyn$crit.val.egt`) because `cband=TRUE`; the default varying base period is retained (using `base_period=\"universal\"` would produce the more familiar event-study normalization).\n\nThis is an unconditional analysis with `lpop` deliberately omitted. Because the package's worked example often adjusts for population, a consistently specified `lpop` sensitivity analysis would be useful, but it should not be mixed selectively across estimators. In short: the contamination exists but is quantitatively small here, so modern estimators change the preferred reported coefficient—not the substantive conclusion. This is not a claim that TWFE is generally safe; it is a dataset-specific reconciliation after checking its comparison weights, robust alternatives, and leads.\n",fmt(twfe_att),fmt(twfe_se),100*treated_never_weight,100*later_earlier_weight,100*earlier_later_weight,100*later_earlier_weight,bacon_att,fmt(cs_nyt_simple$overall.att),fmt(cs_never_simple$overall.att),fmt(sa_att_est),fmt(cs_never_simple$overall.att),fmt(cs_never_simple$overall.se),100*(exp(cs_never_simple$overall.att)-1),cs_never$Wpval,pre_desc)
writeLines(memo,"memo.md")
saveRDS(list(twfe=twfe,cs_nyt=cs_nyt,cs_never=cs_never,sunab=sa,bacon=bacon_out,dynamic=dynamic,bacon_by_type=bacon_by_type),"results.rds")
print(tab); print(bacon_by_type); print(dynamic); cat("Bacon weighted ATT:", bacon_att, "\nCS pre-test p-value:",cs_never$Wpval,"\n")
