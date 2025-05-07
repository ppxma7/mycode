import os
import pandas as pd

# Define project folders and file paths
root_dir = "/Users/spmic/data"
out_dir = "/Users/spmic/data/san"

# hemisphere = "l"
# sashb_file = os.path.join(root_dir, "SASHB", f"freesurfer_stats_{hemisphere}_SASHB.csv")
# afirm_file = os.path.join(root_dir, "AFIRM", f"freesurfer_stats_{hemisphere}_AFIRM.csv")
# nexpo_file = os.path.join(root_dir, "NEXPO", f"freesurfer_stats_{hemisphere}_NEXPO.csv")
# combined_csv_path = os.path.join(out_dir, f"freesurfer_stats_{hemisphere}_combined.csv")

hemisphere = "R"
sashb_file = os.path.join(root_dir, "SASHB", f"t1_stats_destrieux_SASHB_{hemisphere}.csv")
afirm_file = os.path.join(root_dir, "AFIRM", f"t1_stats_destrieux_AFIRM_{hemisphere}.csv")
nexpo_file = os.path.join(root_dir, "NEXPO", f"t1_stats_destrieux_NEXPO_{hemisphere}.csv")
combined_csv_path = os.path.join(out_dir, f"t1_stats_destrieux_combined_{hemisphere}.csv")

# Load both CSV files
df_sashb = pd.read_csv(sashb_file)
df_afirm = pd.read_csv(afirm_file)
df_nexpo = pd.read_csv(nexpo_file)

# Ensure both files have the same column structure
if list(df_sashb.columns) != list(df_afirm.columns):
    print("Warning: Column headers do not match exactly. Fixing misalignment...")
    df_afirm.columns = df_sashb.columns = df_nexpo.columns  # Force column names to match

# Combine the DataFrames correctly
df_combined = pd.concat([df_sashb, df_afirm, df_nexpo], ignore_index=True)

# Drop any fully NaN columns (in case of header mismatches)
df_combined = df_combined.dropna(axis=1, how='all')

# Save the properly merged CSV
df_combined.to_csv(combined_csv_path, index=False)

print(f"Properly merged CSV saved: {combined_csv_path}")
