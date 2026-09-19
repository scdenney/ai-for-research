# Answer key — what each step should produce

Everything in this demo is planted. The four inbox files each carry one problem that the
intake pipeline has to solve, and `messy-project/` carries four more that only an audit
finds. The sources themselves are invented, including the authors, journals, and the
countries they study.

## The inbox

| File | Planted problem | What should happen |
|---|---|---|
| `Download (3).pdf` | A browser filename with no identity in it | Read enough to identify it, rename to `ferreira-nair-2021-compulsory-voting.pdf` |
| `1-s2.0-S0261379421000342.pdf` | A publisher filename, equally unresolvable | Rename to `lindqvist-2019-civic-education-turnout.pdf` |
| `osei_socialtrust_FINAL_v2.docx` | Not a PDF, so it takes the other branch of the converter | Converts through `anydoc` or `pandoc`, lands as `osei-2020-social-trust.md` |
| `scan-0417.pdf` | A photographed page with no text layer | Reported `NEEDS OCR (image-only)`, **not** converted, routed to `vlm-ocr` |

The scan is the one that matters most. Without the image-only guard the converter exits
zero and writes a few kilobytes of noise, and that file then reads downstream as a source
that has been acquired, converted, and filed. A silent success is worse than a refusal.

## The conversions

| What to check | What you will find |
|---|---|
| The results table in Ferreira and Nair | **Flattened.** The header row is absorbed into the section heading and both data rows run together on one line. The numbers survive, the structure does not. |
| The quotable passages | Intact and greppable in all three files |
| The `.docx` conversion | Author and journal lines promoted to top-level headings |

None of these stops the pipeline, and none of them appears in the run log. They are only
visible if you open the file. That is the lesson of step 4.

## The work with no source held

| What to check | What you will find |
|---|---|
| `sources/missing.bib` and `sources/md/marchetti-2016-reluctant-voter.NOTE.md` | The same cited book, Marchetti (2016), recorded twice: a bib entry that says it is missing, and a `.NOTE.md` that says what is believed about it and warns that neither may stand in as evidence for a claim. |

Notice what the `.NOTE.md` does that the bib entry cannot. It carries the claim the
manuscript attaches to the book, but its opening lines forbid using that content to verify
the claim, so a fact-check has to record it as unverifiable rather than read the note and
move on.

## `messy-project/`

| # | Planted problem | Expected finding |
|---|---|---|
| 1 | `sources/og/Paper1.pdf` and `ferreira nair FINAL (2).pdf` were never converted | Orphan originals: filed but unreadable |
| 2 | Same two files violate `author-year-slug` | Naming violations, so no key can resolve to them |
| 3 | `sources/md/lindqvist-2019-civic-education-turnout.md` has no bibliography entry | Drift: read but not citable |
| 4 | `references.bib` has `osei2020`, which exists nowhere in the project | Drift the other way: cited but unfiled |
| 5 | No `unprocessed/`, no `.gitignore`, no convert script, no `sources/README.md` | Pipeline and conventions missing, so the next source will be filed however whoever files it feels like |

Note that #3 and #4 are the same failure seen from opposite ends, and an audit that only
checks one direction misses half of it.

## What a human still has to decide

- **Whether the rename is right.** The pipeline reads the document to pick an author and
  year. On a working paper with three versions and a changed title, that judgment is
  yours, and everything downstream inherits it.
- **Whether a flattened table matters here.** If your claim rests on which interval
  belongs to which outcome, go back to the PDF. If it rests on a sentence, the conversion
  is fine. No tool can make that call for you.
- **What to do about the scan.** OCR it, summarize it by hand, or record it in
  `missing.bib` and move on. All three are defensible. Leaving it in `og/` and forgetting
  it is not.
- **Whether the library is complete enough.** A knowledge base with two thirds of your
  citations in it supports a different claim than one with all of them. The claim check
  will tell you it is not ready. It cannot tell you which missing source would have
  changed your argument.
