# Knowledge-base explainer video

A three-minute video that replaces the live terminal demo. It shows what a chatbot does with a claim from my draft on its own, then what changes when an agent works from my knowledge base. Everything is drawn in `scenes.html`, rendered frame by frame in Chrome, and joined with my voice in ffmpeg.

## Record the voice

The script and the recording instructions are in `script.md`. In short: record one clip per scene (QuickTime → File → New Audio Recording, or Voice Memos), leave a second of silence at each end, and save them as `audio/scene01.m4a` to `audio/scene08.m4a`. Each scene takes the length of its clip, so there is no target to hit.

## Build

From the lecture folder:

```
bash video/build.sh
```

This takes about two minutes and writes `video/kb-demo.mp4` and `video/poster.png` (a still of scene 6 for the slide). For each scene it uses `audio/sceneNN.m4a` if it exists and otherwise the placeholder `audio/sceneNN.aiff`, so you can replace scenes one at a time and rebuild. Loudness is normalised to −16 LUFS.

Placeholder voice (macOS `say`, voice Daniel), regenerated from `script.md`:

```
bash video/make-placeholder-audio.sh
```

Requirements: Google Chrome in `/Applications`, Node, ffmpeg. `build.sh` installs `playwright-core` into `video/node_modules` if it is missing; it drives the installed Chrome and downloads no browser.

Useful while editing `scenes.html`:

- open `scenes.html?play` in Chrome to preview at the storyboard lengths (`?play&scene=4` starts at scene 4)
- `node video/render.mjs --still 6:30:/tmp/s6.png` renders one frame (scene 6 at 30 s)
- `node video/render.mjs --scenes 4` re-renders only scene 4's frames

## Play it in the talk

Copy `kb-demo.mp4` to the presenting laptop beforehand. It needs no network. Open it in QuickTime Player, press ⌃⌘F for full screen, and press space to play. Check the room's sound with the first few seconds before the session.
