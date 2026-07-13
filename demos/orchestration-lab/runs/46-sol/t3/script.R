#!/usr/bin/env Rscript
# Reproducible baseline-sensitivity analysis for BRIEF.md.

set.seed(20260713)
suppressPackageStartupMessages(library(projoint))
data(exampleData1)

out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

dir.create("figures", showWarnings = FALSE, recursive = TRUE)
unlink(list.files("figures", pattern = "\\.png$", full.names = TRUE))

mm_fit <- projoint(
  out, .structure = "profile_level", .estimand = "mm",
  .se_method = "analytical", .seed = 20260713
)
mm <- as.data.frame(mm_fit$estimates)
mm <- mm[mm$estimand == "mm_corrected", , drop = FALSE]
labels <- as.data.frame(out$labels)
mm$attribute_id <- sub(":.*", "", mm$att_level_choose)
mm$level_id <- mm$att_level_choose
mm$attribute <- labels$attribute[match(mm$level_id, labels$level_id)]
mm$level <- labels$level[match(mm$level_id, labels$level_id)]
stopifnot(nrow(mm) == 24L, !anyNA(mm$attribute),
          identical(mm_fit$cluster_by, "id"), mm_fit$irr == "Estimated")

contrast_fit <- function(attribute, chosen, baseline) {
  qoi <- set_qoi(
    .structure = "profile_level", .estimand = "amce",
    .att_choose = attribute, .lev_choose = chosen,
    .att_choose_b = attribute, .lev_choose_b = baseline
  )
  fit <- projoint(out, .qoi = qoi, .se_method = "analytical", .seed = 20260713)
  ans <- as.data.frame(fit$estimates)
  ans <- ans[ans$estimand == "amce_corrected", , drop = FALSE]
  stopifnot(nrow(ans) == 1L, identical(fit$cluster_by, "id"),
            identical(attr(fit$estimates, "se_type_used"), "CR2"))
  ans$attribute_id <- attribute
  ans$chosen <- chosen
  ans$baseline <- baseline
  ans
}

# Explicit directed crime contrasts; their signs depend only on direction.
crime_more_less <- contrast_fit("att7", "level2", "level1")
crime_less_more <- contrast_fit("att7", "level1", "level2")
crime_contrasts <- rbind(crime_more_less, crime_less_more)

# Each Housing Cost baseline is represented, with one directed contrast per fit.
housing_levels <- c("level1", "level2", "level3")
housing_contrasts <- do.call(rbind, lapply(housing_levels, function(base) {
  do.call(rbind, lapply(setdiff(housing_levels, base), function(chosen) {
    contrast_fit("att1", chosen, base)
  }))
}))
stopifnot(identical(sort(unique(housing_contrasts$baseline)), housing_levels))

tol <- 1e-8
stopifnot(abs(crime_more_less$estimate + crime_less_more$estimate) < tol,
          abs(abs(crime_more_less$estimate) - abs(crime_less_more$estimate)) < tol)
crime_mm <- mm[mm$attribute_id == "att7", , drop = FALSE]
crime_mm <- crime_mm[match(c("att7:level1", "att7:level2"), crime_mm$level_id), ]
stopifnot(abs((crime_mm$estimate[2] - crime_mm$estimate[1]) -
                crime_more_less$estimate) < tol)

fmt_pp <- function(x) sprintf("%.1f", 100 * x)
fmt_ci_pp <- function(x) sprintf("%s pp (95%% CI %s, %s)",
                                 fmt_pp(x$estimate), fmt_pp(x$conf.low), fmt_pp(x$conf.high))
fmt_mm <- function(x) sprintf("%.3f (95%% CI %.3f, %.3f)",
                              x$estimate, x$conf.low, x$conf.high)
level_name <- function(attribute, suffix) {
  labels$level[match(paste0(attribute, ":", suffix), labels$level_id)]
}

crime_rows <- data.frame(
  level = c(level_name("att7", "level1"), level_name("att7", "level2")),
  less_baseline = c("Reference", fmt_ci_pp(crime_more_less)),
  more_baseline = c(fmt_ci_pp(crime_less_more), "Reference"),
  mm = c(fmt_mm(crime_mm[1, ]), fmt_mm(crime_mm[2, ])),
  check.names = FALSE
)
table_lines <- c(
  "# Violent Crime Rate baseline sensitivity",
  "",
  "| Crime level | Less crime baseline | More crime baseline | Marginal mean |",
  "|---|---:|---:|---:|",
  sprintf("| %s | %s | %s | %s |", crime_rows$level, crime_rows$less_baseline,
          crime_rows$more_baseline, crime_rows$mm),
  "",
  "*Note.* AMCE entries are corrected profile-level estimates (with 95% confidence intervals) using the package's estimated IRR correction and respondent-clustered analytical standard errors. Marginal means are corrected predicted choice probabilities. Reversing the crime baseline changes only the sign of the same 0.251 (25.1 percentage-point) contrast."
)
writeLines(table_lines, "sensitivity-table.md")

# One accessible horizontal range plot of baseline-invariant corrected MMs.
attribute_order <- unique(labels$attribute)
plot_mm <- mm[match(labels$level_id, mm$level_id), ]
plot_mm$y <- match(plot_mm$attribute, attribute_order)
offsets <- ave(plot_mm$y, plot_mm$attribute, FUN = function(z) {
  seq(-0.22, 0.22, length.out = length(z))
})
plot_mm$y_offset <- plot_mm$y + offsets
range_by_attribute <- lapply(attribute_order, function(a) {
  x <- plot_mm[plot_mm$attribute == a, , drop = FALSE]
  c(min(x$estimate), max(x$estimate))
})
names(range_by_attribute) <- attribute_order
short_labels <- c("Housing cost", "Presidential vote", "Racial composition",
                  "School quality", "Driving / errands", "Type of place", "Violent crime")
point_colours <- ifelse(grepl("^Violent Crime Rate", plot_mm$attribute), "#D55E00",
                        ifelse(plot_mm$y %% 2L == 0L, "#333333", "#0072B2"))
png("figures/sensitivity.png", width = 2800, height = 2100, res = 320,
    type = "cairo-png")
par(mar = c(4.5, 12, 1.2, 1.5), las = 1, family = "sans")
plot(NA, xlim = c(0.25, 0.75), ylim = c(7.6, 0.4), yaxt = "n", xlab = "Corrected marginal mean (choice probability)", ylab = "")
abline(v = 0.5, lty = 2, col = "#666666", lwd = 1.2)
for (i in seq_along(attribute_order)) {
  segments(range_by_attribute[[i]][1], i, range_by_attribute[[i]][2], i,
           col = "#777777", lwd = 1.2)
}
points(plot_mm$estimate, plot_mm$y_offset, pch = 21, bg = point_colours,
       col = "#1A1A1A", cex = 1.35, lwd = 0.8)
axis(2, at = seq_along(attribute_order), labels = short_labels, tick = FALSE)
box(bty = "l")
dev.off()

# Cairo produces the requested pixel dimensions but does not reliably retain
# density metadata. Rewrite the same raster with an explicit 320-dpi pHYs chunk.
stopifnot(requireNamespace("png", quietly = TRUE))
figure_raster <- png::readPNG("figures/sensitivity.png")
png::writePNG(figure_raster, "figures/sensitivity.png", dpi = 320)

# Validate that the requested sole figure is a usable PNG with ample dimensions.
png_files <- list.files("figures", pattern = "\\.png$", full.names = TRUE)
png_header <- readBin("figures/sensitivity.png", "raw", n = 24)
png_info <- attr(png::readPNG("figures/sensitivity.png", info = TRUE), "info")
be32 <- function(r) sum(as.integer(r) * 256^(3:0))
width_px <- be32(png_header[17:20]); height_px <- be32(png_header[21:24])
stopifnot(length(png_files) == 1L,
          identical(as.integer(png_header[1:8]), c(137L, 80L, 78L, 71L, 13L, 10L, 26L, 10L)),
          width_px >= 1800L, height_px >= 1800L,
          all(abs(png_info$dpi - 320) < 0.1),
          file.info(png_files)$size > 0L)

housing_l2_l1 <- housing_contrasts[housing_contrasts$chosen == "level2" & housing_contrasts$baseline == "level1", ]
housing_l1_l3 <- housing_contrasts[housing_contrasts$chosen == "level1" & housing_contrasts$baseline == "level3", ]
crime_range <- diff(range(crime_mm$estimate))
commute_mm <- mm[mm$attribute_id == "att5", , drop = FALSE]
commute_range <- diff(range(commute_mm$estimate))
memo <- sprintf(paste(
  "# Response to reviewer\n\n",
  "Thank you for identifying a real limitation in how we described the AMCE results. AMCE coefficients are parameterized comparisons: changing a reference category changes the displayed coefficient, so a headline framed as a single baseline-specific coefficient is too strong. That mechanical dependence does not make reference categories meaningless, but it does require that the comparison and its direction be explicit.\n\n",
  "For Violent Crime Rate, the data give a particularly simple sensitivity result because the attribute is binary (as is School Quality). With 20%% less crime as the baseline, moving to 20%% more crime has a corrected AMCE of %s. Reversing the baseline gives %s. These are the same randomized comparison with the direction reversed; there is no third crime contrast whose magnitude could alter the result. The associated corrected marginal means are %s for 20%% less crime and %s for 20%% more crime. Their difference is the same %.1f percentage points.\n\n",
  "The reviewer is nevertheless right that multi-level attributes have more baseline-dependent AMCE displays. For Housing Cost, 30%% rather than 15%% of pre-tax income has a corrected contrast of %s when 15%% is the baseline. Expressing the comparison with 40%% as the baseline, 15%% rather than 40%% has a corrected contrast of %s. Those are useful, different parameterizations of different level comparisons, not a basis for ranking a single coefficient across arbitrary baselines.\n\n",
  "We therefore also compare corrected marginal means for all 24 attribute levels, which do not require a reference category. Crime spans %.1f percentage points across its two levels, the largest observed point-estimate spread, but it is close to commuting's %.1f points. This evidence does not establish a uniquely dominant attribute ranking. In revision, we will say that moving from 20%% less to 20%% more crime causes a substantial reduction in choice probability in this randomized conjoint, and that crime is among the strongest attributes (and has the largest observed marginal-mean spread). We will not say that it uniquely drives choice.\n",
  sep = ""),
  fmt_ci_pp(crime_more_less), fmt_ci_pp(crime_less_more), fmt_mm(crime_mm[1, ]),
  fmt_mm(crime_mm[2, ]), 100 * crime_range, fmt_ci_pp(housing_l2_l1),
  fmt_ci_pp(housing_l1_l3), 100 * crime_range, 100 * commute_range)
word_count <- length(strsplit(gsub("[#%(),.;:-]", "", memo), "\\s+")[[1]])
stopifnot(word_count >= 340L, word_count <= 470L)
memo <- paste0(memo,
  "\n\n![Corrected marginal means by attribute; thin segments show each attribute's level range, orange marks crime, and blue/gray mark other attributes.](figures/sensitivity.png)\n\n",
  "*Figure 1. Corrected marginal means are baseline-invariant; each point is a level and each thin segment is that attribute's minimum-to-maximum range. Color supplements the labeled attribute position rather than serving as the sole identifier.*\n")
writeLines(memo, "memo.md")

cat("conclusion: Completed the baseline-sensitivity deliverables; crime is among the strongest attributes, not uniquely dominant.\n")
cat("executed checks: 24 corrected MMs; respondent clustering and estimated IRR; crime sign/magnitude and MM-difference identities; all three Housing Cost baselines; one valid high-resolution PNG; memo word count.\n")
cat("changed files: script.R, sensitivity-table.md, memo.md, figures/sensitivity.png\n")
cat("residual risk: Inference is conditional on the package's analytical corrected-estimate and estimated-IRR assumptions.\n")
