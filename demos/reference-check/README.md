# Reference-Check Demo

**A hands-on, self-contained walkthrough of checking references and claims with agentic AI.**

Part of [**AI for Research**](../../). This is the companion demo for the
*Pixels and Patterns* post *"The reference that wasn't there."* It lets a scholar
or student reproduce, on a tiny synthetic project, the workflow that the
[Open Science Skills](https://github.com/scdenney/open-science-skills) plugin
automates:

1. **Set up** an agentic AI environment.
2. **Install** the relevant skills.
3. **Organize** sources into a local knowledge base.
4. **Run a reference check** — does each cited work exist, resolve, and parse?
5. **Run a source-claim check** — does each cited source actually support the
   claim attached to it?
6. **Interpret and manually verify** every flag. The machine narrows where you
   look. It does not get the final say.

> **The one rule.** These tools are aids to judgment, not substitutes for it.
> Every flag is a prompt to go read the source yourself. Nothing here should be
> repeated in public, least of all the word *fabricated*, until a human has
> confirmed it.

## What's in here

```
demos/reference-check/
├── sample-project/            # a tiny, synthetic research project to check
│   ├── manuscript.md          #   short paper with deliberately planted errors
│   ├── references.bib         #   bibliography (1 real control + 5 synthetic)
│   ├── sources/og, sources/md #   originals (empty here) + the knowledge base
│   └── ANSWER-KEY.md          #   every planted problem, and what to do about it
├── expected-output/           # what the two checks should roughly produce
└── prompts/run.md             # the exact commands / prompts to run
```

The rendered walkthrough lives at [`docs/reference-check/`](../../docs/reference-check/)
(served at [scdenney.github.io/ai-for-research/reference-check](https://scdenney.github.io/ai-for-research/reference-check)).

## Quick start

```bash
# 1. Get the repo and the skills (Claude Code is the reference setup)
git clone https://github.com/scdenney/ai-for-research.git
cd ai-for-research/demos/reference-check
claude plugin marketplace add scdenney/open-science-skills
claude plugin install oss@open-science-skills   # restart after installing

# 2. Reference check
/oss:citation-check sample-project/manuscript.md sample-project/references.bib

# 3. Source-claim check
/oss:fact-check sample-project/manuscript.md
```

Full step-by-step, including what each flag means and the human follow-up, is in
[`prompts/run.md`](prompts/run.md) and on the
[walkthrough site](https://scdenney.github.io/ai-for-research/reference-check).

## Why a synthetic project

Everything in `sample-project/` is invented, except one real methods reference
(`hainmueller2014`) kept as a control so you can watch a checker *confirm* a real
source. Synthetic sources mean the demo runs offline, reproduces the same way for
everyone, and names no real scholar. It also surfaces an honest limit: to a
verifier, an invented source and a fabricated one look identical. Read
[`sample-project/ANSWER-KEY.md`](sample-project/ANSWER-KEY.md) for the full
accounting.

## The skills this demonstrates

| Skill | Does |
|-------|------|
| [`research-repo`](https://github.com/scdenney/open-science-skills/tree/main/plugin/skills/research-repo) | Scaffolds the `sources/og → sources/md` knowledge base and the intake command that converts PDFs to readable Markdown |
| [`citation-check`](https://github.com/scdenney/open-science-skills/tree/main/plugin/skills/citation-check) | Audits citation existence, DOIs, in-text/reference parity, and fabrication risk |
| [`fact-check`](https://github.com/scdenney/open-science-skills/tree/main/plugin/skills/fact-check) | Checks whether each cited source actually supports the claim, against the local knowledge base |

## License

Content CC BY-NC 4.0, matching the Open Science Skills repository. The synthetic
manuscript and sources are released to be copied, run, and broken.
