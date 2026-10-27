# Homework 8 Metrics

Student: Nikhil Kanaparthi  
SID4: 6441  
Dataset: MNIST  
Hardware: Tesla T4

## Training

- Epochs completed: 50
- Final noise-prediction MSE: 0.059010
- Training time: 1022.161 seconds
- CNN convolutional/transposed-convolutional layers: 9
- Model parameters: 574,049

## Sampling comparison

| sampler   |   steps |   seconds |   speedup_vs_ddpm |   mean_pixel_std |   mean_total_variation |
|:----------|--------:|----------:|------------------:|-----------------:|-----------------------:|
| DDPM      |     100 |  0.529534 |           1       |         0.278105 |               0.238553 |
| DDIM      |      50 |  0.234963 |           2.25369 |         0.298336 |               0.327661 |
| DDIM      |      20 |  0.095414 |           5.54983 |         0.293066 |               0.310425 |
