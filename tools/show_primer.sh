#!/bin/bash
# Print the RuberuTutor Chat Primer (from PROJECT_README.md)

PRIMER_FILE="$HOME/Dropbox/ruberututor_knowledge_pack/PROJECT_README.md"

if [[ -f "$PRIMER_FILE" ]]; then
  cat "$PRIMER_FILE"
else
  echo "❌ PROJECT_README.md not found at $PRIMER_FILE"
fi
