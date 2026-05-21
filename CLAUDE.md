# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Scaffolding for a 4-day workshop series, **"Claude for Teaching, Course Development, and Research,"** run by Marlon Kuzmick (Director of the Learning Lab at Harvard's Bok Center). It is a docs/materials repo — no build system, no package manager, no tests. The series description is in [_context/about-this-workshop/series-overview.md](_context/about-this-workshop/series-overview.md), with one file per day in the same folder.

## Audience modes

Two kinds of people open Claude Code in this repo. Figure out which one is talking to you:

- **Faculty attendees** working through the workshop. They may have never used a code editor before. Default to plain-English explanations, never assume CLI fluency, and point them at the day folder and projects they're working in.
- **Marlon, iterating on workshop materials.** Treat as an experienced collaborator — terse responses, no hand-holding.

When unsure, ask one question to disambiguate.

## Repo layout

- [_context/about-this-workshop/](_context/about-this-workshop/) — series overview and per-day descriptions taken from the Bok Center event page.
- [_context/day-1/](_context/day-1/) — Cowork-era projects. Each project under `projects/` has `inputs/`, `operations-tools-commands/`, `outputs/`.
- [_context/day-2/](_context/day-2/) — Claude Code setup guides (Mac, Windows), the AI glossary, markdown cheatsheet, checklists.
- [_context/day-3/](_context/day-3/) — advanced Claude Code (skills, MCPs, hooks, multi-agent); tools/terms reference and documentation.
- [_context/day-4/](_context/day-4/) — capstone day (currently empty, being built out).
- [_context/read_only/](_context/read_only/) — curated reference material. **Off-limits for writes** (enforced by a hook); read freely.
- `output/` — default destination for any artifact Claude generates. Project-specific outputs in day-1 still go into the project's own `outputs/` subdir.
- `resources/` — currently empty; reserved for shared resources.

## Conventions

- **Never write to `_context/read_only/`.** A `PreToolUse` hook blocks it deterministically; don't try to work around the block.
- **Generated artifacts go in `output/`** at the repo root unless they belong to a specific day-1 project (then use that project's `outputs/`).
- **Don't create top-level markdown files** (READMEs, plans, summaries) unless explicitly asked. Workshop content lives under `_context/`.
- **Package manager: pnpm only** if any tooling ever appears here. Never npm or yarn.
- **No emojis** in any file written to this repo unless explicitly requested.

## Glossary edits (day 2)

The AI glossary at [_context/day-2/ai-glossary/](_context/day-2/ai-glossary/) is maintained as both HTML and Markdown variants. When adding or editing a term, update both — the `/glossary-add` skill handles the format.

## MCP bootstrap (replicate-image)

This repo ships a project-scoped MCP server at [_mcp/replicate_image/](_mcp/replicate_image/) that wraps the Replicate image-generation API. It's registered in `.mcp.json` and points at a Python venv at `_mcp/replicate_image/.venv/bin/python` — that venv is **not** in git, so a freshly cloned repo won't have it yet.

**On session start, check whether `_mcp/replicate_image/.venv/bin/python` exists.** If it doesn't, run:

```
bash _mcp/replicate_image/setup.sh
```

The script is idempotent — it creates the venv, installs dependencies from `requirements.txt`, and verifies imports. After it succeeds, tell the user to restart Claude Code (or run `/mcp reconnect`) so the server is picked up.

Also check whether `.mcp.json` still contains the placeholder string `r8_REPLACE_WITH_YOUR_TOKEN`. If it does, remind the user to paste their real Replicate API token in before reconnecting. Get a token at <https://replicate.com/account/api-tokens>.

If both are already done (venv exists, real token present), say nothing — silence is the right behavior.

The MCP exposes four tools, all prefixed `replicate_`: `replicate_generate_image`, `replicate_run_model`, `replicate_get_model`, `replicate_get_prediction`. Generated images land in `output/` by default.
