"""Quick structural validation; full data evaluation still requires Colab/internet."""
import ast
import json
from pathlib import Path

base = Path(__file__).resolve().parents[1]
notebook = json.loads((base / "HW10_RAG_Reranking_Chunking_Memory_Nikhil_Kanaparthi_6441.ipynb").read_text(encoding="utf-8"))
assert notebook["nbformat"] == 4
cells = notebook["cells"]
code_cells = [cell for cell in cells if cell["cell_type"] == "code"]
assert len(code_cells) >= 10
first_code = "".join(code_cells[0]["source"])
for key in ("SID4", "SEED", "SLICE", "HP_ID", "CLS_A", "CLS_B"):
    assert key in first_code
for cell in code_cells:
    src = "".join(cell["source"])
    src = "\n".join(line for line in src.splitlines() if not line.lstrip().startswith("%"))
    ast.parse(src)
raw = (base / "src" / "hw10_core.py").read_text(encoding="utf-8")
ast.parse(raw)
alltext = "\n".join("".join(c["source"]) for c in cells)
for snippet in ('ccdv/arxiv-summarization', '"document"', 'Chroma', 'CrossEncoder',
                'SimpleConversationMemory', 'precision_at_k', 'recall_at_k', 'mrr'):
    assert snippet in alltext, snippet
print(f"PASS: {len(cells)} notebook cells; {len(code_cells)} code cells; source parses; features present")
print("NOTE: Not an execution of the real dataset/model workflow.")
