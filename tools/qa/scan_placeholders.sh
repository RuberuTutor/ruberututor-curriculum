#!/usr/bin/env bash
set -euo pipefail

OUT="tools/qa/out/placeholders.txt"
> "$OUT"

# Add any other placeholders you’ve used into the regex below:
PATTERN='\[VERBATIM\]|\[title\]|\[from PDF\]|TODO|FIXME|PLACEHOLDER|_TEMPLATE_|TEMPLATE'

# Limit to maps + materials; exclude git and binaries
grep -RInE "$PATTERN" \
  curriculum/ontario/maps \
  materials \
  --exclude-dir=.git \
  --exclude='*.pdf' \
  --exclude='*.png' \
  --exclude='*.jpg' \
  --exclude='*.jpeg' \
  --exclude='*.zip' \
  | tee "$OUT"

echo
echo "Saved placeholder hits to: $OUT"
