# Cross-vendor completion audit

Act as a read-only statistical and deliverable auditor. Do not edit files. Inspect the completed draft in the current working directory:

- `BRIEF.md` (authoritative task)
- `script.R`
- `report.md`
- `routing-log.md`
- `figures/amce-dotwhisker.png`
- `terra-advice.md` (earlier independent advice)

The lead ran `Rscript script.R` successfully. The estimator returned 17 non-reference conventional AMCEs from 6,400 profiles/400 respondents; the figure is a 3780 x 3600 RGB PNG written at 360 dpi. The report's results paragraph is 194 words before the figure and caption. No web access or package installation is permitted.

Audit the durable draft against the brief and return one decisive verdict: `PASS` or `REVISE`. Check, in particular:

1. whether the chosen conventional uncorrected profile-level AMCE is a defensible reading of the requested AMCE;
2. whether respondent-clustered uncertainty is truly requested and represented honestly, including the package warning suppression/comment and assertions;
3. every number and direction in `report.md` against the script/output or a local rerun if useful;
4. whether all seven attributes, within-attribute level order, and zero reference rows are handled correctly;
5. figure legibility, grouping, interval encoding, resolution, absence of in-plot title, and caption placement/wording;
6. reproducibility and all explicit constraints in `BRIEF.md`;
7. any overclaim or material omission.

If `REVISE`, list only concrete changes needed for compliance or correctness, ordered by severity. If `PASS`, mention any truly optional polish separately so it cannot be confused with a required revision. Do not broaden the task or propose alternate analyses merely for variety.
