# DATA 266 Homework 11 — CLIP on CIFAR-10

Student: Nikhil Kanaparthi  
SID4: 6441

This submission uses CLIP to compare one caption with 1,000 balanced CIFAR-10 images and to perform zero-shot classification on the same set.

## Main files

- `HW11_CLIP_CIFAR10_Nikhil_Kanaparthi_6441.ipynb`: executed notebook; download it separately from Colab and place it in the `HW11/` folder.
- `METRICS.md`: similarity statistics and per-class classification accuracy.
- `FINDINGS.md`: measured findings and limitations.
- `AI_USE.md`: AI-use disclosure.
- `caption_image_similarity_scores.csv`: all 1,000 caption–image cosine similarities.
- `caption_similarity_by_class.csv`: similarity summaries for all 10 classes.
- `zero_shot_predictions.csv`: image-level predictions and confidence values.
- `per_class_accuracy.csv`: required per-class accuracy.
- `confusion_matrix_counts.csv` and `confusion_matrix_normalized.csv`: required confusion matrix data.
- `figures/`: scored image grids, similarity plot, per-class accuracy, confusion matrix, and mistakes.
- `run_config.json`, `environment.json`, `metrics_summary.json`, `RUN_LOG.txt`: reproducibility evidence.

## Reproduce

Open the notebook in Google Colab, select a GPU runtime if available, and use **Runtime → Run all**. No API key is needed. The last cell creates `HW11_outputs.zip`.

## Repository submission

Extract the ZIP into `data266-6441/HW11/`, add the executed notebook, make progressive commits, push `main`, create the annotated tag `hw11`, and submit the GitHub release or tag URL requested by Canvas.
