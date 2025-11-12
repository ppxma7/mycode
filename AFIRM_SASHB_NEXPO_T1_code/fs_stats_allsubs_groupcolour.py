import os
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Define root directory and file path
root_dir = "/Users/spmic/data/"
fs_filename = os.path.join(root_dir, "freesurfer_stats_combined.csv")

# Define the specific brain region to analyze
region_name = "G_postcentral"

# Load FreeSurfer stats CSV
df = pd.read_csv(fs_filename)

# Filter for the selected region
df_region = df[df["StructName"] == region_name]

# Set consistent y-axis limits
ymin_gmv, ymax_gmv = 0, 15000  # Example values for GMV
ymin_thick, ymax_thick = 0.0, 5.0  # Example values for Thickness

# Define colors for each group
group_colors = {"SASHB": "#FD8D3C", "AFIRM": "#E31A1C"}  # Customize as needed
#colors = ['#FFEDA0', '#FD8D3C', '#E31A1C', '#BD0026', '#800026']

# Generate colors based on the group
colors = df_region["Group"].map(group_colors)



# Check if region exists
if df_region.empty:
    print(f"Region '{region_name}' not found in the data.")
else:
    # Define output plot paths
    gmv_plot_path = os.path.join(root_dir, f"{region_name}_gmv_jittered.png")
    thickness_plot_path = os.path.join(root_dir, f"{region_name}_thickness_jittered.png")

    # Generate jitter (random small offset) to spread points along x-axis
    jitter_strength = 0.1  # Adjust to control spread
    jitter = np.random.uniform(-jitter_strength, jitter_strength, size=len(df_region))

    # Convert group names to numerical positions
    group_mapping = {group: i for i, group in enumerate(df_region["Group"].unique())}
    x_positions = df_region["Group"].map(group_mapping) + jitter

    # **Plot 1: Gray Matter Volume (GMV) by Group**
    plt.figure(figsize=(5, 5))
    plt.scatter(x_positions, df_region["GrayVol"], color=colors, alpha=0.7)
    plt.xticks(range(len(group_mapping)), group_mapping.keys(), rotation=45)
    plt.xlabel("Group")
    plt.ylabel("Gray Matter Volume (mm³)")
    plt.title(f"Gray Matter Volume - {region_name}")
    plt.ylim(ymin_gmv, ymax_gmv)
    plt.grid(True, linestyle="--", alpha=0.5)

    # Save GMV plot
    plt.tight_layout()
    plt.savefig(gmv_plot_path, dpi=300)
    plt.close()
    print(f"GMV plot saved: {gmv_plot_path}")

    # **Plot 2: Cortical Thickness (ThickAvg) by Group**
    plt.figure(figsize=(5, 5))
    plt.scatter(x_positions, df_region["ThickAvg"], color=colors, alpha=0.7)
    plt.xticks(range(len(group_mapping)), group_mapping.keys(), rotation=45)
    plt.xlabel("Group")
    plt.ylabel("Cortical Thickness (mm)")
    plt.title(f"Cortical Thickness - {region_name}")
    plt.ylim(ymin_thick, ymax_thick)
    plt.grid(True, linestyle="--", alpha=0.5)

    # Save Thickness plot
    plt.tight_layout()
    plt.savefig(thickness_plot_path, dpi=300)
    plt.close()
    print(f"Thickness plot saved: {thickness_plot_path}")
