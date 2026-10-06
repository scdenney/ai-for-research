# AI for Research

**Demos, lecture slides, and a setup walkthrough for working with AI agents and skills, not chatbots, in empirical social science.**

A teaching hub maintained by [Steven Denney](https://scdenney.net). It is where I put the worked demonstrations, slide decks, and the short setup walkthrough I use to show students and colleagues how to use agentic AI in research without getting burned by it. Companion to the [Open Science Skills](https://github.com/scdenney/open-science-skills) toolkit.

**Rendered site:** [scdenney.github.io/ai-for-research](https://scdenney.github.io/ai-for-research)

## What's here

```
ai-for-research/
├── docs/                       # the GitHub Pages site
│   ├── index.html              #   landing page (getting started · demos · lectures · skills)
│   ├── getting-started/        #   setup walkthrough (Claude Code and Codex, via terminal)
│   ├── skills/                 #   index of every Open Science Skills skill
│   ├── knowledge-base/         #   walkthrough for the knowledge-base demo
│   ├── reference-check/        #   walkthrough for the reference-check demo
│   ├── orchestration-lab/      #   walkthrough for the orchestration-lab demo
│   ├── talk-to-your-terminal/  #   working in the terminal with an agent
│   └── lectures/               #   the lectures page
├── demos/                      # self-contained projects you can clone and run
│   ├── knowledge-base/         #   build a source library from a pile of downloads
│   ├── reference-check/        #   reference + source-claim checking
│   └── orchestration-lab/      #   four ways of running frontier models, scored
└── lectures/                   # slide decks and notes from talks and workshops
```

## Getting started

Set up Claude Code (the command-line AI tool that runs the skills), then add the
Open Science Skills:

```bash
npm install -g @anthropic-ai/claude-code      # docs: code.claude.com/docs
claude plugin marketplace add scdenney/open-science-skills
claude plugin install oss@open-science-skills
```

Open Claude Code in a project folder and the skills are ready to call. The full
version of this is the first section of the [site](https://scdenney.github.io/ai-for-research),
which also covers setting up [Codex](https://developers.openai.com/codex/skills) as an alternative.

## Skills

Every skill in the toolkit, indexed with a plain-language explanation of what it does:
[**scdenney.github.io/ai-for-research/skills**](https://scdenney.github.io/ai-for-research/skills/).

## Demos

| Demo | What it teaches |
|------|-----------------|
| [**knowledge-base**](demos/knowledge-base/) | Turn a folder of badly named downloads into a **source library** an agent can read: scaffold the spine with `research-repo`, run the intake pipeline on four files as they arrive (two unusable filenames, a `.docx`, an image-only scan), see what conversion quietly breaks, and audit a project that grew without a convention. Runs on local files, and builds the knowledge base the reference-check demo consumes. |
| [**reference-check**](demos/reference-check/) | Catch fabricated or malformed citations against your **reference list** (no knowledge base needed), then check whether each cited source actually supports the claim, against a small **knowledge base** of your sources. Runs on local files (no web sources needed) on a synthetic manuscript with planted errors. |
| [**orchestration-lab**](demos/orchestration-lab/) | Six social-science analyses, each run four ways with the Open Science Skills (a Fable lead, an Opus lead, an advisor consult and a Codex lead) and scored against answer keys written before any model ran. The captured runs are from July 2026, with the models and skills of that time; a re-run with the current skills is planned. Calls hosted models, so it is not offline. |

More to come. Each demo ships sample files, the exact prompts, expected output, and a note on where the human still has to verify.

## Lectures

- [**Rethinking the Research Process**](https://scdenney.github.io/ai-for-research/lectures/rethinking-the-research-process/) — how AI is changing research for students and professors; Korea University, 18 September 2026. Source, notes, and diagrams in [`lectures/2026-09-korea-university-rethinking-the-research-process/`](lectures/2026-09-korea-university-rethinking-the-research-process/).
- [**No Previews in Pyongyang**](https://scdenney.github.io/assets/slides/no-previews-in-pyongyang/) — an LLM, embeddings, and AI-assisted workflows to build and validate a dictionary of reform language, then three decades of a North Korean economics journal.
- [**From Pixels to Patterns**](https://scdenney.github.io/assets/slides/from-pixels-to-patterns/#1) — computer vision and language models in empirical social science and the digital humanities.

New decks go in [`lectures/`](lectures/) as talks are given.

## License

Released under [CC BY-NC 4.0](LICENSE). Clone it, adapt a demo for a seminar, lift the slides, or point students straight at the site. Issues and pull requests welcome, including suggestions for new demos.
