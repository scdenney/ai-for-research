# The knowledge base this demo builds

If you run the intake pipeline in `prompts/run.md`, this is what you end up holding.
It is here so you can see the finished shape without running anything, and so the
next demo has something to read.

- `sources/md/` — three sources, converted from the inbox files, greppable
- `sources/references.bib` — one entry per converted source
- `sources/missing.bib` — one work that was cited and could not be filed
- `sources/md/marchetti-2016-reluctant-voter.NOTE.md` — the same work, as a `.NOTE.md`
  alongside its `missing.bib` entry: a repo-authored note, warned as not a source, for a
  book no digital copy exists for

`missing.bib` and the Marchetti note were added by hand to show the convention. Running
the pipeline will not produce them; the skill does not write `.NOTE.md` files.

The fourth inbox file, the scan, is deliberately not here. It has no text layer, the
converter refuses to guess at it, and it stays in `sources/og/` waiting for OCR.
