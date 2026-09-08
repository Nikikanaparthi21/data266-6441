# DATA 266 Homework 1 Metrics

## Personal parameters

| Parameter | Value |
|---|---:|
| SID4 | 6441 |
| SEED | 6441 |
| SLICE | 441 |
| HP_ID | 3 |
| CLS_A | 1 |
| CLS_B | 7 |

## HP_ID 3 configuration

The baseline and modified models used the same `[64, 32]` architecture and
30 epochs. HP_ID 3 reduced the learning rate from `0.001` to `0.0003`.

The dataset split was fixed using `random_state=6441`. Model training used
seeds 6441, 6442, and 6443.

## Neural-network test accuracy

| Framework | Model | Hidden layers | Learning rate | Epochs | Seed 6441 | Seed 6442 | Seed 6443 | Mean | Std |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|
| PyTorch | Baseline | [64, 32] | 0.001 | 30 | 65.789% | 65.789% | 34.211% | 55.263% | 18.232% |
| PyTorch | Modified HP_ID 3 | [64, 32] | 0.0003 | 30 | 65.789% | 64.912% | 34.211% | 54.971% | 17.984% |
| TensorFlow | Baseline | [64, 32] | 0.001 | 30 | 66.667% | 65.789% | 71.930% | 68.129% | 3.321% |
| TensorFlow | Modified HP_ID 3 | [64, 32] | 0.0003 | 30 | 60.526% | 65.789% | 62.281% | 62.865% | 2.680% |

## CUDA matrix-multiplication measurements

Measurements are medians of three repetitions after warm-up. GPU end-to-end
time equals GPU kernel time plus H2D and D2H transfer time. Allocation time is
excluded.

| Matrix size | CPU (ms) | GPU kernel (ms) | H2D+D2H (ms) | GPU end-to-end (ms) | Speedup |
|---:|---:|---:|---:|---:|---:|
| 256 | 3.161 | 0.113 | 0.256 | 0.369 | 8.578x |
| 1024 | 219.810 | 3.257 | 2.964 | 6.221 | 35.345x |
| 4096 | 26208.769 | 200.268 | 44.798 | 245.066 | 106.946x |

All three CUDA results passed the CPU-versus-GPU correctness check.

## CUDA profiler

Profiler used: `nvprof`

For the 1024 × 1024 profiling run, `nvprof` reported the matrix-multiplication
kernel separately from host-to-device and device-to-host memory copies. The
kernel averaged approximately 5.795 ms per call. The program's measured
iteration reported 5.817 ms of kernel time and 3.136 ms of combined transfer
time.
