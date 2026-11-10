# DATA 266 — Homework 10: Improving RAG

**Student parameters:** SID4 = 6441; SEED = 6441; SLICE = 441; HP_ID = 3; CLS_A = 1; CLS_B = 7.  
**Experiment:** Reranking, chunking, and conversational memory for scientific-document retrieval.

## 1. My objective

In this homework, I investigated how the chunking method, cross-encoder reranking, and a simple conversational-memory mechanism affected the quality of retrieved scientific passages. I compared all approaches on the same collection of 100 research articles and recorded Precision@5, Recall@5, and MRR@5. I used the supplied course examples as a starting point and adapted the workflow to the requirements of HW10.

## 2. Dataset and preprocessing

I used the **first 100 documents from the unshuffled `train` split** of Hugging Face `ccdv/arxiv-summarization`, with the **`document` configuration** rather than the pre-chunked `section` version. I indexed the complete `article` field and used each `abstract` only to locate papers relevant to my sample queries. My preprocessing normalized whitespace and punctuation and replaced the arXiv math and citation placeholders with readable tokens. The execution log records **3,636,236 article characters** across these documents.

## 3. My implementation

I tested two text-splitting methods. For the **fixed-width** strategy, I split the article text into character windows. For the **paragraph-aware** strategy, I preferred paragraph, newline, and sentence boundaries before falling back to characters. I used a maximum chunk size of **1,300 characters** and an overlap of **180 characters** in both cases to make the comparison more consistent.

I embedded each chunk with `sentence-transformers/all-MiniLM-L6-v2` and stored the vectors in separate cosine-distance collections in **ChromaDB**. For each query, I first retrieved **20** vector-search candidates. My vector-only baseline returned the first five; my reranked method used `cross-encoder/ms-marco-MiniLM-L-6-v2` to reorder the **same candidate pool** before keeping five. This isolates the reranking step from changes in the initial candidate retrieval.

I selected the following two standalone questions from topics present in the 100-document subset:

- **Q1:** Why do additive models achieve favorable learning rates in high-dimensional problems?
- **Q2:** How are current reversals in deterministic ratchet systems connected to bifurcations?

For conversational memory, I asked **“What is current reversal in deterministic ratchet systems?”** and then **“How do bifurcations help explain that phenomenon?”**. I compared searching the second question alone against searching it with the first question prepended as context. This is lightweight query-context memory, not a trained conversational model or an answer-generation evaluation.

## 4. My evaluation protocol

I calculated **Precision@5** as the fraction of the five returned chunks marked relevant, **Recall@5** as the fraction of all rule-relevant chunks in that strategy's index appearing in the top five, and **MRR@5** as the reciprocal rank of the first rule-relevant result (zero if there was no such result).

I used a **predefined automated relevance proxy**, not independent human judgments: a chunk had to belong to the topic's reference article and contain at least two of the topic's keyword signals. I kept this policy fixed between retrieval and reranking methods. These labels help make my experiment reproducible, but they can miss genuinely useful passages; I therefore interpret these metrics as *proxy-based retrieval measures*, not definitive measures of answer quality. Because the chunk boundaries and number of relevant chunks differ between the strategies, direct comparisons of Recall@5 also need caution.

## 5. My measured results

### 5.1 Standalone-query averages (Q1 and Q2)

| Chunking        | Reranking   |   Precision@5 |   Recall@5 |   MRR@5 |   Mean retrieval latency (ms) |
|:----------------|:------------|--------------:|-----------:|--------:|------------------------------:|
| Fixed-width     | No          |             1 |      0.253 |       1 |                          10   |
| Fixed-width     | Yes         |             1 |      0.253 |       1 |                          73.3 |
| Paragraph-aware | No          |             1 |      0.257 |       1 |                          10.3 |
| Paragraph-aware | Yes         |             1 |      0.257 |       1 |                          75.9 |

The table averages **Q1 and Q2** for each combination of chunking and reranking. My results show that both chunking methods achieved **Precision@5 = 1.000 and MRR@5 = 1.000**, with and without reranking, under the proxy labeling policy. Reranking changed the order of some passages but **did not improve these aggregate quality scores**. The paragraph-aware method produced a slightly higher mean Recall@5 (**0.2566 versus 0.2525**) without reranking; that difference is small and the strategies have different recall denominators.

The recorded mean retrieval latency over the standalone queries was **10.17 ms** without reranking and **74.62 ms** with reranking. Thus, the cross-encoder added measurable overhead in this run without increasing the proxy-based top-five scores. I treat these timings as run-specific observations, not general hardware benchmarks.

### 5.2 Examples of retrieved evidence before and after reranking

| Query   | Chunking        | Vector-only top-1    | Reranked top-1       | Reranked top-1 evidence (excerpt)                                                                                    |
|:--------|:----------------|:---------------------|:---------------------|:---------------------------------------------------------------------------------------------------------------------|
| Q1      | Fixed-width     | fixed-d000-c0023     | fixed-d000-c0017     | ncreased interpretability, and ( often ) a reduced proneness of the curse of high dimensions. hence it is important… |
| Q2      | Fixed-width     | fixed-d002-c0005     | fixed-d002-c0005     | operties of a chaotic ratchet are not as simple as the initial conjecture. however, we do find evidence for a gener… |
| Q1      | Paragraph-aware | paragraph-d000-c0017 | paragraph-d000-c0000 | additive models CITATION_TOKEN provide an important family of models for semiparametric regression or classificatio… |
| Q2      | Paragraph-aware | paragraph-d002-c0002 | paragraph-d002-c0025 | . in the case of chaotic deterministic ratchets, we have shown that it is important to factor out issues of size, l… |

I inspected the recorded top-ranked examples in `outputs/retrieval_examples.csv`. For Q1, the retrieved passages concern additive-kernel learning rates; for Q2, they discuss current changes and bifurcations in deterministic ratchets. Reranking sometimes selected a **different** top passage, even though the aggregate metrics remained unchanged. I preserved the top-five rankings and retrieved text excerpts in that CSV so the comparison is auditable.

### 5.3 Conversational-memory comparison

| Chunking        | Reranking   | Memory   |   P@5 |   R@5 |   MRR@5 |
|:----------------|:------------|:---------|------:|------:|--------:|
| Fixed-width     | No          | No       |   0.8 | 0.182 |     1   |
| Fixed-width     | Yes         | No       |   1   | 0.227 |     1   |
| Fixed-width     | No          | Yes      |   1   | 0.227 |     1   |
| Fixed-width     | Yes         | Yes      |   1   | 0.227 |     1   |
| Paragraph-aware | No          | No       |   0.6 | 0.15  |     1   |
| Paragraph-aware | Yes         | No       |   0.6 | 0.15  |     0.5 |
| Paragraph-aware | No          | Yes      |   1   | 0.25  |     1   |
| Paragraph-aware | Yes         | Yes      |   1   | 0.25  |     1   |

For the follow-up question **without reranking**, I observed a Precision@5 increase from **0.80 to 1.00** for fixed-width chunks and from **0.60 to 1.00** for paragraph-aware chunks when I included the previous question. Recall@5 rose from **0.1818 to 0.2273** (fixed-width) and from **0.1500 to 0.2500** (paragraph-aware). MRR@5 was already 1.00 in both vector-only conditions, so it did not improve there.

In the paragraph-aware **reranked** condition, memory increased MRR@5 from **0.50 to 1.00** and Precision@5 from **0.60 to 1.00**. With fixed-width reranking, Precision@5 and MRR@5 were already 1.00 even without memory. I therefore found evidence of a benefit from adding context to the ambiguous follow-up, but it was not uniform across all metrics and settings.

## 6. My error analysis

The recorded error list contains results that **failed the automatic keyword-based relevance rule**. I do not treat all of them as genuinely poor semantic retrievals:

1. In the paragraph-aware, reranked, no-memory follow-up, the top-ranked passage `paragraph-d002-c0024` said that sudden current changes were associated with bifurcations. The proxy marked it **nonrelevant**, even though it appears directly useful for answering the follow-up. This is a **possible false negative in the relevance rule**, and it explains why the reported MRR@5 may understate semantic quality for that condition.
2. The fixed-width, no-memory follow-up retrieved `fixed-d002-c0010` at rank 5. Its excerpt discusses sweeping a parameter to generate a bifurcation diagram but does not explicitly establish how this explains current reversal. I consider it **partial context rather than a clearly complete answer**; a relevance rule based only on article identity would over-credit it.
3. The paragraph-aware, reranked, no-memory follow-up returned `paragraph-d036-c0003` at rank 4. That passage discusses period doubling and bifurcations, but the excerpt does not establish a specific connection to deterministic-ratchet current reversal. This is a more convincing **topic-drift example**.

These observations show why I should not interpret every proxy-negative result as a retrieval error or every proxy-positive result as sufficient to answer the question. A stronger evaluation would have me manually label the pooled candidates for *usefulness to the exact question* and recompute the metrics with those judgments.

## 7. My conclusion

I found that the two chunking methods produced very similar proxy-based retrieval quality for my two standalone scientific questions. Cross-encoder reranking visibly changed ranking order but did not improve their Precision@5, Recall@5, or MRR@5; it also increased query latency in this run. Adding the preceding question improved several follow-up measures, especially with paragraph-aware chunking, suggesting that a small conversational-memory mechanism can help disambiguate references such as “that phenomenon.” My conclusions are limited by the small query set, the source-paper-and-keyword proxy labels, and the fact that I evaluated retrieval rather than generated answers.

## 8. My evidence files

I retained the measured per-condition results in `METRICS.md` and `outputs/metrics_results.csv`; retrieved passages in `outputs/retrieval_examples.csv`; rule-based labels in `outputs/relevance_judgments.csv`; illustrative mismatches in `outputs/retrieval_errors.csv`; execution details in `RUN_LOG.txt` and `outputs/run_config.json`; and comparison plots in `figures/`. The **executed Colab notebook must also be saved with outputs** before I complete my Git submission.
