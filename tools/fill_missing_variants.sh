#!/bin/bash
# Clone existing variant (prefers vA, else any present) to fill missing vA–vD in a given folder or entire repo.
set -euo pipefail
TARGET="${1:-materials}"
find "$TARGET" -type d | while read -r dir; do
  mapfile -t stems < <(find "$dir" -maxdepth 1 -type f -name "*_v[A-D].pdf" -print0 | xargs -0 -I{} bash -c 'f="{}"; s="${f%_v?\.pdf}"; echo "$s"' | sort -u)
  for s in "${stems[@]}"; do
    haveA="$s"_vA.pdf
    haveB="$s"_vB.pdf
    haveC="$s"_vC.pdf
    haveD="$s"_vD.pdf
    src=""
    for cand in "$haveA" "$haveB" "$haveC" "$haveD"; do
      [[ -f "$cand" ]] && { src="$cand"; break; }
    done
    [[ -z "$src" ]] && continue
    for v in A B C D; do
      dst="$s"_v"$v".pdf
      if [[ ! -f "$dst" ]]; then
        cp "$src" "$dst"
        echo "Filled: $(basename "$dst")  (from $(basename "$src"))"
      fi
    done
  done
done
