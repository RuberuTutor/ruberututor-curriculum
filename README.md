# Ruberututor Knowledge Pack

This pack is your offline **source of truth** for Math/Language curriculum skills, assessment blueprints, and worksheet specs.
Store it in a Git repo and cloud storage. If ChatGPT access is interrupted, you can re-upload this pack to any LLM.

## Contents
- `/data/` – CSVs with strands/skills (samples included)
- `/schemas/` – JSON Schemas for skills and assessment items
- `/prompts/`
  - `ingestion_prompt.txt` – paste this as the system+user prompt to parse new curriculum
  - `assessment_blueprint_template.json` – starter for assessment design
  - `worksheet_style.md` – house style for worksheet generation

## Recommended Workflow
1. Keep this repo on GitHub/Bitbucket + sync to a cloud drive (Google Drive/Dropbox). Follow 3-2-1 backup: 3 copies, 2 media, 1 offsite.
2. As you add skills/items, commit CSV/JSONL files with clear messages.
3. Export item banks as **JSONL** regularly (one object per line) for easy re-ingestion.
4. Keep a `PROMPTBOOK.md` in the repo with tried-and-true prompts/few-shots.
5. Run a quarterly **restore drill**: spin up a new workspace, upload this pack, and recreate assessments to ensure everything works.

## Rapid Re-ingestion
1. Start a new chat.
2. Paste `/prompts/ingestion_prompt.txt` (as system + user).
3. Upload `/data/*.csv` and any JSONL item banks.
4. Ask the model to build an index (by subject/grade/strand/skill_code).
5. Proceed with assessment blueprinting using `assessment_blueprint_template.json`.

## Data Formats
- **Skills**: CSV & JSONL (fields in `schemas/skills.schema.json`).
- **Items**: JSONL using `schemas/assessment_item.schema.json`.

## Security
- Avoid storing student PII here. If unavoidable, encrypt at rest (e.g., gpg, age) and never upload PII to LLMs.