# Homework 7 Metrics

Student: Nikhil Kanaparthi  
SID4: 6441  
Dataset: FashionMNIST  
Seed: 6441  

## Test-set comparison

| model   |   parameters |   latent_dim |   epochs |   test_mse_per_pixel |   test_mae_per_pixel |   test_bce_per_pixel |   test_psnr_db | test_kl_per_image   |
|:--------|-------------:|-------------:|---------:|---------------------:|---------------------:|---------------------:|---------------:|:--------------------|
| FC-AE   |       439728 |           32 |       15 |             0.017556 |             0.071829 |             0.296087 |         17.556 | N/A                 |
| VAE     |       480848 |           32 |       15 |             0.020528 |             0.07981  |             0.30467  |         16.877 | 11.484169           |

## Interpretation

- The FC-AE produced the lower test MSE in this run. FC-AE MSE was 0.017556, while VAE MSE was 0.020528; the difference relative to the lower value was 16.92%.
- FC-AE achieved 17.56 dB PSNR and the VAE achieved 16.88 dB. These common metrics compare reconstruction quality on the same test images.
- The FC-AE maps each input to one deterministic latent code and is optimized only for reconstruction. This usually allows sharper reconstruction but does not force unused regions of latent space to decode meaningfully.
- The VAE regularizes each posterior toward a standard-normal prior. The KL term makes its latent space smoother and supports random generation and interpolation, but that constraint can blur details and increase reconstruction error.
- The reconstruction grid should be used to judge retained garment shape and fine details, while the random-sample grid and interpolation demonstrate the VAE's generative behavior.

## Experimental controls

- Both models were trained on the same 54,000 training examples.
- Both used the same 6,000 validation and 10,000 test examples.
- Both used latent dimension 32, batch size 512, and seed 6441.
- Final evaluation used deterministic reconstructions on the identical test set.
- VAE generation sampled latent vectors from the standard-normal prior.
