# 01 — `01-transcribe-and-diarize.sh`

The script that turned the Day 1 workshop video into the diarized transcript in
`inputs/20260518_audio_diarize.md`. It is the **first** operation in this project:
video in → speaker-labeled, time-stamped markdown out.

## What it does

Given a video or audio file, it:

1. **Extracts audio** with `ffmpeg` to a 128 kbps MP3 next to the input
   (`/path/to/video.mov` → `/path/to/video/video.mp3`).
2. **Computes the recording's wall-clock start time.** By default it reads the
   input file's modification time (taken as the *end* of the recording) and
   subtracts the audio duration. Override with `-t` when the mtime is wrong
   (copied/exported file) — this is what makes the transcript timestamps line up
   with real clock time, e.g. `07:50:25`.
3. **Chunks long recordings** into 10-minute segments (`MAX_CHUNK_DURATION=600`)
   so each stays well under the API file-size limit.
4. **Transcribes each chunk in parallel** via the OpenAI
   `gpt-4o-transcribe-diarize` model (`response_format=diarized_json`), staggering
   launches by `API_CALL_DELAY` to avoid rate limits, and **skips silent chunks**
   (peak below `SILENCE_THRESHOLD_DB=-35`).
5. **Merges and relabels speakers.** Per-chunk speaker ids are mapped to letters
   and namespaced by chunk number, producing labels like `1-A`, `9-B` — the same
   scheme visible in `inputs/20260518_audio_diarize.md`. (Speaker identity is only
   stable *within* a chunk; `1-A` and `2-A` are not guaranteed to be the same
   person. See caveat below.)
6. **Writes two outputs** next to the input, in a folder named after it:
   - `<base>_diarize.json` — segments with relative and absolute (epoch) times.
   - `<base>_diarize.md` — the human-readable transcript: `## Chunk N` headers and
     `**[HH:MM:SS --> HH:MM:SS]** **N-X:** text` lines.

## Usage

```bash
export OPENAI_API_KEY=sk-...
./01-transcribe-and-diarize.sh /path/to/day1.mov

# Override the recording start time (epoch or "YYYY-MM-DD HH:MM:SS"):
./01-transcribe-and-diarize.sh -t "2026-05-18 07:50:00" /path/to/day1.mov
```

**Requires:** `ffmpeg`, `ffprobe`, `curl`, `jq`, and `OPENAI_API_KEY`.

## Tunables (top of script)

| Variable | Default | Effect |
|---|---|---|
| `MAX_CHUNK_DURATION` | `600` | Seconds per chunk before splitting. |
| `SILENCE_THRESHOLD_DB` | `-35` | Chunks with a lower peak are skipped as silent. |
| `API_CALL_DELAY` | `0.5` | Seconds between launching parallel API calls. |

## Caveats

- **Diarization is per-chunk.** Speaker letters reset every chunk, so the same
  person gets different labels across chunks. The labels are useful for reading
  turn-taking within a stretch, not for counting distinct people across the day.
- **Timestamps are wall-clock**, derived from the start time in step 2. If `-t` is
  wrong, every timestamp is shifted by the same amount — which also shifts the
  timecodes you would feed into `02-grab-still.sh`.
- The script makes real paid API calls; long videos fan out many parallel
  requests.

## Next step

Pick moments worth illustrating from the transcript, then use
[`02-grab-still.sh`](02-grab-still.sh) to pull the matching frame from the video,
and [`03-generate-howto-docs-prompt.md`](03-generate-howto-docs-prompt.md) to turn
transcript + stills into the how-to guides in `outputs/`.
