import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os
import sys

rootFolder = sys.argv[1]

print("Using rootFolder:", rootFolder)

#rootFolder="/Volumes/nemosine/SAN/SASHB/t1mapping_out"
output_path = os.path.join(rootFolder, "r2threshplot.png")

df = pd.read_csv(os.path.join(rootFolder, "R2_stats.txt"))

y = df["meanR2"]

# --- Compute global stats ---
global_mean = y.mean()
global_median = y.median()

# --- Horizontal jitter: small Gaussian noise ---
jitter = np.random.normal(loc=0, scale=0.01, size=len(df))
x = 1 + jitter

plt.figure(figsize=(6,6))

# Points
plt.scatter(x, y, s=20)

#Labels
for xi, yi, subj in zip(x, y, df["subject"]):
    plt.text(xi + 0.002, yi, subj, fontsize=5, va='center', rotation=0)


# --- Horizontal reference lines ---
plt.axhline(global_mean, color='red', linestyle='-', linewidth=1, label=f"Mean = {global_mean:.2f}")
plt.axhline(global_median, color='blue', linestyle='--', linewidth=1, label=f"Median = {global_median:.2f}")


# X-axis formatting
plt.xticks([1], ["All Subjects"])
plt.xlim(0.9, 1.1)

plt.ylabel("Mean R2")
plt.title("Mean R2 per Subject (with jitter)")
plt.grid(True, axis='y', linestyle='--', alpha=0.4)
plt.legend(loc="upper right")
plt.tight_layout()
plt.savefig(output_path, dpi=300, bbox_inches='tight')
print(f"Figure saved at {output_path}")
