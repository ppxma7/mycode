import os
import pandas as pd
import nibabel as nib
import numpy as np
from nilearn import datasets, image

# === USER INPUTS ===
root_dir = "/Users/spmic/data/NEXPO/t1mnispace/pos_tstats"
n_contrasts = 6
atlas = datasets.fetch_atlas_destrieux_2009()
atlas_img = nib.load(atlas.maps)
atlas_data = atlas_img.get_fdata()

print(f"atlas shape: {atlas_data.shape}")
#labels = atlas.labels.set_index("index")  # ensures we can access by label index

labels = atlas.labels
out_dir = root_dir

# === Loop over contrasts ===
for iter in range(1, n_contrasts + 1):
    peak_file = os.path.join(root_dir, f"cluster_peaks_tstat{iter}.txt")
    output_file = os.path.join(out_dir, f"cluster_regions_destrieux_tstat{iter}.csv")

    if not os.path.exists(peak_file):
        print(f"❌ Missing: {peak_file}")
        continue

    print(f"📌 Processing {peak_file}...")

    # Load cluster peaks file: expect header: Cluster, PeakTFCE, X, Y, Z
    #df = pd.read_csv(peak_file, delim_whitespace=True)
    # Skip first row and define column names manually
    df = pd.read_csv(peak_file, sep=r"\s+", skiprows=1, names=["ClusterIndex", "Value", "x", "y", "z"])


    # Standardize column names
    df.columns = [col.strip().lower() for col in df.columns]  # lowercase for safety
    print("Detected columns:", df.columns)

    x_col, y_col, z_col = "x", "y", "z"

    # Resample atlas to match the stats map (if needed)
    stat_map_path = os.path.join(root_dir, f"t1_rand_results_tstat{iter}.nii.gz")
    stat_img = nib.load(stat_map_path)
    if atlas_img.shape != stat_img.shape:
        print(f"⚠️ Resampling Destrieux atlas to match stat map for iter {iter}...")
        atlas_img = image.resample_to_img(atlas_img, stat_img, interpolation="nearest")
        atlas_data = atlas_img.get_fdata()

    # Use affine from stat image to convert MNI mm to voxel coords
    affine = stat_img.affine
    inv_affine = np.linalg.inv(affine)

    region_names = []
    label_indices = []

    for idx, row in df.iterrows():
        #xyz_mm = np.array([row["x"], row["y"], row["z"], 1])
        xyz_mm = np.array([row[x_col], row[y_col], row[z_col], 1])
        voxel_coords = np.round(inv_affine @ xyz_mm).astype(int)[:3]

        try:
            label_index = int(atlas_data[tuple(voxel_coords)])
        except IndexError:
            label_index = 0

        if label_index in labels.index:
            region = labels.loc[label_index]["name"]
        else:
            region = "Unknown"

        region_names.append(region)
        label_indices.append(label_index)

    df["LabelIndex"] = label_indices
    df["Region"] = region_names

    df = df[df["Region"] != "Background"]
    df = df.drop_duplicates(subset=["Region"])

    df.to_csv(output_file, index=False)
    print(f"✅ Saved regions to {output_file}")
