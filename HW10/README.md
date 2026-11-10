# DATA 266 Homework 10 - Improving RAG

Student: Nikhil Kanaparthi  
SID4: 6441

I compared fixed-width and paragraph-aware chunking, vector-only and cross-encoder-reranked retrieval, and conversational memory using the first 100 training articles of `ccdv/arxiv-summarization` (`document` configuration). I evaluated each approach with Precision@5, Recall@5, and MRR@5.

## Required evidence

- Main notebook: `HW10_RAG_Reranking_Chunking_Memory_Nikhil_Kanaparthi_6441.ipynb`
- Discussion: `DISCUSSION.md` (short comparison) and `REPORT.md` (full report)
- Metrics: `METRICS.md` and `outputs/metrics_results.csv`
- Retrieval and labeling evidence: `outputs/retrieval_examples.csv`, `outputs/relevance_judgments.csv`, `outputs/retrieval_errors.csv`
- Figures: `figures/`
- Run details: `RUN_LOG.txt`, `run_config.json`
- AI-use appendix: `AI_USE.md`
- Reproducibility: `requirements.txt`, `src/`, and `tests/`

**Before submission:** My copied notebook does not yet have saved Colab outputs. I must download the executed notebook from Colab and replace `HW10_RAG_Reranking_Chunking_Memory_Nikhil_Kanaparthi_6441.ipynb` with that downloaded version. I will then run `python tests/validate_notebook.py` and `python tests/check_submission.py` and copy this whole `HW10/` folder beside `HW8/` in my existing private GitHub repository. The course tag is `hw10`.
