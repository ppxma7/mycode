import os
import glob
import nibabel as nib
import numpy as np
import pandas as pd
import xml.etree.ElementTree as ET

FSLDIR = "/usr/local/fsl"

def load_atlas_labels(xml_file):
    tree = ET.parse(xml_file)
    root = tree.getroot()
    labels = {}
    for label in root.findall(".//label"):
        idx = int(label.get("index"))
        name = label.text
        labels[idx] = name
    return labels

def strip_ext(fname):
    if fname.endswith(".nii.gz"):
        return fname[:-7]  # strip ".nii.gz"
    else:
        return os.path.splitext(fname)[0]


def roi_table(sodium_file, atlas_file, out_csv, max_roi=47):
    # Load sodium image and atlas
    sodium_img = nib.load(sodium_file)
    atlas_img = nib.load(atlas_file)

    sodium_data = sodium_img.get_fdata()
    atlas_data = atlas_img.get_fdata().astype(int)

    # Get unique ROI labels (limit to Harvard-Oxford range)
    roi_labels = np.unique(atlas_data)
    roi_labels = roi_labels[(roi_labels >= 0) & (roi_labels <= max_roi)]

    # Load ROI names
    xml_file = os.path.join(FSLDIR, "data/atlases/HarvardOxford-Cortical.xml")
    label_dict = load_atlas_labels(xml_file)

    results = []
    for roi in roi_labels:
        mask = atlas_data == roi
        values = sodium_data[mask]

        if values.size > 0:
            mean_val = np.mean(values)
            std_val = np.std(values)
            median_val = np.median(values)
            roi_name = label_dict.get(roi, f"ROI_{roi}")
            results.append([roi, roi_name, mean_val, std_val, median_val])

    df = pd.DataFrame(results, columns=["ROI", "Name", "Mean", "StdDev", "Median"])
    df.to_csv(out_csv, index=False)
    print(f"✅ ROI stats saved to {out_csv}")


# --- Paths ---
subject = "Subject1"   # <-- replace or parse dynamically
base_dir = "/Volumes/nemosine/SAN/SASHB/inputs/NASCAR"
outputs_mni = os.path.join(base_dir, subject, "site2", "outputs_mni")
outputs_native = os.path.join(base_dir, subject, "site2", "outputs")

atlas_mni = os.path.join(FSLDIR, "data/atlases/HarvardOxford/HarvardOxford-cort-maxprob-thr0-1mm.nii.gz")
atlas_native = os.path.join(outputs_native, f"{subject}_atlas_in_sodium.nii.gz")

# --- Process MNI-space sodiums ---
mni_sodiums = glob.glob(os.path.join(outputs_mni, "*MNI.nii.gz"))
for f in mni_sodiums:
    out_csv = f"{strip_ext(f)}_ROIstats.csv"
    if os.path.exists(out_csv):
        print('skipping')
    else:
        roi_table(f, atlas_mni, out_csv)

# --- Process native sodiums ---
native_sodiums = [
    os.path.join(outputs_native, "seiffert_TSC_2375.nii.gz"),
    os.path.join(outputs_native, "seiffert_2375.nii.gz"),
    os.path.join(outputs_native, "radial_TSC.nii"),
    os.path.join(outputs_native, "radial.nii"),
    os.path.join(outputs_native, "floret_TSC.nii"),
    os.path.join(outputs_native, "floret.nii")
]

for f in native_sodiums:
    if os.path.exists(f):
        out_csv = f"{strip_ext(f)}_ROIstats.csv"
        if os.path.exists(out_csv):
            print("skipping")
        else:
            roi_table(f, atlas_native, out_csv)
    else:
        print(f"⚠️ Missing sodium file: {f}")
