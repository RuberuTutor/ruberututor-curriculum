variants-audit:
	bash tools/check_variants.sh
	tail -n 50 `ls -t project_logs/reports/variants_report_*.txt | head -n1`

variants-fill:
	bash tools/fill_missing_variants.sh materials
	bash tools/check_variants.sh
	tail -n 50 `ls -t project_logs/reports/variants_report_*.txt | head -n1`
