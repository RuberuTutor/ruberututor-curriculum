# Chat Transcript — full backup before split
- **Date:** 2025-08-28
- **Time (Toronto):** 18:45

---

```
gebra/.

Run one command:

savepdf worksheets math gr3 C_Algebra ~/Downloads/gr3_algebra/*.pdf
worksheets → goes under materials/worksheets/...

math → subject

gr3 → grade

C_Algebra → strand

~/Downloads/gr3_algebra/*.pdf → all your new files

Script copies them into the right folder, commits, and pushes.

🔹 Notes
If you’d rather move (so they disappear from Downloads), change the line in the script from:

cp "$PDF" "$DEST/$base"
to:

mv "$PDF" "$DEST/$base"
If a file already exists, the script will skip it instead of overwriting.

You can use it for assessments too:

savepdf assessments english gr9 ReadingLiterature ~/Downloads/gr9_reading/*.pdf
✅ You’re now set up to comfortably handle 10–20 PDFs per day without clutter.

👉 Do you want me to also show you how the repo tree looks after you run savepdf once, so you can visually confirm where your worksheets/assessments land?

You said:
Yes
ChatGPT said:
Great 👍 — let’s walk through exactly what happens when you run savepdf and how your repo tree looks.

🔹 Example command
Suppose you run:

savepdf worksheets math gr3 C_Algebra ~/Downloads/gr3_algebra/*.pdf
…and you had 3 files named:

Gr3_Math_C_Algebra_C3-1_Simple_Equations_vA.pdf
Gr3_Math_C_Algebra_C3-1_Simple_Equations_vB.pdf
Gr3_Math_C_Algebra_C3-1_Simple_Equations_vC.pdf
🔹 After running
The script copies them into your repo under:

materials/
  worksheets/
    math/
      gr3/
        C_Algebra/
          Gr3_Math_C_Algebra_C3-1_Simple_Equations_vA.pdf
          Gr3_Math_C_Algebra_C3-1_Simple_Equations_vB.pdf
          Gr3_Math_C_Algebra_C3-1_Simple_Equations_vC.pdf
…and at the same time it does:

git add for those files

git commit -m "Add worksheets math gr3 C_Algebra: 3 file(s)"

git push to GitHub

So they’re now in Dropbox (local) and GitHub (cloud).

🔹 To see the structure locally
In Terminal:

cd ~/Dropbox/ruberututor_knowledge_pack
ls -R materials/worksheets/math/gr3/C_Algebra
You’ll see:

Gr3_Math_C_Algebra_C3-1_Simple_Equations_vA.pdf
Gr3_Math_C_Algebra_C3-1_Simple_Equations_vB.pdf
Gr3_Math_C_Algebra_C3-1_Simple_Equations_vC.pdf
🔹 To confirm on GitHub
Go to your repo on GitHub in the browser.

Navigate to:

materials → worksheets → math → gr3 → C_Algebra
You should see the PDFs listed there with the same filenames.

✅ This gives you a clean, predictable filing system for all future worksheets and assessments.

👉 Do you want me to also show you the parallel example for assessments (so you see how both sides of the tree mirror each other)?

You said:
What does repo stand for
ChatGPT said:
Great question 👌

Repo is short for repository.

In simple terms, a Git repository (repo) is:

A special folder on your computer that Git tracks.

Every file inside it is under version control (Git records every change you make).

That folder is also linked to GitHub (your remote backup in the cloud).

So in your case:

📂 Local repo (on your Mac / Dropbox):

~/Dropbox/ruberututor_knowledge_pack
📂 Remote repo (on GitHub):

https://github.com/RuberuTutor/ruberututor-curriculum
They’re kept in sync:

When you run git add + git commit, Git records changes locally.

When you run git push, Git sends those changes to GitHub.

If you ever work on a new computer, you can git clone the repo from GitHub to restore everything.

✅ So: Repo = the folder that Git and GitHub are tracking for you.

👉 Do you want me to show you a diagram of how your repo connects your Mac → Dropbox → GitHub?```
