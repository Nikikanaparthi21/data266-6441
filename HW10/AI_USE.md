# AI-Use Appendix — DATA 266 Homework 10

## 1. Which parts did I use an assistant for, and which did I do myself?

I used ChatGPT to help me interpret the HW10 instructions and the HW1 standing requirements, adapt the course RAG demo/template into an end-to-end notebook, structure the retrieval evaluation, and draft and review the Markdown reports. The assistant also helped with notebook-generation code, syntax checks, and preparing the files for Git. I supplied the assignment materials and followed the notebook setup in Colab, including entering my SID4 (`6441`). My uploaded run log records a successful experiment with the required 100-document dataset and 16 measured retrieval conditions; I retained the raw metrics and retrieval examples as evidence. The assistant reviewed the exported files and helped me describe the results in first person. **I am responsible for understanding the code, checking the generated conclusions, and submitting the executed notebook.**

## 2. One specific thing the assistant produced incorrectly

An initial assistant-generated notebook included a malformed Python string because the notebook generator inserted a real line break inside a quoted string. The actual syntax-check error during preparation was:

```text
SyntaxError: unterminated string literal (detected at line 20)
```

For example, a line intended to print `"\nSAMPLE QUERY:"` was serialized incorrectly. This was a notebook-source escaping error rather than an observed retrieval-model failure.

## 3. How was the problem detected?

A static Python syntax check of the generated notebook code cells reported the error before the complete experiment was run. The notebook would not execute with the malformed cell, so no model output from that version would have been valid. I used the corrected notebook rather than relying on the broken version.

## 4. What changed, and what did I verify?

The assistant corrected the notebook generation so the newline remained an escaped character inside the Python string. The corrected source passed the Python syntax checks. The later exported `RUN_LOG.txt` shows **`RUN SUCCESS`** and records dataset loading, the two chunking strategies, retrieval examples, and all 16 measured conditions. I can also cross-check the reported summary values against `outputs/metrics_results.csv` and review `outputs/retrieval_errors.csv`. The observed metrics have a known limitation: a passage explaining the connection between current changes and bifurcations can be marked irrelevant by the keyword proxy. I therefore describe these values as reproducible proxy-based scores, not independent human judgments.

During package installation, Colab also printed dependency-compatibility warnings. These warnings did not prevent the later recorded successful experiment. I have kept this distinction clear rather than describing a warning as a failed model run.
