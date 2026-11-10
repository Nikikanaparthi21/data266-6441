"""Reusable deterministic preprocessing, chunking and evaluation helpers for HW10."""
import re
from langchain_text_splitters import RecursiveCharacterTextSplitter

def clean_article(text):
    """Normalize arXiv tokens without destroying paragraph breaks."""
    text = (text or "").replace("\r\n", "\n").replace("\r", "\n")
    text = re.sub(r"@xmath\d+", " MATH_TOKEN ", text, flags=re.IGNORECASE)
    text = re.sub(r"@xcite(?:\d+)?", " CITATION_TOKEN ", text, flags=re.IGNORECASE)
    lines = []
    for line in text.split("\n"):
        line = re.sub(r"\s+", " ", line).strip()
        line = re.sub(r"\s+([.,!?;:])", r"\1", line)
        if line:
            lines.append(line)
    return "\n".join(lines)

CHUNK_SIZE = 1300
CHUNK_OVERLAP = 180
TOP_K = 5
CANDIDATE_K = 20

SPLITTERS = {
    "fixed": RecursiveCharacterTextSplitter(
        chunk_size=CHUNK_SIZE, chunk_overlap=CHUNK_OVERLAP, separators=[""], length_function=len
    ),
    "paragraph": RecursiveCharacterTextSplitter(
        chunk_size=CHUNK_SIZE, chunk_overlap=CHUNK_OVERLAP,
        separators=["\n\n", "\n", ". ", " ", ""], length_function=len
    ),
}

def make_chunks(papers, strategy):
    """Return stable IDs, text and provenance for ONE vector collection."""
    splitter = SPLITTERS[strategy]
    chunks = []
    for doc_idx, paper in enumerate(papers):
        for part_idx, text in enumerate(splitter.split_text(paper["article"])):
            if not text.strip():
                continue
            assert len(text) <= CHUNK_SIZE, f"Oversized chunk: {len(text)}"
            chunks.append({
                "id": f"{strategy}-d{doc_idx:03d}-c{part_idx:04d}",
                "text": text,
                "doc_index": doc_idx,
                "paper_id": str(paper["id"]),
                "strategy": strategy,
                "chunk_number": part_idx,
            })
    if not chunks:
        raise ValueError("No chunks were produced. Check dataset loading.")
    assert len(chunks) == len({c["id"] for c in chunks}), "Duplicate chunk IDs"
    return chunks

# Deterministic topic-specific relevance policy, chosen independently of the
# embedding model and cross-encoder. The paper index is grounded in the
# abstract, while the chunk must contain at least two topic cues.
QUERY_SPECS = [
    {
        "id": "Q1", "kind": "standalone",
        "query": "Why do additive models achieve favorable learning rates in high-dimensional problems?",
        "anchor_phrases": ["additive models", "learning rates"],
        "signals": ["additive", "learning rate", "kernel", "high dimension"],
    },
    {
        "id": "Q2", "kind": "standalone",
        "query": "How are current reversals in deterministic ratchet systems connected to bifurcations?",
        "anchor_phrases": ["current reversal", "ratchet"],
        "signals": ["ratchet", "current revers", "bifurcat", "chaotic"],
    },
    {
        "id": "FOLLOWUP", "kind": "followup",
        "query": "How do bifurcations help explain that phenomenon?",
        "anchor_phrases": ["current reversal", "ratchet"],
        "signals": ["ratchet", "current revers", "bifurcat", "chaotic"],
    },
]

def find_target_doc(papers, anchor_phrases):
    matches = []
    for idx, doc in enumerate(papers):
        abstract = doc["abstract"].lower()
        if all(phrase in abstract for phrase in anchor_phrases):
            matches.append(idx)
    if not matches:
        raise ValueError("The first 100 abstracts do not include required topic anchors: " + str(anchor_phrases))
    return matches[0]

def topic_relevance(chunk, spec):
    """Explicit weak/manual-rule label; NOT a substitute for human assessments."""
    if chunk["doc_index"] != spec["target_doc_index"]:
        return False
    text = chunk["text"].lower()
    return sum(signal in text for signal in spec["signals"]) >= 2

def retrieval_metrics(retrieved, gold_ids, k=TOP_K):
    hits = [int(row["id"] in gold_ids) for row in retrieved[:k]]
    hits.extend([0] * (k - len(hits)))
    precision = sum(hits) / k
    recall = sum(hits) / len(gold_ids) if gold_ids else float("nan")
    first = next((rank for rank, hit in enumerate(hits, start=1) if hit), None)
    mrr = 1 / first if first else 0.0
    return {"precision_at_k": precision, "recall_at_k": recall, "mrr": mrr}

class SimpleConversationMemory:
    """Minimal explicit memory: add the preceding question to a follow-up."""
    def __init__(self):
        self.last_user_question = None
    def remember(self, question):
        self.last_user_question = question
    def contextualize(self, followup):
        return (self.last_user_question + " " + followup) if self.last_user_question else followup
