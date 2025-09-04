#!/usr/bin/env python3
import re, subprocess, json, os
from pathlib import Path
from collections import Counter

REPO = Path.cwd()
MAP_ROOT = REPO / "curriculum" / "ontario" / "maps"
OUT_DIR = REPO / "tools" / "qa" / "out"
OUT_TSV = OUT_DIR / "coverage_report.tsv"
OUT_JSON = OUT_DIR / "coverage_report.json"

CODE_RE = re.compile(r'\b([A-F])(\d+)\.(\d+)\b')  # A–F strands

def extract_codes(txt: str):
    return [f"{m.group(1)}{m.group(2)}.{m.group(3)}" for m in CODE_RE.finditer(txt or "")]

def read_source_pdf(md_file: Path):
    for line in (md_file.read_text(encoding="utf-8", errors="ignore")).splitlines():
        if line.strip().startswith("source_pdf:"):
            sp = line.split(":",1)[1].strip()
            p = (REPO / sp).resolve()
            return p if p.exists() and p.suffix.lower()==".pdf" else None
    return None

def pdfto_text(pdf: Path):
    try:
        out = subprocess.check_output(["pdftotext", "-layout", "-nopgbrk", str(pdf), "-"], stderr=subprocess.DEVNULL)
        return out.decode("utf-8", errors="ignore")
    except Exception:
        return ""

def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    records = []
    # Iterate only real files; some dirs may be named with .md
    for md in MAP_ROOT.rglob("*.md"):
        if not md.is_file():
            continue

        md_txt = md.read_text(encoding="utf-8", errors="ignore")
        md_codes = extract_codes(md_txt)
        md_dupes = [k for k,v in Counter(md_codes).items() if v>1]
        md_set = set(md_codes)

        pdf_path = read_source_pdf(md)
        pdf_codes, pdf_set = [], set()
        if pdf_path:
            pdf_txt = pdfto_text(pdf_path)
            pdf_codes = extract_codes(pdf_txt)
            pdf_set = set(pdf_codes)

        missing = sorted(list(pdf_set - md_set))
        extra   = sorted(list(md_set - pdf_set))

        strands_md  = ",".join(sorted(set(c[0] for c in md_set)))
        strands_pdf = ",".join(sorted(set(c[0] for c in pdf_set)))

        records.append({
            "map_file": str(md.relative_to(REPO)),
            "pdf_file": str(pdf_path.relative_to(REPO)) if pdf_path else "",
            "md_count": len(md_codes),
            "pdf_count": len(pdf_codes),
            "md_strands": strands_md,
            "pdf_strands": strands_pdf,
            "duplicates_in_md": sorted(md_dupes),
            "missing_from_md": missing[:200],  # cap for readability
            "extra_in_md": extra[:200]
        })

    # Write TSV
    with OUT_TSV.open("w", encoding="utf-8") as f:
        f.write("map_file\tpdf_file\tmd_count\tpdf_count\tmd_strands\tpdf_strands\tduplicates_in_md\tmissing_from_md\textra_in_md\n")
        for r in records:
            f.write(
                f"{r['map_file']}\t{r['pdf_file']}\t{r['md_count']}\t{r['pdf_count']}\t"
                f"{r['md_strands']}\t{r['pdf_strands']}\t"
                f"{';'.join(r['duplicates_in_md'])}\t{';'.join(r['missing_from_md'])}\t{';'.join(r['extra_in_md'])}\n"
            )

    # Write JSON (full detail)
    with OUT_JSON.open("w", encoding="utf-8") as f:
        json.dump(records, f, indent=2, ensure_ascii=False)

    print(f"Wrote:\n- {OUT_TSV}\n- {OUT_JSON}")

if __name__ == "__main__":
    main()
