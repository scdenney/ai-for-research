#!/usr/bin/env Rscript

# Sensitivity analysis for reference-category coding in the conjoint data.
# Run from this directory: Rscript script.R

suppressPackageStartupMessages({
  library(projoint)
  library(estimatr)
})

dir.create("figures", showWarnings = FALSE, recursive = TRUE)

data(exampleData1)
pj <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)
d <- as.data.frame(pj$data)
labs <- as.data.frame(pj$labels)
attrs <- grep("^att[0-9]+$", names(d), value = TRUE)

# Conventional profile-level AMCE regression.  CR2 standard errors are
# clustered by respondent because each respondent evaluates multiple profiles.
fit_amce <- function(reference_attribute, reference_level) {
  dd <- d
  dd[[reference_attribute]] <- stats::relevel(dd[[reference_attribute]], ref = reference_level)
  f <- stats::as.formula(paste("selected ~", paste(attrs, collapse = " + ")))
  estimatr::lm_robust(f, data = dd, clusters = id, se_type = "CR2")
}

crime_id <- "att7"
housing_id <- "att1"
crime_labs <- labs[labs$attribute_id == crime_id, ]
housing_labs <- labs[labs$attribute_id == housing_id, ]

# Re-estimate after each possible baseline.  Crime is binary, so the two
# regressions contain the same single contrast with its sign reversed.
crime_fits <- setNames(lapply(levels(d[[crime_id]]), function(ref) {
  fit_amce(crime_id, ref)
}), levels(d[[crime_id]]))

# Housing cost is a multi-level check: every baseline supplies two contrasts.
housing_fits <- setNames(lapply(levels(d[[housing_id]]), function(ref) {
  fit_amce(housing_id, ref)
}), levels(d[[housing_id]]))

fmt_ci <- function(est, lo, hi) sprintf("%.3f [%.3f, %.3f]", est, lo, hi)
coef_for_level <- function(fit, attribute, level, reference) {
  if (identical(level, reference)) return("0.000 (reference)")
  nm <- paste0(attribute, level)
  ci <- stats::confint(fit)[nm, ]
  fmt_ci(unname(stats::coef(fit)[nm]), ci[1], ci[2])
}

# Marginal means are level-specific average selection probabilities.  They do
# not require a reference category.  CR2 intervals use the same respondent
# clustering as the AMCE models.
mm_rows <- do.call(rbind, lapply(attrs, function(a) {
  levs <- levels(d[[a]])
  fit <- estimatr::lm_robust(
    stats::as.formula(paste0("selected ~ 0 + ", a)),
    data = d, clusters = id, se_type = "CR2"
  )
  ci <- stats::confint(fit)
  data.frame(
    attribute_id = a,
    level_id = levs,
    estimate = unname(stats::coef(fit)[paste0(a, levs)]),
    low = ci[paste0(a, levs), 1], high = ci[paste0(a, levs), 2],
    stringsAsFactors = FALSE
  )
}))
mm_rows <- merge(mm_rows, labs, by = c("attribute_id", "level_id"), sort = FALSE)
mm_rows <- mm_rows[match(labs$level_id, mm_rows$level_id), ]

# Required side-by-side crime sensitivity table.
crime_mm <- mm_rows[mm_rows$attribute_id == crime_id, ]
crime_table <- data.frame(Level = crime_labs$level, check.names = FALSE)
for (ref in levels(d[[crime_id]])) {
  ref_label <- crime_labs$level[match(ref, crime_labs$level_id)]
  crime_table[[paste0("AMCE; baseline = ", ref_label)]] <- vapply(
    crime_labs$level_id,
    function(lev) coef_for_level(crime_fits[[ref]], crime_id, lev, ref),
    character(1)
  )
}
crime_table[["Marginal mean [95% CI]"]] <- vapply(seq_len(nrow(crime_mm)), function(i) {
  fmt_ci(crime_mm$estimate[i], crime_mm$low[i], crime_mm$high[i])
}, character(1))

table_lines <- c(
  "# Violent-crime reference-category sensitivity",
  "",
  "AMCEs are percentage-point changes in profile selection relative to the stated baseline; CR2 95% confidence intervals are in brackets. Marginal means (MMs) are level-specific selection probabilities and do not depend on a baseline.",
  "",
  paste0("| ", paste(names(crime_table), collapse = " | "), " |"),
  paste0("|", paste(rep("---", ncol(crime_table)), collapse = "|"), "|")
)
table_lines <- c(table_lines, apply(crime_table, 1, function(x) paste0("| ", paste(x, collapse = " | "), " |")))
table_lines <- c(table_lines,
  "",
  "## Multi-level check: Housing Cost",
  "",
  "Changing the three-category housing-cost baseline similarly only changes the contrast origin. The fitted AMCEs are reproduced below as a check.",
  "")
for (ref in levels(d[[housing_id]])) {
  ref_label <- housing_labs$level[match(ref, housing_labs$level_id)]
  vals <- vapply(housing_labs$level_id, function(lev) coef_for_level(housing_fits[[ref]], housing_id, lev, ref), character(1))
  table_lines <- c(table_lines, paste0("- Baseline **", ref_label, "**: ", paste(paste0(housing_labs$level, " = ", vals), collapse = "; ")))
}
writeLines(table_lines, "sensitivity-table.md")

# Exactly one figure: baseline-invariant MMs for every attribute level.
ragg::agg_png("figures/sensitivity.png", width = 3600, height = 5600,
              units = "px", res = 320)
op <- par(mfrow = c(7, 1), mar = c(2.8, 28.0, 1.5, 0.8), las = 1, cex.axis = 0.78)
for (a in attrs) {
  z <- mm_rows[mm_rows$attribute_id == a, ]
  z <- z[order(z$estimate), ]
  y <- seq_len(nrow(z))
  xlim <- range(c(z$low, z$high, 0.35, 0.65))
  plot(z$estimate, y, xlim = xlim, ylim = c(0.5, nrow(z) + 0.5),
       yaxt = "n", ylab = "", xlab = "", pch = 16,
       col = "#1B5E7A")
  segments(z$low, y, z$high, y, col = "#1B5E7A", lwd = 2)
  abline(v = 0.5, lty = 2, col = "grey55")
  axis(2, at = y, labels = z$level, tick = FALSE)
  mtext(unique(z$attribute), side = 3, adj = 0, line = 0.1, font = 2, cex = 0.85)
}
par(op)
dev.off()

less <- crime_mm[crime_mm$level == "20% Less Crime Than National Average", ]
more <- crime_mm[crime_mm$level == "20% More Crime Than National Average", ]
crime_diff <- less$estimate - more$estimate
crime_level_1 <- levels(d[[crime_id]])[1]
crime_level_2 <- levels(d[[crime_id]])[2]
crime_ci_more_vs_less <- stats::confint(crime_fits[[crime_level_1]])[paste0(crime_id, crime_level_2), ]
crime_ci_less_vs_more <- stats::confint(crime_fits[[crime_level_2]])[paste0(crime_id, crime_level_1), ]

memo <- c(
  "# Response to reviewer",
  "",
  sprintf("We agree with the reviewer’s mechanical point. An AMCE is a contrast, so its displayed coefficient is defined relative to the omitted category. We therefore re-estimated the profile-level AMCE model with respondent-clustered (CR2) standard errors under every possible reference category. For violent crime, using 20%% less crime than the national average as the baseline yields an AMCE for 20%% more crime of %.3f (95%% CI %.3f to %.3f). When the baseline is switched, the coefficient for 20%% less crime is %.3f (%.3f to %.3f). These are the same pairwise comparison expressed in opposite directions, rather than different substantive estimates. The attribute is binary, so there are only these two possible baselines; no within-attribute ordering can change. The analogous exercise for the three-level housing-cost attribute produces a different set of displayed coefficients for each baseline, while preserving each pairwise difference.",
          -crime_diff, crime_ci_more_vs_less[1], crime_ci_more_vs_less[2],
          crime_diff, crime_ci_less_vs_more[1], crime_ci_less_vs_more[2]),
  "",
  sprintf("The baseline-invariant evidence is clearer. The marginal mean (MM) of selection is %.3f (95%% CI %.3f to %.3f) for a profile with 20%% less crime and %.3f (%.3f to %.3f) for one with 20%% more crime. Thus the observed MM gap is %.1f percentage points in favor of lower crime. These MMs are direct level-specific selection probabilities, estimated without choosing an omitted level, and the full set is shown in Figure 1. The table also reports the two AMCE parameterizations next to those MMs.",
          less$estimate, less$low, less$high, more$estimate, more$low, more$high, 100 * crime_diff),
  "",
  sprintf("We will nevertheless revise the manuscript’s language. It should not claim that violent crime ‘drives’ community choice on the basis of a particular AMCE coefficient or an unqualified ranking of attributes. Reference recoding can alter coefficient signs and the apparent magnitudes of non-comparable contrast vectors, especially for attributes with more than two levels. The defensible claim is narrower: in this experiment, profiles describing violent crime as 20%% below the national rate were selected more often than profiles describing it as 20%% above the national rate, by about %.1f percentage points. That directional lower-versus-higher-crime preference is robust to reference coding; a general assertion that crime is the dominant attribute is not established by this sensitivity analysis. We will present MMs and the explicit pairwise contrast as the headline evidence, and describe AMCEs as baseline-specific parameterizations.", 100 * crime_diff)
)
writeLines(memo, "memo.md")

message("Wrote script.R outputs: figures/sensitivity.png, sensitivity-table.md, memo.md")
