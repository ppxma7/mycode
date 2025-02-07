import os
import numpy as np
import pandas as pd
import nibabel as nib
from nilearn import datasets, image
import matplotlib.pyplot as plt
import sys

# Define root directory where all subject FreeSurfer stats files are stored
group_name = "AFIRM"
root_dir = os.path.join("/Users/spmic/data/",group_name,"t1mapping_out")
out_dir = os.path.join("/Users/spmic/data/",group_name)
subjects = ["16469-002A", "16500-002B", "16501-002b", "16521-001b3", "16523_002b"]  # Add more subjects here
#subjects = ["16905_004", "16905_005", "17880001", "17880002"]

hemisphere = "L"  # Change to "R" for right hemisphere analysis


# Initialize empty list to store DataFrames
all_data = []
#Apply the Harvard-Oxford atlas to a T1 image in MNI space and extract statistics.
# Fetch the Harvard-Oxford atlas
print("loading atlas...")
#atlas = datasets.fetch_atlas_harvard_oxford('cort-maxprob-thr25-1mm')
# Fetch the Destrieux 2009 atlas
atlas = datasets.fetch_atlas_destrieux_2009()

if isinstance(atlas.maps, str):  
    atlas_img = nib.load(atlas.maps)  # Load the NIfTI file if it's a path
    whichAtlas = "destrieux"
else:
    atlas_img = atlas.maps  # It's already a NIfTI image
    whichAtlas = "harvard"

print(whichAtlas)

# Extract numerical data
#atlas_data = atlas_img.get_fdata()
#atlas_img = atlas.maps

atlas_data = atlas_img.get_fdata()
labels = atlas.labels  # Corrected way to get region labels

# Extract labels for ONE hemisphere only
labels_L = labels[labels["name"].str.startswith("L ")]  # Left hemisphere
labels_R = labels[labels["name"].str.startswith("R ")]  # Right hemisphere


#print("Labels Example:", labels[:10])  # Print first 10 labels
#print("Unique Atlas Values:", np.unique(atlas_data))
#print("Labels Type:", type(labels))
#print(labels.columns)
#print(labels.head)

#sys.exit()
# Loop through subjects
for subject in subjects:

    print(f"running {subject} now...")

    output_csv_path = os.path.join(root_dir, f"{subject}_T1_stats_{whichAtlas}_{hemisphere}.csv")
    
    # Load the T1 image
    t1_img_path = os.path.join(root_dir, subject, f"{subject}_T1_MNI_1mm.nii.gz")

    print(t1_img_path)

    if not os.path.exists(t1_img_path):
        print(f"❌ T1 image not found: {t1_img_path}")

    t1_img = nib.load(t1_img_path)
    t1_data = t1_img.get_fdata()

    #print(atlas_data.shape)
    #print(t1_data.shape)
    #print(np.unique(atlas_data))

    if atlas_data.shape != t1_data.shape:
        # Need to resample the dextriuex atlas to match T1 image
        print(f"⚠️ Resampling atlas to match T1 image for {subject}...")
        atlas_img = image.resample_to_img(atlas_img, t1_img, interpolation='nearest')
        atlas_data = atlas_img.get_fdata()
        #print(atlas_data.shape)
        #print(t1_img.shape)
    
    #print("Exiting")
    #sys.exit()

    results = []

    #for i, region in enumerate(labels): # this is for HARVARD
    for i in np.unique(atlas_data): # this is for dextrieux
        if i == 0:
            continue  # Skip background
        #region = labels[int(i)]

        if isinstance(atlas.maps, str):  
            region = labels.loc[i, "name"]

        # Select Left or Right hemisphere
        if hemisphere == "L" and int(i) not in labels_L.index:
            continue  # Skip Right hemisphere regions
        if hemisphere == "R" and int(i) not in labels_R.index:
            continue  # Skip Left hemisphere regions
        
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

            #print(mean_val)

    df = pd.DataFrame(results, columns=["Region", "Voxels", "Mean", "Std_dev", "Median", "Min", "Max"])

    # Add subject column
    df["Subject"] = subject

    # Add group column
    df["Group"] = group_name  # Assign "GROUP" to all rows

    # Append to the list
    all_data.append(df)

    # Ensure the output directory exists
    os.makedirs(os.path.dirname(output_csv_path), exist_ok=True)

    # Save the extracted stats
    df.to_csv(output_csv_path, index=False)
    


# Combine all subjects into one DataFrame
df_all = pd.concat(all_data, ignore_index=True)

# Save table to show to user
output_csv_path = os.path.join(out_dir, f"t1_stats_{whichAtlas}_{group_name}_{hemisphere}.csv")
df_all.to_csv(output_csv_path, index=False)
#print(f"Data saved to {output_csv_path}")
print(f"✅ Saved region-wise T1 statistics to {output_csv_path}")
