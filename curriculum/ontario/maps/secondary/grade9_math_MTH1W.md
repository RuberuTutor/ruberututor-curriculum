---
title: "Grade 9 Mathematics — Ontario Curriculum (MTH1W, 2021)"
grade: 9
subject: mathematics
course_code: MTH1W
sources:
  - "The Ontario Curriculum, Grade 9: Mathematics (2021) — official PDF"
last_reviewed: 2025-08-30
---

# Expectations by Strand

## Strand A: Mathematical Thinking and Making Connections

pbpaste >> "$FILE"


---

## Strand B: Number

pbpaste >> "$FILE"


---

## Strand C: Algebra

pbpaste >> "$FILE"


---

## Strand D: Data

# Copy from PDF: Strand D Overall + D1./D2. specifics → to clipboard
pbpaste >> "$FILE"

grep -n "## Strand D" "$FILE"
egrep -n "^D[12]\.[0-9]+" "$FILE" | head


---

## Strand E: Geometry and Measurement

# Copy from PDF: Strand E Overall + E1.x specifics → to clipboard
pbpaste >> "$FILE"

grep -n "## Strand E" "$FILE"
egrep -n "^E1\.[0-9]+" "$FILE" | head


---

## Strand F: Financial Literacy

# Copy from PDF: Strand F Overall + F1.x specifics → to clipboard
pbpaste >> "$FILE"

grep -n "## Strand F" "$FILE"
egrep -n "^F1\.[0-9]+" "$FILE" | head


---

# Planning

## Worksheets (vA–vD)
| Unit | Strand | Expectations | Variant(s) | Path |
|------|--------|--------------|------------|------|
|      |        |              | vA / vB / vC / vD | materials/worksheets/math/grade9/… |

## Assessments (vA–vD)
| Type | Strand | Expectations | Variant | Path |
|------|--------|--------------|---------|------|
| Quiz/Task | | | vA–vD | materials/assessments/math/grade9/… |

---

# Changelog
- 2025-08-30: Populated verbatim from official MTH1W (2021) PDF.


## Strand B: Number

# Strand B
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(B[123]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(B[123]\.[0-9]+)/\1/' "$FILE"
egrep -n "^B[123]\.[0-9]+" "$FILE" | head

# Strand C
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(C[1-4]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(C[1-4]\.[0-9]+)/\1/' "$FILE"
egrep -n "^C[1-4]\.[0-9]+" "$FILE" | head

# Strand D
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(D[12]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(D[12]\.[0-9]+)/\1/' "$FILE"
egrep -n "^D[12]\.[0-9]+" "$FILE" | head

# Strand E
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(E1\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(E1\.[0-9]+)/\1/' "$FILE"
egrep -n "^E1\.[0-9]+" "$FILE" | head

# Strand F
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(F1\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(F1\.[0-9]+)/\1/' "$FILE"
egrep -n "^F1\.[0-9]+" "$FILE" | head


---

## Strand C: Algebra

# Strand B
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(B[123]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(B[123]\.[0-9]+)/\1/' "$FILE"
egrep -n "^B[123]\.[0-9]+" "$FILE" | head

# Strand C
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(C[1-4]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(C[1-4]\.[0-9]+)/\1/' "$FILE"
egrep -n "^C[1-4]\.[0-9]+" "$FILE" | head

# Strand D
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(D[12]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(D[12]\.[0-9]+)/\1/' "$FILE"
egrep -n "^D[12]\.[0-9]+" "$FILE" | head

# Strand E
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(E1\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(E1\.[0-9]+)/\1/' "$FILE"
egrep -n "^E1\.[0-9]+" "$FILE" | head

# Strand F
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(F1\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(F1\.[0-9]+)/\1/' "$FILE"
egrep -n "^F1\.[0-9]+" "$FILE" | head


---

## Strand D: Data

# Strand B
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(B[123]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(B[123]\.[0-9]+)/\1/' "$FILE"
egrep -n "^B[123]\.[0-9]+" "$FILE" | head

# Strand C
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(C[1-4]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(C[1-4]\.[0-9]+)/\1/' "$FILE"
egrep -n "^C[1-4]\.[0-9]+" "$FILE" | head

# Strand D
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(D[12]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(D[12]\.[0-9]+)/\1/' "$FILE"
egrep -n "^D[12]\.[0-9]+" "$FILE" | head

# Strand E
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(E1\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(E1\.[0-9]+)/\1/' "$FILE"
egrep -n "^E1\.[0-9]+" "$FILE" | head

# Strand F
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(F1\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(F1\.[0-9]+)/\1/' "$FILE"
egrep -n "^F1\.[0-9]+" "$FILE" | head


---

## Strand E: Geometry and Measurement

# Strand B
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(B[123]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(B[123]\.[0-9]+)/\1/' "$FILE"
egrep -n "^B[123]\.[0-9]+" "$FILE" | head

# Strand C
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(C[1-4]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(C[1-4]\.[0-9]+)/\1/' "$FILE"
egrep -n "^C[1-4]\.[0-9]+" "$FILE" | head

# Strand D
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(D[12]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(D[12]\.[0-9]+)/\1/' "$FILE"
egrep -n "^D[12]\.[0-9]+" "$FILE" | head

# Strand E
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(E1\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(E1\.[0-9]+)/\1/' "$FILE"
egrep -n "^E1\.[0-9]+" "$FILE" | head

# Strand F
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(F1\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(F1\.[0-9]+)/\1/' "$FILE"
egrep -n "^F1\.[0-9]+" "$FILE" | head


---

## Strand F: Financial Literacy

# Strand B
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(B[123]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(B[123]\.[0-9]+)/\1/' "$FILE"
egrep -n "^B[123]\.[0-9]+" "$FILE" | head

# Strand C
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(C[1-4]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(C[1-4]\.[0-9]+)/\1/' "$FILE"
egrep -n "^C[1-4]\.[0-9]+" "$FILE" | head

# Strand D
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(D[12]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(D[12]\.[0-9]+)/\1/' "$FILE"
egrep -n "^D[12]\.[0-9]+" "$FILE" | head

# Strand E
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(E1\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(E1\.[0-9]+)/\1/' "$FILE"
egrep -n "^E1\.[0-9]+" "$FILE" | head

# Strand F
pbpaste >> "$FILE"
sed -i '' -E 's/^\*\*(F1\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(F1\.[0-9]+)/\1/' "$FILE"
egrep -n "^F1\.[0-9]+" "$FILE" | head


---

## Strand A: Mathematical Thinking and Making Connections

printf "\n## Strand A: Mathematical Thinking and Making Connections\n\n" >> "$FILE"
pbpaste >> "$FILE"
printf "\n\n---\n" >> "$FILE"

# Normalize if bold bullets got copied (optional but helpful for greps)
sed -i '' -E 's/^\*\*(A[12]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(A[12]\.[0-9]+)/\1/' "$FILE"

egrep -n "^A[12]\.[0-9]+" "$FILE" | head


---

## Strand B: Number

printf "\n## Strand B: Number\n\n" >> "$FILE"
pbpaste >> "$FILE"
printf "\n\n---\n" >> "$FILE"

sed -i '' -E 's/^\*\*(B[123]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(B[123]\.[0-9]+)/\1/' "$FILE"

egrep -n "^B[123]\.[0-9]+" "$FILE" | head


---

## Strand C: Algebra

printf "\n## Strand C: Algebra\n\n" >> "$FILE"
pbpaste >> "$FILE"
printf "\n\n---\n" >> "$FILE"

sed -i '' -E 's/^\*\*(C[1-4]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(C[1-4]\.[0-9]+)/\1/' "$FILE"

egrep -n "^C[1-4]\.[0-9]+" "$FILE" | head


---

## Strand D: Data

printf "\n## Strand D: Data\n\n" >> "$FILE"
pbpaste >> "$FILE"
printf "\n\n---\n" >> "$FILE"

sed -i '' -E 's/^\*\*(D[12]\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(D[12]\.[0-9]+)/\1/' "$FILE"

egrep -n "^D[12]\.[0-9]+" "$FILE" | head


---

## Strand E: Geometry and Measurement

printf "\n## Strand E: Geometry and Measurement\n\n" >> "$FILE"
pbpaste >> "$FILE"
printf "\n\n---\n" >> "$FILE"

sed -i '' -E 's/^\*\*(E1\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(E1\.[0-9]+)/\1/' "$FILE"

egrep -n "^E1\.[0-9]+" "$FILE" | head


---

## Strand F: Financial Literacy

printf "\n## Strand F: Financial Literacy\n\n" >> "$FILE"
pbpaste >> "$FILE"
printf "\n\n---\n" >> "$FILE"

sed -i '' -E 's/^\*\*(F1\.[0-9]+)\*\*/\1/' "$FILE"
sed -i '' -E 's/^[[:space:]]*[-•][[:space:]]*(F1\.[0-9]+)/\1/' "$FILE"

egrep -n "^F1\.[0-9]+" "$FILE" | head


---
