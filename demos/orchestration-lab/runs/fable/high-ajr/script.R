# =============================================================================
# Acemoglu-Johnson-Robinson (2001) IV headline: replication + robustness stress
# -----------------------------------------------------------------------------
# Structural model:
#   Outcome eq (2nd stage):  logpgp95 = b0 + b1*avexpr + g'*controls + u
#   First stage:             avexpr   = a0 + a1*logem4 + d'*controls + v
# avexpr (avg. protection against expropriation) is endogenous; logem4 (log
# settler mortality) is the excluded instrument. 2SLS path: estimate the first
# stage, use fitted institutions in the outcome equation. We take the AER::ivreg
# route (installed and available), which does the full 2SLS in one call and
# returns correct 2SLS standard errors, rather than a manual two-step.
# =============================================================================

library(ivdoctr)
library(AER)
library(car)

set.seed(1)  # house convention only; OLS/2SLS are deterministic, no RNG used.

data(colonial, package = "ivdoctr")

# -----------------------------------------------------------------------------
# Estimator for ONE specification on ONE common sample.
#   df       : data (already subset to the common sample)
#   controls : character vector of control names (empty for none)
# Returns a one-row data.frame. OLS, 2SLS, and first stage all use the SAME df,
# so the sample is identical across the three estimators by construction.
# -----------------------------------------------------------------------------
fit_spec <- function(label, df, controls = character(0)) {
  ctrl_rhs <- if (length(controls)) paste("+", paste(controls, collapse = " + ")) else ""

  ols_f <- as.formula(paste0("logpgp95 ~ avexpr", ctrl_rhs))
  iv_f  <- as.formula(paste0("logpgp95 ~ avexpr", ctrl_rhs, " | logem4", ctrl_rhs))
  fs_f  <- as.formula(paste0("avexpr ~ logem4", ctrl_rhs))

  ols <- lm(ols_f, data = df)
  iv  <- AER::ivreg(iv_f, data = df)
  fs  <- lm(fs_f, data = df)

  # First-stage F on the EXCLUDED INSTRUMENT ONLY (not the model overall F,
  # which would also credit the controls). car::linearHypothesis gives exactly
  # the single-restriction F for logem4 = 0.
  fs_F <- car::linearHypothesis(fs, "logem4 = 0")$F[2]

  data.frame(
    Specification = label,
    n             = nrow(df),
    ols_b         = round(unname(coef(ols)["avexpr"]), 3),
    iv_b          = round(unname(coef(iv)["avexpr"]), 3),
    fs_b          = round(unname(coef(fs)["logem4"]), 3),
    fs_F          = round(fs_F, 2),
    weak          = fs_F < 10,
    stringsAsFactors = FALSE
  )
}

# -----------------------------------------------------------------------------
# Six specifications (base is the headline; a-d are the four perturbations).
# -----------------------------------------------------------------------------
full   <- colonial                                                   # 64, zero NA
no_neo <- subset(full, !(shortnam %in% c("AUS", "CAN", "NZL", "USA")))  # 60
afr    <- subset(full, africa == 1)                                  # 27

results <- rbind(
  fit_spec("base",                 full,   character(0)),
  fit_spec("(a) latitude",         full,   "lat_abst"),
  fit_spec("(b) continents",       full,   c("africa", "asia")),
  fit_spec("(c) drop neo-Europes", no_neo, character(0)),
  fit_spec("(d) Africa only",      afr,    character(0))
)

print(results, row.names = FALSE)

# Sanity check: for the base spec (no controls) the excluded-instrument F must
# equal the model's overall first-stage F.
base_fs     <- lm(avexpr ~ logem4, data = full)
base_excl_F <- car::linearHypothesis(base_fs, "logem4 = 0")$F[2]
base_ovr_F  <- summary(base_fs)$fstatistic["value"]
cat(sprintf("\nBase first-stage F check: excluded = %.4f, overall = %.4f, equal = %s\n",
            base_excl_F, base_ovr_F,
            isTRUE(all.equal(unname(base_excl_F), unname(base_ovr_F)))))

# -----------------------------------------------------------------------------
# Write robustness-table.md from the SAME results object so the printed numbers
# and the written table can never drift apart.
# -----------------------------------------------------------------------------
hdr <- paste("| Specification | n | OLS β(avexpr) | 2SLS β(avexpr) |",
             "First-stage β(logem4) | First-stage F | Weak? (F<10) |")
sep <- "|---|---|---|---|---|---|---|"
rows <- apply(results, 1, function(r) {
  sprintf("| %s | %s | %s | %s | %s | %s | %s |",
          r["Specification"], r["n"], r["ols_b"], r["iv_b"],
          r["fs_b"], r["fs_F"], ifelse(as.logical(r["weak"]), "yes", "no"))
})

weak_specs <- results$Specification[results$weak]
weak_note  <- if (length(weak_specs)) {
  paste0("Weakly identified (first-stage F < 10): ",
         paste(weak_specs, collapse = ", "), ".")
} else {
  "No specification is weakly identified (all first-stage F >= 10)."
}
reliab_note <- paste("2SLS point estimates under a collapsed first stage (weak",
                     "instrument) are not reliable and should not be read as",
                     "consistent institutional effects.")

writeLines(c(hdr, sep, rows, "", weak_note, "", reliab_note),
           "robustness-table.md")
