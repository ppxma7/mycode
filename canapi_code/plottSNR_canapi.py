import matplotlib.pyplot as plt
import numpy as np

# Data
values = [
    18.4534618, 17.27214816, 20.65276905, 21.36450172, 15.02913097, 14.81026768,
    26.08808278, 24.08390185, 31.08399756, 29.99419266, 21.22832179, 20.35121216
]
labels = ["Raw"] * 6 + ["Nordic"] * 6
groups = ["1bar", "1bar run 2", "30prc", "30prc run2", "50prc", "50prc run 2", 
          "1bar", "1bar run 2", "30prc", "30prc run2", "50prc", "50prc run 2"]

# Unique x-axis labels
unique_groups = ["1bar", "1bar run 2", "30prc", "30prc run2", "50prc", "50prc run 2"]
x_indices = np.arange(len(unique_groups))  # x positions for the groups

# Separate Raw and Nordic values
raw_values = [values[i] for i in range(len(values)) if labels[i] == "Raw"]
nordic_values = [values[i] for i in range(len(values)) if labels[i] == "Nordic"]

# Bar width and offset
bar_width = 0.35

# Plot bars
plt.figure(figsize=(10, 6))
plt.bar(x_indices - bar_width / 2, raw_values, bar_width, label="Raw", color="skyblue")
plt.bar(x_indices + bar_width / 2, nordic_values, bar_width, label="Nordic", color="orange")

# Add labels and title
plt.xlabel("Groups")
plt.ylabel("Values")
plt.title("Grouped Bar Chart: Raw vs Nordic")
plt.xticks(x_indices, unique_groups, rotation=45, ha="right")  # Rotate x-axis labels for clarity
plt.legend()
plt.grid(axis="y", linestyle="--", alpha=0.7)

# Show the plot
plt.tight_layout()
plt.show()
