#!/usr/bin/env bash
set -euo pipefail

ROOT="$(pwd)"
PDF_DIR="$ROOT/curriculum/ontario/pdfs"

# Guess a PDF path from a map filename (secondary Math/English common cases)
guess_pdf_path() {
  local base="$1"  # e.g., ENL1W.md
  case "$base" in
    # Grade 9 Math
    MTH1W.md)
      echo "curriculum/ontario/pdfs/Mathematics_Grade9_MTH1W_2021_with-Teacher-Supports.pdf"
      return 0;;
    # Grade 10 Math
    MTH2W.md)
      echo "curriculum/ontario/pdfs/Mathematics_Grade10_MTH2W_2021.pdf"
      return 0;;
    # Grade 11–12 Math (broad curriculum doc used in your commits)
    MCR3U.md|MCF3M.md|MBF3C
mark "STEP 3 - Create auto-setter for source_pdf"
cat > tools/qa/auto_set_source_pdfs.sh <<'BASH'
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(pwd)"
PDF_DIR="$ROOT/curriculum/ontario/pdfs"

# Guess a PDF path from a map filename (secondary Math/English common cases)
guess_pdf_path() {
  local base="$1"  # e.g., ENL1W.md
  case "$base" in
    # Grade 9 Math
    MTH1W.md)
      echo "curriculum/ontario/pdfs/Mathematics_Grade9_MTH1W_2021_with-Teacher-Supports.pdf"
      return 0;;
    # Grade 10 Math
    MTH2W.md)
      echo "curriculum/ontario/pdfs/Mathematics_Grade10_MTH2W_2021.pdf"
      return 0;;
    # Grade 11–12 Math (broad curriculum doc used in your commits)
    MCR3U.md|MCF3M.md|MBF3C.md|MHF4U.md|MCV4U.md|MDM4U.md)
      echo "curriculum/ontario/pdfs/math1112currb.pdf"
      return 0;;

    # English 9–10 (broad doc from your commit message)
    ENL1W.md|ENL2W.md|ENG2D.md)
      echo "curriculum/ontario/pdfs/english910currb.pdf"
      return 0;;

    # Likely English 11–12 broad doc (use if present; otherwise skip)
    ENL3W.md|ENL4W.md|ENG4U.md|ENG4E.md)
      if [ -f "$PDF_DIR/english1112currb.pdf" ]; then
        echo "curriculum/ontario/pdfs/english1112currb.pdf"
        return 0
      fi
      return 1;;
    *)
      return 1;;
  esac
}

# Work list: maps missing source_pdf
MISSING_LIST="/tmp/missing_srcpdf.txt"
[ -f "$MISSING_LIST" ] || { echo "Missing list not found: $MISSING_LIST"; exit 1; }

OUT_REPORT="tools/qa/out/auto_set_source_pdfs.tsv"
mkdir -p "$(dirname "$OUT_REPORT")"
: > "$OUT_REPORT"
echo -e "map_file\tguessed_pdf\tresult" >> "$OUT_REPORT"

while IFS= read -r md; do
  [ -n "$md" ] || continue
  base="$(basename "$md")"
  # Skip if it already has source_pdf (defensive)
  if grep -qE '^source_pdf:\s*' "$md"; then
    echo -e "$md\t(n/a)\tALREADY_PRESENT" >> "$OUT_REPORT"
    continue
  fi
  if guessed="$(guess_pdf_path "$base")"; then
    # only insert if the file exists
    if [ -f "$ROOT/${guessed}" ]; then
      # insert at the very top (prepend)
      printf "source_pdf: %s\n" "$guessed" | cat - "$md" > "$md.tmp" && mv "$md.tmp" "$md"
      echo -e "$md\t$guessed\tINSERTED" >> "$OUT_REPORT"
    else
      echo -e "$md\t$guessed\tPDF_NOT_FOUND" >> "$OUT_REPORT"
    fi
  else
    echo -e "$md\t-\tNO_GUESS" >> "$OUT_REPORT"
  fi
done < "$MISSING_LIST"

echo "Wrote $OUT_REPORT"
