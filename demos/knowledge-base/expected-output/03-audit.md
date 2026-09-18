# Audit report — `messy-project/` (illustrative)

What an audit of `messy-project/` should report. Treat this as an answer key for the
shape of the finding, not a transcript to match word for word.

**Mode:** audit · **Archetype:** empirical analysis, half built

## Spine

| Item | State |
|---|---|
| `sources/og/`, `sources/md/`, `sources/unprocessed/` | **partial** — no `unprocessed/` drop zone |
| `og/` gitignored, `md/` tracked | **missing** — no `.gitignore`, so the originals would be pushed |
| Every original has a conversion | **partial** — two originals, no conversion for either |
| Every conversion has a bib entry, every entry a source | **partial** — drift in both directions |
| Filenames follow `author-year-slug` | **missing** — neither original does |
| `sources/references.bib` exists | **partial** — the bibliography is at the repo root, not under `sources/` |
| `sources/README.md` documents the convention | **missing** |

## Pipeline

| Item | State |
|---|---|
| `scripts/convert-sources.sh` | **missing** |
| `.venv/` with `opendataloader-pdf` | **missing** |
| A `process-source` command | **missing** |

## Findings

**Orphan originals — filed but never converted.** Nothing downstream can read these.

```
ferreira nair FINAL (2)
Paper1
```

*Fix: rename to `author-year-slug`, run the conversion, commit the Markdown.*

**Bibliography drift, both directions.**

| Key or file | Problem |
|---|---|
| `ferreira-nair2021` | Entry exists, original exists, no conversion. The key resolves to nothing readable. |
| `osei2020` | Entry exists. No original and no conversion anywhere in the project. |
| `lindqvist-2019-civic-education-turnout.md` | Conversion exists with no entry in the bibliography. Read, but not citable. |

*Fix: convert the two originals, add the missing entry, and either acquire the Osei
source or move its entry to `missing.bib` with a note on why it is not filed.*

**Naming.** `Paper1.pdf` and `ferreira nair FINAL (2).pdf` carry no resolvable identity.
A key cannot be matched to a file by author and year if the file has neither.

## Next three actions

1. Scaffold the missing pipeline: `scripts/convert-sources.sh`, `.venv/`, `.gitignore`.
2. Rename and convert the two originals; commit `sources/md/`.
3. Reconcile the bibliography, and record anything unobtainable in `sources/missing.bib`.
