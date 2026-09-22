# Vendor specifications and provenance

## Measured GPU

- GPU: Tesla T4
- UUID: `GPU-a98bf6a6-5b25-331d-3b55-5cc9697e4e0d`
- Architecture: NVIDIA Turing
- CUDA cores: 2,560
- Tensor cores: 320 Turing Tensor Cores
- Memory: 16 GB GDDR6 (the Colab allocation reported 14.563 GiB usable)
- Specified memory bandwidth: 320+ GB/s
- FP32 peak: 8.1 TFLOPS
- Mixed-precision FP16/FP32 peak: 65 TFLOPS
- Supported reduced precision listed by NVIDIA: FP16, INT8, and INT4
- Power rating: 70 W
- Driver: 580.82.07
- CUDA runtime reported by PyTorch: 12.8

Source: NVIDIA T4 product page: https://www.nvidia.com/en-us/data-center/tesla-t4/

## Important eligibility note

NVIDIA markets the T4 as a data-center Tensor Core GPU, not as an RTX GPU. The instructor's
updated announcement permits any NVIDIA RTX GPU. These measurements therefore require explicit
instructor approval if they are submitted instead of results from an RTX-branded GPU.
