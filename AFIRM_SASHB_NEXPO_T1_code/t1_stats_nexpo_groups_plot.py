import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Define file paths
root_dir = "/Users/spmic/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/nexpo_plots"
hemisphere = "R"
fs_filename = os.path.join(root_dir, f"t1_stats_destrieux_NEXPO_{hemisphere}_with_groups.csv")

# Load the data
df = pd.read_csv(fs_filename)

# Ensure Group2 is string for consistency
df["Group2"] = df["Group2"].astype(str)

# Define group colors (map Group2 values to colors)
#group_colors = {"1": "#e41a1c", "2": "#377eb8", "3": "#4daf4a", "4": "#984ea3"}

# Sort regions and groups to ensure consistent order
regions = sorted(df["Region"].unique())
groups = sorted(df["Group2"].unique())

# Set categorical order for plot aesthetics
df["Region"] = pd.Categorical(df["Region"], categories=regions, ordered=True)
df["Group2"] = pd.Categorical(df["Group2"], categories=groups, ordered=True)

# Set up the figure
plt.figure(figsize=(12, len(regions) * 0.3))

# Use a built-in pastel palette with as many colors as needed
light_palette = sns.color_palette("pastel", n_colors=len(groups))

# Map these to your group values:
group_colors = dict(zip(groups, light_palette))


# Plot horizontal boxplots grouped by region and colored by group
sns.boxplot(
    data=df,
    y="Region",
    x="Mean",
    hue="Group2",
    palette=group_colors,
    orient="h",
    dodge=True,
    showcaps=True,
    fliersize=3,
    linewidth=1,
    flierprops=dict(marker='o', color='gray', alpha=0.4)
)

# Formatting
plt.xlabel("T1 Value")
plt.ylabel("Brain Region")
plt.title("T1 Box Plots Across Brain Regions and Groups")
plt.grid(True, linestyle="--", alpha=0.4)
plt.legend(title="Group", loc="best")
plt.tight_layout()
plt.xlim(0, 9000)
# Save figure
output_path = os.path.join(root_dir, f"T1_boxplot_region_destrieux_{hemisphere}.png")
plt.savefig(output_path, dpi=300)
plt.close()

print(f"✅ Boxplot saved to: {output_path}")
