# CLAUDE.md — Summary of Day 1 Project

This project turns the recording of **Day 1** of the Bok Center Claude workshop
(2026-05-18) into participant-facing how-to guides. The pipeline is: workshop
video → diarized transcript → selected screenshots → rewritten setup guides.

It follows the standard three-folder pattern:

- `inputs/` — the source transcript (`20260518_audio_diarize.md`). The original
  video is not stored in the repo; the operations scripts take a video path as an
  argument.
- `operations-tools-commands/` — the scripts and prompt that produce the outputs,
  numbered in pipeline order. Each script has a matching `.md` explainer.
  - `01-transcribe-and-diarize.sh` — video → diarized, wall-clock-stamped
    transcript (this is the exact script that produced the file in `inputs/`).
  - `02-grab-still.sh` — pull a still frame at a transcript timecode.
  - `03-generate-howto-docs-prompt.md` — transcript + stills → the guides.
- `outputs/` — the finished guides (`claude-ai-setup.md`,
  `claude-cowork-setup.md`) and any embedded screenshots.

## How to work in this project

You are producing reference documentation for Harvard faculty who are new to
Claude and are on the temporary HUIT-provided plan. The transcript is raw spoken
workshop dialogue: reorganize it into task-focused guides rather than cleaning it
up turn by turn. Cut logistics and room-specific asides; keep analogies that
actually teach. The two scripts share one piece of state — the recording's
start time — so the wall-clock timecodes in the transcript and the timecodes you
pass to `02-grab-still.sh` only line up if both steps use the same start time
(see the script `.md` files). Preserve the numeric prefixes on operations files
so the pipeline order stays readable.

## Constraints

- Keep the data-sensitivity guidance accurate and prominent: the HUIT plan is a
  temporary bridge; no data above Harvard Level 2 until the Anthropic Enterprise
  agreement is in place.
- Speaker labels in the transcript are per-chunk and not stable across chunks —
  do not use them to attribute quotes to named individuals.
- Anchor instructions on stable concepts (chats, projects, memory, attachments,
  artifacts, models); note that exact UI placement changes frequently.
- Regenerating a guide: overwrite the file in `outputs/`, don't fork a copy.
- Each operations script keeps a sibling `.md` explainer; update it when the
  script changes.
