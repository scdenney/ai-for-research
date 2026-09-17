# Verifiability revision · 17 September 2026

Implemented the approved storyboard using Astra-led orchestrate, Sol implementation/content review, and Terra implementation of Part 3, appendices, the numerical demonstration, and the versioned OSS snapshot. The lead integrated all work and reviewed the final PDF.

## Delivered artifact

44 physical pages: 35 main and nine appendices. Ordinary footers run consecutively from 1 to 37. Notes allocate exactly 55:00 across 35 continuous speaking intervals; this is a budget, not a measured rehearsal.

Overleaf `main`: `8e35336206c849eaf9ef09115167adb616eea920`, pushed and remote hash verified after checking the remote still matched the prior baseline `0486a4f`. Entry point `main.tex`, XeLaTeX. [Overleaf project](https://www.overleaf.com/project/6aaa697efc7ddb608ab4c4d1).

Local PDF: `../../overleaf/main.pdf`, SHA-256 `bd5f4c13a659d2feb878a598caacbd2ba40662f702414e11b1c6e33b853361f4`. Website PDF replacement and parent GitHub publication were not part of this delivery.

## What changed

- Intro: plain agent/CLI vocabulary; software feedback and research judgment; verifiability distinguished from validity; Pocock attribution.
- Part 1: Kenny/Swaney complexity–verifiability quadrant, with the role table in the appendix. Learning-evidence qualifications preserved.
- Part 2: repository and knowledge base anchor; authentic PDF/Markdown/citation linkage; Git and session continuity; citation-check and fact-check; conjoint checks; paper-review-lite; captured numerical mismatch and correction; accurate OSS verifier tiers; replication handoff.
- Part 3: dated historical claim, preserved source quotations and scoped verdict, followed by the actual recorded revision as a typeset diff.
- Context: raw release capture preserved, planning conflicts explicitly resolved, CSDP/Pocock/Swaney source provenance retained, and a separate hashed OSS 2.31.0 snapshot added.

## Validation

XeLaTeX completed with all fonts embedded, no missing-character/font warnings, and no overfull boxes. One underfull paragraph remains in the displayed historical diff; visual review found no clipping or readability defect.

All 44 pages rendered. Lead reviewed all six contact sheets and the dense revised pages at 1280×720, including compressed JPEGs. Independent Sol review checked substantive Part 2 claims against the pinned skills/verifier and numerical receipt, then visually accepted the corrected pages 19, 26, 28, 29, 32, and 44. The final geometry check reports zero out-of-page text, long diagonals, text overlaps, or fill crossings. See `checks.json`, contact sheets, and retained compressed pages.

The self-contained numerical demo was executed. Its fresh-result pipeline fails on both stale 0.31 fields and passes after both become 0.28. Failed analysis stops comparison despite a pre-existing output. Invalid, missing, nonfinite, and out-of-range results fail. Commands, exit codes, stdout/stderr, and source hashes are retained in `../../demos/verification/receipts/verification-receipt.json`. This is a project-specific comparator, not a built-in OSS numerical comparison. No external research pipeline or OSS execution-tier run is claimed.

`verify_snapshot.py` passed all 36 pinned file records. Speaker timing and footer sequence passed. Authored files pass Git whitespace checks. The unchanged installed conjoint-diagnostics snapshot retains its original trailing blank line so its pinned hash remains exact. Credential, manifest, and prose checks passed; see `deliverable-checks.json`.

## Remaining checks

Author review, timed rehearsal, actual Zoom screen sharing, and authenticated Overleaf server-preview inspection remain. Local rendering and remote Git delivery do not establish those checks. Full acquired benchmark/source copies remain local and Git-ignored under the existing source policy; the tracked provenance identifies exact revisions and hashes for transfer or reacquisition.
