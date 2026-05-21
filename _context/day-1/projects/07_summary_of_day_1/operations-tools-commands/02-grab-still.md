# 02 — `02-grab-still.sh`

Pulls a single still frame out of the source video at a timecode. This is the
**second** operation: once a moment in the transcript is worth illustrating in a
how-to doc, this grabs the screenshot for it.

## Why it exists

`01-transcribe-and-diarize.sh` writes wall-clock timestamps into the transcript,
e.g.:

```
**[07:54:05 --> 07:54:17]** **1-A:** If you have a collapsed sidebar ...
```

That `07:54:05` is clock time, not an offset into the video file. This script
does the inverse of the transcription step's start-time math: it reconstructs the
recording's start time the same way, subtracts it from the timecode you give it,
and seeks the video to the resulting offset. So you can copy a timecode straight
out of the transcript and get the right frame.

## Usage

```bash
# Wall-clock timecode straight from the transcript:
./02-grab-still.sh inputs/day1.mov 07:54:05

# Be explicit about the recording start (use the SAME value passed to
# 01-transcribe-and-diarize.sh's -t, so the offsets line up):
./02-grab-still.sh -s "2026-05-18 07:50:00" inputs/day1.mov 07:54:05

# Raw mode: timecode is an offset from the START of the video, no translation:
./02-grab-still.sh -r inputs/day1.mov 00:03:40

# Custom output path:
./02-grab-still.sh inputs/day1.mov 07:54:05 outputs/img/sidebar-toggle.png
```

`<timecode>` accepts `HH:MM:SS[.mmm]`, `MM:SS`, or a bare number of seconds.
Default output is `<videobase>_<HHMMSS>.png` next to the video.

**Requires:** `ffmpeg`, `ffprobe`.

## Options

| Flag | Meaning |
|---|---|
| `-s START` | Recording start as epoch or `"YYYY-MM-DD HH:MM:SS"`. Must match the `-t` value used during transcription, or frames will be offset. |
| `-r` | Raw mode — treat the timecode as an offset from the start of the video; skip wall-clock translation. |

If neither `-s` nor `-r` is given, the start time is derived exactly like the
transcription script's default: `video file mtime − video duration`.

## The one thing to get right

The screenshots only land on the right frame if this script and
`01-transcribe-and-diarize.sh` agree on the recording start time. If you passed
`-t` during transcription, pass the **same** value as `-s` here. If you relied on
file mtime for the transcript, don't copy or re-export the video before grabbing
stills (copying changes mtime and shifts every offset). When in doubt, use `-r`
with a video-relative offset you read off a player.

## Where the stills go

Save selected frames under `outputs/` (e.g. `outputs/img/`) and reference them
from the how-to docs, the way `outputs/claude-ai-setup.md` already embeds a
screenshot. See [`03-generate-howto-docs-prompt.md`](03-generate-howto-docs-prompt.md)
for turning transcript + stills into the guides.
