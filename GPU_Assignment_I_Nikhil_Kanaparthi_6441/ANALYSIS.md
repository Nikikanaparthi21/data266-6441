# GPU Assignment I - Analysis

Student: Nikhil Kanaparthi  
SID4: 6441  
GPU: Tesla T4  
UUID: `GPU-a98bf6a6-5b25-331d-3b55-5cc9697e4e0d`

## Part A - Onboarding and provenance

The run used a Google Colab Tesla T4 with UUID `GPU-a98bf6a6-5b25-331d-3b55-5cc9697e4e0d`. Full `nvidia-smi -q` output is included.
The vendor properties and official NVIDIA source are recorded in `VENDOR_SPECS.md`. No lab
reservation was made; the known runtime duration is documented in `GPU_HOURS.md`.

## Part B - Precision and achieved throughput

| N | Precision | Achieved TFLOPS | Native peak | % peak | Repetitions | Arithmetic intensity | Interpretation |
|---|---|---|---|---|---|---|---|
| 1024 | FP32 | 3.4052 | 8.1 | 42.04 | 20 | 170.67 | Native T4 FP32 |
| 1024 | TF32 | 3.3656 | N/A | N/A | 20 | 170.67 | T4 does not provide native TF32; this float32 run followed the FP32 path |
| 1024 | FP16 | 18.6385 | 65.0 | 28.67 | 20 | 341.33 | Native T4 FP16 Tensor Core peak used |
| 1024 | BF16 | 1.8262 | N/A | N/A | 20 | 341.33 | T4 does not publish native BF16 throughput; PyTorch completed the operation without a native BF16 peak comparison |
| 4096 | FP32 | 3.8324 | 8.1 | 47.31 | 10 | 682.67 | Native T4 FP32 |
| 4096 | TF32 | 4.1792 | N/A | N/A | 10 | 682.67 | T4 does not provide native TF32; this float32 run followed the FP32 path |
| 4096 | FP16 | 25.5617 | 65.0 | 39.33 | 10 | 1365.33 | Native T4 FP16 Tensor Core peak used |
| 4096 | BF16 | 2.3179 | N/A | N/A | 10 | 1365.33 | T4 does not publish native BF16 throughput; PyTorch completed the operation without a native BF16 peak comparison |
| 8192 | FP32 | 3.9844 | 8.1 | 49.19 | 3 | 1365.33 | Native T4 FP32 |
| 8192 | TF32 | 3.9663 | N/A | N/A | 3 | 1365.33 | T4 does not provide native TF32; this float32 run followed the FP32 path |
| 8192 | FP16 | 23.2275 | 65.0 | 35.73 | 3 | 2730.67 | Native T4 FP16 Tensor Core peak used |
| 8192 | BF16 | 2.2608 | N/A | N/A | 3 | 2730.67 | T4 does not publish native BF16 throughput; PyTorch completed the operation without a native BF16 peak comparison |
| 16384 | FP32 | 4.7872 | 8.1 | 59.10 | 1 | 2730.67 | Native T4 FP32 |
| 16384 | TF32 | 4.7532 | N/A | N/A | 1 | 2730.67 | T4 does not provide native TF32; this float32 run followed the FP32 path |
| 16384 | FP16 | 16.9522 | 65.0 | 26.08 | 1 | 5461.33 | Native T4 FP16 Tensor Core peak used |
| 16384 | BF16 | 2.1223 | N/A | N/A | 1 | 5461.33 | T4 does not publish native BF16 throughput; PyTorch completed the operation without a native BF16 peak comparison |

FP16 achieved the highest measured throughput, peaking at 25.5617
TFLOPS at N=4096. FP32 continued increasing through the largest tested size, so a clear FP32
plateau was not reached. The apparent FP16 peak at N=4096 and decline at larger sizes should be
interpreted cautiously because N=16384 used only one repetition and no variance was saved.
Small matrices do not fully utilize the GPU because launch overhead, limited parallel work, and
data movement occupy a larger share of execution time.

The T4 does not have native TF32 or a published native BF16 peak. Therefore the TF32-labelled
float32 run is interpreted as FP32-path behavior, and BF16 percent-of-peak is reported as N/A.
NVIDIA lists INT8 and INT4 support, but the recorded notebook did not benchmark those precisions.

## Part C - Bandwidth-bound versus compute-bound

The elementwise add achieved 246.279 GB/s, or
76.96% of the 320 GB/s vendor bandwidth. Its arithmetic intensity is
1/12 = 0.083333 FLOP/byte, so it is memory-bound. Using the
published FP32 peak and memory bandwidth, the T4 FP32 roofline balance point is approximately
25.312 FLOP/byte. A square FP32 matmul has approximate arithmetic intensity
N/6 FLOP/byte; even at N=1024 this is 170.667 FLOP/byte, well above the balance point, so the
tested square matmuls are compute-bound.

## Part D - The cost of attention

The attention test used batch size 1, one head, and head dimension 64. Naive attention
materialized both the score and probability matrices. Its measured memory grew from 10.375 MiB
at length 512 to 2064.125 MiB at length 16,384. The fitted quadratic coefficient was
0.000007629395 MiB/token^2, confirming a positive quadratic
term from the measured data.

| Length | Naive ms | Fused ms | Speedup | Naive MiB | Fused MiB | Memory reduction % |
|---|---|---|---|---|---|---|
| 512 | 0.1613 | 0.0758 | 2.13 | 10.38 | 8.44 | 18.67 |
| 1024 | 0.1556 | 0.1301 | 1.20 | 16.62 | 8.75 | 47.37 |
| 2048 | 0.4024 | 0.2855 | 1.41 | 41.12 | 9.38 | 77.20 |
| 4096 | 1.7326 | 0.6574 | 2.64 | 138.12 | 10.62 | 92.31 |
| 8192 | 6.0170 | 2.3973 | 2.51 | 524.12 | 13.12 | 97.50 |
| 16384 | 20.1431 | 7.6553 | 2.63 | 2064.12 | 18.12 | 99.12 |

The fused operation was faster at every tested length. It avoids materializing the complete
sequence-by-sequence attention matrix in global memory, performs intermediate reductions within
the kernel, and reduces memory traffic between separate operations. This explains why its peak
memory remained much smaller and why its advantage grew at long sequences. Neither implementation
failed through length 16,384, so the actual OOM boundaries were not established by this run.

## Part E - Sustained load and thermal behavior

The log spans 19.924 minutes with 238 samples. The first-30-second
peak was 20.3069 TFLOPS and the final-five-minute mean was 20.0562 TFLOPS,
giving a steady-state/peak ratio of 98.77%. No clock or temperature throttle
onset was observed.

The monitoring loop performed one short matmul and then slept for five seconds. Sampled
utilization was therefore mostly near zero, the SM clock remained around
585 MHz, and temperature remained near
49 C. I therefore interpret this as an intermittent-load monitoring result rather than a
continuous full-load thermal stress test.

## Part F - Overall findings

The measurements demonstrate the difference between compute-oriented matrix multiplication and
a memory-bound elementwise operation, and they directly confirm quadratic memory growth for
naive attention. Fused attention reduced both peak memory and latency at every tested sequence
length. On the available T4 runtime, native TF32 and BF16 peak comparisons were unavailable, no
attention OOM failure occurred through length 16,384, and the monitoring loop represented an
intermittent rather than continuous load. These observations define the scope of the reported
results.
