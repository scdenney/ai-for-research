# Orchestration Lab

**Five real analyses, run three ways with Claude models.** Five briefs across three rungs of difficulty — a conjoint description, estimation, and reviewer reply (moderate), an IV replication-and-stress exercise (high), and a genuine methods-dispute adjudication (very high) — each run under a light lead, a heavy lead, and a single advisor consult. The three arms are used identically on every brief. Every run is committed with its transcript record, token counts, and figures.

The modes:

| Mode | Lead | Delegates to | Platform |
|---|---|---|---|
| `fable-orchestrate` | Fable 5 (light, effort max) | Opus deep-reasoner · Sonnet fast-worker · peer-model check | Claude Code |
| `opus-orchestrate` | Opus 4.8 (heavy, ultracode) | same bench; reasons on hard parts itself | Claude Code |
| `advisor` | plain session + one consult | Fable 5 as the reviewer | Claude Code |

> A Codex-led counterpart (`46-orchestrate`, gpt-5.6-terra lead) was re-run on all five briefs via headless `codex exec` on 2026-07-12 and is scored in `RESULTS.md` and `SCORING.md`; it stays out of the dollar charts because Codex reports tokens, not USD. A Codex-side advisor arm is captured for the hard brief only, pending its own re-run.

> **The one rule.** A captured run is one draw from a non-deterministic process, not a benchmark. These are specimens. Read the routing traces and the artifacts, re-run the briefs yourself, and expect your numbers to differ.

## What's in here

```
orchestration-lab/
├── prompts/            # the five briefs (identical across modes) + run instructions
├── data/README.md      # provenance: projoint, ivdoctr, causaldata (no data committed)
├── reference/          # the answer keys: reference solutions + rubrics, written and run first
├── runs/               # the captured runs, one leaf per mode × brief
│   └── opus/SESSION-PROTOCOL.md   # the user-driven Opus capture protocol
├── SCORING.md          # how Pass / Pass+ / Distinction are defined and assigned
├── EXTENSIONS.md       # the complexity ladder: what was planned, what ran, backups
└── RESULTS.md          # the findings matrix the walkthrough page reads from
```

## Quick start

```bash
git clone https://github.com/scdenney/ai-for-research.git
cd ai-for-research/demos/orchestration-lab
Rscript -e 'install.packages(c("projoint", "ivdoctr", "AER", "car", "causaldata", "MatchIt"))'
```

Then read `prompts/run.md` and re-run any cell of the matrix. This demo calls hosted models. It is not offline, and the larger briefs cost real money (the committed run logs record what each cost us).

## Why real data

Every brief analyzes real, package-shipped, public data: the projoint community-choice conjoint (400 respondents), the Acemoglu-Johnson-Robinson colonial-origins sample (64 countries, via ivdoctr), and the LaLonde NSW experiment with its CPS comparison pool (via causaldata). Nothing to download, no license questions. See `data/README.md`.

## The skills this demonstrates

`fable-orchestrate`, `opus-orchestrate`, and `advisor` from the [Open Science Skills](https://github.com/scdenney/open-science-skills) toolkit, plus the Codex-led `46-orchestrate` and the `figures` conventions every brief enforces.

## License

CC BY-NC 4.0, same as the parent repository.
