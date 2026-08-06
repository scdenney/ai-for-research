#!/usr/bin/env bash
# Run this from inside the leaf directory (runs/46-sol-v2/<leaf>/) immediately
# after the interactive Sol-lead session for that leaf exits. It finds that
# session's own log file and writes its authoritative cumulative token total
# to sol-lead-usage.json in the current directory.
set -euo pipefail
LATEST=$(ls -t ~/.codex/sessions/*/*/*/*.jsonl | head -1)
echo "Reading: $LATEST"
grep '"type":"token_count"' "$LATEST" | tail -1 | python3 -c "
import json,sys
d = json.loads(sys.stdin.read())
print(json.dumps(d['payload']['info']['total_token_usage'], indent=2))
" | tee sol-lead-usage.json
