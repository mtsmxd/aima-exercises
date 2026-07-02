# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Jekyll static site (GitHub Pages) hosting online exercises for *Artificial
Intelligence: A Modern Approach* (4th edition, which drops printed exercises
in favor of this site). Content is organized by book chapter; each exercise
has a question and, optionally, a folder of student-submitted answers created
automatically via Staticman pull requests.

## Development commands

Requires a Ruby environment (Jekyll 3.8, Ruby ~2.5–3.x) and Bundler.

```bash
gem install jekyll bundler
bundle install
bundle exec jekyll serve       # serve locally with live rebuild
bundle exec jekyll build       # build the site into _site/
```

There is no JS/CSS build step, test suite, or linter — `js/`, `public/css`,
and `figures/` are served as static assets directly. There are no unit tests
in this repository; verification is "does the built site render and link
correctly," done by running `jekyll serve` and checking pages in a browser.

## Architecture

### Content pipeline: LaTeX → Markdown → Jekyll page

Each book chapter has a canonical LaTeX source in `latex/*.tex` (e.g.
`latex/search-exercises.tex`). Exercises are transcribed into per-exercise
Markdown under `markdown/<N>-<Chapter-Name>/exercises/ex_<n>/`, and it's the
Markdown, not the LaTeX, that Jekyll renders into pages. The chapter-to-file
mapping is documented in the table in `README.md`.

### Exercise folder structure

```
markdown/<N>-<Chapter-Name>/
  README.md                        # chapter index page, links to each exercise's question.md
  exercises/
    ex_<n>/
      index.md                     # Jekyll front matter + includes question.md (this is the actual page)
      question.md                  # exercise text, no front matter, included via {% include_relative %}
      answers/                     # optional, created on first answer submission
        answer-<username>[-<n>].md
        communityanswer.md         # verified/admin answer, rendered separately
```

`index.md` front matter conventions (must stay consistent across exercises):

```yaml
layout: exercise
title: Exercise <chapter>.<n>
permalink: /<chapter-slug>-exercises/ex_<n>/
breadcrumb: <N>-<Chapter-Name>        # must match the markdown/ directory name exactly
canonical_id: ch<N>ex<n>              # used as the Staticman/lunr/bookmark key
```

`<chapter-slug>` is the short slug used in permalinks and matches the LaTeX
filename stem (e.g. chapter 3 → `search-exercises`, chapter 22 →
`nlp-communicating-exercises`) — see the README table for the full mapping
per chapter; it does not always match the directory's `<N>-<Chapter-Name>`
name.

### How an exercise page is assembled

`_layouts/exercise.html` renders the question (via `{% include_relative
question.md %}`), a "Community Solution" card, and a "Student Answers" card.
JS (not Jekyll) populates the latter two at runtime: `js/answer.js` and
`js/commsol.js` hit the GitHub Contents API
(`api.github.com/repos/aimacode/aima-exercises/contents/markdown/<chapter>/exercises/ex_<n>/answers`)
to fetch and render answer files client-side, skipping/singling-out
`communityanswer.md`. `_includes/staticman-comments.html` renders the answer
submission form.

### Answer submission (Staticman)

Submitting an answer through the web form triggers a Staticman-driven PR that
adds a new file to that exercise's `answers/` folder. `staticman.yml` at repo
root has **one config block per exercise** (keyed `ch<N>ex<n>`), each
specifying its own `path` and commit message — when adding a new exercise,
a matching Staticman entry must be added too. Answers can also be
contributed directly by opening a PR that adds
`markdown/<chapter>/exercises/ex_<n>/answers/answer-<github-username>.md`
with frontmatter:

```
---
Name: Your name
Email: Your email
---
Your answer here.
```

(See `CONTRIBUTING.md` for the full walkthrough, including how to add a
second answer from the same user via a `-2` filename suffix.)

### Cross-references

`crossref.json` (Liquid-templated, `layout: null`) is compiled by Jekyll into
a static JSON of labeled references (`paperRef`, `sectionRef`, `chapterRef`,
`equationRef`, `exerciseRef`, figure refs, etc.). `js/crossref.js` fetches
the **built** copy from
`https://raw.githubusercontent.com/.../master/_site/crossref.json` at page
load and replaces elements like `<span class="pageRef">Label</span>` with
the resolved citation text/link. Adding a new citation means adding an entry
to the relevant array in `crossref.json`, keyed by the `label` used in the
page's markup.

### Search

`search_data.json` (also `layout: null`, Liquid-generated) iterates
`site.pages` at build time to produce a flat index of `{title, breadcrumb,
content, url}` for every content page. `js/search.js` loads this file into
`lunr.js` client-side and powers `search/index.html`.

### Generated output is committed

Unusually, `_site/` (the Jekyll build output) and `.jekyll-metadata` are
committed to the repository, not gitignored — several client-side scripts
(`crossref.js`, GitHub Pages serving) depend on `_site/` content being
present in the repo itself. If you change source content, expect `_site/`
to also need regenerating/committing to stay in sync (`bundle exec jekyll
build` regenerates it).

### Other structural pieces

- `_layouts/` — `default.html` (base), `homepage.html`, `chapter.html`,
  `exercise.html`, `answersubmitted.html`, `questionbank.html`, `page.html`,
  `post.html`.
- `_includes/` — shared partials: `sidebar.html`/`sidebar2.html`
  (navigation), `head.html`, `meta.html`, `breadcrumb.html`,
  `mathjax_support` (MathJax config for rendering exercise math),
  `staticman-comments.html`.
- `figures/` — images referenced by exercises/chapters.
- `_config.yml` — Jekyll site config (`baseurl: /aima-exercises`, Staticman
  repo/branch settings, `jekyll-paginate` plugin).
