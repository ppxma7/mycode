import os
import pandas as pd

# Define paths
root_dir = "/Users/spmic/data/NEXPO"
hemisphere = "R"
input_csv = os.path.join(root_dir, f"t1_stats_destrieux_NEXPO_{hemisphere}.csv")
group_mapping_file = os.path.join(root_dir, "t1_groups_n196.xlsx")
output_csv = os.path.join(root_dir, f"t1_stats_destrieux_NEXPO_{hemisphere}_with_groups.csv")

# Read both files, forcing subject IDs to string
df = pd.read_csv(input_csv, dtype={'Subject': str})
group_map = pd.read_excel(group_mapping_file, header=None, names=["Subject", "Group2"], dtype={'Subject': str})

# Strip any whitespace
df["Subject"] = df["Subject"].str.strip()
group_map["Subject"] = group_map["Subject"].str.strip()

# Merge
df = df.merge(group_map, on="Subject", how="left")


# Check for missing group assignments
missing = df[df["Group2"].isna()]
if not missing.empty:
    print("Warning: Some subjects have no group assignment:")
    print(missing["Subject"].unique())

unmatched_subjects = set(df["Subject"].unique()) - set(group_map["Subject"].unique())
print("Subjects in main CSV but not in mapping file:")
print(sorted(unmatched_subjects))


# Save to new CSV file
df.to_csv(output_csv, index=False)

print(f"Saved updated CSV with groups to: {output_csv}")

