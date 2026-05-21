# Coder-alignment audit — analysis

**Coders compared:** A. Reyes, M. Tran, J. Whitfield

**Codings audited:** [coder-1-reyes.csv](../../../../inputs/analysis/coder-1-reyes.csv) (22 segments), [coder-2-tran.csv](../../../../inputs/analysis/coder-2-tran.csv) (24 segments), [coder-3-whitfield.csv](../../../../inputs/analysis/coder-3-whitfield.csv) (27 segments)

**Corpus:** [inputs/transcripts/](../../../../inputs/transcripts/), N = 4

**Shared codebook:** `instrumental`, `expressive`, `cost-risk`, `own-education`, `info-seeking`, `worry`, `child-sorting`

**Date of audit:** 2026-05-21

## How to read this audit

This audit treats coder disagreement as diagnostic, not as error. It does not compute a reliability coefficient and it does not resolve disagreements by majority vote. Every divergence is classified by cause and ends in either a proposed codebook amendment or an item for human adjudication. Agreement between coders is not the same as validity of the codes (Deterding & Waters 2021, p. 734).

The detection is deterministic. The provenance result, the location classifications, the split shapes, and the excerpt-overlap signals below all come from the bundled checker [verify-divergences.py](../verify-divergences.py); re-running it reproduces this ledger. The diagnosis of *why* each divergence happened, and the resolutions, are the interpretive layer on top.

## Provenance check

[verify-divergences.py](../verify-divergences.py) confirmed **73 of 73** coded excerpts resolved verbatim to their transcripts at the cited lines. No fabricated or misattributed quotes. The alignment analysis below rests on a clean corpus.

## Alignment overview

Navigation aid only — this locates where to look; it is not a reliability score. Counts are taken directly from the checker. "Locations" are respondent turns (one per transcript line); a location can carry more than one code.

| Respondent | Convergent | Code-divergent | Coverage-divergent |
|---|---|---|---|
| R001 Tasha | 6 | 1 | 3 |
| R002 Marisol | 4 | 1 | 2 |
| R003 Carla | 0 | 1 | 4 |
| R004 Denise | 1 | 2 | 2 |
| **Total** | **11** | **5** | **11** |

The pattern is not random. Divergence is sparse for R001 (Tasha) and R002 (Marisol) — the corpus's textbook instrumental and expressive cases — and concentrates on R003 (Carla) and R004 (Denise). Per [inputs/README.md](../../../../inputs/README.md), those are exactly the two transcripts designed to be hard: Carla as a self-aware mixed case, Denise as a construct-validity stress test.

Two features of the table are worth stating outright. First, **R003 has no fully convergent location at all** — on the mixed case the three coders rarely coded the same line, and where all three did (L38) they still differed. Second, of Carla's five divergences only one is a code disagreement; the other four are coverage differences. On the mixed case the coders diverged more on *what to code* than on *how to code it*.

## Convergences worth noting

- **R001 and R002 are coded almost identically by all three.** Every explicit definitional line — Tasha's "College is for getting a job. That's what it is now." ([R001 L46](../../../../inputs/transcripts/R001-Transcript.md#L46)) and Marisol's "It's for becoming." ([R002 L34](../../../../inputs/transcripts/R002-Transcript.md#L34)) — drew the same code at high confidence from all three coders. The codebook works cleanly on unambiguous cases.
- **The Denise disagreement is bounded.** Despite splitting on Denise's framing (D-05, D-06), all three coders coded her most explicit line — "Terrance didn't study what he loved. He studied what worked." ([R004 L54](../../../../inputs/transcripts/R004-Transcript.md#L54)) — as `instrumental` at high confidence, including M. Tran, who reads Denise as partly expressive elsewhere. The divergence on Denise is localized to her surface-vocabulary lines, not global.

## Divergences

The checker flagged 16 non-convergent locations. This section writes up the six that need a decision or a codebook change; the remaining ten coverage differences are listed under Coverage gaps below.

### D-01 — R001 Tasha L42 — "I'm not paying for exploring"

**Coded location:** [R001 L42](../../../../inputs/transcripts/R001-Transcript.md#L42)

**Checker signals:** code-divergent — split shape `1-1-1 (K-way scatter)` — span overlap `overlapping` (all three coders coded the identical excerpt).

**The divergence:**

- **A. Reyes** — `child-sorting` (medium): "If she wants to do that — okay. But she's gotta know what she's going for. I'm not paying for \"exploring.\"" — "Coded child-sorting rather than instrumental: the segment is about differentiating Aaliyah's path from Jamir's. The instrumental condition is the criterion, not the focus."
- **M. Tran** — `instrumental` (high): same excerpt — "Coded instrumental: even the four-year path is justified by knowing the job outcome in advance."
- **J. Whitfield** — `instrumental` (medium) and `child-sorting` (medium), double-coded: same excerpt — "the four-year path is conditioned on a known job outcome" / "the same segment also differentiates Aaliyah's path from Jamir's."

**Diagnosis:** D3 — unit/segmentation. The `overlapping` span confirms all three looked at the identical words, so this is not a coverage or exemplar difference. But Reyes and Tran are not contradicting each other — each named a true aspect of the span, and Whitfield named both. The code definitions are not in conflict; the open question is whether one span may carry two codes.

**Suggested resolution:** Adopt an explicit double-coding policy. A span that simultaneously sorts children onto distinct paths *and* states an instrumental criterion should receive both `child-sorting` and `instrumental`, as Whitfield did. This converts the scatter into agreement without anyone changing their reading.

### D-02 — R002 Marisol L46 — "invest in your children" / loans

**Coded location:** [R002 L46](../../../../inputs/transcripts/R002-Transcript.md#L46)

**Checker signals:** code-divergent — split shape `1-1-1 (K-way scatter)` — span overlap `overlapping` (all three coded the identical excerpt).

**The divergence:**

- **A. Reyes** — `expressive` (medium): "I think you have to invest in your children. If she has to take some loans, she'll pay them back." — "Judgement call: although loans are mentioned, the segment subordinates cost to the expressive goal. Coded expressive, not cost-risk."
- **M. Tran** — `cost-risk` (low): same excerpt — "Coded cost-risk because the segment addresses loans and repayment, though her stance is to dismiss the cost. Low confidence — borderline with expressive."
- **J. Whitfield** — `expressive` (medium) and `cost-risk` (low), double-coded: same excerpt — "she raises cost only to dismiss it in favour of the goal" / "the segment does engage loans and repayment. Flagged for team adjudication; defensible either way."

**Diagnosis:** D1 — definitional. The split shape is a scatter, which often signals construct-validity trouble (D2) — but here it does not. The three memos all *read the segment the same way*: Marisol names a cost in order to dismiss it. They disagree only on how to code that reading, because the codebook does not say what to do when a segment raises a cost concern and then subordinates it. The disagreement is in the codebook, not in the data. The low and medium confidence ratings, plus Whitfield's "defensible either way," confirm the coders felt the gap.

**Suggested resolution:** Amend the codebook. Add a decision rule to `cost-risk`: a segment is coded `cost-risk` only when cost or debt is treated as a live constraint on the decision; a segment that names a cost solely to reject its relevance is coded for the rationale that overrides it (here, `expressive`). Under this rule the segment is `expressive`, single-coded.

### D-03 — R003 Carla L38 — the "two voices" (checker over-flag)

**Coded location:** [R003 L38](../../../../inputs/transcripts/R003-Transcript.md#L38)

**Checker signals:** code-divergent — split shape `2-1 (lone holdout)` — span overlap `disjoint`.

**The divergence:**

- **A. Reyes** — `expressive` (medium) on "the first voice, the \"go explore\" voice, that's — I think that's what I believe in my heart." and `instrumental` (high) on "we cannot afford to be romantic about this. He has to come out the other side with a job. Because there's no safety net."
- **J. Whitfield** — `expressive` (high) and `instrumental` (high), the same two sentences.
- **M. Tran** — `expressive` (high) only, on "the first voice ..." — Tran did not code the instrumental sentence at L38.

**Diagnosis:** C1 — benign. The checker flags this `code-divergent` because, location by location, Tran's code set for L38 (`expressive`) differs from Reyes's and Whitfield's (`expressive` + `instrumental`). The two signals tell the real story: a `lone holdout` on `disjoint` spans. Tran coded one sentence of the turn where the others coded two — and Tran did code Carla's instrumental voice, at [L34](../../../../inputs/transcripts/R003-Transcript.md#L34), not L38. There is no contradiction. This is the checker working as designed: it is built for high recall and will surface a difference like this; the analyst supplies the precision.

**Suggested resolution:** None required — record it as checked and benign. The segmentation convention proposed under D-01 would also tidy the ledger here, by settling whether the instrumental sentence at L38 is its own unit.

### D-04 — R003 Carla L70 — "not as sure as I sound"

**Coded location:** [R003 L70](../../../../inputs/transcripts/R003-Transcript.md#L70)

**Checker signals:** coverage-divergent — split shape `single-coder` — span overlap `n/a`.

**The divergence:**

- **M. Tran** — `worry` (medium): "write down that I'm not as sure of any of this as I sound." — "Coded worry: she asks the interviewer to record her uncertainty."
- **A. Reyes** — did not code this location.
- **J. Whitfield** — did not code this location.

**Diagnosis:** D1 — definitional, surfaced as a coverage divergence. Only one coder coded the line, so the checker classes it coverage-divergent. But the reason the other two left it uncoded is informative: the segment is not a worry about a barrier or an outcome — it is Carla's *epistemic* uncertainty about her own views. The codebook's `worry` does not say whether it covers that. Tran stretched `worry` to reach it; Reyes and Whitfield, on this reading, had nowhere to put it.

**Suggested resolution:** Clarify the scope of `worry` in the codebook: state whether it covers only worries about barriers and outcomes (Section 6 of the protocol) or also a respondent's expressed uncertainty about her own position. If the latter is out of scope, the team should decide whether a segment like this is simply uncoded or warrants a new code — a question for the docket, not for this skill.

### D-05 — R004 Denise L46 — what college "means"

**Coded location:** [R004 L46](../../../../inputs/transcripts/R004-Transcript.md#L46)

**Checker signals:** code-divergent — split shape `1-1-1 (K-way scatter)` — span overlap `overlapping` (Reyes and Whitfield disagreed on the identical excerpt; Tran selected a different excerpt from the same line).

**The divergence:**

- **A. Reyes** — `instrumental` (medium): "College means a different life. It means your kids don't worry about lights getting cut off." — "Construct-validity check advised: surface phrasing (\"a different life\") reads expressive, but the stated content is material security. Coded instrumental on the content."
- **M. Tran** — `expressive` (high): "College is — it's the thing that breaks the cycle." — "Coded expressive: aspirational, transformational language about what college means."
- **J. Whitfield** — `instrumental` (medium) and `expressive` (low), double-coded: "College means a different life. It means your kids don't worry about lights getting cut off." — "the stated content is material security" / "the surface register (\"a different life\") is aspirational. Genuine ambivalence; flagged for team adjudication."

**Diagnosis:** D2 — construct-validity. This is not a codebook gap. Denise's talk points two ways at once: the vocabulary ("a different life," "breaks the cycle") is aspirational and reads expressive, while the stated content (lights getting cut off, bills, security) is material and reads instrumental. The `overlapping` signal is the tell — Reyes and Whitfield applied opposite codes to the *identical* words, so no definition can be sharpened to dissolve it; the ambiguity is in the data. Reyes named it outright ("construct-validity check advised"); Whitfield flagged it for adjudication. The [R004 transcript frontmatter](../../../../inputs/transcripts/R004-Transcript.md) confirms the case was designed as a construct-validity stress test.

**Suggested resolution:** Do not resolve this by vote. Send it to the adjudication docket. The decision the team must make is a construct-level one — whether the typology codes track the respondent's *reasoning* or her *vocabulary* — and it should be made once, explicitly, for the whole corpus, not re-litigated segment by segment. See the docket below.

### D-06 — R004 Denise L62 — "college is sacred"

**Coded location:** [R004 L62](../../../../inputs/transcripts/R004-Transcript.md#L62)

**Checker signals:** code-divergent — split shape `1-1-1 (K-way scatter)` — span overlap `disjoint`.

**The divergence:**

- **A. Reyes** — `instrumental` (medium): "sacred means you take it seriously. Sacred means you don't waste it. You go for a reason. You come out with a credential that opens a door." — "Coded the passage where the respondent herself glosses \"sacred\" — the gloss is instrumental (a credential that opens a door). Did not code the bare \"college is sacred\" line in isolation."
- **M. Tran** — `expressive` (high): "I think college is sacred. I do." — "Coded expressive: she calls college sacred and the most important thing her son can do — an elevated, non-instrumental framing."
- **J. Whitfield** — `instrumental` (medium) on the gloss and `expressive` (low) on the bare line, double-coded — "Her own gloss of \"sacred\" is instrumental — a credential that opens a door." / "Coded expressive against the surface language, low confidence. Note: respondent later qualifies \"sacred\" instrumentally (see JW-26). Flagged for adjudication."

**Diagnosis:** D2 — construct-validity, with a D3 mechanism. The construct-validity ambiguity is the same as D-05. But here the checker reports the spans as `disjoint`, and that is diagnostic: the coders coded *different sentences*. Code "I think college is sacred. I do." in isolation and it reads `expressive`; code Denise's very next sentences, where she glosses her own word — "sacred means ... a credential that opens a door" — and it reads `instrumental`. The excerpt boundary decided the code. Reyes states this explicitly in her memo. So D-06 carries the D-05 construct question *plus* a segmentation problem D-05 did not have.

**Suggested resolution:** Two parts. (1) The construct-validity question goes to the adjudication docket with D-05 — it is the same question. (2) Adopt a segmentation rule that would have prevented the `disjoint` half of this split: when a respondent glosses their own term, the gloss is part of the unit and must be coded with it. A bare-term excerpt that omits the respondent's own immediate clarification is an incomplete unit.

## Codebook amendments proposed

Each is a suggestion for the team to evaluate, not a change to make unilaterally.

- **`cost-risk` (decision rule)** — Code `cost-risk` only when cost or debt is treated as a live constraint on the decision. A segment that names a cost solely to reject its relevance is coded for the overriding rationale instead. Source: D-02.
- **Double-coding policy** — A single span may carry two codes when it does two analytically distinct things at once (for example, sorts children onto paths *and* states an instrumental criterion). Adopt this rather than forcing a single code. Source: D-01 (and it would tidy D-03).
- **Segmentation rule (self-gloss)** — When a respondent glosses their own term, the gloss belongs inside the coded unit. Do not code a bare-term excerpt that omits the respondent's own immediate clarification. Source: D-06.
- **`worry` (scope clarification)** — State whether `worry` covers only worries about barriers and outcomes, or also a respondent's epistemic uncertainty about her own views. Source: D-04.

## Adjudication docket

These are not for this skill to settle. Each needs a human decision.

- **R004 Denise — the reasoning-versus-vocabulary question (D-05, D-06).** Decide, once and for the whole corpus: do the `instrumental` and `expressive` codes track the respondent's underlying reasoning or her surface vocabulary? Denise is the case that forces the question — her reasoning is instrumental (engineering credential, family security, "studied what worked") while her vocabulary is expressive ("sacred," "a different life," "breaks the cycle"). What is at stake is the typing of R004 and, with it, the construct validity of the whole instrumental/expressive distinction. Recommended inputs to the decision: run [`/find-negative-cases`](../../find-negative-cases/SKILL.md) on a claim about instrumental mothers and emotional framing (Denise is the designed negative case), and consult the corpus design note in [inputs/README.md](../../../../inputs/README.md) and the [R004 transcript frontmatter](../../../../inputs/transcripts/R004-Transcript.md). This skill does not pre-empt that decision.
- **`worry` scope (from D-04).** If the team rules epistemic uncertainty out of scope for `worry`, decide whether segments like [R003 L70](../../../../inputs/transcripts/R003-Transcript.md#L70) stay uncoded or justify a new code.

## Coverage gaps

C2 items — instances one coder caught and others did not, where the missing coders have no instance of that code for that respondent at all. Each should be checked against the codebook, not assumed wrong.

- **R001 Tasha L18** — "School felt like — okay, you sit there, you do the work ..." coded `own-education` by Reyes and Whitfield; not coded by Tran, who recorded no `own-education` for Tasha at all ([R001 L18](../../../../inputs/transcripts/R001-Transcript.md#L18)).
- **R001 Tasha L66** — "Money. Always money." coded `worry` by M. Tran; not coded by Reyes or Whitfield, who recorded no `worry` for Tasha ([R001 L66](../../../../inputs/transcripts/R001-Transcript.md#L66)). The line is a clear worry instance; the gap looks like an oversight.
- **R002 Marisol L62** — "That she'll feel like she has to come home. That she'll worry about us too much ..." coded `worry` by J. Whitfield; not coded by Reyes or Tran, who recorded no `worry` for Marisol ([R002 L62](../../../../inputs/transcripts/R002-Transcript.md#L62)).
- **R003 Carla L50** — Carla's account of the ROI-ranking website was coded `info-seeking` by Reyes only; Tran and Whitfield recorded no `info-seeking` for Carla ([R003 L50](../../../../inputs/transcripts/R003-Transcript.md#L50)).
- **R003 Carla L58** — "If we had money ... The conflict is because we don't have money." coded `cost-risk` by Reyes and Whitfield; not coded by Tran, who recorded no `cost-risk` for Carla ([R003 L58](../../../../inputs/transcripts/R003-Transcript.md#L58)). This is a load-bearing line — Carla naming class as the source of her ambivalence — and its omission from one coding is worth flagging.

One coverage-divergent location is not a gap but is worth a note: at **R003 Carla L34**, the passage where Carla performs both of her "voices," Tran and Whitfield each double-coded `expressive` + `instrumental`, while Reyes did not code L34 at all — she anchored her dual-frame coding at L38 instead. Reyes did apply both codes to Carla, so this is not a C2 gap; but L34 is the richest single statement of the mixed case and the omission is worth reconciling.

The remaining four coverage-divergent locations are C1 — benign exemplar choices, where the single coder's code is applied elsewhere for the same respondent by the others: [R001 L58](../../../../inputs/transcripts/R001-Transcript.md#L58) (`info-seeking`, also coded by all three at L62), [R002 L50](../../../../inputs/transcripts/R002-Transcript.md#L50) (`expressive`, coded for Marisol throughout), [R004 L30](../../../../inputs/transcripts/R004-Transcript.md#L30) and [R004 L34](../../../../inputs/transcripts/R004-Transcript.md#L34) (`instrumental`, coded for Denise throughout). No action needed; listed so the reader knows they were checked.

## What this audit does not establish

This audit examined where three coders' judgements diverged given a shared codebook. It cannot tell you whether the codebook's constructs are the right ones, or whether a convergent code is a valid one — all three coders can agree on a code that is wrong. The high agreement on R001 and R002 means the codebook is *usable*, not that the instrumental/expressive distinction is *valid*. That question belongs to the analyst, informed by negative-case analysis and by the construct-validity design built into the corpus.
