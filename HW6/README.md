# DATA 266 Homework 6 - STL-10 Representation Learning

Student: Nikhil Kanaparthi  
SID4: 6441

## Overview

This submission compares three ResNet-18 representations trained from scratch on STL-10:

1. End-to-end supervised learning with 500 balanced labeled images.
2. Rotation self-supervised learning on all 100,000 unlabeled images plus a frozen linear probe.
3. SimCLR-style contrastive learning on 20,000 unlabeled images plus a frozen linear probe.

## Main files

- `HW6_STL10_SSL_Nikhil_Kanaparthi_6441.ipynb`: executed notebook; add after downloading it from Colab.
- `METRICS.md`: accuracy and nearest-neighbor summary.
- `ANALYSIS.md`: required comparison and interpretation.
- `AI_USE.md`: AI-use disclosure.
- `RUN_LOG.txt`: timestamped execution record.
- `metrics.csv`: model-level results.
- `training_history.csv`: epoch-level histories.
- `nearest_neighbors.csv`: top-5 cosine retrieval records.
- `figures/`: training plots, augmentations, and nearest-neighbor visualizations.
- `models/`: compact half-precision archival state dictionaries for the three final models.
- `run_config.json` and `environment.json`: reproducibility metadata.

## Important controls

- All encoders use `torchvision.models.resnet18(weights=None)`.
- The same seeded, balanced 500-image subset is used for all classifier training.
- Rotation SSL uses all 100,000 unlabeled STL-10 images.
- SimCLR uses 20,000 unlabeled images, two views, cosine similarity, and temperature 0.2.
- Rotation and SimCLR encoders remain frozen during linear evaluation.
- The same query images are used for all nearest-neighbor comparisons.

## Final measured result

The best test method in this run was **Rotation SSL + linear probe** with **46.90%** accuracy.
