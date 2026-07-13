# Talk to Your Terminal

**Install a dictation pipeline for your CLI agent: tap a hotkey, speak, tap
again, and the cleaned-up text lands at your cursor about a second later.**

Part of [**AI for Research**](../../). This is the companion demo for the
*Pixels and Patterns* post
[*Talk to your terminal*](https://www.pixelsandpatterns.org/p/talk-to-your-terminal),
and the rendered walkthrough lives at
[scdenney.github.io/ai-for-research/talk-to-your-terminal](https://scdenney.github.io/ai-for-research/talk-to-your-terminal/).

## The issue

Most of the work with a command-line agent is writing prompts. Claude Code
and Codex do best when you provide as much information as possible, and
detailed prompts easily run three hundred words. Typing three hundred words
for every prompt, all day, is a kind of drudgery; shortening the prompt
degrades the answer. Dictation resolves the trade-off: a language model is
very good at pulling intent out of even meandering speech, and speaking is
the cheapest way to supply volume and specifics. Speak the intent at length,
type what must be exact, and let a cleanup model make the result readable.

Watch the loop, in real time (13.6 s, unedited):
[dictation-loop.mp4](../../docs/assets/talk-to-your-terminal/dictation-loop.mp4)

[![The dictation loop: one tap starts the recording, the pill streams the live transcript, a second tap leaves the cleaned-up text at the Claude Code prompt](../../docs/assets/talk-to-your-terminal/dictation-loop-poster.png)](../../docs/assets/talk-to-your-terminal/dictation-loop.mp4)

## What you are installing

Two small public repositories, one per platform. Neither is an application
or a package; each is a reproducible configuration pattern: hotkey-triggered
recording, streaming OpenAI transcription, a constrained LLM cleanup pass,
and a calibration loop.

|  | Linux | macOS |
| --- | --- | --- |
| Repository | [scdenney/hyperwhspr](https://github.com/scdenney/hyperwhspr) | [scdenney/macwhspr](https://github.com/scdenney/macwhspr) |
| What it is | Config for the upstream [hyprwhspr](https://github.com/goodroot/hyprwhspr) recorder (Hyprland) | The whole setup in one repo: Python daemon + system glue |
| Hotkey | `SUPER+ALT+D` (Hyprland bind) | Globe/Fn key (Karabiner + Hammerspoon) |
| Runs as | systemd user service | launchd LaunchAgent |

You need an OpenAI API key on either platform. Both repos default to
streaming `gpt-realtime-whisper`, keep the cheaper batch endpoint one config
line away, and on Linux a fully local ONNX backend is available if audio
must not leave the machine.

## Install manually

Each repository's README has the full numbered walkthrough, ending with a
status check and a first-dictation test:

- **Linux:** [hyperwhspr → Install](https://github.com/scdenney/hyperwhspr#install)
  (four steps: copy the files, fix two paths, add your key, start the service)
- **macOS:** [macwhspr → Install](https://github.com/scdenney/macwhspr#install)
  (`brew` prerequisites, `./setup.sh`, then five manual steps)

## Or have an agent install it

Both READMEs are written so a coding agent can run the install. Paste the
matching prompt into Claude Code or Codex and supervise. Two things stay
with you on purpose: your API key never passes through the conversation,
and on the Mac the GUI permission prompts need a human at the screen.

**Linux:**

```text
Install hyperwhspr from https://github.com/scdenney/hyperwhspr: clone the
repo and follow the README's Install section. If upstream hyprwhspr is not
installed, install it first from https://github.com/goodroot/hyprwhspr.
Substitute my real home directory for the YOUR_USER placeholders in step 2.
Skip the API key line in step 3; I will create the credentials file myself.
Finish by running `systemctl --user status hyprwhspr` and showing me the
result.
```

**macOS:**

```text
Install macwhspr from https://github.com/scdenney/macwhspr: install the brew
prerequisites from the README, clone the repo, run ./setup.sh, then walk me
through the remaining manual steps one at a time. Skip the Keychain command
in step 1; I will add the API key myself. Steps 2-4 are System Settings,
Karabiner, and Hammerspoon permission prompts that I have to click, so tell
me what to do and wait for my confirmation. Finish by starting the daemon
(step 5) and showing me `launchctl print gui/$UID/com.macwhspr.daemon`.
```

## After the install

Every raw and cleaned transcript pair is logged, and the `/hypr-calibrate`
command (installed on both platforms) reviews those logs and proposes edits
to a vocabulary file: words the transcriber keeps missing, preferred
spellings of names, habits worth preserving. The system gets better at being
you over time. A month of heavy use, 662 dictations and 54,796 words across
two machines, comes to about $8 in API fees at current streaming prices.

The full argument, the measured latency arc, and the caveats are in the
post: [*Talk to your terminal*](https://www.pixelsandpatterns.org/p/talk-to-your-terminal).
