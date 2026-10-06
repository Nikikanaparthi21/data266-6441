# AI Use - Homework 6

I used an AI assistant to develop a first-cut notebook structure, adapt the provided self-supervised learning demo from CIFAR-10 to STL-10, and implement the assignment requirements with a common ResNet-18 backbone. The assistance helped me understand the differences between end-to-end supervision, rotation pretraining, SimCLR contrastive learning, frozen linear evaluation, cosine nearest-neighbor retrieval, and checkpoint-based recovery in Colab.

I ran the notebook incrementally, reviewed the code and outputs, verified that the labeled subset contained exactly 500 balanced examples, confirmed that the rotation encoder used all 100,000 unlabeled images, and checked that SimCLR used two augmented views from 20,000 unlabeled images with temperature 0.2. I also confirmed that only each linear classification head was trainable during the frozen-encoder evaluations and based the final comparison on the measured accuracies and nearest-neighbor results.
