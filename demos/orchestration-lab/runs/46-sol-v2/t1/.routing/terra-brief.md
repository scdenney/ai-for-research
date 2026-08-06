# Read-only Terra review: conjoint design accounting

Objective: Independently validate the design-accounting logic for a mechanical reporting task. Do not edit any files.

Authoritative task:

- R package `projoint`, built-in `exampleData1`.
- Required reshape:
  `out <- reshape_projoint(exampleData1, .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped"))`
- Required summary: respondents, tasks per respondent, profiles per task, seven human-readable attributes with level counts, and a randomization-balance check based on level frequencies within each attribute.
- Required plot: one PNG of attribute-level frequencies, at least 300 dpi, no title in the image; a one-sentence caption must appear below its Markdown reference.
- Use R for all analysis; no web and no package installation.

Observed by the lead from R 4.5.1 and `projoint` 1.1.1:

- `exampleData1` is 400 x 185.
- `out$data` is 6,400 x 13.
- `out$data` has `id`, `task`, `profile`, `att1`...`att7`, `selected`, `selected_repeated`, and `agree`.
- `task` has the eight main tasks; the repeated flipped response is attached through reliability columns for task 1, rather than adding another set of profile rows.
- `out$labels` is a 24-row mapping with `attribute`, `level`, `attribute_id`, and `level_id`.

Proposed accounting:

1. Report 400 respondents; 8 main randomized tasks per respondent plus 1 repeated task-1 reliability screen (9 choice screens total); 2 profiles per task.
2. Compute each level's count among the 6,400 long-format profile rows for that attribute.
3. Within each attribute, compute observed share, equal-allocation benchmark `1 / number_of_levels`, and percentage-point deviation; report the maximum absolute deviation as a compact balance diagnostic.
4. Assert respondent/task/profile cardinalities and that counts sum to 6,400 within every attribute.

Question: Is this task/repeat interpretation and balance denominator mechanically correct? Identify any concrete correction or missing deterministic validation that matters for the requested deliverables.

Return format: conclusion; evidence/reasoning; concrete corrections if any; residual risk. Keep it concise.
