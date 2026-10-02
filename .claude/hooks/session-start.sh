#!/bin/bash
# Installs the Jekyll toolchain for Claude Code cloud sessions.
# Uses .claude/jekyll/Gemfile instead of the project Gemfile: the project's Gemfile.lock pins
# Bundler 2.0.2, which crashes on Ruby >= 3.2. The project Gemfile/lock are left untouched.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
export BUNDLE_GEMFILE="$PROJECT_DIR/.claude/jekyll/Gemfile"
export BUNDLE_PATH="$HOME/.bundle/aima-exercises"

bundle install --quiet

if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  {
    echo "export BUNDLE_GEMFILE=\"$BUNDLE_GEMFILE\""
    echo "export BUNDLE_PATH=\"$BUNDLE_PATH\""
  } >> "$CLAUDE_ENV_FILE"
fi
