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

Ask an agent whether a source supports a claim and it needs the source. Not the citation,
not your memory of the paper, the text itself. Most projects cannot supply that. The papers
sit in a downloads folder as `Download (3).pdf`, the bibliography was assembled at the end,
and the reading happened in a conversation that has since closed.

Two things go wrong from there. The work does not persist. Each session starts from
nothing, and you either re-explain the project or the agent proceeds on a version it
invented. And there is nothing to check against. A claim check that cannot open the source
can only guess.

The fix is to move the source material out of the conversation and into files. Readable
files an agent can search, read, update, and cite, and that are still there when the
session ends. That move is close to what Andrej Karpathy has called an LLM wiki, though the
setup here is not the same. Persistence does not make the contents correct. It makes them
available for inspection and revision.

The lecture's advice for its collaborate mode was to build a shared research workspace and
check its sources and outputs. What a person needs to review, rather than leave to an
agent, follows from the task and the checks available for it. A knowledge base is what
makes a workspace checkable.

*Diagram 1: a pile of downloads on the left, a source library on the right.*

---

## What a knowledge base is {#what}

A folder of PDFs is not a knowledge base by default. A new project folder usually has
scattered files, drafts with unclear provenance, and no shared naming rule. A working one
has readable source files, stable links to source identity, and instructions for its own
upkeep. That structure has to be built and maintained on purpose. Four folders and one
contract.

- **`sources/og/`** — the originals, exactly as acquired. Gitignored, for size and for
  copyright. The authority whenever a conversion is in doubt.
- **`sources/md/`** — the Markdown conversions. Tracked in git. This is the part an agent
  reads and the part a `grep` searches.
- **`sources/unprocessed/`** — the drop zone. Files land here and stay until they have been
  identified, named, converted, and registered.
- **`sources/references.bib`** — one entry per source, added at intake rather than in a
  batch at the end. The key has to resolve to its file by author and year, because that is
  how a checker maps a citation to a document.

Everything else in the project, the analysis, the manuscript, the replication package,
grows out from these four. Git keeps the changes recoverable and attributable across
sessions.

**The rule.** Read from `md/`, never from the PDF. Cite from `references.bib`. A key that
does not resolve to a filed source is a citation nobody can check, including you.

*Diagram 2: the spine, with the tracked and ignored split and the key-to-file contract.*

---

## Set up {#setup}

Install Claude Code and the skills first (see Getting started). A skill is a stored
procedure for a task you expect to do again. It holds instructions, and often scripts,
templates, and examples. Invoking one loads that procedure for the task at hand. The agent
then works against the repository, and you inspect what it did. Then, in the folder where
the project will live:

```
/oss:research-repo .
```

The skill puts the folder under version control, writes the four parts above, adds a
conversion script and a project-local `/process-source` command, and sets up the Python
environment the converter needs. On an empty library the smoke test prints
`Nothing new to convert.`

Converting PDFs needs Java 11 or newer for the extraction backend, and `poppler-utils` for
the check that spots a scan. If the project already exists, the same command audits it
instead of scaffolding over it. That is the section below.

---

## Add the first source {#intake}

Intake is five steps, split between you, the agent, and a tool.

**Drop.** You put the file into `sources/unprocessed/` under whatever name it arrived with.

**Identify.** The agent reads enough of it to propose author, year, title, and venue. You
confirm them. This step cannot be skipped, because everything downstream inherits it.

**Rename.** The agent names and files it. `author-year-slug`, lowercase, hyphens, up to
three authors and then `firstauthor-etal`. `Download (3).pdf` becomes
`ferreira-nair-2021-compulsory-voting.pdf`. The name is what makes a citation key
resolvable to a document later.

**Convert.** A tool converts. You check the result.

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

The script only touches files with no conversion yet, so re-running it is safe. Figures
extracted from a PDF go into a separate image folder, linked by path.

**Register.** The agent extracts the candidate metadata, verifies it, and adds the
bibliography entry.

*Diagram 3: the intake pipeline, what each step leaves on disk, and who does it.*

---

## What goes wrong {#failures}

Four of the five failures below are in the demo on purpose. The fifth, the flattened
table, is what the converter actually did.

| Symptom | What it means | What to do |
|---|---|---|
| `NEEDS OCR (image-only)` | The PDF is a photograph of a page. There is no text to extract. | Send it to `vlm-ocr`, or summarize it by hand. Do not leave it sitting in `og/`. |
| A table that reads as one run-on line | The extractor kept the numbers and lost the structure | Go back to the original for anything where the layout carried the meaning |
| Headings where the author line should be | The `.docx` branch guessed at document structure | Fix the file, or know it is there when you read it |
| A conversion with no bibliography entry | Read, but not citable | Add the entry |
| An entry with no source anywhere | Cited, but unfiled | Acquire it, or move it to `missing.bib` with a note on why you could not |

The first one is the one to take seriously. Without the guard that catches it, the
converter exits successfully and writes a few kilobytes of noise, and that file then looks
exactly like a source that has been acquired, converted, filed, and read. A refusal is
better than a silent success.

A success message only means the tool ran. It says nothing about whether the result is
right. The tool creates readable text. You check it. This table is in the original PDF:

| Outcome | Estimate | 95% interval |
|---|---|---|
| Turnout (percentage points) | 11.2 | 8.4 to 14.0 |
| Knowledge index (standard deviations) | 0.01 | −0.06 to 0.08 |

This is what came out the other side:

```
### 3. Results Outcome Estimate 95% interval

Turnout (percentage points) 11.2 8.4 to 14.0 Knowledge index (standard deviations) 0.01 −0.06 to 0.08
```

The numbers survived. The structure did not. An agent reading that file can still find 11.2
and 0.01 and quote the sentences around them. It cannot reliably tell you which interval
belongs to which outcome. Nothing in the run log says so. You find it by opening the file.

---

## Audit the project you already have {#audit}

Most researchers do not start clean. Point the same skill at an existing folder and its
audit mode reports what is present, what is partial, and what is missing.

```
/oss:research-repo path/to/project
```

On the half-built project this demo ships, it should find two originals that were never
converted, two filenames that break `author-year-slug` so no citation key can resolve to
them, one conversion with no bibliography entry, and one bibliography entry with no source
anywhere in the project. It should also report the pipeline itself as missing. No
`.gitignore`, no `scripts/convert-sources.sh`, no `sources/README.md`.

The bibliography drift runs in both directions, and both are worth checking. A library
drifts away from its bibliography as easily as a bibliography drifts away from its library.

Git makes changes recoverable and attributable across sessions. Originals stay local,
Markdown conversions are tracked. But recorded is not verified. Git history tells you what
changed and who changed it. The audit tells you what is present, partial, or missing.
Neither one tells you that a filed source is right.

---

## What a knowledge base makes possible {#unlocks}

The knowledge base is the first of four links, and it is the one the others stand on.

| Part of the flow | Skill | What it does |
|---|---|---|
| Knowledge base | `research-repo` | Preserve and connect the evidence |
| Source identity | `citation-check` | Resolve citations and bibliographic records |
| Claim support | `fact-check` | Compare manuscript claims with filed sources |
| Paper and package | `paper-review-lite`, `replication-package` | Review the paper and execute package checks |

Each skill changes the division of planning, action, and review between researcher and
agent.

Each is bounded, and the bounds are worth stating plainly. `citation-check` needs Crossref,
OpenAlex, DataCite, or Semantic Scholar to confirm that a work exists, and reports
`NOT CHECKED` rather than guessing when it cannot reach them. `fact-check` refuses to start
until roughly two thirds of the cited works have a matching source file, which is the right
behaviour and also a reminder that a thin library produces a thin check.
`paper-review-lite` reads what it is given. It can catch an abstract reporting one number
against a table reporting another. On its own it cannot catch both agreeing on a number the
analysis no longer produces. The verify pass in `replication-package` closes part of that
gap. It checks a package's structure and, with explicit permission for each run, executes
the master script and compares what appeared against the crosswalk. It compares exit
status and filenames. It does not compare values.

Together these improve **verifiability**. Another person can inspect the inputs, the
transformations, and the evidence, and check what was done. They do not establish
**validity**. Whether the question, the design, the measurement, and the interpretation
warrant the conclusion is still yours to argue.

---

## Reading the sources behind one sentence {#claim}

An archived draft of Denney, *Governing Immigration by the Rules* (2026), contained this
sentence: "Studies of unilateral policymaking similarly show that citizens penalize
executive action relative to legislative action," citing Reeves & Rogowski (2016) and
Christenson & Kriner (2017).

To support that sentence, the sources would have to compare support for the same policy
under executive action and under legislation.

A `fact-check` run on 16 September 2026, recorded for the lecture, confirmed that both
works exist, match their DOI records, and sit in the knowledge base as readable files. Then
it read them. Reeves and Rogowski report that "only about a quarter of respondents in any
of the surveys supported unilateral policy making." That supports low general support for
unilateral power, not a same-policy comparison. Christenson and Kriner report that the
student-loan route "has no significant influence on the probability of a subject backing
the president." That supports no significant route effect, not a general penalty on
executive action.

Verdict: unsupported, for the comparative claim as written. The verdict is about the
sentence, not the two studies.

*Diagram 4: claim → two sources read → verdict → revision.*

The report returned quoted evidence and a suggested revision. The recommendation is
advisory. The researcher decides whether and how to revise. The revision in the draft's
history, dated 27 August 2026, reads: "Studies of unilateral policymaking find that
Americans express low generalized support for unilateral powers (Reeves & Rogowski 2016)
while judging particular unilateral acts largely by whether they agree with them
(Christenson & Kriner 2017)."

What made this inspectable: the original paper, the readable conversion, the citation
identity, an explicit check, and the revision history, all on record. A skill can repeat
the procedure. The researcher still decides whether the revision is right.

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
