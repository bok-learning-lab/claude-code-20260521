# Memo template — coder-alignment audit

Use this structure verbatim. Replace bracketed placeholders. Remove a section only if it is empty, and say so when you do.

---

# Coder-alignment audit — [codings directory name]

**Coders compared:** [list, e.g. A. Reyes, M. Tran, J. Whitfield]

**Codings audited:** [list of CSV files, as markdown links, with segment counts]

**Corpus:** [transcripts directory], N = [number of transcripts]

**Shared codebook:** [the union of codes used: `instrumental`, `expressive`, ...]

**Date of audit:** [YYYY-MM-DD]

## How to read this audit

This audit treats coder disagreement as diagnostic, not as error. It does not compute a reliability coefficient and it does not resolve disagreements by majority vote. Every divergence is classified by cause and ends in either a proposed codebook amendment or an item for human adjudication. Agreement between coders is not the same as validity of the codes (Deterding & Waters 2021, p. 734).

## Provenance check

[verify-divergences.py](../verify-divergences.py) confirmed [N] of [M] coded excerpts resolved verbatim to their transcripts at the cited lines. [If any failed: list each one; state that it is excluded from the analysis below.]

## Alignment overview

Navigation aid only — this locates where to look; it is not a reliability score. Counts are taken directly from the checker.

| Respondent | Convergent | Code-divergent | Coverage-divergent |
|---|---|---|---|
| R001 Tasha | | | |
| R002 Marisol | | | |
| R003 Carla | | | |
| R004 Denise | | | |

[One or two sentences on the pattern: where divergence concentrates, and whether that is explained by the corpus design.]

## Convergences worth noting

[One or two bullets on load-bearing agreements — especially convergences that bound a disagreement, so the audit does not overstate how far the codings diverged.]

## Divergences

One entry per non-trivial divergence.

### D-0X — [R00X Pseudonym] L[n] — [short label]

**Coded location:** [R00X L[n]](path#L[n])

**Checker signals:** [classification] — split shape [unanimous / N-1 lone holdout / K-way scatter] — span overlap [overlapping / partial / disjoint / n/a].

**The divergence:**

- **[Coder]** — `[code]` ([confidence]): "[verbatim excerpt]" — "[verbatim memo]"
- **[Coder]** — `[code]` ([confidence]): "[verbatim excerpt]" — "[verbatim memo]"

**Diagnosis:** [D1 definitional / D2 construct-validity / D3 unit-segmentation / C1 benign / C2 coverage gap] — [one or two sentences, citing the split shape and span signals where they bear].

**Suggested resolution:** [specific to the diagnosis; see divergence-typology.md].

[repeat per divergence]

## Codebook amendments proposed

Consolidated D1 and D3 fixes. Each is a suggestion for the team to evaluate, not a change to make unilaterally.

- **[code(s) involved]** — [the proposed sharpened definition or decision rule, stated concretely]. Source: D-0X.

## Adjudication docket

D2 items and genuine interpretive splits. These are not for this skill to settle.

- **[R00X Pseudonym] L[n] (or the broader question)** — [the question the analyst must decide]; [what is at stake]. [Pointer, e.g. run `/find-negative-cases`; consult the corpus design notes]. Source: D-0X.

## Coverage gaps

C2 items — instances one coder caught and others did not. Each should be checked, not assumed wrong.

- **[R00X Pseudonym] L[n]** — coded `[code]` by [coder]; not coded by [coders]. [One line on whether the code plausibly applies.]

## What this audit does not establish

This audit examined where the coders' judgements diverged given a shared codebook. It cannot tell you whether the codebook's constructs are the right ones, or whether a convergent code is a valid one — coders can agree on a code that is wrong. Those questions belong to the analyst, informed by negative-case analysis and by the construct-validity design of the corpus.
