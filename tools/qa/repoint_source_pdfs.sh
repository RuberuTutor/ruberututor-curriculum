#!/usr/bin/env bash
set -euo pipefail
OUT="tools/qa/out/repoint_source_pdfs.tsv"
mkdir -p "$(dirname "$OUT")"
: > "$OUT"
echo -e "map_file\told\tnew\tresult" >> "$OUT"

while IFS= read -r -d '' f; do
  old=$(grep -E '^source_pdf:\s*' "$f" | head -n1 | sed -E 's/^source_pdf:\s*//')
  if [[ -z "${old:-}" ]]; then
    echo -e "$f\t\t\tNO_SOURCE_PDF" >> "$OUT"
    continue
  fi
  base="$(basename "$old")"
  cand1="curriculum/ontario/pdfs/$base"
  cand2="curriculum/ontario/$base"
  new=""
  [[ -f "$cand1" ]] && new="$cand1"
  [[ -z "$new" && -f "$cand2" ]] && new="$cand2"

  if [[ -z "$new" ]]; then
    echo -e "$f\t$old\t\tPDF_NOT_FOUND" >> "$OUT"
    continue
  fi

  if [[ "$old" == "$new" ]]; then
    echo -e "$f\t$old\t$new\tOK" >> "$OUT"
  else
    sed -i '' -E "s|^source_pdf:\s*.*$|source_pdf: ${new}|" "$f"
    echo -e "$f\t$old\t$new\tUPDATED" >> "$OUT"
  fi
done < <(find curriculum/ontario/maps/secondary -type f -name '*.md' -print0)

echo "Wrote $OUT"
