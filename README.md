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
| 4 | [Grade 4 Math](curriculum/ontario/maps/grade4_math.md) | [Grade 4 Language](curr)_)
mkdir -p curriculum/ontario/maps
printf "# Grade 9 Math (De-streamed)\n\n*Content coming soon.*\n" > curriculum/ontario/maps/grade9_math.md
printf "# Grade 9 Language (English)\n\n*Content coming soon.*\n" > curriculum/ontario/maps/grade9_language.md
git add curriculum/ontario/maps/grade9_*.md
git commit -m "docs: add Grade 9 placeholder files"
git push
git show origin/main:README.md | sed -n '1,160p' | sed -n '/^## Curriculum Maps/,$p' | sed -n '1,40p'
# 0) Make sure you're on main
git rev-parse --abbrev-ref HEAD

# 1) Restore README to last committed version (wipes the broken partial)
git checkout -- README.md

# 2) Append the correct Curriculum Maps section (no quoting, properly closed heredoc)
cat >> README.md <<'MD'
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
| 7 | [Grade 7 Math](curriculum/ontario/maps/grade7_math.md) | [Grade 7 Language](curriculum/ontario/maps/grade7_language.md) |
| 8 | [Grade 8 Math](curriculum/ontario/maps/grade8_math.md) | [Grade 8 Language](curriculum/ontario/maps/grade8_language.md) |
| 9 | *(De-streamed Math — coming soon)* | *(English — coming soon)* |
