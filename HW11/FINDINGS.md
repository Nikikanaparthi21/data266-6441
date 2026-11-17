# Homework 11 Findings

## Method

I selected exactly 100 CIFAR-10 test images from each class with seed 6441. I used `openai/clip-vit-base-patch32` without fine-tuning. Image and text features were L2-normalized, so their dot products are cosine similarities. For classification, five text prompts per class were averaged into one normalized prototype.

## Results and interpretation

1. **Caption similarity:** the caption `a clear color photograph of a car` was compared with 1,000 images, including exactly 100 from every CIFAR-10 class.
2. **Class alignment:** `automobile` ranked 1 of 10 by mean cosine similarity. Its mean was 0.2518, compared with 0.1943 across non-target images (gap +0.0576).
3. **Top matches:** 100% of the 20 highest-scoring images belonged to the target class. The highest mean-similarity class was `automobile`.
4. **Zero-shot accuracy:** CLIP classified the balanced 1,000-image subset with overall accuracy 89.50%, without CIFAR-10 training or fine-tuning.
5. **Class variation:** the best class was `horse` at 98.00%; the lowest was `frog` at 76.00%.
6. **Largest confusion:** the most frequent off-diagonal error was deer → horse (18 of 100 images).
7. **Interpretation:** CLIP transfers useful semantic knowledge to CIFAR-10, but the 32×32 images are much lower resolution than typical CLIP training images. Similar-looking classes and prompt wording therefore still affect the results.

## Limitations

- This is a balanced 1,000-image sample rather than the complete 10,000-image CIFAR-10 test set.
- CIFAR-10 images are only 32×32 pixels and must be resized for CLIP.
- Zero-shot results depend on the wording of the class prompts.
- Similarity indicates semantic alignment; it is not a calibrated probability that the caption is literally correct.
