#!/usr/bin/env python3
import re, subprocess, json
from pathlib import Path
from collections import Counter

REPO = Path.cwd()
MAP_ROOT = REPO / "curriculum" / "ontario" / "maps"
OUT_DIR = REPO / "tools" / "qa" / "out"
OUT_TSV = OUT_DIR / "coverage_report.tsv"
OUT_JSON = OUT_DIR / "coverage_report.json"

# Strict A1.1 (with optional spaces)
STRICT = re.compile(r'\b([A-F])\s*(\d)\s*\.\s*(\d+)\b')
# Bare 1.1 (no strand letter)
BARE   = re.compile(r'\b(\d)\s*\.\s*(\d+)\b')
# Heuristics to detect current strand in PDF text
STRAND_HDRS = [
    re.compile(r'^\s*Strand\s+([A-F])\b', re.I),
    re
mark "J1 — Upgrade validator to infer strand for bare codes like 1.1"
cat > tools/qa/validate_coverage.py <<'PY'
#!/usr/bin/env python3
import re, subprocess, json
from pathlib import Path
from collections import Counter

REPO = Path.cwd()
MAP_ROOT = REPO / "curriculum" / "ontario" / "maps"
OUT_DIR = REPO / "tools" / "qa" / "out"
OUT_TSV = OUT_DIR / "coverage_report.tsv"
OUT_JSON = OUT_DIR / "coverage_report.json"

# Strict A1.1 (with optional spaces)
STRICT = re.compile(r'\b([A-F])\s*(\d)\s*\.\s*(\d+)\b')
# Bare 1.1 (no strand letter)
BARE   = re.compile(r'\b(\d)\s*\.\s*(\d+)\b')
# Heuristics to detect current strand in PDF text
STRAND_HDRS = [
    re.compile(r'^\s*Strand\s+([A-F])\b', re.I),
    re.compile(r'^\s*([A-F])\s*[\.:–-]\s'),      # "A: …" or "A. …"
    re.compile(r'^\s*([A-F])\s{2,}'),            # Big heading with letter then big gap
]

def pdfto_text(pdf: Path) -> str:
    try:
        out = subprocess.check_output(
            ["pdftotext", "-layout", "-nopgbrk", str(pdf), "-"],
            stderr=subprocess.DEVNULL
        )
        return out.decode("utf-8", errors="ignore")
    except Exception:
        return ""

def read_source_pdf(md_file: Path):
    for line in md_file.read_text(encoding="utf-8", errors="ignore").splitlines():
        if line.strip().startswith("source_pdf:"):
            sp = line.split(":",1)[1].strip()
            p = (REPO / sp).resolve()
            return p if p.exists() and p.suffix.lower()==".pdf" else None
    return None

def extract_pdf_codes(txt: str):
    # First, try strict A1.1 extraction
    hits = [f"{L}{d}.{s}" for (L,d,s) in STRICT.findall(txt)]
    if len(hits) >= 5:
        return hits

    # Fallback: walk lines, keep current strand, attach to bare 1.1 codes
    cur = None
    out = []
    for raw in txt.splitlines():
        line = raw.strip()
        # Update current strand letter when a header-ish line is seen
        for pat in STRAND_HDRS:
            m = pat.search(line)
            if m:
                cur = m.group(1).upper()
                break
        # Collect strict codes if they appear
        for (L,d,s) in STRICT.findall(line):
            out.append(f"{L}{d}.{s}")
        # Collect bare codes if we have a current strand
        if cur:
            for (d,s) in BARE.findall(line):
                out.append(f"{cur}{d}.{s}")
    return out

def extract_md_codes(txt: str):
    # Strict in MD (we expect A1.1 form)
    STRICT_MD = re.compile(r'\b([A-F])(\d)\.(\d+)\b')
    return [f"{L}{d}.{s}" for (L,d,s) in STRICT_MD.findall(txt)]

def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    records = []

    for md in MAP_ROOT.rglob("*.md"):
        if not md.is_file():  # guard against weird dirs named *.md
            continue

        md_txt = md.read_text(encoding="utf-8", errors="ignore")
        md_codes = extract_md_codes(md_txt)
        md_dupes = [k for k,v in Counter(md_codes).items() if v>1]
        md_set   = set(md_codes)

        pdf = read_source_pdf(md)
        pdf_codes, pdf_set = [], set()
        if pdf:
            pdf_txt = pdfto_text(pdf)
            pdf_codes = extract_pdf_codes(pdf_txt)
            pdf_set   = set(pdf_codes)

        missing = sorted(list(pdf_set - md_set))
        extra   = sorted(list(md_set - pdf_set))

        records.append({
            "map_file": str(md.relative_to(REPO)),
            "pdf_file": str(pdf.relative_to(REPO)) if pdf else "",
            "md_count": len(md_codes),
            "pdf_count": len(pdf_codes),
            "md_strands": ",".join(sorted({c[0] for c in md_set})),
            "pdf_strands": ",".join(sorted({c[0] for c in pdf_set})),
            "duplicates_in_md": sorted(md_dupes),
            "missing_from_md": missing[:200],
            "extra_in_md": extra[:200],
        })

    # TSV
    with OUT_TSV.open("w", encoding="utf-8") as f:
        f.write("map_file\tpdf_file\tmd_count\tpdf_count\tmd_strands\tpdf_strands\tduplicates_in_md\tmissing_from_md\textra_in_md\n")
        for r in records:
            f.write(
                f"{r['map_file']}\t{r['pdf_file']}\t{r['md_count']}\t{r['pdf_count']}\t"
                f"{r['md_strands']}\t{r['pdf_strands']}\t"
                f"{';'.join(r['duplicates_in_md'])}\t{';'.join(r['missing_from_md'])}\t{';'.join(r['extra_in_md'])}\n"
            )
    # JSON (full)
    with OUT_JSON.open("w", encoding="utf-8") as f:
        json.dump(records, f, indent=2, ensure_ascii=False)

    print(f"Wrote:\n- {OUT_TSV}\n- {OUT_JSON}")

if __name__ == "__main__":
    main()
