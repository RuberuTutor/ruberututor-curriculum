#!/usr/bin/env bash
set -euo pipefail
fail=0

echo "🔎 Checking required directories…"
dirs=(
  project_logs/conversations/misc
  project_logs/conversations/assessments
  materials/worksheets/math
  materials/worksheets/english
  materials/assessments/math
  materials/assessments/english
  curriculum/ontario
  curriculum/ontario/maps/secondary
)
for d in "${dirs[@]}"; do
  if [[ -d "$d" ]]; then
    echo "  ✅ $d"
  else
    echo "  ❌ Missing dir: $d"; fail=1
  fi
done

echo -e "\n🔎 Scanning secondary map files for required sections…"
shopt -s nullglob
maps=(curriculum/ontario/maps/secondary/*.md)
if [[ ${#maps[@]} -eq 0 ]]; then
  echo "  ⚠️ No .md maps found yet under curriculum/ontario/maps/secondary"
else
  for f in "${maps[@]}"; do
    echo "  • $f"
    miss=0
    for h in "Strands Overview" "Overall Expectations" "Specific Expectations" "Planning Tables" "Changelog"; do
      if ! grep -qE "## +.*${h}" "$f"; then
        echo "    ❌ Missing section: $h"; miss=1
      fi
    done
    [[ $miss -eq 0 ]] && echo "    ✅ Sections OK"
  done
fi

echo -e "\n🔎 Checking for expectation code format (e.g., B2.1, C1.4)…"
if ! grep -RnoE '\b[A-F][0-9]+\.[0-9]+' curriculum/ontario/maps/secondary >/dev/null 2>&1; then
  echo "  ⚠️ No codes matched yet (add specific expectations to your maps)"
else
  grep -RnoE '\b[A-F][0-9]+\.[0-9]+' curriculum/ontario/maps/secondary | sed 's/^/  • /'
fi

echo -e "\n🔎 Recommended: avoid committing the template as a finished course"
if ls curriculum/ontario/maps/secondary/_TEMPLATE_SECONDARY_MAP.md >/dev/null 2>&1; then
  echo "  ℹ️ Template present: curriculum/ontario/maps/secondary/_TEMPLATE_SECONDARY_MAP.md"
fi

exit $fail
