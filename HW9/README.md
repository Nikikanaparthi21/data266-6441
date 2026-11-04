# DATA 266 Homework 9 - Conditional Latent Diffusion

Student: Nikhil Kanaparthi  
SID4: 6441

This submission implements a conditional latent diffusion model on Fashion-MNIST
using the frozen `stabilityai/sd-vae-ft-mse` VAE and a custom latent U-Net trained for 50 epochs.

## Main files

- `HW9_Latent_Diffusion_Nikhil_Kanaparthi_6441.ipynb`: executed Colab notebook
- `METRICS.md`: required configuration and numerical results
- `ANALYSIS.md`: interpretation and limitations
- `RUN_LOG.txt`: timestamped execution record
- `AI_USE.md`: AI-use disclosure and corrected first-draft issue
- `training_history.csv`: epoch-level training and validation loss
- `metrics.json`, `run_config.json`, `environment.json`: machine-readable evidence
- `figures/`: reconstruction, forward diffusion, loss, and sampling figures
- `models/conditional_latent_unet_fp16.safetensors`: trained denoiser weights
- `models/vae_reference.json`: exact pretrained VAE reference

## Reproduction

Open the notebook in Colab, choose a GPU runtime, keep `FAST_DEBUG = False`, and run
all cells in order. The final cell creates `HW9_outputs.zip`.

## Repository submission

Place the executed notebook and extracted output files in the `HW9/` folder of the
course repository. Commit progressively, push `main`, create annotated tag `hw9`,
create the GitHub release, and submit the release URL in Canvas.
