import os
import pandas as pd
import matplotlib.pyplot as plt

# Define root directory and file path
root_dir = "/Users/spmic/data"
fs_filename = os.path.join(root_dir, "freesurfer_stats.csv")

# Define the specific brain region to analyze
region_name = "G_postcentral"

# Load FreeSurfer stats CSV
df = pd.read_csv(fs_filename)

# Filter for the selected region
df_region = df[df["StructName"] == region_name]

# Set consistent y-axis limits (adjust values based on your data range)
ymin_gmv, ymax_gmv = 0, 15000  # Example values for GMV
ymin_thick, ymax_thick = 0.0, 5.0  # Example values for Thickness

# Check if region exists
if df_region.empty:
    print(f"Region '{region_name}' not found in the data.")
else:
    # Define output plot paths
    gmv_plot_path = os.path.join(root_dir, f"{region_name}_gmv.png")
    thickness_plot_path = os.path.join(root_dir, f"{region_name}_thickness.png")

    # **Plot 1: Gray Matter Volume (GMV) per Subject**
    plt.figure(figsize=(10, 5))
    plt.scatter(df_region["Subject"], df_region["GrayVol"], color="blue", alpha=0.7)
    plt.xlabel("Subject")
    plt.ylabel("Gray Matter Volume (mm³)")
    plt.title(f"Gray Matter Volume - {region_name}")
    plt.xticks(rotation=45)
    plt.ylim(ymin_gmv, ymax_gmv)  # Set consistent y-axis limits
    plt.grid(True, linestyle="--", alpha=0.5)
    
    # Save GMV plot
    plt.tight_layout()
    plt.savefig(gmv_plot_path, dpi=300)
    plt.close()
    print(f"GMV plot saved: {gmv_plot_path}")

    # **Plot 2: Cortical Thickness (ThickAvg) per Subject**
    plt.figure(figsize=(10, 5))
    plt.scatter(df_region["Subject"], df_region["ThickAvg"], color="green", alpha=0.7)
    plt.xlabel("Subject")
    plt.ylabel("Cortical Thickness (mm)")
    plt.title(f"Cortical Thickness - {region_name}")
    plt.xticks(rotation=45)
    plt.ylim(ymin_thick, ymax_thick)  # Set consistent y-axis limits
    plt.grid(True, linestyle="--", alpha=0.5)
    
    # Save Thickness plot
    plt.tight_layout()
    plt.savefig(thickness_plot_path, dpi=300)
    plt.close()
    print(f"Thickness plot saved: {thickness_plot_path}")
