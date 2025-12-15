import os
import numpy as np
import pandas as pd
import nibabel as nib
import xml.etree.ElementTree as ET
import sys

# -----------------------------------------------------------
# User settings
# -----------------------------------------------------------
STATS_DIR = "/Volumes/nemosine/SAN/t1mnispace/nocsfver_justnexpo/"             # point to the main TBSS directory
OUTPUT_DIR = os.path.join(STATS_DIR,"atlasextract/")
os.makedirs(OUTPUT_DIR, exist_ok=True)

SIGNIFICANT_MASK = os.path.join(STATS_DIR, "t1_rand_results_tfce_corrp_tstat11.nii.gz")

# Where your per-subject skeletonised data live
# Typically TBSS creates all_FA_skeletonised.nii.gz etc.
# If you have MD, RD, AD available, add paths later.
METRIC = "T1"
ALL_4D = os.path.join(STATS_DIR, "smoothed/", "all_subjects_4D.nii.gz")


print(f"path is {STATS_DIR}")
print(f"output dir is {OUTPUT_DIR}")
print(f"significant mask is {SIGNIFICANT_MASK}")

# ]
SUBJECTS = [
    "15999_003", "16121_002", "16122_002", "16154_002", "16404_004",
    "16466_002", "16467_002", "16621_002", "16787_002", "16788_002",
    "16793_006", "16871_002", "16910_002", "16911", "16985_002",
    "16986_002", "16987_002", "17040_002", "17041_002", "17073_002",
    "17074_002", "17076_002", "17080_002", "17083_002", "17084_002",
    "17086_002", "17102_002", "17103_002", "17111_002", "17127_002",
    "17128_002", "17129_002", "17173_002", "17178_002", "17221_002",
    "17324_002", "17341_002", "17577_002", "17580_002", "17581_002",
    "17589_002", "17594_002", "17596_002", "17607_002", "17610_002",
    "17617_002", "09376_062", "09849", "10469", "12162_005",
    "12219_006", "12294", "12305_004", "12428_005", "12838_004",
    "12869_016", "12929_004", "13006_004", "13673_015", "13676",
    "14007_003", "16133_002", "16176_002", "16278_002", "16280_002",
    "16281_002", "16283_002", "16321_002", "16322_002", "16388_002",
    "16419_002", "16437_002", "16512_002", "16514_002", "16528_002",
    "16544", "16568_002", "16618_002", "16623_002", "16627_002",
    "16662_002", "16693_002", "16702_002", "16725_002", "16728_005",
    "16775_002", "16866_002", "16878_002", "17180_002", "17342_002",
    "17364_002", "03143_174", "05017_014", "06398_005", "10760_130",
    "12181_004", "12185_004", "12411_004", "12422_004", "12578_004",
    "12608_004", "12969_004", "16043_002", "16046_002", "16102_002",
    "16103_002", "16174_002", "16277_002", "16282_002", "16296_002",
    "16298_002", "16299_002", "16301_002", "16303_002", "16389_002",
    "16390_002", "16418_002", "16438_002", "16462_002", "16464_002",
    "16465_002", "16494_002", "16511_002", "16513_002", "16517",
    "16542_002", "16570_002", "16615_002", "16661_002", "16663_002",
    "16701_002", "16791_002", "16874_002", "17072_002", "17075_002",
    "17394_002", "12487_003", "14342_003", "15951_002", "15955_002",
    "16014_002", "16058_002", "16101_002", "16175_002", "16231_003",
    "16302_002", "16377_002", "16430_002", "16543_002", "16613_002",
    "16699_002", "16726_002", "16789_002", "16824_002", "17007_002",
    "17104_002", "17176_002", "17207_003", "17208_002", "17210_002",
    "17243_002", "17275_002", "17293_002", "17348_002", "17395_002",
    "17449_002", "17453_002", "17456_002", "17491_002", "17492_002",
    "17532_002", "17698_002", "17704_002", "17706_002", "17723_002",
    "17769_002", "17930_002", "18031_002", "18038_002", "18094_002"
]

print(len(SUBJECTS))

#sys.exit(0)


# JHU atlas provided with FSL
FSLDIR = os.getenv("FSLDIR")
HARV_ATLAS = os.path.join(FSLDIR, "data/atlases/HarvardOxford/HarvardOxford-cort-maxprob-thr25-1mm.nii.gz")
HARV_XML = os.path.join(FSLDIR, "data/atlases/HarvardOxford-Cortical.xml")

# -----------------------------------------------------------
# Load atlas and parse label names
# -----------------------------------------------------------

def load_labels(xml_path):
    tree = ET.parse(xml_path)
    root = tree.getroot()

    labels = {}

    for lab in root.findall(".//label"):
        idx = int(lab.attrib["index"])        # attribute
        name = lab.text.strip()               # label name inside text
        labels[idx] = name

    return labels


print("Loading atlas...")
harv_img = nib.load(HARV_ATLAS)
harv_data = harv_img.get_fdata().astype(int)

labels = load_labels(HARV_XML)

# -----------------------------------------------------------
# Load significant cluster mask
# -----------------------------------------------------------

print("Loading significant mask:", SIGNIFICANT_MASK)
sig_img = nib.load(SIGNIFICANT_MASK)
sig_data = sig_img.get_fdata()


# Mask atlas by significant voxels above 0.95
sig_mask = sig_data > 0.95
atlas_masked = np.where(sig_mask, harv_data, 0)

roi_indices = np.unique(atlas_masked)
# this line below will remove label 0 but want to keep for Harvard Oxfrod!
# roi_indices = roi_indices[roi_indices != 0]

print(f"Found {len(roi_indices)} atlas labels inside the cluster mask.")

# -----------------------------------------------------------
# Load 
# -----------------------------------------------------------

print("Loading 4D T1 data:", ALL_4D)
t1_img = nib.load(ALL_4D)
t1_data = t1_img.get_fdata()  # shape: X Y Z subjects

if t1_data.ndim != 4:
    raise ValueError("Input T1 file must be 4D (x,y,z,subjects)")

if sig_data.shape != harv_data.shape or sig_data.shape != t1_data.shape[:3]:
    raise ValueError(
        "Atlas, TFCE mask, and T1 maps are not on the same voxel grid"
    )


# Check number of subjects
n_subj = t1_data.shape[3]
if n_subj != len(SUBJECTS):
    raise ValueError(
        f"4D file has {n_subj} volumes but SUBJECTS has {len(SUBJECTS)} entries"
    )


print(f"Subjects: {len(SUBJECTS)}")
print(f"ROIs in mask: {len(roi_indices)}")
print(f"T1 data shape: {t1_data.shape}")


# -----------------------------------------------------------
# Extract ROI statistics
# -----------------------------------------------------------

combined_rows = []

for subj_index, subj_id in enumerate(SUBJECTS):
    print(f"Processing {subj_id}...")

    subj_metric = t1_data[:, :, :, subj_index]

    rows = []
    for roi in roi_indices:
        mask = atlas_masked == roi
        roi_vals = subj_metric[mask]

        if roi_vals.size == 0:
            continue

        label_name = labels.get(roi, f"ROI_{roi}")
        mean_val = np.mean(roi_vals)

        rows.append([subj_id, METRIC, roi, label_name, mean_val])
        combined_rows.append([subj_id, METRIC, roi, label_name, mean_val])

    df_sub = pd.DataFrame(rows, columns=["Subject", "Metric", "ROI_Index", "ROI_Label", "Mean"])

    df_sub.to_csv(os.path.join(OUTPUT_DIR, f"{subj_id}_ROI_stats.csv"), index=False)

# -----------------------------------------------------------
# Save combined cohort summary
# -----------------------------------------------------------

df_all = pd.DataFrame(combined_rows, 
                      columns=["Subject", "Metric", "ROI_Index", "ROI_Label", "Mean"])

df_all.to_csv(os.path.join(OUTPUT_DIR, "all_subjects_ROI_stats.csv"), index=False)

print("Completed ROI extraction.")
print(f"Outputs saved in {OUTPUT_DIR}")
