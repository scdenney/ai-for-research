# Full-deck validation · 16 September 2026

The user approved the five-slide design preview, requested the full deck, and clarified delivery to the existing **Overleaf project**. The full deck entry point is `overleaf/main.tex`. The preview remains independently compilable.

## Build and structure

- XeLaTeX compiled the final source twice with no compilation warnings, missing characters, overfull boxes, or underfull boxes.
- 36 pages: 30 numbered content slides, three unnumbered part dividers, three appendix pages (A1–A3).
- Speaker notes cover all 30 content slides and all three appendix pages. Content numbers and PDF page mappings were checked against extracted PDF text.
- Thirty consecutive timing intervals run from 00:00 to 55:00 without gaps or overlaps. This is a delivery budget, not a measured rehearsal.
- `pdffonts` confirms EB Garamond Regular and Noto Sans Mono are embedded with Unicode mappings.
- Measured text contrast is unchanged from the approved preview: every text/background pair clears 4.5:1. Ratios are recorded in the preamble.
- No Korean text or stray literal `newline` labels in the final extracted PDF text.

## Visual inspection

Every page was rendered to 1280 × 720 PNG and inspected. After corrections, the complete sequence was reviewed again in contact sheets; the final three changed pages were re-rendered and inspected individually.

Corrections included: removing awkward automatic word breaks, shortening crowded row labels, reserving a separate footer area for slide numbers, repairing two escaped line breaks in links/source metadata, shortening a long credit, enlarging the source-image comparison across the slide, and keeping the historical draft quotation to two lines.

Programmatic text-bound inspection found no spans outside the intended page margins. This supplements the visual review; it is not used as a substitute for it. Titles fit on one line; table rows and diagram labels remain separated.

PDF pages 13, 16, 18, 19, and 31 (workspace, resource links, source intake, source diagram, historical comparison) were also inspected after downsampling to 960 × 540, JPEG quality 45/chroma subsampling, and upscaling to 1280 × 720. The main text and diagram relationships remain readable. Small credits and the italic original-source crop soften, while the larger transcription stays legible. This is a compression simulation, not an actual Zoom check.

## Evidence and checks

- Instruction excerpts on content slide 13 checked against NWO project instructions and `fact-check/SKILL.md`.
- Original PDF crop inspected against the corresponding Markdown abstract. It is labelled an excerpt and its crop recipe is recorded in `overleaf/figures/README.md`.
- Historical before/after wording checked against manuscript commit `75366c6`, dated 27 August 2026. The demo is explicitly a historical reconstruction; no new skill report or terminal receipt is fabricated.
- Resource destinations checked against the public AI for Research and Open Science Skills pages. PDF hyperlink targets extracted and checked for the resource URLs and source DOI.
- Current skill roles checked against OSS research-repo, citation-check, fact-check, literature-review, and replication-package instructions. Replication-package's adaptation of Horiuchi's guide is credited on the slide and in the notes.
- The existing deterministic deliverable gate (`check_deliverable.py check --fast`) passes manifest validation, credential-pattern scanning, and prose-tell checks: **3 PASS, 0 WARN, 0 FAIL**. It does not perform a source-support audit of prose citations; those were checked as described above.
- `git diff --check` passed in the Overleaf submodule and parent repository.

## Delivery and remaining work

Push the rebuilt source and source-image asset to Overleaf `main`. Keep parent-repository notes, manifest, wiki, and submodule reference committed locally. The user clarified Overleaf delivery; the website PDF and remote GitHub branch are not updated in this step.

The local compiled PDF is `overleaf/main.pdf` (ignored by git). In Overleaf, select `main.tex` with XeLaTeX to see the full deck. If `design-preview.tex` remains selected, the project will still show only the five-page preview.

Remaining delivery preparation: timed rehearsal, actual Zoom screen-share test, and author revisions if needed. No claim is made that the talk has been rehearsed or independently audited in full.
