# Orchestration Lab

**One real conjoint analysis, run three ways with Claude models.** The same three briefs (easy, standard, hard) run under a light lead, a heavy lead, and a single advisor consult. Every run is committed with its transcript, token counts, and figures.

The modes:

| Mode | Lead | Delegates to | Platform |
|---|---|---|---|
| `fable-orchestrate` | Fable 5 (light, effort max) | Opus deep-reasoner · Sonnet fast-worker · peer-model check | Claude Code |
| `opus-orchestrate` | Opus 4.8 (heavy, ultracode) | same bench; reasons on hard parts itself | Claude Code |
| `advisor` | plain session + one consult | Fable 5 as the reviewer | Claude Code |

> A Codex-led counterpart (`46-orchestrate`) and a Codex-side advisor are also captured in `runs/`, but they stay out of the public write-up until re-run from a live Codex session.

> **The one rule.** A captured run is one draw from a non-deterministic process, not a benchmark. These are specimens. Read the routing traces and the artifacts, re-run the briefs yourself, and expect your numbers to differ.

## What's in here

```
orchestration-lab/
├── prompts/            # the three briefs (identical across modes) + run instructions
├── data/README.md      # provenance: projoint exampleData1 (no data committed)
├── reference/          # the answer key: reference solutions, written and run first
├── runs/               # the captured runs, one leaf per mode × tier
│   └── opus/SESSION-PROTOCOL.md   # the user-driven Opus capture protocol
└── RESULTS.md          # the findings matrix the walkthrough page reads from
```

## Quick start

```bash
git clone https://github.com/scdenney/ai-for-research.git
cd ai-for-research/demos/orchestration-lab
Rscript -e 'install.packages("projoint")'   # the only dependency beyond R + ggplot2
```

Then read `prompts/run.md` and re-run any cell of the matrix. This demo calls hosted models. It is not offline, and the larger tiers cost real money (the committed run logs record what each cost us).

## Why real data

The runs analyze `exampleData1` from the projoint R package, a real community-choice conjoint (400 respondents, 8 tasks, 7 attributes) that ships with the package, so there is nothing to download and no license question. See `data/README.md`.

## The skills this demonstrates

`fable-orchestrate`, `opus-orchestrate`, and `advisor` from the [Open Science Skills](https://github.com/scdenney/open-science-skills) toolkit, plus the `figures` conventions every brief enforces. The Codex-led `46-orchestrate` is captured but pending re-run.

## License

CC BY-NC 4.0, same as the parent repository.
