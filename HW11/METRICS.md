# Homework 11 Metrics

Student: Nikhil Kanaparthi  
SID4: 6441  
Model: `openai/clip-vit-base-patch32`  
Dataset: CIFAR-10 test split; 100 images per class; 1,000 images total

## Caption-to-image similarity

Caption: `a clear color photograph of a car`  
Target class: `automobile`

|   true_class_id | true_class_name   |   image_count |   mean_similarity |   std_similarity |   min_similarity |   median_similarity |   max_similarity |
|----------------:|:------------------|--------------:|------------------:|-----------------:|-----------------:|--------------------:|-----------------:|
|               1 | automobile        |           100 |            0.2518 |           0.0118 |           0.2198 |              0.2512 |           0.2831 |
|               9 | truck             |           100 |            0.2141 |           0.0135 |           0.1768 |              0.2127 |           0.2591 |
|               6 | frog              |           100 |            0.2012 |           0.0114 |           0.1739 |              0.2012 |           0.2264 |
|               0 | airplane          |           100 |            0.1936 |           0.0169 |           0.1507 |              0.1931 |           0.2469 |
|               3 | cat               |           100 |            0.1928 |           0.0109 |           0.1657 |              0.1935 |           0.2238 |
|               4 | deer              |           100 |            0.1927 |           0.0105 |           0.1625 |              0.1927 |           0.2184 |
|               2 | bird              |           100 |            0.1917 |           0.0127 |           0.1624 |              0.1913 |           0.2331 |
|               5 | dog               |           100 |            0.1886 |           0.0122 |           0.1579 |              0.1892 |           0.2222 |
|               8 | ship              |           100 |            0.188  |           0.0177 |           0.1527 |              0.1864 |           0.2551 |
|               7 | horse             |           100 |            0.1858 |           0.0106 |           0.1521 |              0.1861 |           0.209  |

## Zero-shot classification

Overall accuracy: **89.50%**

|   class_id | class_name   |   correct |   total | accuracy   |
|-----------:|:-------------|----------:|--------:|:-----------|
|          0 | airplane     |        93 |     100 | 93.00%     |
|          1 | automobile   |        94 |     100 | 94.00%     |
|          2 | bird         |        87 |     100 | 87.00%     |
|          3 | cat          |        89 |     100 | 89.00%     |
|          4 | deer         |        79 |     100 | 79.00%     |
|          5 | dog          |        90 |     100 | 90.00%     |
|          6 | frog         |        76 |     100 | 76.00%     |
|          7 | horse        |        98 |     100 | 98.00%     |
|          8 | ship         |        92 |     100 | 92.00%     |
|          9 | truck        |        97 |     100 | 97.00%     |

The raw and normalized confusion matrices are saved in `confusion_matrix_counts.csv` and `confusion_matrix_normalized.csv`.
