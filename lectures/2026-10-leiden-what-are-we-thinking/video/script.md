# Voice-over script: the knowledge-base video

## Recording instructions

1. Record one clip per scene, in a quiet room. Use QuickTime Player (File → New Audio Recording) or Voice Memos on a phone.
2. Leave about one second of silence before you start speaking and after you finish.
3. Save the clips as `video/audio/scene01.m4a`, `video/audio/scene02.m4a` and so on up to `video/audio/scene08.m4a`. Voice Memos files can be AirDropped and renamed.
4. Re-record any scene as often as you like. Each scene stretches or shrinks to the length of its clip, so there is no need to hit a target time.
5. When the clips are in place, run `bash video/build.sh` from the lecture folder. It rebuilds `video/kb-demo.mp4`.

Target lengths are given in brackets. They are a guide only.

## Scene 1 · The claim

(about 12 seconds)

This is a sentence from my own draft. It says that citizens penalize a president who acts alone more than one who works through Congress. It cites two studies. Do they really say that?

## Scene 2 · An LLM on its own

(about 30 seconds)

First I ask a chatbot on its own. I give it the sentence and ask whether the two studies support it. The answer is fluent and confident, and it agrees with me. It quotes nothing, so I cannot check it without reading both papers. A week later I ask which papers I was using. It has no memory of that conversation. From here on I use an agent. That is a model that can open files and run tools.

## Scene 3 · The pile

(about 15 seconds)

Here is how my sources usually arrive. Four files in a downloads folder. One is named by my browser and one by the publisher. One is a Word file. One is a scan of a printed page.

## Scene 4 · Intake

(about 30 seconds)

The first job is intake. I drop a file into a folder. The agent finds the author, the year and the title. It gives the file a name I can read. It makes a searchable copy of the text and adds an entry to my bibliography. The scan stops halfway. It is a picture of a page, so it needs text recognition first. The originals never change. The agent works from the copies.

## Scene 5 · The library and the chain

(about 25 seconds)

After intake the project looks like this. The originals sit in one folder and the searchable copies in another. There is one bibliography, my manuscript, and a file of instructions the agent reads every time. Now each citation leads somewhere. It goes from my draft to the bibliography, then to the searchable copy, and back to the original PDF.

## Scene 6 · The same question, with the knowledge base

(about 40 seconds)

Now I ask the agent the same question, inside my knowledge base. It opens the searchable copies of both papers and finds the passages that matter. Reeves and Rogowski report that only about a quarter of respondents supported unilateral policymaking. That is low support in general. They do not compare executive action with legislation. Christenson and Kriner find that the route the president takes has no significant effect on support. Neither study shows a penalty. So my sentence is unsupported as written. The agent shows me the evidence. I decide what to write, and this is the revised sentence.

## Scene 7 · What persists

(about 15 seconds)

At the end of a session the agent writes things down. A handoff note says where I am and what comes next. A session log records what was done. The version history keeps every change and the reason for it.

## Scene 8 · End card

(about 8 seconds)

I made this video with Claude Code, running Opus 5.5. It wrote the animation and drafted the script. The voice is mine.
