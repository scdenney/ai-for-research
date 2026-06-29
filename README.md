# AI for Research

**Demos, lecture slides, and a setup walkthrough for working with AI agents and skills, not chatbots, in empirical social science.**

A teaching hub maintained by [Steven Denney](https://scdenney.net). It is where I put the worked demonstrations, slide decks, and the short setup walkthrough I use to show students and colleagues how to use agentic AI in research without getting burned by it. Companion to the [Open Science Skills](https://github.com/scdenney/open-science-skills) toolkit.

**Rendered site:** [scdenney.github.io/ai-for-research](https://scdenney.github.io/ai-for-research)

## What's here

```
ai-for-research/
├── docs/                       # the GitHub Pages site
│   ├── index.html              #   landing page (getting started · demos · lectures)
│   └── reference-check/        #   walkthrough for the reference-check demo
├── demos/                      # self-contained projects you can clone and run
│   └── reference-check/        #   reference + source-claim checking
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
version of this is the first section of the [site](https://scdenney.github.io/ai-for-research).

## Demos

| Demo | What it teaches |
|------|-----------------|
| [**reference-check**](demos/reference-check/) | Catch fabricated or malformed citations against your **reference list** (no knowledge base needed), then check whether each cited source actually supports the claim, against a small **knowledge base** of your sources. Runs offline on a synthetic manuscript with planted errors. |

More to come. Each demo ships sample files, the exact prompts, expected output, and a note on where the human still has to verify.

## Lectures

- [**From Pixels to Patterns**](https://scdenney.github.io/assets/slides/from-pixels-to-patterns/#1) — computer vision and language models in empirical social science and the digital humanities.

New decks go in [`lectures/`](lectures/) as talks are given.

## License

Released under [CC BY-NC 4.0](LICENSE). Clone it, adapt a demo for a seminar, lift the slides, or point students straight at the site. Issues and pull requests welcome, including suggestions for new demos.
