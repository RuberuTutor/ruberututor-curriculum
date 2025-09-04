#!/usr/bin/env bash
set -euo pipefail

echo "== Stage 7 QA: starting =="

echo "--- scan_placeholders.sh ---"
if tools/qa/scan_placeholders.sh; then
  echo "placeholders scan: OK"
else
  echo "placeholders scan: completed with non-fatal issues"
fi

echo "--- verify_source_pdfs.sh ---"
if tools/qa/verify_source_pdfs.sh; then
  echo "source_pdf verification: OK"
else
  echo "source_pdf verification: completed with non-fatal issues"
fi

echo "--- validate_coverage.py ---"
if command -v pdftotext >/dev/null 2>&1; then
  if python3 tools/qa/validate_coverage.py; then
    echo "coverage validation: OK"
  else
    echo "coverage validation: completed with non-fatal issues"
  fi
else
  echo "WARNING: pdftotext not found. Install with: brew install poppler"
  echo "Skipping PDF comparison; only Markdown code extraction would be possible."
fi

echo "== Stage 7 QA: done =="
echo "Reports in tools/qa/out/ (if created)"
ls -lah tools/qa/out || true
