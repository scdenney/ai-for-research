#!/usr/bin/env bash
# Codex-side advisor arm, all five historical tiers, run from a PLAIN terminal
# (not from inside a codex session) so the sol-advisor.sh consult step can
# nest its own codex exec without hitting the sandbox restriction.
set -euo pipefail
cd "$(dirname "$0")/../.."   # -> demos/orchestration-lab

for pair in "t1:t1-descriptive" "t2:t2-amce" "t3:t3-reviewer-memo" \
            "high-ajr:high-ajr" "vhigh-lalonde:vhigh-lalonde"; do
  leaf="${pair%%:*}"; brief="${pair##*:}"
  dir="runs/advisor/${leaf}-codex"
  echo "=== $leaf ==="
  cd "$dir"

  codex exec --model gpt-5.6-terra -c model_reasoning_effort=medium \
    --sandbox workspace-write --skip-git-repo-check -C "$PWD" \
    "$(cat "../../../prompts/${brief}.md")" \
    < /dev/null > exec-step1.log 2>&1

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
    --prompt-file briefing.md --out advice.md -C "$PWD"

  codex exec --model gpt-5.6-terra -c model_reasoning_effort=medium \
    --sandbox workspace-write --skip-git-repo-check -C "$PWD" \
    "Revise the deliverables in this directory per the attached advice. Advice: $(cat advice.md)" \
    < /dev/null > exec-step3.log 2>&1

  cd - > /dev/null
  echo "=== $leaf done ==="
done
echo "All five tiers complete."
