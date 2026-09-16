# Notes review and deck revision, 16 September 2026

## Scope and result

Read `notes.md` end to end, the framework of record, all slide sources, the brief, README, and open questions. Compiled with XeLaTeX and inspected all 52 rendered pages before and after revision. Slide references below are the printed slide numbers, not PDF page numbers. Appendix slides are 44–48. The four unnumbered pages are three section dividers and the appendix divider.

The notes have **6 high, 12 medium, and 43 low findings**. High means a factual or inferential statement to resolve before delivery. Medium means a missing audit trail, an important qualification, or a delivery problem. Low means wording or presentation. Each ID counts once, even when several examples belong to it. Recommendations below are proposals only: `notes.md`, the framework, the open questions, and excluded material were not edited. This is a comparison and delivery review, not a fresh verification of the underlying NWO research. Sources not opened are NOT CHECKED.

## High findings

### H1. Slide 29 calls a synthetic reference real

Notes: “The reference is real and correctly written, so the citation check passes it.” The slide says “Passes,” but `demos/reference-check/expected-output/citation-audit-report.md` explicitly assigns `ferreira-nair2021` **NEEDS AUTHOR VERIFICATION (synthetic)**. The report's table identifies synthetic sources with no web footprint. The local fact-check example does contain the quoted contradiction. Its explanatory paragraph loosely says the reference would pass, so the demo's own explanatory prose and verdict table disagree.

Proposed spoken replacement: “This is a synthetic teaching example. Its reference is internally consistent. Its claim contradicts the supplied source.” Resolve the slide's Passes label before delivery. A metadata formatting check is not the complete citation-check skill. I left this substantive verdict unchanged under the brief's constraints.

### H2. Slide 30's numerical success story conflicts with the guardrail

Notes: “The first run that morning caught two of three. The scan was widened the same day, and the second run caught all three.” Slide 30 likewise presents a model finding the third, Ogura. But **Gate details** says the first run flagged two **Aviña strings** and the second “all three,” which reads as three Aviña strings. Slide 23 shows two Aviña occurrences and one Ogura occurrence. The total of three is consistent, the identity is not.

Proposed clarification, conditional on the receipts: “The first run flagged the two Aviña citations. The model review found the Ogura citation. After I widened the scan, the script flagged all three occurrences.” Check `checks/pilot-first-run.json`, `talks/apsa-2026/checks/2026-09-09/fast.json`, and `report.md` before adopting that causal chronology. Underlying receipts NOT CHECKED here. Correct the guardrail's “all three” referent as well.

### H3. Slide 36 turns absence of a record into proof of no AI

Notes: “Grant and ethics in 2025: nothing on record, all human.” Slide: “no use on record” and “everything on record.” Neither establishes that all activity was human.

Replace with: “I have no recorded AI use for the grant and ethics work in 2025.” This preserves the evidentiary limit in the slide.

### H4. Slide 40 states a different word count

Notes: “a paper at eleven thousand seven hundred words against a ceiling of ten thousand.” Slide and guardrail: **11,772**, against **10,000**. This is not labelled as an approximation.

Replace with: “The paper has eleven thousand seven hundred and seventy-two words against a ceiling of ten thousand.” Alternatively explicitly say “about” before a rounded value. Do not silently change the displayed count.

### H5. Slide 27 groups four different errors as opposite findings

Notes: “Four citations had been supporting the opposite of what their source found.” The slide repeats that claim, but its own rows distinguish a country error, an argument about party divisions, a source that does not address asylum, and a null finding. Geography and absent topical coverage are not opposite empirical results. The guardrail's “four reversed citations” repeats the same overstatement.

Replace the spoken line with: “Four examples show different errors in how I used sources.” Keep the four cases and nineteen corrections. Resolve the corresponding slide and guardrail wording with the author, rather than presenting all four as sign reversals.

### H6. Slides 5 and 20–21 overstate what a mechanical check establishes

Notes 5: “the compiler and the tests answer, and the answer is legible without domain expertise”; “once written they run for free”; “That is why an agent can work unsupervised on code.” Notes 20: “The second control is deterministic.” Notes 21: “The lookups are mechanical: an index either holds the work or it does not.” Slide 15's actual skill description includes claim support and several judgment tasks, not only lookup.

A compiler or test suite establishes selected properties, not correctness of a scientific analysis. Running it has computational cost, and someone must judge coverage. Bibliographic entity matching and deciding what an absent index entry means also require judgment. The notes partly repair this in slide 21, but only after the stronger claim has been repeated.

Suggested replacement at 5: “For software I can write tests and run them repeatedly. The agent can use those results to revise the code. I still have to decide what the tests should check. A research claim usually needs a different kind of check.” At 20: “The lookup step checks the reference against external records.” At 21: “The script applies fixed rules. An unresolved reference still needs review.” This qualifies the mechanism without changing the three-mode argument. The framework itself contains the stronger version, so record this as an author decision, not a silent argument rewrite.

## Medium findings

### M1. Slide 23 claims more provenance than the displayed receipt shows

Notes: “A hundred and forty-seven numbers on the slides, each traced to one checksummed data snapshot.” The slide's actual receipt says **147 table values present in numbers.tex**, with a snapshot identifier. Presence in a generated file does not on its own establish every number's correctness or a verified checksum. The lede also broadens “table values” to “numbers.”

Replace with: “The script found 147 table values in the generated numbers file for the recorded snapshot.” Add the checksum claim only with its own source. Do not infer that this September 9 run protected the September 4 delivery. Slide 36 correctly says it ran afterward.

### M2. The skill-dependent qualification arrives five slides late

The framework explicitly asks for the student/researcher qualification directly under the three-mode table. Notes 7 explains the framework, but the qualification arrives at 12. The slide order is fixed, so add one spoken sentence at 7: “The mode also depends on what the person doing the task needs to learn.” Keep the fuller reading example at 12. Students and professors are not permanent ability categories.

### M3. Slide 11 changes the framework's account of student agency

Notes and slide: “The student has an interest in the outcome, and only I can protect it” / “only you can protect it.” The framework says the student “has an interest and no vote.” The revised claim that only the instructor can protect that interest excludes student agency and other institutional responsibility.

Proposed spoken line: “I cannot give up a student's opportunity to learn on their behalf.” Preserve the obligation without asserting exclusive power. At 12 replace the categorical research/student distinction as proposed in L12.

### M4. Slide 43's title is broader than the spoken claim

Title: “Everything shown today is public.” Notes list the skills, demo site, and slides. That narrower list does not establish public access to the NWO files, private dictation history, feedback originals, or plugin instructions quoted earlier. The framework does not make all these artifacts public.

Say: “The skills, demonstrations and slides are public.” Recommend the same narrower title in a subsequent content pass. No publication or permissions claim about the underlying originals was verified here.

### M5. Quantities missing from the accuracy guardrails

These empirical, derived, or comparative quantities occur outside the guardrails without an explicit guardrail statement. Some can be inferred from existing entries, but the brief says every spoken number should be listed.

| Location | Quantity or quantitative phrase | What is missing |
|---|---|---|
| Opening | up to an hour, 43 numbered slides, 57:00, three minutes | Deck/timing inventory as a guardrail. The appendix also has numbered slides, so say 43 main slides. |
| 2 | two public repositories | Repository names/URLs in a guardrail, if this self-description is to be audited. |
| 3, 7–8, 13–14 | three parts, three modes, four controls, three on one project and a fourth in supervision | Structural inventory. These are counts of this talk, not research estimates. |
| 4 | “last week” for Kenny | Talk date is recorded, but the relative expression is not. Use 10 September or “eight days ago” only if needed. |
| 9 | “about fifty-five thousand words” | Rounded variant of 54,796. Not a disagreement, but list the permitted rounding. |
| 23 | “two weeks ago” for APSA | Derived from 4 to 18 September. Date appears, permitted relative form does not. |
| 24 | “Five days later” | Derived from gate on 9 September to commit on 14 September. |
| 28 | “Zero hits in the chapter” | The August pass entry names the Bansak finding but does not state the zero or its search terms. |
| 28 | “the last unverified citation” | Implies zero remaining unverified citations. The guardrail names the finding but does not explicitly substantiate completeness. |
| 31 | “Those three are mine” | Read, annotate, dictate: a workflow count that can be checked against the diagram. |
| 32 | “a second later”; “One word repaired” | Log file is named, but latency and the one-word difference are not explicitly recorded in the guardrail. Slide says “about a second”; notes omit “about.” The one-word change is visibly beckon → require. |
| 33 | “one criterion” never machine-marked | Guardrail names Learning Skills, but does not state that exactly one criterion is reserved. |
| 34 heading | “a third shorter” | 89 → 61 is 31.46% shorter, approximately a third. The paragraph counts are listed, the derived proportion is not. The full letter's 596 → 484 is only 18.79% shorter. Clarify that the heading refers to the opening. |
| 34 | “three paragraphs later” | Not stated in the letter guardrail. Requires the full original letter. NOT CHECKED. |
| 36 heading | “Twelve months, eight stages” | Grant dates support twelve months, but this duration and the eight-row inventory are not listed. |
| 38 | “last two snapshots” | 0/107 is listed, but the two snapshot IDs are not. |
| 40 | eleven thousand seven hundred | Not the listed 11,772. See H4. |

Identifiers are not additional empirical claims: slide numbers and cross-references (“slide five,” “Part 2,” “Paper 2”), author-year **Citrin 1997**, and the numbered section headings/timing endpoints. Every heading's timing is audited below rather than given an external source. “One project,” “one number,” “first draft,” “last sentence,” “second sentence,” “one in full,” and “one place” are discourse or artifact pointers. Slide 24's “second sentence” is imprecise: the emphasized sentence is third if the commit's one-sentence subject is counted; say “the bold sentence.”

The two public repository counts, three parts/modes, four controls, three human steps, eight stages, and 43 main slides can be guarded by the deck itself. The timings can be guarded by the timing table. They need no external research source.

### M6. Guardrails with no source file or an incomplete source locator

No empirical bullet is wholly devoid of any reference, but several do not give a source **file for the claim in question**. A stale comparison, directory, commit hash, or generic artifact description is not an independently usable locator.

| Guardrail | Missing or inadequate locator | Required repair |
|---|---|---|
| Repository | 447 commits cites “git log,” not a saved file. 54 session logs cites `logs/`, a directory. | Record the repository/revision, counting commands and saved receipt. `HANDOFF.md` is a file for the handoff count. |
| Dates | The final sentence's 4 September delivery and 9 September first gate/lint dates have no explicit files attached to that sentence. | Point to the talk record and first-run receipts. Other bullets partly supply these, but the mapping is ambiguous. |
| Quoted artifacts | “the files named on each slide” is not a list of source files. Several slides give only a description or abbreviated artifact. | Give one exact path per quote, and a revision for changing files. |
| Knowledge base | The 119/103/15/1 inventory, 103 originals and 126 bibliography entries have no current measurement file. `CLAUDE.md` is cited only to reject its stale 114. `HANDOFF.md` supports historical growth. | Save or name the 16 September inventory receipt. |
| The commit | `563f103` identifies a revision but not its repository/file for the quoted message. `checks/citations.json` is a file for the cache count. | Name the submodule and an inspectable commit-message receipt. |
| Letter | First draft has an exact file. “the sci-edited version” has no filename. | Give the edited file's exact path and paragraph-count method. |
| numbers.tex | Header source is named only as `numbers.tex`, without a path. `HANDOFF.md` dates the 0/107 count but not both compared snapshots. | Name generated file and comparison receipt, with both IDs. |
| Kenny | GitHub repository URL is not the cited deck file. No source file is named for the attributed four-mode adaptation. | Name the local PDF (`~/Desktop/temp/2026-09-10-csdp-ai.pdf`) and relevant pages after verifying them. NOT CHECKED in this review. |

Also make roots explicit for `fast.json`, `fact-check/SKILL.md`, `doc-to-markdown/SKILL.md`, `README.md`, `manuscript/main.tex` and plugin `_shared/*`. These are source filenames, so I do not classify them as absent, but their current relative roots are ambiguous. The excluded-material bullet is an instruction, not an empirical guardrail, and needs no source.

### M7. Timings pass arithmetically but do not describe a full spoken script

All 43 intervals are increasing, adjacent, and non-overlapping. Total **57:00**, leaving **3:00** against the 60-minute maximum. Actual section allocation is open 4:00, Part 1 14:00, Part 2 29:00, Part 3 7:30, close 2:30. The framework budgets 4 / 14 / 30 / 9 / 3, so the notes fit within every section budget.

Whitespace counts below include delivery cues, which makes their effective spoken count even lower. At 100–120 spoken words per minute, the written text alone takes roughly 22–26 minutes. Many slots clearly expect pointing, explaining and pauses. Do not assume reading these paragraphs will produce 57 minutes.

| Slide | Seconds | Words | Words/minute if stretched across slot |
|---|---:|---:|---:|
| 1 | 30 | 30 | 60 |
| 2 | 90 | 46 | 31 |
| 3 | 120 | 52 | 26 |
| 4 | 90 | 62 | 41 |
| 5 | 120 | 83 | 42 |
| 6 | 90 | 71 | 47 |
| 7 | 120 | 93 | 46 |
| 8 | 60 | 49 | 49 |
| 9 | 90 | 53 | 35 |
| 10 | 90 | 62 | 41 |
| 11 | 60 | 72 | 72 |
| 12 | 60 | 64 | 64 |
| 13 | 60 | 44 | 44 |
| 14 | 90 | 69 | 46 |
| 15 | 60 | 66 | 66 |
| 16 | 90 | 67 | 45 |
| 17 | 60 | 55 | 55 |
| 18 | 60 | 33 | 33 |
| 19 | 90 | 70 | 47 |
| 20 | 90 | 70 | 47 |
| 21 | 60 | 61 | 61 |
| 22 | 120 | 69 | 34 |
| 23 | 120 | 72 | 36 |
| 24 | 60 | 55 | 55 |
| 25 | 60 | 57 | 57 |
| 26 | 60 | 45 | 45 |
| 27 | 120 | 100 | 50 |
| 28 | 90 | 76 | 51 |
| 29 | 60 | 47 | 47 |
| 30 | 90 | 102 | 68 |
| 31 | 90 | 58 | 39 |
| 32 | 60 | 32 | 32 |
| 33 | 90 | 82 | 55 |
| 34 | 90 | 75 | 50 |
| 35 | 30 | 5 | 10 |
| 36 | 150 | 189 | 76 |
| 37 | 90 | 58 | 39 |
| 38 | 90 | 58 | 39 |
| 39 | 60 | 50 | 50 |
| 40 | 60 | 36 | 36 |
| 41 | 90 | 54 | 36 |
| 42 | 30 | 3 | 6 |
| 43 | 30 | 20 | 40 |

Most implausibly long **as written**: 2 (46 words/90s), 3 (52/120), 9 (53/90), 18 (33/60), 22 (69/120), 23 (72/120), 31 (58/90), 32 (32/60), 37 (58/90), 38 (58/90), 40 (36/60), 41 (54/90). Artifact slides 22–23 and 38 can use the time if the notes name what to point at. Slide 35's eight-word statement takes only a few seconds, leaving most of its 30 seconds for transition. Slide 42's 26-word statement leaves time to pause. Those are valid holds if deliberate. No section demands an implausibly fast reading speed. Slide 36 has the highest substantive load, eight stages in 150 seconds, so rehearse it even though its 76 wpm is modest. Divider transitions need to fit within neighboring slots, because they have no separate time.

### M8. The novice audience needs a short technical vocabulary

At first occurrence explain **agent** (4 already does this well), **NWO** (14: Dutch research funder), **conjoint** (14: respondents choose between profiles with experimentally varied attributes), **DOI** (15/20: a persistent identifier for a work), **API fees** (9: charges for model use), **Markdown** (16–18: plain text with simple formatting), **git/commit** (14/16: recorded version/change), and **AMCE** (28: average marginal component effect, relative to a specified baseline). “Estimand,” “confirmatory,” “hypothesized sign,” “macro,” “snapshot,” and “guarded key” cluster in 36–38. Give the plain meaning before the technical name. Do not make listeners decode filenames or monospaced verdict labels aloud.

### M9. Slide 28 is too compressed to teach its inference

Notes: “an AMCE is defined over the levels a researcher writes”; then “a baseline value and the randomization distribution”; then “Zero hits.” This jumps between a claim, a technical definition, and a string search. Absence of those words is not by itself evidence of contradiction. Say: “I compared my definition with the chapter's definition. The chapter specifies a baseline and a randomization distribution. I rewrote my sentence to match that definition.” Describe the search as supporting inspection, not a proof. The verbatim chapter and actual original sentence were NOT CHECKED here.

### M10. Privacy and governance are absent from discussion preparation

The notes say unpublished material should not be in training data (6), but give no prepared answer about processing unpublished data or student work with external services. Slides 31–33 invite that question. Prepare an answer naming the actual approved environment, data handling policy and consent requirements used in the example. Those details are not established here. Avoid improvising promises about privacy, retention, training or institutional permission. Keep student material off-screen as already decided.

### M11. The accuracy section makes a universal promise it does not yet meet

Opening: “Every number spoken here is listed at the end with the file it was verified against.” M5–M6 identify exceptions. Replace after repair with: “The guardrails record the figures and their source files.” Until the missing receipts are supplied, do not say all numbers were verified. This report checks internal agreement and locators, not the truth of every underlying statistic.

### M12. The three-mode boundary needs one usable decision example

At 10 “Reading, above all” is protected; at 12 the researcher reads collaboratively; at 41 students may collaborate only where they can check. These can coexist, but “I have done the reading” is not a transferable rule for a new topic. Prepare: “If I cannot assess a summary, I read the source first. If I can assess it, I may use the model to locate or compare passages.” This uses the same source-library example and adds no new artifact or fourth mode.

## Low findings: quoted delivery edits

The following is the complete set of additional lines I would change for delivery. H/M replacements above are not counted again. Line wrapping has been normalized in quotations. Suggested speech deliberately follows the brief's first-person, short-sentence standard rather than the prose skill's general preference for impersonal academic writing. Author uncertainty is retained where the framework explicitly makes it part of the discussion.

| ID | Slide | Current wording | Proposed change |
|---|---|---|---|
| L1 | 1 | “One sentence on the shape: a way of thinking first, then the tools I actually use, then one project from grant to conference talk.” | Cue: “Explain the order of the talk.” Spoken: “I will explain how I decide where to use AI. Then I will show the tools and a project.” |
| L2 | 3 | “The subject is the research pipeline.” | “I will follow the steps of a research project.” Keep the visible pipeline as the organizing diagram, without repeatedly invoking the metaphor. |
| L3 | 3 | “we run it ourselves, and the question of where AI belongs in it is the same question from two sides.” | “We also do this work ourselves. In each role, we need to decide where AI helps.” |
| L4 | 4 | “It reads your files, runs a command, sees what came back, and decides the next step, and it loops until the task is done or you stop it.” | “It can read files and run commands. It uses the results to choose its next action. It repeats this until the task is done or I stop it.” |
| L5 | 4 | “That loop was built for programmers. Christopher Kenny drew it this way last week at Princeton and I am borrowing it.” | “This diagram comes from Christopher Kenny's talk at Princeton on 10 September.” Keep the attribution. Avoid “borrowing” and an unnecessary relative date. |
| L6 | 5 | “This is the mechanism behind everything else.” | Cut. Start with the qualified test explanation in H6. |
| L7 | 5 | “A research claim has no compiler. Nothing errors.” | “A false research claim may produce no automatic warning.” The displayed compiler analogy can remain, but explain its meaning literally. |
| L8 | 6 | “Errors are silent and they compound: a bad transcription becomes a bad count becomes a claim becomes someone's citation of your claim.” | “A transcription error can change a count. I may then write a false claim that someone else cites.” |
| L9 | 6 | “Checking often needs the very skill you were handing over: you cannot tell whether a summary of Brubaker is right unless you have read Brubaker.” | “I need knowledge of the source to assess a summary. I cannot check a summary of Brubaker without reading the relevant work.” No need to explain the proper name's scholarly significance. |
| L10 | 6 | “And the inputs are not in the training data and should not be: your archive, your unpublished data, a scanned textbook nobody has transcribed.” | “My archive and unpublished data may not be in the model's training material. The model needs access to the sources for this task.” The original cannot establish universal training-data absence, especially for published scans. |
| L11 | 7 | “The framework, plainly.” / “The sentence underneath is the whole talk” / “Protection is the principle. Sandboxing is how you do it.” | Cut the first and last. Introduce the governing sentence with “This is the question I use.” “Sandboxing” adds a new technical metaphor without explaining a concrete practice. |
| L12 | 12 | “The same pipeline stage sits in different modes depending on who is standing at it.” | “The same task can require different AI use, depending on what the person needs to learn.” |
| L13 | 12 | “Many of you are both, since graduate students teach, so you sit on both sides of one decision.” | “Many of you both study and teach. You will make this decision in both roles.” |
| L14 | 8 | “Now tie the three modes to slide five.” / “Collaborate where you can build the check that research never had.” | Cue: “Connect the modes to the testing example.” Spoken: “I collaborate when I can specify how to check the output.” |
| L15 | 9 | “Cognitive offloading is good.” / “Chores and admin.” | “I use AI for routine tasks that do not need my attention.” Preserve “aggressively and shamelessly” as the framework's deliberate stance. |
| L16 | 10 | “Where I am sure: grading, maybe all of it.” | “I protect grading. I am still deciding whether any part should use AI.” This removes the contradiction between “sure” and “maybe” without inventing certainty. |
| L17 | 10 | “writing before the final draft, and the seeds of ideas.” / “I have written those two with question marks in my own notebook and I am leaving them that way.” | “I am still deciding how to use AI in early drafts and when developing an initial idea. I would like to discuss those choices.” |
| L18 | 11 | “I can waive it, and I know what I gave up.” / “A preference becomes an obligation.” | “I can choose how to develop my own skills. As a teacher, I must preserve students' opportunities to learn.” Do not imply that foregone learning is always fully known. |
| L19 | 13 | “The common category from my notes: research scaffolding and knowledge bases, bibliometrics and formatting, data collection through visualization, ideation and quality assurance, supervision.” / “The rest of the talk is four controls, built. Three of them on one project, the fourth at the supervision desk.” | “I use AI to organize sources, check references and help with research tasks. I will show four controls. Three come from one research project. The fourth supports my thesis supervision.” |
| L20 | 15 | “Forty-one of them in the library.” / “what it will not do: it marks whatever it did not check as not checked.” | “The library has forty-one skills for Claude Code. This skill must report what it did not check.” This makes the platform-specific count explicit. |
| L21 | 16 | “The source library is the spine and everything else grows from it.” / “Without this, the later checks cannot run.” | “The later checks need these source files.” |
| L22 | 17 | “A hundred and nineteen Markdown files, a hundred and three of them verbatim conversions, fifteen notes for works we do not hold.” | “There are 119 Markdown files. Of these, 103 contain converted source text, 15 are notes, and one is their index.” The current notes omit the index shown on the slide, leaving listeners to reconcile the sum. |
| L23 | 18 | “That is the whole trick behind a grounded check: the model reads the file, not its memory.” | “For this check, the model reads the source file.” |
| L24 | 19 | “none with nothing. That last clause is the standard.” | “Every cited work has either source text or a clearly marked note. A note still cannot verify a claim.” This prevents completeness of cataloguing from sounding like complete evidence coverage. |
| L25 | 20 | “One rule to take home: never treat a DOI that resolves as a DOI that is correct.” / “A live DOI pointing at a different real paper is the classic fabrication signature.” | “I check that the DOI identifies the cited work. A working DOI can point to a different paper.” Wrong DOI metadata alone does not establish fabrication. |
| L26 | 21 | “Its whole vocabulary.” / “the gate strips the agent out.” | “These are its reference-check labels.” / “The next example runs as a script without a model.” “NOT CHECKED” is also in the lede, so “whole” is unnecessary. |
| L27 | 22 | “That entry had survived in my working bibliography until a systematic pass.” | “I found that entry when I checked the bibliography systematically.” |
| L28 | 23 | “Exit code one, so the commit is blocked.” | “Exit code one means the check failed. With the commit check installed, it prevents the commit.” Explain the condition rather than assuming everyone understands the hook. |
| L29 | 24 | “Five days later this commit landed in the paper's bibliography.” / “Read the second sentence” / “The check changed what I did, not just what I knew.” | “Five days later I added the reference to the paper's bibliography. Read the bold sentence.” Cut the last sentence. The concrete action already makes the point. |
| L30 | 25 | “A check that runs around a hole gives false reassurance, which is worse than no check.” | “I need the source files to assess the claims. Missing files must be reported.” |
| L31 | 26 | “the rule that makes the verdicts mean something” | “A support or contradiction verdict must include a source quote.” |
| L32 | 27 | “In August every claim in Paper 2 was checked against the source text where we hold it, not the citation.” | “In August I checked Paper 2's claims against the available source text.” Explicitly keep the following sentence about notes being unverifiable. |
| L33 | 28 | “One in full, because the shape matters.” / “The fix: rewrite the sentence to what the chapter says.” | “Here is one finding and the resulting revision. I rewrote my sentence to match the chapter's definition.” |
| L34 | 29 | “The claim runs backwards” / “Formatting-clean is not the same as true.” | “The claim contradicts the supplied text.” / “A correctly formatted reference can still support a false claim.” Use H1's synthetic-example qualification too. |
| L35 | 30 | “One place the control failed, on my own deck, and I want to show it rather than hide it.” / “A check is only as wide as its scan, and you have to know where the edges are.” | “Here is a failure in the check on my own slides.” / “The script can only check the fields it reads.” |
| L36 | 31 | “Those three are mine.” / “The judgment stays with the supervisor. The machinery around the judgment is automated.” | “I do those three tasks myself. I make the judgment and review the final letter. The model helps organize, check and format it.” |
| L37 | 32 | “the cleaned text a second later on the right.” / “Nothing rewritten. The words are still mine.” | “The cleaned text is on the right, about a second later.” / “The model replaced one word. I kept the rest.” The slide shows “about,” and a repair is still an edit. |
| L38 | 33 | “Five readers in parallel, one per assessment criterion, each writing findings with a page anchor.” / “A hard cap of 900 words.” / “That one is mine alone.” | “Five model agents review different assessment criteria. Each finding must name a page. The letter has a 900-word limit. I alone assess the student's learning process.” |
| L39 | 34 | “so no student is on the screen.” / “The evaluative adverbs are gone” / “The letter's judgment is unchanged. Its shape is not.” | “This example contains no student material.” / “The revision removes some evaluative language.” / “The revision states the criticism earlier.” “Compelling,” “persuasive,” “memorable,” “accessible” and “consequential” are adjectives, so the adverb-only account is inaccurate. The full letter's unchanged judgment is NOT CHECKED here. |
| L40 | 36 | “Design and the pre-analysis plan: adversarial reviews and bibliography audits by the machine, every design decision by me and logged.” / “Fielding, first response 11 August to close on 31 August: quota grids and publish gating by the machine, vendor letters and quota rulings by me.” / “Analysis: figures, the numbers file, and the runs by the machine, the estimand and the decision rule by me, handed over without the hypothesized sign.” / “Writing: prose passes and pre-submission review by the machine, every word and every push by me.” / “The talk on 4 September: the deck build by the machine, the notes and the order by me, and the gate and the lint ran on 9 September, after delivery, and found what they found.” | Split each row into two sentences. “The model reviewed the design and checked references. I made and recorded each design decision.” “Responses ran from 11 to 31 August. The model helped track quotas. I dealt with the vendor and decided quota changes.” “I specified the effect to estimate and the decision rule. I withheld the expected direction. The model ran the analysis and generated figures and numbers.” “The model suggested edits and reviewed the draft. I approved the wording and each upload.” “The model built the slides for 4 September. I chose the order and notes. The automated check and model review ran on 9 September, after delivery.” |
| L41 | 37 | “the agent gets the estimand and the decision rule, not the direction I hope for, so it cannot quietly search for the specification that pleases me.” / “Never push to Overleaf without my say-so.” | “I give the agent the effect to estimate and the decision rule. I withhold my expected direction to reduce the risk of choosing an analysis to suit it.” / “The agent must ask before uploading changes to Overleaf.” Withholding direction reduces a risk, not an absolute guarantee against specification searching. |
| L42 | 38–40 | “Every result number in the paper resolves through a macro to a generated file, pinned to one data snapshot with a timestamp.” / “none of 107 guarded keys moved” / “That sentence is the point of the whole architecture. The checks exist so that I can sign it.” / “The machinery was automated.” | “The manuscript inserts result numbers from a generated file. That file names the data version used.” / “None of the 107 tracked results changed its decision between the two versions.” / “I review the work and remain responsible for it.” / “I automated routine work.” Confirm that “changed its decision” matches the actual guard's comparison, since the present notes could mean no numeric value changed. |
| L43 | 41 | “Students: automate the clerical; protect reading, first ideas, and the procedures you are still learning; collaborate only where you can check the output yourself. Professors: automate more of your own machinery and leave a trace; protect the formation of your students' judgment; collaborate where the machine changes what is feasible.” | “As students, automate routine administration. Protect the work through which you learn to read, develop ideas and use methods. Use AI collaboratively when you can check its output. As professors, automate routine work and keep a record. Protect students' opportunities to develop judgment. Use AI where it makes useful research possible.” These are the **four semicolons in the spoken sections**. Remove all four. |

No em dashes occur in the spoken sections. The guardrail list contains semicolons as separators, but it is not speech. Preserve the governing sentence and mode names even though the sentence is longer than the preferred delivery style. It is the argument of record, not an incidental stylistic flourish. Slides 35 and 42 are delivery cues to read their displayed statements; they are not missing spoken paragraphs.

## Slide/notes agreement ledger

All 43 main sections were compared. Hard differences or scope mismatches are H1–H5, M1, M4, L22, L29, L37, L39 and L42. Slide 36 says “wording, and every push,” whereas the notes' “every word ... by me” overstates authorship in a workflow that includes model prose passes; L40 proposes “approved.” Slide 21's “whole vocabulary” omits the slide's NOT CHECKED qualifier; L26 repairs it. The slide/notes source-library figures agree with each other but supersede the framework's earlier 157 conversions and 83 bibliography entries. Do not restore those stale figures. Likewise the framework's “zero fabrications” and slide 22's invented entry may distinguish nonexistent works from invented metadata. Explain that distinction if asked rather than equating the two.

Other sections agree in substance. Not every displayed datum needs to be spoken. In particular, 54,796 → “about fifty-five thousand” at 9 is an acceptable marked approximation; the country counts and 360 design cells omitted in the spoken paragraph at 14 are not contradictions; the source-file header at 18 need not be read out; the date, version and count labels in artifacts can remain visual. The appendix has no corresponding speaker-note sections, which is appropriate for unplanned discussion, but do not count appendix material inside the 57-minute script.

Post-layout title changes at 9, 16 and 44 have the same meaning. The notes headings retain their original wording because rewriting notes was prohibited. Layout edits shortened supporting text without resolving the substantive content issues above.

## Likely opening discussion questions

| Likely question | Preparation in current notes | What to prepare |
|---|---|---|
| “How do students learn enough to check AI, and when can they start using it?” | Partial. Slides 10–12 and 41 state the boundary but do not demonstrate a progression. | Use the same reading task: read a source unaided, compare a model summary with it, then use the model to locate passages while checking them. Explain what evidence of competence you require. |
| “Why should I trust a model checking another model, especially after your gate missed a citation?” | Strongest preparation. Slides 19, 25–30 and the supervision quote check distinguish missing evidence, grounded judgments and scan coverage. | Explain that a verbatim quote can still be selectively interpreted. Describe the human review and what remains NOT CHECKED. Resolve H1–H2 first. |
| “Can I use this with unpublished or student material under our university's rules?” | Weak. A sentence on training data is not an answer about processing or governance. | Prepare the concrete institutional and service conditions actually used. Do not imply that a source on local disk necessarily stays local when an agent reads it. No excluded student material is needed. |
| “What would I install first, and how much time and money does this save?” | Partial. The public links, 41/40 skills and $8 dictation example help. The 447 commits and 54 sessions demonstrate effort, not measured savings. | Describe one small source-and-claim check a beginner can repeat. Distinguish dictation's observed API cost from the unmeasured cost of the whole research workflow. Say that these records do not establish a net productivity gain. |

## Deck changes and validation

**Ivory and Chestnut**: Page `#FCF8F0`, Ink `#302A23`, Muted `#5E5345`, Structure `#75452F`, Emphasis `#4D5C32`, Pass `#346044`, Partial `#725010`, Fail `#913329`, Box `#F0E6D6`, Divider `#E8D8BE`. Fonts unchanged. Ten named colors. Mode tints derive from partial, fail and emphasis colors, respectively, and remain distinguished by text labels as well as hue.

The preamble contains an sRGB contrast table covering all seven text roles on all six backgrounds, including the three mode tints. Every tested pair exceeds 4.5:1. This is a numerical sRGB check, not a simulated guarantee about a particular Zoom connection.

All titled slides share the title inset and title-to-content spacing. The lede macro now supplies a single consistent gap without the extra list spacing introduced by flushleft. All 52 pages received the palette change. All 45 titled frames received the title/alignment treatment. Statements and divider layouts retain their existing form.

Targeted changes beyond that global treatment: **3–4, 6–14, 16–17, 20, 23, 26–29, 31–34, 36, 40, 43–44, 46–48**. These include shorter single-line titles, removal of excessive gaps, a booktabs frame for the mode grid, shorter ledes and table cells, separation of the Bansak source definition and search result into two rows of the same table, more diagram-node padding, tighter table row spacing, reference wrapping, and the letter comparison's increase from 9 to 9.3 pt. Exact source quotations in the letters, code artifacts and disclosure were retained. No credit had to be moved into the notes.

No slide, overlay, research number, font family or ordering was added or removed. Build output remains 52 pages: 43 main slides, 3 section dividers, appendix divider, 5 appendix content slides. Generated `overleaf/main.pdf` is rebuilt locally; it is ignored by the submodule as before. The published `docs/.../slides.pdf` was left untouched, so the existing public QR destination still serves the previous deck. Publishing is outside this local-only brief.

Final validation: XeLaTeX build succeeded with zero overfull boxes. One underfull box remains in the three-panel slide and was visually inspected. All 52 pages were rendered at 80 dpi and inspected. A numeric-token comparison of all six part files, excluding layout dimensions and comments, found no added or removed numeric values. `git diff --check` passed. Minimum contrast across the complete table is 4.60:1.
