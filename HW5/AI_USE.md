# AI Use - Homework 5

## How AI assistance was used

I used an AI assistant to develop a first-cut notebook structure, adapt the provided LoRA demonstration to the DialogSum dataset, and understand the overall training workflow. The assistance covered preprocessing the dialogue and summary fields, running baseline inference, configuring LoRA, comparing ranks 4 and 16, saving the trained adapters, and interpreting the resulting ROUGE metrics.

I executed the notebook one section at a time, reviewed the code and outputs, and created incremental GitHub commits as the work progressed. I also verified that the baseline and both LoRA configurations were evaluated using the same selected dialogues and held-out evaluation subset.

## Error encountered and resolution

During the LoRA rank-4 experiment, PEFT produced the following error:

```text
ImportError: Found an incompatible version of torchao. Found version 0.10.0,
but only versions above 0.16.0 are supported.
```

I used the traceback and AI assistance to determine that the version of `torchao` preinstalled in the Colab environment was incompatible with the installed PEFT version. The `torchao` package was optional and was not required for this FLAN-T5 LoRA experiment.

I removed the incompatible package using:

```python
!pip uninstall -y torchao
```

I then restarted the Colab runtime and reran the notebook cells in order. This resolved the issue because PEFT no longer detected the incompatible optional `torchao` installation.

## Model-specific LoRA configuration

I also used AI assistance to understand that FLAN-T5 identifies its attention query and value modules as `q` and `v`. Other transformer architectures may use module names such as `q_proj` and `v_proj`, but those names are not appropriate for FLAN-T5.

The final LoRA configuration used:

```python
target_modules=["q", "v"]
```

I verified these target-module names before training. I then reviewed the rank-4 and rank-16 results and based the final interpretation on the metrics produced by the executed notebook.
