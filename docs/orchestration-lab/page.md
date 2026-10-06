<!--
Prose source for index.html. Edit here; the HTML is mirrored from this file.
The rubric checklists and the run commands live only in index.html.
Numbers come from demos/orchestration-lab/RESULTS.md (July 2026 captures).
-->

# Orchestration Lab

**Lede:** Run an analysis task four ways and score the result against an answer key.

**Kicker:** Demos · Hands-on

---

## Note {#note}

These runs were made in July 2026 with Fable 5, Opus 4.8, Sonnet 5, GPT-5.6 Sol and
GPT-5.6 Terra, and with the Open Science Skills as they were then. The models and the
skills have changed since, so a run today would give different results. We will re-run the
briefs with the current skills and post the results here. Until then, the page shows the
four setups and the design of the test.

## What this is {#what}

Each brief is a social-science analysis of public data that comes with an R package. Each
brief was run in four ways, with Fable leading, with Opus leading, with one advisor
consult, and with Codex leading. All runs use skills from the
[Open Science Skills](https://github.com/scdenney/open-science-skills). Each brief also has
a reference solution and a scoring rubric, both written before any model ran (one T1 item was reworded after the first scoring). To run one
yourself, pick a brief and a setup and run the command. Then compare the result with the
answer key and [our committed runs](https://github.com/scdenney/ai-for-research/tree/main/demos/orchestration-lab/runs).

**Report card:** Four ways to run a frontier model. The full findings from the July runs
are on Pixels & Patterns.

## The four setups {#setups}

| Setup | How it works | When to use it | In the skills now |
|---|---|---|---|
| Fable lead | Fable plans the work and does the hard reasoning itself. Sonnet subagents do the mechanical work and Opus subagents the wide reasoning. A GPT model in Codex does the cross-checks. | Work too large for one context, such as a multi-file audit or a survey of many sources. These briefs did not test that. In July it was the cheapest and fastest Claude setup. | `/oss:orchestrate` in a Fable session. In July this was `/oss:fable-orchestrate`, and the cross-check went to GPT-5.6 Sol. It now goes to GPT-6 Astra. |
| Opus lead | The same skill, with Opus as the lead. | A task hard enough to strain Fable. In July it matched or beat the Fable lead on every brief, at a higher cost. | `/oss:orchestrate` in an Opus session, at medium effort. In July this was `/oss:opus-orchestrate` on Opus 4.8, run headless. |
| Advisor | A plain session does the work. Fable reviews it once, without editing anything, and the session revises. | The default for one well-scoped analysis. In July its review caught an analysis error before it shipped, a misread comparison-type label on the extreme brief. | `/oss:advisor`, from an Opus or Sonnet session. It refuses to run from a Fable session, since a second Fable is not a check. In Codex, `$advisor` asks GPT-6 Astra. In July the work ran mostly on Sonnet 5 (the T1 solve ran on Fable 5) and the review on Fable 5. |
| Codex lead | A GPT model leads in Codex. It sends bounded work to cheaper GPT models and can ask Claude for a check. | When you want the second opinion to come from a different vendor. | `$orchestrate` in a GPT-6 Astra or GPT-5.6 Sol session. In July this was `$46-orchestrate`, with a GPT-5.6 Sol lead and a Fable 5 peer. |

[`/oss:model-committee`](../skills/#model-committee) has also changed since July. GPT-6
Astra and Opus now each propose an answer and critique the other's, and a Fable chair
settles the result.

## Step 1: Set up {#setup}

You need Claude Code with the Open Science Skills ([Getting started](../getting-started/))
and R with the packages below. The commands below clone this repository. The Fable and Opus leads use the
[Codex CLI](https://developers.openai.com/codex/) for their cross-checks, and the Codex lead
also needs the Codex version of the skills.

The data ship with the R packages, so you do not need to download anything. The runs call
hosted models, so they cost money. In July a run of one brief cost about $1 to $5 on the
Claude setups. Keep `ANTHROPIC_API_KEY` unset so that headless runs charge your
claude.ai plan instead of an API account.

## Step 2: Pick a brief {#briefs}

The six briefs are on four rungs of difficulty, and each rung is a different kind of
problem.

| Rung | The briefs | Why they are there |
|---|---|---|
| easy to moderate | Three briefs on one conjoint dataset. The first two have fixed answers, and the third asks for a judgment call. | They check that a setup gets the facts right before it has to judge. |
| hard to very hard | Two well-known methods disputes with settled answers | The statistics are harder, but worked versions are widely published. All four setups reached the top band on both in July. |
| extreme | A recent methods debate, with a trap in the data that the brief warns about | It tests whether the agreement on the harder rungs came from the setups or from well-known tasks. In July it did not separate the setups. |

Each brief links to the exact prompt the models get.

## Step 3: Pick a setup and run it {#run}

Pick a setup and a brief, and run the command below. It uses the current skills, which we
have not yet run on the briefs. To leave the committed runs unchanged, it writes to a new
folder called `myruns/`. The July run protocol, and the rules we followed for the captured
runs, are in [run.md](https://github.com/scdenney/ai-for-research/blob/main/demos/orchestration-lab/prompts/run.md). The 19 July advisor rerun is in
[rerun.sh](https://github.com/scdenney/ai-for-research/blob/main/demos/orchestration-lab/runs/advisor-v2/rerun.sh). Headless runs use your own Claude Code permission settings,
and a run that is not allowed to write files or call Rscript will stop.

The run writes to your `myruns/` folder. It usually produces an R script and a memo, and
often a figure. A headless Claude run also creates a JSON file whose `total_cost_usd` and
`duration_ms` fields give the cost and the time. When the run finishes, score its output
with the checklists below. You can then compare it with the committed run of the same brief
in [runs/](https://github.com/scdenney/ai-for-research/tree/main/demos/orchestration-lab/runs).

## Step 4: Score your run {#score}

Each brief is scored on six items, and each item is a yes-or-no question. Four are core
facts about the brief. The other two cover a judgment call and completeness, meaning work
beyond getting the answer right. A run needs all four core items to Pass, the judgment item
as well for Pass+, and all six for Distinction. Missing any core item fails the run. The
definitions, and the item scores for every captured run, are in
[SCORING.md](https://github.com/scdenney/ai-for-research/blob/main/demos/orchestration-lab/SCORING.md). The executed reference solutions are in
[reference/](https://github.com/scdenney/ai-for-research/tree/main/demos/orchestration-lab/reference).

## What the July runs showed {#results}

The July test ran six briefs through six setups: the four above, a headless Codex run that
could not hand work to a cheaper model, and an advisor run entirely in Codex. All 36 runs
were scored against the rubrics, and two results stand out.

First, both orchestrated Claude leads scored only Pass on the easy brief. Neither flagged
Driving Time as the one unbalanced attribute or reported the exact largest deviation from
balance.
Second, five of the six setups reached Distinction on the extreme brief, so the harder and
newer task did little to separate them.

The sixth, the advisor run entirely in Codex, failed it. Its first draft
dealt with the trap correctly. The reviewer then objected, reasonably, that the `staggered`
estimator assumes randomized timing. In revising, the model removed that estimator, and
with it the code that dealt with the trap. A
sound second opinion cost the run the item the rubric was built to check. See the
[report](https://www.pixelsandpatterns.org/p/four-ways-to-run-a-frontier-model) or
[RESULTS.md](https://github.com/scdenney/ai-for-research/blob/main/demos/orchestration-lab/RESULTS.md) for details.

**Figure caption:** Rubric items met on the six briefs, one panel per setup, against the
three score bands. July 2026, one run each.

Each result here is a single run, and the models do not give the same answer twice.
Expect a different result when you re-run a brief.
