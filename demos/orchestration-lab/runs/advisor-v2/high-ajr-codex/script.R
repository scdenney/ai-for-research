# Replication and robustness checks for Acemoglu, Johnson, and Robinson (2001)
# Data: ivdoctr::colonial (AJR base sample, 64 countries)

# Packages ---------------------------------------------------------------
library(ivdoctr)
library(AER)
library(car)

# This analysis is deterministic; the seed is declared for reproducibility.
set.seed(20260719)

# No figure is produced, so no palette or graphical theme is required.

# Data -------------------------------------------------------------------
data(colonial, package = "ivdoctr")
colonial <- as.data.frame(colonial)

neo_europes <- c("AUS", "CAN", "NZL", "USA")

# Estimate OLS, 2SLS, and the first stage on one common analytic sample.
# The reported F statistic is the partial first-stage F test of logem4 = 0,
# conditional on the controls in that specification.
estimate_specification <- function(name, controls = character(), keep) {
  variables <- c("logpgp95", "avexpr", "logem4", controls)
  dat <- colonial[keep(colonial), variables, drop = FALSE]
  dat <- dat[stats::complete.cases(dat), , drop = FALSE]

  ols_formula <- stats::reformulate(c("avexpr", controls), response = "logpgp95")
  first_stage_formula <- stats::reformulate(c("logem4", controls), response = "avexpr")
  ols <- stats::lm(ols_formula, data = dat)
  first_stage <- stats::lm(first_stage_formula, data = dat)

  structural_rhs <- paste(c("avexpr", controls), collapse = " + ")
  instrument_rhs <- paste(c("logem4", controls), collapse = " + ")
  iv_formula <- stats::as.formula(
    paste("logpgp95 ~", structural_rhs, "|", instrument_rhs)
  )
  iv <- AER::ivreg(iv_formula, data = dat)
  iv_estimate <- stats::coef(iv)["avexpr"]

  first_stage_test <- car::linearHypothesis(
    first_stage, "logem4 = 0", test = "F"
  )
  first_stage_f <- first_stage_test[2, "F"]

  data.frame(
    specification = name,
    n = nrow(dat),
    ols = unname(stats::coef(ols)["avexpr"]),
    iv = unname(iv_estimate),
    first_stage_coefficient = unname(stats::coef(first_stage)["logem4"]),
    first_stage_f = unname(first_stage_f),
    identification = ifelse(
      first_stage_f < 10,
      "Weak (F < 10)",
      ifelse(
        first_stage_f < 15,
        "Passes F ≥ 10 rule, but borderline",
        "Not weak by F ≥ 10 rule"
      )
    ),
    stringsAsFactors = FALSE
  )
}

results <- do.call(
  rbind,
  list(
    estimate_specification(
      "Bivariate", keep = function(dat) rep(TRUE, nrow(dat))
    ),
    estimate_specification(
      "Add latitude", controls = "lat_abst",
      keep = function(dat) rep(TRUE, nrow(dat))
    ),
    estimate_specification(
      "Add continent controls", controls = c("africa", "asia"),
      keep = function(dat) rep(TRUE, nrow(dat))
    ),
    estimate_specification(
      "Drop neo-Europes", keep = function(dat) !dat$shortnam %in% neo_europes
    ),
    estimate_specification(
      "Africa only", keep = function(dat) dat$africa == 1
    )
  )
)

# Robustness table -------------------------------------------------------
table_rows <- vapply(seq_len(nrow(results)), function(i) {
  row <- results[i, ]
  sprintf(
    "| %s | %d | %.3f | %.3f | %.3f | %.2f | %s |",
    row$specification, row$n, row$ols, row$iv,
    row$first_stage_coefficient, row$first_stage_f, row$identification
  )
}, character(1))

table_note <- "2SLS is estimated with `AER::ivreg`."

table_lines <- c(
  "# Robustness of the AJR institutions–income IV estimate",
  "",
  "| Specification | N | OLS: avexpr | 2SLS: avexpr | First-stage: logem4 | First-stage F | Identification |",
  "|:--|--:|--:|--:|--:|--:|:--|",
  table_rows,
  "",
  paste0(
    "Notes: The outcome is log PPP GDP per capita in 1995 (`logpgp95`). ",
    "OLS and 2SLS use the same complete-case analytic sample within each row. ",
    "The structural regressor is institutions (`avexpr`); the excluded instrument is ",
    "log settler mortality (`logem4`). The first-stage F is the one-degree-of-freedom ",
    "partial F test of the excluded instrument conditional on the listed controls. ",
    "`F < 10` is flagged as weak identification; 2SLS point estimates in those rows ",
    "should not be interpreted as reliable. `Add latitude` controls for `lat_abst`; ",
    "`Add continent controls` controls for `africa` and `asia`; the neo-Europe restriction ",
    "removes AUS, CAN, NZL, and USA. ", table_note
  )
)

writeLines(table_lines, "robustness-table.md")

print(results[, c(
  "specification", "n", "ols", "iv", "first_stage_coefficient",
  "first_stage_f", "identification"
)])
message("Wrote robustness-table.md")
