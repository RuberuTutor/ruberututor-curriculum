#!/bin/bash
set -euo pipefail

REPO="${1:-$HOME/Dropbox/ruberututor_knowledge_pack}"
cd "$REPO" || { echo "❌ Repo not found at $REPO"; exit 1; }

D="$(date +%F)"
DIR="project_logs/conversations/misc/$D"
mkdir -p "$DIR"

echo "👉 COPY the entire chat now (⌘A, ⌘C). When ready, press ENTER here…"
read -r

TMP="$(mktemp)"
pbpaste > "$TMP"

[ -s "$TMP" ] || { echo "❌ Clipboard is empty. Copy the chat and run again."; rm -f "$TMP"; exit 1; }

# Full copy
cp "$TMP" "$DIR/${D}_chat_full.md"

# Split into ~400-line parts
awk -v DIR="$DIR" -v D="$D" -v N=400 '{f=sprintf("%s/%s_chat_part%02d.md",DIR,D,int((NR-1)/N)+1); print > f}' "$TMP"

rm -f "$TMP"

git add "$DIR"
git commit -m "backup: chat split into parts for $D"
git push

echo "✅ Backed up to $DIR"
