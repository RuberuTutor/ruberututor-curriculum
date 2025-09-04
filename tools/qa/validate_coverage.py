#!/usr/bin/env python3
import re, subprocess, json, sys, os
from pathlib import Path
from collections import Counter, defaultdict

REPO = Path.cwd()
MAP_ROOT = REPO / "curriculum" / "ontario" / "maps"
OUT_TSV = REPO / "tools" / "qa" / "out" / "coverage_report.tsv"
OUT_JSON = REPO / "tools" / "qa" / "out" / "coverage_report.json"

# Matches codes like A1.1, B1.10, D2.3 etc.
CODE_RE = re.compile(r'\b([A-Z])(\d+)\.(\d+)\b')

def extract_codes_from_text(txt: str):
    return [f"{m.group(1)}{m.group(2)}.{m.group(3)}" for m in CODE_RE.finditer(txt)]

def read_source_pdf(md_file: Path):
    sp = None
    for line in md_file.read_text(encoding="utf-8", errors="ignore").splitlines():
        if line.strip().startswith("source_pdf:"):
            sp = line.split(":",1)[1].strip()
            break
    if not sp:
        return None
    p = (REPO / sp).resolve()
    return p if p.exists() and p.suffix.lower() == ".pdf" else None

def pdfto_text(pdf_path: Path):
    try:
        out = subprocess.check_output(["pdftotext", "-layout", "-nopgbrk", str(pdf_path), "-"], stderr=subprocess.DEVNULL)
        return out.decode("utf-8", errors="ignore")
    except Exception:
        return ""

def md_text(md_path: Path):
    return md_path.read_text(encoding="utf-8", errors="ignore")

def summarize_set(s):
    # Keep small, sorted, semicolon-delimited
    return ";".join(sorted(s, key=lambda x: (x[0], int(x.split('.')[0][1:]), int(x.split('.')[1]))))[:2000]

def main():
    records = []
    for md in MAP_ROOT.rglob("*.md"):
        md_txt = md_text(md)
        md_codes = extract_codes_from_text(md_txt)
        md_dupes = [k for k,v in Counter(md_codes).items() if v>1]
        md_set = set(md_codes)

        pdf_path = read_source_pdf(md)
        pdf_codes, pdf_set = [], set()
        if pdf_path:
            pdf_txt = pdfto_text(pdf_path)
            if pdf_txt:
                pdf_codes = extract_codes_from_text(pdf_txt)
                pdf_set = set(pdf_codes)

        missing = sorted(list(pdf_set - md_set))
        extra   = sorted(list(md_set - pdf_set))

        strands_in_md = sorted(set(c[0] for c in md_set))
        strands_in_pdf = sorted(set(c[0] for c in pdf_set))

        records.append({
            "map_file": str(md.relative_to(REPO)),
            "pdf_file": str(pdf_path.relative_to(REPO)) if pdf_path else "",
            "md_count": len(md_codes),
            "pdf_count": len(pdf_codes) if pdf_set else 0,
            "md_strands": ",".join(strands_in_md),
            "pdf_strands": ",".join(strands_in_pdf),
            "duplicates_in_md": md_dupes,
            "missing_from_md": missing,
            "extra_in_md": extra
        })

    # Write TSV
    OUT_TSV.parent.mkdir(parents=True, exist_ok=True)
    with OUT_TSV.open("w", encoding="utf-8") as f:
        f.write("map_file\tpdf_file\tmd_count\tpdf_count\tmd_strands\tpdf_strands\tduplicates_in_md\tmissing_from_md\textra_in_md\n")
        for r in records:
            f.write(
                f"{r['map_file']}\t{r['pdf_file']}\t{r['md_count']}\t{r['pdf_count']}\t"
                f"{r['md_strands']}\t{r['pdf_strands']}\t"
                f"{summarize_set(r['duplicates_in_md'])}\t{summarize_set(r['missing_from_md'])}\t{summarize_set(r['extra_in_md'])}\n"
            )

    # Write JSON (full detail)
    with OUT_JSON.open("w", encoding="utf-8") as f:
        json.dump(records, f, indent=2, ensure_ascii=False)

    print(f"Wrote:\n- {OUT_TSV}\n- {OUT_JSON}")

if __name__ == "__main__":
    main()
