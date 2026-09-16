# Five-page design review

Open [design-preview.pdf](design-preview.pdf). Individual 1280 × 720 renders are `page-1.png` through `page-5.png`. Source: `../../overleaf/design-preview.tex`. This is the approved review checkpoint, not the rebuilt full lecture.

## Rebuild

From the lecture's `overleaf/` directory, with XeLaTeX, EB Garamond and Noto Sans Mono installed:

```sh
mkdir -p /tmp/korea-preview-build
xelatex -interaction=nonstopmode -halt-on-error -output-directory=/tmp/korea-preview-build design-preview.tex
xelatex -interaction=nonstopmode -halt-on-error -output-directory=/tmp/korea-preview-build design-preview.tex
pdftoppm -scale-to-x 1280 -scale-to-y 720 -png /tmp/korea-preview-build/design-preview.pdf /tmp/korea-preview-build/page
```

Copy the PDF and five page PNGs here after inspecting them. Auxiliary files stay outside the repository. Compile this independent file in Overleaf by selecting `design-preview.tex` as the main document; leave the lecture's existing main document setting in place unless intentionally previewing it.

## Validation, 16 September 2026

- Five pages compiled successfully with XeLaTeX, twice; no overfull/underfull boxes, missing glyphs, or compilation warnings in the final log.
- Every rendered page inspected at 1280 × 720. Earlier overlaps in the mode comparison and source diagram were corrected; all titles fit one line and content stays within the margins.
- Every page also inspected after downsampling to 960 × 540, JPEG quality 45 with chroma subsampling, and resizing to 1280 × 720. Main argument, excerpts, and diagrams remain readable. Small provenance/arrow labels soften. This is a compression stress simulation, not a live Zoom test; rehearsal on the actual connection remains necessary.
- `pdffonts` confirms both EB Garamond Regular and Noto Sans Mono are embedded, subsetted, with Unicode mappings.
- No Korean text in the new preview. The unchanged old deck still contains its previous content until the full rebuild.
- Source quote checked verbatim against the converted source abstract. Both manuscript excerpts checked against the historical diff `75366c6`. The demonstration is explicitly labelled a historical reconstruction, not a new skill execution or a fabricated receipt.
- Main source, preamble, parts, existing speaker notes, and published website PDF are unchanged by this checkpoint.

Measured sRGB contrast (text colors on both backgrounds):

| Text | Page | Fill |
|---|---|---|
| Ink | 15.28:1 | 13.44:1 |
| Muted | 6.66:1 | 5.86:1 |
| Structure | 8.75:1 | 7.70:1 |
| Accent | 7.13:1 | 6.27:1 |

Full teaching sequence and evidence locators: [storyboard](../02-rebuild-storyboard.md).
