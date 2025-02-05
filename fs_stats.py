import os
import pandas as pd
import matplotlib.pyplot as plt

# Define root directory where all subject FreeSurfer stats files are stored
root_dir = "/Users/spmic/data"
#subjects = ["16469-002A", "Subject2", "Subject3"]  # Add more subjects here
subjects = ["16469-002A", "16500-002B"]
# Define the stats file relative path
stats_filename = "analysis/anatMRI/T1/processed/FreeSurfer/stats/lh.aparc.a2009s.stats"

# Initialize empty list to store DataFrames
all_data = []

# Loop through subjects
for subject in subjects:
    stats_path = os.path.join(root_dir, subject, stats_filename)
    
    if not os.path.exists(stats_path):
        print(f"Warning: Stats file not found for {subject}")
        continue
    
    # Read the file, skipping header lines (starting with #)
    with open(stats_path, "r") as file:
        lines = file.readlines()
    
    # Find where the actual data starts (after the last header line)
    for i, line in enumerate(lines):
        if line.startswith("# ColHeaders"):
            headers = line.strip().split()[2:]  # Extract headers after "# ColHeaders"
            data_start_idx = i + 1  # Data starts on the next line
            break
    
    # Read the data into a DataFrame
    data = [line.strip().split() for line in lines[data_start_idx:]]
    df = pd.DataFrame(data, columns=headers)
    
    # Convert numerical columns to float
    numeric_cols = ["NumVert", "SurfArea", "GrayVol", "ThickAvg", "ThickStd", "MeanCurv", "GausCurv", "FoldInd", "CurvInd"]
    df[numeric_cols] = df[numeric_cols].astype(float)
    
    # Add subject column
    df["Subject"] = subject
    
    # Append to the list
    all_data.append(df)

# Combine all subjects into one DataFrame
df_all = pd.concat(all_data, ignore_index=True)

# Save table to show to user
output_csv_path = os.path.join(root_dir, "freesurfer_stats.csv")
df_all.to_csv(output_csv_path, index=False)
print(f"Data saved to {output_csv_path}")

# Set consistent y-axis limits (adjust values based on your data range)
ymin_gmv, ymax_gmv = 0, 15000  # Example values for GMV
ymin_thick, ymax_thick = 0.0, 5.0  # Example values for Thickness

# Loop through subjects and save each subject's plot separately
for subject in subjects:
    sub_df = df_all[df_all["Subject"] == subject]
    
    # Define output path for each subject
    output_plot_path = os.path.join(root_dir, subject, f"{subject}_gmv.png")
    
    # Create figure
    plt.figure(figsize=(12, 6))
    plt.scatter(sub_df["StructName"], sub_df["GrayVol"], alpha=0.6)
    
    plt.xlabel("Brain Region")
    plt.ylabel("Gray Matter Volume (mm³)")
    plt.title(f"Gray Matter Volume - {subject}")
    plt.xticks(rotation=90)
    plt.ylim(ymin_gmv, ymax_gmv)  # Set consistent y-axis limits
    plt.grid(True, linestyle="--", alpha=0.5)
    
    # Save figure instead of showing
    plt.tight_layout()
    plt.savefig(output_plot_path, dpi=300)
    plt.close()  # Close the figure to free memory
    print(f"Scatter plot saved for {subject}: {output_plot_path}")

# Loop through subjects and save each subject's bar chart separately
for subject in subjects:
    sub_df = df_all[df_all["Subject"] == subject]
    
    # Define output path for each subject
    output_plot_path = os.path.join(root_dir, subject, f"{subject}_ct_thick.png")

    # Create bar chart figure
    plt.figure(figsize=(12, 6))
    plt.bar(sub_df["StructName"], sub_df["ThickAvg"], label=f"{subject} - Thickness", alpha=0.7)
    plt.errorbar(sub_df["StructName"], sub_df["ThickAvg"], yerr=sub_df["ThickStd"], fmt="o", color="red", alpha=0.6)
    
    plt.xlabel("Brain Region")
    plt.ylabel("Cortical Thickness (mm)")
    plt.title(f"Cortical Thickness Across Brain Regions - {subject}")
    plt.xticks(rotation=90)
    plt.ylim(ymin_thick, ymax_thick)  # Set consistent y-axis limits
    plt.legend()
    plt.grid(True, linestyle="--", alpha=0.5)
    
    # Save figure instead of showing
    plt.tight_layout()
    plt.savefig(output_plot_path, dpi=300)
    plt.close()  # Close the figure to free memory
    print(f"Bar chart saved for {subject}: {output_plot_path}")

