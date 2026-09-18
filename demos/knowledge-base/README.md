# Knowledge-Base Demo

**Turn a folder of badly named downloads into a source library an agent can actually read.**

Part of [**AI for Research**](../../). This is the demo that comes before
[reference-check](../reference-check/): it builds the knowledge base that the
source-claim check needs, using the
[`research-repo`](https://github.com/scdenney/open-science-skills/blob/main/plugin/skills/research-repo/SKILL.md)
skill from [Open Science Skills](https://github.com/scdenney/open-science-skills).

You start with four files as they actually arrive — a browser download called
`Download (3).pdf`, a publisher filename, a `.docx` somebody emailed, and a photographed
scan with no text in it. You end with three readable sources, a bibliography whose keys
resolve to files, and one source the converter refused to guess at.

1. **Scaffold** the source spine, or audit the one you already have.
2. **Drop** new files into `sources/unprocessed/`.
3. **Identify** each one and rename it `author-year-slug`.
4. **Convert** it to Markdown and **inspect** what the conversion did.
5. **Register** the bibliography entry, so the citation key resolves to the filed source.
6. **Audit** the result, and keep auditing it, because libraries drift.

> **The one rule.** A conversion that succeeded is not a conversion that is correct.
> The original stays the authority for tables, figures, page references, and anything
> where layout carried meaning. Open the file before you trust it.

## What's in here

```
demos/knowledge-base/
├── inbox/                  # four files as they arrive, names and all
│   ├── Download (3).pdf                 #   a text PDF with an unusable name
│   ├── 1-s2.0-S0261379421000342.pdf     #   a publisher filename
│   ├── osei_socialtrust_FINAL_v2.docx   #   not a PDF at all
│   └── scan-0417.pdf                    #   an image-only scan, no text layer
├── messy-project/          # a half-built repo to point the audit at
├── expected-output/        # what each step should produce, captured from a real run
│   └── finished-base/      #   the knowledge base you end up with
├── prompts/run.md          # the exact commands, in order
├── scripts/                # regenerates inbox/ from the synthetic paper text
└── ANSWER-KEY.md           # every planted problem and what should be reported
```

The rendered walkthrough lives at [`docs/knowledge-base/`](../../docs/knowledge-base/).

## Quick start

Install Claude Code and the skills first (see
[Getting started](https://scdenney.github.io/ai-for-research/getting-started/)):

```bash
git clone https://github.com/scdenney/ai-for-research.git
cd ai-for-research/demos/knowledge-base

mkdir -p ~/kb-demo && cd ~/kb-demo        # a fresh folder to build in
claude
```

Then, in the session:

```
/oss:research-repo .
```

Copy the four files from `inbox/` into `sources/unprocessed/` and work through
[`prompts/run.md`](prompts/run.md).

Converting PDFs needs Java 11 or newer, a Python virtual environment with
`opendataloader-pdf`, and `poppler-utils` for the image-only check. The skill sets the
last two up for you. If you would rather read than run, `expected-output/` has the
result of each step.

## Why a synthetic project

The four sources are invented, and so are their authors, journals, and countries. That
keeps the demo self-contained, redistributable, and free of any real scholar's name.
Every generated file says so on its first page, and `scripts/make-inbox.sh` rebuilds
them all from the text in `scripts/originals/`.

The conversion problems, though, are real. The flattened table in
`expected-output/04-inspect-the-conversion.md` is what the converter actually did to
that table, not an illustration of what it might do.

## The skills this demonstrates

| Skill | Does |
|---|---|
| [`research-repo`](https://github.com/scdenney/open-science-skills/blob/main/plugin/skills/research-repo/SKILL.md) | Scaffolds the source spine, or audits an existing repo against it |
| [`doc-to-markdown`](https://github.com/scdenney/open-science-skills/blob/main/plugin/skills/doc-to-markdown/SKILL.md) | Converts a single document when you do not need the whole pipeline |
| [`vlm-ocr`](https://github.com/scdenney/open-science-skills/blob/main/plugin/skills/vlm-ocr/SKILL.md) | Reads the image-only scan that the converter refuses to guess at |
| [`fact-check`](https://github.com/scdenney/open-science-skills/blob/main/plugin/skills/fact-check/SKILL.md) | The first thing the finished knowledge base makes possible |

## License

CC BY-NC 4.0, matching the Open Science Skills repository.
