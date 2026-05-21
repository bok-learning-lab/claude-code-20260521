---
name: reconcile-codings
description: Audit two or more coders' codings of the same interview corpus for alignment and divergence. Verifies excerpt provenance, classifies every disagreement (definitional, construct-validity, unit/segmentation, coverage), and writes a memo with proposed codebook amendments and an adjudication docket. Treats coder disagreement as diagnostic rather than error; does not reduce alignment to a reliability coefficient and does not resolve splits by majority vote. Ships a deterministic Python checker (verify-divergences.py) for the detection step, so the ledger is reproducible. Trigger when the user asks to compare coders, check inter-coder alignment, reconcile codings, run a coder-alignment audit, or runs /reconcile-codings.
---

You are auditing how two or more coders coded the same interview corpus against a shared codebook. Your job is not to score their agreement and not to declare a winner. Your job is to find every place their judgements diverge, explain *why* each divergence happened, and propose either a fix to the codebook or an item for the analyst to adjudicate.

This skill treats coder disagreement the way `/find-negative-cases` treats disconfirming respondents: divergence is data. "Data that diverge from the pattern are not discounted without a clear rationale to do so" (Blee 2009, quoted in Deterding & Waters 2018, p. 731). A minority coder's reading is examined, not outvoted. A disagreement is a signal that a code definition is underspecified, that a construct has a validity problem, or that the coders segmented the talk differently — and each of those has a different remedy.

## What this skill is and is not

**It is** a critical audit of inter-coder alignment that ends in concrete, actionable suggestions.

**It is not** an inter-coder reliability calculation. It does not compute Cohen's kappa or Krippendorff's alpha, and it does not treat an agreement percentage as the result. Deterding & Waters are explicit that frequency counts "are not the proof of theoretical validity" (2021, p. 734). Agreement counts appear in this skill only as a navigation aid, clearly labelled as such.

It does not resolve disagreements by majority vote. Where coders read the same evidence differently and both readings are defensible, the skill flags the item for human adjudication and says what is at stake — it does not pick.

Framing for any user-facing prose: "the coders applied a shared codebook; this audit examines where their judgements diverged" — never "the coders discovered themes."

## Inputs

- **Codings directory** (optional): a directory of per-coder CSV files, one file per coder. Default: `inputs/analysis/` relative to the project root. If the user passes a directory, use it.
- **Corpus directory** (optional): the transcripts, for the provenance check. Default: `inputs/transcripts/`.

Each coder CSV is expected to carry at least `respondent_id`, `line`, `code`, and `excerpt`. Most also carry `coder`, `pseudonym`, `confidence`, and `memo` — use them when present. If a CSV has no `coder` column, take the coder's identity from the filename. Be tolerant of column-name variants (`segment_id`, `transcript_line`, and so on).

All paths in this skill are relative to the project root — the folder containing this `.claude/` directory.

## Step 1 — Load the codings

Enumerate the CSV files in the codings directory and read each one. Establish:

- The **coder set** — who coded.
- The **shared codebook** — the union of `code` values used across all coders. If coders used visibly different code vocabularies, say so: that is a finding in itself, and it means the codings are not from a shared codebook, which weakens the rest of the audit.
- The **schema** — whether `confidence` and `memo` fields are available.

## Step 2 — Run the deterministic checker

Run the bundled script from the project root:

```
python3 .claude/skills/reconcile-codings/verify-divergences.py --codings <codings-dir> --transcripts <corpus-dir>
```

It prints a **divergence ledger** — the reproducible, non-interpretive backbone of the audit. Reason on top of the ledger; do not re-derive it by hand. Anyone can re-run the script to verify a memo's divergence list.

What the script settles deterministically, so you do not have to:

- **Provenance** — whether each `excerpt` is verbatim in its transcript at the stated `line`.
- **Location grouping** — segments keyed by `respondent_id` + `line`. (For a corpus where turns span multiple lines, the line key would need replacing; this corpus has one turn per line.)
- **Classification** — each location is `convergent`, `code-divergent` (all coders present, code sets differ), or `coverage-divergent` (some coder did not code the location at all).
- **Split shape** — `unanimous`, `N-1 (lone holdout)`, or `K-way scatter`. With three or more coders this distinguishes a near-consensus with one dissenter from a full scatter — a distinction a binary convergent/divergent label loses.
- **Span overlap** — for differently-coded segments, whether the coders' excerpts cover the same stretch of talk (`overlapping`), partly (`partial`), or different stretches (`disjoint`). Excerpts need not be identical; overlap is scored by character-range containment within the line, and `--overlap-threshold` tunes the cutoff.

If the script reports warnings (missing columns, unreadable files), resolve those before continuing.

## Step 3 — Read the provenance result

Take the provenance line from the script output: "N of M coded excerpts resolved verbatim." Any excerpt that did not resolve is **excluded from the alignment analysis** — you cannot audit alignment on a quote that is not in the data. A failed provenance check is a serious finding; surface it at the top of the memo.

## Step 4 — Diagnose each divergence

The script found *where* the divergences are and *what shape* they take. Your job is to determine *why* each one happened — the interpretive core of the skill.

For every non-convergent location in the ledger, assign a diagnosis using [divergence-typology.md](divergence-typology.md):

- **Code-divergences** resolve to D1 (definitional), D2 (construct-validity), or D3 (unit/segmentation).
- **Coverage-divergences** resolve to C1 (benign exemplar choice — the code is applied elsewhere by the other coders for the same respondent) or C2 (coverage gap — an instance one coder caught and others missed).

Use the script's signals as evidence:

- **Split shape.** A `lone holdout` (N-1) tends toward C2 or D1 — one coder read a definition or an instance differently from a settled group; read the holdout's memo first. A `K-way scatter` is a stronger signal of D2 — if the segment were unambiguous under the codebook, the coders would not have scattered.
- **Span overlap.** `disjoint` differently-coded segments point to D3 — the coders coded different stretches of talk, so they may not be in conflict at all. `overlapping` segments mean the coders looked at the same words and still differed — D1 or D2, or D3 by double-coding.

The script is built for high recall and can over-flag: a location where coders agree the code applies but one also added a second code will surface as `code-divergent`. On inspection that may be a benign C1-style difference — say so. The script detects; you supply the precision.

Note **confidence spread** (the script reports it) as an overlay: a location coded the same way but at `low` by one coder and `high` by another is worth a sentence.

The diagnosis is the heart of the skill. The same surface fact — "coders used different codes" — has several causes and several remedies. Get the diagnosis right and the resolution follows.

## Step 5 — Write each divergence entry

For every non-trivial divergence, write an entry containing:

- The coded location, as a clickable line reference.
- The **checker signals** for that location: its classification, split shape, and span-overlap value, copied from the ledger.
- The divergence laid out coder by coder: each coder's code, confidence, the verbatim excerpt they chose, and their memo. Quote the excerpts and memos exactly — do not paraphrase.
- The **diagnosis** (D1 / D2 / D3 / C1 / C2), with a sentence or two of reasoning that cites the split shape and span signals where they bear.
- The **suggested resolution**, specific to the diagnosis:
  - **D1 definitional** — a concrete proposed codebook edit: a sharpened definition or an if/then decision rule that would have prevented the split.
  - **D2 construct-validity** — do not propose a code. Flag the item for the analyst, recommend a construct-level coding rule (for example, "code on the respondent's reasoning, not their vocabulary"), and recommend a construct-validity pass. Cross-reference `/find-negative-cases` and the corpus design notes.
  - **D3 unit/segmentation** — a segmentation convention and/or a double-coding policy.
  - **C2 coverage gap** — name the missed instance and recommend the other coders evaluate it against the existing codebook.

## Step 6 — Consolidate

Pull the per-entry resolutions into three closing sections:

- **Codebook amendments proposed** — every D1 and D3 fix, written as concrete edits the team could adopt.
- **Adjudication docket** — every D2 item and every genuine interpretive split, written as a question the analyst must decide, with what is at stake. These are not for the skill to settle.
- **Coverage gaps** — the C2 items.

## Step 7 — Write the alignment overview

Produce a short per-respondent table: counts of convergent, code-divergent, and coverage-divergent locations. Take the counts directly from the script's overview table — do not hand-tabulate them. Introduce the table with one sentence stating plainly that this is a navigation aid for finding where to look, not a reliability score, and that agreement does not establish validity (Deterding & Waters 2021, p. 734). If divergence clusters on particular respondents, say so and ask why — that pattern is itself a finding.

## Step 8 — Write the memo

Write to `output/alignment/<slug>-alignment-audit.md`, where `<slug>` is the codings directory name (for example, `analysis`). Create `output/alignment/` if it does not exist. Use the structure in [memo-template.md](memo-template.md).

Then report back to the user in 4-8 lines: where the memo is, the provenance result, how many divergences of each type, and the single most important item on the adjudication docket.

## Hard constraints

- **Disagreement is diagnostic, not error.** Do not "correct" a coder. Do not resolve a split by majority vote. Do not compute a reliability coefficient and stop.
- **Examine the minority reading.** A code used by only one coder gets the same scrutiny as the majority's — the Blee principle the project already applies to respondents applies here to coders.
- **Verbatim excerpts and memos.** Quote what the coders wrote exactly. Report the provenance result honestly.
- **Run the checker.** The provenance result, the location classifications, the split shapes, and the overview counts come from `verify-divergences.py`, not from hand-tabulation. Re-running the script must reproduce the memo's ledger.
- **Preserve respondent IDs and pseudonyms** exactly (R001 Tasha, R002 Marisol, R003 Carla, R004 Denise).
- **No emojis.** No "discovering themes" framing. The coders applied a shared codebook; this audit examines their judgements.
- **Use markdown link syntax** for every file and line reference, so they are clickable in the IDE.
- **Suggestions, not verdicts.** The codebook amendments and adjudication items are for the team to evaluate. The analyst decides; the skill surfaces.

## When inputs are missing or unusable

- If the codings directory has fewer than two CSV files, say so and stop — there is nothing to compare.
- If the CSVs use different code vocabularies, report that as the primary finding; a meaningful alignment audit needs a shared codebook.
- If the provenance check fails for a large share of excerpts, lead with that and recommend fixing the codings before the alignment audit is trusted.

## See also

- [verify-divergences.py](verify-divergences.py) — the deterministic checker: provenance, location grouping, classification, split shape, and excerpt-overlap signal. Standard library only; run with `--help` for options.
- [divergence-typology.md](divergence-typology.md) — the D1/D2/D3 and C1/C2 classification, the split-shape and span-overlap signals, the resolution playbook, and citations.
- [memo-template.md](memo-template.md) — the output structure.
- [examples/analysis-alignment-audit.md](examples/analysis-alignment-audit.md) — a worked audit of the three codings in `inputs/analysis/`.
