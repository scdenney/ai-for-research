#!/usr/bin/env Rscript

# Reference-category sensitivity analysis for exampleData1
# Reproduces: figures/sensitivity.png, sensitivity-table.md, and memo.md.

library(projoint)

dir.create("figures", showWarnings = FALSE, recursive = TRUE)

data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

# The package estimates the repeated-task reliability correction and uses
# respondent-clustered analytical standard errors for these profile-level QoIs.
mm_fit <- projoint(out, .structure = "profile_level", .estimand = "mm")
mm <- as.data.frame(summary(mm_fit))
mm <- mm[mm$estimand == "mm_corrected", ]
names(mm)[names(mm) == "att_level_choose"] <- "level_id"
mm <- merge(out$labels, mm, by = "level_id", sort = FALSE)
mm <- mm[order(mm$attribute_id, mm$level_id), ]

# Explicitly refit an AMCE for each focal/reference pairing.  This avoids
# treating a post-estimation sign change as though it were a new estimand.
fit_amce <- function(attribute_id, focal, reference) {
  qoi <- set_qoi(
    .structure = "profile_level", .estimand = "amce",
    .att_choose = attribute_id, .lev_choose = focal,
    .att_choose_b = attribute_id, .lev_choose_b = reference
  )
  fit <- suppressWarnings(projoint(out, .qoi = qoi))
  ans <- as.data.frame(summary(fit))
  ans <- ans[ans$estimand == "amce_corrected", ]
  ans[1, c("estimate", "conf.low", "conf.high")]
}

baseline_grid <- function(attribute_id) {
  lev <- out$labels[out$labels$attribute_id == attribute_id, ]
  result <- matrix(NA_real_, nrow = nrow(lev), ncol = nrow(lev),
                   dimnames = list(lev$level_id, lev$level_id))
  low <- high <- result
  for (j in seq_len(nrow(lev))) {
    for (i in seq_len(nrow(lev))) {
      if (i == j) {
        result[i, j] <- 0
      } else {
        est <- fit_amce(attribute_id, sub(".*:", "", lev$level_id[i]),
                        sub(".*:", "", lev$level_id[j]))
        result[i, j] <- est$estimate
        low[i, j] <- est$conf.low
        high[i, j] <- est$conf.high
      }
    }
  }
  list(levels = lev, estimate = result, low = low, high = high)
}

crime <- baseline_grid("att7")                 # binary: only a sign reversal is possible
housing <- baseline_grid("att1")               # multi-level sensitivity check

fmt_num <- function(x) sprintf("%.3f", x)
fmt_ci <- function(est, lo, hi) {
  if (is.na(lo)) "0.000 (reference)" else
    sprintf("%.3f [%.3f, %.3f]", est, lo, hi)
}
# Tiny helper to retain base-R compatibility without importing a formatting package.
`%+%` <- paste0
amce_markdown <- function(grid, heading) {
  lev_names <- grid$levels$level
  header <- paste(c("Level", paste0("Reference: ", lev_names)), collapse = " | ")
  divider <- paste(rep("---", length(lev_names) + 1), collapse = " | ")
  rows <- vapply(seq_along(lev_names), function(i) {
    vals <- vapply(seq_along(lev_names), function(j) {
      fmt_ci(grid$estimate[i, j], grid$low[i, j], grid$high[i, j])
    }, character(1))
    paste(c(lev_names[i], vals), collapse = " | ")
  }, character(1))
  c(paste0("## ", heading), "", header, divider, rows, "")
}

mm_rows <- vapply(seq_len(nrow(mm)), function(i) {
  sprintf("| %s | %s | %.3f [%.3f, %.3f] |",
          mm$attribute[i], mm$level[i], mm$estimate[i],
          mm$conf.low[i], mm$conf.high[i])
}, character(1))

range_by_attribute <- aggregate(estimate ~ attribute, data = mm,
                                FUN = function(x) diff(range(x)))
range_by_attribute <- range_by_attribute[order(-range_by_attribute$estimate), ]
range_text <- paste(sprintf("%s = %.3f", range_by_attribute$attribute,
                            range_by_attribute$estimate), collapse = "; ")

table_lines <- c(
  "# Reference-category sensitivity and marginal means",
  "",
  "All estimates are profile-level, IRR-corrected `projoint` estimates with respondent-clustered analytical 95% confidence intervals. The repeated-task correction estimated tau = " %+% fmt_num(mm_fit$tau) %+% ". A zero is the fitted reference category, not an estimated null effect.",
  "",
  amce_markdown(crime, "Violent Crime Rate: AMCEs under each reference"),
  "The crime attribute is binary. Changing the reference can only reverse the contrast: 20% more crime versus 20% less crime, or its negative.",
  "",
  amce_markdown(housing, "Housing Cost (multi-level check): AMCEs under each reference"),
  "For a multi-level attribute, the particular AMCE displayed changes with the reference; pairwise contrasts themselves remain the same when expressed in the corresponding direction.",
  "",
  "## Marginal means for every experimental level",
  "",
  "| Attribute | Level | Marginal mean [95% CI] |",
  "| --- | --- | --- |",
  mm_rows,
  "",
  "Observed within-attribute MM ranges (descriptive): " %+% range_text %+% ". Ranges are included as a descriptive summary, not a universal importance ranking: attributes have different numbers of levels and different possible contrast ranges."
)

writeLines(table_lines, "sensitivity-table.md")

crime_mm <- mm[mm$attribute_id == "att7", ]
housing_mm <- mm[mm$attribute_id == "att1", ]

# Figure plan: compare baseline-invariant choice probabilities across levels.
# Two panels keep the binary crime contrast alongside an illustrative multi-level
# attribute. Direct labels and point shapes keep the figure readable in grayscale.
png("figures/sensitivity.png", width = 7.2, height = 4.1, units = "in", res = 320)
par(mfrow = c(1, 2), mar = c(7.0, 4.4, 1.2, 0.8), las = 1,
    family = "sans", cex.axis = 0.82, cex.lab = 0.96)
plot_mm <- function(d, x_labels, x_axis_label, point_col) {
  x <- seq_len(nrow(d))
  plot(x, d$estimate, ylim = c(0.25, 0.72), xlim = c(0.6, nrow(d) + 0.4),
       xaxt = "n", pch = 16, col = point_col, xlab = "", ylab = "Marginal mean choice probability (0–1)")
  segments(x, d$conf.low, x, d$conf.high, col = point_col, lwd = 1.35)
  segments(x - 0.06, d$conf.low, x + 0.06, d$conf.low, col = point_col, lwd = 1.35)
  segments(x - 0.06, d$conf.high, x + 0.06, d$conf.high, col = point_col, lwd = 1.35)
  axis(1, at = x, labels = x_labels, las = 1, cex.axis = 0.76)
  abline(h = 0.5, lty = 2, col = "grey55")
  mtext(x_axis_label, side = 1, line = 4.8, cex = 0.92)
}
plot_mm(crime_mm, c("20% less\ncrime", "20% more\ncrime"),
        "Violent crime rate (relative to national average)", "#0072B2")
plot_mm(housing_mm, c("15%", "30%", "40%"),
        "Housing cost (share of pre-tax income)", "#D55E00")
dev.off()

memo_lines <- c(
  "# Reply to reviewer",
  "",
  "The reviewer is mechanically correct about AMCE parameterization. An AMCE is a contrast against a named reference level, so its displayed sign and magnitude depend on that reference. We have rerun the estimates with every available crime reference and, as a multi-level check, every housing-cost reference (Table `sensitivity-table.md`). The crime attribute is binary. Consequently, switching its reference does not create a different substantive comparison: the estimate for 20% more crime relative to 20% less crime is -0.251 (95% CI [-0.334, -0.168]), whereas the reverse contrast is +0.251 (95% CI [0.168, 0.334]). The sign flips because the comparison has been reversed. Housing cost illustrates the reviewer’s broader point: with three levels, the individual AMCE reported depends on which of the three is set to zero, even though each directed pairwise contrast is unchanged.",
  "",
  "That coding dependence is a reason not to treat a single dummy coefficient as an attribute-importance ranking. It does not, however, erase the pattern in these data. We therefore also report marginal means (MMs) for every level. MMs have no reference category: they are the modeled probability that a profile with a given level is selected, averaging over the randomized distribution of the other attributes. The IRR-corrected MM is 0.626 (95% CI [0.584, 0.667]) for a community with 20% less violent crime than the national average and 0.374 (95% CI [0.333, 0.416]) for one with 20% more crime. Thus, the 25.1-percentage-point separation is visible without choosing a baseline. In this design it is the largest observed within-attribute MM range (commuting time: 23.7 points; housing cost: 19.8 points), although ranges across attributes with different numbers and spacings of levels should not be promoted as a universal scale of importance.",
  "",
  "We will revise the manuscript accordingly. The headline will say that, among the experimentally varied levels, respondents strongly prefer communities with lower rather than higher violent crime; this conclusion is robust to reference coding and is supported directly by the MMs. We will not say that crime ‘drives’ community choice in a general sense, nor claim a definitive cross-attribute importance ordering from AMCE magnitudes. The revised results will present the MM figure and table as the primary evidence, retain AMCEs only with explicit references, and state that the evidence pertains to the specified 20% less-versus-more crime contrast in this conjoint design."
)
writeLines(memo_lines, "memo.md")

message("Wrote script.R, sensitivity-table.md, memo.md, and figures/sensitivity.png")
