import os
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Define root directory and file path
root_dir = "/Users/spmic/data/san"

hemisphere = "R"
fs_filename = os.path.join(root_dir, f"t1_stats_destrieux_combined_{hemisphere}.csv")

# Load FreeSurfer stats CSV
df = pd.read_csv(fs_filename)

# Compute mean and std per group
#df_grouped = df.groupby(["Region", "Group"])["Mean"].agg(["mean", "std"]).reset_index()

df_grouped = df.groupby(["Region", "Group"]).agg(
    Mean=("Mean", "mean"),  # Compute mean across subjects for each region
    Std_dev=("Mean", "std")  # Compute std deviation across subjects for each region
).reset_index()


# Get unique regions and groups
regions = df["Region"].unique()
groups = df["Group"].unique()
#group_colors = {"AFIRM": "#FD8D3C", "SASHB": "#E31A1C", "NEXPO": "#FD8D3C"}  # Customize colors per group
group_colors = {"AFIRM": "#e41a1c", "SASHB": "#377eb8", "NEXPO": "#4daf4a"}
# Define figure size
plt.figure(figsize=(10, len(regions) * 0.3))

# Bar width and positioning
bar_width = 0.25
x = np.arange(len(regions))  # X positions for each region
min_x = -1000
max_x = 10000
# Loop through groups to plot bars
for i, group in enumerate(groups):
    subset = df_grouped[df_grouped["Group"] == group]
    plt.barh(x + i * bar_width, subset["Mean"], xerr=subset["Std_dev"], 
             color=group_colors[group], alpha=0.6, label=f"{group} Mean ± Std Dev",
             height=bar_width)

# Add jittered individual subject points
jitter_strength = 0.1
for _, row in df.iterrows():
    region_index = np.where(regions == row["Region"])[0][0]  # Get x position
    group_offset = list(groups).index(row["Group"]) * bar_width  # Offset for groups
    plt.scatter(row["Mean"], region_index + group_offset, 
                color=group_colors[row["Group"]], alpha=0.6, edgecolors="black")

# Formatting
plt.yticks(x + bar_width / 2, regions)  # Set region names as y-axis labels
plt.xlabel("T1 Value")
plt.ylabel("Brain Region")
plt.title("T1 Values Across Brain Regions and Groups")
plt.legend()
plt.xlim(min_x, max_x)
plt.grid(True, linestyle="--", alpha=0.5)

# Save the plot
mean_plot_path = os.path.join(root_dir, f"T1_region_comparison_destrieux_{hemisphere}.png")
plt.tight_layout()
plt.savefig(mean_plot_path, dpi=300)
plt.close()

print(f"Plot saved: {mean_plot_path}")