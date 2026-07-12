#!/usr/bin/env Rscript
# =============================================================================
# VHIGH — LaLonde / Dehejia-Wahba / Smith-Todd: does propensity-score matching
# recover the experimental benchmark from observational controls? (judgment tier)
# Run from this directory:  cd reference/vhigh-lalonde && Rscript script.R
#
# Data: causaldata::nsw_mixtape (445 = 185 treated + 260 control; the DW
#   experimental subsample) and causaldata::cps_mixtape (15,992 CPS-1 controls).
# Deliverables: spec-table.md, figures/spec-curve.png
#   (The human-authored grading rubric lives in RUBRIC.md, written separately.)
#
# METHOD NOTE. MatchIt is installed on this machine, but the propensity-score
# matching is HAND-ROLLED in base R + glm on purpose: a reference answer key
# must be exactly reproducible and quote-checkable, must not drift with a
# package's default caliper/ratio/estimand, and must expose the stratification
# estimator (not MatchIt's native output). Every step below is explicit:
# logit propensity model, 1-NN-with-replacement ATT, 5-quintile stratification,
# common-support trimming. A test-taker who instead uses MatchIt must target the
# same estimand (ATT, replace = TRUE) or the numbers will not be comparable.
#
# INFERENCE NOTE. Point estimates are computed ONCE and are deterministic.
# CIs are NOT a naive resampling bootstrap: Abadie & Imbens (2008) prove the
# nonparametric bootstrap is invalid for the variance of nearest-neighbor
# matching estimators. Instead: 1-NN CIs are cluster-robust (matched-pair WLS,
# clustered on unique units so a reused control forms one cluster; the
# MatchIt / Abadie-Spiess 2022 recommended practice); stratification CIs are the
# closed-form treated-weighted combination of within-stratum variances. Both
# EXCLUDE propensity-score-estimation uncertainty and are illustrative — the
# finding is the SPREAD of point estimates across specifications, not any single
# interval. set.seed() is a convention only; nothing here is stochastic.
# =============================================================================

suppressPackageStartupMessages({
  library(ggplot2)
  library(causaldata)
  library(sandwich)   # vcovCL: cluster-robust variance for the matched-pair WLS
  library(lmtest)     # coeftest (loaded for completeness; SE taken from vcovCL)
})

# --- Conventions (site figures skill) ----------------------------------------
okabe_ito <- c(
  black          = "#000000",
  orange         = "#E69F00",
  sky_blue       = "#56B4E9",
  bluish_green   = "#009E73",
  yellow         = "#F0E442",
  blue           = "#0072B2",
  vermillion     = "#D55E00",
  reddish_purple = "#CC79A7"
)
theme_okabe <- theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor   = element_blank(),
    panel.grid.major.x = element_blank(),
    strip.text         = element_text(face = "bold", size = 11),
    axis.title         = element_text(face = "bold"),
    legend.position    = "top",
    plot.margin        = margin(10, 14, 10, 10)
  )

set.seed(46)                       # convention; the analytical path is deterministic
dir.create("figures", showWarnings = FALSE)

# --- Data: build the observational composite ---------------------------------
nsw <- causaldata::nsw_mixtape
cps <- causaldata::cps_mixtape
# Composite = NSW TREATED (185) + CPS controls (15,992). NSW controls are used
# only for the experimental benchmark, never in the observational estimates.
obs <- rbind(nsw[nsw$treat == 1, ], cps)
obs$uid <- seq_len(nrow(obs))      # globally unique id (reused controls share it)
N1 <- sum(obs$treat == 1)
N0 <- sum(obs$treat == 0)

demog <- c("age", "educ", "black", "hisp", "marr", "nodegree")
earn  <- c(demog, "re74", "re75")
allx  <- earn                      # balance is always audited on the full set

# --- (0) Anchors: experimental benchmark and naive observational gap ----------
benchmark <- mean(nsw$re78[nsw$treat == 1]) - mean(nsw$re78[nsw$treat == 0])
naive_obs <- mean(obs$re78[obs$treat == 1]) - mean(obs$re78[obs$treat == 0])

# --- Helpers -----------------------------------------------------------------
fit_ps <- function(d, covs) {
  f <- as.formula(paste("treat ~", paste(covs, collapse = " + ")))
  m <- suppressWarnings(glm(f, data = d, family = binomial))
  list(m = m, ps = as.numeric(predict(m, type = "response")))
}

# common-support trim: keep units inside the overlap of the two pscore ranges
support_keep <- function(d, ps) {
  pt <- ps[d$treat == 1]; pc <- ps[d$treat == 0]
  lo <- max(min(pt), min(pc)); hi <- min(max(pt), max(pc))
  ps >= lo & ps <= hi
}

# 1-NN with replacement on the pscore; returns matched-control index per treated
nn_match <- function(d, ps) {
  t_idx <- which(d$treat == 1); c_idx <- which(d$treat == 0)
  pt <- ps[t_idx]; pc <- ps[c_idx]
  ord <- order(pc); pc_s <- pc[ord]; c_sorted <- c_idx[ord]
  pos  <- findInterval(pt, pc_s, all.inside = TRUE)
  c1 <- pmax(pos, 1); c2 <- pmin(pos + 1, length(pc_s))
  pick <- ifelse(abs(pt - pc_s[c1]) <= abs(pt - pc_s[c2]), c1, c2)
  m_idx <- c_sorted[pick]
  list(t_idx = t_idx, m_idx = m_idx,
       dist  = abs(ps[t_idx] - ps[m_idx]))          # |pscore distance| per pair
}

# ATT + cluster-robust CI from the matched pairs (1-NN with replacement)
att_nn <- function(d, mm) {
  pdf <- data.frame(
    y     = c(d$re78[mm$t_idx], d$re78[mm$m_idx]),
    treat = c(rep(1, length(mm$t_idx)), rep(0, length(mm$m_idx))),
    uid   = c(d$uid[mm$t_idx], d$uid[mm$m_idx])
  )
  fit <- lm(y ~ treat, data = pdf)
  V   <- sandwich::vcovCL(fit, cluster = pdf$uid, type = "HC1")
  att <- unname(coef(fit)["treat"]); se <- sqrt(V["treat", "treat"])
  c(att = att, se = se, lo = att - 1.96 * se, hi = att + 1.96 * se)
}

# ATT + analytic CI from 5 strata (quintiles of treated pscore); treated-weighted
att_strat <- function(d, ps, keep, K = 5) {
  tr <- d$treat == 1
  qs <- quantile(ps[keep & tr], probs = seq(0, 1, length.out = K + 1),
                 names = FALSE)
  qs[1] <- -Inf; qs[length(qs)] <- Inf
  b <- cut(ps, breaks = qs, labels = FALSE, include.lowest = TRUE)
  num <- 0; den <- 0; vnum <- 0
  for (k in seq_len(K)) {
    it <- which(keep & tr & b == k); ic <- which(keep & !tr & b == k)
    if (length(it) > 0 && length(ic) > 1 && length(it) > 1) {
      diff <- mean(d$re78[it]) - mean(d$re78[ic]); w <- length(it)
      num  <- num + w * diff; den <- den + w
      vnum <- vnum + w^2 * (var(d$re78[it]) / length(it) +
                            var(d$re78[ic]) / length(ic))
    }
  }
  att <- num / den; se <- sqrt(vnum) / den
  c(att = att, se = se, lo = att - 1.96 * se, hi = att + 1.96 * se)
}

# max |standardized mean difference| across ALL covariates, post-design.
# Denominator = treated SD (ATT convention). Reused controls weighted by count.
max_smd <- function(d, t_idx, c_idx_weighted) {
  ct <- table(c_idx_weighted)
  cw <- as.integer(ct); ci <- as.integer(names(ct))
  smds <- vapply(allx, function(v) {
    xt <- d[[v]][t_idx]
    xc <- d[[v]][ci]
    mt <- mean(xt)
    mc <- sum(xc * cw) / sum(cw)
    sdt <- sd(xt)
    if (sdt == 0) return(0)
    abs(mt - mc) / sdt
  }, numeric(1))
  max(smds)
}

# --- Run the 8-spec diagnostic sensitivity grid ------------------------------
cov_sets <- list(`Demographics` = demog, `+ Pre-earnings` = earn)
specs <- list()
for (cs in names(cov_sets)) {
  fp <- fit_ps(obs, cov_sets[[cs]]); ps <- fp$ps
  keep_full <- rep(TRUE, nrow(obs))
  keep_trim <- support_keep(obs, ps)

  for (sup in c("Full", "Trimmed")) {
    keep <- if (sup == "Full") keep_full else keep_trim
    dk   <- obs[keep, ]; psk <- ps[keep]

    # 1-NN with replacement
    mm  <- nn_match(dk, psk)
    e   <- att_nn(dk, mm)
    smd <- max_smd(dk, mm$t_idx, mm$m_idx)
    specs[[length(specs) + 1]] <- data.frame(
      cov = cs, est = "1-NN matching", support = sup,
      att = e["att"], se = e["se"], lo = e["lo"], hi = e["hi"],
      n_t = length(mm$t_idx), n_c = length(unique(mm$m_idx)),
      dist = mean(mm$dist), max_smd = smd,
      n_drop = sum(!keep), stringsAsFactors = FALSE)

    # stratification (5 quintile strata of treated pscore)
    es  <- att_strat(obs, ps, keep = keep, K = 5)
    lab <- if (sup == "Full") "Stratification*" else "Stratification"
    # post-strata balance summary: treated-weighted control means across strata
    trb <- obs$treat == 1
    qs  <- quantile(ps[keep & trb], probs = seq(0, 1, length.out = 6),
                    names = FALSE); qs[1] <- -Inf; qs[6] <- Inf
    bb  <- cut(ps, breaks = qs, labels = FALSE, include.lowest = TRUE)
    smd_s <- max(vapply(allx, function(v) {
      num <- 0; den <- 0; mt_all <- 0
      for (k in 1:5) {
        it <- which(keep & trb & bb == k); ic <- which(keep & !trb & bb == k)
        if (length(it) > 1 && length(ic) > 1) {
          num <- num + length(it) * mean(obs[[v]][ic]); den <- den + length(it)
          mt_all <- mt_all + length(it) * mean(obs[[v]][it])
        }
      }
      sdt <- sd(obs[[v]][keep & trb]); if (sdt == 0) return(0)
      abs(mt_all / den - num / den) / sdt
    }, numeric(1)))
    specs[[length(specs) + 1]] <- data.frame(
      cov = cs, est = lab, support = sup,
      att = es["att"], se = es["se"], lo = es["lo"], hi = es["hi"],
      n_t = sum(keep & obs$treat == 1), n_c = sum(keep & obs$treat == 0),
      dist = NA_real_, max_smd = smd_s,
      n_drop = sum(!keep), stringsAsFactors = FALSE)
  }
}
S <- do.call(rbind, specs); rownames(S) <- NULL
S$gap <- S$att - benchmark
S$id  <- seq_len(nrow(S))

# --- Figure: point-estimate specification curve ------------------------------
S$estimator <- factor(sub("\\*$", "", S$est),
                      levels = c("1-NN matching", "Stratification"))
S$xlab <- paste0(S$estimator, "\n(", S$support, ")")
S$cov_f <- factor(S$cov, levels = c("Demographics", "+ Pre-earnings"))
S$xlab  <- factor(S$xlab, levels = c("1-NN matching\n(Full)",
                                     "1-NN matching\n(Trimmed)",
                                     "Stratification\n(Full)",
                                     "Stratification\n(Trimmed)"))
# benchmark label: left facet has open space at +$1,794 (all its points are ~-$4k)
bench_lab <- data.frame(
  cov_f = factor("Demographics", levels = c("Demographics", "+ Pre-earnings")),
  xlab  = factor(levels(S$xlab)[1], levels = levels(S$xlab)),
  att   = benchmark, estimator = factor("1-NN matching", levels = levels(S$estimator)),
  label = sprintf("Experimental benchmark (%s)",
                  paste0("+$", format(round(benchmark), big.mark = ","))))

p <- ggplot(S, aes(x = xlab, y = att, colour = estimator)) +
  geom_hline(yintercept = 0, colour = "grey80", linewidth = 0.4) +
  geom_hline(yintercept = benchmark, linetype = "dashed",
             colour = okabe_ito[["black"]], linewidth = 0.6) +
  geom_text(data = bench_lab, aes(x = xlab, y = att, label = label),
            inherit.aes = FALSE, vjust = -0.8, hjust = 0.1, size = 3.3,
            colour = okabe_ito[["black"]], fontface = "bold") +
  geom_linerange(aes(ymin = lo, ymax = hi), linewidth = 0.7) +
  geom_point(size = 3) +
  facet_wrap(~ cov_f) +
  scale_colour_manual(values = c(`1-NN matching`  = okabe_ito[["blue"]],
                                 `Stratification` = okabe_ito[["vermillion"]]),
                      name = NULL) +
  scale_y_continuous(labels = scales::label_dollar(),
                     breaks = seq(-4000, 2000, 1000)) +
  labs(x = NULL,
       y = "Estimated ATT on 1978 earnings (vs experimental benchmark)") +
  theme_okabe +
  theme(axis.text.x = element_text(size = 8.5))

ggsave("figures/spec-curve.png", p, width = 10, height = 6.2,
       dpi = 320, bg = "white")

# --- Write spec-table.md -----------------------------------------------------
d0 <- function(x) paste0(ifelse(x < 0, "-$", "+$"),
                         format(abs(round(x)), big.mark = ",", trim = TRUE))
d0u <- function(x) paste0("$", format(round(x), big.mark = ",", trim = TRUE))

md <- c(
  "# VHIGH — Does propensity-score matching recover the experimental benchmark? (specification table)",
  "",
  "*Reference solution (answer key). Data: `causaldata::nsw_mixtape` (185 treated",
  "+ 260 experimental controls) and `causaldata::cps_mixtape` (15,992 CPS",
  "controls). R 4.5.1. Propensity matching hand-rolled in base R + glm for exact",
  "reproducibility (see `script.R` header). Estimand: ATT on 1978 earnings",
  "(`re78`), dollars. Point estimates deterministic; CIs are cluster-robust",
  "(1-NN) / analytic-stratum (stratification), NOT a bootstrap — see the",
  "inference note below.*",
  "",
  "## 0. The two anchors",
  "",
  "| Quantity | Definition | Value |",
  "|---|---|---:|",
  sprintf("| **Experimental benchmark** | mean `re78`, NSW treated (185) − NSW control (260) | **%s** |", d0(benchmark)),
  sprintf("| **Naive observational** | mean `re78`, NSW treated (185) − CPS controls (15,992) | **%s** |", d0(naive_obs)),
  "",
  sprintf(paste0("The experiment says the program raised 1978 earnings by about **%s**.",
                 " Simply differencing the NSW treated against the CPS pool gives **%s** —",
                 " wrong in sign and off by roughly **%s**, because the CPS controls are",
                 " older, better-educated, far more often married, mostly not Black, and",
                 " earn ~$14k vs ~$2k pre-program. The question is whether conditioning on",
                 " observables via the propensity score closes that gap."),
          d0(benchmark), d0(naive_obs), d0u(abs(naive_obs - benchmark))),
  "",
  "## 1. The specification grid (ATT vs the benchmark)",
  "",
  "Eight specifications: covariate set {demographics; + pre-earnings `re74`,`re75`}",
  "× estimator {1-NN with replacement; 5-quintile stratification} × support {full;",
  "trimmed to common support}.",
  "",
  "| # | Covariates | Estimator | Support | ATT (95% CI) | Gap vs benchmark |",
  "|---|---|---|---|---:|---:|"
)
for (i in S$id) {
  r <- S[i, ]
  md <- c(md, sprintf("| %d | %s | %s | %s | %s [%s, %s] | %s |",
    r$id, r$cov, r$est, r$support,
    d0(r$att), d0(r$lo), d0(r$hi), d0(r$gap)))
}
md <- c(md,
  "",
  "\\* **Unrestricted stratification** (full support): the outer strata absorb",
  "CPS controls whose pscore lies below the treated range, so the endpoint",
  "subclass means include plainly non-comparable controls. Read it as a",
  "diagnostic of what happens when overlap is ignored, not as an equally",
  "defensible estimator.",
  "",
  "## 2. Per-specification diagnostics (why the estimates move)",
  "",
  "Balance is audited on **all eight covariates including `re74`/`re75`**, so a",
  "demographics-only model is scored on the earnings imbalance it leaves behind.",
  "Common support by range-intersection is a weak overlap check (it can retain",
  "local sparsity); the retention column reports how much of the CPS pool each",
  "trim discards.",
  "",
  "| # | Covariates | Estimator | Support | Controls used | Max \\|SMD\\| (all covars) | Mean pscore dist. | CPS dropped by trim |",
  "|---|---|---|---|---:|---:|---:|---:|"
)
for (i in S$id) {
  r <- S[i, ]
  dist_s <- if (is.na(r$dist)) "—" else sprintf("%.4f", r$dist)
  md <- c(md, sprintf("| %d | %s | %s | %s | %s | %.2f | %s | %s |",
    r$id, r$cov, r$est, r$support,
    format(r$n_c, big.mark = ","), r$max_smd, dist_s,
    if (r$n_drop == 0) "0" else format(r$n_drop, big.mark = ",")))
}

# pull key cells for the prose
nn_de_full <- S$att[S$cov == "+ Pre-earnings" & S$est == "1-NN matching" & S$support == "Full"]
nn_de_trim <- S$att[S$cov == "+ Pre-earnings" & S$est == "1-NN matching" & S$support == "Trimmed"]
st_de_full <- S$att[S$cov == "+ Pre-earnings" & grepl("Stratification", S$est) & S$support == "Full"]
st_de_trim <- S$att[S$cov == "+ Pre-earnings" & S$est == "Stratification" & S$support == "Trimmed"]
defensible_pe <- c(nn_de_full, nn_de_trim, st_de_trim)   # excludes unrestricted strat.
demog_range <- range(S$att[S$cov == "Demographics"])
smd_demog_nn <- S$max_smd[S$cov == "Demographics" & S$est == "1-NN matching" & S$support == "Full"]
smd_earn_nn  <- S$max_smd[S$cov == "+ Pre-earnings" & S$est == "1-NN matching" & S$support == "Full"]

md <- c(md,
  "",
  "## 3. Reading the grid",
  "",
  sprintf(paste0("**Pre-treatment earnings are the load-bearing covariate.** Every",
                 " demographics-only specification lands between %s and %s — still",
                 " negative, still %s–%s below the benchmark, essentially no better",
                 " than the naive gap in sign. The diagnostic explains why: matching on",
                 " demographics alone leaves a post-match max \\|SMD\\| of **%.2f**,",
                 " driven by the earnings variables it never conditioned on. Adding",
                 " `re74`/`re75` drops that imbalance to **%.2f**."),
          d0(min(demog_range)), d0(max(demog_range)),
          d0u(abs(min(demog_range) - benchmark)), d0u(abs(max(demog_range) - benchmark)),
          smd_demog_nn, smd_earn_nn),
  "",
  sprintf(paste0("**With pre-earnings the estimate is *closer* to the benchmark — but",
                 " how close, and how stably, depends on the estimator and the support.**",
                 " The three well-implemented pre-earnings specifications cluster in a",
                 " narrow **%s–%s** band (1-NN %s full / %s trimmed; stratification %s on",
                 " common support), each landing $%s–$%s *below* the benchmark with a CI",
                 " that still covers it. But the *unrestricted* stratification cell over",
                 " the same score collapses to %s — a **$%s swing** produced by an",
                 " overlap-handling choice alone. Pre-earnings matching gets close; it",
                 " does not pin the benchmark, and a careless support choice can still",
                 " return essentially zero."),
          d0(min(defensible_pe)), d0(max(defensible_pe)),
          d0(nn_de_full), d0(nn_de_trim), d0(st_de_trim),
          format(round(benchmark - max(defensible_pe)), big.mark = ","),
          format(round(benchmark - min(defensible_pe)), big.mark = ","),
          d0(st_de_full),
          format(round(max(defensible_pe) - st_de_full), big.mark = ",")),
  "",
  sprintf(paste0("**The trim asymmetry is empirical, not a law.** Trimming barely moves",
                 " 1-NN here (%s → %s) because a nearest-neighbor rule already draws",
                 " only in-support controls; it moves stratification a lot (%s → %s)",
                 " because subclass means average over every in-stratum control,",
                 " including the poorly-overlapping ones the trim removes. This is a",
                 " property of *these* data and estimators, not a general guarantee that",
                 " nearest-neighbor matching is trim-robust — 1-NN picks the least-distant",
                 " control, which need not be a close one."),
          d0(nn_de_full), d0(nn_de_trim), d0(st_de_full), d0(st_de_trim)),
  "",
  "## 4. The calibrated verdict",
  "",
  paste0("In this CPS-based reconstruction, conditioning on pre-treatment earnings",
         " substantially improves the nearest-neighbor estimate and moves it close to",
         " the experimental benchmark, while a demographics-only model does not. But",
         " agreement with the benchmark is **specification-dependent** — it varies with",
         " estimator and support — so the exercise does **not** establish robust",
         " recovery. Neither slogan survives: not an unconditional \"matching works\"",
         " (Dehejia-Wahba), because the win requires the right conditioning set and a",
         " favorable estimator/support; and not an unconditional \"matching fails\"",
         " (Smith-Todd), because the pre-earnings 1-NN estimates land near the",
         " benchmark and remove most of the naive bias. Matching **helps but does not",
         " settle** LaLonde's critique. And because this is a single CPS-based",
         " comparison sample, it is a sensitivity demonstration, not a complete",
         " historical adjudication of the dispute."),
  "",
  "## Figure",
  "",
  "![Specification curve](figures/spec-curve.png)",
  "",
  sprintf(paste0("**Figure 1.** Estimated ATT of the NSW program on 1978 earnings across",
                 " eight observational specifications, faceted by covariate set; the",
                 " dashed line is the experimental benchmark (%s). Whiskers are 95%%",
                 " intervals (cluster-robust for 1-NN, analytic-stratum for",
                 " stratification) and **exclude propensity-score-estimation",
                 " uncertainty** — the finding is the spread of point estimates across",
                 " specifications, not any single interval. Demographics-only",
                 " specifications (left) sit far below the benchmark; adding pre-treatment",
                 " earnings (right) pulls the 1-NN estimates up to it, but stratification",
                 " over the same score still disagrees."),
          d0(benchmark)),
  ""
)
writeLines(md, "spec-table.md")

# --- Console echo ------------------------------------------------------------
cat("VHIGH complete.\n")
cat(sprintf("  benchmark (experimental)   = %s\n", d0(benchmark)))
cat(sprintf("  naive observational        = %s\n", d0(naive_obs)))
cat("  spec grid (ATT | 95%% CI | gap vs benchmark):\n")
for (i in S$id) {
  r <- S[i, ]
  cat(sprintf("    %d. %-14s %-16s %-8s  %8s  [%8s,%8s]  gap %8s  maxSMD=%.2f\n",
      r$id, r$cov, r$est, r$support,
      d0(r$att), d0(r$lo), d0(r$hi), d0(r$gap), r$max_smd))
}
