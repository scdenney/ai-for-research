# LaLonde NSW--CPS specification curve: corrected support and diagnostics
set.seed(20260717)
library(causaldata)
library(MatchIt)
library(ggplot2)

oi <- c(orange="#E69F00", sky_blue="#56B4E9", bluish_green="#009E73",
        blue="#0072B2", vermillion="#D55E00", black="#000000")
theme_set(theme_minimal(base_size=11) + theme(panel.grid.minor=element_blank(),
  panel.grid.major.y=element_blank(), axis.title.y=element_blank(), legend.position="none"))
dir.create("figures", showWarnings=FALSE)

nsw <- causaldata::nsw_mixtape; cps <- causaldata::cps_mixtape
nsw_t <- nsw[nsw$treat == 1, ]; nsw_c <- nsw[nsw$treat == 0, ]
benchmark <- mean(nsw_t$re78) - mean(nsw_c$re78)
obs <- rbind(nsw_t, cps[cps$treat == 0, ]); obs$treat <- as.integer(obs$treat)
obs$uid <- seq_len(nrow(obs))
demo <- c("age","educ","black","hisp","marr","nodegree")
earn <- c(demo,"re74","re75")

# Conditional-on-design HC variance: realized analysis weights are fixed.  This
# is deliberately not advertised as full sampling inference for NN matching.
fixed_hc <- function(a) {
  tr <- a$treat == 1; wc <- abs(a$w[!tr]); wc <- wc / sum(wc)
  rt <- a$re78[tr] - mean(a$re78[tr])
  rc <- a$re78[!tr] - weighted.mean(a$re78[!tr], wc)
  sqrt(sum((a$w[tr] * rt)^2) + sum((a$w[!tr] * rc)^2))
}
gap_hc <- function(a) {
  wc <- abs(a$w[a$treat == 0]); wc <- wc / sum(wc)
  rc <- a$re78[a$treat == 0] - weighted.mean(a$re78[a$treat == 0], wc)
  rn <- nsw_c$re78 - mean(nsw_c$re78)
  sqrt(sum((rn / nrow(nsw_c))^2) + sum((wc * rc)^2))
}
wvar <- function(x,w) sum(w * (x - weighted.mean(x,w))^2) / sum(w)
max_smd <- function(a, cv) {
  tr <- a$treat == 1; wc <- abs(a$w[!tr]); wc <- wc / sum(wc)
  smd <- vapply(cv, function(v) {
    mt <- mean(a[[v]][tr]); mc <- weighted.mean(a[[v]][!tr], wc)
    den <- sqrt((var(a[[v]][tr]) + wvar(a[[v]][!tr],wc)) / 2)
    if (is.finite(den) && den > 0) abs(mt - mc) / den else 0
  }, numeric(1))
  max(smd)
}
summarize_spec <- function(a, cv) {
  nt <- sum(a$treat == 1); wc <- abs(a$w[a$treat == 0]); wc <- wc / sum(wc)
  est <- sum(a$w * a$re78)
  gap <- if (nt == nrow(nsw_t)) mean(nsw_c$re78) - weighted.mean(a$re78[a$treat == 0], wc) else NA_real_
  gse <- if (nt == nrow(nsw_t)) gap_hc(a) else NA_real_
  c(estimate=est, se=fixed_hc(a), gap=gap, gap_se=gse, n_treated=nt,
    n_controls=sum(a$treat == 0), ess_control=1/sum(wc^2), max_smd=max_smd(a,cv))
}
run_nn <- function(d, cv, trim) {
  m <- matchit(reformulate(cv, "treat"), data=d, method="nearest", distance="glm",
    link="logit", estimand="ATT", replace=TRUE, ratio=1,
    discard=if(trim) "both" else "none")
  gm <- get_matches(m, id=".match_id")
  tu <- unique(gm$uid[gm$treat == 1]); cu <- gm$uid[gm$treat == 0]
  a <- d[d$uid %in% c(tu, unique(cu)), ]
  a$w <- 0
  a$w[a$uid %in% tu] <- 1 / length(tu)
  kk <- table(cu)
  a$w[a$treat == 0] <- -as.numeric(kk[as.character(a$uid[a$treat == 0])]) / length(tu)
  summarize_spec(a, cv)
}
run_strata <- function(d, cv, trim) {
  d$ps <- fitted(glm(reformulate(cv,"treat"), family=binomial(), data=d))
  if (trim) {
    lo <- max(min(d$ps[d$treat==1]), min(d$ps[d$treat==0]))
    hi <- min(max(d$ps[d$treat==1]), max(d$ps[d$treat==0]))
    d <- d[d$ps >= lo & d$ps <= hi, ]
  }
  # No-trim strata cover every CPS score.  Only the four *internal* treated
  # quintiles define bins; score extrema are not implicit support restrictions.
  internal <- unique(as.numeric(quantile(d$ps[d$treat==1], c(.2,.4,.6,.8), type=8)))
  if (length(internal) != 4) stop("too few distinct internal treated-score quintiles")
  d$st <- cut(d$ps, breaks=c(-Inf, internal, Inf), include.lowest=TRUE)
  ntt <- table(d$st[d$treat == 1]); ncc <- table(d$st[d$treat == 0])
  keep <- names(ntt)[ntt > 0 & ncc[names(ntt)] > 0]
  d <- d[as.character(d$st) %in% keep, ]
  nt <- sum(d$treat == 1); d$w <- 0
  for (s in keep) {
    ii <- d$st == s; nts <- sum(d$treat[ii] == 1); ncs <- sum(d$treat[ii] == 0)
    d$w[ii & d$treat == 1] <- 1 / nt
    d$w[ii & d$treat == 0] <- -nts / (nt * ncs)
  }
  summarize_spec(d, cv)
}

raw <- obs; raw$w <- ifelse(raw$treat == 1, 1/sum(raw$treat==1), -1/sum(raw$treat==0))
out <- data.frame(specification="Naive observational difference", estimator="Naive", covariates="None", trimming="None", t(summarize_spec(raw, demo)))
for(nm in c("Demographics", "Demographics + earnings")) for(tr in c(FALSE,TRUE)) {
  cv <- if(nm=="Demographics") demo else earn; tl <- if(tr) "Common-support trim" else "No trim"
  a <- run_nn(obs,cv,tr); b <- run_strata(obs,cv,tr)
  out <- rbind(out,
    data.frame(specification=paste("1-NN:",nm,"/",tl), estimator="1-NN matching",covariates=nm,trimming=tl,t(a)),
    data.frame(specification=paste("Stratification:",nm,"/",tl), estimator="Five score strata",covariates=nm,trimming=tl,t(b)))
}
out$lo <- out$estimate-qnorm(.975)*out$se; out$hi <- out$estimate+qnorm(.975)*out$se
out$gap_lo <- out$gap-qnorm(.975)*out$gap_se; out$gap_hi <- out$gap+qnorm(.975)*out$gap_se

money <- function(x) formatC(x,format="f",digits=1,big.mark=",")
lines <- c("# NSW--CPS specification table", "", sprintf("Experimental benchmark (NSW treated minus NSW control): **%s**.",money(benchmark)), "",
  "| Specification | Estimator | Covariates | Support rule | Estimate | Conditional 95% interval | Gap vs benchmark (conditional 95% interval) | Max \\|SMD\\| | Treated retained | CPS controls | Effective CPS controls |",
  "|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|")
for(i in seq_len(nrow(out))) { x<-out[i,]; lines<-c(lines,sprintf("| %s | %s | %s | %s | %s | [%s, %s] | %s [%s, %s] | %.3f | %d | %d | %.1f |",x$specification,x$estimator,x$covariates,x$trimming,money(x$estimate),money(x$lo),money(x$hi),money(x$gap),money(x$gap_lo),money(x$gap_hi),x$max_smd,x$n_treated,x$n_controls,x$ess_control)) }
writeLines(c(lines,"",
  "`No trim` strata use the four internal treated-score quintiles with `-Inf` and `Inf` boundaries, so every CPS control is eligible. Common-support trimming is applied only in trim rows.",
  "Intervals are fixed-weight HC intervals, conditional on the estimated score and realized matches/strata; they are not full matching-estimator inference. The gap interval respects the shared NSW treated mean: with all 185 treated retained, the gap is the NSW randomized-control mean minus the weighted CPS-control mean. Benchmark inclusion in an estimate-level interval is not a recovery test or equivalence result."),"spec-table.md")

out$specification <- factor(out$specification,levels=rev(out$specification))
p <- ggplot(out,aes(estimate,specification,colour=estimator))+geom_vline(xintercept=benchmark,colour=oi["black"],linetype="dashed",linewidth=.6)+geom_errorbar(aes(xmin=lo,xmax=hi),orientation="y",width=.16,linewidth=.55)+geom_point(size=2.1)+scale_colour_manual(values=c("Naive"=unname(oi["vermillion"]),"1-NN matching"=unname(oi["blue"]),"Five score strata"=unname(oi["bluish_green"])))+labs(x="Estimated ATT on 1978 earnings (USD)")+theme(axis.text.y=element_text(size=8))
ggsave("figures/spec-curve.png",p,width=10,height=5.4,dpi=320)
write.csv(out,"results.csv",row.names=FALSE)
