# sources/og/ — original PDFs go here

In a real project this folder holds the **original PDF/document** for each source.
It is normally **gitignored** (file size + copyright): you keep the PDFs locally,
and the tracked, machine-readable knowledge base lives one folder over in
`sources/md/`.

For this self-contained demo there are no PDFs to ship, so `sources/md/` already
contains faithful Markdown summaries written by hand. In your own work you would
not write those by hand: you would drop the PDF here and let the intake step
(`process-source`, scaffolded by the `research-repo` skill) convert it to
`sources/md/<author>-<year>-<slug>.md`.

The rule that matters: **read sources from `sources/md/`, never from the PDF.**
That is the file the claim checker reads.
