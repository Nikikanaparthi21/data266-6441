# AI-Use Appendix - Nikhil Kanaparthi

## 1. Which parts did you use an assistant for, and which did you write yourself?

I used ChatGPT to break the assignment into smaller steps, adapt the course demonstrations to the HW1 requirements, and draft reusable PyTorch, TensorFlow, and CUDA scaffolding. It also helped me organize the result tables and identify what the loss curves and profiler output showed. I ran every cell myself, checked the dataset dimensions, inspected the plots, verified the CPU/GPU correctness result, and reviewed the interpretations against my own numerical outputs. I also made the GitHub commits and prepared the repository submission.

## 2. Give one specific thing it produced that was wrong. Paste the wrong output.

The first dataset-loading suggestion assumed that the CSV contained a header row and proposed:

```python
df = pd.read_csv("diabetes.csv")
TARGET = "Outcome"
```

That was wrong because the supplied course CSV has no header. The incorrect load consumed the first example as column names and produced:

```text
Shape: (758, 9)
Columns: ['-0.294118', '0.487437', '0.180328', '-0.292929',
          '0', '0.00149028', '-0.53117', '-0.0333333', '0.1']
KeyError: 'Outcome'
```

## 3. How did you find out? What did the failure look like?

I inspected `df.shape` and `df.columns` before training. The assignment file should contain 759 examples, but the DataFrame only contained 758. The columns were numeric values from the first record instead of feature names, and selecting `df["Outcome"]` failed with `KeyError: 'Outcome'`. This showed that the loader had interpreted the first data record as a header.

## 4. What did you change, and why does your version work?

I loaded the CSV with `header=None` and supplied the eight feature names plus `Outcome` explicitly:

```python
FEATURE_NAMES = [
    "Pregnancies", "Glucose", "BloodPressure", "SkinThickness",
    "Insulin", "BMI", "DiabetesPedigreeFunction", "Age"
]

df = pd.read_csv(
    "diabetes.csv",
    header=None,
    names=FEATURE_NAMES + ["Outcome"]
)
```

The corrected DataFrame has shape `(759, 9)`, preserves the first record as data, contains no missing values, and exposes a binary `Outcome` column with 263 class-0 and 496 class-1 examples. I added assertions for the shape, missing-value count, and target values so the notebook stops immediately if the data is loaded incorrectly in a later run.
