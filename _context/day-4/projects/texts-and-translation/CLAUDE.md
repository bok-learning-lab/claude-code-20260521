# CLAUDE.md — Texts and translation

## What this project is

A workshop project for faculty who work with texts in languages other than English — translation, close reading, comparative scholarship across editions and translations, and the kinds of close textual labor that humanists do at scale. Built during the 4-day Bok Center workshop "Claude for Teaching, Course Development, and Research."

The project bundles two distinct corpora, each set up as a standalone demo target:

- [the-odyssey/](the-odyssey/) — Homer's *Odyssey* in 14 translations spanning Greek, Latin, Spanish, French, Swedish, and English (Bryant, Butcher/Lang, Butler, Cotterill, Cowper, Merry/Riddell, Monro, Pope). Designed for *comparative translation* work — surfacing the decisions each translator made.
- [early-modern-sanskrit/](early-modern-sanskrit/) — Jagannātha Paṇḍitarāja's *Rasagaṅgādhara* (17th c.), a major Sanskrit treatise on poetics (alaṃkāra-śāstra), from the GRETIL etext archive at Göttingen. Currently only Ānana 1 is downloaded. Designed for *close work on a non-Roman-script primary text*, including identifying figures of speech in a treatise that is itself about figures of speech.

Faculty open Claude Code with this folder as the working directory. Skills built for this project live under `.claude/skills/` *inside this folder*, so the project travels as a self-contained bundle.

## Status

**This is initial scaffolding.** CLAUDE.md and PLAN.md exist; no skills have been built yet. The corpora are in place. See [PLAN.md](PLAN.md) for candidate skills, parallel-build tasks, and open questions.

## Audience modes

Two kinds of people open Claude Code here:

- **Faculty working with their own non-English texts.** They may never have touched a code editor. They are usually deep in their primary source but new to LLM-assisted work. Default to plain-English explanations; do not assume CLI fluency; frame outputs in terms of the scholarly task (close reading, translation comparison, glossary work, figure identification) rather than in terms of "data" or "documents."
- **Marlon (or another collaborator) iterating on the project itself.** Terse responses, no hand-holding.

If unsure which mode applies, ask one question to disambiguate.

## The two corpora

### The Odyssey

The richer of the two at this stage. Single Greek source ([the_odyssey.txt](the-odyssey/the_odyssey.txt), Polylas's 19th-century translation into Modern Greek) plus 14 translations into other languages under [the-odyssey/translations/](the-odyssey/translations/). This is the corpus to demo *comparative translation* skills: handing a passage to Claude with five translations and asking what each translator chose to preserve and what they let go.

The Greek source here is itself a translation (Polylas, Modern Greek), not the original Homeric Greek. If a demo needs the Homeric original specifically, source it separately (Project Gutenberg #1727 has Murray's Loeb).

### Early modern Sanskrit (Rasagaṅgādhara)

A single primary text right now: Jagannātha Paṇḍitarāja's *Rasagaṅgādhara*, Ānana 1, at [early-modern-sanskrit/inputs/jagannatha-rasagangadhara.htm](early-modern-sanskrit/inputs/jagannatha-rasagangadhara.htm). Jagannātha was a 17th-century poet at the Mughal court of Shah Jahan; the *Rasagaṅgādhara* is one of the last great works of classical Sanskrit poetics, focused on rasa theory and figures of speech. The text is particularly apt for workshop demos because it is itself *about* the kind of close textual labor — identifying figures of speech, weighing rhetorical effects — that the skills should be helping faculty do.

Source: GRETIL (Göttingen Register of Electronic Texts in Indian Languages), edited by Timothy C. Cahill based on four printed editions (Motilal Banārsīdās 1983; Chowkhamba Vidyabhawan 1990; Sampurnanand Sanskrit Vishvavidyalaya 1977; Banaras Hindu University 1962). The file is Devanāgarī HTML with embedded Sanskrit and Hindi commentaries; faculty may want to add IAST/Harvard-Kyoto transliterations or pull in published English translations (Gerow, Pollock, Patwardhan-Athavale).

## Conventions

- **Skills live in `.claude/skills/<skill-name>/`** — project-scoped, so they travel with this folder.
- **Source texts are read-only.** Don't modify files in `the-odyssey/translations/` or `early-modern-sanskrit/inputs/`. Generated artifacts go in `output/`.
- **Preserve script and diacritics exactly.** Do not silently transliterate, romanize, or strip diacritics from source text. If a transformation is needed, produce a separate file and label it explicitly (e.g. `passage-iast.txt`).
- **No emojis** in any file. Workshop-wide convention.
- **Markdown link syntax** for file references — `[Pope](the-odyssey/translations/odyssey_pope.txt)`.
- **Cite by edition and line/verse, not by file line number.** A passage exists at *Odyssey* 1.1–10 across every translation; that citation should be primary, with file paths secondary.

## Alignment with humanistic practice

Workshop participants in this project are likely to be skeptical of LLM-assisted text work, often for good reasons. Skills built here should:

- Frame the LLM as a *first-pass collaborator*, not a final arbiter. The scholar reads the primary source; the LLM surfaces candidates for the scholar to evaluate.
- Be honest about what the model can and cannot do. It can compare translations; it cannot make Sanskrit philological judgments at the level of a trained Sanskritist. Skill outputs should be clear about which kind of claim they make.
- Quote verbatim. Paraphrase is the scholar's job, not the LLM's.
- Cite by primary-source coordinates (book.line, verse number, sūtra number), not by file path.
- Never invent passages or translations. If asked for a translation that does not exist in the corpus, say so.

## Open questions (carried in PLAN.md)

- Should the Homeric Greek original (Loeb / Murray) be added alongside Polylas?
- Should more of the *Rasagaṅgādhara* (Ānanas 2–4) be downloaded from GRETIL?
- Should published English translations of the *Rasagaṅgādhara* be added for a comparative-translation pass on a Sanskrit primary?
