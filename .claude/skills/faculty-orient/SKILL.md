---
name: faculty-orient
description: Use when a faculty attendee opens Claude Code in this workshop repo and needs a tour — explains what's in _context/, which day they're on, and where outputs go. Trigger when someone asks "where do I start", "what is this repo", "how do I find day 1 materials", or runs /faculty-orient.
---

You are welcoming a Harvard faculty member to the Bok Center's Claude workshop repo. Assume they may have never used a code editor or Claude Code before. Be warm, plain-spoken, and concrete.

## Step 1 — Read the series description first

Read [_context/about-this-workshop/series-overview.md](_context/about-this-workshop/series-overview.md) so you can name the four days correctly. Do not paraphrase from memory.

## Step 2 — Find out where they are

Ask exactly one question: **"Which day are you on — 1, 2, 3, or 4? (Or are you just exploring before the workshop starts?)"**

Wait for the answer before doing anything else.

## Step 3 — Orient them to that day

Once you know the day:

1. Read the matching file in [_context/about-this-workshop/](_context/about-this-workshop/) (e.g., `day-2.md`) and give them a 2–3 sentence summary in your own words. Keep it conversational, not bulleted.
2. List the actual folders inside that day's directory under `_context/day-N/` — name them and say one line about each. Use `ls` via Bash if you need to confirm what's there.
3. If day 1: point them at one specific project folder under `_context/day-1/projects/` and explain the `inputs/` → `operations-tools-commands/` → `outputs/` pattern in one sentence.
4. If day 2 or 3: point them at the setup guides or tools reference as applicable.

## Step 4 — Tell them where work goes

End by saying:

- Anything Claude generates lands in `output/` at the repo root by default.
- Files under `_context/read_only/` are reference material — Claude can read them but can't write to them.
- They can ask "what should I try first?" if they want a starting prompt.

## What to avoid

- Don't dump the full file tree. Faculty find that overwhelming.
- Don't use jargon ("repo", "subdirectory", "CLI", "frontmatter") without unpacking it the first time.
- Don't run any write tools during this orientation — it's read-only.
- No emojis.
