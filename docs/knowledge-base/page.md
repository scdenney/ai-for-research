<!--
Prose source for index.html. Edit here; the HTML is mirrored from this file.
The longer walkthrough of the same demo is in walkthrough/.
TODO: link the companion post on Alex Kustov's blog once it is published.
-->

# Build a Knowledge Base

**Lede:** Set up a project, add a paper, check the copy, and close the session.

**Kicker:** Demos · Knowledge base

---

## Before you start {#start}

Install Claude Code and the Open Science Skills ([Getting started](../getting-started/)).
The PDF converter also needs [Java 11](https://adoptium.net) or newer, and the check for
scanned PDFs needs [`poppler-utils`](https://poppler.freedesktop.org).

Whatever the agent reads is sent to your model provider. The sample files are invented.
Before you use your own, check what your provider and your institution allow.

## 1. Set up the project {#setup}

Open Claude Code in an empty folder:

```
mkdir my-project && cd my-project
claude
```

```
/oss:research-repo .
```

*Figure: 01-spine-and-contract.svg.* The folders the skill creates, and how a citation
leads to its bibliography entry, the Markdown copy, and the original.

## 2. Add a paper {#add}

Put a PDF in `sources/unprocessed/` and run:

```
/process-source
```

To use the four sample files instead:

```
git clone https://github.com/scdenney/ai-for-research.git ~/ai-for-research
cp ~/ai-for-research/demos/knowledge-base/inbox/* sources/unprocessed/
```

For each file, the agent:

- renames the original and files it: `Download (3).pdf` becomes
  `sources/og/ferreira-nair-2021-compulsory-voting.pdf`
- writes a Markdown copy: `sources/md/ferreira-nair-2021-compulsory-voting.md`
- adds a bibliography entry with a matching key: `ferreira-nair2021` in
  `sources/references.bib`

PDFs are converted with
[OpenDataLoader PDF](https://github.com/opendataloader-project/opendataloader-pdf).
Check the author and year the agent picks, because the file name and the key are built
from them.

*Figure: 03-intake-pipeline.svg.* One source, five steps.

## 3. Check the copy against the PDF {#check}

Open the Markdown copy next to the original.

- **A scan with no text layer is refused.** The converter reports
  `NEEDS OCR (image-only)` and writes nothing. The original stays in `sources/og/` until
  you run OCR on it, for example with [`/oss:vlm-ocr`](../skills/#vlm-ocr).
- **A table can keep its numbers and lose its layout.** Nothing reports this.

*Figure: 05-table-that-broke.svg.* The results table in the sample Ferreira and Nair PDF,
and the text the converter produced from it.

## 4. End the session {#end}

```
/oss:finished
```

This writes a handoff note (where things stand and what comes next) and adds an entry to
the session log. The first time, it asks before creating these files. It does not commit.
Read both, then commit:

```
git add -A
git status --short   # no line should start with sources/og/
git commit -m "Add the first sources"
```

The originals in `sources/og/` are not committed, so back them up separately. If you push
the project to GitHub, make the repository private: the copies are still copyrighted
text.

## 5. Use it {#use}

- **Pick up later.** In a new session, run [`/oss:sitrep`](../skills/#sitrep). It reads
  the handoff and the log and checks them against the repository.
- **Check claims.** [`/oss:fact-check`](../skills/#fact-check) checks claims in a draft
  against the copies in `sources/md/`.
- **Check references.** [`/oss:citation-check`](../skills/#citation-check) checks the
  reference list and the DOIs.

The [reference-check demo](../reference-check/) has a manuscript to run both checks on.
The [full walkthrough](walkthrough/) covers all four sample files and an audit of a messy
project.
