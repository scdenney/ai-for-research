#!/usr/bin/env Rscript

# Fixed LaLonde specification-curve analysis.
# The uncertainty intervals condition on the estimated propensity score/match.

library(causaldata)
library(MatchIt)
library(ggplot2)
library(sandwich)

set.seed(4601)

# Okabe-Ito palette and a compact, legible plotting theme.
oi <- c(orange = "#E69F00", sky_blue = "#56B4E9", bluish_green = "#009E73",
        yellow = "#F0E442", blue = "#0072B2", vermillion = "#D55E00",
        reddish_purple = "#CC79A7", black = "#000000")
theme_spec <- theme_minimal(base_size = 11) +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        plot.title = element_blank(),
        plot.caption = element_text(hjust = 0, colour = "#333333"))

fmt_dollar <- function(x) {
  sign <- ifelse(x < 0, "-", "")
  paste0(sign, "$", format(abs(round(x)), big.mark = ",", trim = TRUE))
}
fmt_ci <- function(lo, hi) paste0("[", fmt_dollar(lo), ", ", fmt_dollar(hi), "]")

fit_effect <- function(dat, weighted = FALSE) {
  fit <- if (weighted) lm(re78 ~ treat, data = dat, weights = weights) else lm(re78 ~ treat, data = dat)
  est <- unname(coef(fit)["treat"])
  se <- sqrt(unname(vcovHC(fit, type = "HC2")["treat", "treat"]))
  z <- qnorm(0.975)
  c(estimate = est, se = se, lower = est - z * se, upper = est + z * se)
}

nsw <- as.data.frame(causaldata::nsw_mixtape)
cps <- as.data.frame(causaldata::cps_mixtape)

# Experimental treated-minus-control benchmark, deliberately estimated rather than entered.
benchmark_fit <- fit_effect(nsw)
benchmark <- benchmark_fit["estimate"]

treated <- nsw[nsw$treat == 1, ]
controls <- cps[cps$treat == 0, ]
obs <- rbind(treated, controls)
obs$u74 <- as.integer(obs$re74 == 0)
obs$u75 <- as.integer(obs$re75 == 0)

formulas <- list(
  Demographics = treat ~ age + I(age^2) + educ + I(educ^2) + black + hisp + marr + nodegree,
  `Demographics + earnings` = treat ~ age + I(age^2) + educ + I(educ^2) + black + hisp + marr + nodegree +
    re74 + re75 + I(re74^2) + I(re75^2) + u74 + u75
)

results <- list()
naive <- fit_effect(obs)
results[[1]] <- data.frame(
  specification = "Naive raw difference", estimator = "Raw difference", covariates = "None",
  support = "No trim", estimate = naive["estimate"], se = naive["se"],
  lower = naive["lower"], upper = naive["upper"], benchmark = benchmark,
  gap = naive["estimate"] - benchmark, treated_n = sum(obs$treat == 1),
  control_n = sum(obs$treat == 0), control_ess = sum(obs$treat == 0), stringsAsFactors = FALSE
)

for (cov_name in names(formulas)) {
  for (support_name in c("No trim", "Common support")) {
    discard_value <- if (support_name == "No trim") "none" else "both"
    reestimate_value <- support_name == "Common support"
    for (estimator_name in c("1-NN replacement", "5 strata")) {
      if (estimator_name == "1-NN replacement") {
        m <- matchit(formulas[[cov_name]], data = obs, method = "nearest", distance = "glm",
                     estimand = "ATT", replace = TRUE, ratio = 1, m.order = "closest",
                     discard = discard_value, reestimate = reestimate_value)
      } else {
        m <- matchit(formulas[[cov_name]], data = obs, method = "subclass", distance = "glm",
                     estimand = "ATT", subclass = 5, discard = discard_value,
                     reestimate = reestimate_value)
      }
      md <- match.data(m, drop.unmatched = TRUE)
      effect <- fit_effect(md, weighted = TRUE)
      control_weights <- md$weights[md$treat == 0]
      results[[length(results) + 1]] <- data.frame(
        specification = paste(cov_name, support_name, estimator_name, sep = " — "),
        estimator = estimator_name, covariates = cov_name, support = support_name,
        estimate = effect["estimate"], se = effect["se"], lower = effect["lower"],
        upper = effect["upper"], benchmark = benchmark, gap = effect["estimate"] - benchmark,
        treated_n = sum(md$treat == 1), control_n = sum(md$treat == 0),
        control_ess = sum(control_weights)^2 / sum(control_weights^2), stringsAsFactors = FALSE
      )
    }
  }
}

res <- do.call(rbind, results)
res$specification <- factor(res$specification, levels = res$specification)

# Markdown specification table.
table_lines <- c(
  "# Fixed LaLonde specification curve",
  "",
  "All amounts are 1978 dollars. The benchmark is the NSW experimental treated-minus-control contrast.",
  "",
  "| Estimator | Covariates | Support | Estimate | 95% CI | Benchmark | Gap | Treated N | Control N | Control ESS |",
  "|---|---|---|---:|---|---:|---:|---:|---:|---:|"
)
for (i in seq_len(nrow(res))) {
  r <- res[i, ]
  table_lines <- c(table_lines, paste0("| ", r$estimator, " | ", r$covariates, " | ", r$support,
    " | ", fmt_dollar(r$estimate), " | ", fmt_ci(r$lower, r$upper),
    " | ", fmt_dollar(r$benchmark), " | ", fmt_dollar(r$gap), " | ",
    r$treated_n, " | ", r$control_n, " | ", format(round(r$control_ess), big.mark = ",", trim = TRUE), " |"))
}
table_lines <- c(table_lines, "", "## Methods", "",
  "The observational composite contains all 185 NSW treated units and all 15,992 CPS controls. The naive row is an unweighted `lm(re78 ~ treat)`. Each adjusted row uses a propensity-score logit fit by MatchIt with ATT targeting and `distance = \"glm\"`; 1-NN uses replacement, ratio 1, and closest-first matching, while stratification uses exactly five subclasses. No-trim specifications set `discard = \"none\"` and `reestimate = FALSE`; common-support specifications set `discard = \"both\"` and `reestimate = TRUE`. Matched data retain only matched observations. Estimates come from `lm(re78 ~ treat)` using MatchIt weights, with HC2 sandwich standard errors and normal 95% intervals. Control N is the number of unique retained controls; control ESS is sum(w)^2/sum(w^2). These intervals condition on estimated scores and matches; they do not bootstrap nearest-neighbor matching.")
writeLines(table_lines, "spec-table.md")

# The sole figure: all observational estimates and their conditional 95% intervals.
plot_labels <- c("Naive", "Demo / no trim / 1-NN", "Demo / no trim / 5 strata",
  "Demo / common support / 1-NN", "Demo / common support / 5 strata",
  "Demo + earnings / no trim / 1-NN", "Demo + earnings / no trim / 5 strata",
  "Demo + earnings / common support / 1-NN", "Demo + earnings / common support / 5 strata")
plot_dat <- res
plot_dat$label <- factor(plot_labels, levels = plot_labels)
plot_dat$family <- ifelse(plot_dat$covariates == "Demographics + earnings", "Demographics + earnings",
                          ifelse(plot_dat$covariates == "Demographics", "Demographic covariates", "Naive"))
p <- ggplot(plot_dat, aes(x = label, y = estimate, colour = family)) +
  geom_hline(yintercept = benchmark, linewidth = 0.7, colour = oi["black"], linetype = "dashed") +
  geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.18, linewidth = 0.65) +
  geom_point(size = 2.4) +
  scale_colour_manual(values = c("Naive" = unname(oi["orange"]),
                                 "Demographic covariates" = unname(oi["sky_blue"]),
                                 "Demographics + earnings" = unname(oi["bluish_green"])), name = NULL) +
  labs(x = NULL, y = "Estimated ATT on 1978 earnings (dollars)",
       caption = paste0("Points are estimates; bars are HC2 normal 95% intervals. Dashed line: NSW experimental benchmark (", fmt_dollar(benchmark), ").")) +
  theme_spec + theme(legend.position = "top",
                     axis.text.x = element_text(angle = 35, hjust = 1, vjust = 1, size = 8.5))
dir.create("figures", showWarnings = FALSE, recursive = TRUE)
ggsave("figures/spec-curve.png", p, width = 10.5, height = 6.3, dpi = 320, bg = "white")

# Results-bound memo, kept within the requested 430--500-word range.
adjusted <- res[res$estimator != "Raw difference", ]
min_est <- min(adjusted$estimate)
max_est <- max(adjusted$estimate)
closest <- adjusted[which.min(abs(adjusted$gap)), ]
overlap_n <- sum(res$lower <= benchmark & res$upper >= benchmark)
memo <- paste0(
"# Memo: What the fixed specification curve shows\n\n",
"The evidence supports favorable-specification-only recovery, not robust recovery. The experimental NSW benchmark, estimated within the randomized sample by the same regression contrast used throughout, is ", fmt_dollar(benchmark), ". In the observational composite of all 185 NSW participants and 15,992 CPS controls, the raw difference is ", fmt_dollar(res$estimate[1]), ", a gap of ", fmt_dollar(res$gap[1]), ". Across the eight prespecified propensity-score analyses, estimates range from ", fmt_dollar(min_est), " to ", fmt_dollar(max_est), ". The closest adjusted result is ", closest$specification, " at ", fmt_dollar(closest$estimate), ", with a gap of ", fmt_dollar(closest$gap), ". That pattern is not a stable recovery of the experimental contrast across reasonable fixed choices.\n\n",
"Conditioning on the listed pre-treatment covariates makes CPS controls more comparable to NSW treated units on those measured features. The propensity score summarizes those observed predictors for the matching or subclassification step, and the weighted outcome regression then estimates an ATT contrast in the retained, weighted sample. It does not make treatment assignment randomized in CPS, balance unmeasured determinants by assumption alone, or identify the experimental effect when selection remains related to potential 1978 earnings after conditioning. Consequently, agreement with the benchmark in one cell is diagnostic evidence about that specification, not proof that propensity-score matching has generally removed observational bias.\n\n",
"Sensitivity is material on all three requested axes. Adding lagged earnings and zero-earnings indicators changes the adjustment set; matching with replacement and five-score subclassification form different counterfactual comparisons; and common-support trimming changes the analysis population as well as the available controls. In particular, a trimmed estimate targets the ATT for treated units retained after the overlap rule, not necessarily the ATT for all 185 NSW treated units. The control counts and effective sample sizes in the table make clear that nominal CPS abundance does not by itself guarantee the same comparison information under every design.\n\n",
"Exact benchmark recovery and interval overlap are distinct standards. An estimate can miss ", fmt_dollar(benchmark), " exactly while its conditional 95% interval includes it; here ", overlap_n, " of the nine observational intervals include the benchmark. Conversely, interval overlap is not a demonstration of unbiased recovery, especially because these HC2 intervals condition on the estimated propensity scores and selected matches. They do not incorporate score-estimation or matching-design uncertainty, and nearest-neighbor matching has not been bootstrapped.\n\n",
"A paper may claim that specified observed-covariate adjustments can yield estimates compatible with the NSW benchmark in this application, and it may report the full curve and its ATT targets. It may not claim unqualified recovery, causal identification from CPS controls, or robustness to covariate, support, and estimator decisions. The defensible conclusion is narrower: favorable specifications can align with the experiment, but the fixed curve shows that alignment is specification-dependent.\n")
writeLines(memo, "memo.md")

stopifnot(nrow(res) == 9, abs(benchmark - 1794.3423818501) < 0.01)
cat("Conclusion: favorable-specification-only recovery.\n")
cat("Benchmark:", sprintf("%.6f", benchmark), "\n")
cat("Adjusted estimate range:", sprintf("%.6f", min_est), "to", sprintf("%.6f", max_est), "\n")
cat("Artifacts: script.R, figures/spec-curve.png, spec-table.md, memo.md\n")
cat("Acceptance: 9 observational rows; one 320 dpi PNG; memo words:", length(strsplit(gsub("[#`]|\\n", " ", memo), "\\s+")[[1]]), "\n")
