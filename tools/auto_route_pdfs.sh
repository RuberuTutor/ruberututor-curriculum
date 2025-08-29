#!/bin/bash
# Auto-route PDFs by Ontario-coded filename into materials tree.
# Usage:
#   bash tools/auto_route_pdfs.sh <worksheets|assessments> <pdf1> [pdf2 ...]
set -euo pipefail

usage(){ echo "Usage: bash tools/auto_route_pdfs.sh <worksheets|assessments> <pdf1> [pdf2 ...]"; exit 1; }
[[ $# -ge 2 ]] || usage

TYPE="$1"; shift
case "$TYPE" in worksheets|assessments) ;; *) echo "❌ TYPE must be worksheets|assessments"; exit 1;; esac

REPO="$HOME/Dropbox/ruberututor_knowledge_pack"
BASE="$REPO/materials/$TYPE"
mkdir -p "$BASE"

added=0; skipped=0; failed=0

route_one() {
  local PDF="$1"
  local name base ext
  [[ -f "$PDF" ]] || { echo "⚠️  Missing file: $PDF"; ((failed++)); return; }
  base="$(basename "$PDF")"

  # Expect forms like:
  # Gr1_Math_B_Number_B1-1_Count_to_50_vA.pdf
  # Gr7_Math_C_Algebra_C2-3_OneStep_Equations_vB.pdf
  # Gr9_English_ReadingLiterature_RL1_Theme_Inference_vC.pdf
  # Gr3_English_B_Foundations_B2-1_Phonics_vD.pdf

  # Split on underscores via awk for flexibility
  eval "$(
    echo "$base" | awk -F'_' '
      function lower(s){ gsub(/[A-Z]/,"&",s); return tolower(s) }
      {
        n=NF
        # Extract grade "GrX"
        grade=$1
        if (match(grade, /^Gr([0-9]{1,2})$/)==0){ print "ok=0"; next }
        gnum=substr(grade,3)
        gfolder="gr" gnum

        subj=$2
        subjl=tolower(subj)

        # Determine strand/group token(s)
        # Case A: Letter + Word (e.g., B_Number) → tokens 3 + 4
        # Case B: Single word group (e.g., ReadingLiterature) → token 3
        strand=""
        idx_after_strand=0
        if ($3 ~ /^[A-F]$/ && $4 ~ /^[A-Za-z]+$/) {
          strand=$3"_"$4
          idx_after_strand=5
        } else {
          strand=$3
          idx_after_strand=4
        }

        # Skill code token (e.g., B1-1 or RL1); if pattern holds
        skill=$idx_after_strand

        # Variant at end must match _vA.._vD
        variant=$n
        if (match($variant, /^v[A-D]\.pdf$/)==0){
          # Sometimes variant comes as last token with .pdf attached to previous
          # Strip .pdf from last field
          sub(/\.pdf$/,"", $n)
        }

        print "ok=1; gfolder=\""gfolder"\"; subject=\""subjl"\"; strand=\""<<strand<<"\""
      }'
  )"

  if [[ "${ok:-0}" != "1" ]]; then
    echo "❌ Unrecognized filename (cannot parse grade/subject/strand): $base"
    ((failed++)); return
  fi

  dest="$BASE/$subject/$gfolder/$strand"
  mkdir -p "$dest"

  if [[ -f "$dest/$base" ]]; then
    echo "↩️  Exists, skipping: $base"
    ((skipped++)); return
  fi

  cp "$PDF" "$dest/$base"
  echo "✅ Added: $dest/$base"
  ((added++))
}

for f in "$@"; do
  route_one "$f"
done

cd "$REPO"
if (( added > 0 )); then
  git add materials
  git commit -m "Auto-route $TYPE PDFs: added $added (skipped=$skipped, failed=$failed)"
  git push
fi

# Post-save quick audit for destination folders touched (ensure vA–vD per stem)
report="$REPO/project_logs/reports/auto_route_audit_$(date +%F_%H%M%S).txt"
mkdir -p "$(dirname "$report")"

{
  echo "Auto-route audit — $(date)"
  echo "Type: $TYPE"
  echo ""
  find "$BASE" -type f -name "*_v[A-D].pdf" | awk -v SUBSEP="\034" '
  {
    f=$0; stem=f; sub(/_v[A-D]\.pdf$/, "", stem);
    seen[stem]=1;
    if (f ~ /_vA\.pdf$/) have[stem,SUBSEP "A"]=1;
    if (f ~ /_vB\.pdf$/) have[stem,SUBSEP "B"]=1;
    if (f ~ /_vC\.pdf$/) have[stem,SUBSEP "C"]=1;
    if (f ~ /_vD\.pdf$/) have[stem,SUBSEP "D"]=1;
  }
  END{
    any=0;
    for (s in seen){
      miss="";
      if (!(s SUBSEP "A" in have)) miss=miss "A ";
      if (!(s SUBSEP "B" in have)) miss=miss "B ";
      if (!(s SUBSEP "C" in have)) miss=miss "C ";
      if (!(s SUBSEP "D" in have)) miss=miss "D ";
      if (length(miss)>0){
        sub(/[ ]+$/, "", miss);
        printf "%s  →  missing variants: %s\n", s, miss;
        any=1;
      }
    }
    if (!any) print "All stems present with vA–vD.";
  }'
  echo ""
  echo "Added=$added  Skipped=$skipped  Failed=$failed"
} > "$report"

echo "📄 Report: $report"
