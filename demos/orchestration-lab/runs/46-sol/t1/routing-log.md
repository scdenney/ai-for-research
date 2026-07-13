# Routing log

## Route table

| Workstream | Owner | Why this owner | Acceptance check |
|---|---|---|---|
| Design interpretation and implementation specification | Sol (lead, direct) | The lead retained the analytical decision about whether the repeated reliability task belongs in the experimental task count and fixed the balance estimand. | Confirm `out$data` has 400 respondents, eight experimental tasks, two profiles per respondent-task, and 6,400 profile rows; treat the repeated flipped outcome as reliability fields rather than a ninth randomized task. |
| Mechanical R implementation and rendering | Terra out-of-band | Writing a self-contained script and rendering deterministic descriptive outputs were bounded, mechanically testable work. | `Rscript script.R` exits zero and recreates `summary.md` plus the sole 300+ dpi PNG. |
| Independent audit, visual review, and integration | Sol (lead, direct) | Final correctness, interpretation, and artifact quality remain lead responsibilities. | Independently recompute all design dimensions and attribute totals; inspect the PNG; confirm all labels, caption placement, figure count, palette, and no-title constraint. |

## Out-of-band calls

### Implementation

```bash
codex exec --model gpt-5.6-terra -c model_reasoning_effort=low --sandbox workspace-write --skip-git-repo-check -C "$PWD" 'Objective: Implement the fully specified descriptive-design analysis in BRIEF.md. Inputs and authoritative paths: ./BRIEF.md and the installed R package projoint with built-in exampleData1. In scope: create only ./script.R, ./summary.md, and ./figures/level-frequencies.png. Out of scope: analytical reinterpretation, web access, package installation, edits to BRIEF.md, routing-log.md, sol-session.log, or any terra log. Constraints and invariants: use Rscript for all analysis; script.R must be self-contained and recreate summary.md and the PNG from scratch; load library(projoint), data(exampleData1), and call reshape_projoint exactly with outcomes choice1 through choice8 plus choice1_repeated_flipped; declare an Okabe-Ito palette and the plotting theme near the top; call set.seed before any stochastic operation; report 400 unique respondents, 8 experimental tasks per respondent, and 2 profiles per task based on out$data; explicitly note that the repeated flipped task is represented by reliability fields and is not a ninth randomized profile task; map att1 through att7 to human-readable attribute and level labels via out$labels; list all seven attributes and their level counts; compute a randomization-balance table over all 6400 profile presentations for every attribute-level pair, with count, percent within attribute, expected percent under equal allocation, and percentage-point deviation; do not hard-code substantive counts or labels when they can be derived; preserve explicit zero-count factor levels if any; produce one legible descriptive faceted figure showing within-attribute level percentages with a vertical equal-allocation reference line in each facet, using an Okabe-Ito color, no in-plot title, and save at 300 dpi or higher; put a one-sentence caption directly below the figure reference in summary.md; use relative paths and create figures if absent. Expected artifact: those three files only. Acceptance checks: Rscript script.R exits zero in a clean rerun; summary values reconcile to nrow(out$data)=6400 and exactly seven attributes; each attribute frequency count sums to 6400 and percentages sum to 100 percent allowing rounding; PNG is at least 300 dpi and has no embedded plot title. Return format: conclusion, evidence, changed files, residual risk.' < /dev/null > terra-implementation.log 2>&1
```

tokens used: 67,525

### Narrow retry

```bash
codex exec --model gpt-5.6-terra -c model_reasoning_effort=low --sandbox workspace-write --skip-git-repo-check -C "$PWD" 'This is a single mechanical implementation retry. Do not use any skill, advisor, subagent, nested codex exec, web access, or package installation. Create only script.R, summary.md, and figures/level-frequencies.png. Read BRIEF.md. Implement a self-contained R script using installed projoint and ggplot2. Near the top declare a named Okabe-Ito palette and a reusable ggplot theme, then set.seed. Load exampleData1 and call reshape_projoint with choice1 through choice8 and choice1_repeated_flipped exactly as BRIEF.md specifies. Derive from out$data and out$labels: 400 unique respondents; 8 tasks per respondent; 2 profiles per task; seven human-readable attribute names and level counts; and all 24 level frequencies. For each attribute-level row report count, percent within attribute, equal-allocation expected percent, and percentage-point deviation. Preserve zero-count factor levels. State that the repeated flipped task appears in reliability fields and is not a ninth randomized task. Generate one faceted horizontal frequency plot at 300 dpi or higher, using an Okabe-Ito color, a per-facet dashed equal-allocation reference line, and no plot title. Write summary.md with a compact design table, attribute level-count table, complete balance table, then a Markdown reference to figures/level-frequencies.png followed immediately by a one-sentence caption. Use only relative paths and create figures if needed. End by running Rscript script.R yourself and checking: 6400 long rows; seven attributes; each attribute counts sum to 6400; percentages sum to 100 modulo rounding; all requested files exist. Return only after the artifacts pass.' < /dev/null > terra-implementation-retry.log 2>&1
```

tokens used: 5,981

## What the lead reasoned directly

The lead determined that the reshaped analysis data contain eight randomized choice tasks: the repeated flipped item is folded into `selected_repeated` and `agree`, so counting it as a ninth task would be wrong. The lead also defined balance over all 6,400 profile presentations within each attribute, with equal-allocation percentages as descriptive reference values, and required all labeled factor levels to remain visible even if a level had zero observations. Final integration strengthened the script to verify constant tasks and profiles for every respondent rather than infer them only from aggregate dimensions.

## Friction

The first one-shot invoked the advisor skill despite having a mechanical contract; its nested advisory call was blocked by the worker sandbox. The surrounding process appeared to return before the worker had flushed its artifact and final log, so a narrow retry was issued. That retry incorrectly claimed it lacked shell/file tools and wrote nothing, although it did report a token count. The original worker subsequently completed the artifacts and log. Lead visual inspection then found a clipped long facet heading; the single revision cycle wrapped facet labels, moved the seed below the top-level palette/theme declarations, and strengthened per-respondent design checks. No web access, package installation, Sol spawn, or writes outside this leaf were used.

[SOL LEAD TOKENS: 103,100]  + Terra one-shots: 73,506  = 176,606
