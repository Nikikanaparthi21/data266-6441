# My Discussion: HW10 Retrieval Comparisons

**Student:** Nikhil Kanaparthi  
**SID4:** 6441

I compared two chunking approaches on the first 100 arXiv-summarization training documents. I used identical chunk sizes (1,300 characters) and overlap (180 characters), indexed MiniLM embeddings in separate ChromaDB collections, and reranked the same top-20 candidate pools using a cross-encoder.

## My standalone-query results

| Chunking | Reranking | Mean Precision@5 | Mean Recall@5 | Mean MRR@5 |
|---|---|---:|---:|---:|
| Fixed-width | No | 1.0000 | 0.2525 | 1.0000 |
| Fixed-width | Yes | 1.0000 | 0.2525 | 1.0000 |
| Paragraph-aware | No | 1.0000 | 0.2566 | 1.0000 |
| Paragraph-aware | Yes | 1.0000 | 0.2566 | 1.0000 |

I found that reranking changed the order of my retrieved passages without improving these aggregate proxy-based scores. My measured mean standalone latency rose from **10.17 ms** (vector-only) to **74.62 ms** (reranked). The paragraph-aware method had slightly higher Recall@5, but the denominator changes when I change splitting boundaries, so the result is not a definitive win.

## My conversational-memory comparison

For my ambiguous follow-up, adding the previous question raised vector-only Precision@5 from **0.80 to 1.00** with fixed-width chunks and from **0.60 to 1.00** with paragraph-aware chunks. With paragraph-aware reranking, MRR@5 increased from **0.50 to 1.00** when I included memory. I interpret this as evidence that carrying short conversational context can help disambiguate a follow-up question in this test.

## My error analysis and conclusion

I identified a limitation in my reference-article-and-keyword relevance proxy: a retrieved passage directly connecting sudden current changes to bifurcations was marked nonrelevant because it did not match enough keyword signals. I also observed topic drift in a passage about period-doubling bifurcations from another article without an explicit current-reversal connection. These examples mean I cannot equate every proxy-negative with a genuinely unhelpful passage.

I conclude that conversational memory helped my follow-up question, while the two chunking strategies performed similarly on my two standalone questions. Reranking added latency without improving their proxy scores. I report the retrieved evidence, complete measurements, and limitations in `REPORT.md`, `METRICS.md`, and the CSV files.
