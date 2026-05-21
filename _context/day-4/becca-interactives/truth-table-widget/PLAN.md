# Interactive Truth Table Widget — Implementation Plan

## Overview

A single self-contained HTML file (no build tools, no dependencies) that renders an
interactive truth table for propositional logic. Each problem instance is configured
by a plain JavaScript object at the top of the file. Students fill in T/F values by
clicking cells, then click **Check** to see feedback.

### Design decisions

- **Display:** Unicode symbols (¬ ∧ ∨ → ↔ ⊕) in headers and labels.
- **Input:** Click a formula cell to cycle through blank → T → F → blank.
- **Variable columns:** Auto-filled (they define the truth assignment, not the answer).
- **Formula columns:** All student-filled — first column, any middle columns, last column.
- **Feedback (only after clicking Check):**
  - Cells marked ✓ (green) or ✗ (red) vs. correct values.
  - Equivalence verdict banner (green "Equivalent" or red "Not equivalent") based on
    correct first/last column values.
  - Rows that are counterexamples in the correct answer highlighted in amber.

### Configuration object (example)

```javascript
const PROBLEM = {
  title: "Problem 1a",
  instructions: "Show using a truth table that P → Q is equivalent to ¬P ∨ Q.",
  variables: ["P", "Q"],
  firstColumn:  { label: "P → Q",  formula: "P -> Q"  },
  lastColumn:   { label: "¬P ∨ Q", formula: "!P | Q"  },
  // Optional: instructor-provided middle columns (student still fills in values)
  middleColumns: [
    { label: "¬P", formula: "!P" }
  ]
};
```

To create a new problem, copy the HTML file and change only `PROBLEM`.

---

## Step 1 — HTML skeleton and configuration object

**Goal:** Create the HTML file with the `PROBLEM` config object, a placeholder `<div>`
for the widget, and stub `<style>` / `<script>` sections. No rendering logic yet.

**Deliverables:**
- `truth-table-widget/truth-table.html` — the widget file
- Config object at the top of the `<script>` block with the P→Q / ¬P∨Q example
- Page title, h1 heading, and `<div id="widget">` container

**Suggested prompt:**
Create the file `truth-table-widget/truth-table.html` as a self-contained HTML page.
At the top of the script block, define the `PROBLEM` config object exactly as shown in
`truth-table-widget/PLAN.md`. Add a `<div id="widget"></div>` container, a `<style>`
section (empty for now), and a `<script>` section that logs `PROBLEM` to the console
on load to confirm the config is wired up. Don't implement any rendering logic yet.

---

## Step 2 — Truth table grid rendering (structure only)

**Goal:** Render the full table skeleton from the config: variable columns (auto-filled
T/F), formula column headers (first, any configured middle columns, last). Cells in
formula columns are empty `<td>` elements for now — no interaction yet.

**Details:**
- Generate all 2ⁿ truth-assignment rows (n = number of variables), MSB-first order
  (e.g., TT, TF, FT, FF for two variables).
- Variable cells show T or F (auto-filled, not clickable).
- Formula column `<td>` elements get `data-col` and `data-row` attributes for later
  targeting.
- First and last column `<th>` elements get a CSS class `col-fixed` for later styling.

**Suggested prompt:**
Implement the `renderTable()` function in `truth-table-widget/truth-table.html`.
It should read `PROBLEM` and build an HTML `<table>` inside `#widget`.
Variable columns are auto-filled with T/F (MSB-first row order).
Formula columns (firstColumn, any middleColumns, lastColumn) have empty `<td>` cells
with `data-col="colIndex"` and `data-row="rowIndex"` attributes.
First and last column headers get class `col-fixed`.
Call `renderTable()` on page load.

---

## Step 3 — Clickable T/F input cells

**Goal:** Make formula-column cells interactive. Clicking cycles blank → T → F → blank.
Style blank, T, and F states visually distinctly (e.g., blank is light grey, T is white,
F is white, all with clear text).

**Details:**
- Each formula cell stores its current value in a `data-value` attribute: `""`, `"T"`,
  or `"F"`.
- Clicking advances the cycle.
- Font should be monospace and centered; cells should be a fixed width.
- Add a thin border to all cells; thicker border between the variable columns and the
  first formula column, and between the last formula column and the second-to-last
  column, to visually group sections.

**Suggested prompt:**
Add click-to-cycle behavior to formula cells in `truth-table-widget/truth-table.html`.
Clicking a formula cell advances its `data-value` through `""` → `"T"` → `"F"` → `""`
and updates the displayed text. Add CSS so blank cells have a light grey background,
T/F cells have a white background with bold centered text. Add a thicker border between
the variable columns and the first formula column (and between the last and
second-to-last formula columns) to visually separate the sections.

---

## Step 4 — Add and remove student middle columns

**Goal:** A button below the table lets students add a new formula column between the
first and last columns. Each new column has an editable text label (displayed in the
header) and blank clickable cells. An ✕ button on each student-added column header
removes it (pre-configured middle columns from the instructor cannot be removed).

**Details:**
- "Add column" button inserts a new column to the right of the last student-added column
  (but always left of the last fixed column).
- New column header contains an `<input type="text">` for the label (placeholder: "Label
  (e.g. ¬P)"). The label is display-only — it is NOT evaluated as a formula; only the
  instructor-configured formulas are evaluated during Check.
- Student-added columns participate in the T/F cycling but are NOT checked against any
  formula (since there's no formula attached — they're the student's working space).
- The ✕ remove button appears only on student-added columns.

**Suggested prompt:**
Add an "Add column" button below the table in `truth-table-widget/truth-table.html`.
Clicking it inserts a new column to the left of the last (fixed) column. The new
column's `<th>` contains a text input for the label (not evaluated) and an ✕ button to remove it. Each cell in the new column is a blank clickable T/F cell. Student-added columns are marked with `data-student="true"` on the `<th>`. Pre-configured middle
columns (from `PROBLEM.middleColumns`) do NOT have the ✕ button. Removing a column deletes it from the table entirely.

---

## Step 5 — Formula evaluator

**Goal:** Implement a formula parser/evaluator that takes a formula string and a variable
assignment object and returns `true` or `false`.

**Accepted input syntax (case-insensitive):**

| Operator    | Accepted forms              |
|-------------|----------------------------|
| NOT         | `!`, `~`, `NOT`, `¬`       |
| AND         | `&`, `&&`, `AND`, `∧`      |
| OR          | `\|`, `\|\|`, `OR`, `∨`   |
| IMPLIES     | `->`, `=>`, `→`            |
| IFF         | `<->`, `<=>`, `↔`         |
| XOR         | `XOR`, `⊕`                |
| NAND        | `NAND`, `↑`               |
| NOR         | `NOR`, `↓`                |
| Grouping    | `(`, `)`                  |

**Operator precedence (high to low):** NOT, AND, OR, IMPLIES, IFF/XOR, NAND, NOR.
(Parentheses override all.)

**Suggested prompt:**
Implement a `evaluate(formula, assignment)` function in
`truth-table-widget/truth-table.html`.
`formula` is a string; `assignment` is an object like `{P: true, Q: false}`.
The function should tokenize the formula, parse it respecting operator precedence
(NOT > AND > OR > IMPLIES > IFF/XOR > NAND/NOR), and evaluate it to `true` or `false`.
Support all input forms listed in Step 5 of `truth-table-widget/PLAN.md`.
Add a small self-test block (run on load, log results) that verifies a handful of
expected values including at least: `!P`, `P & Q`, `P -> Q`, `P <-> Q`, `P NAND Q`.

---

## Step 6 — Check button and per-cell feedback

**Goal:** A **Check** button evaluates the correct values for the first and last columns
(using the formula evaluator) and compares them to the student's entries. Each cell in
those columns is marked correct (green ✓) or incorrect (red ✗). Student-added columns
are not checked. Pre-configured middle columns ARE checked against their formulas.

**Details:**
- Correct: cell gets class `cell-correct` (green background, ✓ suffix or border).
- Incorrect or blank when it should have a value: class `cell-incorrect` (red background,
  ✗ suffix or border).
- A **Reset** button (shown alongside Check) clears all student entries and all feedback
  classes, returning the table to its initial state.
- After Check, cells are no longer clickable until Reset is pressed.

**Suggested prompt:**
Add a **Check** button and a **Reset** button below the table in
`truth-table-widget/truth-table.html`.
When Check is clicked: use `evaluate()` to compute correct values for each
instructor-configured formula column (firstColumn, any middleColumns, lastColumn).
Compare to student's `data-value` on each cell. Apply class `cell-correct` (green) or
`cell-incorrect` (red) to each cell. Lock all formula cells (disable cycling).
When Reset is clicked: clear all student values and all feedback classes, re-enable cycling.

---

## Step 7 — Equivalence verdict and counterexample row highlighting

**Goal:** After Check, display a verdict banner and highlight counterexample rows.

**Details:**
- Compute correct values for first and last columns across all rows.
- If they match in every row → banner: green box reading "✓ Equivalent"
- If they differ in at least one row → banner: red box reading "✗ Not equivalent"
- Rows where the correct first ≠ correct last get a background highlight (amber/yellow)
  on the entire row. These are the counterexample rows that demonstrate non-equivalence.
- If the propositions are equivalent, no rows are highlighted.
- The banner appears above the table (or between the title and table).
- The banner and row highlights are cleared by Reset.

**Suggested prompt:**
 After the Check logic in `truth-table-widget/truth-table.html`, add equivalence verdict
 display. Compare the correct values of `firstColumn` and `lastColumn` across all rows.
 If all match, insert a green "✓ Equivalent" banner above the table.
 If any differ, insert a red "✗ Not equivalent" banner and apply class
 `row-counterexample` (amber background) to every row where they differ.
 Clear the banner and `row-counterexample` classes when Reset is clicked.

---

## Step 8 — Instructions, title display, and symbol input helper

**Goal:** Render the problem title and instructions from the config above the widget.
Add a small row of clickable symbol buttons (¬ ∧ ∨ → ↔ ⊕) near the "Add column" button
that insert the symbol into the column-label input when clicked (quality of life for
students entering column labels).

**Suggested prompt:**
In `truth-table-widget/truth-table.html`, render `PROBLEM.title` as an `<h2>` and
`PROBLEM.instructions` as a `<p>` above the table (from the config).
Add a row of small clickable buttons for the symbols ¬ ∧ ∨ → ↔ ⊕ NAND NOR near the
"Add column" area. When a symbol button is clicked while a column-label input is
focused, insert the symbol at the cursor position in that input. If no label input is
focused, clicking a symbol button has no effect (don't show an error).

---

## Step 9 — Final polish and configuration guide

**Goal:** Clean up styling, test with multiple problem configs, and add a brief
configuration comment block at the top of the file explaining how to adapt it for a new
problem.

**Checklist:**
- [ ] Reasonable appearance on both desktop and a narrower window (no horizontal scroll
      for tables up to ~6 columns)
- [ ] Font choices (suggest a clean sans-serif for prose, monospace for cells)
- [ ] Thematic color palette (suggest: blue for fixed headers, neutral for variable cols,
      amber for counterexamples, green/red for correct/incorrect)
- [ ] Test with a second `PROBLEM` config (e.g., P→Q vs. Q→P to test non-equivalence)
- [ ] Add a comment block at the top of the `<script>` explaining every field of
      `PROBLEM` and what values are acceptable

**Suggested prompt:**
 Polish `truth-table-widget/truth-table.html`:
 (1) Refine the CSS for a clean, readable layout — sans-serif prose, monospace cells,
 blue header backgrounds for fixed columns, neutral for variable columns.
 (2) Add a second `PROBLEM` config as a commented-out example in the script, using
 `P → Q` vs. `Q → P` to demonstrate a non-equivalence case.
 (3) Add a comment block at the top of the script explaining every field of `PROBLEM`.
 (4) Verify the widget works correctly end-to-end for both example configs.

---

## File layout

```
truth-table-widget/
  PLAN.md          ← this file
  truth-table.html ← the widget (single file, self-contained)
```
