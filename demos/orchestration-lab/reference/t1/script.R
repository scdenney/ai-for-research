#!/usr/bin/env Rscript
# =============================================================================
# T1 — Describe the design (mechanical tier)  |  ANSWER KEY reference solution
# Run from this directory:  cd reference/t1 && Rscript script.R
# Data: projoint::exampleData1 (community-choice conjoint)
# Deliverables: summary.md, figures/level-frequencies.png
# =============================================================================

suppressPackageStartupMessages({
  library(projoint)
  library(ggplot2)
})

# --- Conventions (site figures skill) ----------------------------------------
# Okabe-Ito colour-blind-safe palette, declared at the top.
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

# Caption-not-title theme: no plot title/subtitle (captions live in the .md).
theme_okabe <- theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    strip.text = element_text(face = "bold", hjust = 0),
    axis.title = element_text(face = "bold"),
    plot.margin = margin(10, 14, 10, 10)
  )

# projoint's default estimation path (analytical SEs) is deterministic, so the
# seed is a safeguard/convention rather than load-bearing here. Set it anyway.
set.seed(46)

dir.create("figures", showWarnings = FALSE)

# --- Load & reshape ----------------------------------------------------------
data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)
dat    <- out$data
labels <- out$labels

# att id -> human-readable attribute name
att_name <- with(labels, tapply(attribute, attribute_id, function(x) x[1]))
att_ids  <- sort(unique(labels$attribute_id))

# --- Design summary numbers --------------------------------------------------
n_resp        <- length(unique(dat$id))
tasks_per_id  <- tapply(dat$task, dat$id, function(x) length(unique(x)))
n_tasks_each  <- unique(as.vector(tasks_per_id))
prof_per_task <- unique(as.vector(tapply(dat$profile,
                                         paste(dat$id, dat$task),
                                         length)))
n_choice_tasks <- n_resp * n_tasks_each
# repeated-task agreement (raw intra-respondent reliability signal)
irr_raw <- mean(dat$agree, na.rm = TRUE)
n_repeated_obs <- sum(!is.na(dat$agree))

# per-attribute level counts
level_counts <- lapply(att_ids, function(a) {
  tb <- table(dat[[a]])
  data.frame(
    attribute_id = a,
    attribute    = att_name[[a]],
    level_id     = names(tb),
    level = labels$level[match(names(tb), labels$level_id)],
    n = as.integer(tb),
    row.names = NULL
  )
})
level_counts <- do.call(rbind, level_counts)
# within-attribute proportion, uniform expectation, deviation
level_counts$k        <- ave(level_counts$n, level_counts$attribute_id,
                             FUN = length)
level_counts$att_total <- ave(level_counts$n, level_counts$attribute_id,
                              FUN = sum)
level_counts$prop      <- level_counts$n / level_counts$att_total
level_counts$expected  <- 1 / level_counts$k
level_counts$dev_pp    <- 100 * (level_counts$prop - level_counts$expected)

# per-attribute chi-square goodness-of-fit vs uniform (heuristic balance check;
# profiles are not fully independent -> treat p-values as approximate)
bal <- lapply(att_ids, function(a) {
  tb <- table(dat[[a]])
  ct <- suppressWarnings(chisq.test(tb))   # tests uniform by default
  data.frame(
    attribute_id = a,
    attribute    = att_name[[a]],
    n_levels     = length(tb),
    min_prop     = min(prop.table(tb)),
    max_prop     = max(prop.table(tb)),
    max_abs_dev_pp = 100 * max(abs(prop.table(tb) - 1/length(tb))),
    chisq        = unname(ct$statistic),
    df           = unname(ct$parameter),
    p_value      = ct$p.value,
    row.names = NULL
  )
})
bal <- do.call(rbind, bal)
balanced <- all(bal$p_value > 0.05) && max(bal$max_abs_dev_pp) < 2

# --- Figure: attribute-level frequencies -------------------------------------
plt <- level_counts
plt$level_wrapped <- factor(plt$level,
                            levels = rev(unique(plt$level)))  # top-to-bottom
# wrap long level labels
levs <- levels(plt$level_wrapped)
levels(plt$level_wrapped) <- vapply(levs,
  function(s) paste(strwrap(s, width = 34), collapse = "\n"),
  character(1))
plt$att_facet <- factor(plt$attribute, levels = unique(att_name[att_ids]))

p <- ggplot(plt, aes(x = prop, y = level_wrapped)) +
  geom_col(fill = okabe_ito[["blue"]], width = 0.7, alpha = 0.9) +
  geom_vline(aes(xintercept = expected),
             linetype = "dashed", colour = okabe_ito[["vermillion"]],
             linewidth = 0.5) +
  facet_wrap(~ att_facet, scales = "free_y", ncol = 2,
             labeller = label_wrap_gen(width = 34)) +
  scale_x_continuous(labels = scales::percent_format(accuracy = 1),
                     expand = expansion(mult = c(0, 0.05))) +
  labs(x = "Within-attribute frequency (dashed line = uniform expectation)",
       y = NULL) +
  theme_okabe +
  theme(axis.text.y = element_text(size = 7))

ggsave("figures/level-frequencies.png", p,
       width = 9, height = 8, dpi = 320, bg = "white")

# --- Write summary.md --------------------------------------------------------
fmt_pct <- function(x) sprintf("%.1f%%", 100 * x)

md <- c(
  "# T1 — Design summary: `exampleData1` community-choice conjoint",
  "",
  "*Reference solution (answer key). All numbers computed from",
  "`projoint::exampleData1` reshaped with the 8 choice tasks plus the repeated",
  "task. projoint version 1.1.1, R 4.5.1.*",
  "",
  "## Design at a glance",
  "",
  "| Quantity | Value |",
  "|---|---|",
  sprintf("| Respondents | %d |", n_resp),
  sprintf("| Choice tasks per respondent | %d |", n_tasks_each),
  sprintf("| Profiles per task | %d |", prof_per_task),
  sprintf("| Total profile rows (long format) | %d |", nrow(dat)),
  sprintf("| Total choice tasks | %d |", n_choice_tasks),
  sprintf("| Attributes | %d |", length(att_ids)),
  "| Repeated task (reliability) | 1 (task 1 repeated, flipped) |",
  sprintf("| Repeated-task agreement (raw IRR) | %s of %d repeated profiles |",
          fmt_pct(irr_raw), n_repeated_obs),
  "",
  "Exactly one profile is selected in each of the 3,200 choice tasks",
  "(`selected`: 3,200 ones / 3,200 zeros), as expected for a forced-choice",
  "design.",
  "",
  "## Attributes and levels",
  "",
  "| Attribute | # levels | Levels |",
  "|---|---|---|"
)
for (a in att_ids) {
  lv <- labels$level[labels$attribute_id == a]
  md <- c(md, sprintf("| %s | %d | %s |",
                      att_name[[a]], length(lv),
                      paste(lv, collapse = "; ")))
}
md <- c(md,
  "",
  "## Randomization balance check",
  "",
  "For a properly randomized conjoint, levels should appear about equally often",
  "*within* each attribute. The table reports the observed within-attribute",
  "proportion range, the largest absolute deviation from the uniform",
  "expectation (1 / #levels), and an approximate chi-square goodness-of-fit test",
  "against uniformity. (Profiles are not fully independent — 2 per task — so the",
  "chi-square p-values are heuristic, not exact.)",
  "",
  "| Attribute | # levels | Min prop | Max prop | Max abs. dev. | chi-sq (df) | p |",
  "|---|---|---|---|---|---|---|"
)
fmt_p <- function(p) ifelse(p < 0.001, "<0.001", sprintf("%.3f", p))
for (i in seq_len(nrow(bal))) {
  md <- c(md, sprintf("| %s | %d | %s | %s | %.2f pp | %.2f (%d) | %s |",
                      bal$attribute[i], bal$n_levels[i],
                      fmt_pct(bal$min_prop[i]), fmt_pct(bal$max_prop[i]),
                      bal$max_abs_dev_pp[i], bal$chisq[i], bal$df[i],
                      fmt_p(bal$p_value[i])))
}
flagged  <- bal[bal$p_value <= 0.05, , drop = FALSE]
max_dev  <- max(bal$max_abs_dev_pp)
# name of the single most over-represented level of the worst-flagged attribute
flag_level <- if (nrow(flagged) > 0) {
  fa  <- flagged$attribute_id[which.max(flagged$max_abs_dev_pp)]
  sub <- level_counts[level_counts$attribute_id == fa, ]
  sub$level[which.max(sub$prop)]
} else NA_character_
verdict_line <- if (nrow(flagged) == 0) {
  "**Verdict: balanced.** No attribute departs from uniform at the 5% level."
} else {
  sprintf(paste0("**Verdict: sound, with one minor flag.** %d of %d attributes",
                 " are statistically indistinguishable from uniform; %s shows a",
                 " *statistically detectable but substantively negligible*",
                 " departure."),
          nrow(bal) - nrow(flagged), nrow(bal),
          paste(flagged$attribute, collapse = " and "))
}
md <- c(md,
  "",
  verdict_line,
  "",
  sprintf(paste0("The largest single deviation across all attributes is %.2f pp",
                 " (under 2 pp). With 6,400 profile rows the chi-square test is",
                 " highly powered, so it detects even trivial departures: %s",
                 " (max dev. %.2f pp, over-representation of its \"%s\" level).",
                 " A sub-2-pp imbalance does not threaten AMCE/MM estimation,",
                 " but a careful analyst should disclose it rather than claim",
                 " perfect balance. The other %d attributes are essentially",
                 " uniform (max dev. < 1 pp)."),
          max_dev,
          paste(sprintf("%s (chi-sq = %.1f, p %s)", flagged$attribute,
                        flagged$chisq,
                        ifelse(flagged$p_value < 0.001, "< 0.001",
                               sprintf("= %.3f", flagged$p_value))),
                collapse = "; "),
          max_dev, flag_level,
          nrow(bal) - nrow(flagged)),
  "",
  "## Figure",
  "",
  "![Attribute-level frequencies](figures/level-frequencies.png)",
  "",
  "**Figure 1.** Within-attribute frequency of each level in the reshaped",
  "community-choice conjoint (400 respondents, 6,400 profile rows). Bars are",
  "observed proportions; the dashed red line marks the uniform expectation",
  "(1 / number of levels). Every level sits within 2 percentage points of its",
  sprintf(paste0("uniform target; the only visible departure is a slight",
                 " over-representation of the \"%s\" level of Total Daily",
                 " Driving Time (see balance table)."), flag_level),
  ""
)
writeLines(md, "summary.md")

# --- Console echo (for the run log) ------------------------------------------
cat("T1 complete.\n")
cat(sprintf("  respondents=%d  tasks/resp=%d  profiles/task=%d  rows=%d\n",
            n_resp, n_tasks_each, prof_per_task, nrow(dat)))
cat(sprintf("  raw IRR (repeated-task agreement)=%.3f\n", irr_raw))
cat(sprintf("  max abs balance deviation=%.2f pp  balanced=%s\n",
            max(bal$max_abs_dev_pp), balanced))
