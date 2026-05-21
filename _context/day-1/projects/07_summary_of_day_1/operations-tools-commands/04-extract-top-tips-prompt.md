# 04 — Prompt: Extract the instructors' top tips from the Day 1 transcript

The **fourth** operation. Operation 03 turns the transcript into step-by-step
setup guides (the *run-through*). This operation produces the companion piece:
the **conceptual guidance** the instructors gave — the "how to think about LLMs
and harnesses" advice that is woven through the demos rather than stated as a
numbered procedure. Output is `outputs/day-1-top-tips.md` plus a matching
`outputs/day-1-top-tips.html`, linked from `outputs/index.html`.

---

## How to share inputs

Provide Claude with:
- `inputs/20260518_audio_diarize.md` — the full diarized, time-stamped
  transcript. The whole file matters here: tips are scattered across every
  chunk, often as asides during a demo, not collected in one place.
- An existing `outputs/*.html` guide (e.g. `claude-ai-setup.html`) as the
  styling reference for the HTML version.
- `outputs/index.html` — the file to link the new page into.

---

## Prompt

```
Read the entire attached Day 1 workshop transcript — every chunk, not a sample.
It is diarized with wall-clock timecodes; speaker labels reset per chunk, so use
them only to follow turn-taking, never to attribute a quote to a named person.
Refer to the teaching team generically ("the instructors").

I do NOT want a rewrite of the run-through (that already exists). I want the
durable *guidance*: the pro-tips, mental models, and warnings the instructors
kept returning to about how to use LLMs and harnesses well. These are usually
delivered as asides during a live demo, not as a labeled list — you have to
recognize them.

Open with one orientation tip that the run-through only implies: a clear map of
claude.ai vs. Claude Cowork vs. Claude Code — what each can reach on the user's
machine, what each is best for, and a rule of thumb for choosing. You may go
modestly beyond what was said on Day 1 here to give the full picture; flag in
the footer where the doc extends past the session.

Then, for each remaining candidate tip, judge it against these tests, and keep
roughly the top dozen that pass:
- It is advice that changes how the reader works, not a UI click-path.
- The instructors emphasized it, returned to it, or built a whole demo around
  it (e.g. the multiplication / "write the code instead" demo; the cold
  Shakespeare close-reading; the Memento context-window analogy).
- It generalizes beyond the specific demo file or this room.

Write each tip as a short titled section: a one-line imperative heading, then
2–4 sentences of explanation that name the demo or analogy the instructors used
to make the point, and the underlying reason it works. Preserve teaching
analogies when they actually teach. Plain, calm, second-person prose; no hype.

Keep the data-sensitivity guidance accurate and prominent: the HUIT plan is a
temporary bridge; no data above Harvard Level 2 until the Anthropic Enterprise
agreement is in place. Anchor on stable concepts (context window, memory,
models, artifacts, paths) rather than exact button placement.

Then produce an HTML version that matches the styling of the existing
outputs/*.html guides (reuse the same <style> block and page chrome), and add a
card linking to it in outputs/index.html under its own section heading, between
the handouts and the glossary.
```

---

## Output

- `outputs/day-1-top-tips.md` — the tips as markdown, one titled section each.
- `outputs/day-1-top-tips.html` — same content, styled to match the other
  Day 1 guides (shared `<style>` block, `← Day 1 index` topnav).
- An updated `outputs/index.html` with a "Pro-tips" section card linking to the
  new page, and the intro paragraph adjusted to mention it.

Regenerating: overwrite these files in place, don't fork copies (per the
project CLAUDE.md).
