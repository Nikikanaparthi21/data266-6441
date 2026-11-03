# METRICS.md - HW4.5 Summary

I used one Google Colab GPU: **Tesla T4**.  
GPU UUID: **GPU-ef1369de-78dd-c684-4e6a-c14668cb81c9**.  
Dataset: **IMDB Dataset.csv**, rows **441-5440 inclusive**, 5000 rows.  
Seed: **6441**.  
Part C: **Part C skipped (optional) - I used one permitted Colab GPU.**

## Baseline

| Measurement | My result |
|---|---:|
| Baseline batch size | 16 |
| Peak memory (GB) | 2.8164 |
| Throughput (samples/s) | 37.1682 |
| Wall-clock time (s) | 188.3331 |
| Test accuracy | 0.8600 |

## Table HW4.5.1

| label                           | status   |   batch_size |   physical_batch_size |   effective_batch_size |   gradient_accumulation | use_amp   | checkpointing   | use_8bit   | optimizer             |   epochs |   seconds |   seconds_per_epoch |   samples_per_second |   peak_memory_gb |   validation_accuracy |   test_accuracy |   best_epoch | technique                 |
|:--------------------------------|:---------|-------------:|----------------------:|-----------------------:|------------------------:|:----------|:----------------|:-----------|:----------------------|---------:|----------:|--------------------:|---------------------:|-----------------:|----------------------:|----------------:|-------------:|:--------------------------|
| mixed_precision_batch_128       | success  |          128 |                   128 |                    128 |                       1 | True      | False           | False      | AdamW                 |        2 |   55.5621 |             27.781  |             125.985  |          9.55078 |              0.850667 |        0.817333 |            2 | Automatic mixed precision |
| checkpointing_batch_128         | success  |          128 |                   128 |                    128 |                       1 | False     | True            | False      | AdamW                 |        2 |  239.606  |            119.803  |              29.2146 |          4.49023 |              0.822667 |        0.806667 |            2 | Gradient checkpointing    |
| gradient_accumulation_batch_128 | success  |          128 |                   128 |                    512 |                       4 | False     | False           | False      | AdamW                 |        2 |  178.624  |             89.3122 |              39.1884 |         12.8379  |              0.733333 |        0.726667 |            2 | Gradient accumulation     |
| eight_bit_optimizer_batch_128   | success  |          128 |                   128 |                    128 |                       1 | False     | False           | True       | bitsandbytes Adam8bit |        2 |  179.291  |             89.6453 |              39.0428 |         11.7754  |              0.838667 |        0.806667 |            2 | 8-bit optimizer           |

## Part A

| label             | status   |   batch_size |   physical_batch_size |   effective_batch_size |   gradient_accumulation | use_amp   | checkpointing   | use_8bit   | optimizer   |   epochs |   seconds |   seconds_per_epoch |   samples_per_second |   peak_memory_gb |   validation_accuracy |   test_accuracy |   best_epoch |
|:------------------|:---------|-------------:|----------------------:|-----------------------:|------------------------:|:----------|:----------------|:-----------|:------------|---------:|----------:|--------------------:|---------------------:|-----------------:|----------------------:|----------------:|-------------:|
| scaling_batch_4   | success  |            4 |                     4 |                      4 |                       1 | False     | False           | False      | AdamW       |        1 |  123.765  |            123.765  |              28.2794 |          2.25195 |              0.854667 |        0.854667 |            1 |
| scaling_batch_8   | success  |            8 |                     8 |                      8 |                       1 | False     | False           | False      | AdamW       |        1 |  108.036  |            108.036  |              32.3966 |          2.27539 |              0.865333 |        0.86     |            1 |
| scaling_batch_16  | success  |           16 |                    16 |                     16 |                       1 | False     | False           | False      | AdamW       |        1 |   98.7723 |             98.7723 |              35.435  |          2.81641 |              0.858667 |        0.842667 |            1 |
| scaling_batch_32  | success  |           32 |                    32 |                     32 |                       1 | False     | False           | False      | AdamW       |        1 |   92.411  |             92.411  |              37.8743 |          3.95703 |              0.873333 |        0.834667 |            1 |
| scaling_batch_64  | success  |           64 |                    64 |                     64 |                       1 | False     | False           | False      | AdamW       |        1 |   91.0356 |             91.0356 |              38.4465 |          6.26367 |              0.796    |        0.757333 |            1 |
| scaling_batch_128 | success  |          128 |                   128 |                    128 |                       1 | False     | False           | False      | AdamW       |        1 |   89.5397 |             89.5397 |              39.0888 |         11.082   |              0.748    |        0.722667 |            1 |
| scaling_batch_256 | OOM      |          256 |                   256 |                    256 |                       1 | False     | False           | False      | nan         |      nan |  nan      |            nan      |             nan      |        nan       |            nan        |      nan        |          nan |

## Part D

| configuration       |   batch_size |   tokens_per_second |   p50_latency_ms |   p95_latency_ms | status   |
|:--------------------|-------------:|--------------------:|-----------------:|-----------------:|:---------|
| HF pipeline batch 1 |            1 |             62.2073 |          295.877 |          587.771 | success  |

## Provenance

I saved nvidia-smi-q.txt, nvidia-smi-L.txt, gpu_provenance.json, and all CSV/PNG files in this output folder. I did not invent unavailable second-GPU or reservation values.
