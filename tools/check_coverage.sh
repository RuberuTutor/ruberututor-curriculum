#!/usr/bin/env bash
set -euo pipefail

# --- Config ---
# Scan these map files (defaults to all secondary; you can pass paths as args)
MAPS=("$@")
if [ ${#MAPS[@]} -eq 0 ]; then
  while IFS= read -r -d '' f; do
    MAPS+=("$f")
  done < <(find curriculum/ontario/maps -type f -name '*.md' \
            ! -name '_TEMPLATE_*' ! -path '*/_archive/*' -print0)
fi

# --- Helpers ---
have_pdftotext() { command -v pdftotext >/dev/null 2>&1; }

extract_codes_md() {
  # Expectation codes look like A1, A1.1, … up to F (Ontario uses A–F)
  # We take only codes in lists/sections to avoid accidental matches.
  grep -oE '\b[A-F][0-9]+(\.[0-9]+)?\b' "$1" | sort -u
}

extract_codes_pdf() {
  local pdf="$1"
  if have_pdftotext; then
    pdftotext -layout "$pdf" - 2>/dev/null \
      | grep -oE '\b[A-F][0-9]+(\.[0-9]+)?\b' \
      | sort -u
  else
    # Fallback using Python (pdfminer.six required)
    python3 - <<'PY' "$pdf" | grep -oE '\b[A-F][0-9]+(\.[0-9]+)?\b' | sort -u
import sys
from io import StringIO
try:
    from pdfminer.high_level import extract_text
except Exception as e:
    sys.stderr.write("ERROR: Need either 'pdftotext' (poppler) or python 'pdfminer.six'.\n")
    sys.exit(1)
pdf = sys.argv[1]
txt = extract_text(pdf) or ""
sys.stdout.write(txt)
PY
  fi
}

header() { printf "\n\033[1m%s\033[0m\n" "$*"; }
ok()     { printf "  ✅ %s\n" "$*"; }
warn()   { printf "  ⚠️  %s\n" "$*"; }
err()    { printf "  ❌ %s\n" "$*"; }

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

overall_missing=0
overall_extra=0
overall_files=0

for map in "${MAPS[@]}"; do
  overall_files=$((overall_files+1))
  header "• $map"

  # Get source_pdf from front-matter
  src_pdf="$(awk -F': *' 'BEGIN{f=0}
    /^---[[:space:]]*$/{f=!f; next}
    f && $1=="source_pdf" {print $2; exit}' "$map" 2>/dev/null || true)"

  if [ -z "${src_pdf:-}" ]; then
    warn "No 'source_pdf:' found — skipping PDF comparison."
    continue
  fi
  if [ ! -f "$src_pdf" ]; then
    err "Missing PDF: $src_pdf"
    continue
  fi

  md_codes="$tmpdir/$(basename "$map").md.codes"
  pdf_codes="$tmpdir/$(basename "$map").pdf.codes"

  extract_codes_md  "$map"     > "$md_codes"  || true
  extract_codes_pdf "$src_pdf" > "$pdf_codes" || true

  # Report counts
  md_count=$(wc -l < "$md_codes" | tr -d ' ')
  pdf_count=$(wc -l < "$pdf_codes" | tr -d ' ')
  printf "  MD codes:  %d\n" "$md_count"
  printf "  PDF codes: %d\n" "$pdf_count"

  # Compare
  missing="$tmpdir/$(basename "$map").missing"
  extra="$tmpdir/$(basename "$map").extra"

  comm -23 "$pdf_codes" "$md_codes" > "$missing" || true   # In PDF, not in MD
  comm -13 "$pdf_codes" "$md_codes" > "$extra"   || true   # In MD, not in PDF

  miss_n=$(wc -l < "$missing" | tr -d ' ')
  extr_n=$(wc -l < "$extra"   | tr -d ' ')
  overall_missing=$((overall_missing+miss_n))
  overall_extra=$((overall_extra+extr_n))

  if [ "$miss_n" -eq 0 ] && [ "$extr_n" -eq 0 ]; then
    ok "Coverage OK (sets match)"
  else
    [ "$miss_n" -gt 0 ] && err "Missing in MD (present in PDF): $(paste -sd, "$missing")"
    [ "$extr_n" -gt 0 ] && warn "Extra in MD (not in PDF):    $(paste -sd, "$extra")"
  fi
done

header "Summary"
printf "  Files checked: %d\n" "$overall_files"
printf "  Total missing (need to add to MD): %d\n" "$overall_missing"
printf "  Total extra    (likely remove/fix): %d\n" "$overall_extra"

# Exit nonzero if any gaps
[ "$overall_missing" -eq 0 ] || exit 2
