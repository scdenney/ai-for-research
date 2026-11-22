# Speaker notes – What Are We Thinking? AI in Research and Supervision

Leiden University, Wednesday 21 October 2026, 15:00–17:00, DH Lab, Huizinga 0.09. Moderator: Aron van de Pol. In person.

The compiled deck has **42 PDF pages**: 38 main pages, an appendix divider (39), and three reference pages (40–42). Headings use physical PDF pages, and since the third review round the printed footer number is the same number.

**Session plan.** Clock times in the per-page headings run from 15:00 (00:00). These are speaking allocations, not a measured rehearsal.

| Clock | Time | What |
|---|---|---|
| 00:00–03:00 | 15:00–15:03 | People arrive. Page 2 (survey QR) on screen |
| 03:00–10:00 | 15:03–15:10 | Welcome and the published surveys, pages 3–6 |
| 10:00–55:00 | 15:10–15:55 | Pages 7–38, including the knowledge-base slides on pages 22–34 (about 12 minutes) and the live demo on pages 35–36 (about 8 minutes) |
| 55:00–57:00 | 15:55–15:57 | Page 38 on screen while the results export runs in the second terminal. No break |
| 57:00–115:00 | 15:57–16:55 | Discussion from `results.pdf` |
| 120:00 | 17:00 | End |

**Changes on 21 October (two review rounds).** The cover is centered. The roadmap's fourth item is "Discussion". Page 2 reads "Anonymous survey" with a clickable link. Page 4 adds science, technology and medicine in light blue, with humanities in deep blue; page 5 adds economics and computing. Page 6 is "We are behind". "Five terms" (page 7) adds the CLI. The three modes (page 9) are redefined. Every row table is set on even bands with label and text centered. Two new Collaborate pages, "What collaboration means" (19) and "Where the gains are" (20), precede "Working together" (21). "From an LLM wiki" is split into Karpathy (26) and "The agent works from what I collected" (27). The check (30) is two plain columns with a callout. The demo background (36) states the topic, the four planted errors, and the agent's job. "Your answers" (37) is one line; there is no break, and the results export runs while page 38 is up. Third round: footer numbers equal PDF pages; the Automate divider is "Willingly offload"; the morning-brief row leaves "Examples"; "What we're protecting", "Offloading hurts durable learning", "Practicing with AI and taking an exam without it", "Experts are in a position to gain"; "Why collaborate" (19) has three gains; "Working together to verify" (21); the chatbot pages are "Asking a chatbot"; Karpathy (26) gets two more sentences and an inline citation; "The knowledge base idea" (27) has four moves; the check (30) is two rows; "How to manage your knowledge base" (32); the demo background names the draft; "Your answers" (37) asks two questions. Fifth round: dividers count but print no number; Karpathy row labels match the text size; "Knowledge base scaffolding" (28) with arrows and labels centered between boxes; the check (30) repeats the claim and the quotes; the demo background (35) now precedes the divider (36) and says plainly what the draft is about. Fourth round: slide 19 loses its callout; the Karpathy page is four rows; the anatomy page (28) now precedes intake (29); page 15 and the footers of 16–17 name the models used (GPT-3.5 for Melumad & Yun's Experiment 1, ChatGPT-4o for Fernandes, GPT-4 for Bassner and Bastani, GPT-4o for Shen & Tamkin, an unnamed Google Labs tool for Autor).

**Results commands** (second terminal, already open in the lecture folder; run them when page 37 comes up):

```
cd survey && python3 export-responses.py && python3 results.py && open results.pdf
```

**Before 15:00, set up the demo.** Open a terminal in `~/kb-demo` (already scaffolded) and start Claude Code. The checklist and the commands are in `demo-runsheet.md`. The demo needs a network connection. The fallback is the rehearsed state in `~/kb-demo-done`.

## 1. What Are We Thinking? AI in Research and Supervision
**00:00–00:00 · 00:00 · PDF page 1**

The cover is on screen while you set up, before 15:00. At 15:00, go to page 2 and leave the QR up while people find seats. No speaking budget.

## 2. Before we start
**00:00–03:00 · 03:00 · PDF page 2**

As people sit down, invite them to scan the code. The survey is on Leiden's Qualtrics, takes about three minutes, collects no names or e-mail addresses, and the answers are deleted after the seminar. The link is printed under the code, and the slides are on my website before we begin, so anyone with a laptop can open it there. Seven questions use the wording of published surveys. The slide says we review the answers at the end, and that happens straight after the talk. Remind people to press the arrow at the end to submit. Do not promise Leiden figures, because none have been published.

## 3. This afternoon
**03:00–04:30 · 01:30 · PDF page 3**

Thank Aron and the DH Lab, then welcome the room. Name the four parts: what the surveys say, the three modes, a research knowledge base with a short live demo, and then, with no break, the room's answers and a discussion. Say that the second hour is mostly theirs. If latecomers want the survey, go back to page 2 for a moment.

## 4. How often researchers use AI
**04:30–07:00 · 02:30 · PDF page 4**

OUP surveyed 2,606 researchers in April 2026. Arts and humanities researchers are the most likely to say never, 35% against 18% in the social sciences. Social scientists are the most likely to say frequently, 36% against 18%. Science, technology and medicine, OUP's third group, sits with the social sciences: 35% frequently and 15% never. OUP publishes no finer split by discipline. Say aloud that Wiley reports 84% of researchers used AI tools in 2025, up from 57% in 2024, though only in a press release. Elsevier's *Researcher of the Future* (2025) found the Netherlands lowest of all countries on "AI will drive new knowledge", 29% against 61% worldwide.

## 5. Who has used AI to edit a draft
**07:00–08:30 · 01:30 · PDF page 5**

Nature surveyed 5,229 researchers in February and March 2025. Overall, 29% had written a draft and then used AI to help edit it. The share is 25% in the humanities and 38% in the social sciences. Economics (40%, n = 149) and computing (37%, n = 411) are the highest fields. The Netherlands is at 39%, the United States at 24% (n = 933), and PhD students at 42%. Each bar now shows its group's n, and the Netherlands bar rests on 59 people. The footer gives the sampling: authors, a publisher panel, and newsletter readers, with fields that could overlap, so this is not a random sample of researchers.

*Comparison caveat:* the room's version of this item drops Nature's lead-in "Have you done this yourself? That is:" and adds "I don't do academic research", so read the room-versus-Nature gap as indicative. *If asked* why the slide says 29% when the article prints 18% and 10%: the groups were computed from Nature's published microdata, by the field each person ticked, rounded half up. The combined yes share is 28.7%. People could tick more than one field. Counting only those who ticked humanities alone gives 19% (n = 96), and the direction of the comparison is the same.

## 6. We are behind
**08:30–10:00 · 01:30 · PDF page 6**

The title is the point: we are behind. In the SGSSS survey of 308 UK social-science PhD students, 77% had used AI, and 20% had ever openly talked about it with their supervisors. In the EUA survey, 23% of 217 European universities do not know how their PhD candidates use AI. OUP found that 74% of researchers find the disclosure rules unclear, and 46% of journal authors do not fully disclose. Say aloud that 65% of PhD students in the Nature Graduate Survey worry that AI weakens their skills, in a survey of STEM and health only. These are different populations, so do not add them up or read them as a trend.

*If asked:* the SGSSS 20% was coded from an open question, so it does not compare directly with the closed question the room answered. The AAC&U and Elon survey found that 90% of US faculty expect weaker critical thinking among students, with a differently worded question.

## 7. Five terms
**10:00–12:00 · 02:00 · PDF page 7**

Five terms come up all afternoon. An LLM, a large language model, is trained on large amounts of text and produces text by predicting what comes next. A chatbot is an app for talking with one, such as ChatGPT or Claude. An agent is an LLM given tools and a goal: it opens files, runs code, and works in steps until the task is done. The CLI, the "terminal", is a text window where you type commands; Claude Code runs there, and that is what you will see in the demo. A skill is a set of written instructions an agent follows for a task that comes up again.

## 8. Automate, guard, collaborate
**12:00–12:30 · 00:30 · PDF page 8**

The framework has three ways to work with AI, for research and for supervision. They are choices about where human thinking matters. They are not a ladder with collaboration at the top.

## 9. Three modes
**12:30–15:00 · 02:30 · PDF page 9**

Define each mode. Automate is the work we want to offload to AI. Guard is the work we keep away from AI, to protect durable learning and core skills. Collaborate is the work we do with AI to increase productivity, do better work, and do things we otherwise could not. The same task can move between modes when its purpose changes.

## 10. Willingly offload
**15:00–15:15 · 00:15 · PDF page 10**

Divider for Automate: work we willingly offload. The goal is time and attention for the work that matters.

## 11. Examples
**15:15–17:15 · 02:00 · PDF page 11**

These are my own examples. An agent reads my email, triages it, flags what is due, and summarizes the inbox. An agent on the calendar reviews the schedule and stays on standby, and I can ask it "When am I free? Am I missing anything?" It also tracks tasks and deadlines, names and sorts files, and formats references.

## 12. My morning brief
**17:15–19:15 · 02:00 · PDF page 12**

This is a simplified version of my real brief, in its colors. Each morning I get one page: today's schedule, the deadlines coming up, and a summary of the inbox after the overnight sort. The real one also has priorities, tomorrow's schedule, and what is waiting on other people. The entries here are invented. Say the risks aloud. The agent can mis-triage a message or miss something, so I still look at what matters, and everything it reads, including email content, goes to the model provider.

## 13. Protect core skills
**19:15–19:30 · 00:15 · PDF page 13**

Divider for Guard. The goal is durable learning.

## 14. What we're protecting
**19:30–21:30 · 02:00 · PDF page 14**

Guard writing, reading, and judging evidence for ourselves first. We keep these skills only by using them. Guard them most of all for our students. Core skills are learned by doing the work, and they will be scarce in an age of AI. The reason to guard them is that cognitive offloading can cost learning, and the next three pages show the evidence.

## 15. Offloading hurts durable learning
**21:30–25:30 · 04:00 · PDF page 15**

Read the table one row at a time: who was studied, what was compared, and what was found. Melumad and Yun compared learning from a chatbot with web search in 10,462 adults across seven experiments; the figure on the slide is Experiment 1, which ran GPT-3.5-turbo behind a ChatGPT-style interface against real Google results, and the chatbot group reported learning less deeply, 3.43 against 3.86 on a 1–5 scale. Fernandes and colleagues had 246 adults solve logic problems with ChatGPT-4o, and they scored three points above a norm group but overestimated their own score by four: they thought they had done better than they had. Bassner and colleagues compared 275 students coding with GPT-4, either as a hint-first tutor (Iris) or as unrestricted ChatGPT, or without AI, and the AI groups had higher exercise scores but no greater gain in knowledge or code comprehension. Shen and Tamkin, a preprint by Anthropic authors, found that 52 programmers learning a new code library with a GPT-4o assistant scored 17% lower on a later quiz without it. Say the models aloud: which model was used matters for what the results mean.

*If asked:* the Melumad and Yun figure is self-reported and does not test retention, and their Experiment 2 gives 3.71 against 3.96. Fernandes also found that higher AI literacy went with less accurate self-assessment, and a second study of 452 people replicated the result. Shen and Tamkin found no clear time saving.

## 16. Practicing with AI and taking an exam without it
**25:30–27:45 · 02:15 · PDF page 16**

Bastani and colleagues studied high school math in Turkey. The slide no longer prints the setting, so say it. Both tutors were built on OpenAI GPT-4, as the footer now says. AI raised practice scores in both versions. No takeaway is printed, so say it. On the exam without AI, students who practiced with unrestricted GPT Base scored 5.4 points below the control group. The guided GPT Tutor came out at about zero, so it avoided the harm and produced no gain.

## 17. Experts are in a position to gain
**27:45–30:00 · 02:15 · PDF page 17**

Autor and colleagues followed patent lawyers who drafted with AI for about three months. The tool was an unreleased Google Labs writing assistant, and the paper does not name the model behind it, so do not call it Gemini; Gemini appears in the paper only as the rater. Say the takeaway aloud. Both junior and senior lawyers drafted better with AI. At the later review without AI, only the seniors improved. For juniors the effect is unclear, so do not call it a decline, and experience was not randomized.

## 18. Working with the machine
**30:00–30:15 · 00:15 · PDF page 18**

Divider for Collaborate. I set the question and judge the answer. The agent does legwork I can check.

## 19. Why collaborate
**30:15–30:55 · 00:40 · PDF page 19**

Three kinds of gain. Productivity: more done in the same time. Quality: the same work done, but better, and with a supercomputer as fact checker. Reach: work we could otherwise not do, in more languages, across more sources, at greater scale. Say aloud what the slide no longer prints: we set the task and check the result, and which tasks belong here is the open question the rest of the talk works on. The next page names where the gains are, and the knowledge base is the worked example.

## 20. Where the gains are
**30:55–31:40 · 00:45 · PDF page 20**

Five places where the gains are, from my own work and what I see around me. Sources: finding, gathering, and organizing new material, in any language. Digitization: OCR turns scans and archives into searchable text. Scale: text and image analysis across whole collections. New data: collecting new types of data, with staff and students. Verification: an expert fact checker and source manager, which is the demo. Say the footer: these are now within reach for the humanities and social sciences.

## 21. Working together to verify
**31:40–32:15 · 00:35 · PDF page 21**

Read across the three rows: what the agents do, and what we do. Agents, plural: the demo uses more than one. For sources, the agent files and converts them, and I choose what belongs. For citations, it checks each reference, and I confirm every flag. For claims, the agent finds the passages, and I judge whether they support the claim. The next pages follow one claim through that last row.

## The knowledge-base sequence (pages 22–34) and the demo (pages 35–36)

These are ordinary slides. Narrate them in the first person. Budget about 12 minutes, from "A sentence from my draft" through "Build your own", then about 8 minutes of live demo. Spend the most time on the check (pages 30–31). The message is that a knowledge base plus skills is a responsible way to use agentic AI, and it improves the quality of research. It gives exact citations, claims checked against the text, and a record of the work.

## 22. A sentence from my draft
**32:15–33:15 · 01:00 · PDF page 22**

This is a sentence from my own draft, and it cites two published studies. Read the plain-words line: people support a policy less when a president makes it alone than when Congress passes it. The archived wording had "similarly", and the slide drops it for clarity. Two questions on the callout: do these two studies support the claim, and do they even exist? Ask the room what the sources would need to show, and do not answer yet.

## 23. Using ChatGPT
**33:15–34:00 · 00:45 · PDF page 23**

First I ask a chatbot on its own whether the two studies support the sentence. The answer is fluent and confident, and it agrees with me. It gives no quotation and no page, so there is nothing to check. The exchange is a labeled illustration and not a transcript.

## 24. The next week, starting again
**34:00–34:30 · 00:30 · PDF page 24**

The next week I ask which sources we checked. The chatbot has no access to the earlier conversation. Every session starts from zero.

## 25. A research knowledge base
**34:30–34:45 · 00:15 · PDF page 25**

Divider. This is collaboration in practice: how agents work with my research projects.

## 26. Karpathy's LLM wiki
**34:45–35:30 · 00:45 · PDF page 26**

Andrej Karpathy's LLM wiki (a GitHub gist, 4 April 2026), in four rows. Sources: all the raw sources in one folder, never changed. Wiki: the model writes a summary of each source and pages for the people, places, and ideas that recur, with an index and a log. Answers: a question's answer is written back into the wiki. Accumulation: the next question starts from there. Read his quote and name him: the model is otherwise "rediscovering knowledge from scratch on every question."

## 27. The knowledge base idea
**35:30–36:15 · 00:45 · PDF page 27**

The transition to my version: how I assemble it. Pause here: the point is an agent working from material I have gathered and vetted, in one project folder, not from the open web. Four moves: I keep the originals; I create searchable text copies; I generate bibliographic entries; I bolt on additional skills. The callout: this serves as the basis of my agent-based work.

## 28. Knowledge base scaffolding
**36:15–37:00 · 00:45 · PDF page 28**

This is the knowledge base itself. The project holds originals, searchable copies, one bibliography, my draft, and a file of instructions the agent reads every time. Say that I write in LaTeX, so the draft is `manuscript/main.tex` and the citation keys on the right are LaTeX `\cite` commands. Each citation leads from my draft to the bibliography, to the searchable copy, and back to the original PDF. If a link breaks, the citation cannot be checked. A converted copy can lose a table's structure, so I check it against the original when it matters.

## 29. How to incorporate a source in five steps
**37:00–38:00 · 01:00 · PDF page 29**

The page shows one source as the example; every source goes through the same five steps. I drop a file into a folder. The agent identifies the author, year, and title, and renames the file. It converts it to a searchable copy and registers an entry in my bibliography. A scan needs text recognition first, and the original always stays untouched. The sources in this example are invented, and the conversion problems are real.

## 30. Evaluating the question from before
**38:00–40:00 · 02:00 · PDF page 30**

Now I ask the same question inside the knowledge base, and the agent quotes the searchable copies. The top line repeats the claim, because the room will not remember it from page 22. Then one row per study: the quoted passage from the searchable copy on the left, and in red what it does not show. Say aloud that each answer comes with the quoted passage; the slide no longer has a footnote for it. Reeves and Rogowski report that only about a quarter of respondents supported unilateral policymaking. They do not compare the two routes. Christenson and Kriner do compare them, and the route "has no significant influence on the probability of a subject backing the president." Neither study shows a penalty, so my sentence is unsupported as written.

## 31. I decide what to write
**40:00–41:15 · 01:15 · PDF page 31**

The agent shows me the evidence, and I write the sentence. Read the after version aloud. I revised it by hand on 27 August 2026, and the check ran on 16 September on the archived wording and reached the same verdict. So the tool did not cause the revision, and one example does not test how well agents catch citation errors. A nonsignificant estimate also does not show that the two routes are equivalent.

## 32. How to manage your knowledge base
**41:15–42:00 · 00:45 · PDF page 32**

At the end of a session the agent writes things down. A handoff note says where I am and what comes next, and a session log records what was done. Two skills do this: `/oss:finished` writes the note and the log when a session ends, and `/oss:sitrep` reads them when the next one starts. The version history is Git, which records each change you commit, with a short note on why; GitHub keeps a copy online. Say that committing is a step you take on purpose, or ask the agent to take, usually at the end of a session. Give the recommendation in the last line: Git for every project, with a private copy on GitHub, so nothing you commit is lost and you can see what the agent changed. The next session, or the next supervision meeting, starts from there. Compare page 24, where every session started from zero.

## 33. Skills: procedures the agent follows
**42:00–43:00 · 01:00 · PDF page 33**

A skill is a written procedure the agent follows the same way every time. These are four examples, and there are others. `research-repo` sets up the library and its rules, and `process-source` files away new sources. `citation-check` asks whether each reference exists and matches its record, and `fact-check` asks whether the source says what I claim.

## 34. Build your own
**43:00–44:30 · 01:30 · PDF page 34**

Walk the five steps briefly. Install Claude Code, an agent that runs in the terminal on your own computer, and the Open Science Skills, then run `/oss:research-repo` in an empty project folder, which also starts Git. Add a paper, run `/process-source`, and check the copy. Run `/oss:citation-check` and `/oss:fact-check` on a draft, end with `/oss:finished`, and start the next session with `/oss:sitrep`. Say that you will now do steps 2, 3, and 5 live, and that the walk-through link has practice files for every step.

## 35. What you are about to see
**44:30–45:30 · 01:00 · PDF page 35**

Background before the terminal. The slide says only: I prepared a draft about Koreans in Japan in 1946. Say the rest: many went home to Korea and some came back; cholera broke out in Korea; and the occupation authorities ordered ships entering Japan illegally to be stopped. Say that all three sources are real. SCAP is spelled out on the slide as the Supreme Commander for the Allied Powers, the US-led occupation authority. The three sources are real: Kim 2021 in Korean, Morris-Suzuki 2011 in English, and a scanned SCAP directive from June 1946; they still carry their download names. The draft is yours, and you planted four errors in it: a reversed claim, a mistranslation, an unsupported claim, and a reference that does not exist. The agent files the sources into the knowledge base, then checks every reference and every cited claim. Point to the last row: the SCAP page has no text layer, the Korean article has to become searchable, and the question is whether it catches all four. The footer says the same setup serves any research that rests on sources you hold copies of.

## 36. Live demonstration
**45:30 · divider · PDF page 36**

Divider. The URL of the click-through demo is on the slide; switch to its browser tab and press F.

### The demo, on the terminal
**45:30–52:30 · 07:00**

Follow `demo-runsheet.md`. The primary demo is now the click-through page at scdenney.github.io/ai-for-research/archive-check (press F to present, → to step), which replays a recorded run from 21 October: the agent's intake, GLM-OCR run locally on the scan, the agent's check and correction of the OCR text against the scan, and the claim check on the corrected text. Say it is a recorded run. On the OCR step, point out that GLM-OCR reads the body cleanly but drops the header and the pencil note, that the agent finds and fixes those, and that this is easy for one page but a whole archive needs a stronger OCR model. The live terminal in `~/kb-demo`, already scaffolded, is the backup. The sources are real: Kim Jeong-ran (2021) in Korean on the 1946 cholera epidemic and Korean stowaways, Morris-Suzuki (2011) on Japan's postwar border controls, and a scan of SCAPIN 1015 (12 June 1946) from the National Diet Library. The draft citing them is yours for the demo, with errors planted in it. Page 35 has already said this. Copy the three files into `sources/unprocessed/` and run `/process-source` with the line from the run sheet that tells it to transcribe scans itself (about 1:30), pointing out each rename, the bibliography entries, and the SCAP page read as an image. Grep the Korean copy for "80%". Then run `/oss:fact-check manuscript/manuscript.md` (about 1:45) and read the verdicts: Morris-Suzuki reversed (fewer than 100,000 repatriated by 1950, not most in 1946), Kim's stowaways turned into "returnees" in translation, SCAPIN 1015 cited for a suspension it does not order, and an article that does not exist. End with the point of pages 30–31: the machine narrows where I look, and I decide what to write.

*Fallback:* if the live run stalls, say so and read the same verdicts from `~/kb-demo-done/factcheck.log`, or go back to pages 28–31. Move on at 52:30.

## 37. Your answers
**52:30–54:00 · 01:30 · PDF page 37**

Two questions on the slide: what do you think, and what did you answer? The report sets what the room said at the start beside the published surveys. There is no break. As you say the line, start the results command in the second terminal; it takes under a minute. Go to page 38 while it runs.

## 38. Resources
**54:00–55:00 · 01:00 · PDF page 38**

The walk-through on AI for Research has the practice files, the commands, and the answer key. Open Science Skills has the procedures the agent used, and Pixels & Patterns is where I write about this. Suggest one thing to try: build a knowledge base for one paper, then ask a new session for the passage behind one of your claims. Leave this page up while the export runs, about a minute, then open `results.pdf`.

## 39. Appendix
**Outside the timed plan · PDF page 39**

Divider only. Do not present.

## 40–42. References (surveys, learning and judgment, the example and the knowledge base)
**Outside the timed plan · PDF pages 40–42**

Show only if someone asks for a source. The survey references give sample sizes and fieldwork dates. The evidence register below adds the caveats.

## Exporting the results (no break)

There is no break. At page 37, in the second terminal, already open in the lecture folder, run:

```
cd survey && python3 export-responses.py && python3 results.py && open results.pdf
```

`export-responses.py` keeps responses from 14:30 onward by default. Before projecting `results.pdf`, check four things. The response count on the first page is plausible for the room. No "Other/unmatched" warnings were printed to the terminal. No bar carries a dagger for a pending published value. The open answers on the last page (overflow goes to `open-text.md`) contain nothing identifying or inappropriate. If fewer than 10 people answered, `results.pdf` prints "Small room; read as anecdote." Say so aloud and treat every percentage as a count of a few people. If the export fails, follow the fallback in `survey/README.md` (CSV export from the Qualtrics web interface, then `--from-csv`).

## Discussion plan

Run the discussion from `results.pdf` from about 15:57, and leave the last five minutes before 16:55 for Aron to close. That is close to an hour, so each of the three blocks below can run 15 to 20 minutes.

Open with item 6 (results page 4): how many in the room have openly discussed AI with their supervisor or their students, set beside the SGSSS 20%. Note that the room answered a closed question and mixes supervisors and candidates, and that the SGSSS figure was coded from an open question. Ask what prompted the conversation, or what stopped it (about 15 minutes).

Then the open answers (results page 5). Read a few "never hand to AI" answers as the room's Guard list and a few "happily hand to AI" answers as its Automate list. Ask what would be lost, and who checks the result (about 15 minutes).

Then the gaps between the room and the published samples: frequency of use (OUP), editing a draft (Nature, with the room's shorter stem) and the undisclosed first draft (Nature), worry about skills (Nature Graduate Survey, STEM and health only, with the room's reworded item), and whether AI is "just the latest technology" or something different and threatening (Gallup, June 2025: US adults split 49% to 49%). About 15 minutes. Treat any gap as a feature of this self-selected room on one afternoon. It is not a Leiden figure, and do not test differences for significance.

## Likely questions

1. **How much must I read myself?** There is no fixed share. The claim and what you need to learn decide what you must understand. You remain responsible for the interpretations that matter. Summaries are a way into the sources. They do not replace the evidence you need to defend a claim.
2. **Does a second model solve verification?** It can offer another reading, but two models can share an error or miss the same source. Compare the readings against the actual passage in the copy and the original, and keep open questions visible.
3. **What about restricted material, and the data sent to the provider?** The conversion runs on your computer, but whatever the agent reads is sent to the model provider. That includes email and calendar entries when an agent triages them. Check how your provider handles data and what Leiden and your data agreements allow before you use your own files. Decide which tools may see which files. Keep originals out of Git. If you push a repository, keep it private, because a converted paper is still someone else's copyrighted text.
4. **How can students learn while using AI?** Name the skill being developed or assessed, guard the thinking it needs, and design any AI help around that goal. Assess unaided understanding separately from the assisted product. The guided tutor on page 16 avoided harm and produced no gain. The studies on pages 15–17 do not set a general rule for graduate research.
5. **What should I try first?** Work through the knowledge-base walk-through on AI for Research with the four demonstration files. Then set up a project for one of your own papers with `/oss:research-repo`, add one source, and inspect its copy and bibliography entry. Close with `/oss:finished`, and in a new session ask for the passage behind one of your claims.
6. **What do I tell my PhD candidates tomorrow?** Have a conversation about AI use at the start of the thesis, and revisit it. Agree what can be automated, what they must do alone and how you will see it, where AI may help and how they check it, and how they record what was assisted. Read their work yourself before any tool does. Check the current faculty and graduate school rules yourself. This talk does not state Leiden policy.
7. **How were pages 22–34 made?** They are slides drawn in the deck. The chatbot exchanges, the intake example, and the morning brief on page 12 are illustrations with invented content. The claim check and its verdict on pages 22 and 30–31 are real. The citation-check practice project with planted errors is no longer on a slide, and the register below keeps its results. The live demo on pages 35–36 runs three real archival sources and a draft with planted errors. If someone wants to see the knowledge base step by step again, open `visual/knowledge-base.html`.

## Evidence register

- **OUP (2026)**, *Disclosing AI use in academic research*, https://fdslive.oup.com/www.oup.com/Group_comms/pdf/Disclosing_AI_use_in_academic_research.pdf. N = 2,606, fieldwork April 2026. Never: A&H 35%, SS 18%, STM 15%. Frequently: A&H 18%, SS 36%, STM 35%. 74% find disclosure unclear. 46% of journal authors do not fully disclose. 20% trust outputs (A&H 14%, SS 23%). Pages 4 and 6.
- **Kwon, Nature (14 May 2025)**, https://www.nature.com/articles/d41586-025-01463-8. N = 5,229. Group sizes: the slide shows how many in each group answered this item (5,213 overall, humanities 199, social sciences 402, Netherlands 59, PhD students 753); the groups themselves are 200, 403, 59 and 754 people. Edited a draft with AI, any yes: 29% overall (18% undisclosed, 10% disclosed), humanities 25% (n = 200), social sciences 38% (n = 403), Netherlands 39% (n = 59), PhD students 42% (n = 754). Undisclosed AI first draft "not appropriate under any circumstances": 35% overall, humanities 48%, social sciences 37%, Netherlands 32%. Subgroups recomputed from the published microdata on 20 October 2026, by field ticked, rounded half up. The combined yes share is 28.7% (the article prints 18 + 10). Field is multi-select: 1,291 respondents ticked two or more fields. Humanities-only gives 19% (n = 96) and social sciences-only 37%. Small Netherlands n. Script: `planning/nature2025-recompute.py`, run as `python3 -I planning/nature2025-recompute.py <path to the supplementary .xlsx>`. The data file is Nature's supplementary download and is not stored in the repository. Page 5.
- **Wiley ExplanAItions 2025**, https://newsroom.wiley.com/press-releases/press-release-details/2025/AI-Adoption-Jumps-to-84-Among-Researchers-as-Expectations-Undergo-Significant-Reality-Check/default.aspx. N = 2,430. 84% use AI tools, from 57% in 2024. Press release only. Spoken on page 4.
- **Elsevier (2025)**, *Researcher of the Future*, https://assets.ctfassets.net/o78em1y1w4i4/137SmnpRSP2mSuhDxtFdls/72a1777e8a72f3c60748956037f76433/Researcher-Of-The-Future.pdf. N = 3,234, Netherlands n = 87. Netherlands lowest on "AI will drive new knowledge", 29% against 61% worldwide. Spoken on page 4.
- **SGSSS (2026)**, *Generative AI and the Social Science PhD*, https://www.sgsss.ac.uk/files/Generative-AI-and-the-Social-Science-PhD-Report-February-2026-for-website.pdf. N = 308 UK social-science PhD students. 77% have used it. 20% ever openly talked about AI with the supervisory team, coded from an open question. 21% of users had any guidance or training. Page 6.
- **EUA-CDE (2026)**, *Policies in Doctoral Education*, survey report II, https://www.eua.eu/images/publications/Publication_PDFs/CDE_Doctoral_Education_Survey_Part_2_FIN_Online.pdf. 217 universities. 23% do not know how far their doctoral candidates use AI. 5% say existing policies suffice. The unit is the institution. Page 6.
- **Nature Graduate Survey 2025**, reported in *Nature* 651, 19 March 2026. About 3,800 PhD students, STEM and health, no social sciences or humanities. 65% worried AI weakens skills. 81% do not fully trust AI tools. Spoken on page 6.
- **AAC&U and Elon (2026)**, *The AI Challenge*, https://imaginingthedigitalfuture.org/collaborations/the-ai-challenge-how-college-faculty-assess-the-present-and-future-of-higher-education-in-the-age-of-ai/. N = 1,057 US faculty, non-probability. 90% expect diminished student critical thinking. Different wording from the room's item. Page 6, if asked.
- **Autor et al. (2026)**, NBER Working Paper 35720, https://doi.org/10.3386/w35720. Working paper. Patent lawyers, about 90 days of drafting with AI. Both junior and senior lawyers drafted better with AI. Only seniors improved at the later unaided review. The junior unaided result is an unclear average effect. Do not call it a decline. Experience was not randomized. Approximate 95% intervals from Tables 4 and 6. Greater dispersion among juniors is a separate result that an average does not show. The tool: an unreleased Google Labs writing assistant, model not stated (§3.2); Gemini 2.5 Flash served only as the rater. Page 17.
- **Bastani et al. (2025)**, *PNAS* 122(26), https://doi.org/10.1073/pnas.2422633122. High-school math in Turkey. Unrestricted GPT Base: exam score 5.4 points below control. Guided GPT Tutor: about zero on the exam, so it avoided the harm with no learning gain. One setting. Approximate 95% intervals from Table 1. Both GPT Base and GPT Tutor were built on OpenAI GPT-4 (Experimental Design). Page 16.
- **Fernandes et al. (2026)**, "AI makes you smarter but none the wiser", *Computers in Human Behavior* 175, 108779, https://doi.org/10.1016/j.chb.2025.108779. Study 1, N = 246, LSAT logical reasoning with ChatGPT-4o (gpt-4o-2024-05-13, §4.1.5): performance three points above a norm population, and participants overestimated their performance by four points. Higher AI literacy went with lower metacognitive accuracy. Study 2 (N = 452) replicated. Page 15.
- **Bassner et al. (2026)**, *Computers and Education: Artificial Intelligence* 10, 100537, https://doi.org/10.1016/j.caeai.2025.100537. N = 275, three-arm randomized trial in a CS1 course; both AI arms on OpenAI GPT-4, as the hint-first tutor Iris and as unrestricted ChatGPT (§3, §4.2). Both AI arms had higher exercise scores. Neither produced greater knowledge gains or code comprehension. Page 15.
- **Melumad and Yun (2025)**, *PNAS Nexus* 4(10), pgaf316, https://doi.org/10.1093/pnasnexus/pgaf316. Seven experiments, n = 10,462 in the abstract. 3.43 versus 3.86 is Experiment 1's "learned new things" item on a 1–5 scale, ChatGPT versus Google; Experiment 1 used GPT-3.5-turbo through the Chat Completion API and real Google results (Methods, footnote c). Experiment 2 gives 3.71 versus 3.96. Self-reported. It is not a retention test. Page 15.
- **Shen and Tamkin (2026)**, *How AI impacts skill formation*, arXiv:2601.20245. Preprint by Anthropic authors. n = 52, learning the Trio library; the assistant ran on GPT-4o (§4.1). AI use reduced the later quiz score by 17% (Cohen's d = 0.74). No clear time saving. Page 15.
- **Reeves and Rogowski (2016)**, *Journal of Politics* 78(1), https://doi.org/10.1086/683433. **Christenson and Kriner (2017)**, *AJPS* 61(2), https://doi.org/10.1111/ajps.12262. The claim check: sentence revised by hand on 27 August 2026. The check, run on 16 September 2026 on the archived wording, reached the same verdict. Nonsignificant route estimates do not show equivalence. The check tests support for the sentence. It does not judge the studies. The archived wording had "similarly", which page 22 drops for clarity. Pages 22 and 30–31.
- **Reference-check practice project**, `demos/reference-check` in AI for Research. Synthetic, with planted errors. othen2022 likely fabricated, vance2018 cited but not in the bibliography, kowalski2017 listed but never cited, hainmueller2014 verified as the real control. Confirm by hand before calling anything fabricated. No longer on a slide. Use only if asked.
- **Karpathy (2026)**, *LLM Wiki*, https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f. A pattern. It is not the implementation used here and does not guarantee sound synthesis. Pages 23–24.
- **Kenny (2026)**, *Agentic AI for Political Science Research*, CSDP, Princeton, 10 September 2026, https://christophertkenny.com/files/2026-09-10-csdp-ai.pdf. Code: https://github.com/christopherkenny/csdp-llm-wiki. Builds a wiki and treats conversions as staging files. This talk keeps the copies. Named in the page 26 footer.
- **Build a Knowledge Base** (AI for Research), https://scdenney.github.io/ai-for-research/knowledge-base/. **Open Science Skills**, https://github.com/scdenney/open-science-skills. **OpenDataLoader PDF**, https://github.com/opendataloader-project/opendataloader-pdf. Demo commands: `demos/knowledge-base/prompts/run.md`. The existence of a procedure does not establish a successful run. Pages 30–32 and 34.
