"""My final HW10 package checks. This script never fabricates notebook execution."""
import csv
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
checks = []

def check(name, ok):
    checks.append((name, bool(ok)))
    print(("PASS" if ok else "FAIL") + ": " + name)

notebook = json.loads((ROOT / "HW10_RAG_Reranking_Chunking_Memory_Nikhil_Kanaparthi_6441.ipynb").read_text(encoding="utf-8"))
code_cells = [c for c in notebook["cells"] if c["cell_type"] == "code"]
check("At least one executed code cell has saved outputs", any(c.get("outputs") for c in code_cells))
check("All code cells have saved execution counts", all(c.get("execution_count") is not None for c in code_cells))
for name in ("METRICS.md", "REPORT.md", "AI_USE.md", "RUN_LOG.txt"):
    check(name + " exists and is nonempty", (ROOT / name).is_file() and (ROOT / name).stat().st_size > 0)
for name in ("metrics_results.csv", "retrieval_examples.csv", "relevance_judgments.csv", "retrieval_errors.csv", "run_config.json"):
    check("outputs/" + name + " exists", (ROOT / "outputs" / name).is_file())
for name in ("precision_comparison.png", "memory_comparison.png"):
    check("figures/" + name + " exists", (ROOT / "figures" / name).is_file())
log = (ROOT / "RUN_LOG.txt").read_text(encoding="utf-8")
check("Experiment run log contains success marker", "RUN SUCCESS" in log)
with (ROOT / "outputs" / "metrics_results.csv").open(newline="", encoding="utf-8") as handle:
    rows = list(csv.DictReader(handle))
check("16 measured conditions are recorded", len(rows) == 16)
check("All metrics remain in [0, 1]", all(0.0 <= float(r[m]) <= 1.0 for r in rows for m in ("precision_at_k", "recall_at_k", "mrr")))
check("AI appendix has no unfilled placeholder", "[Write the exact" not in (ROOT / "AI_USE.md").read_text(encoding="utf-8"))
print("\n" + ("READY: all automated checks passed." if all(ok for _,ok in checks) else "NOT READY: resolve the failed checks before submitting."))
raise SystemExit(0 if all(ok for _,ok in checks) else 1)
