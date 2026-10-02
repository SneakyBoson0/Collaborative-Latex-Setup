#!/usr/bin/env bash
# Build a "track changes" PDF comparing an older revision with the current files.
#   bash scripts/diff.sh            # vs. previous commit
#   bash scripts/diff.sh v1.0       # vs. a tag
#   bash scripts/diff.sh origin/main
# Output: build/diff.pdf
set -euo pipefail

REV="${1:-HEAD~1}"
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

TMP="$(mktemp -d)"
cleanup() { git worktree remove --force "$TMP/old" >/dev/null 2>&1 || true; rm -rf "$TMP"; }
trap cleanup EXIT

git worktree add --detach "$TMP/old" "$REV" >/dev/null
latexdiff --flatten "$TMP/old/main.tex" main.tex > diff.tex
latexmk diff.tex
echo "Created build/diff.pdf (changes since $REV)"
