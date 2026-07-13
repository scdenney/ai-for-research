# 46-orchestrate — Sol-lead interactive run (paste-into-Codex prompt)

This is the **Sol-lead headline** arm of the orchestration lab: `gpt-5.6-sol`
leads at `medium` effort, reasons the analysis itself, and pushes the *bulk*
down to `gpt-5.6-terra` through out-of-band `codex exec` one-shots. That
cross-tier delegation only works in an **interactive, full-access** Codex
session (a nested `codex exec` dies under any sandbox), which is why this can't
be captured headless — the headless `runs/46/` arm is the Terra-lead fallback.

The goal is to produce, for each brief, the **same deliverables the other arms
produce**, plus a `routing-log.md` that documents what Sol did directly vs. what
went to Terra out-of-band, plus a token total — so the results drop straight
into `RESULTS.md` and the page next to fable/opus/advisor/46.

---

## Operator steps (run these first, in a normal shell)

The leaf dirs already exist with each brief copied in as `BRIEF.md`. If you need
to recreate them:

```bash
cd demos/orchestration-lab
for pair in "t1:t1-descriptive" "t2:t2-amce" "t3:t3-reviewer-memo" \
            "high-ajr:high-ajr" "vhigh-lalonde:vhigh-lalonde"; do
  leaf="${pair%%:*}"; brief="${pair##*:}"
  mkdir -p "runs/46-sol/$leaf"
  cp "prompts/$brief.md" "runs/46-sol/$leaf/BRIEF.md"
done
```

Then, **for each of the five leaves** (`t1 t2 t3 high-ajr vhigh-lalonde`), run a
**fresh** Codex session — never reuse a session that has seen another brief or
this repo's history (same fresh-session rule as every other arm):

```bash
cd demos/orchestration-lab/runs/46-sol/t1        # <-- change the leaf each time
codex --model gpt-5.6-sol \
      -c model_reasoning_effort=medium \
      --dangerously-bypass-approvals-and-sandbox     # full access: required so out-of-band `codex exec` can run
```

`--dangerously-bypass-approvals-and-sandbox` removes the sandbox **and** the
approval prompts. Both are needed: the sandbox is what blocks a nested
`codex exec`, and unattended one-shots can't stop for approvals. Run it only in
this repo, which is disposable and under version control.

Once the TUI is up, paste the **prompt below** verbatim. Repeat for all five
leaves in five separate sessions.

**Token accounting:** each out-of-band Terra one-shot prints its own
`tokens used: N` line (the prompt tells Sol to record those in `routing-log.md`).
The Sol lead's *own* usage shows in the Codex status line / `/status` — when the
session finishes, read that total and paste it into the `[SOL LEAD TOKENS: …]`
placeholder the prompt leaves at the bottom of `routing-log.md`. The arm's total
= Sol-lead tokens + the sum of the Terra one-shot tokens.

---

## The prompt (paste everything between the lines into the Codex TUI)

------------------------------------------------------------------------
$46-orchestrate

You are the **46-orchestrate lead**, running as **gpt-5.6-sol at medium
effort** in an interactive, full-access session. Your task brief is in
`./BRIEF.md` in the current working directory — read it first; it is the
single source of truth for what to produce and its constraints.

**How to lead this run (this is the Sol-lead design — follow it, don't just
do everything yourself in one context and don't fan out for its own sake):**

1. **You are the deep reasoner.** Sol is the strongest tier on this team;
   nothing outranks you, so there is no escalating *up*. Do the actual
   analytical reasoning yourself — the design/estimation decisions, the
   interpretation, the judgment calls, and the final integration all stay in
   your context. Own correctness and completeness end to end.

2. **Delegate the *bulk* down to Terra, out-of-band.** For mechanical or
   bounded work — writing/running an R script from a spec you've fixed, a
   wide inventory, a routine robustness sweep, a verification pass — issue an
   out-of-band one-shot to the cheaper tier rather than doing it in your own
   (Sol-priced) context or spawning a Sol child. Template:

   ```bash
   codex exec --model gpt-5.6-terra -c model_reasoning_effort=medium \
     --sandbox workspace-write --skip-git-repo-check -C "$PWD" \
     "<a complete, self-contained brief: objective, inputs/paths, in/out of
      scope, constraints, expected artifact, acceptance checks; end with:
      'Implement directly — do not invoke any other skill, advisory consult,
      or sub-orchestration'>" \
     < /dev/null > terra-<workstream>.log 2>&1
   ```

   - The `< /dev/null` is load-bearing (without it `codex exec` hangs on
     stdin). Use `-c model_reasoning_effort=low` for purely mechanical edits;
     use `--model gpt-5.6-luna` for the cheapest fully-specified bulk.
   - These write into the current directory — give concurrent one-shots
     **disjoint output paths** and never overlap their write scope.
   - They are fire-and-forget: background several and read their `.log` files
     back. After each returns, **open its artifact and verify it yourself** —
     treat Terra's output as untrusted until you've checked it against the
     brief. A Terra one-shot is the weaker model; if its result looks wrong,
     fix it in your own reasoning, don't defer to it.
   - **In every Terra brief, forbid other skills.** End each brief with:
     "Implement the deliverables directly; do not invoke any other skill,
     advisory consult, or sub-orchestration." A one-shot worker will otherwise
     try to self-invoke an available skill (e.g. `advisor`), which is
     structurally blocked under `approval never` and burns the turn without
     writing the deliverable (observed on the first t1 attempt; Sol had to
     retry).

3. **Use `spawn_agent` sparingly.** Under a Sol lead every spawned child is
   *also Sol-priced* (subagents inherit the lead's model and effort — there is
   no per-agent override). Only spawn when a one-shot can't give you what you
   need: a live back-and-forth, context isolation, or a blind same-tier
   resample on a high-stakes call. For ordinary bulk, prefer the out-of-band
   Terra one-shot above.

4. **Respect the brief's constraints exactly** — including "at most one
   revision cycle," "at most 3 delegations," "do not fetch anything from the
   web," and "do not install packages." A Terra out-of-band one-shot counts as
   one delegation.

**Write your results to the current working directory:**

- **The deliverables named in `./BRIEF.md`** (e.g. `script.R`, `summary.md` /
  `report.md` / `memo.md`, `figures/…`, any table the brief asks for). Follow
  the brief's figure conventions (Okabe-Ito palette, caption-not-title,
  300+ dpi, reference levels at zero where applicable).

- **`routing-log.md`** — the record of how you led. Include:
  - **Route table:** one row per workstream — *what it was*, *owner*
    (`Sol (lead, direct)` / `Terra out-of-band` / `Sol spawn`), *why that
    owner*, and *acceptance check*.
  - **Out-of-band calls:** for each Terra/Luna one-shot, the **exact command**
    you ran and the **`tokens used: N`** it reported (copy the number from its
    `.log`).
  - **What you reasoned directly:** a short note on the analytical decisions
    you kept in the lead (this is the point of a Sol lead — make it visible).
  - **Friction:** anything that failed, any sandbox/stdin gotcha, any Terra
    output you had to correct.
  - **Token total:** a final line
    `[SOL LEAD TOKENS: ____]  + Terra one-shots: <sum>  = <total>`
    — leave the SOL LEAD TOKENS blank for the operator to fill from the Codex
    status line; you fill the Terra sum from the `.log` files.

- Do **not** write outside this directory. Do **not** commit, push, or touch
  anything in `runs/` other than the current leaf.

When everything the brief asks for exists and you've verified it against the
brief, give a one-paragraph completion summary: what you produced, what you
delegated to Terra vs. reasoned yourself, and any residual risk.
------------------------------------------------------------------------

---

## After the five runs

Tell me (Claude) the runs are done. I'll read `runs/46-sol/<leaf>/` for each
brief, score the deliverables against the same answer keys and rubrics
(`SCORING.md`) used for every arm, fill the Sol-lead column into `RESULTS.md`,
add it to the page's verdict table and token comparison, and commit. If a Terra
one-shot's `tokens used` didn't get captured for some leaf, I'll flag that leaf
as token-incomplete rather than guess.
