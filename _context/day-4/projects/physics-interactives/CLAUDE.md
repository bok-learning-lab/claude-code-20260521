# CLAUDE.md

This file gives Claude Code project-specific instructions when working inside this folder.

## What this project is

A self-contained bundle for making **PhET-style interactive simulations** — single-file HTML pages that a faculty member can build with Claude Code, double-click to open in Chrome, and share with students without any setup. The project ships with:

- An essay explaining why this kind of artifact was historically out of reach for individual faculty, and why it isn't anymore: [essay-phet-tradition.md](essay-phet-tradition.md).
- A skill (`/phet-sim`) that runs a structured pedagogical interview before generating each simulation, plus rubrics and templates that keep quality high.
- Worked examples a faculty member can adapt for their own course.

The full project plan is in [PLAN.md](PLAN.md).

This folder is designed to be **grabbable**. A physics faculty member can take just this directory, open Claude Code inside it, and start making teaching interactives without needing the rest of the workshop repo. Skills live in the *project's own* `.claude/skills/` directory, not at the repo root.

## Audience modes

Two kinds of people open Claude Code here:

- **Faculty making their own interactive.** They may never have touched a code editor before. Default to plain-English explanations and don't assume CLI or git fluency. Their natural first move is to invoke the `/phet-sim` skill and answer its questions — or to fill out [skill-draft/rubrics/pedagogical-design-worksheet.md](skill-draft/rubrics/pedagogical-design-worksheet.md) on paper first if they want to think through the design before any code is written.
- **Marlon (or another collaborator) iterating on the skill itself or its examples.** Terse responses, no hand-holding. They're working from [PLAN.md](PLAN.md).

If it's unclear which mode applies, ask one question to disambiguate.

## Output contract (hard rules)

Every simulation produced by this project must satisfy these properties. They are the whole point of the project — they make the resulting file portable, emailable, Canvas-uploadable, and viewable on any laptop without setup.

- **Single `.html` file**, opens by double-click in Chrome from `file://`.
- **No React, Vue, Vite, Next.js, `npm install`, or any build step.**
- **No runtime data fetches.** No `fetch`, no `XMLHttpRequest`, no loading of JSON/CSV/images/audio at runtime. Everything the simulation needs is embedded inline or generated in code.
- **External CSS via `<link>` is allowed.** External JS via CDN is allowed but discouraged; if used, mark it in the file's header comment.
- **No emojis** anywhere in any file (matches the workshop repo's convention).
- **Header comment captures the design record** — learning goal, target learner, core misconception, manipulables, hidden variables, representations, prompts, limitations, classroom use, date.

If a user explicitly overrides one of these rules (e.g. "I'm fine with a CDN dependency for this one"), proceed but mark the deviation in the file's header.

## Layout

```text
physics-interactives/
  CLAUDE.md                                — this file
  PLAN.md                                  — project plan; read first if iterating on the skill
  essay-phet-tradition.md                  — historical context for the design tradition

  skill-draft/                             — working copy; promoted to .claude/skills/ in Phase 4
    SKILL.md                               — the /phet-sim skill (draft)
    rubrics/
      simulation-quality-rubric.md         — 8 dimensions, 0/1/2 scoring; QC pass uses this
      accessibility-checklist.md           — keyboard, labels, contrast, sizing floor
      pedagogical-design-worksheet.md      — paper-friendly version of the 10-question interview
    templates/
      single-file-svg-sim.html             — minimal SVG starter (default choice)
      single-file-canvas-sim.html          — Canvas starter (particle systems, fields)
      single-file-linked-graph-sim.html    — canonical PhET layout: model + live graph
    examples/                              — worked examples (to be added in PLAN Phase 3)

  .claude/skills/                          — promoted skills land here (PLAN Phase 4)
    phet-sim/                              — primary skill
    phet-critique/                         — sibling: review an existing .html
    phet-port/                             — sibling: convert a static figure to an interactive

  output/                                  — generated simulations land here when this project
                                             is opened standalone
```

## The skills

- **`/phet-sim`** — author a new simulation from a learning goal. Runs a structured pedagogical interview (10 questions covering goal, learner, misconception, manipulables, hidden variables, representations, feedback, prompts, limitations, classroom use) *before* writing any code. Produces a single-file HTML that satisfies the output contract above. Self-scores against [skill-draft/rubrics/simulation-quality-rubric.md](skill-draft/rubrics/simulation-quality-rubric.md) and reports the score; refuses to declare a simulation done if it scores below 12/16 or scores 0 on any dimension.

  *Status:* draft at [skill-draft/SKILL.md](skill-draft/SKILL.md). Will be promoted to `.claude/skills/phet-sim/` once the worked examples in PLAN Phase 3 have exercised it.

- **`/phet-critique`** *(planned)* — score an existing `.html` against the rubric and accessibility checklist; produce a critique memo with a prioritized list of improvements.

- **`/phet-port`** *(planned)* — take a static figure, description, or equation and propose the manipulable / fixed / linked-representation decomposition, then build the interactive. The on-ramp skill for faculty who arrive with a textbook diagram in mind.

## Generated outputs

- **When this folder is opened standalone** (faculty workflow): generated `.html` files go in this project's own `output/` directory.
- **When opened from inside the larger workshop repo:** generated `.html` files go in the repo-root `output/physics-interactives/` directory instead, matching the workshop's overall convention.

In both cases, the design record stays embedded as a header comment inside the `.html` file. Do not write a separate metadata file alongside.

## Session-start checks

On session start, in this order:

1. Check whether `.claude/skills/phet-sim/SKILL.md` exists.
   - If it does, the skill is invokable as `/phet-sim`. Silence is correct.
   - If it does not, the skill is still in draft form. Mention this to the user once, point to [skill-draft/SKILL.md](skill-draft/SKILL.md), and offer to invoke the workflow from the draft.
2. Make sure an `output/` directory exists (project-local if running standalone, repo-root `output/physics-interactives/` if running from the workshop repo). Create it lazily when the first generation is requested.

If both are in place and the user hasn't asked a question, say nothing — silence is the right behavior.
