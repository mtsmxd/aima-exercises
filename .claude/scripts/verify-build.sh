#!/bin/bash
# Smoke-builds the site from a throwaway copy of the sources.
# Building in place is unsafe: _site/, .sass-cache/ and .jekyll-metadata are tracked in git, and
# Jekyll rewrites or deletes them (incremental: false deletes .jekyll-metadata).
# Usage: .claude/scripts/verify-build.sh [destination]
set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
export BUNDLE_GEMFILE="${BUNDLE_GEMFILE:-$PROJECT_DIR/.claude/jekyll/Gemfile}"
export BUNDLE_PATH="${BUNDLE_PATH:-$HOME/.bundle/aima-exercises}"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
DEST="${1:-$WORK/out}"

mkdir "$WORK/src"
(cd "$PROJECT_DIR" && tar --exclude=./.git --exclude=./_site --exclude=./.sass-cache \
  --exclude=./.jekyll-metadata -cf - .) | tar -xf - -C "$WORK/src"

cd "$WORK/src"
bundle exec jekyll build --config _config.yml,.claude/jekyll/verify.yml -d "$DEST"
echo "Built $(find "$DEST" -type f | wc -l) files into $DEST"
