=== ORIGINAL BRIEF ===
# Task VHIGH — Adjudicate a methods dispute (very-high tier)

You are working in a project directory. Use R (`Rscript`); the `causaldata` package is installed.

**Data.** The LaLonde National Supported Work (NSW) experiment plus the CPS comparison sample:

```r
library(causaldata)
nsw <- causaldata::nsw_mixtape   # 445 obs = 185 treated + 260 control (experimental)
cps <- causaldata::cps_mixtape   # 15,992 CPS controls (observational comparison pool)
# columns (both): data_id treat age educ black hisp marr nodegree re74 re75 re78
```

**Situation.** The NSW experiment gives an unbiased estimate of the program's effect on 1978 earnings (`re78`): the treated−control difference in `nsw_mixtape` (about **+$1,794** — compute it, do not trust the figure). Dehejia and Wahba (1999, 2002) claim propensity-score methods **recover** this experimental benchmark when the experimental controls are discarded and replaced by CPS observational controls (`cps_mixtape`). Smith and Todd (2005) reply that the recovered estimate is **fragile** to the covariate set and the analysis sample. Your job is to run the specification curve and decide which claim the evidence supports.

**Task.**

1. Compute the **experimental benchmark** (treated − control difference in `re78`, within `nsw_mixtape`).
2. Construct the **observational composite** — NSW **treated** units plus CPS **controls** — and estimate the treatment effect on `re78` (a) **naively** (raw treated−control difference) and (b) by **propensity-score matching** under **at least four** specifications. Vary two axes: the **covariate set** (demographics only vs demographics **+ `re74`/`re75`** pre-treatment earnings) and an **estimator detail** (with/without trimming to common support; 1-NN matching vs simple score stratification).
3. Lay the estimates **against the benchmark** in a specification table.
4. **Adjudicate** in `memo.md` (~450 words): does matching recover the benchmark **robustly**, **only under favorable specifications**, or **not at all** — and what may a paper legitimately claim?

**Produce, in the current working directory:**

1. `script.R` — one self-contained script; conventions as in T1/T2 (Okabe-Ito palette and theme at the top; `set.seed()` before anything stochastic).
2. `figures/spec-curve.png` — exactly ONE figure: the estimates with 95% intervals across specifications, the experimental benchmark drawn as a horizontal reference line. 300+ dpi, no in-plot title.
3. `spec-table.md` — every specification's estimate laid against the benchmark (a gap column, or the benchmark side-by-side), plus the naive observational estimate.
4. `memo.md` — the ~450-word adjudication: concede what conditioning on the covariates is and is not doing, state whether recovery is robust / favorable-specification-only / absent, and say precisely what a paper may and may not claim.

**Method note.** `MatchIt` is installed; `Matching` is not. If you use `MatchIt`, target the ATT with replacement (`estimand = "ATT"`, `replace = TRUE`) so it matches the estimand here; if neither package were installed you would hand-roll it (a logit propensity model, 1-NN on the score, with replacement). Choose a **defensible standard error** for each estimator — note that the ordinary nonparametric bootstrap is **not** valid for nearest-neighbor matching variances (Abadie-Imbens 2008).

**Constraints.** At most one revision cycle. If your mode delegates, use at most 3 delegations. No web access. Do not install packages. The memo must not overclaim: if recovery is specification-dependent, say so plainly — neither "matching works" nor "matching fails" unqualified.

=== PRODUCED DELIVERABLES ===
--- advisor-briefing.md ---
# Independent methods review request

I analysed LaLonde's NSW experimental sample and the CPS comparison pool in R.
The experimental treated-minus-control earnings benchmark is $1,794.3. The observational composite is 185 NSW treated units plus 15,992 CPS controls. The raw gap is -$8,497.5.

I fit logistic propensity scores using either demographics (age, education, Black, Hispanic, married, no-degree) or those variables plus pre-treatment earnings (re74, re75). For each covariate set I used 1:1 nearest-neighbour ATT matching with replacement (MatchIt) and five propensity-score strata standardized to the treated distribution, both with and without common-support trimming. Matching estimates are -$2,797.9 with demographics alone and $1,712.2/$1,758.6 with the richer covariates (untrimmed/trimmed). Stratification estimates are -$3,911.7 under demographics alone and $1,252.5 with richer covariates. Trimming has no material effect in most cells because retained matched/stratified units are already inside overlap.

For nearest neighbours, I use a fixed-match heteroskedastic plug-in SE that counts repeated control use, rather than an ordinary bootstrap. Strata use an independent-strata heteroskedastic plug-in SE.

Question: Is the proper adjudication that matching recovers the benchmark only under favourable specifications, and what cautions must the memo state about conditioning, overlap, estimands, and inference? Please flag any material methodological issue in this conclusion.

--- memo.md ---
# Adjudication: NSW treated versus CPS controls

The experimental benchmark is $1,794.3: mean 1978 earnings among the 185 NSW treated units minus mean earnings among the 260 randomized NSW controls. Replacing those controls with 15,992 CPS controls produces a raw difference of -$8,497.5. The comparison is therefore badly confounded before any adjustment: CPS members differ from program participants in ways that are strongly related to earnings.

The specification curve supports the Smith--Todd qualification. Matching does **not** recover the benchmark robustly across reasonable versions of the analysis. With demographic covariates alone, both procedures miss the experimental result by thousands of dollars: 1-NN matching gives -$2,797.9 and score stratification gives -$3,911.7. Adding the two pre-treatment earnings measures changes the result substantially. Nearest-neighbour matching then gives $1,712.2 without trimming and $1,758.6 with common-support trimming, both close in point estimate to the experiment. But the equally simple five-stratum estimator with that same richer score gives $1,252.5, about $542 below the benchmark (its fairly wide interval includes the benchmark). Thus the defensible conclusion is recovery **only under favourable specifications**, not a general success of propensity-score matching on this comparison sample.

Conditioning here is doing something concrete but limited. Age, education, race/ethnicity, marital status, schooling completion, and especially prior earnings are used to make the CPS controls resemble NSW treated units on observed, pre-treatment predictors of treatment selection and later earnings. The large movement after adding `re74` and `re75` shows that these variables carry consequential selection information. It does not show that the propensity score has made treatment as-if random. Balance on included covariates is not balance on unmeasured labor-market history, motivation, local conditions, or measurement differences; nor does it repair lack of overlap. The trimming variants define an ATT for the treated units retained in the common-support region, so they can also change the target population. Here trimming has little practical effect on several estimates, rather than furnishing evidence that the broader identification claim is secure.

The intervals are descriptive sampling-uncertainty calculations appropriate to the implemented estimators: for 1-NN they use a fixed-match, heteroskedastic plug-in variance that counts re-used CPS controls, rather than an ordinary nonparametric bootstrap (which is not valid for nearest-neighbour matching). They should not be read as resolving design uncertainty from covariate choice, score-model choice, or the observational identifying assumption.

A paper may accurately say that a particular ATT implementation--1-NN matching with replacement using demographics plus lagged earnings--closely reproduces the NSW experimental contrast in this dataset. It may use that as a useful diagnostic or illustrative replication. It may not claim, without qualification, that propensity-score matching recovers the experimental effect, that conditioning eliminates selection bias, or that success transfers to other comparison samples, outcomes, or specifications. The figure and table should be reported with the favorable estimate alongside the adverse specifications, not as a post hoc selection of the one estimate that agrees with the experiment.

--- spec-table.md ---
# NSW--CPS specification table

Experimental benchmark (NSW treated minus NSW control): **1,794.3**.

| Specification | Estimator | Covariates | Support rule | Estimate | 95% interval | Gap vs. benchmark | Treated | Controls |
|---|---|---|---|---:|---:|---:|---:|---:|
| Naive observational difference | Naive | None | None | -8,497.5 | [-9,641.0, -7,354.0] | -10,291.9 | 185 | 15992 |
| 1-NN: Demographics / No trim | 1-NN matching | Demographics | No trim | -2,797.9 | [-5,005.7, -590.1] | -4,592.3 | 185 | 120 |
| Stratification: Demographics / No trim | Five score strata | Demographics | No trim | -3,911.7 | [-5,225.5, -2,598.0] | -5,706.1 | 185 | 12706 |
| 1-NN: Demographics / Common-support trim | 1-NN matching | Demographics | Common-support trim | -2,797.9 | [-5,005.7, -590.1] | -4,592.3 | 185 | 120 |
| Stratification: Demographics / Common-support trim | Five score strata | Demographics | Common-support trim | -3,911.7 | [-5,225.5, -2,598.0] | -5,706.1 | 185 | 12706 |
| 1-NN: Demographics + earnings / No trim | 1-NN matching | Demographics + earnings | No trim | 1,712.2 | [46.3, 3,378.0] | -82.2 | 185 | 127 |
| Stratification: Demographics + earnings / No trim | Five score strata | Demographics + earnings | No trim | 1,252.5 | [-13.4, 2,518.4] | -541.8 | 185 | 5776 |
| 1-NN: Demographics + earnings / Common-support trim | 1-NN matching | Demographics + earnings | Common-support trim | 1,758.6 | [91.4, 3,425.8] | -35.8 | 185 | 127 |
| Stratification: Demographics + earnings / Common-support trim | Five score strata | Demographics + earnings | Common-support trim | 1,252.5 | [-13.4, 2,518.4] | -541.8 | 185 | 5776 |

Intervals are estimate +/- 1.96 standard errors. NN intervals use a fixed-match heteroskedastic plug-in variance that accounts for CPS-control reuse, not bootstrap inference.

--- script.R ---
# LaLonde NSW--CPS specification curve
set.seed(20260717)
library(causaldata)
library(MatchIt)
library(ggplot2)

# Okabe-Ito palette and plotting theme.
oi <- c(orange="#E69F00", sky_blue="#56B4E9", bluish_green="#009E73",
        blue="#0072B2", vermillion="#D55E00", black="#000000")
theme_set(theme_minimal(base_size=11) + theme(panel.grid.minor=element_blank(),
  panel.grid.major.y=element_blank(), axis.title.y=element_blank(), legend.position="none"))
dir.create("figures", showWarnings=FALSE)

nsw <- causaldata::nsw_mixtape; cps <- causaldata::cps_mixtape
benchmark <- with(nsw, mean(re78[treat==1])-mean(re78[treat==0]))
obs <- rbind(nsw[nsw$treat==1,], cps[cps$treat==0,]); obs$treat <- as.integer(obs$treat)
diff_se <- function(y,z) sqrt(var(y[z==1])/sum(z==1) + var(y[z==0])/sum(z==0))

# Fixed-match plug-in SE counts every reuse of a CPS control. This is used
# instead of an ordinary bootstrap, which is invalid for NN matching.
nn_se <- function(gm) {
  tr <- gm[gm$treat==1,]; co <- gm[gm$treat==0,]; nt <- nrow(tr)
  uco <- co[!duplicated(co$.unit_id),]; ct <- as.numeric(table(co$.unit_id)[as.character(uco$.unit_id)])
  sqrt(var(tr$re78)/nt + sum(ct^2)*var(uco$re78)/nt^2)
}
run_nn <- function(d, cv, trim) {
  m <- matchit(reformulate(cv, "treat"), data=d, method="nearest", distance="glm",
    link="logit", estimand="ATT", replace=TRUE, ratio=1,
    discard=if(trim) "both" else "none")
  md <- match.data(m); gm <- get_matches(m, id=".unit_id")
  est <- with(md, weighted.mean(re78[treat==1],weights[treat==1])-weighted.mean(re78[treat==0],weights[treat==0]))
  c(estimate=est,se=nn_se(gm),n_treated=sum(gm$treat==1),n_controls=length(unique(gm$.unit_id[gm$treat==0])))
}
run_strata <- function(d, cv, trim) {
  d$ps <- fitted(glm(reformulate(cv,"treat"), family=binomial(), data=d))
  if(trim) { lo <- max(min(d$ps[d$treat==1]),min(d$ps[d$treat==0])); hi <- min(max(d$ps[d$treat==1]),max(d$ps[d$treat==0])); d <- d[d$ps>=lo & d$ps<=hi,] }
  br <- unique(quantile(d$ps[d$treat==1],seq(0,1,.2),type=8)); if(length(br)<6) stop("too few score values")
  d$st <- cut(d$ps,br,include.lowest=TRUE); ss <- split(d,d$st)
  ss <- ss[vapply(ss,function(x) all(table(factor(x$treat,levels=0:1))>0),logical(1))]
  nt <- vapply(ss,function(x) sum(x$treat==1),numeric(1)); w <- nt/sum(nt)
  dd <- vapply(ss,function(x) mean(x$re78[x$treat==1])-mean(x$re78[x$treat==0]),numeric(1))
  vv <- vapply(ss,function(x) { a<-x$re78[x$treat==1]; b<-x$re78[x$treat==0]; var(a)/length(a)+var(b)/length(b) },numeric(1))
  c(estimate=sum(w*dd),se=sqrt(sum(w^2*vv)),n_treated=sum(nt),n_controls=sum(vapply(ss,function(x)sum(x$treat==0),numeric(1))))
}

demo <- c("age","educ","black","hisp","marr","nodegree"); earn <- c(demo,"re74","re75")
out <- data.frame(specification="Naive observational difference",estimator="Naive",covariates="None",trimming="None",
  estimate=with(obs,mean(re78[treat==1])-mean(re78[treat==0])),se=with(obs,diff_se(re78,treat)),n_treated=sum(obs$treat==1),n_controls=sum(obs$treat==0))
for(nm in c("Demographics","Demographics + earnings")) for(tr in c(FALSE,TRUE)) {
  cv <- if(nm=="Demographics") demo else earn; tl <- if(tr) "Common-support trim" else "No trim"
  a <- run_nn(obs,cv,tr); b <- run_strata(obs,cv,tr)
  out <- rbind(out,data.frame(specification=paste("1-NN:",nm,"/",tl),estimator="1-NN matching",covariates=nm,trimming=tl,t(a)),data.frame(specification=paste("Stratification:",nm,"/",tl),estimator="Five score strata",covariates=nm,trimming=tl,t(b)))
}
out$lo <- out$estimate-qnorm(.975)*out$se; out$hi <- out$estimate+qnorm(.975)*out$se; out$gap <- out$estimate-benchmark

lines <- c("# NSW--CPS specification table","",sprintf("Experimental benchmark (NSW treated minus NSW control): **%s**.",formatC(benchmark,format="f",digits=1,big.mark=",")),"","| Specification | Estimator | Covariates | Support rule | Estimate | 95% interval | Gap vs. benchmark | Treated | Controls |","|---|---|---|---|---:|---:|---:|---:|---:|")
for(i in seq_len(nrow(out))) { x<-out[i,]; lines<-c(lines,sprintf("| %s | %s | %s | %s | %s | [%s, %s] | %s | %d | %d |",x$specification,x$estimator,x$covariates,x$trimming,formatC(x$estimate,format="f",digits=1,big.mark=","),formatC(x$lo,format="f",digits=1,big.mark=","),formatC(x$hi,format="f",digits=1,big.mark=","),formatC(x$gap,format="f",digits=1,big.mark=","),x$n_treated,x$n_controls)) }
writeLines(c(lines,"","Intervals are estimate +/- 1.96 standard errors. NN intervals use a fixed-match heteroskedastic plug-in variance that accounts for CPS-control reuse, not bootstrap inference."),"spec-table.md")

out$specification <- factor(out$specification,levels=rev(out$specification))
p <- ggplot(out,aes(estimate,specification,colour=estimator))+geom_vline(xintercept=benchmark,colour=oi["black"],linetype="dashed",linewidth=.6)+geom_errorbar(aes(xmin=lo,xmax=hi),orientation="y",width=.16,linewidth=.55)+geom_point(size=2.1)+scale_colour_manual(values=c("Naive"=unname(oi["vermillion"]),"1-NN matching"=unname(oi["blue"]),"Five score strata"=unname(oi["bluish_green"])))+labs(x="Estimated ATT on 1978 earnings (USD)")+theme(axis.text.y=element_text(size=8))
ggsave("figures/spec-curve.png",p,width=9,height=5.4,dpi=320)
write.csv(out,"results.csv",row.names=FALSE)

=== QUESTION ===
This is a completed submission against the brief above. What would you change?
