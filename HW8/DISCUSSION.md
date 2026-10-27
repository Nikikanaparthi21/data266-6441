### Discussion of DDPM versus DDIM

All three rows above were produced by the same trained noise-prediction network and the same initial Gaussian noise. The only change was the reverse sampler.

- **DDPM (100 steps)** performed every adjacent reverse transition and injected posterior noise at intermediate steps. It took **0.530 seconds** for 64 images and serves as the full-step reference.
- **DDIM (50 steps)** used half as many model evaluations and took **0.235 seconds**, a measured **2.25x speedup** over DDPM in this run. With $\eta=0$, its trajectory was deterministic for the fixed starting noise.
- **DDIM (20 steps)** used only one fifth as many evaluations and took **0.095 seconds**, a measured **5.55x speedup**. The aggressive timestep skipping provides the fastest result, but it gives the model fewer opportunities to refine digit boundaries and remove residual artifacts.

The image grids should therefore be read as a speed-quality trade-off. DDPM uses the most gradual stochastic refinement. DDIM-50 usually preserves much of the visible structure while reducing runtime. DDIM-20 is fastest, but its samples can be less stable or less detailed because each update spans a larger interval. The exact visual ranking depends on this small model and training run, so the displayed samples are the primary evidence; the diversity and total-variation columns are supporting diagnostics rather than definitive perceptual-quality scores.
