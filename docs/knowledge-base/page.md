<!--
Prose source for index.html. Edit here; the HTML is mirrored from this file by hand.
Section ids match the <section id="..."> anchors in the page.
-->

# Build a Knowledge Base

**Lede:** Turn a folder of downloads into a source library an agent can read, and that
every later check can be run against.

**Kicker:** Demos · Knowledge base

---

## Motivation {#motivation}

Ask an agent whether a source supports the claim you have attached to it and it needs the
source. Not the citation, not your memory of the paper, the text. Most projects cannot
supply that. The papers are in a downloads folder under names like `Download (3).pdf`, the
bibliography was assembled at the end from whatever the reference manager had, and the
reading happened in a conversation that has since been closed.

Two things go wrong from there. The first is that the work does not persist. Each session
starts from nothing and you re-explain the project, or worse, you do not and the agent
proceeds on a version of it that it invented. The second is that there is nothing to
check against. A claim check that cannot open the source has only two options, and both of
them are guessing.

A knowledge base fixes both. The originals are preserved and identified, the readable
conversions sit in version control where an agent and a colleague can both reach them, and
the citation keys resolve to files that were actually read. The source library becomes the
spine of the project, and the checks that matter grow from it.

*Diagram 1: raw material to persistent base to project memory.*

---

## What a knowledge base is {#what}

Four folders and one contract.

- **`sources/og/`** — the originals, exactly as acquired. Gitignored, for size and for
  copyright. You rarely read these directly, and they are the authority when a conversion
  is in doubt.
- **`sources/md/`** — the Markdown conversions. Tracked in git. This is the part an agent
  reads and the part a grep searches.
- **`sources/unprocessed/`** — the drop zone. New files land here and stay here until they
  have been identified, named, converted, and registered.
- **`sources/references.bib`** — one entry per source, added at intake rather than in a
  batch at the end. The key has to be resolvable to its file by author and year, because
  that is how the checkers map a citation to a document.

**The rule.** Read from `md/`, never from the PDF. Cite from `references.bib`. A key that
does not resolve to a filed source is a citation nobody can check, including you.

*Diagram 2: the spine, with the tracked and ignored split and the key-to-file contract.*

---

## Set up {#setup}

Install Claude Code and the skills first (see Getting started). Then, in the folder where
the project will live:

```
/oss:research-repo .
```

The skill puts the folder under version control, writes the four parts above, adds a
conversion script and a project-local `/process-source` command, and sets up the Python
environment the converter needs. On an empty library the smoke test prints
`Nothing new to convert.`

Converting PDFs needs Java 11 or newer for the extraction backend, and `poppler-utils` for
the check that spots a scan. If a project already exists, the same command audits it
instead of scaffolding over it, which is the section below.

---

## Add the first source {#intake}

Intake is four decisions and one command.

**Drop.** The file goes into `sources/unprocessed/` under whatever name it arrived with.

**Identify.** Read enough of it to establish author, year, title, and venue. This is the
step that cannot be skipped and cannot be automated away, because everything downstream
inherits it.

**Rename.** `author-year-slug`, lowercase, hyphens, up to three authors and then
`firstauthor-etal`. `Download (3).pdf` becomes
`ferreira-nair-2021-compulsory-voting.pdf`. The name is not housekeeping. It is what makes
a citation key resolvable to a document later.

**Convert and register.** Run the conversion, then add the bibliography entry.

```
./scripts/convert-sources.sh
```

```
Converting ferreira-nair-2021-compulsory-voting.pdf...
  NEEDS OCR (image-only): kowalski-2017-turnout-cascades.pdf
Converting lindqvist-2019-civic-education-turnout.pdf...
Converting osei-2020-social-trust.docx...
Converted 3 file(s), 1 need OCR. Markdown in sources/md/
```

The script only touches files that have no conversion yet, so re-running it is safe.

*Diagram 3: the intake pipeline and what each step leaves on disk.*

---

## What goes wrong {#failures}

Four of the five failures below are in the demo on purpose. The fifth, the flattened
table, is what the converter actually did.

| Symptom | What it means | What to do |
|---|---|---|
| `NEEDS OCR (image-only)` | The PDF is a photograph of a page. There is no text to extract. | Send it to `vlm-ocr`, or summarize it by hand. Do not leave it sitting in `og/`. |
| A table that reads as one run-on line | The extractor kept the numbers and lost the structure | Go back to the original for anything where the layout carried the meaning |
| Headings where the author line should be | The `.docx` branch guessed at document structure | Fix the file, or just know it is there when you read it |
| A conversion with no bibliography entry | Read but not citable | Add the entry |
| An entry with no source anywhere | Cited but unfiled | Acquire it, or move it to `missing.bib` with a note on why you could not |

The first one is the one to take seriously. Without the guard that catches it, the
converter exits successfully and writes a few kilobytes of noise, and that file then looks
exactly like a source that has been acquired, converted, filed, and read. A refusal is
better than a silent success.

And a conversion that succeeded is still not a conversion that is correct. Nothing in the
run log tells you the table collapsed. You find that by opening the file.

---

## Audit the project you already have {#audit}

Most researchers do not start clean. Point the same skill at an existing folder and it
reports what is present, what is partial, and what is missing.

```
/oss:research-repo path/to/project
```

On the half-built project this demo ships, it should find two originals that were never
converted, filenames that resolve to nobody, one conversion with no bibliography entry,
and one entry with no source anywhere in the project.

Those last two are the same failure from opposite ends, and it is worth checking both
directions. A library drifts away from its bibliography as easily as a bibliography drifts
away from its library.

---

## What this unlocks {#unlocks}

The knowledge base is the first of four links, and it is the one the others stand on.

| Link | Skill | The question it answers |
|---|---|---|
| Knowledge base | `research-repo` | Is the evidence preserved and linked? |
| Sources | `citation-check`, `fact-check` | Do identities resolve and claims match? |
| Manuscript | `paper-review-lite` | Does the paper agree with its own evidence? |
| Research artifact | `replication-package`, `/oss:verify` | Does the package run as specified? |

Each is bounded, and the bounds are worth stating plainly. `fact-check` refuses to start
until roughly two thirds of the cited works are converted, which is the right behaviour
and also a reminder that a thin library produces a thin check. `citation-check` needs
Crossref and OpenAlex to confirm that a work exists, and reports `NOT CHECKED` rather than
guessing when it cannot reach them. `paper-review-lite` reads what it is given, so it can
catch an abstract reporting one number against a table reporting another, and it cannot
catch both of them agreeing on a number the analysis no longer produces. `/oss:verify`
checks that a replication package has the structure it claims and, with explicit
permission, that its master script runs. It compares exit status and filenames. It does
not compare values.

Together these improve **verifiability**: another person can inspect the inputs, the
transformations, and the evidence, and check what was done. They do not establish
**validity**. Whether the question, the design, the measurement, and the interpretation
warrant the conclusion is still yours to argue.

---

## Check it yourself {#by-hand}

- Delete a conversion and run the claim check. It should refuse on its pre-flight rather
  than answer from memory.
- Rename a file so its author and year stop matching its key, then re-run the audit.
- Add a source and skip the bibliography entry. Drift gets reported in both directions.
- Open a conversion beside its original and compare the tables, not the prose.
- Put the scan through OCR, then audit again and watch the orphan disappear.

---

## Next card {#next}

**Reference and source-claim checking** — with a knowledge base in place, check whether
each cited work exists and whether each source actually supports the claim attached to it.
Links to `/reference-check/`.
