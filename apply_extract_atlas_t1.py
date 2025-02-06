import os
import numpy as np
import pandas as pd
import nibabel as nib
from nilearn import datasets, image

def apply_atlas_and_extract_stats(t1_mni_path, output_csv):
    """Apply the Harvard-Oxford atlas to a T1 image in MNI space and extract statistics."""
    
    # Load the T1 image
    t1_img = nib.load(t1_mni_path)
    t1_data = t1_img.get_fdata()
    
    # Fetch the Harvard-Oxford atlas
    atlas_data = datasets.fetch_atlas_harvard_oxford('cort-maxprob-thr25-1mm')
    atlas_img = nib.load(atlas_data.maps)
    atlas_data = atlas_img.get_fdata()
    labels = atlas_data.labels
    
    results = []
    
    for i, region in enumerate(labels):
        if i == 0:
            continue  # Skip background
        
        mask = atlas_data == i
        region_values = t1_data[mask]
        
        if region_values.size > 0:
            mean_val = np.mean(region_values)
            std_val = np.std(region_values)
            median_val = np.median(region_values)
            min_val = np.min(region_values)
            max_val = np.max(region_values)
            voxel_count = region_values.size
            
            results.append([region, voxel_count, mean_val, std_val, median_val, min_val, max_val])
    
    df = pd.DataFrame(results, columns=["Region", "Voxels", "Mean", "Std_dev", "Median", "Min", "Max"])
    df.to_csv(output_csv, index=False)
    print(f"✅ Saved region-wise T1 statistics to {output_csv}")

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--t1_mni", required=True, help="Path to the T1 image in MNI space")
    parser.add_argument("--output_csv", required=True, help="Output CSV file path")
    args = parser.parse_args()
    
    apply_atlas_and_extract_stats(args.t1_mni, args.output_csv)
