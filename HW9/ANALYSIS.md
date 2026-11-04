# Homework 9 Analysis

## VAE compression

The pretrained VAE compressed each 128x128, three-channel Fashion-MNIST image to a
4x16x16 latent tensor. The scaling factor was 0.18215. On the held-out
reconstruction batch, the normalized-pixel MSE was **0.00060739**.
The side-by-side reconstruction figure shows the information retained by the frozen
VAE before diffusion training.

## Forward diffusion

The decoded latent sequence at t = 0, 200, 500, 800, and 1000 demonstrates the
progressive loss of recognizable clothing structure under the linear beta schedule.
At late timesteps, the decoded representation is dominated by Gaussian noise, as
expected from the decreasing cumulative alpha product.

## Denoising training

The conditional latent U-Net completed **50 epochs** at learning rate
**2e-05**. Training noise MSE ended at **0.10047932** and
held-out noise MSE ended at **0.10219185**. The best held-out MSE
was **0.09943402** at epoch **48**. The mean
observed null-label fraction was **0.0998**, close to the
required 0.10 probability.

## Classifier-free guidance

At every reverse step, conditional and null-label predictions were evaluated and
combined as `(1 + w) * epsilon_cond - w * epsilon_uncond` with `w = 3`. The final
8x8 figure contains 64 generated samples with Fashion-MNIST labels 0-9 repeated.
The sampling-progress figure shows how class-conditioned structure emerges from
noise. Differences between individual samples reflect the random initial latent and
the stochastic DDPM reverse process.

## Limitations

Fashion-MNIST was converted from grayscale to three channels solely for compatibility
with the pretrained RGB VAE. The VAE was trained on natural images rather than
Fashion-MNIST, so its reconstruction error places an upper bound on downstream image
fidelity. A longer or larger denoiser could improve samples but would change the
required architecture or training budget.
