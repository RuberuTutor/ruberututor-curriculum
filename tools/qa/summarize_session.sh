#!/usr/bin/env bash
set -euo pipefail

echo "========== SESSION SUMMARY =========="

echo
echo "## Repo & Branch"
git rev-parse --show-toplevel
git branch -vv | grep '^\*'
git remote -v | head -n 2

echo
echo "## Git Status (staged + untracked)"
git status -s

echo
echo "## Last 3 Commits"
git log --oneline -n 3

echo
echo "## QA Reports (sizes + first few lines)"
for f in tools/qa/out/*; do
  [ -f "$f" ] || continue
  echo "--- $(basename "$f") ---"
  ls -lh "$f"
  head -n 20 "$f"
  echo
done

echo "========== END SUMMARY =========="
