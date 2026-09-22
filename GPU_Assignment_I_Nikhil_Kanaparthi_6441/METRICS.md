# METRICS - GPU Assignment I

Student: Nikhil Kanaparthi  
SID4: 6441  
GPU UUID: `GPU-a98bf6a6-5b25-331d-3b55-5cc9697e4e0d`  
GPU: Tesla T4

## Table HW2.5.1 - Summary table

| Measurement | Tesla T4 result / notes |
|---|---|
| Peak achieved TFLOPS (BF16 operation) | 2.3179 |
| % of theoretical peak (BF16) | N/A - NVIDIA does not publish a native BF16 peak for T4 |
| Effective bandwidth (GB/s) | 246.279 (76.96% of 320 GB/s) |
| Naive attention OOM length | Largest success: 16,384; smallest failure: not observed in tested range |
| Fused attention OOM length | Largest success: 16,384; smallest failure: not observed in tested range |
| Steady-state / peak throughput | 98.77% during the recorded monitoring loop |
| Throttle onset (s, or none) | None observed during the recorded monitoring loop |

## Supporting measurements

- Temperature/clock samples: 238
- Logged duration: 19.924 minutes
- Median sample interval: 5.043 seconds
- First-30-second peak throughput: 20.3069 TFLOPS
- Final-five-minute mean throughput: 20.0562 TFLOPS
- Maximum sampled temperature: 50.0 C
- Sampled SM clock range: 585-585 MHz
- Maximum sampled power: 44.11 W
- Maximum sampled utilization: 6.0%
- Naive attention quadratic memory coefficient: 0.000007629395 MiB/token^2

No failure was observed through sequence length 16,384, so a larger test range would be needed
to locate the OOM boundary.
