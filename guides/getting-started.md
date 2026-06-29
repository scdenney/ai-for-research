# Getting started: an agentic environment and the skills

A short setup guide that the demos in this repo point back to. The goal is an AI
setup that can **read a folder of your files and run reusable skills**, rather
than a chat window you paste into.

## 1. An agentic environment

You need a tool that works inside a project directory and can run skills, not
just answer prompts. The reference setup is [Claude Code](https://www.claude.com/product/claude-code),
a command-line agent. Cursor, or any agent that supports the same skills format,
works too. Install it and open it inside the folder you want to work in.

## 2. Install the Open Science Skills

The checks the demos use live in the [Open Science Skills](https://github.com/scdenney/open-science-skills)
plugin. Install it once, user-wide:

```bash
claude plugin marketplace add scdenney/open-science-skills
claude plugin install oss@open-science-skills
```

Restart the tool so the skills load. Confirm with `/help` that `oss:` commands
appear. The three that carry the reference-check workflow:

- `research-repo` — scaffolds the source library (the knowledge base).
- `citation-check` — audits whether each citation exists, resolves, and parses.
- `fact-check` — audits whether each cited source supports the claim it backs.

## 3. Organize sources into a knowledge base

The claim checker can only compare your sentences against sources it can read,
so the sources have to live on disk as machine-readable text. The convention,
scaffolded by `research-repo`:

```
sources/
├── og/   original PDFs you keep locally (gitignored)
└── md/   one Markdown file per source — the knowledge base the checker reads
```

In real work you drop a PDF into `og/` and the intake step (`process-source`)
converts it to `md/<author>-<year>-<slug>.md`. The rule that matters: **the
checker reads `sources/md/`, never the PDF.**

## 4. Run the checks

From inside your project:

```bash
/oss:citation-check manuscript.md references.bib   # existence, DOIs, parity
/oss:fact-check manuscript.md                       # does the source support the claim?
```

The [reference-check demo](../demos/reference-check/) walks through both on a
sample project with planted errors, and shows what the output should look like.

## 5. The part the tools do not do

Every flag is a place to go look, not a verdict to publish. A "likely
fabricated" label can be a real paper the tool could not reach. A claim flagged
as overreaching might just need one reworded word. The tools narrow the search.
You make the call, and you own it.
