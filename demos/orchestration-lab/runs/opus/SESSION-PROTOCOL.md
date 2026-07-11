# Opus capture protocol (user-driven)

Three short interactive sessions, one per tier, ~5–10 minutes of attention each. They exist because the opus-orchestrate lead must actually BE Opus 4.8 under ultracode — a session with any other lead is not a capture of this mode.

## Per tier (N = 1, 2, 3)

1. **Start fresh** in the run leaf so artifacts land in place:
   ```bash
   cd demos/orchestration-lab/runs/opus/tN && claude
   ```
2. **Set the lead:** `/model` → Claude Opus 4.8, `/effort` → ultracode. (Session-scoped; your defaults return next session.)
3. **Paste the tier's block** from below, unmodified.
4. **When the run finishes:** type `/cost`, then paste its output back with this one line:
   > Append the /cost output above verbatim to run-log.md, then stop.
5. Exit. Done.

The build session extracts `transcript-excerpt.md` from the local session log afterwards and generates `SHA256SUMS`.

---

## Paste block — T1

```
/oss:opus-orchestrate Work this brief in the current directory exactly as written. When done, create run-log.md here from the template at ../../../prompts/run-log-template.md, filling the routing-trace section yourself (who you delegated to, model + effort, purpose, what came back — "none, did it inline" is valid) and the friction log. Brief follows.

[paste the full contents of demos/orchestration-lab/prompts/t1-descriptive.md]
```

## Paste block — T2

```
/oss:opus-orchestrate Work this brief in the current directory exactly as written. When done, create run-log.md here from the template at ../../../prompts/run-log-template.md, filling the routing-trace section yourself and the friction log. Brief follows.

[paste the full contents of demos/orchestration-lab/prompts/t2-amce.md]
```

## Paste block — T3

```
/oss:opus-orchestrate Work this brief in the current directory exactly as written. When done, create run-log.md here from the template at ../../../prompts/run-log-template.md, filling the routing-trace section yourself and the friction log. Brief follows.

[paste the full contents of demos/orchestration-lab/prompts/t3-reviewer-memo.md]
```
