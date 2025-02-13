import pandas as pd
import numpy as np
from nilearn import datasets
import os

# Root directory where all nested CSVs are located
root_folder_path = '/Users/spmic/data/pain_redo/'

# Fetch the Harvard-Oxford atlas
atlas_data = datasets.fetch_atlas_harvard_oxford('cort-maxprob-thr25-1mm')
atlas_img = atlas_data.maps  # This is a Nifti1Image object
labels = atlas_data.labels

# Function to get the brain region from coordinates
def get_region_from_coordinates(x, y, z):
    affine = atlas_img.affine
    voxel_coords = np.linalg.inv(affine).dot([x, y, z, 1])[:-1].astype(int)  # Convert MNI coordinates to voxel indices

    if all(0 <= index < atlas_img.shape[i] for i, index in enumerate(voxel_coords)):
        region_index = atlas_img.get_fdata()[tuple(voxel_coords)]
        if region_index > 0:
            return labels[int(region_index)]
    return 'Unknown region'

# Recursively find all CSV files in nested folders
for subdir, _, files in os.walk(root_folder_path):
    for file in files:
        if file.endswith('.csv'):
            file_path = os.path.join(subdir, file)
            print(f"Processing: {file_path}")

            # Load the CSV file
            df = pd.read_csv(file_path)

            # Ensure required columns exist before processing
            if {'mm1', 'mm2', 'mm3'}.issubset(df.columns):
                df['Region'] = df.apply(lambda row: get_region_from_coordinates(row['mm1'], row['mm2'], row['mm3']), axis=1)

                # Remove rows with 'Unknown region'
                df = df[df['Region'] != 'Unknown region']

                new_file_path = file_path.replace(".csv", "_atlas.csv")
                df.to_csv(new_file_path, index=False)

                print(f"Updated and saved: {file_path}")

            else:
                print(f"Skipping {file_path}: Missing mm1, mm2, or mm3 columns")
