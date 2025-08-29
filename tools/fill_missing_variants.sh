#!/bin/bash
set -euo pipefail
TARGET="${1:-materials}"

find "$TARGET" -type d | while read -r dir; do
  stems=$(find "$dir" -maxdepth 1 -type f -name "*_v[A-D].pdf" \
            | sed -E 's/_v[ABCD]\.pdf$//' | sort -u)
  for s in $stems; do
    src=""
    for cand in "${s}_vA.pdf" "${s}_vB.pdf" "${s}_vC.pdf" "${s}_vD.pdf"; do
      [[ -f "$cand" ]] && { src="$cand"; break; }
    done
    [[ -z "$src" ]] && continue
    for v in A B C D; do
      dst="${s}_v${v}.pdf"
      if [[ ! -f "$dst" ]]; then
        cp "$src" "$dst"
        echo "Filled: $(basename "$dst") (from $(basename "$src"))"
      fi
    done
  done
done
