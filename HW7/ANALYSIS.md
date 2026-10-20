# Homework 7 Analysis

## GAN theory

The complete responses to Questions 1A-1C are included in the executed notebook. They cover the GAN minimax game, mode collapse with three mitigation mechanisms, and DCGAN, Conditional GAN, and CycleGAN.

## Autoencoder comparison

The FC-AE produced the lower test MSE in this run. FC-AE MSE was 0.017556, while VAE MSE was 0.020528; the difference relative to the lower value was 16.92%.
FC-AE achieved 17.56 dB PSNR and the VAE achieved 16.88 dB. These common metrics compare reconstruction quality on the same test images.
The FC-AE maps each input to one deterministic latent code and is optimized only for reconstruction. This usually allows sharper reconstruction but does not force unused regions of latent space to decode meaningfully.
The VAE regularizes each posterior toward a standard-normal prior. The KL term makes its latent space smoother and supports random generation and interpolation, but that constraint can blur details and increase reconstruction error.
The reconstruction grid should be used to judge retained garment shape and fine details, while the random-sample grid and interpolation demonstrate the VAE's generative behavior.

The FC-AE is preferable when the main goal is deterministic compression and accurate reconstruction. The VAE is preferable when a structured, sampleable latent space and controlled interpolation are important. Their objectives differ, so the common test MSE, MAE, BCE, and PSNR values are used for the direct reconstruction comparison.
