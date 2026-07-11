# Running the matrix

Every run starts from its own leaf directory under `runs/<mode>/<tier>/`, so the mode writes its artifacts in place. Every run is a **fresh session**. Never reuse a session that has seen another run or this repo's build history. After each run, fill `run-log.md` (copy `prompts/run-log-template.md`), write `transcript-excerpt.md` under the excerpt rules below, and generate hashes:

```bash
shasum -a 256 script.R figures/* *.md > SHA256SUMS
```

## Excerpt rules (applied mechanically, stated on the page)

1. Always keep: the brief as received, every delegation boundary (instruction out + summary back), decision pivots, the final deliverable message.
2. Mark every cut with an explicit elision line: `[… N lines elided — full log: <file>]`.
3. Never paraphrase quoted transcript text. Annotations go between quoted blocks, visually distinct.
4. Codex runs commit their full `exec-stdout.log` (scrub absolute home paths first). Claude session transcripts stay local. The committed excerpt + cost snapshot is the public record.

## fable-orchestrate (headless)

`ANTHROPIC_API_KEY` must be unset for headless runs. If set, it overrides the claude.ai login and bills (or fails on) the API account:

```bash
cd runs/fable/t1
env -u ANTHROPIC_API_KEY claude -p \
  "/oss:fable-orchestrate $(cat ../../../prompts/t1-descriptive.md)" \
  --output-format json > claude-envelope.json
```

The JSON envelope carries `duration_ms`, `total_cost_usd`, `usage`, and `session_id` (locate the local transcript under `~/.claude/projects/` by that id for excerpting). Repeat with `t2-amce.md`, `t3-reviewer-memo.md`.

## 46-orchestrate (headless)

The Codex skills must be installed user-wide (`ln -sfn` loop in the toolkit's `codex/README.md`). Then:

```bash
cd runs/46/t1
codex exec --model gpt-5.6-terra -c model_reasoning_effort=medium \
  --sandbox workspace-write --skip-git-repo-check -C "$PWD" \
  "\$46-orchestrate

$(cat ../../../prompts/t1-descriptive.md)" < /dev/null 2>&1 | tee exec-stdout.log
```

The `< /dev/null` is load-bearing (`codex exec` hangs on stdin without it). Token counts are the `tokens used` lines in the log.

## advisor arm (T3 only; three scripted steps per platform)

Plain session solves T3, then one advisor consult, then plain session revises. No orchestration skill in steps 1 and 3.

**Claude arm** (`runs/advisor/t3-claude/`):

```bash
env -u ANTHROPIC_API_KEY claude -p "$(cat ../../../prompts/t3-reviewer-memo.md)" \
  --output-format json > claude-envelope-1.json
# compose briefing.md: the brief + the produced memo + "what would you change?"
env -u ANTHROPIC_API_KEY CLAUDE_EFFORT=max \
  <toolkit>/plugin/skills/advisor/scripts/fable-advisor.sh \
  --prompt-file briefing.md --out advice.md -C "$PWD"
env -u ANTHROPIC_API_KEY claude -p \
  "Revise memo.md and its supporting artifacts in this directory per the attached advice. Advice: $(cat advice.md)" \
  --output-format json > claude-envelope-2.json
```

**Codex arm** (`runs/advisor/t3-codex/`): the same three steps with `codex exec --model gpt-5.6-terra -c model_reasoning_effort=medium` for steps 1 and 3, and the toolkit's Codex-side advisor script for step 2.

## opus-orchestrate (interactive, user-driven)

See `../runs/opus/SESSION-PROTOCOL.md`. The build assistant cannot run these. The lead must be a real Opus 4.8 + ultracode session.
