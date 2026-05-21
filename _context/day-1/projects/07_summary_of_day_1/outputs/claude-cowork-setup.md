# Claude Co-Working Setup Guide

"Co-working with Claude" is a workflow — not a separate product. It's the practice of using Claude.ai as a collaborative partner across a sustained project, treating each session as a working session with a capable collaborator rather than a one-shot query tool.

---

## The basic co-working workflow

```
1. Gather your inputs (files, data, notes, questions)
2. Open a Claude conversation
3. Drop in your inputs
4. Give Claude a specific task with a clear output format
5. Review the output, redirect as needed
6. Move the output somewhere useful (copy into a doc, save to a file, etc.)
```

---

## How yesterday's workshop was structured

Each project yesterday followed this pattern:

| Step | What we did |
|------|-------------|
| **Inputs** | Gathered raw material (images, CSVs, texts, course documents) |
| **Tools** | Wrote or used a prompt to specify the task |
| **Outputs** | Claude generated an artifact (website, analysis, exam, reading) |

The `projects/` folder in this repo is the organized version of that workflow.

---

## Best practices

### Write a real prompt, not a question
Instead of: *"Can you analyze this data?"*
Try: *"Analyze this CSV and tell me which country comparisons would make the most visually striking population pyramids. Explain your choices."*

### Specify the output format
Claude will match whatever format you describe:
- *"Return a markdown table with columns: name | date | topic"*
- *"Write this as a numbered list"*
- *"Generate a standalone HTML file I can open in a browser"*

### Attach everything upfront
Drop all relevant files into the conversation before sending your first message. Claude can hold a lot of context; give it what it needs.

### Treat Claude's first draft as a draft
The first output is a starting point. Follow up with corrections, additions, or redirections. The conversation is the tool.

---

## Setting up for a new project

1. In Claude.ai, click **New Project** in the sidebar
2. Give the project a name
3. Upload any reference documents that should persist across sessions (syllabus, style guide, dataset)
4. Start your first conversation in the project

Projects let Claude remember context from previous sessions — useful for anything that spans more than one sitting.

---

## What lives in each project folder

```
my-project/
├── inputs/     ← Raw materials: images, data, texts, documents
├── tools/      ← Prompts and instructions (markdown files)
└── outputs/    ← Generated artifacts from Claude
```

Use the `my-project/` folder in this repo as your blank workspace for today.
