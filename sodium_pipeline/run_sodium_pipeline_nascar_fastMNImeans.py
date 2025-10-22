#!/usr/bin/env python3
"""
Compute site-level mean FAST masks in MNI space from subject-specific masks.
"""

import os
import glob
import numpy as np
import nibabel as nib
import sys
import pandas as pd
import subprocess

# -------- Configuration --------
ROOTDIR = "/Volumes/nemosine/SAN/NASCAR"
subjects = ["Subject1", "Subject2", "Subject3", "Subject4"]
sites = ["site1", "site2", "site3"]
FSLDIR = "/usr/local/fsl"

FAST_MASK_SUBFOLDER = "outputs_pve_mni"
OUTDIR = os.path.join(ROOTDIR, "groupstats_acrosssub")
os.makedirs(OUTDIR, exist_ok=True)

groupstats_pve_across_subs = os.path.join(ROOTDIR, "groupstats_pve_across_subs")
os.makedirs(groupstats_pve_across_subs, exist_ok=True)

# PVE types to process
pve_types = ["pve_0_bin", "pve_1_bin", "pve_2_bin", "pve_2_bin_ero"]

# Threshold for creating binary masks from mean (probabilistic) mask
THRESHOLD = 0.5

# -------- Loop over sites --------
for site in sites:
    print(f"\n--- Processing {site} ---")

    # Collect subject-specific mask files per PVE type
    site_masks = {pve: [] for pve in pve_types}

    for subj in subjects:
        subj_mask_dir = os.path.join(ROOTDIR, subj, site, FAST_MASK_SUBFOLDER)
        if not os.path.exists(subj_mask_dir):
            print(f"⚠️ Missing folder: {subj_mask_dir}, skipping subject {subj}")
            continue

        for pve in pve_types:
            # glob for the mask
            mask_file = glob.glob(os.path.join(subj_mask_dir, f"*{pve}.nii.gz"))
            if mask_file:
                site_masks[pve].append(mask_file[0])
            else:
                print(f"⚠️ Missing mask {pve} for {subj} at {subj_mask_dir}")

    # print(f"\nCollected subject masks for {site}:")
    # for pve, files in site_masks.items():
    #     print(f"{pve}: {files}")

    # sys.exit(0)

    # Compute mean mask per PVE type
    for pve, files in site_masks.items():
        if not files:
            print(f"⚠️ No files found for {pve} in {site}, skipping.")
            continue

        print(f"Processing {pve} ({len(files)} subjects)")
        out_file = os.path.join(OUTDIR, f"acrossSubjects_fast_in_MNI_{pve}_{site}.nii.gz")
        # Load all masks and stack
        if not os.path.exists(out_file):
            mask_data_list = []
            for f in files:
                img = nib.load(f)
                mask_data_list.append(img.get_fdata())

            stacked = np.stack(mask_data_list, axis=0)
            mean_mask = np.mean(stacked, axis=0)

            # Threshold to binary
            bin_mask = (mean_mask >= THRESHOLD).astype(np.uint8)

            # Save as NIfTI
            
            mean_img = nib.Nifti1Image(bin_mask, img.affine, img.header)
            nib.save(mean_img, out_file)
            print(f"✅ Saved {out_file}")
        else:
            print("Skipping generation of mean masks")


# Now apply the masks to the site specific sodium files

site_mean_masks = {}  # site -> list of masks
for site in sites:
    masks_for_site = glob.glob(os.path.join(OUTDIR, f"*_{site}.nii.gz"))
    site_mean_masks[site] = masks_for_site
    print(f"{site}: {masks_for_site}")

# Loop over sites
for site in sites:
    # Get all site-specific mean/std/TSC images
    site_files = [
        f for f in glob.glob(os.path.join(OUTDIR, f"{site}_*_acrossSubjects_*.nii.gz"))
        if "_masked_" not in f
    ]

    print(site_files)

    sys.exit(0)

    # Loop over each site mask
    for mask_file in site_mean_masks[site]:
        mask_base = os.path.basename(mask_file).replace(".nii.gz", "")
        
        for img_file in site_files:
            out_file = os.path.join(
                OUTDIR,
                f"{os.path.basename(img_file).replace('.nii.gz','')}_masked_{mask_base}.nii.gz"
            )

            if not os.path.exists(out_file):
                subprocess.run([
                    f"{FSLDIR}/bin/fslmaths",
                    img_file,
                    "-mas", mask_file,
                    out_file
                ], check=True)
                print(f"✅ Masked {img_file} with {mask_base} → {out_file}")
            else:
                print(f"⏭️ Skipping {out_file} (already exists)")

#### MOVING


files = glob.glob(os.path.join(OUTDIR, "*masked_acrossSubjects_fast_in_MNI_pve_*.nii.gz"))

for f in files:
    if not os.path.exists(f):
        print(f"⚠️ Missing source file: {f}")
        continue
    dest = os.path.join(groupstats_pve_across_subs, os.path.basename(f))
    shutil.move(f, dest)
    print(f"📦 Moved {os.path.basename(f)} → {groupstats_pve_across_subs}/")

print(f"✅ Moved {len(files)} files to {groupstats_pve_across_subs}")






