import os
import nibabel as nib
import numpy as np
import pandas as pd
from nilearn import datasets, image

# === USER INPUTS ===
input_dir = "/Volumes/r15/DRS-GBPerm/other/t1_mprage_overlap"
output_dir = "/Volumes/r15/DRS-GBPerm/other/t1_dice_outputs"
os.makedirs(output_dir, exist_ok=True)

# Choose atlas: 'destrieux' or 'harvard_oxford'
atlas_name = 'harvard_oxford'  # change to 'harvard_oxford' if preferred

if atlas_name == 'destrieux':
    atlas = datasets.fetch_atlas_destrieux_2009()
    atlas_img = nib.load(atlas.maps)  # destrieux gives path
    labels = pd.DataFrame(atlas.labels, columns=["index", "name"]).set_index("index")
elif atlas_name == 'harvard_oxford':
    atlas = datasets.fetch_atlas_harvard_oxford('cort-maxprob-thr25-1mm')
    atlas_img = atlas.maps  # harvard_oxford gives image
    labels = pd.DataFrame(enumerate(atlas.labels), columns=["index", "name"]).set_index("index")



atlas_data_orig = atlas_img.get_fdata()

# === Loop through intersection files ===
for filename in os.listdir(input_dir):
    if not filename.endswith("_intersection.nii.gz"):
        continue

    path = os.path.join(input_dir, filename)
    print(f"📍 Processing {filename}...")

    img = nib.load(path)
    data = img.get_fdata()
    affine = img.affine

    # Resample atlas if needed
    if atlas_img.shape != img.shape or not np.allclose(atlas_img.affine, img.affine):
        print("⚠️ Resampling atlas to match intersection image...")
        atlas_img_resampled = image.resample_to_img(atlas_img, img, interpolation="nearest")
        atlas_data = atlas_img_resampled.get_fdata()
    else:
        atlas_data = atlas_data_orig

    # Find voxel indices where intersection > 0
    overlap_indices = np.argwhere(data > 0)

    found_regions = []
    for voxel in overlap_indices:
        try:
            label_index = int(atlas_data[tuple(voxel)])
        except IndexError:
            continue
        if label_index == 0:
            continue
        region = labels.loc[label_index]["name"] if label_index in labels.index else "Unknown"
        found_regions.append((label_index, region))

    # Deduplicate
    unique_regions = pd.DataFrame(found_regions, columns=["LabelIndex", "Region"]).drop_duplicates()

    # Save CSV
    out_csv = os.path.join(output_dir, filename.replace("_intersection.nii.gz", "_regions.csv"))
    unique_regions.to_csv(out_csv, index=False)
    print(f"✅ Saved: {out_csv}")
