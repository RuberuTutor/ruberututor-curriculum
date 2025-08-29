#!/bin/bash
# Usage:
#   bash tools/save_pdf.sh <worksheets|assessments> <math|english> <gr1..gr12> <StrandOrGroup> <pdf1> [pdf2 ...]
# Example:
#   bash tools/save_pdf.sh worksheets math gr1 B_Number ~/Downloads/*.pdf
set -euo pipefail

usage(){ echo "Usage: bash tools/save_pdf.sh <worksheets|assessments> <math|english> <gr1..gr12> <StrandOrGroup> <pdf1> [pdf2 ...]"; exit 1; }
[[ $# -ge 5 ]] || usage

TYPE="$1"; SUBJECT="$2"; GRADE="$3"; STRAND="$4"; shift 4
case "$TYPE" in worksheets|assessments) ;; *) echo "❌ TYPE must be worksheets|assessments"; exit 1;; esac
case "$SUBJECT" in math|english) ;; *) echo "❌ SUBJECT must be math|english"; exit 1;; esac
case "$GRADE" in gr[1-9]|gr1[0-2]) ;; *) echo "❌ GRADE must be gr1..gr12"; exit 1;; esac

REPO="$HOME/Dropbox/ruberututor_knowledge_pack"
DEST="$REPO/materials/$TYPE/$SUBJECT/$GRADE/$STRAND"
mkdir -p "$DEST"

added=0; skipped=0
for PDF in "$@"; do
  if [[ ! -f "$PDF" ]]; then echo "⚠️  Missing file: $PDF"; ((skipped++)); continue; fi
  base="$(basename "$PDF")"
  if [[ -f "$DEST/$base" ]]; then echo "↩️  Exists, skipping: $base"; ((skipped++)); continue; fi
  cp "$PDF" "$DEST/$base"
  echo "✅ Added: $base"
  ((added++))
done

cd "$REPO"
if (( added > 0 )); then
  git add "$DEST"
  git commit -m "Add $TYPE $SUBJECT $GRADE $STRAND: $added file(s)"
  git push
fi

# Variant audit (ensure vA–vD present for each stem in DEST)
report="$REPO/project_logs/reports/variant_postsave_$(date +%F_%H%M%S).txt"
mkdir -p "$(dirname "$report")"
{
  echo "Post-save variant check — $(date)"
  echo "$DEST"
  find "$DEST" -type f -name "*_v[A-D].pdf" | awk -v SUBSEP="\034" '
  {
    f=$0; stem=f; sub(/_v[A-D]\.pdf$/, "", stem);
    seen[stem]=1;
    if (f ~ /_vA\.pdf$/) have[stem,SUBSEP "A"]=1;
    if (f ~ /_vB\.pdf$/) have[stem,SUBSEP "B"]=1;
    if (f ~ /_vC\.pdf$/) have[stem,SUBSEP "C"]=1;
    if (f ~ /_vD\.pdf$/) have[stem,SUBSEP "D"]=1;
  }
  END{
    missing_any=0;
    for (s in seen){
      miss="";
      if (!(s SUBSEP "A" in have)) miss=miss "A ";
      if (!(s SUBSEP "B" in have)) miss=miss "B ";
      if (!(s SUBSEP "C" in have)) miss=miss "C ";
      if (!(s SUBSEP "D" in have)) miss=miss "D ";
      if (length(miss)>0){
        sub(/[ ]+$/, "", miss);
        printf "%s  →  missing: %s\n", s, miss;
        missing_any=1;
      }
    }
    if (!missing_any) print "All stems in this folder have vA–vD.";
  }'
} > "$report"
echo "📄 Report: $report"
