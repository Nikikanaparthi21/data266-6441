# AI Use - Homework 9

I used an AI assistant to develop a first-cut notebook structure from the assignment
and the two instructor demos, explain latent diffusion and classifier-free guidance,
and help debug tensor shapes and artifact export. I reviewed the architecture, ran
every cell, checked the displayed outputs, and used the measured results from my own
run in the final analysis.

One important correction was image size. An early draft followed the demo and resized
Fashion-MNIST to 64x64. The Stable Diffusion VAE downsamples by a factor of eight, so
that produced 8x8 latents and could not satisfy the assignment requirement for
self-attention at 16x16. I changed preprocessing to 128x128, verified the encoded
shape was 4x16x16, and added an assertion before training. I also replaced the demo's
simple linear noise interpolation with the required alpha-bar Gaussian diffusion
equation and verified schedule indices for assignment timestep 1000.
