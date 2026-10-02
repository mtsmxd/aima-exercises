# AIMA Exercises

Jekyll 3 site (GitHub Pages) with the exercises of *Artificial Intelligence: A Modern Approach*. See `README.md` / `CONTRIBUTING.md` for the full directory tour.

## Layout in one glance
- `markdown/<N-Chapter-Name>/index.md` – chapter page; one card per exercise (`include_relative exercises/ex_K/question.md`).
- `markdown/<N-Chapter-Name>/exercises/ex_K/{index.md,question.md}` – exercise page (layout `exercise`) and its text. Optional `answers/` per exercise.
- `markdown/<N-Chapter-Name>/README.md` – status table per chapter.
- `latex/*.tex` – LaTeX source of the exercises (`uexercise`/`exercise` environments, `% id=N.K section=...` comment).
- `crossref.json` – bibliography references only (label -> citation), not per-exercise data.
- `figures/` images, `js/` bookmark/upvote/search scripts, `_layouts/` + `_includes/` templates.

## Do not hand-edit (tracked build output)
`_site/`, `.sass-cache/`, `.jekyll-metadata` are generated but **committed**. Edits to them are denied in `.claude/settings.json`. Never run a plain `jekyll build` in the repo: it rewrites `_site/` and (with `incremental: false`) deletes `.jekyll-metadata`.

## Build / verify
- `.claude/scripts/verify-build.sh` – builds from a throwaway copy into a temp dir (~6 s, expect 1374 files). Use this after any content or layout change.
- Cloud sessions: `.claude/hooks/session-start.sh` installs gems from `.claude/jekyll/Gemfile` (Jekyll 3.10 + `kramdown-parser-gfm`, `webrick`). The project `Gemfile.lock` pins Bundler 2.0.2, which crashes on Ruby >= 3.2, so it is not used there. Output matches the committed `_site/` apart from the footer year.
- There are no automated tests or linters; a successful verify build is the check.

## Conventions
- Exercise math is MathJax: keep `{% include mathjax_support %}` in pages that render it.
- Adding an exercise: use the `add-exercise` skill (`.claude/skills/add-exercise`).
