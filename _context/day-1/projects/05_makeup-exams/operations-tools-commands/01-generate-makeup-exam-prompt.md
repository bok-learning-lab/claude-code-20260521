# Prompt: Generate a Makeup Midterm Exam

Use this prompt after sharing the syllabus and practice materials from `inputs/`. It asks Claude to generate a new midterm exam at the same difficulty and covering the same content as Midterm 2.

---

## How to share inputs

Provide Claude with:
- `GENED1104_Syllabus.md` — to understand the course topics and learning goals
- The PDFs and DOCX files from `inputs/Midterm-2-Practice-Materials/` — actual past midterms and answer keys

Note: Claude can read PDFs and Word documents. Share them directly in your conversation.

---

## Prompt

```
I'm teaching GENED 1104: Science and Cooking at Harvard. I've shared the course syllabus and several years of Midterm 2 exams and answer keys with you.

Please generate a new makeup version of Midterm 2 that:

1. **Covers the same topics** as the existing Midterm 2 (based on the past exams and the syllabus)
2. **Matches the format** of the existing exams — same question types (multiple choice, short answer, calculations, etc.), same approximate number of questions, same point distribution
3. **Is comparable in difficulty** — not easier, not harder. Use the existing exams as your calibration
4. **Uses different questions** — do not reuse questions from the past exams. Write original questions that test the same concepts in new ways
5. **Includes all necessary reference material** — if the original exams included an equation sheet or reference table, generate an equivalent one for this new exam

After generating the exam, please also generate a **complete answer key** with:
- The correct answer for every question
- Brief explanations for each answer (2–3 sentences) explaining the underlying concept
- For calculation questions: show the full worked solution

Format the exam as a clean, professional document. The answer key should be clearly separated from the exam itself.
```

---

## Output

Save both the exam and answer key to `outputs/`:
- `outputs/makeup-exam.md`
- `outputs/answer-key.md`
