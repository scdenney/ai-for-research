#!/usr/bin/env bash
# Build kb-demo.mp4 from scenes.html and the voice clips in audio/.
#
#   bash video/build.sh
#
# For each scene N the voice clip is audio/sceneNN.m4a (your recording) or, if that is
# missing, audio/sceneNN.aiff (the placeholder from make-placeholder-audio.sh). The scene
# lasts as long as its clip plus PAD seconds (plus EXTRA for scenes that hold on a frame).
# A scene with no clip at all gets its storyboard length and silence.
set -euo pipefail
cd "$(dirname "$0")"

FPS=30
PAD=0.6
TARGETS=(12 30 15 30 25 40 15 8)        # storyboard lengths, used only when a clip is missing
EXTRA=(0 0 0 0 0 2.5 0 1.5)             # extra hold: scene 6 (revised sentence), scene 8 (end card)
N=${#TARGETS[@]}

for tool in ffmpeg ffprobe node python3; do
  command -v "$tool" >/dev/null || { echo "Missing $tool" >&2; exit 1; }
done
[ -d node_modules/playwright-core ] || npm i --no-audit --no-fund playwright-core

mkdir -p build
t_start=$(date +%s)

# ---- 1. durations ---------------------------------------------------------------
durs=()
clips=()
for ((i = 1; i <= N; i++)); do
  nn=$(printf '%02d' "$i")
  clip=""
  for ext in m4a aiff; do
    if [ -f "audio/scene${nn}.${ext}" ]; then clip="audio/scene${nn}.${ext}"; break; fi
  done
  if [ -n "$clip" ]; then
    a=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$clip")
    d=$(python3 -c "print($a + $PAD + ${EXTRA[$((i-1))]})")
  else
    d=${TARGETS[$((i-1))]}
  fi
  # whole number of frames
  d=$(python3 -c "print(round($d * $FPS) / $FPS)")
  durs+=("$d")
  clips+=("$clip")
  printf 'scene %s  %6.2f s  %s\n' "$nn" "$d" "${clip:-(no clip: silence)}"
done
python3 -c "import json,sys; print(json.dumps([float(x) for x in sys.argv[1:]]))" "${durs[@]}" > durations.json

# ---- 2. frames ------------------------------------------------------------------
t_render=$(date +%s)
node render.mjs --jobs "${JOBS:-6}"
t_rendered=$(date +%s)

# ---- 3. per-scene video and audio -----------------------------------------------
: > build/video.txt
: > build/audio.txt
for ((i = 1; i <= N; i++)); do
  nn=$(printf '%02d' "$i")
  d=${durs[$((i-1))]}
  clip=${clips[$((i-1))]}

  ffmpeg -y -v error -framerate "$FPS" -i "frames/scene${nn}/%05d.png" \
    -vf "scale=out_color_matrix=bt709:out_range=tv,format=yuv420p" \
    -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p \
    -colorspace bt709 -color_primaries bt709 -color_trc bt709 -color_range tv \
    -r "$FPS" "build/scene${nn}.mp4"

  if [ -n "$clip" ]; then
    # two-pass loudness normalisation to -16 LUFS, then pad with silence to the scene length
    m=$(ffmpeg -hide_banner -i "$clip" -af "loudnorm=I=-16:TP=-1.5:LRA=11:print_format=json" -f null - 2>&1 |
        python3 -c "import sys,json; t=sys.stdin.read(); j=json.loads(t[t.rindex('{'):t.rindex('}')+1]); print(':'.join(['measured_I='+j['input_i'],'measured_TP='+j['input_tp'],'measured_LRA='+j['input_lra'],'measured_thresh='+j['input_thresh'],'offset='+j['target_offset']]))")
    ffmpeg -y -v error -i "$clip" \
      -af "loudnorm=I=-16:TP=-1.5:LRA=11:${m}:linear=true,aresample=48000,apad" \
      -t "$d" -ac 2 -ar 48000 -c:a pcm_s16le "build/scene${nn}.wav"
  else
    ffmpeg -y -v error -f lavfi -i "anullsrc=r=48000:cl=stereo" -t "$d" -c:a pcm_s16le "build/scene${nn}.wav"
  fi
  echo "file 'scene${nn}.mp4'" >> build/video.txt
  echo "file 'scene${nn}.wav'" >> build/audio.txt
done

# ---- 4. join --------------------------------------------------------------------
# Video segments are joined without re-encoding; the audio is joined as one sample-exact
# track and encoded once, so sound and picture stay in step across scene cuts.
ffmpeg -y -v error -f concat -safe 0 -i build/audio.txt -c copy build/audio.wav
ffmpeg -y -v error -f concat -safe 0 -i build/video.txt -i build/audio.wav \
  -map 0:v -map 1:a -c:v copy -c:a aac -b:a 192k -ar 48000 -movflags +faststart -shortest kb-demo.mp4

# ---- 5. poster for the slide: scene 6 with both passages and their tags, just before the verdict
d6=${durs[5]}
pf=$(python3 -c "print(max(1, round($d6 * 0.69 * $FPS)))")
cp "frames/scene06/$(printf '%05d' "$pf").png" poster.png

t_end=$(date +%s)
total=$(ffprobe -v error -show_entries format=duration -of csv=p=0 kb-demo.mp4)
echo "kb-demo.mp4: ${total} s. Frames rendered in $((t_rendered - t_render)) s, whole build $((t_end - t_start)) s."
