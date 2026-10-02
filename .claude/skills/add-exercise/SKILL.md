---
name: add-exercise
description: Add a new exercise to a chapter of the AIMA exercises Jekyll site (question.md, index.md, chapter card, README row). Use when asked to add, create or digitalize an exercise.
---

# Add an AIMA exercise

Chapter dirs look like `markdown/3-Solving-Problems-By-Searching`. Exercises live in `<chapter>/exercises/ex_K/`.

1. Find the next number K: list `<chapter>/exercises/` and take max+1. Read the highest existing `ex_*` pair and the last card in `<chapter>/index.md`; copy their shape exactly rather than inventing markup.
2. Create `<chapter>/exercises/ex_K/question.md` with the exercise text (MathJax: inline `$...$`, display `$$...$$`, as in existing exercises).
3. Create `<chapter>/exercises/ex_K/index.md`, copying the previous one and changing:
   - `title: Exercise <chapter-number>.K`
   - `permalink: <chapter permalink>/ex_K/` (chapter permalink is in the front matter of `<chapter>/index.md`, e.g. `/search-exercises/`)
   - `breadcrumb:` the chapter dir name, `canonical_id: ch<chapter-number>exK`
4. Append a card to `<chapter>/index.md` (copy the previous card): link `ex_K/`, `bookmark('ch<N>exK')`, `upvote('ex<N>.K')`, `include_relative exercises/ex_K/question.md`.
5. Append a row `| K | Unanswered | [\`Question\`](exercises/ex_K/question.md)|` to `<chapter>/README.md`.
6. Only touch `latex/*.tex` if asked; if so add a `\begin{uexercise}...\end{uexercise}` block followed by `% id=<N>.K section=<section>`.
7. Never edit `_site/`, `.sass-cache/`, `.jekyll-metadata`, and do not use `crossref.json` (bibliography only).
8. Verify: run `.claude/scripts/verify-build.sh <tmpdir>` and confirm `<tmpdir>/<permalink path>/ex_K/index.html` exists and contains the question text. Report the result.
