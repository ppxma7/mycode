import os
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import sys

# Define root directory and file path
#group_name = "NEXPO"
#root_dir = "/Users/spmic/data/"
#root_dir = os.path.join("/Users/spmic/data/",group_name)
#root_dir = "/Users/spmic/data/san"

root_dir = "/Volumes/nemosine/SAN/"

hemisphere = "r"

fs_filename = os.path.join(root_dir, f"freesurfer_stats_{hemisphere}_combined.csv")
#fs_filename = os.path.join(root_dir, f"freesurfer_stats_{hemisphere}_{group_name}.csv")

print(fs_filename)

#sys.exit(0)

# Load FreeSurfer stats CSV
df = pd.read_csv(fs_filename)

# Compute mean and std per group for Gray Matter Volume (GMV) and Cortical Thickness
df_gmv = df.groupby(["StructName", "Group"]).agg(
    Mean=("GrayVol", "mean"),  # Compute mean GMV across subjects for each region
    Std_dev=("GrayVol", "std")  # Compute std deviation across subjects for GMV
).reset_index()


df_thickness = df.groupby(["StructName", "Group"]).agg(
    Mean=("ThickAvg", "mean"),  # Compute mean thickness across subjects
    Std_dev=("ThickAvg", "std")  # Compute std deviation for cortical thickness
).reset_index()

# Get unique regions and groups
regions = df["StructName"].unique()
groups = df["Group"].unique()
group_colors = {
    "AFIRM": "#e41a1c",   # red
    "SASHB": "#377eb8",   # blue
    "NEXPO1": "#4daf4a",  # green
    "NEXPO2": "#984ea3",  # purple
    "NEXPO3": "#ff7f00",  # orange
    "NEXPO4": "#a65628"   # brown
}

print("Grouped GMV Data:\n", df_gmv[df_gmv["StructName"] == "G frontal superior"])
print("Individual Data:\n", df[df["StructName"] == "G frontal superior"])

print(df["Group"].unique())  # Should match {"AFIRM", "SASHB", "NEXPO"}

df_gmv = df_gmv.set_index("StructName").loc[regions].reset_index()

# Define function to plot
def plot_grouped_bars(df_grouped, y_label, title, filename, ymin, ymax):
    plt.figure(figsize=(10, len(regions) * 0.3))  # scales figure height by #regions

    # Manually tuned bar width & spacing for fixed number of regions/groups
    bar_width = 0.1       # thinner bars so they don’t overlap
    group_spacing = 0.05  # extra gap between groups

    x = np.arange(len(regions))  # base positions

    # Plot bars with spacing
    for i, group in enumerate(groups):
        subset = df_grouped[df_grouped["Group"] == group]
        y_positions = x + i * (bar_width + group_spacing)
        plt.barh(
            y_positions, subset["Mean"],
            xerr=subset["Std_dev"],
            color=group_colors[group],
            alpha=0.6,
            label=f"{group} Mean ± Std Dev",
            height=bar_width
        )

    # Adjust yticks so labels are centered on the group stack
    total_group_height = len(groups) * bar_width + (len(groups) - 1) * group_spacing
    plt.yticks(x + total_group_height / 2 - (bar_width / 2), regions)

    # Formatting
    plt.xlabel(y_label)
    plt.ylabel("Brain Region")
    plt.title(title)
    plt.legend()

    # Apply x limits and add left padding
    plt.xlim(ymin, ymax)
    xmin, xmax = plt.xlim()
    plt.xlim(xmin - (xmax - xmin) * 0.05, xmax)

    plt.grid(True, linestyle="--", alpha=0.5)

    # Save the plot
    plot_path = os.path.join(root_dir, filename)
    plt.tight_layout()
    plt.savefig(plot_path, dpi=300)
    plt.close()
    print(f"Plot saved: {plot_path}")




ymin_gmv, ymax_gmv = 0, 25000  # GMV limits
ymin_thick, ymax_thick = 1.0, 5.0  # Thickness limits

# Plot GMV
plot_grouped_bars(df_gmv, "GrayVol", "Gray Matter Volume Across Brain Regions and Groups",
                   f"GMV_region_comparison_{hemisphere}_dots.png",ymin_gmv,ymax_gmv)

# Plot Cortical Thickness
plot_grouped_bars(df_thickness, "ThickAvg", "Cortical Thickness Across Brain Regions and Groups",
                   f"Cortical_Thickness_region_comparison_{hemisphere}_dots.png", ymin_thick, ymax_thick)
