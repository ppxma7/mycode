import os
import pandas as pd
import nibabel as nib
import numpy as np
import subprocess


# Set paths
data_dir = "/Volumes/r15/DRS-GBPerm/other/t1mapping_out"
group_file = os.path.join(data_dir, "t1_groups_n196.xlsx")
output_dir = os.path.join(data_dir, "group_averages_python")
os.makedirs(output_dir, exist_ok=True)

# Load subject-to-group mapping
df = pd.read_excel(group_file)
#df = df.iloc[115:181]
#df = df.head(50) # just look at 50 subjects first

df["Subject"] = df["Subject"].astype(str).str.strip()
df["Group2"] = df["Group2"].astype(int)

# Dictionary to hold images per group
group_images = {1: [], 2: [], 3: [], 4: []}
template_img = None  # To hold header/affine info for saving

# Load each subject's T1 map
for _, row in df.iterrows():
    subj = row["Subject"]
    group = row["Group2"]
    t1_path = os.path.join(data_dir, subj, f"{subj}_T1_to_MNI_linear_1mm.nii.gz")

    if os.path.exists(t1_path):
        #print(f"Found {t1_path} ...")
        img = nib.load(t1_path)
        data = img.get_fdata()
        group_images[group].append(data)

        if template_img is None:
            template_img = img  # Use first image as reference for affine/header
    else:
        print(f"⚠️ Missing: {t1_path}")


mean_paths = {}
std_paths = {}
median_paths = {}
iqr_paths = {}
cov_paths = {}


# Compute mean/std for each group
for group, imgs in group_images.items():
    if group != 1:
        continue


    if not imgs:
        print(f"❌ No data for group {group}")
        continue

    stack = np.stack(imgs, axis=-1)  # Shape: (X, Y, Z, N)
    mean_img = np.mean(stack, axis=-1)
    # Threshold mean map: set values > 3000 to 0
    #mean_img[mean_img > 3000] = 0

    std_img = np.std(stack, axis=-1)

    # Save output
    mean_nii = nib.Nifti1Image(mean_img, template_img.affine, template_img.header)
    std_nii = nib.Nifti1Image(std_img, template_img.affine, template_img.header)

    mean_path = os.path.join(output_dir, f"group{group}_mean.nii.gz")
    std_path = os.path.join(output_dir, f"group{group}_std.nii.gz")

    nib.save(mean_nii, mean_path)
    nib.save(std_nii, std_path)

    print(f"✅ Saved: {mean_path}")
    print(f"✅ Saved: {std_path}")

    # Inside your group loop:
    median_img = np.median(stack, axis=-1)
    q75 = np.percentile(stack, 75, axis=-1)
    q25 = np.percentile(stack, 25, axis=-1)
    iqr_img = q75 - q25
    cov_img = std_img / (mean_img + 1e-6)  # avoid division by zero

    # Save these as nifti images
    median_path = os.path.join(output_dir, f"group{group}_median.nii.gz")
    iqr_path = os.path.join(output_dir, f"group{group}_iqr.nii.gz")
    cov_path = os.path.join(output_dir, f"group{group}_cov.nii.gz")

    nib.save(nib.Nifti1Image(median_img, template_img.affine, template_img.header), median_path)
    nib.save(nib.Nifti1Image(iqr_img, template_img.affine, template_img.header), iqr_path)
    nib.save(nib.Nifti1Image(cov_img, template_img.affine, template_img.header), cov_path)

    print(f"✅ Saved median: {median_path}")
    print(f"✅ Saved IQR: {iqr_path}")
    print(f"✅ Saved CoV: {cov_path}")

    # Collect for plotting later
    # mean_paths[group] = mean_path
    # std_paths[group] = std_path
    # median_paths[group] = median_path
    # iqr_paths[group] = iqr_path
    # cov_paths[group] = cov_path


    # # Run FSL BET on the mean image
    # bet_output = os.path.join(output_dir, f"group{group}_mean_brain")
    # subprocess.run([
    #     "bet",
    #     mean_path,       # input image file path
    #     bet_output,      # output prefix (BET adds suffixes)
    #     "-R"
    # ], check=True)

    # brain_mask = bet_output + "_mask.nii.gz"
    # print(f"✅ BET brain mask saved: {brain_mask}")
