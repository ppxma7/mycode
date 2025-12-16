import os
import shutil
import pandas as pd

# Path setup
#excel_file = "/Users/spmic/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Michael_Sue - General/AFIRM_SASHB_NEXPO/nexpo_plots/t1_groups_n180_medianoutliers.xlsx"
excel_file = "/Volumes/nemosine/SAN/t1mnispace/nocsfver_justnexpo/t1_groups_n180_medianoutliers.xlsx"
source_base = "/Volumes/DRS-GBPerm/other/t1mapping_out"
#dest_base = "/Volumes/nemosine/SAN/t1mnispace/nocsfver_justnexpo"
dest_base = "/Volumes/nemosine/SAN/t1mnispace/nexpo_gmwm"

# Load Excel
df = pd.read_excel(excel_file)

# Standardise column names and extract needed data
df.columns = df.columns.str.lower()  # lowercase
subject_col = "subject"
group_col = "group2" # this is not group2, jsut the name of teh column where each group is labelled!

# Loop over each row
for _, row in df.iterrows():
    subj = str(row[subject_col]).strip()
    group = str(row[group_col]).strip()

    # Define source and destination paths
    #src_file = os.path.join(source_base, subj, f"{subj}_T1_to_MPRAGE_noCSF_MNI.nii.gz")
    src_file = os.path.join(source_base, subj, f"{subj}_T1_to_MPRAGE_WM_MNI.nii.gz")
    print(src_file)

    group_folder = os.path.join(dest_base, f"group{group}")
    #dest_file = os.path.join(group_folder, f"{subj}_T1_to_MPRAGE_noCSF_MNI.nii.gz")
    dest_file = os.path.join(group_folder, f"{subj}_T1_to_MPRAGE_WM_MNI.nii.gz")


    # Make sure group folder exists
    os.makedirs(group_folder, exist_ok=True)

    if not os.path.exists(src_file):
        print(f"❌ File missing for subject {subj}")
        continue

    # 👉 Skip if file already copied
    if os.path.exists(dest_file):
        print(f"⏩ Skipping {subj} (already copied)")
        continue

    try:
        shutil.copyfile(src_file, dest_file)
        print(f"✅ Copied {subj} → group{group}")
    except Exception as e:
        print(f"⚠️ Error copying {subj}: {e}")



