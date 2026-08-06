#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."   # -> demos/orchestration-lab

for pair in "t1:t1-descriptive" "t2:t2-amce" "t3:t3-reviewer-memo" \
            "high-ajr:high-ajr" "vhigh-lalonde:vhigh-lalonde" \
            "extreme-stagdid:extreme-stagdid"; do
  leaf="${pair%%:*}"; brief="${pair##*:}"
  dir="runs/advisor-v2/${leaf}-codex"
  mkdir -p "$dir"; cd "$dir"
  echo "=== $leaf ==="

  codex exec --json --model gpt-5.6-terra -c model_reasoning_effort=xhigh \
    --sandbox workspace-write --skip-git-repo-check -C "$PWD" \
    "$(cat "../../../prompts/${brief}.md")" \
    < /dev/null > exec-step1.jsonl 2>&1

  {
    echo "=== ORIGINAL BRIEF ==="; cat "../../../prompts/${brief}.md"
    echo; echo "=== PRODUCED DELIVERABLES ==="
    for f in *.md *.R; do
      [ -f "$f" ] || continue
      case "$f" in briefing.md|advice.md) continue ;; esac
      echo "--- $f ---"; cat "$f"; echo
    done
    echo "=== QUESTION ==="; echo "This is a completed submission against the brief above. What would you change?"
  } > briefing.md

  ~/.codex/skills/advisor/scripts/sol-advisor.sh \
    --prompt-file briefing.md --out advice.md -C "$PWD" 2>&1 | tee sol-consult.log

  codex exec --json --model gpt-5.6-terra -c model_reasoning_effort=xhigh \
    --sandbox workspace-write --skip-git-repo-check -C "$PWD" \
    "Revise the deliverables in this directory per the attached advice. Advice: $(cat advice.md)" \
    < /dev/null > exec-step3.jsonl 2>&1

  cd - > /dev/null
  echo "=== $leaf done ==="
done
echo "All six tiers complete."
