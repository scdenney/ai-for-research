# Exact prompts to run the demo

Open this repository in an agentic coding tool that supports skills (Claude Code
is the reference setup) with the Open Science Skills plugin installed. Then:

## 0. Install the skills (one time)

```bash
claude plugin marketplace add scdenney/open-science-skills
claude plugin install oss@open-science-skills
```

Restart the tool so the skills load. Confirm with `/help` that `oss:` commands
appear.

## 1. Reference check (existence, DOIs, parity)

Type the slash command, or just ask in plain language:

```
/oss:citation-check sample-project/manuscript.md sample-project/references.bib
```

or

```
Run a citation check on sample-project/manuscript.md against
sample-project/references.bib. APA 7. Flag fabricated, malformed, or
inconsistent references.
```

Compare what you get to `expected-output/citation-audit-report.md`.

## 2. Source-claim check (does the source support the claim?)

```
/oss:fact-check sample-project/manuscript.md
```

`fact-check` will look for the knowledge base on its own. It first runs a
pre-flight gate (knowledge base must exist and cover the cited works), then
`citation-check`, then the claim-support pass against `sample-project/sources/md/`.

Compare to `expected-output/fact-check-report.md`.

## 3. The part the machine does not do

For every flag, do the human step:

1. **Re-derive the evidence.** Open the source file the report quotes. Read the
   passage yourself. Does it say what the report says?
2. **Confirm before you escalate.** Never repeat the word "fabricated" outside
   your own notes until you have personally failed to find the source.
3. **Decide the fix.** "Causes" → "is associated with" is yours to make, not the
   checker's.

## Try breaking it

- Add a real, correct reference of your own and re-run step 1. It should verify.
- Edit a claim in `manuscript.md` to match its source and re-run step 2. The
  CONTRADICTED row should turn into SUPPORTED.
- Delete a file from `sources/md/` and re-run step 2. Watch the pre-flight gate
  refuse, rather than quietly checking around the hole.
