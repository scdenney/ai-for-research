# Narrative and skills revision — validation, 16 September 2026

## Result

37 physical pages: 31 main pages (including cover and three dividers), then six appendices. Ordinary footer numbers run continuously 1–33. Speaker notes contain 31 timed sections, continuously 00:00–55:00: opening 7 minutes, Part 1 15, Part 2 23, Part 3 7, closing 3.

The opening claim now supplies a concrete task for the agent definitions and returns in Part 3. The three modes have explicit decision rules and examples using the same paper. Part 2 teaches writing and using skills from actual research-repo instructions, then inspects audit evidence, a PDF conversion, citation identity, and claim support. Karpathy's original LLM Wiki is credited alongside Kenny; the four delegation patterns are credited to Kenny's adaptation of Swaney. Replication-package is an appendix option.

## Build and visual inspection

- XeLaTeX via `latexmk -xelatex -interaction=nonstopmode -halt-on-error main.tex`: passes; no overfull/underfull boxes or LaTeX warnings in final log.
- All 37 pages rendered; final contact sheets inspected. Dense and changed pages also inspected at full size. Compressed 1280×720 JPEGs of pages 18, 22, 24, and 29 inspected for readability; additional compression samples retained.
- Text bounds: no text outside page. No Korean text. Embedded EB Garamond, Noto Sans Mono and CMSY; no Type 3 fonts.
- Diagrams use aligned node/arrow coordinates; the context and collaboration boxes have consistent dimensions. Routine green takeaway lines removed; four remain where they qualify evidence or connect the argument.
- Final local PDF SHA256: `0ae047b305955893ca04f0619aa9c8bc5fbe00813d5bf5e4d050c943bc0e9d9c`.
- Contact sheets, compressed samples, numbering/bounds/link results: `review-narrative-2026-09-16/`.

## Evidence and scope

Sol workers revised the opening and skills teaching; a Terra worker executed read-only audits and independently reviewed factual scope. Lead checked sources, corrected findings and inspected rendered output.

Actual audit receipts are in `receipts-2026-09-16/`. The source inventory has 102 originals, 119 Markdown files, and zero originals lacking a matching Markdown stem. These counts establish presence, not conversion fidelity or complete bibliography parity. The canonical bibliography has 126 entries; the inventory's totals are stale. Reference project and manuscript working-tree status remained unchanged during the audit.

The citation check covers only the two historical cite keys. Crossref metadata retrieved through DOI content negotiation matches both works; no direct publisher-page inspection or full-reference-list audit is claimed. The source-support check uses both full texts. The comparative penalty claim is UNSUPPORTED: Reeves/Rogowski do not supply the direct route comparison, and Christenson/Kriner report nonsignificant route effects. Nonsignificance does not establish equivalence or no effect. The new check is separate from the historical August 27 revision, whose exact diff is retained.

Autor's junior result is no detectable average unaided gain with increased dispersion, not average decline. Bastani's tutor mitigated harm in that setting, without establishing a learning gain; Bassner qualifies generalization in notes and appendix. Source support is explicitly separated from measurement, identification and broader research validity.

## Browser and delivery

The installed Chrome Playwright extension was actually used for the GitHub skill capture and refreshed Hub screenshot. Provenance is recorded beside the figures; credentials remain outside the repository. The original-source image is a crop of the actual PDF.

Overleaf browser inspection remains blocked by the connected Chrome profile showing an unauthenticated Restricted page. Git access works. Local rendering is verified; the Overleaf-compiled PDF has NOT been inspected. A timed rehearsal and real Zoom screen-share check also remain outstanding.

Delivery target: existing Overleaf project, main.tex, XeLaTeX. Parent GitHub branch and website PDF are not pushed or replaced. Original design-preview.tex and the pre-existing untracked brief are preserved.

## Delivery record

Overleaf main pushed and remote hash verified: `42ff7ff2e321c1947e22f911577717f1f203a403`, based on author revision `a304738`. Parent changes committed locally only.
