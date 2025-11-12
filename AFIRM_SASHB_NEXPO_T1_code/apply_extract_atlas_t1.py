import os
import numpy as np
import pandas as pd
import nibabel as nib
from nilearn import datasets, image

def apply_atlas_and_extract_stats(sub_dir, subject, output_csv_path):
    """Apply the Harvard-Oxford atlas to a T1 image in MNI space and extract statistics."""
    
    # Load the T1 image
    t1_img_path = os.path.join(sub_dir, f"{subject}_T1_MNI_1mm.nii.gz")

    print(t1_img_path)
    
    if not os.path.exists(t1_img_path):
        print(f"❌ T1 image not found: {t1_img_path}")
        return

    t1_img = nib.load(t1_img_path)
    t1_data = t1_img.get_fdata()
    
    # Fetch the Harvard-Oxford atlas
    atlas = datasets.fetch_atlas_harvard_oxford('cort-maxprob-thr25-1mm')
    atlas_img = atlas.maps
    atlas_data = atlas_img.get_fdata()
    labels = atlas.labels  # Corrected way to get region labels

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

    # Add subject column
    df["Subject"] = subject

    # Add group column
    #df["Group"] = group_name  # Assign "SASHB" to all rows

    # Ensure the output directory exists
    os.makedirs(os.path.dirname(output_csv_path), exist_ok=True)
    
    # Save the extracted stats
    df.to_csv(output_csv_path, index=False)
    print(f"✅ Saved region-wise T1 statistics to {output_csv_path}")

def main(output_dir, subject):
    """Main function to process subject."""
    
    sub_dir = os.path.join(output_dir, subject)
    output_csv_path = os.path.join(output_dir, f"{subject}_T1_stats.csv")

    if not os.path.exists(sub_dir):
        print(f"❌ Output directory missing for {subject}")
        return

    apply_atlas_and_extract_stats(sub_dir, subject, output_csv_path)

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("-o", "--output_dir", required=True, help="Output directory for extracted statistics")
    parser.add_argument("-s", "--subject", required=True, help="Subject ID")
    args = parser.parse_args()
    
    main(args.output_dir, args.subject)
