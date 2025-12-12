import os
import numpy as np
import pandas as pd
import nibabel as nib
import xml.etree.ElementTree as ET

# -----------------------------------------------------------
# User settings
# -----------------------------------------------------------

TBSS_DIR = "/Volumes/kratos/dti_data/tbss_analysis_justnexpo/"             # point to the main TBSS directory
STATS_DIR = os.path.join(TBSS_DIR, "stats")

SIGNIFICANT_MASK = os.path.join(STATS_DIR, "tbss_tfce_corrp_tstat10.nii.gz")

# Where your per-subject skeletonised data live
# Typically TBSS creates all_FA_skeletonised.nii.gz etc.
# If you have MD, RD, AD available, add paths later.
METRIC = "FA"
SKEL_4D = os.path.join(STATS_DIR, "all_FA_skeletonised.nii.gz")

# SUBJECTS = [
#     "AFIRM_1688-002C", "AFIRM_15234-003B", "AFIRM_16469-002A", "AFIRM_16498-002A",
#     "AFIRM_16500-002B", "AFIRM_16501-002b", "AFIRM_16521-001b", "AFIRM_16523_002b",
#     "AFIRM_16602-002B", "AFIRM_16707-002A", "AFIRM_16708-03A", "AFIRM_16797-002C",
#     "AFIRM_16798-002A", "AFIRM_16821-002A", "AFIRM_16835-002A", "AFIRM_16885-002A",
#     "AFIRM_16994-002A", "AFIRM_16999-002B", "AFIRM_17057-002C", "AFIRM_17058-002A",
#     "AFIRM_17059-002a", "AFIRM_17311-002b", "CHAIN_CHN001_V6", "CHAIN_CHN002_V6",
#     "CHAIN_CHN003_V6", "CHAIN_CHN005_V6", "CHAIN_CHN006_V6", "CHAIN_CHN007_V6",
#     "CHAIN_CHN008_V6", "CHAIN_CHN009_V6", "CHAIN_CHN010_V6", "CHAIN_CHN012_V6",
#     "CHAIN_CHN013_V6", "CHAIN_CHN014_V6", "CHAIN_CHN015_V6", "CHAIN_CHN019_V6",
#     "SASHB_16905_004", "SASHB_156862_004"
# ]
SUBJECTS = [
    "NEXPOG1_15999_003", "NEXPOG1_16121_002", "NEXPOG1_16122_002", "NEXPOG1_16154_002",
    "NEXPOG1_16404_004", "NEXPOG1_16466_002", "NEXPOG1_16467_002", "NEXPOG1_16621_002",
    "NEXPOG1_16787_002", "NEXPOG1_16788_002", "NEXPOG1_16793_006", "NEXPOG1_16871_002",
    "NEXPOG1_16910_002", "NEXPOG1_16985_002", "NEXPOG1_16986_002", "NEXPOG1_16987_002",
    "NEXPOG1_17040_002", "NEXPOG1_17041_002", "NEXPOG1_17073_002", "NEXPOG1_17074_002",
    "NEXPOG1_17076_002", "NEXPOG1_17080_002", "NEXPOG1_17083_002", "NEXPOG1_17084_002",
    "NEXPOG1_17086_002", "NEXPOG1_17102_002", "NEXPOG1_17103_002", "NEXPOG1_17105_002",
    "NEXPOG1_17108_002", "NEXPOG1_17111_002", "NEXPOG1_17127_002", "NEXPOG1_17128_002",
    "NEXPOG1_17129_002", "NEXPOG1_17173_002", "NEXPOG1_17178_002", "NEXPOG1_17221_002",
    "NEXPOG1_17324_002", "NEXPOG1_17341_002", "NEXPOG1_17577_002", "NEXPOG1_17580_002",
    "NEXPOG1_17581_002", "NEXPOG1_17589_002", "NEXPOG1_17594_002", "NEXPOG1_17596_002",
    "NEXPOG1_17606_002", "NEXPOG1_17607_002", "NEXPOG1_17610_002", "NEXPOG1_17617_002",
    "NEXPOG2_09376_062", "NEXPOG2_09849", "NEXPOG2_10469", "NEXPOG2_12219_006",
    "NEXPOG2_12305_004", "NEXPOG2_12428_005", "NEXPOG2_12838_004", "NEXPOG2_12869_016",
    "NEXPOG2_12929_004", "NEXPOG2_13673_015", "NEXPOG2_14007_003", "NEXPOG2_16133_002",
    "NEXPOG2_16176_002", "NEXPOG2_16278_002", "NEXPOG2_16280_002", "NEXPOG2_16281_002",
    "NEXPOG2_16283_002", "NEXPOG2_16321_002", "NEXPOG2_16322_002", "NEXPOG2_16388_002",
    "NEXPOG2_16419_002", "NEXPOG2_16437_002", "NEXPOG2_16439_002", "NEXPOG2_16463_002",
    "NEXPOG2_16512_002", "NEXPOG2_16514_002", "NEXPOG2_16528_002", "NEXPOG2_16544",
    "NEXPOG2_16568_002", "NEXPOG2_16618_002", "NEXPOG2_16623_002", "NEXPOG2_16627_002",
    "NEXPOG2_16662_002", "NEXPOG2_16664_002", "NEXPOG2_16693_002", "NEXPOG2_16702_002",
    "NEXPOG2_16725_002", "NEXPOG2_16728_005", "NEXPOG2_16775_002", "NEXPOG2_16866_002",
    "NEXPOG2_16878_002", "NEXPOG2_17171_002", "NEXPOG2_17180_002", "NEXPOG2_17239_002",
    "NEXPOG2_17342_002", "NEXPOG2_17364_002", "NEXPOG3_03143_174", "NEXPOG3_05017_015",
    "NEXPOG3_06398_005", "NEXPOG3_10760_130", "NEXPOG3_12181_004", "NEXPOG3_12185_004",
    "NEXPOG3_12411_004", "NEXPOG3_12422_004", "NEXPOG3_12578_004", "NEXPOG3_12608_004",
    "NEXPOG3_12967_004", "NEXPOG3_12969_004", "NEXPOG3_15721_009", "NEXPOG3_16043_002",
    "NEXPOG3_16044_002", "NEXPOG3_16046_002", "NEXPOG3_16102_002", "NEXPOG3_16103_002",
    "NEXPOG3_16174_002", "NEXPOG3_16277_002", "NEXPOG3_16282_002", "NEXPOG3_16296_002",
    "NEXPOG3_16297_002", "NEXPOG3_16298_002", "NEXPOG3_16299_002", "NEXPOG3_16301_002",
    "NEXPOG3_16303_002", "NEXPOG3_16389_002", "NEXPOG3_16390_002", "NEXPOG3_16418_002",
    "NEXPOG3_16438_002", "NEXPOG3_16462_002", "NEXPOG3_16464_002", "NEXPOG3_16465_002",
    "NEXPOG3_16494_002", "NEXPOG3_16511_002", "NEXPOG3_16513_002", "NEXPOG3_16542_002",
    "NEXPOG3_16570_002", "NEXPOG3_16615_002", "NEXPOG3_16661_002", "NEXPOG3_16663_002",
    "NEXPOG3_16701_002", "NEXPOG3_16791_002", "NEXPOG3_16874_002", "NEXPOG3_17072_002",
    "NEXPOG3_17075_002", "NEXPOG3_17394_002", "NEXPOG4_14342_003", "NEXPOG4_15951_002",
    "NEXPOG4_15955_002", "NEXPOG4_16014_002", "NEXPOG4_16058_002", "NEXPOG4_16101_002",
    "NEXPOG4_16175_002", "NEXPOG4_16231_003", "NEXPOG4_16302_002", "NEXPOG4_16377_002",
    "NEXPOG4_16430_002", "NEXPOG4_16543_002", "NEXPOG4_16569_002", "NEXPOG4_16613_002",
    "NEXPOG4_16699_002", "NEXPOG4_16726_002", "NEXPOG4_16789_002", "NEXPOG4_16824_002",
    "NEXPOG4_17007_002", "NEXPOG4_17104_002", "NEXPOG4_17176_002", "NEXPOG4_17207_002",
    "NEXPOG4_17208_002", "NEXPOG4_17210_002", "NEXPOG4_17243_002", "NEXPOG4_17275_002",
    "NEXPOG4_17292_002", "NEXPOG4_17293_002", "NEXPOG4_17305_002", "NEXPOG4_17348_002",
    "NEXPOG4_17395_002", "NEXPOG4_17449_002", "NEXPOG4_17453_002", "NEXPOG4_17456_002",
    "NEXPOG4_17491_002", "NEXPOG4_17492_002", "NEXPOG4_17532_002", "NEXPOG4_17698_002",
    "NEXPOG4_17704_002", "NEXPOG4_17706_002", "NEXPOG4_17723_002", "NEXPOG4_17765_002",
    "NEXPOG4_17769_002", "NEXPOG4_17930_002", "NEXPOG4_18031_002", "NEXPOG4_18038_002",
    "NEXPOG4_18076_002", "NEXPOG4_18089", "NEXPOG4_18094_002"
]


OUTPUT_DIR = os.path.join(TBSS_DIR, "roi_output_tstat10")
os.makedirs(OUTPUT_DIR, exist_ok=True)

# JHU atlas provided with FSL
FSLDIR = os.getenv("FSLDIR")
JHU_ATLAS = os.path.join(FSLDIR, "data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz")
JHU_XML = os.path.join(FSLDIR, "data/atlases/JHU-labels.xml")

# -----------------------------------------------------------
# Load atlas and parse label names
# -----------------------------------------------------------

def load_jhu_labels(xml_path):
    tree = ET.parse(xml_path)
    root = tree.getroot()

    labels = {}

    for lab in root.findall(".//label"):
        idx = int(lab.attrib["index"])        # attribute
        name = lab.text.strip()               # label name inside text
        labels[idx] = name

    return labels


print("Loading JHU atlas...")
jhu_img = nib.load(JHU_ATLAS)
jhu_data = jhu_img.get_fdata().astype(int)

labels = load_jhu_labels(JHU_XML)

# -----------------------------------------------------------
# Load TBSS significant cluster mask
# -----------------------------------------------------------

print("Loading significant TBSS mask:", SIGNIFICANT_MASK)
sig_img = nib.load(SIGNIFICANT_MASK)
sig_data = sig_img.get_fdata()

if sig_data.shape != jhu_data.shape:
    raise ValueError("JHU atlas and TBSS mask do not have the same shape. "
                     "Resample atlas using FSL flirt or nilearn first.")

# Mask atlas by significant voxels above 0.95
sig_mask = sig_data > 0.95
atlas_masked = np.where(sig_mask, jhu_data, 0)

roi_indices = np.unique(atlas_masked)
roi_indices = roi_indices[roi_indices != 0]

print(f"Found {len(roi_indices)} atlas labels inside the TBSS cluster mask.")

# -----------------------------------------------------------
# Load skeletonised 4D metric data
# -----------------------------------------------------------

print("Loading skeletonised data:", SKEL_4D)
skel_img = nib.load(SKEL_4D)
skel_data = skel_img.get_fdata()   # shape: X Y Z subjects

if skel_data.ndim != 4:
    raise ValueError("Skeletonised input must be 4D: (x,y,z,subjects)")

# Check number of subjects
n_subj = skel_data.shape[3]
if n_subj != len(SUBJECTS):
    print(f"Warning: 4D skeleton file has {n_subj} volumes, "
          f"but subject list has {len(SUBJECTS)} entries.")

# -----------------------------------------------------------
# Extract ROI statistics
# -----------------------------------------------------------

combined_rows = []

for subj_index, subj_id in enumerate(SUBJECTS):
    print(f"Processing {subj_id}...")

    subj_metric = skel_data[:, :, :, subj_index]

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
