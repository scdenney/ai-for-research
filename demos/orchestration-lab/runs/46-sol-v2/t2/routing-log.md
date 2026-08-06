# Routing log

## Route table

| Workstream | Route | Why this route | Disposition |
|---|---|---|---|
| Estimand and variance architecture | Terra (`gpt-5.6-terra`, xhigh; read-only) | The brief leaves a material choice between conventional and reliability-corrected AMCEs, and the package's CR2 fallback needed independent methodological judgment. | Followed Terra's recommendation to report only conventional uncorrected AMCEs, request Stata-style respondent-clustered SEs explicitly, and label zero reference rows as display anchors without estimated uncertainty. |
| Cross-vendor completion check | Claude peer (`fable`; read-only) | A different model family can catch unsupported interpretation, numerical transcription, code/report mismatches, and figure-legibility problems after a complete draft exists. | Returned `PASS` after a fresh read-only rerun. It independently verified all reported values/CIs, clustering metadata, references, ordering, image resolution, caption placement, and explicit constraints. |
| Package and data inspection | 46-orchestrate lead | Direct local evidence is authoritative for installed-version behavior, object structure, coefficient values, and estimator metadata. | Inspected `projoint` 1.1.1, confirmed 6,400 profile rows/400 IDs/seven attributes, traced the estimator's fallback code, and verified the returned clustering metadata. |
| Implementation and statistical interpretation | 46-orchestrate lead | Coding and final claims require accountable synthesis of the brief, package output, and peer advice. | Wrote the self-contained analysis, reference-row construction, ordered faceted figure, and approximately 200-word report. |
| Mechanical and visual verification | 46-orchestrate lead | These checks are objective and cheap to verify locally; delegation would add no useful independence. | Ran `Rscript script.R` successfully; inspected the rendered image; confirmed 3780 × 3600 pixels at 360 dpi; checked the 194-word results paragraph and all rounded claims against the 17 estimates. |

## Delegation budget

The route uses two of the three allowed delegations: one Terra consultation and one Claude cross-vendor audit. No web access, package installation, or implementation delegation was used.

## Decision record

Terra advised that the low-reliability corrected estimates are a model-dependent estimand rather than the conventional AMCE requested by the brief. I accepted that recommendation. Terra also advised explicit Stata-style clustered SEs after CR2 proved numerically invalid. Direct source inspection revealed that `projoint` 1.1.1 still emits a hard-coded CR2 fallback warning for discarded reference-vs-itself fits even when `stata` is requested. The script therefore suppresses that misleading internal warning, asserts that the returned estimator records clustering by `id` and `stata` SEs, and reports only the finite non-reference contrasts.

Fable returned `PASS` with three explicitly optional suggestions: omit the visually hidden zero-width interval geometry for references, narrow warning suppression, and mention the nonsignificant houses-only suburb contrast. None addressed a compliance or correctness defect. I declined them because the figure already explains reference uncertainty, the warning suppression is documented and guarded by estimator assertions, and the report does not imply that every place-type contrast differs from zero.

## Revision and verification record

The cross-vendor audit required no revision, so the brief's one-cycle allowance was not consumed. Final local verification consisted of a successful clean script run, inspection of the full-resolution PNG, programmatic resolution/density checks, a word count, and a claim-by-claim comparison with the printed estimate table. The final deliverables therefore reflect the initial durable analysis plus this completed routing record, not a second analytical specification.
