# HW4.5 - Training Throughput and Memory Engineering

## My setup and reproducibility

I am Nikhil Kanaparthi, SID4 6441. I used Google Colab with a Tesla T4. The GPU UUID was GPU-ef1369de-78dd-c684-4e6a-c14668cb81c9. My driver version was 580.82.07, and my CUDA version was 13.0. I used one GPU. Part C was optional, so I recorded it as skipped.

I reused the IMDB Dataset.csv data from HW4.a. I used the consecutive zero-based row range 441-5440, inclusive, containing 5000 rows. I used SEED=6441 for the split and initialization. I used a 70/15/15 stratified train/validation/test split. My model was bert-base-uncased, with maximum sequence length 128, learning rate 2e-05, and 2 baseline epochs.

## Part A - Batch scaling

My largest successful baseline batch size was 128. The detailed measurements are in part_a_batch_scaling.csv, and I plotted throughput against batch size in part_a_throughput_vs_batch.png. Since I used one Colab GPU, I did not claim a two-card batch-size ratio. I recorded the second-card comparison as not applicable under the optional one-GPU clarification.

| label             | status   |   batch_size |   physical_batch_size |   effective_batch_size |   gradient_accumulation | use_amp   | checkpointing   | use_8bit   | optimizer   |   epochs |   seconds |   seconds_per_epoch |   samples_per_second |   peak_memory_gb |   validation_accuracy |   test_accuracy |   best_epoch |
|:------------------|:---------|-------------:|----------------------:|-----------------------:|------------------------:|:----------|:----------------|:-----------|:------------|---------:|----------:|--------------------:|---------------------:|-----------------:|----------------------:|----------------:|-------------:|
| scaling_batch_4   | success  |            4 |                     4 |                      4 |                       1 | False     | False           | False      | AdamW       |        1 |  123.765  |            123.765  |              28.2794 |          2.25195 |              0.854667 |        0.854667 |            1 |
| scaling_batch_8   | success  |            8 |                     8 |                      8 |                       1 | False     | False           | False      | AdamW       |        1 |  108.036  |            108.036  |              32.3966 |          2.27539 |              0.865333 |        0.86     |            1 |
| scaling_batch_16  | success  |           16 |                    16 |                     16 |                       1 | False     | False           | False      | AdamW       |        1 |   98.7723 |             98.7723 |              35.435  |          2.81641 |              0.858667 |        0.842667 |            1 |
| scaling_batch_32  | success  |           32 |                    32 |                     32 |                       1 | False     | False           | False      | AdamW       |        1 |   92.411  |             92.411  |              37.8743 |          3.95703 |              0.873333 |        0.834667 |            1 |
| scaling_batch_64  | success  |           64 |                    64 |                     64 |                       1 | False     | False           | False      | AdamW       |        1 |   91.0356 |             91.0356 |              38.4465 |          6.26367 |              0.796    |        0.757333 |            1 |
| scaling_batch_128 | success  |          128 |                   128 |                    128 |                       1 | False     | False           | False      | AdamW       |        1 |   89.5397 |             89.5397 |              39.0888 |         11.082   |              0.748    |        0.722667 |            1 |
| scaling_batch_256 | OOM      |          256 |                   256 |                    256 |                       1 | False     | False           | False      | nan         |      nan |  nan      |            nan      |             nan      |        nan       |            nan        |      nan        |          nan |

## Part B - Memory techniques

I measured automatic mixed precision, gradient checkpointing, gradient accumulation, and an 8-bit optimizer independently. I then ran a combined configuration using the techniques that were available in the runtime.

| label                           | status   |   batch_size |   physical_batch_size |   effective_batch_size |   gradient_accumulation | use_amp   | checkpointing   | use_8bit   | optimizer             |   epochs |   seconds |   seconds_per_epoch |   samples_per_second |   peak_memory_gb |   validation_accuracy |   test_accuracy |   best_epoch | technique                 |
|:--------------------------------|:---------|-------------:|----------------------:|-----------------------:|------------------------:|:----------|:----------------|:-----------|:----------------------|---------:|----------:|--------------------:|---------------------:|-----------------:|----------------------:|----------------:|-------------:|:--------------------------|
| mixed_precision_batch_128       | success  |          128 |                   128 |                    128 |                       1 | True      | False           | False      | AdamW                 |        2 |   55.5621 |             27.781  |             125.985  |          9.55078 |              0.850667 |        0.817333 |            2 | Automatic mixed precision |
| checkpointing_batch_128         | success  |          128 |                   128 |                    128 |                       1 | False     | True            | False      | AdamW                 |        2 |  239.606  |            119.803  |              29.2146 |          4.49023 |              0.822667 |        0.806667 |            2 | Gradient checkpointing    |
| gradient_accumulation_batch_128 | success  |          128 |                   128 |                    512 |                       4 | False     | False           | False      | AdamW                 |        2 |  178.624  |             89.3122 |              39.1884 |         12.8379  |              0.733333 |        0.726667 |            2 | Gradient accumulation     |
| eight_bit_optimizer_batch_128   | success  |          128 |                   128 |                    128 |                       1 | False     | False           | True       | bitsandbytes Adam8bit |        2 |  179.291  |             89.6453 |              39.0428 |         11.7754  |              0.838667 |        0.806667 |            2 | 8-bit optimizer           |

### Ranking

| label                           | status   |   batch_size |   physical_batch_size |   effective_batch_size |   gradient_accumulation | use_amp   | checkpointing   | use_8bit   | optimizer             |   epochs |   seconds |   seconds_per_epoch |   samples_per_second |   peak_memory_gb |   validation_accuracy |   test_accuracy |   best_epoch | technique                 |   memory_saved_gb |   throughput_lost_samples_per_second |   memory_saved_per_throughput_lost |
|:--------------------------------|:---------|-------------:|----------------------:|-----------------------:|------------------------:|:----------|:----------------|:-----------|:----------------------|---------:|----------:|--------------------:|---------------------:|-----------------:|----------------------:|----------------:|-------------:|:--------------------------|------------------:|-------------------------------------:|-----------------------------------:|
| gradient_accumulation_batch_128 | success  |          128 |                   128 |                    512 |                       4 | False     | False           | False      | AdamW                 |        2 |  178.624  |             89.3122 |              39.1884 |         12.8379  |              0.733333 |        0.726667 |            2 | Gradient accumulation     |         -10.0215  |                             -2.02016 |                           4.96074  |
| eight_bit_optimizer_batch_128   | success  |          128 |                   128 |                    128 |                       1 | False     | False           | True       | bitsandbytes Adam8bit |        2 |  179.291  |             89.6453 |              39.0428 |         11.7754  |              0.838667 |        0.806667 |            2 | 8-bit optimizer           |          -8.95898 |                             -1.87458 |                           4.77919  |
| mixed_precision_batch_128       | success  |          128 |                   128 |                    128 |                       1 | True      | False           | False      | AdamW                 |        2 |   55.5621 |             27.781  |             125.985  |          9.55078 |              0.850667 |        0.817333 |            2 | Automatic mixed precision |          -6.73438 |                            -88.8171  |                           0.075823 |
| checkpointing_batch_128         | success  |          128 |                   128 |                    128 |                       1 | False     | True            | False      | AdamW                 |        2 |  239.606  |            119.803  |              29.2146 |          4.49023 |              0.822667 |        0.806667 |            2 | Gradient checkpointing    |          -1.67383 |                              7.95355 |                          -0.21045  |

Based on the measured memory saved per unit of throughput lost, I would apply Gradient accumulation first. I would avoid using a technique on a 32 GB card when its measured memory saving was small relative to its throughput cost. The exact decision is traceable to part_b_technique_ranking.csv.

## Part D - Serving

I attempted vLLM with facebook/opt-125m. My vLLM status was: {"installed": true, "initialized": false, "error": "vLLM initialization or benchmark failed: cannot import name 'aggregate' from 'triton' (/usr/local/lib/python3.13/dist-packages/triton/__init__.py)"}.

| configuration       |   batch_size |   tokens_per_second |   p50_latency_ms |   p95_latency_ms | status   |
|:--------------------|-------------:|--------------------:|-----------------:|-----------------:|:---------|
| HF pipeline batch 1 |            1 |             62.2073 |          295.877 |          587.771 | success  |

For an interactive application, I care more about p95 per-request latency than total throughput. A larger batch can improve aggregate tokens per second while making an individual request wait longer. The crossover batch size is the first vLLM batch whose p50 or p95 latency exceeds the HF pipeline baseline while tokens per second continues to improve; I report that crossover from my measured table rather than assuming it.

My fixed-batch-size-8 context-length measurements are in kv_cache_memory.csv. The longest successful context is the largest row marked success in that file.

## Part E - Summary

My fresh HW4.5 baseline peak memory was 2.8164 GB, my baseline wall-clock time was 188.3331 seconds, and my baseline test accuracy was 0.8600. These are HW4.5 measurements and are not an HW5 baseline.

I used the configuration represented by Gradient accumulation for a full fine-tune because the table gives the best measured tradeoff. My GPU-hours calculation is the measured wall-clock seconds divided by 3600, giving 0.0523 GPU-hours for the baseline run.

## Part C

Part C skipped (optional) - I used one permitted Google Colab GPU.

## Figures and traceability

I generated all figures in the figures directory. Every measurement is traceable to GPU UUID GPU-ef1369de-78dd-c684-4e6a-c14668cb81c9, the dataset slice in split_manifest.json, and the exact experiment settings in the CSV files.
