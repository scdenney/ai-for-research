# AI for Research

**Demos, lecture slides, and how-to guides for working with AI agents and skills, not chatbots, in empirical social science.**

A teaching hub maintained by [Steven Denney](https://scdenney.net). It is where I put the worked demonstrations, slide decks, and practical guides I use to show students and faculty colleagues how to use agentic AI in research without getting burned by it. Companion to the [Open Science Skills](https://github.com/scdenney/open-science-skills) toolkit.

**Rendered site:** [scdenney.github.io/ai-for-research](https://scdenney.github.io/ai-for-research)

## What's here

```
ai-for-research/
├── docs/                       # the GitHub Pages site (landing page + per-demo pages)
│   ├── index.html              #   hub landing
│   └── reference-check/        #   walkthrough for the reference-check demo
├── demos/                      # self-contained projects you can clone and run
│   └── reference-check/        #   reference + source-claim checking
├── lectures/                   # slide decks and notes from talks and workshops
└── guides/                     # short how-to write-ups the demos point back to
    └── getting-started.md      #   set up an agent + install the skills + build a knowledge base
```

## Demos

| Demo | What it teaches | Skills |
|------|-----------------|--------|
| [**reference-check**](demos/reference-check/) | Catch fabricated, malformed, or inconsistent citations, then check whether each cited source actually supports the claim attached to it. Runs offline on a synthetic manuscript with planted errors. | `citation-check`, `fact-check`, `research-repo` |

More to come. Each demo ships sample files, the exact prompts, expected output, and a clear warning about where the human still has to verify.

## Lectures

Slide decks and notes live in [`lectures/`](lectures/). Added as talks are given.

- [**From Pixels to Patterns**](https://scdenney.github.io/assets/slides/from-pixels-to-patterns/#1) — computer vision and language models in empirical social science and the digital humanities.

## Guides

- [**Getting started**](guides/getting-started.md) — an agentic environment, installing the Open Science Skills, and organizing sources into a local knowledge base the tools can read.

## Using this in your own teaching

Everything here is released under [CC BY-NC 4.0](LICENSE). Clone it, adapt a demo for a seminar, lift the slides, or point students straight at the site. Issues and pull requests welcome, including suggestions for new demos.
