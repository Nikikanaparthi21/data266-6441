# Homework 5 Metrics

Student: Nikhil Kanaparthi  
SID4: 6441  
SEED: 6441  
Base model: `google/flan-t5-small`  
Dataset: `neil-code/dialogsum-test`

## Model comparison

| model     |   rank |   lora_alpha |   lora_dropout |   total_parameters |   trainable_parameters |   trainable_percent | final_training_loss   | validation_loss   |   rouge1 |   rouge2 |   rougeL |
|:----------|-------:|-------------:|---------------:|-------------------:|-----------------------:|--------------------:|:----------------------|:------------------|---------:|---------:|---------:|
| Baseline  |      0 |            0 |           0    |           76961152 |                      0 |            0        | N/A                   | N/A               | 0.155991 | 0.029894 | 0.13669  |
| LoRA r=4  |      4 |           32 |           0.05 |           77133184 |                 172032 |            0.223032 | 1.880470              | 1.391726          | 0.312105 | 0.093923 | 0.255038 |
| LoRA r=16 |     16 |           32 |           0.05 |           77649280 |                 688128 |            0.8862   | 1.882864              | 1.392088          | 0.28844  | 0.064112 | 0.234647 |

## Required interpretation

After fine-tuning, the best LoRA configuration was r=4, with ROUGE-L=0.2550 versus the baseline's ROUGE-L=0.1367 on the same 50 held-out dialogues.
The r=4 and r=16 adapters achieved ROUGE-L values of 0.2550 and 0.2346; the higher rank used 688,128 trainable parameters compared with 172,032.
The displayed examples show that fine-tuning changes the output from general instruction-model responses toward concise dialogue summaries; the metric difference indicates whether the extra capacity at rank 16 produced a meaningful quality gain in this run.

## Experimental controls

- The rank-4 and rank-16 experiments used the same 800 training examples.
- Both experiments used the same 100 validation examples.
- The baseline, rank-4 model, and rank-16 model were evaluated on the same 50 held-out dialogues.
- LoRA alpha: 32.
- LoRA dropout: 0.05.
- LoRA target modules: ['q', 'v'].
- Training epochs: 2.
- Learning rate: 0.0002.
- Random seed: 6441.
- ROUGE values are average F1 scores over the held-out evaluation subset.
