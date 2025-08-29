#!/bin/bash
set -euo pipefail

ROOT="materials"
OUT="project_logs/reports/variants_report_$(date +%F).txt"
mkdir -p "$(dirname "$OUT")"

echo "Variant audit — $(date)" > "$OUT"
echo "" >> "$OUT"

find "$ROOT" -type f -name "*_v[A-D].pdf" | while read -r f; do
  base="$(basename "$f")"
  dir="$(dirname "$f")"
  stem="${base%_v?\.pdf}"
  key="$dir/$stem"
  echo "$key" >> "$OUT.tmpkeys"
done

sort -u "$OUT.tmpkeys" | while read -r key; do
  miss=()
  for v in A B C D; do
    [[ -f "${key}_v${v}.pdf" ]] || miss+=("$v")
  done
  if ((${#miss[@]})); then
    echo "$key  →  missing variants: ${miss[*]}" >> "$OUT"
  fi
done
rm -f "$OUT.tmpkeys"

if ! grep -q "missing variants:" "$OUT"; then
  echo "All worksheet/assessment PDFs have complete variants (vA–vD)." >> "$OUT"
fi

echo "" >> "$OUT"
echo "Report saved to: $OUT"
