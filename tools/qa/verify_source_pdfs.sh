#!/usr/bin/env bash
set -euo pipefail

ROOT="$(pwd)"
OUT="tools/qa/out/source_pdf_report.tsv"
> "$OUT"
echo -e "map_file\tsource_pdf\tstatus" >> "$OUT"

# Look for `source_pdf:` in frontmatter or body
while IFS= read -r -d '' f; do
  sp=$(grep -E '^source_pdf:\s*' "$f" | head -n1 | sed -E 's/^source_pdf:\s*//')
  if [[ -z "${sp:-}" ]]; then
    echo -e "$f\t\tMISSING_source_pdf_field" >> "$OUT"
    continue
  fi
  # Normalize path (assume relative to repo root)
  pdf="$ROOT/${sp#./}"
  if [[ -f "$pdf" ]]; then
    echo -e "$f\t$sp\tOK" >> "$OUT"
  else
    echo -e "$f\t$sp\tNOT_FOUND" >> "$OUT"
  fi
done < <(find curriculum/ontario/maps -type f -name '*.md' -print0)

echo "Wrote: $OUT"
