# DATA 266 Homework 5 — DialogSum LoRA Fine-Tuning

Student: Nikhil Kanaparthi  
SID4: 6441

## Project overview

This submission fine-tunes `google/flan-t5-small` on `neil-code/dialogsum-test` using parameter-efficient LoRA training. It compares the original pretrained baseline with LoRA ranks 4 and 16.

## Main files

- `HW5_DialogSum_LoRA_Nikhil_Kanaparthi_6441.ipynb`: executed notebook containing code and outputs
- `METRICS.md`: measurements, rank comparison, and interpretation
- `RUN_LOG.txt`: timestamped execution and training record
- `AI_USE.md`: description of AI assistance and the debugging process
- `metrics.csv`: model-level training and ROUGE results
- `sample_comparisons.csv`: baseline, rank-4, and rank-16 outputs for the same two dialogues
- `quality_evaluation_predictions.csv`: predictions for the held-out evaluation subset
- `training_history.csv`: Hugging Face Trainer logs
- `adapters/`: saved rank-4 and rank-16 LoRA adapters
- `figures/`: training-loss and ROUGE comparison plots
- `run_config.json`: experiment configuration
- `environment.json`: software and hardware environment

## Experiment

The notebook performs the following steps:

1. Loads the DialogSum dataset.
2. Preprocesses the `dialogue` input and `summary` target fields.
3. Runs baseline inference on two selected dialogues.
4. Applies LoRA to the FLAN-T5 `q` and `v` attention modules.
5. Fine-tunes and evaluates LoRA rank 4.
6. Fine-tunes and evaluates LoRA rank 16.
7. Compares baseline, rank-4, and rank-16 quality using ROUGE.
8. Saves both trained LoRA adapters and the supporting artifacts.

## Training command

Training is performed by the following call inside the notebook:

```python
trainer.train()
```

The `train_lora_experiment(rank)` function is run once with `rank=4` and once with `rank=16`.

## Repository submission

This folder should be committed to the private repository `data266-6441`. After all files have been uploaded and verified, the final commit should be tagged `hw5`, and the tagged repository URL should be submitted through Canvas.
