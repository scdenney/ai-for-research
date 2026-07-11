#!/usr/bin/env Rscript
###############################################################################
# script.R
#
# Purpose
# -------
# Conjoint AMCE baseline-sensitivity analysis for the projoint::exampleData1
# community-choice experiment. A reviewer argues that the headline claim
# ("Violent Crime Rate drives community choice") could be an artifact of the
# arbitrary reference categories used for AMCEs. This script tests that
# empirically by:
#   A. Estimating profile-level AMCEs (corrected) under the DEFAULT baselines
#      for all seven attributes.
#   B. Re-baselining the binary crime attribute (att7) -> shows the AMCE sign
#      flips exactly while |AMCE| and CI width are unchanged.
#   C. Re-baselining a MULTI-LEVEL attribute (att6, "Type of Place", 6 levels)
#      to the level whose MM is closest to 0.5 (the sample-average MM), which
#      maximally shrinks its apparent max-|AMCE| -> shows the importance
#      ordering among multi-level attributes is baseline-dependent.
#   D. Estimating profile-level MMs (corrected) for every level of every
#      attribute and computing per-attribute MM spread (max MM - min MM), a
#      baseline-INVARIANT importance measure. Crime's rank is reported.
#
# Estimation choice
# -----------------
# ALL estimates are the IRR measurement-error-CORRECTED quantities
# (amce_corrected / mm_corrected), enabled by the choice1_repeated_flipped
# task. The uncorrected estimates are never used for reporting.
#
# Re-baselining mechanism
# -----------------------
# projoint() has no .baselines argument; the AMCE baseline is always the
# level whose level_id is "<att>:level1". To move a whole-attribute baseline
# we swap the target level's level_id with level1 in BOTH out$data and
# out$labels (rebaseline() below), then re-estimate. This is exact.
#
# Outputs
# -------
#   figures/sensitivity.png   one figure, dpi=300, no in-plot title
#   sensitivity-table.md      crime AMCEs per baseline, att6 re-baselining,
#                             MMs with 95% CIs, MM-spread ranking, table note
#
# Run: Rscript script.R   (projoint, ggplot2, dplyr must be installed)
###############################################################################

set.seed(20260711)

suppressPackageStartupMessages({
  library(projoint)
  library(ggplot2)
  library(dplyr)
})

## ---- Presentation constants (declared up top) ------------------------------
# Okabe-Ito colour-blind-safe palette
okabe_ito <- c(
  black   = "#000000", orange = "#E69F00", skyblue = "#56B4E9",
  green   = "#009E73", yellow = "#F0E442", blue    = "#0072B2",
  vermil  = "#D55E00", purple = "#CC79A7", grey    = "#999999"
)

theme_sensitivity <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    strip.text       = element_text(face = "bold", hjust = 0),
    axis.title       = element_text(face = "bold"),
    plot.margin      = margin(10, 14, 10, 10),
    legend.position  = "none"
  )

## ---- Human-readable attribute names ----------------------------------------
att_names <- c(
  att1 = "Housing Cost",
  att2 = "Presidential Vote (2020)",
  att3 = "Racial Composition",
  att4 = "School Quality",
  att5 = "Daily Driving Time",
  att6 = "Type of Place",
  att7 = "Violent Crime Rate"
)

## ---- Data ------------------------------------------------------------------
data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

# Sanity check: att7 (crime) is binary
stopifnot(sum(out$labels$attribute_id == "att7") == 2L)

## ---- Helpers ---------------------------------------------------------------
# Corrected profile-level AMCE table for a projoint_data object
amce_corr <- function(o) {
  invisible(capture.output(
    s <- summary(projoint(o, .structure = "profile_level", .estimand = "amce"))
  ))
  s[s$estimand == "amce_corrected", ]
}
# Corrected profile-level MM table
mm_corr <- function(o) {
  invisible(capture.output(
    s <- summary(projoint(o, .structure = "profile_level", .estimand = "mm"))
  ))
  s[s$estimand == "mm_corrected", ]
}

# Re-baseline attribute `att` by making its level `k` the new baseline:
# swap level_id "<att>:levelk" with "<att>:level1" in data AND labels.
rebaseline <- function(o, att, k) {
  a <- paste0(att, ":level1")
  b <- paste0(att, ":level", k)
  col <- o$data[[att]]
  new <- col
  new[col == a] <- b
  new[col == b] <- a
  o$data[[att]] <- new
  li <- o$labels$level_id
  ni <- li
  ni[li == a] <- b
  ni[li == b] <- a
  o$labels$level_id <- ni
  o$labels <- o$labels[order(o$labels$level_id), ]
  o
}

# Attach human attribute + level labels to a projoint summary table,
# using the (possibly re-mapped) label tibble `lab`.
label_join <- function(tab, lab, key = "att_level_choose") {
  lab2 <- lab[, c("level_id", "attribute", "level")]
  m <- match(tab[[key]], lab2$level_id)
  tab$attribute_id <- sub(":level.*$", "", tab[[key]])
  tab$attribute    <- lab2$attribute[m]
  tab$level        <- lab2$level[m]
  tab
}

## ===========================================================================
## A. Default-baseline profile-level AMCEs (corrected), all attributes
## ===========================================================================
amce_default <- label_join(amce_corr(out), out$labels)
mm_default   <- label_join(mm_corr(out),  out$labels)

# per-attribute max-|AMCE| under default baselines
maxabs_default <- amce_default %>%
  mutate(attid = sub(":level.*$", "", att_level_choose)) %>%
  group_by(attid) %>%
  summarise(max_abs_amce = max(abs(estimate)), .groups = "drop") %>%
  mutate(attribute = att_names[attid]) %>%
  arrange(desc(max_abs_amce))

## ===========================================================================
## B. Re-baseline crime (att7): swap its two levels, re-estimate.
##    Binary attribute => exact sign flip, identical |AMCE| and CI width.
## ===========================================================================
out_c2   <- rebaseline(out, "att7", 2)
amce_c2  <- label_join(amce_corr(out_c2), out_c2$labels)

crime_b1 <- amce_default[amce_default$attribute_id == "att7", ]
crime_b2 <- amce_c2[grepl("att7", amce_c2$att_level_choose), ]
# human labels for the BASELINE (reference) level under each regime
crime_b1_base <- out$labels$level[out$labels$level_id == "att7:level1"]
crime_b2_base <- out_c2$labels$level[out_c2$labels$level_id == "att7:level1"]

## ===========================================================================
## C. Re-baseline att6 (Type of Place) to the level whose MM is closest to 0.5
##    (the sample-average MM) -> maximally shrinks its max-|AMCE|.
## ===========================================================================
mm6 <- mm_default[mm_default$attribute_id == "att6", ]
mm6$levnum <- as.integer(sub(".*level", "", mm6$att_level_choose))
alt_lev <- mm6$levnum[which.min(abs(mm6$estimate - 0.5))]      # nearest 0.5
alt_lev_label <- mm6$level[mm6$levnum == alt_lev]

out_6alt  <- rebaseline(out, "att6", alt_lev)
amce_6alt <- label_join(amce_corr(out_6alt), out_6alt$labels)

att6_maxabs_default <- max(abs(amce_default$estimate[amce_default$attribute_id == "att6"]))
att6_maxabs_alt     <- max(abs(amce_6alt$estimate[grepl("att6", amce_6alt$att_level_choose)]))

# Importance ordering (max-|AMCE|) under the ALTERNATIVE regime:
# att6 re-baselined, all other attributes at default baselines.
maxabs_alt <- maxabs_default %>%
  mutate(max_abs_amce = ifelse(attid == "att6", att6_maxabs_alt, max_abs_amce)) %>%
  arrange(desc(max_abs_amce))

## ===========================================================================
## D. Baseline-INVARIANT importance: per-attribute MM spread (max MM - min MM)
## ===========================================================================
mm_spread <- mm_default %>%
  mutate(attid = sub(":level.*$", "", att_level_choose)) %>%
  group_by(attid) %>%
  summarise(spread = max(estimate) - min(estimate), .groups = "drop") %>%
  mutate(attribute = att_names[attid]) %>%
  arrange(desc(spread))
mm_spread$rank <- seq_len(nrow(mm_spread))
crime_spread_rank <- mm_spread$rank[mm_spread$attid == "att7"]

## ---- Consistency check: AMCE(L vs baseline) == MM(L) - MM(baseline) --------
mm_lookup <- setNames(mm_default$estimate, mm_default$att_level_choose)
chk <- amce_default
chk$mm_diff <- mm_lookup[chk$att_level_choose] -
               mm_lookup[chk$att_level_choose_baseline]
chk$discrepancy <- abs(chk$estimate - chk$mm_diff)
max_discrepancy <- max(chk$discrepancy)

## ===========================================================================
## FIGURE  (one png, two facets, no in-plot title)
##   Left  : crime AMCE under the two baselines -> mirror-image sign flip
##   Right : per-attribute MM spread (baseline-invariant) -> crime ranks #1
## ===========================================================================
panelA <- data.frame(
  panel = "A. Crime AMCE flips sign under re-baselining",
  ylab  = c(sprintf("Baseline = “%s”", crime_b1_base),
            sprintf("Baseline = “%s”", crime_b2_base)),
  est   = c(crime_b1$estimate[1], crime_b2$estimate[1]),
  lo    = c(crime_b1$conf.low[1], crime_b2$conf.low[1]),
  hi    = c(crime_b1$conf.high[1], crime_b2$conf.high[1]),
  hl    = TRUE,
  stringsAsFactors = FALSE
)
# order so the two baselines sit as a mirror pair
panelA$ylab <- factor(panelA$ylab, levels = rev(panelA$ylab))

panelB <- data.frame(
  panel = "B. MM spread (baseline-invariant importance)",
  ylab  = mm_spread$attribute,
  est   = mm_spread$spread,
  lo    = NA_real_, hi = NA_real_,
  hl    = mm_spread$attid == "att7",
  stringsAsFactors = FALSE
)
panelB$ylab <- factor(panelB$ylab, levels = rev(mm_spread$attribute))

fig_df <- rbind(panelA, panelB)

p <- ggplot(fig_df, aes(x = est, y = ylab, colour = hl)) +
  geom_vline(xintercept = 0, colour = okabe_ito[["grey"]], linewidth = 0.4) +
  geom_errorbarh(aes(xmin = lo, xmax = hi), height = 0.18,
                 linewidth = 0.7, na.rm = TRUE) +
  geom_point(size = 3) +
  facet_wrap(~panel, scales = "free", ncol = 2) +
  scale_colour_manual(values = c("TRUE"  = okabe_ito[["vermil"]],
                                 "FALSE" = okabe_ito[["blue"]])) +
  labs(
    x = "Corrected estimate (AMCE in panel A, MM spread in panel B), probability units",
    y = NULL
  ) +
  theme_sensitivity

dir.create("figures", showWarnings = FALSE)
ggsave("figures/sensitivity.png", p, width = 11, height = 5.2,
       dpi = 300, bg = "white")

## ===========================================================================
## MARKDOWN TABLE
## ===========================================================================
r3 <- function(x) formatC(round(x, 3), format = "f", digits = 3)
ci <- function(lo, hi) sprintf("[%s, %s]", r3(lo), r3(hi))

lines <- c(
  "# Baseline-Sensitivity of the Violent-Crime Conjoint Finding",
  "",
  "All estimates are IRR measurement-error-**corrected** profile-level",
  "quantities (projoint `amce_corrected` / `mm_corrected`), using the",
  "`choice1_repeated_flipped` task. Estimates in probability units; 95% CIs.",
  "",
  "## (i) Crime attribute (att7) AMCE under each baseline choice",
  "",
  "| Baseline (reference level) | Contrast level | AMCE (corrected) | 95% CI |",
  "|---|---|---|---|",
  sprintf("| %s | %s | %s | %s |",
          crime_b1_base, crime_b1$level[1],
          r3(crime_b1$estimate[1]), ci(crime_b1$conf.low[1], crime_b1$conf.high[1])),
  sprintf("| %s | %s | %s | %s |",
          crime_b2_base, crime_b2$level[1],
          r3(crime_b2$estimate[1]), ci(crime_b2$conf.low[1], crime_b2$conf.high[1])),
  "",
  sprintf("Binary attribute: re-baselining flips the sign exactly (%s vs %s); |AMCE| = %s and CI width are identical.",
          r3(crime_b1$estimate[1]), r3(crime_b2$estimate[1]), r3(abs(crime_b1$estimate[1]))),
  "",
  "## (ii) att6 (Type of Place) re-baselining: max-|AMCE| under each baseline",
  "",
  sprintf("Alternative baseline chosen = level %d (“%s”), the level whose MM is closest to the sample-average MM of 0.5.",
          alt_lev, alt_lev_label),
  "",
  "| Baseline for att6 | max-\\|AMCE\\| (corrected) |",
  "|---|---|",
  sprintf("| Default (level1, “%s”) | %s |",
          out$labels$level[out$labels$level_id == "att6:level1"], r3(att6_maxabs_default)),
  sprintf("| Alternative (level%d, “%s”) | %s |",
          alt_lev, alt_lev_label, r3(att6_maxabs_alt)),
  "",
  "## (iii) Attribute-importance ordering by max-|AMCE|",
  "",
  "| Rank | Default baselines | max-\\|AMCE\\| | Alternative regime (att6 re-baselined) | max-\\|AMCE\\| |",
  "|---|---|---|---|---|"
)
for (i in seq_len(nrow(maxabs_default))) {
  lines <- c(lines, sprintf("| %d | %s | %s | %s | %s |",
    i,
    maxabs_default$attribute[i], r3(maxabs_default$max_abs_amce[i]),
    maxabs_alt$attribute[i],     r3(maxabs_alt$max_abs_amce[i])))
}

lines <- c(lines,
  "",
  "## (iv) Baseline-INVARIANT importance: per-attribute MM spread",
  "",
  "| Rank | Attribute | MM spread (max MM − min MM) |",
  "|---|---|---|"
)
for (i in seq_len(nrow(mm_spread))) {
  lines <- c(lines, sprintf("| %d | %s | %s |",
    mm_spread$rank[i], mm_spread$attribute[i], r3(mm_spread$spread[i])))
}

# MM tables for crime and att6 (full), plus compact all-attribute MMs
mm_tab <- function(attid) {
  d <- mm_default[mm_default$attribute_id == attid, ]
  d <- d[order(d$att_level_choose), ]
  c(sprintf("### MMs — %s (%s)", att_names[attid], attid), "",
    "| Level | MM (corrected) | 95% CI |", "|---|---|---|",
    sprintf("| %s | %s | %s |", d$level, r3(d$estimate), ci(d$conf.low, d$conf.high)),
    "")
}
lines <- c(lines,
  "",
  "## (v) Marginal Means with 95% CIs",
  "",
  mm_tab("att7"),
  mm_tab("att6")
)

# compact all-attribute MM table
lines <- c(lines,
  "### MMs — all attributes (compact)",
  "",
  "| Attribute | Level | MM (corrected) | 95% CI |",
  "|---|---|---|---|"
)
mm_all <- mm_default[order(mm_default$att_level_choose), ]
for (i in seq_len(nrow(mm_all))) {
  lines <- c(lines, sprintf("| %s | %s | %s | %s |",
    att_names[mm_all$attribute_id[i]], mm_all$level[i],
    r3(mm_all$estimate[i]), ci(mm_all$conf.low[i], mm_all$conf.high[i])))
}

lines <- c(lines,
  "",
  "## Table note",
  "",
  sprintf("All quantities are IRR measurement-error-**corrected** profile-level estimates (projoint `amce_corrected` / `mm_corrected`; tau estimated from `choice1_repeated_flipped`). In (i), each column names its reference (baseline) level; the AMCE is the listed contrast level vs that reference. In (iii), the default column uses each attribute's level1 as baseline, and the alternative column re-baselines att6 to level%d (“%s”) while all other attributes stay at their default baseline. MM spread (iv) and marginal means (v) do not depend on any baseline. AMCE≡MM-difference consistency check: max discrepancy = %.2e across all default contrasts. Estimates in probability units, rounded to 3 decimals.",
    alt_lev, alt_lev_label, max_discrepancy)
)

writeLines(lines, "sensitivity-table.md")

## ---- Console summary (for the orchestrator) --------------------------------
cat("\n===== RESULTS =====\n")
cat(sprintf("Crime AMCE (corrected): baseline='%s', contrast='%s' -> %.3f [%.3f, %.3f]\n",
            crime_b1_base, crime_b1$level[1], crime_b1$estimate[1], crime_b1$conf.low[1], crime_b1$conf.high[1]))
cat(sprintf("Crime AMCE (corrected): baseline='%s', contrast='%s' -> %.3f [%.3f, %.3f]\n",
            crime_b2_base, crime_b2$level[1], crime_b2$estimate[1], crime_b2$conf.low[1], crime_b2$conf.high[1]))
cat(sprintf("att6 max-|AMCE|: default=%.3f  alt(level%d,'%s')=%.3f\n",
            att6_maxabs_default, alt_lev, alt_lev_label, att6_maxabs_alt))
cat("\nmax-|AMCE| ranking (default):\n"); print(maxabs_default[, c("attribute","max_abs_amce")])
cat("\nmax-|AMCE| ranking (alt regime):\n"); print(maxabs_alt[, c("attribute","max_abs_amce")])
cat("\nMM-spread ranking (invariant):\n"); print(mm_spread[, c("rank","attribute","spread")])
cat(sprintf("\nCrime rank by MM spread: %d\n", crime_spread_rank))
cat(sprintf("Crime MMs: level1='%s' %.3f [%.3f,%.3f]; level2='%s' %.3f [%.3f,%.3f]\n",
            mm_default$level[mm_default$att_level_choose=="att7:level1"],
            mm_default$estimate[mm_default$att_level_choose=="att7:level1"],
            mm_default$conf.low[mm_default$att_level_choose=="att7:level1"],
            mm_default$conf.high[mm_default$att_level_choose=="att7:level1"],
            mm_default$level[mm_default$att_level_choose=="att7:level2"],
            mm_default$estimate[mm_default$att_level_choose=="att7:level2"],
            mm_default$conf.low[mm_default$att_level_choose=="att7:level2"],
            mm_default$conf.high[mm_default$att_level_choose=="att7:level2"]))
cat(sprintf("Max AMCE=MM-diff discrepancy: %.3e\n", max_discrepancy))
cat("Artifacts: figures/sensitivity.png, sensitivity-table.md\n")
