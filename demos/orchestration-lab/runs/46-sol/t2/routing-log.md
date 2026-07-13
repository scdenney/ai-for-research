# Routing log

## Route table

| Workstream | Owner | Why this owner | Acceptance check |
|---|---|---|---|
| Estimand, estimator, correction, references, and uncertainty interpretation | Sol (lead, direct) | These compact analytical choices determine the meaning of every result and required lead-level judgment. | `projoint` profile-level corrected AMCEs for all seven attributes; first-listed references at zero; fitted object records respondent clustering by `id`. |
| Initial script execution and deliverable production | Terra out-of-band | Once the analytical contract was fixed, R implementation, joins, plotting, and draft generation were bounded work with objective checks. | `Rscript script.R` exits zero; 24 ordered levels in seven groups; seven zero references; report numbers match corrected estimates; PNG is at least 300 dpi. |
| Statistical, textual, and visual verification and integration | Sol (lead, direct) | Final accountability required independent inspection of code, numerical output, prose, and the rendered image. | Clean rerun; largest effects reproduced; 181-word paragraph; no in-plot title; caption below image reference; 2960 x 4640 PNG at 320 dpi. |

## Out-of-band calls

One Terra one-shot was issued. Exact command:

```bash
codex exec --model gpt-5.6-terra -c model_reasoning_effort=medium --sandbox workspace-write --skip-git-repo-check -C "$PWD" 'Objective: Create the initial requested analysis deliverables from BRIEF.md using the fixed lead specification below.
Inputs and authoritative paths: ./BRIEF.md and the installed R package projoint with exampleData1. Work only in the current directory.
In scope: Write ./script.R; when run, it must create ./figures/amce-dotwhisker.png and ./report.md. Run Rscript script.R. Use reshape_projoint exactly with outcomes choice1 through choice8 plus choice1_repeated_flipped. Fit projoint(out, .structure="profile_level", .estimand="amce", .se_method="analytical", .auto_cluster=TRUE). Select estimand == "amce_corrected" for reporting and plotting. Join label metadata, add all seven level1 reference rows with estimate and interval endpoints equal to zero, and preserve label-table attribute and within-attribute level order. Assert seven attributes and respondent clustering by id from the fitted object. Report the estimated tau and the actual variance fallback accurately if useful, but do not overfocus on it.
Out of scope: Do not alter BRIEF.md or sol-session.log. Do not write routing-log.md. Do not use the web, install packages, commit, or touch any parent/sibling directory.
Constraints and invariants: script.R is self-contained; declare an Okabe-Ito palette and a ggplot theme at the top, then call set.seed before anything stochastic. Use only installed packages. Figure is grouped clearly by attribute, includes labeled reference levels at zero, has a visible vertical zero line, corrected AMCE dots and 95 percent whiskers, no in-plot title, caption belongs in report.md under the Markdown figure reference, and export is at least 300 dpi. Avoid an in-plot caption too. Report is one paper-ready results paragraph roughly 200 words, identifies largest corrected effects with direction and percentage-point magnitudes, and includes one sentence on respondent-clustered 95 percent uncertainty. Put a Markdown image reference after the paragraph and its plain-text caption immediately below it. Any methods wording must state corrected AMCEs relative to the first-listed level of each attribute. Prefer a readable tall plot and Okabe-Ito colors by attribute.
Write ownership: Only ./script.R, ./report.md, and ./figures/amce-dotwhisker.png plus creation of ./figures if absent. Shared workspace may change; reread files before edits. Use apply_patch for text-file edits.
Expected artifact: The three deliverables above, reproducible by Rscript script.R.
Acceptance checks: Rscript script.R exits zero; PNG metadata is 300 dpi or greater; plot contains 24 levels in seven ordered groups including seven zero references; reported numbers match corrected rows; fit cluster_by is id; report is approximately 180 to 230 words excluding caption.
Return format: conclusion, evidence including key estimates and checks, changed files, residual risk.' < /dev/null > terra-implementation.log 2>&1
```

tokens used: 87,170

## What Sol reasoned directly

The lead selected profile-level rather than choice-level estimation because the outcome is profile choice and the task requests effects for every attribute. The repeated task was intentionally retained so `projoint` could estimate intra-respondent reliability; the lead chose the reliability-corrected AMCE rows as the single reported estimand, rather than mixing corrected and uncorrected effects. The lead also fixed first-listed levels as the reference categories, determined that those references must be reconstructed as explicit zero rows, interpreted magnitudes on the probability scale, and verified that the estimator clustered on respondent `id`. The lead independently adjudicated the largest effects, uncertainty language, figure organization, and final prose.

## Friction

`projoint` attempted CR2 analytical variances but detected non-PSD/NA variances and used its clustered `stata` fallback; the fitted object still records clustering by `id`, and the script asserts this. Terra's first plot used left-side facet strips that consumed too much horizontal space, and its draft incorrectly described the reliability correction as adjustment for profile-level dependence. In the one permitted revision cycle, Sol replaced the strips with compact top strips, corrected the language to intra-respondent reliability, and replaced deprecated `geom_errorbarh()` with oriented `geom_errorbar()`. Terra also attempted an unnecessary nested advisory consult, which could not launch under its transitive sandbox; no extra reviewer output was used. One verification shell command used zsh's reserved `status` variable and was immediately rerun with `rc`; it did not affect the deliverables. No web access or package installation occurred.

[SOL LEAD TOKENS: 115,379]  + Terra one-shots: 87,170  = 202,549
