# Experimental notes

1. Google Colab assigned a Tesla T4 for this run. NVIDIA classifies the T4 as a data-center
   Tensor Core GPU rather than an RTX-branded GPU.
2. The notebook did not observe an OOM failure through sequence length 16,384; the true naive
   and fused OOM boundaries are above the tested range.
3. The thermal loop slept after each short matmul. It ran for approximately 20 minutes but did
   not maintain continuous utilization, so the result describes this monitoring workload only.
4. The supplied notebook file has no saved execution outputs. Raw CSV, JSON, log, and figure
   artifacts contain the recorded results from the Colab run.
5. The T4 does not provide native TF32 or a vendor-published BF16 tensor peak, so those requested
   comparisons are reported as N/A.
