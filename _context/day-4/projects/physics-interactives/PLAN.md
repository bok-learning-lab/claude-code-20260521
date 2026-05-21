# Plan — PhET-style interactive simulations for faculty

A workshop project that pairs a short historical essay with a Claude Code skill (and supporting resources) that helps faculty build PhET-inspired interactive diagrams as single, locally-runnable HTML files.

## Why this project

Faculty in the workshop have all seen PhET simulations in their own teaching, but most of them assume "interactives like that" are out of reach without a software team. They are not, anymore. The collapse in cost between idea and prototype is the central pedagogical point of this project — and it only lands if the artifacts Claude produces are genuinely good, not just shiny.

So the project has two halves:

1. **An essay** ([essay-phet-tradition.md](essay-phet-tradition.md)) that situates PhET in its own history — what these simulations were, what they cost to build, why they worked pedagogically — and explains why faculty-authored interactives are newly possible.
2. **A skill** ([skill-draft/SKILL.md](skill-draft/SKILL.md)) that encodes PhET's design discipline so Claude Code does not just make "flashy interactive things." The skill's purpose is to keep the pedagogical bar high while the technical bar is low.

The essay justifies the skill. The skill is the payoff.

## Hard output contract for the skill

Faculty must be able to **double-click a file and have it run in Chrome.** That constraint is the whole point — it makes the artifact portable (emailable, attachable, Canvas-uploadable, archivable) and removes every dependency that has ever broken faculty workflows in the past.

Specifically:

- **Single `.html` file.** No React, no Next.js, no Vite, no build step, no `npm install`.
- **Runs from `file://` in Chrome.** No local server. No `python -m http.server`.
- **No runtime data fetches.** No JSON, CSV, or asset loading at runtime. Everything the simulation needs is embedded.
- **External CSS via `<link>` is allowed.** Faculty may want to swap in a stylesheet, and CSS does not break the file:// model.
- **External JS via CDN is allowed but discouraged.** If used, the file should still degrade gracefully or be clearly marked as internet-dependent.
- **No emojis** in generated files (per repo convention).

## What the skill must protect against

A faculty member with Claude Code can produce a screen full of sliders and animated particles in five minutes. That is the failure mode, not the goal. The skill's job is to insist on the harder PhET lessons before any code is written:

- Start from the misconception, not the topic.
- Constrain the world deliberately — simplification is the pedagogical move.
- Make the invisible visible.
- Link at least two representations (model, graph, equation, table).
- Show causality immediately and reversibly.
- State the model's limitations as part of the artifact.

See the skill draft for the full pedagogical contract.

## Skills to build (in order)

### 1. `/phet-sim` — author a new simulation from a learning goal

The flagship skill. Drafted in [skill-draft/SKILL.md](skill-draft/SKILL.md). Walks the faculty member through learning-goal articulation first, then produces a single-file HTML simulation that satisfies both the technical and pedagogical contracts.

**Build location (when promoted):** `.claude/skills/phet-sim/`.

### 2. `/phet-critique` — review an existing single-file simulation (planned)

Given an HTML file, score it against the simulation quality rubric: conceptual clarity, interactivity, visual legibility, feedback quality, accessibility, local portability, code maintainability, disciplinary honesty. Output is a critique memo plus a prioritized list of improvements. This is the skill faculty use on their own drafts (or on each other's) before sharing with students.

**Build location (when promoted):** `.claude/skills/phet-critique/`.

### 3. `/phet-port` — convert a static figure or textbook diagram into an interactive (planned)

Given a static image, a description, or an equation, propose what would become manipulable, what would stay fixed, and which linked representations would best teach the concept. Then build it. Most faculty come to this project with a static figure in mind; this skill is the on-ramp.

**Build location (when promoted):** `.claude/skills/phet-port/`.

## Supporting resources (to be drafted alongside the skill)

Under `skill-draft/`:

- `rubrics/simulation-quality-rubric.md` — the scoring rubric used by `/phet-critique` and by the final QC step of `/phet-sim`.
- `rubrics/accessibility-checklist.md` — keyboard navigation, labels, color contrast, projector legibility.
- `rubrics/pedagogical-design-worksheet.md` — the learning-goal-first worksheet `/phet-sim` walks faculty through.
- `templates/single-file-svg-sim.html` — minimal SVG-based starter (good for diagrams, draggable objects, crisp labels).
- `templates/single-file-canvas-sim.html` — minimal Canvas starter (good for particles, fields, fluids, many moving objects).
- `templates/single-file-linked-graph-sim.html` — model + live graph + readout, the canonical PhET layout.
- `examples/` — at least three worked examples spanning STEM and humanities (e.g. projectile motion, SIR epidemiology, rhetorical feedback loop, attention-window visualizer). Examples double as evidence the skill works and as starting points for faculty to adapt.

## Open questions

- **Which examples should ship with the skill?** The STEM examples sell the legitimacy of the lineage. The humanities/social-science examples sell the new possibility. Probably two of each.
- **How aggressive should the skill be about insisting on the learning-goal-first workflow?** Faculty in a workshop setting will want fast gratification. There is a real tension between "produces something in 90 seconds" and "produces something good."
- **Accessibility floor.** What is the minimum we enforce vs. recommend? Keyboard-operable sliders are non-negotiable; full ARIA labeling on SVG is harder to guarantee in a single-file artifact.
- **Offline-first vs. CDN-allowed.** Workshop rooms have wifi but conferences and classrooms often don't. Default should probably be fully self-contained, with CDN as an opt-in.

These are good questions to settle alongside the first draft, not before it.
