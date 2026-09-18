# Run the demo

The exact commands, in order. Everything runs on local files. Nothing here needs the web.

## 0. Before you start

Claude Code with the Open Science Skills plugin installed
([Getting started](https://scdenney.github.io/ai-for-research/getting-started/)),
Java 11 or newer for the PDF backend, and `poppler-utils` for `pdfinfo` and `pdftotext`.
Python and the converter get set up by the skill in step 1.

Work in a fresh folder, not in this repository:

```bash
mkdir -p ~/kb-demo && cd ~/kb-demo
claude
```

## 1. Scaffold the spine

```
/oss:research-repo .
```

The skill puts the directory under version control if it is not already, writes
`sources/og/`, `sources/md/`, `sources/unprocessed/`, `references.bib`, the conversion
script, a `.gitignore` that keeps originals out of git, a `CLAUDE.md`, and a project-local
`/process-source` command. It then sets up the Python environment and smoke-tests the
converter, which on an empty library prints `Nothing new to convert.`

Compare what you get with `expected-output/01-scaffold.txt`.

## 2. Drop the files in

```bash
cp /path/to/ai-for-research/demos/knowledge-base/inbox/* sources/unprocessed/
ls sources/unprocessed/
```

Four files. Two of the names tell you nothing, one is not a PDF, and one is a photograph
of a page.

## 3. Intake, one file at a time

```
/process-source
```

For each file this reads enough to identify it, renames it `author-year-slug`, moves it
to `sources/og/`, converts it, and adds the bibliography entry. Watch what it decides.
The renaming is the step that makes a citation key resolvable later, so check that the
author and year it picked match the document.

Expected names:

```
ferreira-nair-2021-compulsory-voting.pdf
lindqvist-2019-civic-education-turnout.pdf
osei-2020-social-trust.docx
kowalski-2017-turnout-cascades.pdf
```

## 4. Convert and look at what came out

```bash
./scripts/convert-sources.sh
ls sources/md/
```

Three conversions, and one refusal:

```
  NEEDS OCR (image-only): kowalski-2017-turnout-cascades.pdf
Converted 3 file(s), 1 need OCR. Markdown in .../sources/md/
```

The scan has no text layer. Without the guard the converter would write a few kilobytes
of noise and report success, which reads downstream as a source that has been filed and
read. Route that one to OCR instead:

```
/oss:vlm-ocr sources/og/kowalski-2017-turnout-cascades.pdf
```

Now open a conversion and check it against the original. Start with the results table in
Ferreira and Nair, which does not survive the trip:
`expected-output/04-inspect-the-conversion.md` shows what to look for.

## 5. Check that the bibliography and the library agree

```bash
grep -oE '^@[a-zA-Z]+\{[^,]+' sources/references.bib | sed 's/^@[a-zA-Z]*{//' | sort
ls sources/md/
```

Every key should be resolvable to a file by author and year. Anything you cited but could
not obtain goes in `sources/missing.bib` with a note on why, so it stays visible.

## 6. Audit a project that grew without a convention

```
/oss:research-repo /path/to/ai-for-research/demos/knowledge-base/messy-project
```

Two originals that were never converted, one conversion with no bibliography entry, one
entry with no source anywhere, and filenames that resolve to nobody. The report should
name all four. Compare with `expected-output/03-audit.md`.

## 7. Use what you built

The knowledge base is the input to the next demo. With one in place, the source-claim
check has something to read:

```
/oss:fact-check manuscript.md
```

Without one it refuses to run rather than guess, which is the behaviour you want. See
[reference-check](../../reference-check/).

## Try breaking it

- **Delete a conversion** from `sources/md/` and run the claim check. It should refuse on
  its pre-flight rather than answer from memory.
- **Rename a file** so its author and year no longer match its bibliography key, then
  re-run the audit. Watch the drift get reported.
- **Add a source and skip the bibliography entry.** The audit reports files with no entry
  as well as entries with no file. Drift runs in both directions.
- **Re-run the converter twice.** It only touches files without a conversion, so a second
  run is safe and says so.
- **Put the scan through OCR**, then re-run the audit and watch the orphan disappear.
