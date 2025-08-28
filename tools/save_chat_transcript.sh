#!/usr/bin/env bash
# Save today's ChatGPT transcript from the clipboard into the repo, then commit & push.
# Usage: bash tools/save_chat_transcript.sh "Short session title"
set -euo pipefail

REPO="$HOME/Dropbox/ruberututor_knowledge_pack"
OUTDIR="$REPO/project_logs/conversations"
TITLE="${1:-session}"
# Toronto time
export TZ="America/Toronto"
DATE="$(date +%F)"            # e.g., 2025-08-28
TIME="$(date +%H:%M)"         # e.g., 21:05

# Slugify title for filename
SLUG="$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')"
FILENAME="${DATE}_${SLUG:-session}.md"
FILEPATH="$OUTDIR/$FILENAME"

mkdir -p "$OUTDIR"

# Grab clipboard (macOS)
CLIP="$(pbpaste || true)"

# If clipboard is empty, make a placeholder so you can paste manually later.
if [ -z "${CLIP// }" ]; then
  CLIP="(Paste today’s ChatGPT transcript here. Clipboard was empty when saved.)"
fi

cat > "$FILEPATH" <<EOF
# Chat Transcript — $TITLE
- **Date:** $DATE
- **Time (Toronto):** $TIME

---

\`\`\`
$CLIP
\`\`\`
EOF

cd "$REPO"
git add "$FILEPATH"
git commit -m "Session log $DATE: $TITLE"
git push

echo "✅ Saved and pushed: $FILEPATH"
