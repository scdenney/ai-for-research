#!/usr/bin/env bash
# Make placeholder voice clips audio/scene01.aiff ... audio/scene08.aiff from script.md
# with the macOS speech synthesizer, so the video can be built before the real recording.
# The real clips (audio/sceneNN.m4a) take precedence in build.sh; these are never used
# for a scene that has an .m4a.
#
#   bash video/make-placeholder-audio.sh            # voice Daniel, 150 words a minute
#   VOICE=Samantha RATE=160 bash video/make-placeholder-audio.sh
set -euo pipefail
cd "$(dirname "$0")"

VOICE="${VOICE:-Daniel}"
RATE="${RATE:-150}"
mkdir -p audio

if ! say -v '?' | grep -q "^${VOICE} "; then
  echo "Voice '$VOICE' is not installed. Pick one from: say -v '?' | grep en_" >&2
  exit 1
fi

# Spoken text of scene N: the paragraphs under "## Scene N ·", minus the "(about ...)" line.
scene_text() {
  awk -v n="$1" '
    /^## Scene / { on = ($3 == n); next }
    /^## /       { on = 0; next }
    on && !/^\(about/ && NF { printf "%s ", $0 }
  ' script.md
}

for n in 1 2 3 4 5 6 7 8; do
  nn=$(printf '%02d' "$n")
  text=$(scene_text "$n")
  if [ -z "$text" ]; then
    echo "No text for scene $n in script.md" >&2
    exit 1
  fi
  # one second of silence before and after, as in the recording instructions
  say -v "$VOICE" -r "$RATE" -o "audio/scene${nn}.aiff" "[[slnc 1000]] ${text} [[slnc 1000]]"
  printf 'audio/scene%s.aiff  %5.1f s\n' "$nn" \
    "$(ffprobe -v error -show_entries format=duration -of csv=p=0 "audio/scene${nn}.aiff")"
done
