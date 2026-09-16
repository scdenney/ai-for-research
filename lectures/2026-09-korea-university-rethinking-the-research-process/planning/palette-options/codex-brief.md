# Codex palette proposal, 2026-09-16

Two complete Beamer systems for the Korea University talk. Full preambles in the two .tex files here; each is a compilable document with one example frame. Codex could not compile them in its read-only workspace, so both need a test build on Overleaf.

---

Use **XeLaTeX** for both alternatives. Each code block is a complete `.tex` document, including its example frame.

Both use Beamer’s `default` theme for direct control of typography, spacing, and color. All fonts are shipped on Overleaf, so no uploads or substitutions are required. Korean and hanja use the KR-specific Noto CJK families through `xeCJK`, with automatic inline switching, preserved Korean spaces, and no baseline offsets. [Overleaf font inventory](https://www.overleaf.com/learn/latex/Questions/Which_OTF_or_TTF_fonts_are_supported_via_fontspec%3F), [Korean typesetting](https://www.overleaf.com/learn/latex/Korean).

The requested inverted-slide accent becomes a **light divider background**. Box headers use structure-colored lettering on the page background above a tinted body.

Contrast ratios below are calculated from the exact sRGB values. WCAG AA requires **4.5:1 for ordinary text** and **3:1 for large text**, while AAA requires **7:1 for ordinary text**. Every proposed pairing exceeds 4.5:1, without relying on the large-text exception. These are source-color measurements, not measurements of Zoom output. [WCAG thresholds](https://www.w3.org/WAI/WCAG22/Techniques/general/G18).

I verified font availability and calculated contrast, but could not run a PDF compilation in this read-only workspace.

**Alternative 1: Chalk & Mulberry.** Cool, contemporary, and restrained. Noto Sans carries the entire presentation, with bold headings and upright Korean. Mulberry provides structure, while eucalyptus supplies the single emphasis color.

| Role | Color | Hex |
|---|---|---|
| Page | Chalk | `#F7F7FA` |
| Ink | Carbon | `#24212B` |
| Muted text | Smoke | `#5F5B66` |
| Structure | Mulberry | `#6B465F` |
| Emphasis | Eucalyptus | `#4D6256` |
| Pass | Pine | `#366746` |
| Partial | Bronze | `#79591E` |
| Fail | Cranberry | `#983D4D` |
| Box fill | Porcelain | `#EBEAF0` |
| Inverted-slide accent | Lilac stone | `#DED7E2` |

Every text color was checked against all three available backgrounds. Values are ratios to 1.

| Text color | Page | Box fill | Divider |
|---|---:|---:|---:|
| Ink | 14.80 | 13.23 | 11.24 |
| Muted text | 6.19 | 5.53 | 4.70 |
| Structure | 7.37 | 6.59 | 5.60 |
| Emphasis | 6.14 | 5.49 | 4.67 |
| Pass | 6.17 | 5.51 | 4.69 |
| Partial | 6.02 | 5.39 | 4.58 |
| Fail | 6.32 | 5.65 | 4.80 |

The type hierarchy is 14 pt body, 22 pt frame titles, 28 pt statements, 12 pt tables, and 11 pt code. Those sizes refer to Beamer’s native 160 × 90 mm canvas. Rules are at least 0.9 pt, and verdicts combine a symbol, a word, and color.

[Beamer preamble: see the .tex file beside this note]


**Alternative 2: Limestone & Graphite.** A reading-room mood, with a neutral mineral palette and Noto Serif for the main narrative. Tables, code, and diagram labels remain sans serif or monospace. The single emphasis color is a subdued slate blue, while all structural elements are graphite.

| Role | Color | Hex |
|---|---|---|
| Page | Limestone | `#F6F5F1` |
| Ink | Charcoal | `#292824` |
| Muted text | Flint | `#605D56` |
| Structure | Graphite | `#57544F` |
| Emphasis | Slate | `#465F79` |
| Pass | Juniper | `#3B654B` |
| Partial | Brass | `#795A21` |
| Fail | Iron oxide | `#913F38` |
| Box fill | Plaster | `#EAE7DF` |
| Inverted-slide accent | Pale stone | `#DEDACF` |

Again, every text color was checked against every available background.

| Text color | Page | Box fill | Divider |
|---|---:|---:|---:|
| Ink | 13.52 | 11.94 | 10.56 |
| Muted text | 6.02 | 5.31 | 4.70 |
| Structure | 6.91 | 6.10 | 5.40 |
| Emphasis | 6.07 | 5.36 | 4.74 |
| Pass | 6.11 | 5.40 | 4.77 |
| Partial | 5.84 | 5.15 | 4.56 |
| Fail | 6.48 | 5.72 | 5.06 |

The size hierarchy and rule weights match Alternative 1. The serif narrative and neutral structure provide the distinct mood, while technical material retains the more compact sans-serif treatment.

[Beamer preamble: see the .tex file beside this note]


I would ship **Chalk & Mulberry** for this audience and Zoom delivery. Its consistent sans-serif typography gives English, Korean, tables, and diagrams a steady visual rhythm, with fewer fine strokes exposed to compression. The cool page and mulberry structure also make a clear departure from the previous warm palette while retaining an academic, editorial character.
tokens used
42,867
Use **XeLaTeX** for both alternatives. Each code block is a complete `.tex` document, including its example frame.

Both use Beamer’s `default` theme for direct control of typography, spacing, and color. All fonts are shipped on Overleaf, so no uploads or substitutions are required. Korean and hanja use the KR-specific Noto CJK families through `xeCJK`, with automatic inline switching, preserved Korean spaces, and no baseline offsets. [Overleaf font inventory](https://www.overleaf.com/learn/latex/Questions/Which_OTF_or_TTF_fonts_are_supported_via_fontspec%3F), [Korean typesetting](https://www.overleaf.com/learn/latex/Korean).

The requested inverted-slide accent becomes a **light divider background**. Box headers use structure-colored lettering on the page background above a tinted body.

Contrast ratios below are calculated from the exact sRGB values. WCAG AA requires **4.5:1 for ordinary text** and **3:1 for large text**, while AAA requires **7:1 for ordinary text**. Every proposed pairing exceeds 4.5:1, without relying on the large-text exception. These are source-color measurements, not measurements of Zoom output. [WCAG thresholds](https://www.w3.org/WAI/WCAG22/Techniques/general/G18).

I verified font availability and calculated contrast, but could not run a PDF compilation in this read-only workspace.

**Alternative 1: Chalk & Mulberry.** Cool, contemporary, and restrained. Noto Sans carries the entire presentation, with bold headings and upright Korean. Mulberry provides structure, while eucalyptus supplies the single emphasis color.

| Role | Color | Hex |
|---|---|---|
| Page | Chalk | `#F7F7FA` |
| Ink | Carbon | `#24212B` |
| Muted text | Smoke | `#5F5B66` |
| Structure | Mulberry | `#6B465F` |
| Emphasis | Eucalyptus | `#4D6256` |
| Pass | Pine | `#366746` |
| Partial | Bronze | `#79591E` |
| Fail | Cranberry | `#983D4D` |
| Box fill | Porcelain | `#EBEAF0` |
| Inverted-slide accent | Lilac stone | `#DED7E2` |

Every text color was checked against all three available backgrounds. Values are ratios to 1.

| Text color | Page | Box fill | Divider |
|---|---:|---:|---:|
| Ink | 14.80 | 13.23 | 11.24 |
| Muted text | 6.19 | 5.53 | 4.70 |
| Structure | 7.37 | 6.59 | 5.60 |
| Emphasis | 6.14 | 5.49 | 4.67 |
| Pass | 6.17 | 5.51 | 4.69 |
| Partial | 6.02 | 5.39 | 4.58 |
| Fail | 6.32 | 5.65 | 4.80 |

The type hierarchy is 14 pt body, 22 pt frame titles, 28 pt statements, 12 pt tables, and 11 pt code. Those sizes refer to Beamer’s native 160 × 90 mm canvas. Rules are at least 0.9 pt, and verdicts combine a symbol, a word, and color.

[Beamer preamble: see the .tex file beside this note]


**Alternative 2: Limestone & Graphite.** A reading-room mood, with a neutral mineral palette and Noto Serif for the main narrative. Tables, code, and diagram labels remain sans serif or monospace. The single emphasis color is a subdued slate blue, while all structural elements are graphite.

| Role | Color | Hex |
|---|---|---|
| Page | Limestone | `#F6F5F1` |
| Ink | Charcoal | `#292824` |
| Muted text | Flint | `#605D56` |
| Structure | Graphite | `#57544F` |
| Emphasis | Slate | `#465F79` |
| Pass | Juniper | `#3B654B` |
| Partial | Brass | `#795A21` |
| Fail | Iron oxide | `#913F38` |
| Box fill | Plaster | `#EAE7DF` |
| Inverted-slide accent | Pale stone | `#DEDACF` |

Again, every text color was checked against every available background.

| Text color | Page | Box fill | Divider |
|---|---:|---:|---:|
| Ink | 13.52 | 11.94 | 10.56 |
| Muted text | 6.02 | 5.31 | 4.70 |
| Structure | 6.91 | 6.10 | 5.40 |
| Emphasis | 6.07 | 5.36 | 4.74 |
| Pass | 6.11 | 5.40 | 4.77 |
| Partial | 5.84 | 5.15 | 4.56 |
| Fail | 6.48 | 5.72 | 5.06 |

The size hierarchy and rule weights match Alternative 1. The serif narrative and neutral structure provide the distinct mood, while technical material retains the more compact sans-serif treatment.

[Beamer preamble: see the .tex file beside this note]


I would ship **Chalk & Mulberry** for this audience and Zoom delivery. Its consistent sans-serif typography gives English, Korean, tables, and diagrams a steady visual rhythm, with fewer fine strokes exposed to compression. The cool page and mulberry structure also make a clear departure from the previous warm palette while retaining an academic, editorial character.
