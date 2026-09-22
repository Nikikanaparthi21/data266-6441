# Submission limitations requiring instructor awareness

1. The measured GPU is a Tesla T4, which NVIDIA classifies as a data-center Tensor Core GPU,
   not an RTX GPU. The updated announcement permits any NVIDIA RTX GPU, so explicit instructor
   permission is still needed to use these results.
2. The notebook did not observe an OOM failure through sequence length 16,384; the true naive
   and fused OOM boundaries remain unmeasured.
3. The thermal loop slept after each short matmul. It ran for approximately 20 minutes but did
   not maintain sustained utilization, so its no-throttling finding is not a full-load result.
4. The supplied notebook file has no saved execution outputs. Raw CSV, JSON, log, and figure
   artifacts demonstrate that its cells ran, but the executed notebook itself was not preserved.
5. The T4 does not provide native TF32 or a vendor-published BF16 tensor peak, so those requested
   comparisons cannot be completed as written on this device.

These limitations are intentionally explicit. They should not be deleted or represented as
successful RTX measurements.
