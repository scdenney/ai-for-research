# Orchestration Lab

**Six real analyses, run four ways.** Six briefs across four rungs of difficulty — a conjoint description, estimation, and reviewer reply (moderate), an IV replication-and-stress exercise (high), a genuine methods-dispute adjudication (very high), and a modern staggered-DiD estimator reconciliation (extreme) — each run under a Fable lead, an Opus lead, a single advisor consult, and a Codex lead. The four arms are used identically on every brief. None dials effort down; the split is strategy, not a weaker setting. Every run is committed with its transcript record, token counts, and figures.

The high and very-high tiers are decades-old, thoroughly rehearsed textbook disputes — every arm reached the top rubric band on both, converging on the same verdict. The extreme tier was built to test whether that convergence was about the arms or about the tasks: a 2020s-vintage methods debate (modern heterogeneity-robust difference-in-differences under staggered treatment timing) with a genuine, verifiable trap baked into the data itself, not manufactured after the fact — see `EXTENSIONS.md`. It did not show the hypothesized separation: all five arms reached Distinction, including the historical weak point (the Codex headless single-tier fallback). See `RESULTS.md`'s 2026-07-17 section for why.

The arms and their exact settings, as of the 2026-07-17 full rerun:

| Arm | Lead model + effort | Delegates to | Platform |
|---|---|---|---|
| `fable-orchestrate` | Fable 5 · max | Opus 4.8 deep-reasoner (max) · Sonnet 4.5 fast-worker (medium) · gpt-5.6-sol Codex peer (xhigh) | Claude Code |
| `opus-orchestrate` | Opus 4.8 · ultracode | Sonnet 4.5 fast-worker (medium); reasons on hard parts itself; gpt-5.6-sol Codex peer (xhigh) on the high-stakes parallel path | Claude Code |
| `advisor` | Sonnet 5 (plain session, no orchestration skill, solve + revise) | one Fable 5 reviewer · max (single consult) | Claude Code |
| `46-orchestrate` | gpt-5.6-sol · high | gpt-5.6-terra out-of-band one-shots for bounded work; gpt-5.6-luna only for tightly specified mechanical work | Codex CLI |

All six briefs were re-run today, in one sitting, across all five captured arms (the four above, plus the headless single-tier Codex fallback that needs no interactive session) under this one consistent settings pass — replacing three separate prior capture dates that each used different Codex-peer and Codex-lead defaults. The `46-orchestrate` results reported on the page and in the post are the Sol-lead interactive capture (`gpt-5.6-sol` · high leading, delegating to `gpt-5.6-terra` one-shots out-of-band; leaves in `runs/46-sol/`). It stays out of the dollar charts because Codex reports tokens, not USD. The headless single-tier Terra/Sol fallback capture (no interactive session, no cross-tier delegation possible) is in `runs/46/` and `RESULTS.md`; a Codex-side advisor-arm capture exists for every tier in `runs/advisor/*-codex/` but remains a secondary, non-primary data point.

The [demonstration page](https://scdenney.github.io/ai-for-research/orchestration-lab/) walks the run-a-cell-yourself path; the findings report, [Four ways to run a frontier model](https://www.pixelsandpatterns.org/p/four-ways-to-run-a-frontier-model), is on Pixels & Patterns.

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
Rscript -e 'install.packages(c("projoint", "ivdoctr", "AER", "car", "causaldata", "MatchIt", "did", "fixest", "staggered", "bacondecomp"))'
```

Then read `prompts/run.md` and re-run any cell of the matrix. This demo calls hosted models. It is not offline, and the larger briefs cost real money (the committed run logs record what each cost us).

## Why real data

Every brief analyzes real, package-shipped, public data: the projoint community-choice conjoint (400 respondents), the Acemoglu-Johnson-Robinson colonial-origins sample (64 countries, via ivdoctr), the LaLonde NSW experiment with its CPS comparison pool (via causaldata), and the Callaway-Sant'Anna staggered minimum-wage panel (500 counties, via the `did` package). Nothing to download, no license questions. See `data/README.md`.

## The skills this demonstrates

`fable-orchestrate`, `opus-orchestrate`, and `advisor` from the [Open Science Skills](https://github.com/scdenney/open-science-skills) toolkit, plus the Codex-led `46-orchestrate` and the `figures` conventions every brief enforces.

## License

CC BY-NC 4.0, same as the parent repository.
