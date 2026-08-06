#!/usr/bin/env Rscript
# T3 — Is the "Violent Crime Rate drives community choice" headline an
# artifact of AMCE reference-category choice? Re-estimate crime AMCEs under
# every available baseline, do the same for one multi-level attribute, and
# compute marginal means (MMs), which have no reference category at all.
# Produces: sensitivity-table.md, figures/sensitivity.png, memo.md.

set.seed(20260717)

suppressPackageStartupMessages({
  library(projoint)
  library(ggplot2)
})

dir.create("figures", showWarnings = FALSE, recursive = TRUE)

## Okabe-Ito palette + shared theme -------------------------------------
okabe_ito <- c(
  black = "#000000", orange = "#E69F00", sky = "#56B4E9", green = "#009E73",
  yellow = "#F0E442", blue = "#0072B2", vermillion = "#D55E00", purple = "#CC79A7"
)
theme_t3 <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold"),
    axis.title = element_text(size = 10)
  )

## Data -------------------------------------------------------------------
data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

## Marginal means: the baseline-invariant quantity -------------------------
mm_fit <- projoint(out, .structure = "profile_level", .estimand = "mm")
invisible(capture.output(mm <- as.data.frame(summary(mm_fit))))
mm <- mm[mm$estimand == "mm_corrected", ]
names(mm)[names(mm) == "att_level_choose"] <- "level_id"
mm <- merge(out$labels, mm, by = "level_id", sort = FALSE)
mm <- mm[order(mm$attribute_id, mm$level_id), ]

## AMCEs under every available reference for a given attribute -------------
fit_amce <- function(attribute_id, focal_level, reference_level) {
  qoi <- set_qoi(
    .structure = "profile_level", .estimand = "amce",
    .att_choose = attribute_id, .lev_choose = focal_level,
    .att_choose_b = attribute_id, .lev_choose_b = reference_level
  )
  fit <- suppressWarnings(projoint(out, .qoi = qoi))
  invisible(capture.output(s <- as.data.frame(summary(fit))))
  s[s$estimand == "amce_corrected", c("estimate", "conf.low", "conf.high")]
}

baseline_grid <- function(attribute_id) {
  levs <- out$labels[out$labels$attribute_id == attribute_id, ]
  short <- sub(".*:", "", levs$level_id)
  n <- nrow(levs)
  est <- lo <- hi <- matrix(NA_real_, n, n, dimnames = list(levs$level_id, levs$level_id))
  for (ref in seq_len(n)) {
    for (foc in seq_len(n)) {
      if (foc == ref) { est[foc, ref] <- 0; next }
      s <- fit_amce(attribute_id, short[foc], short[ref])
      est[foc, ref] <- s$estimate; lo[foc, ref] <- s$conf.low; hi[foc, ref] <- s$conf.high
    }
  }
  list(levels = levs, estimate = est, low = lo, high = hi)
}

crime <- baseline_grid("att7")     # binary: only a sign reversal is possible
housing <- baseline_grid("att1")   # multi-level check: 3 levels, 3 possible baselines

## sensitivity-table.md -----------------------------------------------------
fmt_cell <- function(est, lo, hi) {
  if (is.na(lo)) "0.000 (ref.)" else sprintf("%.3f [%.3f, %.3f]", est, lo, hi)
}
grid_table <- function(grid, heading, note) {
  lab <- grid$levels$level
  header <- paste(c("Focal level", paste0("Reference: ", lab)), collapse = " | ")
  divider <- paste(rep("---", length(lab) + 1), collapse = " | ")
  rows <- vapply(seq_along(lab), function(i) {
    cells <- vapply(seq_along(lab), function(j) {
      fmt_cell(grid$estimate[i, j], grid$low[i, j], grid$high[i, j])
    }, character(1))
    paste(c(lab[i], cells), collapse = " | ")
  }, character(1))
  c(paste0("## ", heading), "", header, divider, rows, "", note, "")
}

mm_rows <- vapply(seq_len(nrow(mm)), function(i) {
  sprintf("| %s | %s | %.3f [%.3f, %.3f] |",
          mm$attribute[i], mm$level[i], mm$estimate[i], mm$conf.low[i], mm$conf.high[i])
}, character(1))

mm_range <- aggregate(estimate ~ attribute, data = mm, FUN = function(x) diff(range(x)))
mm_range <- mm_range[order(-mm_range$estimate), ]
range_text <- paste(sprintf("%s: %.3f", mm_range$attribute, mm_range$estimate), collapse = "; ")

short_name <- c(att1 = "housing cost", att2 = "presidential vote", att3 = "racial composition",
                 att4 = "school quality", att5 = "commuting time", att6 = "type of place",
                 att7 = "violent crime rate")
attribute_of <- setNames(out$labels$attribute_id, out$labels$attribute)[mm_range$attribute]
crime_range <- mm_range$estimate[mm_range$attribute == "Violent Crime Rate (Vs National Rate)"]
next_range <- mm_range[mm_range$attribute != "Violent Crime Rate (Vs National Rate)", ][1, ]
next_range$short_name <- short_name[[attribute_of[[next_range$attribute]]]]

lines <- c(
  "# Reference-category sensitivity: AMCEs vs. marginal means",
  "",
  sprintf("All figures are profile-level, IRR-corrected `projoint` estimates with respondent-clustered analytical 95%% CIs (estimated tau = %.3f). A `0.000 (ref.)` cell is the fitted reference level, not a null result.", mm_fit$tau),
  "",
  grid_table(crime, "Violent Crime Rate (att7, binary) — AMCE under each reference",
             "Crime has only two levels, so re-baselining can only flip the sign of the same contrast; no third comparison exists to reveal."),
  grid_table(housing, "Housing Cost (att1, 3 levels) — AMCE under each reference",
             sprintf("With three levels, each baseline choice reports 2 AMCEs (not one), and *which* two of the three pairwise contrasts get shown, and their apparent size, changes with the baseline: the largest displayed |AMCE| is %.3f under the 15%%-or-40%%-income baseline but only %.3f under the 30%%-income baseline, even though the underlying 15%%-vs-40%% pairwise contrast (%.3f) never changes. The matrix is antisymmetric: every off-diagonal entry is just the corresponding MM difference (row level minus column level), so a lower-triangle entry is always the upper triangle's mirror-image entry with the sign flipped.",
                     max(abs(housing$estimate["att1:level3", "att1:level1"]), abs(housing$estimate["att1:level1", "att1:level3"])),
                     abs(housing$estimate["att1:level1", "att1:level2"]),
                     abs(housing$estimate["att1:level3", "att1:level1"]))),
  "## Marginal means — every experimental level (baseline-invariant)",
  "",
  "| Attribute | Level | Marginal mean [95% CI] |",
  "| --- | --- | --- |",
  mm_rows,
  "",
  sprintf("Within-attribute MM range (descriptive only, not a formal importance test): %s.", range_text),
  "",
  sprintf("Identity worth noting: for any attribute, the largest AMCE achievable under *any* choice of reference equals that attribute's MM range (an AMCE against a given baseline is just the difference of two MMs). Since crime's range (%.3f) is the largest of the seven, no re-baselining of *any* attribute in this design can produce a reported AMCE bigger than crime's — the point-estimate ordering with crime at the top is invariant to reference choice, even though crime's narrow lead over commuting time (%.3f) is not itself a precise, statistically distinguishable ranking.",
          crime_range, next_range$estimate)
)
writeLines(lines, "sensitivity-table.md")

## figures/sensitivity.png ---------------------------------------------------
# All 24 levels, baseline-invariant MMs, grouped by attribute and ordered by
# descending within-attribute range so crime (the headline attribute) leads.
mm_fig <- mm
mm_fig$attribute <- factor(mm_fig$attribute, levels = mm_range$attribute)
mm_fig$level <- factor(mm_fig$level, levels = rev(mm_fig$level[order(mm_fig$attribute, mm_fig$level_id)]))

fig <- ggplot(mm_fig, aes(x = estimate, y = level, color = attribute)) +
  geom_vline(xintercept = 0.5, linetype = 2, color = "grey55") +
  geom_pointrange(aes(xmin = conf.low, xmax = conf.high), size = 0.45, linewidth = 0.7) +
  facet_grid(attribute ~ ., scales = "free_y", space = "free_y") +
  scale_color_manual(values = unname(okabe_ito[c("vermillion", "blue", "green", "orange", "purple", "sky", "yellow")]), guide = "none") +
  labs(x = "Marginal mean (probability a profile is chosen)", y = NULL) +
  theme_t3 +
  theme(strip.text.y = element_text(angle = 0, hjust = 0, size = 8), axis.text.y = element_text(size = 8))

ggsave("figures/sensitivity.png", fig, width = 7.2, height = 7.6, dpi = 320)

crime_mm <- mm[mm$attribute_id == "att7", ]
crime_less_mm <- crime_mm[crime_mm$level_id == "att7:level1", ]
crime_more_mm <- crime_mm[crime_mm$level_id == "att7:level2", ]

## memo.md --------------------------------------------------------------------
more_vs_less <- fit_amce("att7", "level2", "level1")
less_vs_more <- fit_amce("att7", "level1", "level2")

memo <- c(
"# Reply to Reviewer",
"",
sprintf("The reviewer is right on the mechanics. An AMCE is a contrast against a named reference level, so re-baselining relabels which comparison earns a sign and a number. We reran the crime AMCE at both references (`sensitivity-table.md`): 20%% more crime vs. 20%% less crime is %.3f (95%% CI [%.3f, %.3f]); the reverse contrast is %.3f (95%% CI [%.3f, %.3f]). Crime is binary, so only a sign flip is possible; no third baseline exists to tell a different story. For a genuinely multi-level attribute (housing cost, 3 levels) the concern has more bite: each baseline reports 2 of the 3 pairwise contrasts, and which two — and how large they look — changes with the baseline, even though all three directed contrasts are themselves unchanged.", more_vs_less$estimate, more_vs_less$conf.low, more_vs_less$conf.high, less_vs_more$estimate, less_vs_more$conf.low, less_vs_more$conf.high),
"",
sprintf("That is a real constraint on how AMCEs should be read, but it does not make the headline finding an artifact. Marginal means carry no reference category at all: each is the modeled probability that a profile with a given level is chosen, averaged over the randomized distribution of every other attribute. The IRR-corrected MM for 20%% less crime is %.3f (95%% CI [%.3f, %.3f]); for 20%% more crime it is %.3f (95%% CI [%.3f, %.3f]) (`figures/sensitivity.png`). That roughly %.0f-point, baseline-free separation is the largest within-attribute MM range of the seven attributes (%.3f vs. %.3f for the runner-up, %s) — though that %.3f gap is narrow relative to either attribute's own uncertainty and is not a precise #1-vs-#2 ranking. A sharper, fully baseline-free rebuttal: since any AMCE is just a difference of two MMs, no re-baselining of any attribute can exceed crime's own range, so crime's position at or near the top is invariant to how the contrasts are coded.", crime_less_mm$estimate, crime_less_mm$conf.low, crime_less_mm$conf.high, crime_more_mm$estimate, crime_more_mm$conf.low, crime_more_mm$conf.high, 100 * (crime_less_mm$estimate - crime_more_mm$estimate), crime_range, next_range$estimate, next_range$short_name, crime_range - next_range$estimate),
"",
"The paper is not entitled to a precise cross-attribute importance ranking from AMCE or MM-range magnitudes, since attributes differ in level count and spacing and crime's edge over commuting time is not statistically sharp. The revised manuscript will say: respondents strongly prefer communities with lower violent crime, and crime is among the strongest drivers of choice here (on a par with commuting time, ahead of the rest) — a conclusion the MMs support and that reference recoding cannot disturb, though a given contrast's displayed sign still flips if its own baseline is swapped, as expected. It will report AMCEs only alongside their named reference and drop any claim that crime is uniquely or precisely the single most important attribute. The MM figure and table become the primary exhibit; the AMCE table stays as a secondary, explicitly-labeled robustness check."
)
writeLines(memo, "memo.md")

message("Wrote sensitivity-table.md, figures/sensitivity.png, memo.md")
