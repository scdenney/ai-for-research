# Demo run sheet (pages 35–36, 8 minutes)

File three real sources into a knowledge base, then check a draft against them. The sources are real: a Korean-language article on the 1946 cholera epidemic and Korean stowaways (Kim 2021), an English article on Japan's postwar border controls (Morris-Suzuki 2011), and a scanned SCAP directive of 12 June 1946 (SCAPIN 1015). The draft citing them is written for the demo, with errors planted in it. Materials and the answer key are in `demo/real/`. Rehearsed headlessly on 20 October: intake about 1:50, the claim check about 1:45. Re-tested on 21 October (11:45) with the transcribe-scans instruction: intake 1:21, claim check 1:40, all four planted errors caught, the cholera control supported, and the uncited "largely stopped" flagged. Output in `~/kb-demo-check2/`.

## Primary: the click-through demo (decided 21 Oct)

Open <https://scdenney.github.io/ai-for-research/archive-check/> in a browser tab before the talk. At page 36, switch to that tab and press **F** to hide the site chrome. **→** steps through each highlight, **←** goes back, number keys jump to a step. Nine steps: setup, the draft, the downloads, intake, OCR and a check of the OCR, the Korean search, the reference check, the claim check, and the summary. It replays a recorded run from today. The agent's intake at 11:43 left the scan as needing OCR. GLM-OCR (local, through Ollama) read the scan in 13 s. The agent then checked the OCR text against the scan and made nine corrections, all outside the body text: the header with the date and SCAPIN number, AGC to AGD, and the handwriting, including the pencil note. The claim check on the corrected text caught all four planted errors and confirmed the control. Files in `~/kb-demo-ocr2/`. Nothing can stall; say that it is a recorded run. At step 5, say that one page is easy to check this way, but a whole archive needs a stronger OCR model. Afterwards the audience can open the same page.

The live terminal run below is now the **backup**.

## Before 15:00

- [ ] Terminal, large font: `cd ~/kb-demo && claude`. The library is already scaffolded and the converter installed.
- [ ] `~/kb-demo-inbox/` holds the three PDFs. `~/kb-demo/manuscript/` holds the draft and its bibliography.
- [ ] Network on. The claim check looks up every reference in Crossref and OpenAlex.
- [ ] Fallback ready: `~/kb-demo-done/` is the finished rehearsal, with its output in `~/kb-demo-done/intake.log` and `~/kb-demo-done/factcheck.log`.

## Live

| Clock | Type | Say |
|---|---|---|
| 0:00 | `! ls ~/kb-demo-inbox` | Three files with the names they download under. A journal article in Korean from Europe PMC, an English article from Cambridge, and a SCAP directive from the National Diet Library, which is only a photograph of a typed page. |
| 0:45 | `! cp ~/kb-demo-inbox/* sources/unprocessed/` then `/process-source If a file is a scan with no text, transcribe it yourself into sources/md/ and note at the top that you did.` | It reads each file for author, year and title, renames it, makes a searchable copy, and writes the bibliography entry. The SCAP page has no text, so it is read as an image. Watch for the crossed-out page and the pencil note: rescinded December 1946. |
| 2:45 | `! ls sources/md` and `! grep -n "80%" sources/md/kim*.md` | Every source is searchable, including the Korean. Remember this sentence: of the stowaways who entered Japan, about 80% went back because of hardship. |
| 3:30 | `/oss:fact-check manuscript/manuscript.md` | The draft cites these three sources and one more. First it checks that every reference exists, then it reads the cited passage for each claim. |
| 5:15 | Read the report | Morris-Suzuki: the draft says most went home in 1946, she says fewer than 100,000 by 1950. Kim: 그들 중 약 80%, the stowaways, became "80 percent of returnees". SCAPIN 1015 orders ships seized; it says nothing about suspending repatriation. Lee 2019 does not exist. The cholera date and ship hold. |
| 7:00 | Back to the deck | The machine narrows where I look. I open the source and decide what to write. |

Before the terminal, page 35 (about 1 minute) covers the setup, the sources, the task, and what the method suits. Say there: the sources are real, the draft is mine for this demo, and I put the errors in it. The clock below starts when you switch to the terminal.

## If it stalls

If the agent stops to ask how to handle the scanned SCAP page (OCR or transcribe), answer: `Transcribe it yourself into md/.` Without a text copy of the scan, the claim check refuses to run (pre-flight below two-thirds coverage). This happened in the 21 October 11:43 test run when the instruction was left off.


Say so. `/exit`, then `less ~/kb-demo-done/factcheck.log` and read the same verdicts from the rehearsal. Or return to pages 28–31. Move on at 52:30 whatever happens.

## What varies between runs

The model picks the filenames, labels and wording each time ("contradicted" or "unsupported"; "unverifiable" or "likely fabricated"). It may add notes you did not plan. In rehearsal it traced the 80% figure through Kim's footnote to Morris-Suzuki and Cho Rinsik's survey, and it flagged the draft's uncited claim that crossings "largely stopped" against Kim's 7,378 arrests in July 1946. Name the problem, not the label, and do not promise a verdict before it appears.

## Other versions

- `~/kb-demo-done-synthetic/` and `demo/synthetic/`: the same exercise with invented archival sources (rehearsed, all planted problems found).
- `~/kb-demo-done-turnout/`: the original practice files from `demos/knowledge-base`.

## Reset after rehearsing

```bash
rm -rf ~/kb-demo && tar -xzf ~/kb-demo-pristine.tgz -C ~
```

The archive restores the folder to the same path, so the converter's Python environment keeps working.
