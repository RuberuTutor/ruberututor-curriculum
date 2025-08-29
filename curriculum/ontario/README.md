# Ontario Curriculum Knowledge Base

This folder stores stable references, change logs, and working notes for Ontario curriculum alignment.

## Structure
- `_source_docs/` — PDFs or links metadata for official curriculum docs (do not edit originals)
- `reference/YYYY-MM-DD/` — extracted, normalized summaries (headings, codes, strands) for that snapshot date
- `working_notes/` — drafting, mapping tables, unresolved items
- `CHANGELOG.md` — human-readable record of curriculum updates we observe
- `VERSION` — internal version tag of our mapping set

## Update Flow
1. Save official sources into `_source_docs/` (or link metadata).
2. Create a new `reference/<date>/` snapshot with summarized strands & codes.
3. Update `CHANGELOG.md` with what changed.
4. Bump `VERSION` if mappings or policies changed.
