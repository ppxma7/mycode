import os
import pandas as pd
import pdb
import re

# Root directory containing the subfolders
root_dir = "/Users/spmic/Library/CloudStorage/OneDrive-TheUniversityofNottingham/stage/nexpo_screenshots/eTIV_groups_doss"

# List of subfolders to check
folders = [
    "Age_overall", "g1_vs_g2", "g1_vs_g3", "g1_vs_g4",
    "g2_vs_g3", "g2_vs_g4", "g3_vs_g4",
    "HL_overall", "HL_vs_Noise",
    "Noise_by_Age_interaction", "Noise_overall"
]

# Filenames to look for
target_filenames = [
    "cacheth30possigcluster__rh_volume.csv",
    "cacheth30possigcluster__rh_thickness.csv",
    "cacheth30possigcluster__lh_volume.csv",
    "cacheth30possigcluster__lh_thickness.csv"
]

for folder in folders:
    folder_path = os.path.join(root_dir, folder)
    csv_paths = [
        os.path.join(folder_path, fname)
        for fname in target_filenames
        if os.path.exists(os.path.join(folder_path, fname))
    ]

    if len(csv_paths) > 1:
        combined_dfs = []
        for path in csv_paths:
            df = pd.read_csv(path)
            #pdb.set_trace()
            filename = os.path.basename(path)
            match = re.search(r"__(.*?)\.csv", filename)
            #print(match.group(1))
            df["source_file"] = match.group(1)  # Extract the part before .csv
            combined_dfs.append(df)

        combined_df = pd.concat(combined_dfs, ignore_index=True)
        output_file = os.path.join(folder_path, "combined_sig_clusters.csv")
        combined_df.to_csv(output_file, index=False)
        print(f"✅ Combined file written to: {output_file}")
    else:
        print(f"⚠️ Skipping '{folder}': less than 2 CSVs found.")
