# 03 — Prompt: Turn the Day 1 transcript + stills into how-to guides

The **third** operation. Inputs 01 and 02 produce a diarized transcript and a set
of screenshots; this prompt turns them into the participant-facing how-to docs in
`outputs/` (e.g. `claude-ai-setup.md`, `claude-cowork-setup.md`).

---

## How to share inputs

Provide Claude with:
- `inputs/20260518_audio_diarize.md` — the diarized, time-stamped transcript.
- Any stills pulled with `02-grab-still.sh` (note each one's transcript timecode
  so it can be placed at the right step).
- The target audience: Harvard faculty new to Claude, on the HUIT-provided plan.

---

## Prompt

```
I'm turning the attached Day 1 workshop transcript into clean, standalone how-to
guides for faculty who attended (or missed) the session. The transcript is
diarized with wall-clock timecodes; speaker labels reset per chunk, so use them
only to follow turn-taking, not to identify specific people.

Produce one or more task-focused setup guides (not a transcript rewrite). For
each guide:

1. Lead with what the reader is trying to accomplish, not the chronology of the
   session. Reorganize the spoken material into a logical setup sequence.
2. Convert demonstrated actions into numbered, do-this steps. Cut filler, asides,
   logistics ("we'll break for coffee"), and anything specific to the room.
3. Preserve the workshop's framing and analogies when they teach something (e.g.
   the artifact-vs-image-model contrast, "context rot," credits/model choice).
4. Where a screenshot is provided, embed it at the step it illustrates with a
   one-line caption. Reference images by relative path under outputs/.
5. Keep the data-sensitivity guidance prominent and accurate: the HUIT plan is
   temporary, no data above Harvard Level 2 until the Enterprise agreement lands.
6. Note that the UI changes often — anchor on concepts (chats, projects, memory,
   attachments, artifacts, models), and say exact button placement may shift.

Write in plain, calm, second-person prose. No hype. A reader who never attended
should be able to follow it alone.
```

---

## Output

Write the guides to `outputs/` as markdown, one file per coherent task, e.g.:
- `outputs/claude-ai-setup.md` — the browser interface, settings, first artifact.
- `outputs/claude-cowork-setup.md` — the co-working workflow and project layout.

Put any embedded screenshots under `outputs/` (e.g. `outputs/img/`) and link them
with relative paths.
