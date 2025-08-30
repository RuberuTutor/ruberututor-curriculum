## Curriculum Maps

This repository includes scaffolded curriculum maps for the **Ontario Curriculum**:
- Mathematics (2020, revised)
- Language (2023)

### Quick Links

| Grade | Mathematics | Language |
|-------|-------------|----------|
| 1 | [Grade 1 Math](curriculum/ontario/maps/grade1_math.md) | [Grade 1 Language](curriculum/ontario/maps/grade1_language.md) |
| 2 | [Grade 2 Math](curriculum/ontario/maps/grade2_math.md) | [Grade 2 Language](curriculum/ontario/maps/grade2_language.md) |
| 3 | [Grade 3 Math](curriculum/ontario/maps/grade3_math.md) | [Grade 3 Language](curriculum/ontario/maps/grade3_language.md) |
| 4 | [Grade 4 Math](curriculum/ontario/maps/grade4_math.md) | [Grade 4 Language](curriculum/ontario/maps/grade4_language.md) |
| 5 | [Grade 5 Math](curriculum/ontario/maps/grade5_math.md) | [Grade 5 Language](curriculum/ontario/maps/grade5_language.md) |
| 6 | [Grade 6 Math](curriculum/ontario/maps/grade6_math.md) | [Grade 6 Language](curriculum/ontario/maps/grade6_language.md) |
| 7 | [Grade 7 Math]()
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
## Curriculum Maps
- `curriculum/ontario/maps/gradeX_math.md`
- `curriculum/ontario/maps/gradeX_language.md`
