# Divergence typology — diagnosing coder disagreement

A reference for `/reconcile-codings`. The skill's central claim: "coders used different codes" is a *symptom*, and it has three distinct underlying causes, each with its own remedy. Diagnosing the cause is the analytic work — and the checker's split-shape and span-overlap signals are the evidence for it. This file defines the categories, the signals, and the resolution playbook.

## Why disagreement is treated as data

Deterding & Waters (2018) build flexible coding around transparency and the explicit treatment of divergence. Their Stage 3 rigor move — negative-case analysis — rests on Blee's standard: "Data that diverge from the pattern are not discounted without a clear rationale to do so" (Blee 2009, quoted p. 731). This skill applies the same standard one level up: divergence *between coders* is not averaged away or outvoted. It is examined, because it usually reveals something about the codebook or the constructs that a clean agreement score would have hidden.

This is also why the skill does not compute a reliability coefficient. A kappa of 0.7 tells you how often coders agreed; it tells you nothing about *why* they disagreed the other 30 percent of the time, and Deterding & Waters caution that such counts "are not the proof of theoretical validity" (2021, p. 734). The disagreements are where the information is.

## The two top-level patterns

For any location coded by two or more coders:

| Pattern | Definition |
|---|---|
| **Code-divergent** | Coders applied different codes to the same location. |
| **Coverage-divergent** | Some coders coded the location; others did not code it at all. |

A location everyone coded the same way is **convergent** and needs no entry, though load-bearing convergences are worth noting (see below).

## Code-divergence: three diagnoses

### D1 — Definitional

The coders disagree because the **code definitions overlap or are underspecified**. Both codes are plausibly correct because the codebook never said which one wins in this situation. The disagreement is in the codebook, not in the data.

*Signature:* you can write the missing rule. If you can state an if/then ("when a segment names a cost only to dismiss it, code X") that would have produced agreement, it is D1.

*Resolution:* a codebook amendment — a sharpened definition or an explicit decision rule. This is the most fixable kind of divergence.

### D2 — Construct-validity

The coders disagree because the **segment itself is ambiguous about the construct** — most often, surface vocabulary points one way and underlying reasoning points another. The disagreement is not a codebook bug; it is a true property of the data, and it is diagnostic of a possible problem with the construct.

*Signature:* both readings are defensible *and* the ambiguity is in the respondent's talk, not in the code definitions. Tightening a definition will not dissolve it.

*Resolution:* do not force a code and do not vote. Flag the item for the analyst. Recommend a construct-level coding rule (typically: code on the respondent's reasoning, not their vocabulary) and a construct-validity pass over the corpus. This is the same move `/find-negative-cases` makes — a D2 divergence often marks exactly the respondent who is a negative case.

### D3 — Unit / segmentation

The coders disagree because they **segmented the talk differently** — different excerpt boundaries, or one coder double-coded a span that another split or single-coded. They may not actually disagree about the meaning at all; they disagree about what the unit of analysis is.

*Signature:* the codes differ but each is defensible *for the span that coder marked*. Move the boundary and the disagreement moves or disappears.

*Resolution:* a segmentation convention (where a unit starts and stops) and/or a double-coding policy (when a span legitimately carries two codes). A useful sub-rule: when a respondent glosses their own term, the gloss belongs inside the unit.

## Coverage-divergence: two diagnoses

### C1 — Benign exemplar choice

One coder coded a location the others did not, but the others applied **the same code elsewhere for the same respondent**. The coders agree the code is present; they just chose different quotes to evidence it. This is not a disagreement.

*Resolution:* none. Note it so the reader knows it was checked.

### C2 — Coverage gap

One coder coded a location the others did not, and the others have **no instance of that code for that respondent at all**. One coder caught something the others missed.

*Resolution:* name the missed instance and recommend the other coders evaluate it against the existing codebook. A gap is not automatically an error — the others may have considered and rejected it — but it should be checked, not left silent.

## Split shape

The checker reports the *shape* of every split — how the coders partition into code sets. With three or more coders the shape carries information a binary convergent/divergent label loses.

- **Unanimous** — every coder who coded the location used the same code set. Not a divergence.
- **Lone holdout (N-1)** — all coders but one agree; one differs. A settled group plus a single dissenter usually points to **D1** (the holdout applied a definition differently) or, if the holdout simply did not code something the others did, **C2**. The holdout's memo is the first place to look.
- **K-way scatter (1-1-1, ...)** — every coder differs. Scatter is a stronger signal of **D2**: if the segment were unambiguous under the codebook, the coders would not have spread out. Scatter can also be severe **D1** — the definitions are badly underspecified — and the two are told apart by the memos: in a D2 scatter the coders disagree about what the segment *means*; in a D1 scatter they agree on the meaning and disagree only on which code records it.

Shape is a lead, not a verdict. Confirm it against the excerpts and memos.

## Span overlap

The checker also reports, for differently-coded segments, how much the coders' chosen excerpts overlap — scored by character-range containment within the transcript line, so excerpts need not be identical to count as the same stretch of talk.

- **Overlapping** — the coders coded essentially the same words and still applied different codes. The disagreement is real: **D1** or **D2**, or **D3** by double-coding (one coder added a second code to the same span).
- **Disjoint** — the coders coded different stretches of the same turn. They may not be in conflict at all; this is the signature of **D3** (segmentation), or of a coverage difference where one coder also tagged a neighbouring sentence.
- **Partial** — the excerpts overlap but not fully. Inspect directly.

A useful pairing: *disjoint + lone holdout* often means one coder simply coded an extra sentence (benign — see C1); *overlapping + scatter* on a single span is the case that most often needs adjudication.

## Confidence spread

When coders converge on a code but recorded different confidence levels, that is not a divergence. But a wide spread (one coder `low`, another `high`) flags a segment that felt obvious to one coder and marginal to another — often a quiet D1 or D2 in the making. Note these; do not make full entries of them unless the spread is large.

## Convergences worth noting

Not every agreement is uninformative. A convergence is worth a sentence when it **bounds a disagreement** — for example, if coders split on a respondent's ambiguous lines but all agree on that respondent's most explicit line, the disagreement is localized rather than global. Saying so keeps the audit honest: it does not let a few vivid disagreements imply the whole coding fell apart.

## A note on what the audit cannot do

This typology diagnoses *disagreement*. It cannot diagnose *shared error*: if every coder applies the same code to the same segment and they are all wrong, this skill will record a convergence and move on. Agreement is consistency, not validity. The validity of the constructs themselves is settled by the analyst through negative-case analysis and construct-validity checks, not by inter-coder comparison.

## Citations

- Deterding, N. M., & Waters, M. C. (2018). Flexible Coding of In-Depth Interviews: A Twenty-First-Century Approach. *Sociological Methods & Research*. Transparency and Stage 3 negative-case analysis, p. 731.
- Deterding, N. M., & Waters, M. C. (2021). Frequency counts "are not the proof of theoretical validity," p. 734 (as cited in this project's `CLAUDE.md`).
- Blee, K. M. (2009). *Democracy in the Making*. The "diverge from the pattern" standard.
