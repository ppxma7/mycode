import pandas as pd
import numpy as np
from nilearn import datasets
import nibabel as nib

# Load the updated Excel file with the full path
updated_file_path = '/Users/spmic/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Zespri- fMRI - General/analysis/brand/brandstats/combined_data_brand.xlsx'
all_data = pd.read_excel(updated_file_path)

# Fetch the Harvard-Oxford atlas
atlas_data = datasets.fetch_atlas_harvard_oxford('cort-maxprob-thr25-1mm')
atlas_img = atlas_data.maps  # This is a Nifti1Image object
labels = atlas_data.labels

# Function to get the brain region from coordinates
def get_region_from_coordinates(x, y, z):
    # Use the already loaded atlas image
    atlas_nifti = atlas_img  # No need to load it again

    # Create an affine transformation from the atlas
    affine = atlas_nifti.affine

    # Convert MNI coordinates to voxel indices
    voxel_coords = np.linalg.inv(affine).dot([x, y, z, 1])[:-1].astype(int)  # Remove the last element (homogeneous coordinate)

    # Check if the indices are within the bounds of the atlas image
    if all(0 <= index < atlas_nifti.shape[i] for i, index in enumerate(voxel_coords)):
        # Get the region index at these voxel indices
        region_index = atlas_nifti.get_fdata()[tuple(voxel_coords)]
        if region_index > 0:
            return labels[int(region_index)]
    return 'Unknown region'

# Apply the function to each row of the DataFrame
all_data['Region'] = all_data.apply(lambda row: get_region_from_coordinates(row['mm1'], row['mm2'], row['mm3']), axis=1)

# Remove rows where the region is 'Unknown region'
#all_data = all_data[all_data['Region'] != 'Unknown region']

# Save the updated DataFrame back to Excel
output_file_with_regions = '/Users/spmic/Library/CloudStorage/OneDrive-SharedLibraries-TheUniversityofNottingham/Zespri- fMRI - General/analysis/brand/brandstats/combined_data_brand_regions.xlsx'
all_data.to_excel(output_file_with_regions, index=False)

# Display the first few rows of the updated DataFrame
print(all_data.head())