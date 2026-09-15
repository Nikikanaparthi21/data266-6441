# DATA 266 Homework 3 Metrics

SID4: 6441; SEED: 6441; prompt model: gemini-3.6-flash

## Prompt engineering summary

| technique        |   examples |   mean_latency_seconds |   mean_response_characters |   term_check_rate |
|:-----------------|-----------:|-----------------------:|---------------------------:|------------------:|
| Zero-Shot        |          2 |                 3.0685 |                   605.5000 |            1.0000 |
| Few-Shot         |          2 |                 3.5608 |                    50.0000 |            1.0000 |
| Chain-of-Thought |          2 |                 4.0914 |                   610.0000 |            1.0000 |
| Zero-Shot CoT    |          2 |                14.4461 |                   943.5000 |            0.5000 |
| Meta-Prompting   |          2 |                 4.8360 |                   595.5000 |            0.5000 |
| Tree of Thoughts |          2 |                 4.8896 |                   892.5000 |            0.5000 |

## Attention model metrics

| model    | causal_mask   |   final_loss |   final_next_token_accuracy |   training_seconds | checkpoint                                       |   future_attention_mass |   maximum_future_attention_weight |
|:---------|:--------------|-------------:|----------------------------:|-------------------:|:-------------------------------------------------|------------------------:|----------------------------------:|
| unmasked | False         |     0.000094 |                    1.000000 |           4.480171 | hw3_outputs/models/unmasked_attention_sid6441.pt |               17.971975 |                          0.999993 |
| causal   | True          |     0.000101 |                    1.000000 |           3.048499 | hw3_outputs/models/causal_attention_sid6441.pt   |                0.000000 |                          0.000000 |

Causal masking check: maximum weight above diagonal = 0.0000000000
