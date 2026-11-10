# DATA 266 — Homework 10 Metrics

**Student SID4:** 6441  
**Seed:** 6441  
**Dataset:** ccdv/arxiv-summarization / document / train / first 100 documents  
**Chunk sizes:** 1300 characters; overlap 180 for both splitters  
**Top K:** 5; **Candidate pool:** 20  
**Embedding:** `sentence-transformers/all-MiniLM-L6-v2`  
**Vector DB:** persistent ChromaDB, cosine distance  
**Reranker:** `cross-encoder/ms-marco-MiniLM-L-6-v2`  
**Relevance:** I used paper/keyword proxy labels, not independent human annotations  

## All measured conditions

| strategy   | query_id   | reranking   | memory   |   gold_chunks |   precision_at_k |   recall_at_k |    mrr |   latency_ms |
|:-----------|:-----------|:------------|:---------|--------------:|-----------------:|--------------:|-------:|-------------:|
| fixed      | Q1         | False       | False    |            18 |           1.0000 |        0.2778 | 1.0000 |      10.7918 |
| fixed      | Q1         | True        | False    |            18 |           1.0000 |        0.2778 | 1.0000 |      71.6388 |
| fixed      | Q2         | False       | False    |            22 |           1.0000 |        0.2273 | 1.0000 |       9.1985 |
| fixed      | Q2         | True        | False    |            22 |           1.0000 |        0.2273 | 1.0000 |      74.9845 |
| fixed      | FOLLOWUP   | False       | False    |            22 |           0.8000 |        0.1818 | 1.0000 |       8.7907 |
| fixed      | FOLLOWUP   | True        | False    |            22 |           1.0000 |        0.2273 | 1.0000 |      66.9448 |
| fixed      | FOLLOWUP   | False       | True     |            22 |           1.0000 |        0.2273 | 1.0000 |      10.8602 |
| fixed      | FOLLOWUP   | True        | True     |            22 |           1.0000 |        0.2273 | 1.0000 |      82.3623 |
| paragraph  | Q1         | False       | False    |            19 |           1.0000 |        0.2632 | 1.0000 |      11.5082 |
| paragraph  | Q1         | True        | False    |            19 |           1.0000 |        0.2632 | 1.0000 |      85.3650 |
| paragraph  | Q2         | False       | False    |            20 |           1.0000 |        0.2500 | 1.0000 |       9.1635 |
| paragraph  | Q2         | True        | False    |            20 |           1.0000 |        0.2500 | 1.0000 |      66.4916 |
| paragraph  | FOLLOWUP   | False       | False    |            20 |           0.6000 |        0.1500 | 1.0000 |       8.7389 |
| paragraph  | FOLLOWUP   | True        | False    |            20 |           0.6000 |        0.1500 | 0.5000 |      64.6934 |
| paragraph  | FOLLOWUP   | False       | True     |            20 |           1.0000 |        0.2500 | 1.0000 |       9.3663 |
| paragraph  | FOLLOWUP   | True        | True     |            20 |           1.0000 |        0.2500 | 1.0000 |      67.2971 |

## Standalone query mean (Q1 and Q2)

| strategy   | reranking   |   precision_at_k |   recall_at_k |    mrr |
|:-----------|:------------|-----------------:|--------------:|-------:|
| fixed      | False       |           1.0000 |        0.2525 | 1.0000 |
| fixed      | True        |           1.0000 |        0.2525 | 1.0000 |
| paragraph  | False       |           1.0000 |        0.2566 | 1.0000 |
| paragraph  | True        |           1.0000 |        0.2566 | 1.0000 |

## How I interpret these metrics

I calculated Recall@5 as the fraction of **all rule-relevant chunks** returned among the top five in each strategy's index. I did not calculate document-level recall, and I recognize that the number of relevant chunks varies with the chunking strategy. I calculated MRR@5 using the rank of the first rule-relevant chunk. I measured the latency of each retrieval request during my run; it depends on the execution environment. I used an automated paper/keyword relevance proxy rather than a manually curated gold standard, so I do not treat the numbers as human-judged answer quality.

I summarized the observed comparisons and relevance-label limitations in `REPORT.md`.
