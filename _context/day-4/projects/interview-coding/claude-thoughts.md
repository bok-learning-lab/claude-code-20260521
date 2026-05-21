# Claude's thoughts: LLMs + Claude Code for flexible coding (Deterding & Waters 2018)

Brainstorm of ways to use LLMs (and Claude Code specifically) for the kind of disciplinary work Deterding & Waters describe — in-depth interview coding at scale, aligned with their "flexible coding" approach rather than grounded theory.

Source: Deterding, N. M., & Waters, M. C. (2018). "Flexible Coding of In-depth Interviews: A Twenty-first-century Approach." *Sociological Methods & Research*, 50(2), 708–739.

## Framing: where LLMs slot into the Waters pipeline

Waters' three stages give us natural seams — and a clear constraint: **the LLM should not do the immersive first read for the human, and it should not do open coding line-by-line.** That's the grounded-theory antipattern she's pushing against. The LLM is most aligned with her view when it operates *after* a researcher has formed concepts, and when it makes the audit trail more transparent rather than less.

## A. Testing new coding systems against ground

1. **LLM-as-second-coder for an analytic code, with disagreement as the signal.** Human develops the code + definition on a subset. LLM applies it to held-out transcripts. Don't report κ as the headline — surface the disagreements as candidates for code refinement. This is what Campbell et al. 2013 (cited in the paper) called for but at human-grad-student cost.

2. **Typology stress-test.** Take Waters' instrumental / expressive / mixed typology (or the African American / ethnic American / immigrant-identified one from *Ethnic Options*). Have the LLM independently assign each respondent and write its evidentiary justification. Surface every case where it disagrees with the human classification — those are the construct-validity warnings she describes at p. 731.

3. **Negative-case hunting at scale.** Once a working theory exists ("low-income mothers with expressive logic pursue X"), point the LLM at the full corpus and ask: *find me respondents whose evidence cuts against this.* This is the Katz/Luker/Blee requirement she names (p. 731) — currently almost impossible to do exhaustively at N=200.

4. **Alternative-explanation probes.** For each main claim in a paper draft, generate the two or three competing explanations the data could support, and surface transcript evidence for each. Forces the researcher to rule them out on the record.

5. **Construct-validity audit.** "Show me every quote you used to classify R047 as instrumental. Now show me the strongest counter-quotes from the same transcript." Mirrors exactly what she did manually for misclassifications.

## B. Scaling up coding systems (Waters' actual workflow, just bigger)

6. **Automated indexing to the interview protocol.** Her Stage 1: every transcript indexed to the protocol's broad chunks (childhood-neighborhood, evacuation-experience, physical-and-mental-health). LLMs do this trivially well; humans verify the edge cases where conversation drifted. This is the "easily distributed among team members" point on p. 723 — the LLM is just an additional team member.

7. **Respondent-level memos as a draft, not a finished product.** After indexing, generate a first-pass memo per respondent that the human edits. The memos are *hers*; the boilerplate is automated. Preserves the "case as case study" framing (Small 2009) without the grind.

8. **Cross-case thematic memos with citations.** Generate cross-case patterns *with respondent IDs and excerpts attached* — the researcher can then collapse, reject, or develop.

9. **Attributes spreadsheet construction from screening sheets + transcripts.** Demographics, site, experimental condition, etc. — extract once, validate, import to NVivo/ATLAS.ti/Dedoose.

10. **"Great quote" / "aha" surfacing.** She singles this out (p. 727). LLM is genuinely good at this — give it the working concepts and let it nominate quotes. Human curates.

11. **Question-by-question coverage matrix.** Her p. 727 trick: NVivo's matrix coding query to spot transcripts missing answers to a given protocol question. LLM can do this on raw text without QDA software at all.

## C. The hybrid move — grounded benefits, Waters epistemology

The interesting territory. Waters explicitly says she's not anti-emergence, she's anti-the-fairytale-that-you-start-with-no-prior-theory. So:

12. **Theory-aware emergence.** Give the LLM both the prior literature and the transcripts and ask: *what is here that the literature does not predict?* This is Timmermans & Tavory's abduction, mechanized. Surprise-detection against a stated theoretical background, not against a blank slate.

13. **Saturation checks.** After every N interviews, ask: *do the last 10 add new conceptual content beyond the first 50, or just more instances?* Helps with Glaser-Strauss saturation in a way the original method never operationalized.

14. **Theoretical sampling assistance.** Given the current indexed corpus and the attribute spreadsheet, *which interviews should I read next to maximize information gain about hypothesis X?* This is grounded theory's theoretical sampling, but tractable on a 200-interview pile.

15. **Multi-codebook exploration.** Generate three candidate codebooks from the same indexed data using different theoretical starting points (e.g., Bourdieu vs. Lareau vs. straight rational-choice). The researcher picks; the rejected ones document the analytic decision.

## D. Transparency and methods-section reporting (her central complaint)

16. **Auto-generated methods paragraph.** Track the indexing decisions, the codebook versions, the coder agreements, and emit the paragraph Deterding & Waters wish more papers had — including "we read X% of the full transcripts for analytic coding" (her Sociology of Education paper used 20%).

17. **Per-claim provenance.** Every claim in a paper draft links to (a) the analytic code, (b) the index sections, (c) the count of respondents whose evidence supports it. Reviewer-readable audit trail.

18. **Coding decision log.** When the codebook changes, capture *why* — the memo trail that's currently the most fragile part of the process.

## E. Secondary analysis & archiving (her funder-mandated concern)

19. **Index-only archives.** Per p. 728 — produce the "attribute + index codes only" version of the project for archive/team distribution, automatically.

20. **Cross-study codebook translation.** Two researchers, two studies, overlapping concepts. LLM proposes mappings between codebooks. Enables the kind of secondary work she points out is "rarely taken advantage of."

21. **Onboarding a secondary analyst.** Generate a guided tour of an archived corpus: what's here, how it was collected, what's already been published, what's untouched.

## F. Team workflows (her RISK reality)

22. **Distributed indexing with LLM tiebreaking.** Two grad students index; LLM adjudicates disagreements with a written rationale; PI reviews adjudications. Cheaper than her three-coder-with-reconciliation setup (Price & Smith 2017).

23. **Disagreement surfacing across coders.** Treat coder disagreements as theoretical signal, not noise. LLM clusters disagreement patterns.

## G. Claude Code–specific affordances

24. **Skills per stage.** `/index-transcripts`, `/respondent-memo`, `/cross-case-memo`, `/find-negative-cases`, `/great-quotes`, `/methods-paragraph`. Each skill encodes Waters' procedure so a non-methodologist student can run it.

25. **Parallel subagents over transcripts.** One subagent per transcript for indexing; results merged. The N=200 problem becomes N=1, 200 times.

26. **Codebook-as-file.** A living `codebook.md` Claude reads on every session. Version-controlled. The codebook becomes the audit trail.

27. **Hooks for data hygiene.** PreToolUse hook blocking writes that contain PII; blocking sharing of raw transcripts outside an `archive/` directory.

28. **MCP to NVivo / ATLAS.ti / Dedoose.** Round-trip — apply codes in Claude, sync to the QDA tool the team actually uses. (Doesn't exist yet, but is a buildable project.)

29. **Plan mode for analytic decisions.** Before any coding pass, Claude proposes the plan; researcher approves. Documents the analytic choice.

## H. Things to flag *against* in front of Mary

To stay credible with her view:

- Don't pitch "the LLM discovers themes" — she'll (correctly) call that the epistemological fairytale again. Pitch it as "the LLM applies a researcher's concepts at scale" or "surfaces candidates the researcher evaluates."
- Don't replace the immersive first read. The respondent-level memos are *generated* by the analyst sitting with the transcript. The LLM augments cross-case memos and the second-pass analytic coding.
- Don't oversell quantification. She explicitly cautions against it on p. 734.
- Don't use line-by-line open coding as the entry point. Index first, analytic-code second — same as her.

---

**Suggested next step:** pick 2–3 of these to actually demo with a sample transcript or two during the workshop — Mary will believe a working `/find-negative-cases` she can poke at far more than a slide deck.
