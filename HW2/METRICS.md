# DATA 266 Homework 2 Metrics

SID4: 6441; SEED: 6441

## Embedding vector shifts

| word   |   original_vs_finetuned_cosine |   shift_distance |
|:-------|-------------------------------:|-----------------:|
| review |                         0.6186 |           0.3814 |
| screen |                         0.6756 |           0.3244 |
| score  |                         0.6844 |           0.3156 |
| cast   |                         0.6855 |           0.3145 |
| plot   |                         0.6932 |           0.3068 |

## RAG retrieval evaluation

| question                                                                | correct_source   | retrieved_in_top_3   |   first_relevant_rank |
|:------------------------------------------------------------------------|:-----------------|:---------------------|----------------------:|
| Who directed Inception?                                                 | Inception        | Yes                  |                     1 |
| Which novel was The Godfather adapted from, and who wrote that novel?   | The Godfather    | Yes                  |                     1 |
| Who directed the 1997 film Titanic?                                     | Titanic          | Yes                  |                     1 |
| Which actor portrayed the Joker in The Dark Knight?                     | The Dark Knight  | No                   |                   nan |
| What Best Picture milestone did Parasite achieve at the Academy Awards? | Parasite         | Yes                  |                     1 |

Retrieval Success Rate: 80.0%

## RAG failures

| question                                            | failure_type                                   |   rank | retrieved_title   | diagnosis                                                                                                                                |
|:----------------------------------------------------|:-----------------------------------------------|-------:|:------------------|:-----------------------------------------------------------------------------------------------------------------------------------------|
| Which actor portrayed the Joker in The Dark Knight? | Irrelevant or incomplete chunk ranked in top 3 |      1 | The Dark Knight   | This chunk does not contain the manually identified answer passage, so it consumes limited context space and may distract the generator. |
| Which actor portrayed the Joker in The Dark Knight? | Irrelevant or incomplete chunk ranked in top 3 |      2 | The Dark Knight   | This chunk does not contain the manually identified answer passage, so it consumes limited context space and may distract the generator. |

## Optimization measurements

| technique                | configuration     |   time_sec |   peak_gpu_memory_mb |   final_5_step_mean_loss |
|:-------------------------|:------------------|-----------:|---------------------:|-------------------------:|
| Tensor placement         | cpu_then_transfer |     0.3060 |            1181.0156 |                   0.5346 |
| Tensor placement         | device_resident   |     0.1822 |            1185.9097 |                   0.5346 |
| Weight initialization    | default           |     0.1967 |            1181.0156 |                   0.5346 |
| Weight initialization    | xavier            |     0.2028 |            1181.0156 |                   0.6879 |
| Activation checkpointing | disabled          |     0.1918 |            1181.0156 |                   0.5346 |
| Activation checkpointing | enabled           |     0.3047 |            1182.0156 |                   0.5346 |
| Gradient accumulation    | 1 micro-batch(es) |     0.2094 |            1182.0156 |                   0.5346 |
| Gradient accumulation    | 4 micro-batch(es) |     0.5535 |            1181.9219 |                   0.5361 |
| Mixed precision          | FP32              |     0.1993 |            1182.0156 |                   0.5346 |
| Mixed precision          | AMP FP16          |     0.4137 |            1182.0171 |                   0.6029 |
