#!/bin/bash
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
  local base dest ok gfolder subject strand
  [[ -f "$PDF" ]] || { echo "⚠️  Missing file: $PDF"; ((failed++)); return; }
  base="$(basename "$PDF")"

  eval "$(
    echo "$base" | awk -F'_' '
      {
        n=NF
        grade=$1
        if (grade !~ /^Gr[0-9]{1,2}$/) { print "ok=0"; next }
        gnum=substr(grade,3)
        gfolder="gr" gnum

        subj=$2
        subjl=tolower(subj)

        strand=""
        if ($3 ~ /^[A-F]$/ && $4 ~ /^[A-Za-z]+$/) {
          strand=$3"_"$4
        } else {
          strand=$3
        }

        printf "ok=1; gfolder=\"%s\"; subject=\"%s\"; strand=\"%s\"\n", gfolder, subjl, strand
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
