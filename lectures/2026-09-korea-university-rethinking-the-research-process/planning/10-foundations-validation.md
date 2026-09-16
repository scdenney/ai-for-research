# Foundations and evidence revision — validation, 16 September 2026

## Delivered scope

32 main slides including the cover, three section dividers, five appendix slides: 40 PDF pages. The unnumbered cover and dividers leave ordinary slide numbers 1–36. Matching notes have 32 timed sections and a continuous 55:00 budget: 3 opening + 10 foundations + 15 modes/evidence + 17 infrastructure + 7 historical demonstration + 3 closing. This is a planned duration; an actual timed rehearsal and Zoom screen-share check remain the author's next steps.

## Build and review

- XeLaTeX via latexmk; full main.tex compiled. All 40 pages rendered before evaluating layout.
- All pages visually inspected in five contact sheets; individual checks of foundation diagrams, both plots, screenshots, source chain, replication handoff, historical evidence, and appendices. An independent agent reviewed all 40 pages and checked dense pages at full size.
- Corrected heading/body collisions, screenshot/text overlap, a context arrow touching text, and an overlong comparison row. Final Bassner wording describes the comparison with control, not absence of learning.
- Six dense pages also inspected as 1280×720 JPEGs at quality 55: skill excerpt, Autor, Bastani, scaffold, historical revision, and evidence table. This is a compression simulation, not a completed Zoom call.
- Text remains within page bounds. Ordinary numbering is continuous; no repeated talk-title header or Korean text. No LaTeX overflow, underflow, missing-character or compilation warnings in the final log. All font resources are embedded. A Matplotlib OpenType metadata mismatch was resolved by exporting plots through its supported PGF/XeLaTeX backend; pdffonts now reports no warnings and searchable signed values are preserved.
- Deliverable gate: manifest, credentials, and prose checks all pass. Git whitespace check passes.

## Evidence and authentic artifacts

Autor Tables 4/6 column 4 and Bastani Table 1 were checked directly. Plots preserve units and use explicitly approximate normal 95% intervals from published rounded clustered SE. Inputs, calculated intervals, source locators and hashes accompany the reproducible plotting script. No average decline is attributed to Autor's juniors. The two task panels are not before/after trajectories. Bastani's tutor is not presented as establishing a learning gain.

The historical claim, source quote, project instruction, and revised wording were checked again against the NWO source Markdown, project instructions, and manuscript git objects at 75366c6 and its parent. No NWO files were edited. No fresh full-project audit or fabricated skill receipt is represented.

Actual public OSS and Hub pages were opened and captured through Microsoft's installed Chrome Playwright extension with MCP in extension mode. The browser crops were inspected individually and within the rendered deck. Their URLs, OSS revision, and date are recorded in overleaf/figures/browser-capture-provenance.md. Supporting repository/catalog captures are in planning/browser-captures/. Credentials are outside the lecture repository.

The appendix and notes qualify guardrails with Bassner, distinguish task-specific familiarity from general seniority, and distinguish Melumad–Yun reported learning from retention. Relayed literature leads in 09-evidence-protect.md are not represented as a new systematic review. Excluded/retracted items remain off the deck.

## Preserved and delivery boundaries

The original standalone design-preview.tex, prior review artifacts, existing untracked codex brief, reference projects, and website PDF are preserved. Only the Overleaf remote receives this deck. Parent-repository changes are committed locally without a GitHub push. Main entry point remains main.tex with XeLaTeX.

## Lessons for the later presentation skill

1. Establish the audience's objective and minimum working vocabulary before the conceptual framework.
2. Distinguish a captured artifact, a schematic, an illustrative prompt, and an actual execution receipt.
3. Remove repeated headers and routine footer prose; retain citations where they earn the space.
4. Build visual comparisons around the measured outcome, units, timing, and uncertainty.
5. Draw connectors from object anchors and inspect the rendered result, not only coordinates.
6. Crop screenshots to the passage being discussed; pair them with readable native explanation.
7. Render every page, inspect dense pages at delivery resolution, and reconcile notes/page numbers after restructuring.

These are recorded lessons. No new presentation skill was created in this task.

## Retained review artifacts

Final contact sheets, six compression samples, and PDF hash/check record are retained in `planning/review-2026-09-16/`. Full-size individual page renders are in `/tmp/korea-full-qa/`; the compiled full deck is `overleaf/main.pdf` (gitignored).

## Delivery record

Overleaf main pushed successfully: `cc5198c` → `180d608`, 16 September 2026. Parent commit is local only.
