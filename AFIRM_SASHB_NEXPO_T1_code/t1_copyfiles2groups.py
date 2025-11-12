import os
import shutil
import pandas as pd

# Path setup
excel_file = "/Users/spmic/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/nexpo_plots/t1_groups_n180_medianoutliers.xlsx"
source_base = "/Users/spmic/data/NEXPO/t1mnispace"
dest_base = "/Users/spmic/data/NEXPO/t1mnispace"

# Load Excel
df = pd.read_excel(excel_file)

# Standardise column names and extract needed data
df.columns = df.columns.str.lower()  # lowercase
subject_col = "subject"
group_col = "group2"

# Loop over each row
for _, row in df.iterrows():
    subj = str(row[subject_col]).strip()
    group = str(row[group_col]).strip()

    # Define source and destination paths
    src_file = os.path.join(source_base, f"{subj}_T1_to_MNI_linear_1mm.nii.gz")
    group_folder = os.path.join(dest_base, f"group{group}")
    dest_file = os.path.join(group_folder, f"{subj}_T1_to_MNI_linear_1mm.nii.gz")

    # Make sure group folder exists
    os.makedirs(group_folder, exist_ok=True)

    if not os.path.exists(src_file):
        print(f"❌ File missing for subject {subj}")
        continue

    try:
        shutil.copyfile(src_file, dest_file)
        print(f"✅ Copied {subj} → group{group}")
    except Exception as e:
        print(f"⚠️ Error copying {subj}: {e}")
