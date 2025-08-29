#!/bin/bash
set -euo pipefail

ROOT="materials"
OUT="project_logs/reports/variants_report_$(date +%F).txt"
mkdir -p "$(dirname "$OUT")"

{
  echo "Variant audit — $(date)"
  echo ""
  find "$ROOT" -type f -name "*_v[A-D].pdf" | awk -v SUBSEP="\034" '
  {
    file=$0
    stem=file
    sub(/_v[A-D]\.pdf$/, "", stem)
    seen[stem]=1
    if (file ~ /_vA\.pdf$/) have[stem,SUBSEP "A"]=1
    if (file ~ /_vB\.pdf$/) have[stem,SUBSEP "B"]=1
    if (file ~ /_vC\.pdf$/) have[stem,SUBSEP "C"]=1
    if (file ~ /_vD\.pdf$/) have[stem,SUBSEP "D"]=1
  }
  END{
    missing_total=0
    for (s in seen){
      miss=""
      if (!(s SUBSEP "A" in have)) miss=miss "A "
      if (!(s SUBSEP "B" in have)) miss=miss "B "
      if (!(s SUBSEP "C" in have)) miss=miss "C "
      if (!(s SUBSEP "D" in have)) miss=miss "D "
      if (length(miss)>0){
        sub(/[ ]+$/, "", miss)
        printf "%s  →  missing variants: %s\n", s, miss
        missing_total++
      }
    }
    if (missing_total==0){
      print "All worksheet/assessment PDFs have complete variants (vA–vD)."
    }
  }'
  echo ""
  echo "Report saved to: $OUT"
} >"$OUT"

echo "Report saved to: $OUT"
