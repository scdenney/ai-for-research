# Read-only Claude/Fable review: descriptive output contract

Objective: Independently review a proposed output design for a mechanical conjoint summary. Do not edit any files and do not use the web.

Authoritative task:

- R package `projoint`, built-in `exampleData1`, reshaped with:
  `out <- reshape_projoint(exampleData1, .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped"))`
- Produce `script.R`, `summary.md`, and one `figures/level-frequencies.png` at 300+ dpi.
- Summary must give respondents, tasks/respondent, profiles/task, seven human-readable attributes with level counts, and a randomization-balance check using level frequencies within each attribute.
- Figure must have no in-plot title; its one-sentence caption must sit below the Markdown image reference.
- Plotting theme and Okabe-Ito palette declared at top of the script; `set.seed()` before stochastic work.
- R only; no web; no package installs.

Observed schema: 400 respondents; 8 main tasks; 2 profiles/task; 6,400 long rows; a ninth choice screen repeats task 1 with sides flipped for reliability and is stored through repeated-choice fields rather than as additional profile draws; seven attributes and 24 levels total.

Proposed output:

- Markdown overview explicitly distinguishes 8 main randomized tasks + 1 repeat reliability screen (9 choice screens total).
- Attribute table has attribute id, human-readable name, and level count.
- Balance table has one row per level: attribute, human-readable level, count, observed share, equal expected share, and signed percentage-point deviation.
- A horizontal faceted bar chart plots observed within-attribute share for all 24 levels, with one facet per human-readable attribute, a dashed equal-allocation reference line per facet, Okabe-Ito fill mapped redundantly to facet, no legend, and no title/subtitle. Axis: `Share of profile rows within attribute (%)`; y-axis conveys attribute level. Export 8 x 12 inches at 320 dpi.
- Caption beneath image: `Observed attribute-level shares across 6,400 profile rows from 400 respondents (eight main tasks and two profiles per task); dashed lines mark the equal-allocation benchmark within each attribute.`

Question: Does this design satisfy the brief cleanly and make balance legible? Flag only concrete problems (including accessibility, scale, caption placement/content, or misleading interpretation) and give exact fixes.

Return format: verdict; concrete issues; exact fixes; residual risk. Keep it concise.
