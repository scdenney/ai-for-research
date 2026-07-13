#!/usr/bin/env Rscript
# ---------------------------------------------------------------------------
# AJR (2001) instrumental-variables replication + robustness/stress test
#
# Structural model: logpgp95 ~ avexpr, with avexpr instrumented by logem4
# (log settler mortality). Controls, when added, enter BOTH stages (as
# exogenous regressors and as instruments). Five specifications are run:
#   1. base            (full sample, no controls)
#   2. add latitude    (+ lat_abst)
#   3. add continents  (+ africa + asia)
#   4. drop neo-Europes (drop AUS, CAN, NZL, USA)
#   5. Africa only     (africa == 1)
#
# Estimation path: 2SLS via AER::ivreg (available in this environment); the
# first-stage F is the F-test on the excluded instrument logem4 in the first
# stage, controls partialled out (car::linearHypothesis(fs, "logem4 = 0")$F[2]).
#
# OLS/2SLS point estimates are deterministic given the data; set.seed() is
# included anyway per house convention (no stochastic step depends on it).
# ---------------------------------------------------------------------------

suppressPackageStartupMessages({
  library(ivdoctr)
  library(AER)
  library(car)
  library(ggplot2)
})

okabe_ito <- c("#E69F00","#56B4E9","#009E73","#F0E442","#0072B2","#D55E00","#CC79A7","#000000")

theme_report <- theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold"),
    legend.position = "none"
  )
theme_set(theme_report)

set.seed(20260713)

dir.create("figures", showWarnings = FALSE)

# ---- data -------------------------------------------------------------
data(colonial, package = "ivdoctr")
d0 <- as.data.frame(colonial)                       # 64 rows; data.table -> data.frame
d0 <- d0[complete.cases(d0[, c("logpgp95", "avexpr", "logem4")]), ]  # base sample = 64

# ---- generic spec runner -----------------------------------------------
# controls: character vector of control variable names (added to both
# stages as exogenous regressors/instruments), or character(0) for none.
run_spec <- function(dat, controls, label) {
  rhs_struct <- paste(c("avexpr", controls), collapse = " + ")
  rhs_inst   <- paste(c("logem4", controls), collapse = " + ")
  form <- as.formula(paste0("logpgp95 ~ ", rhs_struct, " | ", rhs_inst))

  ols_form <- as.formula(paste0("logpgp95 ~ ", rhs_struct))
  ols_fit  <- lm(ols_form, data = dat)
  ols_coef <- unname(coef(ols_fit)["avexpr"])

  iv_fit   <- ivreg(form, data = dat)
  iv_coef  <- unname(coef(iv_fit)["avexpr"])

  fs_form <- as.formula(paste0("avexpr ~ ", rhs_inst))
  fs_fit  <- lm(fs_form, data = dat)
  fs_coef <- unname(coef(fs_fit)["logem4"])
  fs_F    <- linearHypothesis(fs_fit, "logem4 = 0")$F[2]

  data.frame(
    spec       = label,
    n          = nrow(dat),
    ols_coef   = ols_coef,
    iv_coef    = iv_coef,
    fs_coef    = fs_coef,
    fs_F       = fs_F,
    weak       = fs_F < 10,
    stringsAsFactors = FALSE
  )
}

# ---- five specifications -------------------------------------------------
specs <- list(
  list(dat = d0, controls = character(0), label = "base"),
  list(dat = d0, controls = "lat_abst", label = "add latitude"),
  list(dat = d0, controls = c("africa", "asia"), label = "add continents"),
  list(dat = d0[!(d0$shortnam %in% c("AUS", "CAN", "NZL", "USA")), ],
       controls = character(0), label = "drop neo-Europes"),
  list(dat = d0[d0$africa == 1, ], controls = character(0), label = "Africa only")
)

results <- do.call(rbind, lapply(specs, function(s) run_spec(s$dat, s$controls, s$label)))
rownames(results) <- NULL

print(results)

# ---- write robustness-table.md ------------------------------------------
ident <- ifelse(results$spec %in% c("base", "add latitude"), "strong",
          ifelse(results$spec == "add continents", "marginal",
          ifelse(results$spec == "drop neo-Europes", "weak — F<10",
          ifelse(results$spec == "Africa only", "collapsed", NA))))

fmt3 <- function(x) formatC(x, format = "f", digits = 3)
fmt2 <- function(x) formatC(x, format = "f", digits = 2)

md_lines <- c(
  "| Specification | n | OLS β(avexpr) | 2SLS β(avexpr) | First-stage coef (logem4) | First-stage F | Identification |",
  "|---|---|---|---|---|---|---|"
)
for (i in seq_len(nrow(results))) {
  md_lines <- c(md_lines, sprintf(
    "| %s | %d | %s | %s | %s | %s | %s |",
    results$spec[i], results$n[i],
    fmt3(results$ols_coef[i]), fmt3(results$iv_coef[i]),
    fmt3(results$fs_coef[i]), fmt2(results$fs_F[i]),
    ident[i]
  ))
}
md_lines <- c(
  md_lines,
  "",
  "F is the first-stage F on the excluded instrument logem4; rule of thumb F<10 = weak; 2SLS estimates in weakly/un-identified specs are not reliable and are shown for completeness only."
)
writeLines(md_lines, "robustness-table.md")

# ---- optional figure: first-stage F by spec ------------------------------
plot_df <- results
plot_df$spec <- factor(plot_df$spec, levels = rev(results$spec))
plot_df$strength <- ifelse(plot_df$weak, "weak (F<10)", "strong/marginal")

p <- ggplot(plot_df, aes(x = fs_F, y = spec, color = strength)) +
  geom_vline(xintercept = 10, linetype = "dashed", color = "grey50") +
  geom_point(size = 3) +
  scale_color_manual(values = c("weak (F<10)" = okabe_ito[6], "strong/marginal" = okabe_ito[5])) +
  labs(x = "First-stage F (excluded instrument: logem4)", y = NULL, color = NULL) +
  theme_report +
  theme(legend.position = "bottom")

ggsave("figures/first-stage.png", plot = p, width = 7, height = 4.5, dpi = 300)

cat("Done.\n")
