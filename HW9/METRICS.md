# Homework 9 Metrics

Student: Nikhil Kanaparthi  
SID4: 6441  
Seed: 6441

## Required configuration

| Item | Value |
|---|---:|
| Dataset | FashionMNIST |
| Pretrained VAE | `stabilityai/sd-vae-ft-mse` |
| Image / latent size | `128x128` / `4x16x16` |
| Latent scaling factor | 0.18215 |
| Diffusion timesteps | 1000 |
| Linear beta range | [0.0001, 0.02] |
| U-Net base channels | 64 |
| Channel multipliers | (1, 2, 4) |
| Epochs | 50 |
| Learning rate | 2e-05 |
| Label drop probability | 0.1 |
| Guidance scale | 3.0 |
| Conditional samples | 64 |

## Results

| Metric | Value |
|---|---:|
| VAE reconstruction MSE | 0.00060739 |
| Final training noise MSE | 0.10047932 |
| Final validation noise MSE | 0.10219185 |
| Best validation noise MSE | 0.09943402 |
| Best validation epoch | 48 |
| Mean observed label-drop fraction | 0.0998 |
| Trainable U-Net parameters | 11,717,636 |
| Saved U-Net size | 22.37 MiB |
| Latent caching time | 463.72 s |
| Sampling time | 35.48 s |
