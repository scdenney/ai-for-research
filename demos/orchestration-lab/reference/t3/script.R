#!/usr/bin/env Rscript
# =============================================================================
# T3 — Answer the reviewer: baseline-sensitivity of the headline (judgment tier)
# Run from this directory:  cd reference/t3 && Rscript script.R
# HEADLINE_ATTR (from T2) = Violent Crime Rate (att7), a BINARY attribute.
# Data: projoint::exampleData1 (community-choice conjoint)
# Deliverables: sensitivity-table.md, figures/sensitivity.png
#   (The human-authored grading rubric lives in RUBRIC.md, written separately.)
# =============================================================================

suppressPackageStartupMessages({
  library(projoint)
  library(ggplot2)
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
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    strip.text.y.left = element_text(angle = 0, face = "bold", hjust = 0,
                                     size = 9),
    strip.placement = "outside",
    axis.title = element_text(face = "bold"),
    legend.position = "top",
    plot.margin = margin(10, 14, 10, 10)
  )

# Default (analytical) path is deterministic; seed is a convention/safeguard.
set.seed(46)
dir.create("figures", showWarnings = FALSE)

# --- Load & reshape ----------------------------------------------------------
data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)
labels <- out$labels
att_name  <- with(labels, tapply(attribute, attribute_id, function(x) x[1]))
lev_name  <- function(id) labels$level[match(id, labels$level_id)]

HEAD_ATT <- "att7"                       # headline attribute (from T2)
OTHER1   <- "att5"                       # multi-level attr to vary (Driving Time)
OTHER2   <- "att1"                       # second multi-level attr (Housing Cost)

# --- Helper: profile-level AMCE for a level vs an explicit baseline -----------
amce_vs <- function(att, lev, base) {
  q <- set_qoi(.structure = "profile_level", .estimand = "amce",
               .att_choose = att, .lev_choose = lev,
               .att_choose_b = att, .lev_choose_b = base)
  e <- as.data.frame(suppressWarnings(projoint(out, .qoi = q))$estimates)
  data.frame(
    att = att,
    level_id = paste0(att, ":", lev),
    base_id  = paste0(att, ":", base),
    corr_pp  = 100 * e$estimate[e$estimand == "amce_corrected"],
    corr_lo  = 100 * e$conf.low[e$estimand == "amce_corrected"],
    corr_hi  = 100 * e$conf.high[e$estimand == "amce_corrected"],
    unc_pp   = 100 * e$estimate[e$estimand == "amce_uncorrected"],
    stringsAsFactors = FALSE
  )
}

# --- (A) Headline att7 (binary) under its two possible baselines --------------
# Default baseline = level1 (Less Crime); the ONLY alternative = level2 (More).
head_default <- amce_vs(HEAD_ATT, "level2", "level1")  # More vs Less  (default)
head_alt     <- amce_vs(HEAD_ATT, "level1", "level2")  # Less vs More  (flip)

# --- (B) A multi-level attribute (att5 Driving Time) under two baselines ------
d_lv <- sort(unique(labels$level_id[labels$attribute_id == OTHER1]))
d_lv <- sub(".*:", "", d_lv)                            # level1..level4
o1_base1 <- do.call(rbind, lapply(setdiff(d_lv, "level1"),
                                  function(l) amce_vs(OTHER1, l, "level1")))
o1_base4 <- do.call(rbind, lapply(setdiff(d_lv, "level4"),
                                  function(l) amce_vs(OTHER1, l, "level4")))

# --- (C) Marginal means for ALL levels (baseline-invariant) ------------------
mm <- suppressWarnings(projoint(out, .structure = "profile_level",
                                .estimand = "mm"))
mmdf <- as.data.frame(mm$estimates)
mmc  <- mmdf[mmdf$estimand == "mm_corrected", ]
mmc$att       <- sub(":.*", "", mmc$att_level_choose)
mmc$attribute <- att_name[mmc$att]
mmc$level     <- lev_name(mmc$att_level_choose)
mmc$mm        <- mmc$estimate
mmc$lo        <- mmc$conf.low
mmc$hi        <- mmc$conf.high

# attribute importance = within-attribute MM range (max - min), baseline-free
rng <- do.call(rbind, lapply(split(mmc, mmc$att), function(s) {
  data.frame(att = s$att[1], attribute = s$attribute[1],
             mm_min = min(s$mm), mm_max = max(s$mm),
             range_pp = 100 * (max(s$mm) - min(s$mm)),
             stringsAsFactors = FALSE)
}))
rng <- rng[order(-rng$range_pp), ]
rng$rank <- seq_len(nrow(rng))

# --- (D) Figure: marginal means, attributes ordered by importance ------------
ord_att <- rng$attribute[order(-rng$range_pp)]          # most important on top
mmc$attribute <- factor(mmc$attribute, levels = ord_att)
mmc <- mmc[order(mmc$attribute, mmc$att_level_choose), ]
mmc$level <- factor(mmc$level, levels = rev(unique(mmc$level)))
mmc$is_head <- mmc$att == HEAD_ATT

p <- ggplot(mmc, aes(x = mm, y = level, colour = is_head)) +
  geom_vline(xintercept = 0.5, linetype = "dashed", colour = "grey40",
             linewidth = 0.5) +
  geom_linerange(aes(xmin = lo, xmax = hi), orientation = "y",
                 linewidth = 0.6) +
  geom_point(size = 2.4) +
  facet_grid(attribute ~ ., scales = "free_y", space = "free_y",
             switch = "y", labeller = label_wrap_gen(width = 18)) +
  scale_colour_manual(
    values = c(`FALSE` = okabe_ito[["blue"]], `TRUE` = okabe_ito[["vermillion"]]),
    labels = c(`FALSE` = "Other attributes",
               `TRUE`  = "Headline: Violent Crime Rate"),
    name = NULL) +
  scale_x_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(x = "Marginal mean: Pr(profile chosen) — baseline-invariant", y = NULL) +
  theme_okabe +
  theme(axis.text.y = element_text(size = 8))

ggsave("figures/sensitivity.png", p,
       width = 10, height = 9.5, dpi = 320, bg = "white")

# --- Write sensitivity-table.md ----------------------------------------------
f1 <- function(x) { r <- ifelse(abs(x) < 0.05, 0, x)
                    ifelse(r == 0, "0.0", sprintf("%+.1f", r)) }
p1 <- function(x) sprintf("%.1f%%", 100 * x)

md <- c(
  "# T3 — Baseline-sensitivity of the headline finding (sensitivity table)",
  "",
  "*Reference solution (answer key). Headline attribute (T2) = **Violent Crime",
  "Rate**, which is a **binary** attribute. projoint 1.1.1, R 4.5.1. All AMCEs",
  "IRR-corrected unless noted; percentage points.*",
  "",
  "## 1. Headline attribute (Violent Crime Rate) under each baseline",
  "",
  "A 2-level attribute admits only two possible baselines, so there is exactly",
  "one alternative to the manuscript's default. Flipping it does not change the",
  "magnitude — only the sign and the verbal framing.",
  "",
  "| Reference set | Contrast estimated | AMCE (corrected) | 95% CI | AMCE (uncorrected) |",
  "|---|---|---|---|---|",
  sprintf("| **Default** (baseline = *%s*) | %s vs baseline | %s | [%s, %s] | %s |",
          lev_name(head_default$base_id),
          lev_name(head_default$level_id),
          f1(head_default$corr_pp), f1(head_default$corr_lo),
          f1(head_default$corr_hi), f1(head_default$unc_pp)),
  sprintf("| **Alternative** (baseline = *%s*) | %s vs baseline | %s | [%s, %s] | %s |",
          lev_name(head_alt$base_id),
          lev_name(head_alt$level_id),
          f1(head_alt$corr_pp), f1(head_alt$corr_lo),
          f1(head_alt$corr_hi), f1(head_alt$unc_pp)),
  "",
  sprintf(paste0("**|AMCE| is identical (%.1f pp corrected, %.1f pp uncorrected)",
                 " under both baselines.** The effect of Violent Crime Rate is",
                 " therefore *not* an artifact of the reference category: for a",
                 " binary attribute the AMCE and the marginal-mean gap are the",
                 " same number."),
          abs(head_default$corr_pp), abs(head_default$unc_pp)),
  "",
  "## 2. A multi-level attribute (Total Daily Driving Time) — where the reviewer is right",
  "",
  "For an attribute with >2 levels the reported level-vs-baseline AMCEs *do*",
  "change when the baseline is relabeled. Same data, two baselines:",
  "",
  "| Level | AMCE vs *10 min* (default) | AMCE vs *75 min* (alt) |",
  "|---|---|---|"
)
for (l in d_lv) {
  a <- o1_base1$corr_pp[o1_base1$level_id == paste0(OTHER1, ":", l)]
  b <- o1_base4$corr_pp[o1_base4$level_id == paste0(OTHER1, ":", l)]
  a <- if (length(a) == 0) "0.0 *(ref)*" else f1(a)
  b <- if (length(b) == 0) "0.0 *(ref)*" else f1(b)
  md <- c(md, sprintf("| %s | %s | %s |", lev_name(paste0(OTHER1, ":", l)), a, b))
}
spread1 <- 100 * (max(mmc$mm[mmc$att == OTHER1]) - min(mmc$mm[mmc$att == OTHER1]))
md <- c(md,
  "",
  sprintf(paste0("Every number in the first column differs from the second, yet",
                 " the *spread* of the attribute (max AMCE minus min AMCE = %.1f",
                 " pp) is preserved, and so are all pairwise level differences.",
                 " This is exactly the mechanical dependence the reviewer names —",
                 " real, but a relabeling, not a change in substance."),
          spread1),
  "",
  "## 3. Marginal means for ALL levels (the baseline-invariant quantity)",
  "",
  "Marginal means do not reference any baseline. They are the primitive; every",
  "AMCE is a difference of two of them.",
  "",
  "| Attribute | Level | Marginal mean | 95% CI |",
  "|---|---|---|---|"
)
mm_tab <- mmc[order(factor(mmc$att, levels = sort(unique(mmc$att))),
                    mmc$att_level_choose), ]
for (i in seq_len(nrow(mm_tab))) {
  first <- i == 1 || mm_tab$att[i] != mm_tab$att[i - 1]
  md <- c(md, sprintf("| %s | %s | %s | [%s, %s] |",
                      if (first) as.character(mm_tab$attribute[i]) else "",
                      as.character(mm_tab$level[i]),
                      p1(mm_tab$mm[i]), p1(mm_tab$lo[i]), p1(mm_tab$hi[i])))
}
md <- c(md,
  "",
  "## 4. Attribute importance by MM range (baseline-invariant ordering)",
  "",
  "| Rank | Attribute | MM range (max - min) |",
  "|---|---|---|"
)
for (i in seq_len(nrow(rng))) {
  md <- c(md, sprintf("| %d | %s | %.1f pp |",
                      rng$rank[i], rng$attribute[i], rng$range_pp[i]))
}
md <- c(md,
  "",
  sprintf(paste0("The ordering is fixed regardless of any reference-category",
                 " choice. Violent Crime Rate ranks #1 (%.1f pp), but only",
                 " ~%.1f pp ahead of Total Daily Driving Time (%.1f pp); their",
                 " endpoint CIs overlap heavily, so the #1-vs-#2 gap is within",
                 " sampling error. Housing Cost (%.1f pp) is a close third."),
          rng$range_pp[1], rng$range_pp[1] - rng$range_pp[2],
          rng$range_pp[2], rng$range_pp[3]),
  "",
  "## Figure",
  "",
  "![Marginal means by attribute](figures/sensitivity.png)",
  "",
  paste0("**Figure 1.** IRR-corrected marginal means (Pr a profile is chosen)",
         " for every attribute level, with 95% respondent-clustered CIs;",
         " attributes are ordered top-to-bottom by decreasing importance",
         " (within-attribute MM range). Marginal means are baseline-invariant.",
         " Violent Crime Rate (orange) has the widest spread — 62.6% for less",
         " crime vs 37.4% for more crime — but Driving Time is a close second,",
         " so crime is the largest single driver, not a dominant one."),
  ""
)
writeLines(md, "sensitivity-table.md")

# --- Console echo ------------------------------------------------------------
cat("T3 complete.\n")
cat(sprintf("  headline att7 AMCE: default=%.1f  alt=%.1f  (|.|=%.1f invariant)\n",
            head_default$corr_pp, head_alt$corr_pp, abs(head_default$corr_pp)))
cat(sprintf("  att5 spread preserved across baselines = %.1f pp\n", spread1))
cat("  MM range ranking (pp):\n")
for (i in seq_len(nrow(rng)))
  cat(sprintf("    %d. %-40s %.1f\n", rng$rank[i], rng$attribute[i],
              rng$range_pp[i]))
cat(sprintf("  att7 MMs: %s (less crime) vs %s (more crime)\n",
            p1(max(mmc$mm[mmc$att == HEAD_ATT])),
            p1(min(mmc$mm[mmc$att == HEAD_ATT]))))
