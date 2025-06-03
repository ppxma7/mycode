import os
import numpy as np
import pandas as pd
import nibabel as nib
from nilearn import datasets, image
import matplotlib.pyplot as plt
import sys

# Define root directory where all subject FreeSurfer stats files are stored
group_name = "NEXPO"
#root_dir = os.path.join("/Users/spmic/data/",group_name,"t1mapping_out")
#out_dir = os.path.join("/Users/spmic/data/",group_name)
root_dir = "/Volumes/DRS-GBPerm/other/t1mapping_out"
out_dir = "/Volumes/DRS-GBPerm/other"


#subjects = ["16469-002A", "16500-002B", "16501-002b", "16521-001b3", "16523_002b", "16602-002B", "16707-002A", "16708-03A"]  # Add more subjects here
#subjects = ["16905_004", "16905_005", "17880001", "17880002"]
subjects = [
     "03143_174", "05017_014", "06398_005", "09376_062", "09849", "10469", "10760_130", "12162_005",
     "12181_004", "12185_004", "12219_006", "12294", "12305_004", "12411_004", "12422_004", "12428_005",
     "12487_003", "12578_004", "12608_004", "12838_004", "12869_016", "12929_004", "12967_004", "12969_004",
     "13006_004", "13673_015", "13676", "14007_003", "14342_003", "15721_009", "15951_002", "15955_002",
     "15999_003", "16014_002", "16043_002", "16044_002", "16046_002", "16058_002", "16101_002", "16102_002",
     "16103_002", "16121_002", "16122_002", "16133_002", "16154_002", "16174_002", "16175_002", "16176_002",
     "16231_003", "16277_002", "16278_002", "16279", "16280_002", "16281_002", "16282_002", "16283_002",
     "16296_002", "16297_002", "16298_002", "16299_002", "16301_002", "16302_002", "16303_002", "16321_002",
     "16322_002", "16377_002", "16388_002", "16389_002", "16390_002", "16404_004", "16418_002", "16419_002",
     "16430_002", "16437_002", "16438_002", "16439_002", "16462_002", "16463_002", "16464_002", "16465_002",
     "16466_002", "16467_002", "16494_002", "16511_002", "16512_002", "16513_002", "16514_002", "16517",
     "16528_002", "16542_002", "16543_002", "16544", "16568_002", "16569_002", "16570_002", "16613_002",
     "16615_002", "16618_002", "16621_002", "16623_002", "16627_002", "16661_002", "16662_002", "16663_002",
     "16664_002", "16693_002", "16699_002", "16701_002", "16702_002", "16725_002", "16726_002", "16728_005",
     "16775_002", "16787_002", "16788_002", "16789_002", "16791_002", "16793_006", "16824_002", "16866_002",
     "16871_002", "16874_002", "16878_002", "16910_002", "16911", "16985_002", "16986_002", "16987_002",
     "17007_002", "17038_002", "17040_002", "17041_002", "17072_002", "17073_002", "17074_002", "17075_002",
     "17076_002", "17080_002", "17083_002", "17084_002", "17086_002", "17102_002", "17103_002", "17104_002",
     "17105_002", "17108_002", "17111_002", "17127_002", "17128_002", "17129_002", "17171_002", "17173_002",
     "17176_002", "17178_002", "17180_002", "17207_003", "17208_002", "17210_002", "17221_002", "17239_002",
     "17243_002", "17275_002", "17293_002", "17305_002", "17324_002", "17341_002", "17342_002",
     "17348_002", "17364_002", "17394_002", "17395_002", "17449_002", "17453_002", "17456_002", "17491_002",
     "17492_002", "17532_002", "17577_002", "17580_002", "17581_002", "17589_002", "17594_002", "17596_002",
     "17606_002", "17607_002", "17610_002", "17617_002", "17698_002", "17704_002", "17706_002", "17723_002",
     "17765_002", "17769_002", "17930_002", "18031_002", "18038_002", "18076_002", "18094_002"
]
print(f"Number of subjects: {len(subjects)}")
# subjects = ["17207_003", "17208_002", "17210_002", "17221_002", "17239_002",
#     "17243_002", "17275_002", "17293_002", "17305_002", "17324_002", "17341_002", "17342_002",
#     "17348_002", "17364_002", "17394_002", "17395_002", "17449_002", "17453_002", "17456_002", "17491_002",
#     "17492_002", "17532_002", "17577_002", "17580_002", "17581_002", "17589_002", "17594_002", "17596_002",
#     "17606_002", "17607_002", "17610_002", "17617_002", "17698_002", "17704_002", "17706_002", "17723_002",
#     "17765_002", "17769_002", "17930_002", "18031_002", "18038_002", "18076_002", "18094_002"]

sys.exit()
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
    #t1_img_path = os.path.join(root_dir, subject, f"{subject}_T1_MNI_1mm.nii.gz")
    # use linear transform instead of FNIRT 
    t1_img_path = os.path.join(root_dir, subject, f"{subject}_T1_to_MNI_linear_1mm.nii.gz")
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
    print(f"✅ Saved subject-wise T1 statistics to {output_csv_path}")


# Combine all subjects into one DataFrame
df_all = pd.concat(all_data, ignore_index=True)

# Save table to show to user
output_csv_path = os.path.join(out_dir, f"t1_stats_{whichAtlas}_{group_name}_{hemisphere}.csv")
df_all.to_csv(output_csv_path, index=False)
#print(f"Data saved to {output_csv_path}")
print(f"✅ Saved region-wise T1 statistics to {output_csv_path}")
