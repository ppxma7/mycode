import os
import pandas as pd

# Define project folders and file paths
root_dir = "/Users/spmic/data"
sashb_file = os.path.join(root_dir, "SASHB", "freesurfer_stats_sashb.csv")
afirm_file = os.path.join(root_dir, "AFIRM", "freesurfer_stats_afirm.csv")

# Load both CSV files
df_sashb = pd.read_csv(sashb_file)
df_afirm = pd.read_csv(afirm_file)

# Ensure both files have the same column structure
if list(df_sashb.columns) != list(df_afirm.columns):
    print("Warning: Column headers do not match exactly. Fixing misalignment...")
    df_afirm.columns = df_sashb.columns  # Force column names to match

# Combine the DataFrames correctly
df_combined = pd.concat([df_sashb, df_afirm], ignore_index=True)

# Drop any fully NaN columns (in case of header mismatches)
df_combined = df_combined.dropna(axis=1, how='all')

# Save the properly merged CSV
combined_csv_path = os.path.join(root_dir, "freesurfer_stats_combined.csv")
df_combined.to_csv(combined_csv_path, index=False)

print(f"Properly merged CSV saved: {combined_csv_path}")
