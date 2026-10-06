# Homework 6 Metrics

Student: Nikhil Kanaparthi  
SID4: 6441  
Seed: 6441  
Dataset: STL-10  
Backbone: ResNet-18 with no pretrained weights

## Model comparison

| method                      | backbone                |   pretraining_images |   pretraining_epochs |   linear_probe_epochs |   test_accuracy_percent |   test_loss |   top5_neighbor_purity_percent |
|:----------------------------|:------------------------|---------------------:|---------------------:|----------------------:|------------------------:|------------:|-------------------------------:|
| Supervised (500 labels)     | ResNet-18, weights=None |                  500 |                   15 |                     0 |                    36.2 |      1.7074 |                        26.6667 |
| Rotation SSL + linear probe | ResNet-18, weights=None |               100000 |                   15 |                    20 |                    46.9 |      2.6843 |                        20      |
| SimCLR + linear probe       | ResNet-18, weights=None |                20000 |                   15 |                    20 |                    43.6 |      3.8022 |                        46.6667 |

## Nearest-neighbor label purity

| encoder      |   top5_label_purity_percent |
|:-------------|----------------------------:|
| SimCLR       |                      46.667 |
| Supervised   |                      26.667 |
| Rotation SSL |                      20     |

## Required analysis

The strongest test classifier was Rotation SSL + linear probe with 46.90% accuracy. All three methods used the same unpretrained ResNet-18 architecture and the same balanced 500-image labeled subset, so the main experimental difference was how each representation was learned.
The supervised baseline achieved 36.20% accuracy. It received direct class supervision but only from 500 images, so it can learn task-specific boundaries while also being vulnerable to overfitting. Stronger regularization, tuned augmentation, longer scheduling, or additional labels could improve it.
Rotation SSL achieved 46.90% accuracy after learning from all 100,000 unlabeled images. Rotation prediction encourages shape and orientation features, but the proxy task does not always align with semantic object categories. Longer pretraining, multi-task pretexts, or carefully tuned spatial augmentations could improve this representation.
SimCLR achieved 43.60% accuracy after contrastive training on 20,000 unlabeled images. Its result depends on augmentation quality, batch negatives, training duration, and temperature. A larger batch, more pretraining epochs, a learning-rate warmup, or a larger unlabeled subset could improve it.
The nearest-neighbor visualizations used identical queries and cosine similarity for all encoders. SimCLR + linear probe had the highest top-5 label purity at 46.67%. Rows containing visually and semantically consistent neighbors indicate a representation that clusters class-relevant features; mismatched neighbors reveal sensitivity to background, color, pose, or low-level texture.
