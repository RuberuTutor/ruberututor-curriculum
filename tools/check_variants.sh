#!/usr/bin/env bash
# Variant checker (requires bash 4+)
set -euo pipefail

ROOT="materials"
OUT="project_logs/reports/variants_report_$(date +%F).txt"
mkdir -p "$(dirname "$OUT")"

echo "Variant audit — $(date)" > "$OUT"
echo "" >> "$OUT"

shopt -s nullglob
declare -A SEEN
declare -A HAVE

while IFS= read -r -d '' f; do
  base="$(basename "$f")"
  dir="$(dirname "$f")"
  if [[ "$base" =~ ^(.+)_v([A-D])\.pdf$ ]]; then
    stem="${BASH_REMATCH[1]}"
    var="${BASH_REMATCH[2]}"
    key="$dir/$stem"
    SEEN["$key"]=1
    HAVE["$key:$var"]=1
  fi
done < <(find "$ROOT" -type f -name "*.pdf" -print0)

missing_total=0
for key in "${!SEEN[@]}"; do
  miss=()
  for v in A B C D; do
    [[ -n "${HAVE["$key:$v"]+x}" ]] || miss+=("$v")
  done
  if ((${#miss[@]})); then
    ((missing_total+=${#miss[@]}))
    echo "$key  →  missing variants: ${miss[*]}" >> "$OUT"
  fi
done

if ((missing_total==0)); then
  echo "All worksheet/assessment PDFs have complete variants (vA–vD)." >> "$OUT"
fi

echo "" >> "$OUT"
echo "Report saved to: $OUT"
