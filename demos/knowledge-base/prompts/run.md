# Run the demo

The exact commands, in order. The sources are local files; setup, the Word converter and the
push need a network connection.

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
script, a `.gitignore` that keeps originals local while their Markdown conversions stay
tracked in git, a `CLAUDE.md`, and a project-local
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

## 4. Confirm the conversion and look at what came out

```bash
ls sources/md/
```

Three conversions are already there. `/process-source` converted each file as it filed
it, so there is nothing left to convert, only to check.

Re-run the converter and see that for yourself:

```bash
./scripts/convert-sources.sh
```

```
  NEEDS OCR (image-only): kowalski-2017-turnout-cascades.pdf
Converted 0 file(s), 1 need OCR. Markdown in $PROJECT/sources/md/
```

Nothing new, and the scan still gets flagged. That is how you know the script is safe to
re-run: it only touches files without a conversion. The scan itself has no text layer.
Without the guard the converter would write a few kilobytes of noise and report success,
which reads downstream as a source that has been filed and read. Route that one to OCR
when you are ready:

```
/oss:vlm-ocr sources/og/kowalski-2017-turnout-cascades.pdf
```

OCR is not part of the main walkthrough. The saved end state in
`expected-output/finished-base/` is captured before this step: the scan still sits in
`sources/og/` waiting for it. Do it now, later, or not at all.

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

## 7. Close the session, then resume it

```
/oss:finished
```

It writes what changed into the project's handoff and log, sorting each item into
verified, unverified, half-finished, or decided and not yet built. If the project has
neither file it asks once before creating one. It does not commit.

Record the run in git, and push it to a private GitHub repository the first time:

```bash
git add -A
git status --short   # no line should start with sources/og/
git commit -m "File three sources; flag the scan and the damaged table"
gh repo create kb-demo --private --source=. --push
```

Quit Claude Code, start a new session in the same folder, and ask where things stand:

```
/oss:sitrep
```

It should report the scan as open, the damaged table as a known problem, and a clean
tree. Edit any file without committing and run it again: the uncommitted change should
appear as a gap between the handoff and the repository.

## 8. Use what you built

The knowledge base is the input to the next demo. The claim check needs two things: a
manuscript to check, and a knowledge base to check it against. This demo builds the
knowledge base and ships no manuscript, so there is nothing here to run
`/oss:fact-check` against.

[reference-check](../../reference-check/) supplies a manuscript with planted problems,
along with a knowledge base of its own. That is where to go next.

Here is why a base you can read matters. An archived draft of the author's manuscript
contained the sentence "Studies of unilateral policymaking similarly show that citizens
penalize executive action relative to legislative action," cited to Reeves and Rogowski
(2016) and Christenson and Kriner (2017). Neither source backs it as written. Reeves and
Rogowski report low generalized support for unilateral power, not a comparison between
routes. Christenson and Kriner's route estimate is not significant. The author had already
rewritten the sentence by hand on 27 August 2026, as two narrower claims each tied to the
source that supports it. A claim check run on 16 September 2026 against the archived
wording reached the same verdict. The check shows what reading the sources finds; the
researcher decided what to write.

## Try breaking it

- **In the reference-check demo, delete a conversion** from `sources/md/` and run the
  claim check. It should refuse on its pre-flight rather than answer from memory.
- **Rename a file** so its author and year no longer match its bibliography key, then
  re-run the audit. Watch the drift get reported.
- **Add a source and skip the bibliography entry.** The audit reports files with no entry
  as well as entries with no file. Drift runs in both directions.
- **Re-run the converter twice.** It only touches files without a conversion, so a second
  run is safe and says so.
- **OCR the scan**, save the text as `sources/md/kowalski-2017-turnout-cascades.md`, then
  run `/oss:research-repo .` and check that the scan is no longer listed as unconverted.
